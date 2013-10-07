bash "wordpress-core-install" do
  user "vagrant"
  group "vagrant"
  cwd "/var/www/wordpress"
  code <<-EOH
    wp core install \
    --url="#{node['wp-plugins']['url']}" \\
    --title="#{node['wp-plugins']['title']}" \\
    --admin_user="#{node['wp-plugins']['admin_user']}" \\
    --admin_password="#{node['wp-plugins']['admin_password']}" \\
    --admin_email="#{node['wp-plugins']['admin_email']}"
  EOH
end


if node['wordpress']['languages']['lang'] == 'ja'
  bash "wordpress-plugin-ja-install" do
    user "vagrant"
    group "vagrant"
    cwd "/var/www/wordpress"
    code <<-EOH
      wp plugin install wp-multibyte-patch
      wp plugin activate wp-multibyte-patch
    EOH
  end
end

bash "wordpress-plugin-install" do
  user "vagrant"
  group "vagrant"
  cwd "/var/www/wordpress"
  code <<-EOH
    wp plugin install theme-check
    wp plugin install plugin-check
    wp plugin activate theme-check
    wp plugin activate plugin-check
  EOH
end

