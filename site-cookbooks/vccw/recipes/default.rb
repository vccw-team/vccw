# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{gettext subversion rubygems npm}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

subversion "Checkout WordPress i18n tools." do
  repository    node[:vccw][:i18ntools_repositry]
  revision      "HEAD"
  destination   node[:vccw][:path]
  action        :sync
  user          "root"
  group         "root"
end

execute "echo 'alias makepot.php=\"#{node[:vccw][:makepot]}\"' >> #{node[:vccw]['bash_profile']}" do
  not_if "grep 'alias makepot.php' #{node[:vccw][:bash_profile]}"
end

execute "npm install -g grunt-init grunt-cli" do
  user "root"
  group "root"
end

execute "gem install sass" do
  user "root"
  group "root"
end

directory '/home/vagrant/.grunt-init' do
  recursive true
  user "vagrant"
  group "vagrant"
end

git "/home/vagrant/.grunt-init/hatamoto" do
  repository node[:vccw][:hatamoto_repository]
  reference  "master"
  user "vagrant"
  group "vagrant"
  action :sync
end

git "/home/vagrant/.grunt-init/iemoto" do
  repository node[:vccw][:iemoto_repositry]
  reference  "master"
  user "vagrant"
  group "vagrant"
  action :sync
end

template  "/home/vagrant/.grunt-init/defaults.json" do
  source  "defaults.json.erb"
  owner   "vagrant"
  group   "vagrant"
  mode    "0600"
end

