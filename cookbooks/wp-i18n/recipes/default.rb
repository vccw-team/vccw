# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{gettext}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

git node['wp-i18n']['path'] do
  repository "https://github.com/osclass/i18n-tools.git"
  reference  "master"
  action     :sync
  user       "root"
  group      "root"
end

execute "echo 'alias makepot=\"#{node['wp-i18n']['makepot']}\"' >> #{node['wp-i18n']['bash_profile']}" do
  not_if "grep 'alias makepot' #{node['wp-i18n']['bash_profile']}"
end

