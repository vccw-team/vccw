#
# Cookbook Name:: apache2
# Recipe:: mod_auth_openid
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

openid_dev_pkgs = value_for_platform_family(
  ["debian"] => %w{automake make g++ apache2-prefork-dev libopkele-dev libopkele3 libtool},
  ["rhel", "fedora"] => %w{gcc-c++ httpd-devel curl-devel libtidy libtidy-devel sqlite-devel pcre-devel openssl-devel make libtool},
  "arch" => ["libopkele"],
  "freebsd" => %w{libopkele pcre sqlite3}
)

make_cmd = value_for_platform_family(
  "freebsd" => { "default" => "gmake" },
  "default" => "make"
)

case node['platform_family']
when "arch"

  include_recipe "pacman"
  package "tidyhtml"
  pacman_aur openid_dev_pkgs.first do
    action [:build, :install]
  end

else
  openid_dev_pkgs.each do |pkg|

    package pkg

  end
end

case node['platform_family']
when "rhel", "fedora"
  remote_file "#{Chef::Config['file_cache_path']}/libopkele-2.0.4.tar.gz" do
    source "http://kin.klever.net/dist/libopkele-2.0.4.tar.gz"
    mode 00644
    checksum "57a5bc753b7e80c5ece1e5968b2051b0ce7ed9ce4329d17122c61575a9ea7648"
  end

  bash "install libopkele" do
    cwd Chef::Config['file_cache_path']
    # Ruby 1.8.6 does not have rpartition, unfortunately
    syslibdir = node['apache']['lib_dir'][0..node['apache']['lib_dir'].rindex("/")]
    code <<-EOH
    tar zxvf libopkele-2.0.4.tar.gz
    cd libopkele-2.0.4 && ./configure --prefix=/usr --libdir=#{syslibdir}
    #{make_cmd} && #{make_cmd} install
    EOH
    creates "#{syslibdir}/libopkele.a"
  end
end

version = node['apache']['mod_auth_openid']['ref']
configure_flags = node['apache']['mod_auth_openid']['configure_flags']

remote_file "#{Chef::Config['file_cache_path']}/mod_auth_openid-#{version}.tar.gz" do
  source node['apache']['mod_auth_openid']['source_url']
  mode 00644
  action :create_if_missing
end

file "mod_auth_openid_dblocation" do
  path node['apache']['mod_auth_openid']['dblocation']
  action :nothing
end

bash "untar mod_auth_openid" do
  cwd Chef::Config['file_cache_path']
  code <<-EOH
  tar zxvf mod_auth_openid-#{version}.tar.gz
  EOH
end

bash "compile mod_auth_openid" do
  cwd "#{Chef::Config['file_cache_path']}/mod_auth_openid-#{version}"
  code <<-EOH
  ./autogen.sh
  ./configure #{configure_flags.join(' ')}
  perl -pi -e "s/-i -a -n 'authopenid'/-i -n 'authopenid'/g" Makefile
  #{make_cmd} && #{make_cmd} install
  EOH
  creates "#{node['apache']['libexecdir']}/mod_auth_openid.so"
  notifies :delete, "file[mod_auth_openid_dblocation]", :immediately
  notifies :restart, "service[apache2]"
end

directory node['apache']['mod_auth_openid']['cache_dir'] do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00700
end

file node['apache']['mod_auth_openid']['dblocation'] do
  owner node['apache']['user']
  group node['apache']['group']
  mode 00644
end

template "#{node['apache']['dir']}/mods-available/authopenid.load" do
  source "mods/authopenid.load.erb"
  owner "root"
  group node['apache']['root_group']
  mode 00644
end

apache_module "authopenid" do
  filename "mod_auth_openid.so"
end
