# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{git subversion zip unzip}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

git node[:wpcli][:dir] do
  repository "git://github.com/wp-cli/builds.git"
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

directory '/home/vagrant/.wp-cli' do
  recursive true
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
end

directory '/home/vagrant/.wp-cli/commands' do
  recursive true
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
end

template '/home/vagrant/.wp-cli/config.yml' do
  source "config.yml"
  owner node[:wpcli][:user]
  group node[:wpcli][:group]
  mode "0644"
end

git 'home/vagrant/.wp-cli/commands/dictator' do
  repository "git://github.com/danielbachhuber/dictator.git"
  user node[:wpcli][:user]
  group node[:wpcli][:group]
  action :sync
end
