# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

include_recipe "yum::remi"
include_recipe 'php::package'

packages = %w{git subversion zip unzip kernel-devel gcc perl make jq httpd-devel libxml2-devel libcurl-devel libjpeg-turbo-devel libpng-devel giflib-devel gd-devel libmcrypt-devel sqlite-devel libtidy-devel libxslt-devel}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

git node[:wpcli][:dir] do
  repository "https://github.com/wp-cli/builds.git"
  action :sync
end

bin = ::File.join(node[:wpcli][:dir], 'phar', 'wp-cli.phar')
file bin do
  mode '0755'
  action :create
end

link node[:wpcli][:link] do
  to bin
end

directory File.join("/home/", Shellwords.shellescape(node[:wpcli][:user]), "/.wp-cli") do
  recursive true
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
end

directory File.join("/home/", Shellwords.shellescape(node[:wpcli][:user]), "/.wp-cli/commands") do
  recursive true
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
end

template File.join("/home/", Shellwords.shellescape(node[:wpcli][:user]), "/.wp-cli/config.yml") do
  source "config.yml.erb"
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
  mode "0644"
  variables(
    :docroot => File.join(node[:wpcli][:wp_docroot], node[:wpcli][:wp_siteurl])
  )
end

git File.join("/home/", Shellwords.shellescape(node[:wpcli][:user]), "/.wp-cli/commands/dictator") do
  repository "https://github.com/danielbachhuber/dictator.git"
  user node[:wpcli][:user]
  group node[:wpcli][:group]
  action :sync
end
