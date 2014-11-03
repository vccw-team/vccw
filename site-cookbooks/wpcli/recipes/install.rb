# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

node.set_unless[:wpcli][:dbpassword] = secure_password

execute "mysql-install-wp-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node[:mysql][:server_root_password]}\" < #{node[:mysql][:conf_dir]}/wp-grants.sql"
  action :nothing
end

template File.join(node[:mysql][:conf_dir], '/wp-grants.sql') do
  source "grants.sql.erb"
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
  mode "0600"
  variables(
    :user     => node[:wpcli][:dbuser],
    :password => node[:wpcli][:dbpassword],
    :database => node[:wpcli][:dbname]
  )
  notifies :run, "execute[mysql-install-wp-privileges]", :immediately
end


execute "create wordpress database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node[:mysql][:server_root_password]}\" create #{node[:wpcli][:dbname]}"
  not_if do
    # Make sure gem is detected if it was just installed earlier in this recipe
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", node[:mysql][:server_root_password])
    m.list_dbs.include?(node[:wpcli][:dbname])
  end
  notifies :create, "ruby_block[save node data]", :immediately unless Chef::Config[:solo]
end


bash "wordpress-core-download" do
  user node[:wpcli][:user]
  group node[:wpcli][:group]
  if node[:wpcli][:wp_version] == 'latest' then
      code <<-EOH
WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp core download \\
--path=#{Shellwords.shellescape(node[:wpcli][:wpdir])} \\
--locale=#{Shellwords.shellescape(node[:wpcli][:locale])} \\
--force
      EOH
  elsif node[:wpcli][:wp_version] =~ %r{^http(s)?://.*?\.zip$}
      code <<-EOH
        cd /tmp && wget -O ./download.zip #{Shellwords.shellescape(node[:wpcli][:wp_version])} && unzip -d /var/www/ ./download.zip && rm ./download.zip
      EOH
  else
      code <<-EOH
WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp core download \\
--path=#{Shellwords.shellescape(node[:wpcli][:wpdir])} \\
--locale=#{Shellwords.shellescape(node[:wpcli][:locale])} \\
--version=#{Shellwords.shellescape(node[:wpcli][:wp_version])} \\
--force
      EOH
  end
end

file File.join(node[:wpcli][:wpdir], "wp-config.php") do
  action :delete
  backup false
end

bash "wordpress-core-config" do
  user node[:wpcli][:user]
  group node[:wpcli][:group]
  cwd node[:wpcli][:wpdir]
  code <<-EOH
    WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp core config \\
    --dbhost=#{Shellwords.shellescape(node[:wpcli][:dbhost])} \\
    --dbname=#{Shellwords.shellescape(node[:wpcli][:dbname])} \\
    --dbuser=#{Shellwords.shellescape(node[:wpcli][:dbuser])} \\
    --dbpass=#{Shellwords.shellescape(node[:wpcli][:dbpassword])} \\
    --dbprefix=#{Shellwords.shellescape(node[:wpcli][:dbprefix])} \\
    --locale=#{Shellwords.shellescape(node[:wpcli][:locale])} \\
    --extra-php <<PHP
define( 'WP_HOME', '#{Shellwords.shellescape(node[:wpcli][:url]).sub(/\/$/, '')}' );
define( 'WP_SITEURL', '#{Shellwords.shellescape(node[:wpcli][:url]).sub(/\/$/, '')}' );
define( 'JETPACK_DEV_DEBUG', #{node[:wpcli][:debug_mode]} );
define( 'WP_DEBUG', #{node[:wpcli][:debug_mode]} );
define( 'FORCE_SSL_ADMIN', #{node[:wpcli][:force_ssl_admin]} );
define( 'SAVEQUERIES', #{node[:wpcli][:savequeries]} );
PHP
  EOH
end

if node[:wpcli][:always_reset] == true then
    bash "wordpress-db-reset" do
      user node[:wpcli][:user]
      group node[:wpcli][:group]
      cwd node[:wpcli][:wpdir]
      code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp db reset --yes"
    end
end

bash "wordpress-core-install" do
  user node[:wpcli][:user]
  group node[:wpcli][:group]
  cwd node[:wpcli][:wpdir]
  code <<-EOH
    WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp core install \\
    --url=#{Shellwords.shellescape(node[:wpcli][:url]).sub(/\/$/, '')} \\
    --title=#{Shellwords.shellescape(node[:wpcli][:title])} \\
    --admin_user=#{Shellwords.shellescape(node[:wpcli][:admin_user])} \\
    --admin_password=#{Shellwords.shellescape(node[:wpcli][:admin_password])} \\
    --admin_email=#{Shellwords.shellescape(node[:wpcli][:admin_email])}
  EOH
end


if node[:wpcli][:locale] == 'ja' then
  bash "wordpress-plugin-ja-install" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp plugin activate wp-multibyte-patch"
  end
end

node[:wpcli][:default_plugins].each do |plugin|
  bash "WordPress #{plugin} install" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp plugin install #{Shellwords.shellescape(plugin)} --activate"
  end
end

if node[:wpcli][:default_theme] != '' then
    bash "WordPress #{node[:wpcli][:default_theme]} install" do
      user node[:wpcli][:user]
      group node[:wpcli][:group]
      cwd node[:wpcli][:wpdir]
      code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp theme install #{Shellwords.shellescape(node[:wpcli][:default_theme])}"
    end
    bash "WordPress #{node[:wpcli][:default_theme]} activate" do
      user node[:wpcli][:user]
      group node[:wpcli][:group]
      cwd node[:wpcli][:wpdir]
      code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp theme activate #{File.basename(Shellwords.shellescape(node[:wpcli][:default_theme])).sub(/\..*$/, '')}"
    end
end

if node[:wpcli][:is_multisite] == true then
  bash "Setup multisite" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp core multisite-convert"
  end

  template File.join(node[:wpcli][:wpdir], '/.htaccess') do
    source "multisite.htaccess.erb"
    owner node[:wpcli][:user]
    group node[:wpcli][:group]
    mode "0644"
  end
end

if node[:wpcli][:theme_unit_test] == true then
  remote_file node[:wpcli][:theme_unit_test_data] do
    source node[:wpcli][:theme_unit_test_data_url]
    mode 0644
    action :create
  end

  bash "Import theme unit test data" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp plugin install wordpress-importer --activate"
  end

  bash "Import theme unit test data" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp import --authors=create #{Shellwords.shellescape(node[:wpcli][:theme_unit_test_data])}"
  end
end


node[:wpcli][:options].each do |key, value|
  bash "Setting up WordPress option #{key}" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp option update #{Shellwords.shellescape(key)} #{Shellwords.shellescape(value)}"
  end
end


if node[:wpcli][:rewrite_structure] then
  template File.join(node[:wpcli][:wpdir], '.htaccess') do
    source ".htaccess"
    owner node[:wpcli][:user]
    group node[:wpcli][:group]
    mode "0644"
  end
  bash "Setting up rewrite rules" do
    user node[:wpcli][:user]
    group node[:wpcli][:group]
    cwd node[:wpcli][:wpdir]
    code "WP_CLI_CONFIG_PATH=#{Shellwords.shellescape(node[:wpcli][:config_path])} wp rewrite structure #{Shellwords.shellescape(node[:wpcli][:rewrite_structure])} --hard"
  end
end


remote_file node[:wpcli][:gitignore] do
  source node[:wpcli][:gitignore_url]
  mode 0644
  action :create
end



apache_site "000-default" do
  enable false
end

web_app "wordpress" do
  template "wordpress.conf.erb"
  docroot node[:apache][:docroot_dir]
  server_name node[:fqdn]
end

bash "create-ssl-keys" do
  user "root"
  group "root"
  cwd File.join(node[:apache][:dir], 'ssl')
  code <<-EOH
    openssl genrsa -out server.key 2048
    openssl req -new -key server.key -subj '/C=JP/ST=Wakayama/L=Kushimoto/O=My Corporate/CN=#{node[:fqdn]}' -out server.csr
    openssl x509 -in server.csr -days 365 -req -signkey server.key > server.crt
  EOH
  notifies :restart, "service[apache2]"
end


iptables_rule "wordpress-iptables"
