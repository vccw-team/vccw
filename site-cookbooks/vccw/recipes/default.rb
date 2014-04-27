# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{gettext subversion}

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

execute "echo 'alias makepot=\"#{node[:vccw][:makepot]}\"' >> #{node[:vccw]['bash_profile']}" do
  not_if "grep 'alias makepot' #{node[:vccw][:bash_profile]}"
end

