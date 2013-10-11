require 'shellwords'

node.set_unless['wp-install']['dbpassword'] = secure_password

execute "mysql-install-wp-privileges" do
  command "/usr/bin/mysql -u root -p\"#{node['mysql']['server_root_password']}\" < #{node['mysql']['conf_dir']}/wp-grants.sql"
  action :nothing
end

template "#{node['mysql']['conf_dir']}/wp-grants.sql" do
  source "grants.sql.erb"
  owner "vagrant"
  group "vagrant"
  mode "0600"
  variables(
    :user     => node['wp-install']['dbuser'],
    :password => node['wp-install']['dbpassword'],
    :database => node['wp-install']['dbname']
  )
  notifies :run, "execute[mysql-install-wp-privileges]", :immediately
end


execute "create wordpress database" do
  command "/usr/bin/mysqladmin -u root -p\"#{node['mysql']['server_root_password']}\" create #{node['wp-install']['dbname']}"
  not_if do
    # Make sure gem is detected if it was just installed earlier in this recipe
    require 'rubygems'
    Gem.clear_paths
    require 'mysql'
    m = Mysql.new("localhost", "root", node['mysql']['server_root_password'])
    m.list_dbs.include?(node['wp-install']['dbname'])
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

bash "wordpress-core-download" do
  user "vagrant"
  group "vagrant"
  if node['wp-install']['wp_version'] == 'latest' then
      code <<-EOH
wp core download \\
--path=#{Shellwords.shellescape(node['wp-install']['wpdir'])} \\
--locale=#{Shellwords.shellescape(node['wp-install']['locale'])} \\
--force
      EOH
  else
      code <<-EOH
wp core download \\
--path=#{Shellwords.shellescape(node['wp-install']['wpdir'])} \\
--locale=#{Shellwords.shellescape(node['wp-install']['locale'])} \\
--version=#{Shellwords.shellescape(node['wp-install']['wp_version'])} \\
--force
      EOH
  end
end

file "#{node['wp-install']['wpdir']}/wp-config.php" do
  action :delete
  backup false
end

bash "wordpress-core-config" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-install']['wpdir']
  code <<-EOH
    wp core config \\
    --dbhost=#{Shellwords.shellescape(node['wp-install']['dbhost'])} \\
    --dbname=#{Shellwords.shellescape(node['wp-install']['dbname'])} \\
    --dbuser=#{Shellwords.shellescape(node['wp-install']['dbuser'])} \\
    --dbpass=#{Shellwords.shellescape(node['wp-install']['dbpassword'])} \\
    --dbprefix=#{Shellwords.shellescape(node['wp-install']['dbprefix'])} \\
    --locale=#{Shellwords.shellescape(node['wp-install']['locale'])} \\
    --extra-php <<PHP
define( 'WP_DEBUG', #{node['wp-install']['debug_mode']} );
define( 'FORCE_SSL_ADMIN', #{node['wp-install']['force_ssl_admin']} );
PHP
  EOH
end

if node['wp-install']['always_reset'] == true then
    bash "wordpress-db-reset" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-install']['wpdir']
      code 'wp db reset --yes'
    end
end

bash "wordpress-core-install" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-install']['wpdir']
  code <<-EOH
    wp core install \\
    --url=#{Shellwords.shellescape(node['wp-install']['url']).sub(/\/$/, '')} \\
    --title=#{Shellwords.shellescape(node['wp-install']['title'])} \\
    --admin_user=#{Shellwords.shellescape(node['wp-install']['admin_user'])} \\
    --admin_password=#{Shellwords.shellescape(node['wp-install']['admin_password'])} \\
    --admin_email=#{Shellwords.shellescape(node['wp-install']['admin_email'])}
  EOH
end


if node['wp-install']['locale'] == 'ja' then
  bash "wordpress-plugin-ja-install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-install']['wpdir']
    code 'wp plugin activate wp-multibyte-patch'
  end
end


node['wp-install']['default_plugins'].each do |plugin|
  bash "WordPress #{plugin} install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-install']['wpdir']
    code <<-EOH
      wp plugin install #{Shellwords.shellescape(plugin)}
      wp plugin activate #{Shellwords.shellescape(plugin)}
    EOH
  end
end

if node['wp-install']['default_theme'] != '' then
    bash "WordPress #{node['wp-install']['default_theme']} install" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-install']['wpdir']
      code "wp theme install #{Shellwords.shellescape(node['wp-install']['default_theme'])} --activate"
    end
end

if node['wp-install']['is_multisite'] == true then
    bash "Setup multisite" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-install']['wpdir']
      code "wp core multisite-convert"
    end
end

if node['wp-install']['theme_unit_test'] == true then
    remote_file node['wp-install']['theme_unit_test_data'] do
      source node['wp-install']['theme_unit_test_data_url']
      mode 0644
      action :create
    end

    bash "Import theme unit test data" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-install']['wpdir']
      code "wp plugin activate wordpress-importer"
    end

    bash "Import theme unit test data" do
      user "vagrant"
      group "vagrant"
      cwd node['wp-install']['wpdir']
      code "wp import --authors=create #{Shellwords.shellescape(node['wp-install']['theme_unit_test_data'])}"
    end
end
