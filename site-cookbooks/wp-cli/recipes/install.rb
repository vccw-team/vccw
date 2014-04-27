# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

node.set_unless['wp-cli']['dbpassword'] = secure_password

execute "mysql-install-wp-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
  action :nothing
end

template File.join(node['mysql']['conf_dir'], '/wp-grants.sql') do
  source "grants.sql.erb"
  owner "vagrant"
  group "vagrant"
  mode "0600"
  variables(
    :user     => node['wp-cli']['dbuser'],
    :password => node['wp-cli']['dbpassword'],
    :database => node['wp-cli']['dbname']
  )
  notifies :run, "execute[mysql-install-wp-privileges]", :immediately
end


execute "create wordpress database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['wp-cli']['dbname']}"
  not_if do
    # Make sure gem is detected if it was just installed earlier in this recipe
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['wp-cli']['dbname'])
  end
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end


# save node data after writing the MYSQL root password, so that a failed chef-client run that gets this far doesn't cause an unknown password to get applied to the box without being saved in the node data.
unless Chef::Config[:solo]
  ruby_block "save node data" do
    block do
      node.save
    end
    action :create
  end
end

bash "install zip" do
  user "root"
  group "root"
  code "yum install -y zip unzip"
end

bash "wordpress-core-download" do
  user "vagrant"
  group "vagrant"
  if node['wp-cli']['wp_version'] == 'latest' then
      code <<-EOH
wp core download \\
--path=#{Shellwords.shellescape(node['wp-cli']['wpdir'])} \\
--locale=#{Shellwords.shellescape(node['wp-cli']['locale'])} \\
--force
      EOH
  elsif node['wp-cli']['wp_version'] =~ %r{^http(s)?://.*?\.zip$}
      code <<-EOH
        cd /tmp && wget -O ./download.zip #{Shellwords.shellescape(node['wp-cli']['wp_version'])} && unzip -d /var/www/ ./download.zip && rm ./download.zip
      EOH
  else
      code <<-EOH
wp core download \\
--path=#{Shellwords.shellescape(node['wp-cli']['wpdir'])} \\
--locale=#{Shellwords.shellescape(node['wp-cli']['locale'])} \\
--version=#{Shellwords.shellescape(node['wp-cli']['wp_version'])} \\
--force
      EOH
  end
end

file File.join(node['wp-cli']['wpdir'], "wp-config.php") do
  action :delete
  backup false
end

bash "wordpress-core-config" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-cli']['wpdir']
  code <<-EOH
    wp core config \\
    --dbhost=#{Shellwords.shellescape(node['wp-cli']['dbhost'])} \\
    --dbname=#{Shellwords.shellescape(node['wp-cli']['dbname'])} \\
    --dbuser=#{Shellwords.shellescape(node['wp-cli']['dbuser'])} \\
    --dbpass=#{Shellwords.shellescape(node['wp-cli']['dbpassword'])} \\
    --dbprefix=#{Shellwords.shellescape(node['wp-cli']['dbprefix'])} \\
    --locale=#{Shellwords.shellescape(node['wp-cli']['locale'])} \\
    --extra-php <<PHP
define( 'WP_HOME', '#{Shellwords.shellescape(node['wp-cli']['url']).sub(/\/$/, '')}' );
define( 'WP_SITEURL', '#{Shellwords.shellescape(node['wp-cli']['url']).sub(/\/$/, '')}' );
define( 'JETPACK_DEV_DEBUG', #{node['wp-cli']['debug_mode']} );
define( 'WP_DEBUG', #{node['wp-cli']['debug_mode']} );
define( 'FORCE_SSL_ADMIN', #{node['wp-cli']['force_ssl_admin']} );
define( 'SAVEQUERIES', #{node['wp-cli']['savequeries']} );
PHP
  EOH
end

if node['wp-cli']['always_reset'] == true then
    bash "wordpress-db-reset" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-cli']['wpdir']
      code 'wp db reset --yes'
    end
end

bash "wordpress-core-install" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-cli']['wpdir']
  code <<-EOH
    wp core install \\
    --url=#{Shellwords.shellescape(node['wp-cli']['url']).sub(/\/$/, '')} \\
    --title=#{Shellwords.shellescape(node['wp-cli']['title'])} \\
    --admin_user=#{Shellwords.shellescape(node['wp-cli']['admin_user'])} \\
    --admin_password=#{Shellwords.shellescape(node['wp-cli']['admin_password'])} \\
    --admin_email=#{Shellwords.shellescape(node['wp-cli']['admin_email'])}
  EOH
end


if node['wp-cli']['locale'] == 'ja' then
  bash "wordpress-plugin-ja-install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-cli']['wpdir']
    code 'wp plugin activate wp-multibyte-patch'
  end
end


node['wp-cli']['default_plugins'].each do |plugin|
  bash "WordPress #{plugin} install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-cli']['wpdir']
    code "wp plugin install #{Shellwords.shellescape(plugin)} --activate"
  end
end

if node['wp-cli']['default_theme'] != '' then
    bash "WordPress #{node['wp-cli']['default_theme']} install" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-cli']['wpdir']
      code "wp theme install #{Shellwords.shellescape(node['wp-cli']['default_theme'])} --activate"
    end
end

if node['wp-cli']['is_multisite'] == true then
  bash "Setup multisite" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-cli']['wpdir']
    code "wp core multisite-convert"
  end

  template File.join(node['wp-cli']['wpdir'], '/.htaccess') do
    source "multisite.htaccess.erb"
    owner "vagrant"
    group "vagrant"
    mode "0644"
  end
end

if node['wp-cli']['theme_unit_test'] == true then
  remote_file node['wp-cli']['theme_unit_test_data'] do
    source node['wp-cli']['theme_unit_test_data_url']
    mode 0644
    action :create
  end

  bash "Import theme unit test data" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-cli']['wpdir']
    code "wp plugin install wordpress-importer --activate"
  end

  bash "Import theme unit test data" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-cli']['wpdir']
    code "wp import --authors=create #{Shellwords.shellescape(node['wp-cli']['theme_unit_test_data'])}"
  end
end

remote_file node['wp-cli']['gitignore'] do
  source node['wp-cli']['gitignore_url']
  mode 0644
  action :create
end



apache_site "000-default" do
  enable false
end

web_app "wordpress" do
  template "wordpress.conf.erb"
  docroot node['apache']['docroot_dir']
  server_name node['fqdn']
end

bash "create-ssl-keys" do
  user "root"
  group "root"
  cwd File.join(node['apache']['dir'], 'ssl')
  code <<-EOH
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -subj '/C=JP/ST=Wakayama/L=Kushimoto/O=My Corporate/CN=#{node['fqdn']}' -out server.csr
    openssl x509 -in server.csr -days 365 -req -signkey server.key > server.crt
  EOH
  notifies :restart, "service[apache2]"
end


iptables_rule "wordpress-iptables"

