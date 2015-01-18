#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "apache2" do
  package_name node['apache']['package']
end

service "apache2" do
  case node['platform_family']
  when "rhel", "fedora", "suse"
    service_name "httpd"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service httpd restart && sleep 1"
    reload_command "/sbin/service httpd reload && sleep 1"
  when "debian"
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 1"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 1"
  when "arch"
    service_name "httpd"
  when "freebsd"
    service_name "apache22"
  end
  supports [:restart, :reload, :status]
  action :enable
end

if platform_family?("rhel", "fedora", "arch", "suse", "freebsd")
  directory node['apache']['log_dir'] do
    mode 00755
  end

  package "perl"

  cookbook_file "/usr/local/bin/apache2_module_conf_generate.pl" do
    source "apache2_module_conf_generate.pl"
    mode 00755
    owner "root"
    group node['apache']['root_group']
  end

  %w{sites-available sites-enabled mods-available mods-enabled}.each do |dir|
    directory "#{node['apache']['dir']}/#{dir}" do
      mode 00755
      owner "root"
      group node['apache']['root_group']
    end
  end

  execute "generate-module-list" do
    command "/usr/local/bin/apache2_module_conf_generate.pl #{node['apache']['lib_dir']} #{node['apache']['dir']}/mods-available"
    action :nothing
  end

  %w{a2ensite a2dissite a2enmod a2dismod}.each do |modscript|
    template "/usr/sbin/#{modscript}" do
      source "#{modscript}.erb"
      mode 00700
      owner "root"
      group node['apache']['root_group']
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  %w{ proxy_ajp auth_pam authz_ldap webalizer ssl welcome }.each do |f|
    file "#{node['apache']['dir']}/conf.d/#{f}.conf" do
      action :delete
      backup false
    end
  end

  # installed by default on centos/rhel, remove in favour of mods-enabled
  file "#{node['apache']['dir']}/conf.d/README" do
    action :delete
    backup false
  end

  # enable mod_deflate for consistency across distributions
  include_recipe "apache2::mod_deflate"
end

if platform_family?("freebsd")

  file "#{node['apache']['dir']}/Includes/no-accf.conf" do
    action :delete
    backup false
  end

  directory "#{node['apache']['dir']}/Includes" do
    action :delete
  end

  %w{
      httpd-autoindex.conf httpd-dav.conf httpd-default.conf httpd-info.conf
      httpd-languages.conf httpd-manual.conf httpd-mpm.conf
      httpd-multilang-errordoc.conf httpd-ssl.conf httpd-userdir.conf
      httpd-vhosts.conf
    }.each do |f|

    file "#{node['apache']['dir']}/extra/#{f}" do
      action :delete
      backup false
    end

  end

  directory "#{node['apache']['dir']}/extra" do
    action :delete
  end

end

directory "#{node['apache']['dir']}/ssl" do
  mode 00755
  owner "root"
  group node['apache']['root_group']
end

directory "#{node['apache']['dir']}/conf.d" do
  mode 00755
  owner "root"
  group node['apache']['root_group']
end

directory node['apache']['cache_dir'] do
  mode 00755
  owner "root"
  group node['apache']['root_group']
end

# Set the preferred execution binary - prefork or worker
template "/etc/sysconfig/httpd" do
  source "etc-sysconfig-httpd.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  notifies :restart, "service[apache2]"
  only_if { platform_family?("rhel", "fedora") }
end

template "apache2.conf" do
  case node['platform_family']
  when "rhel", "fedora", "arch"
    path "#{node['apache']['dir']}/conf/httpd.conf"
  when "debian"
    path "#{node['apache']['dir']}/apache2.conf"
  when "freebsd"
    path "#{node['apache']['dir']}/httpd.conf"
  end
  source "apache2.conf.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  notifies :restart, "service[apache2]"
end

template "apache2-conf-security" do
  path "#{node['apache']['dir']}/conf.d/security"
  source "security.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  backup false
  notifies :restart, "service[apache2]"
end

template "apache2-conf-charset" do
  path "#{node['apache']['dir']}/conf.d/charset"
  source "charset.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  backup false
  notifies :restart, "service[apache2]"
end

template "#{node['apache']['dir']}/ports.conf" do
  source "ports.conf.erb"
  owner "root"
  group node['apache']['root_group']
  variables :apache_listen_ports => node['apache']['listen_ports'].map { |p| p.to_i }.uniq
  mode 00644
  notifies :restart, "service[apache2]"
end

template "#{node['apache']['dir']}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
  notifies :restart, "service[apache2]"
end

node['apache']['default_modules'].each do |mod|
  module_recipe_name = mod =~ /^mod_/ ? mod : "mod_#{mod}"
  include_recipe "apache2::#{module_recipe_name}"
end

apache_site "default" do
  enable node['apache']['default_site_enabled']
end

service "apache2" do
  action :start
end
