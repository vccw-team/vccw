# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel giflib-devel gd-devel libmcrypt-devel sqlite-devel libtidy-devel libxslt-devel}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

execute node[:vccw][:phpenv][:install] do
  user "root"
  group "root"
  environment ({
    'PHPENV_ROOT' => node[:vccw][:phpenv][:phpenv_root]
  })
  not_if { ::File.exists?(node[:vccw][:phpenv][:phpenv_root]) }
end

execute node[:vccw][:phpenv][:install] do
  user "root"
  group "root"
  environment ({
    'PHPENV_ROOT' => node[:vccw][:phpenv][:phpenv_root],
    'UPDATE' => 'yes'
  })
  only_if { ::File.exists?(node[:vccw][:phpenv][:phpenv_root]) }
end

template "/etc/profile.d/phpenv.sh" do
  source "phpenv.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  variables(
    :phpenv_root => node[:vccw][:phpenv][:phpenv_root]
  )
  action :create_if_missing
end

directory File.join(node[:vccw][:phpenv][:phpenv_root], "/shims") do
  recursive true
  owner node[:vccw][:user]
  group node[:vccw][:group]
  mode "0755"
  action :create
end

directory File.join(node[:vccw][:phpenv][:phpenv_root], "/versions") do
  recursive true
  owner node[:vccw][:user]
  group node[:vccw][:group]
  mode "0755"
  action :create
end

directory File.join(node[:vccw][:phpenv][:phpenv_root], "/plugins") do
  recursive true
  owner node[:vccw][:user]
  group node[:vccw][:group]
  mode "0755"
  action :create
end

git File.join(node[:vccw][:phpenv][:phpenv_root], "/plugins/php-build") do
  repository "https://github.com/php-build/php-build.git"
  reference  "master"
  user node[:vccw][:user]
  group node[:vccw][:group]
  action :sync
end

file File.join(node[:vccw][:phpenv][:phpenv_root], "/version") do
  owner node[:vccw][:user]
  group node[:vccw][:group]
  mode '0644'
  action :create
end
