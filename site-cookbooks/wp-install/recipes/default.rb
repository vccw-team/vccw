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
--path='#{node['wp-install']['wpdir']}' \\
--locale='#{node['wp-install']['locale']}' \\
--force
      EOH
  else
      code <<-EOH
wp core download \\
--path='#{node['wp-install']['wpdir']}' \\
--locale='#{node['wp-install']['locale']}' \\
--version='#{node['wp-install']['wp_version']}' \\
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
    --dbname='#{node['wp-install']['dbname']}' \\
    --dbuser='#{node['wp-install']['dbuser']}' \\
    --dbpass='#{node['wp-install']['dbpassword']}' \\
    --dbprefix='#{node['wp-install']['dbprefix']}' \\
    --locale='#{node['wp-install']['locale']}' \\
    --extra-php <<PHP
define( 'WP_DEBUG', true );
PHP
  EOH
end

bash "wordpress-core-install" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-install']['wpdir']
  code <<-EOH
    wp core install \\
    --url="#{node['wp-install']['url']}" \\
    --title="#{node['wp-install']['title']}" \\
    --admin_user="#{node['wp-install']['admin_user']}" \\
    --admin_password="#{node['wp-install']['admin_password']}" \\
    --admin_email="#{node['wp-install']['admin_email']}"
  EOH
end


if node['wp-install']['locale'] == 'ja'
  bash "wordpress-plugin-ja-install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-install']['wpdir']
    code <<-EOH
      wp plugin activate wp-multibyte-patch
    EOH
  end
end


node['wp-install']['default_plugins'].each do |plugin|
  bash "WordPress #{plugin} install" do
    user "vagrant"
    group "vagrant"
    cwd node['wp-install']['wpdir']
    code <<-EOH
      wp plugin install #{plugin}
      wp plugin activate #{plugin}
    EOH
  end
end

if node['wp-install']['default_theme'] != '' then
bash "WordPress #{node['wp-install']['default_theme']} install" do
  user "vagrant"
  group "vagrant"
  cwd node['wp-install']['wpdir']
  code "wp theme install #{node['wp-install']['default_theme']} --activate"
end
end
