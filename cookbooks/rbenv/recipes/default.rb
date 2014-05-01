#
# Cookbook Name:: rbenv
# Recipe:: default
#
# Author:: Jamie Winsor (<jamie@vialstudios.com>)
#
# Copyright 2011-2012, Riot Games
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

node.set[:rbenv][:root]          = rbenv_root_path
node.set[:ruby_build][:prefix]   = "#{node[:rbenv][:root]}/plugins/ruby_build"
node.set[:ruby_build][:bin_path] = "#{node[:ruby_build][:prefix]}/bin"

case node[:platform]
when "ubuntu", "debian"
  include_recipe "apt"
end

include_recipe "build-essential"
include_recipe "git"
package "curl"

case node[:platform]
when "redhat", "centos", "amazon", "oracle"
  # TODO: add as per "rvm requirements"
  package "openssl-devel"
  package "zlib-devel"
  package "readline-devel"
  package "libxml2-devel"
  package "libxslt-devel"
when "ubuntu", "debian"
  package "libc6-dev"
  package "automake"
  package "libtool"

  # https://github.com/sstephenson/ruby-build/issues/119
  # "It seems your ruby installation is missing psych (for YAML
  # output). To eliminate this warning, please install libyaml and
  # reinstall your ruby."
  package 'libyaml-dev'

  # needed to unpack rubygems
  package 'zlib1g'
  package 'zlib1g-dev'

  # openssl support for ruby
  package "openssl"
  package 'libssl-dev'

  # readline for irb and rails console
  package "libreadline-dev"

  # for ruby stdlib rexml and nokogiri
  # http://nokogiri.org/tutorials/installing_nokogiri.html
  package "libxml2-dev"
  package "libxslt1-dev"

  # better irb support
  package "ncurses-dev"

  # for searching packages
  package "pkg-config"
end

group node[:rbenv][:group] do
  members node[:rbenv][:group_users] if node[:rbenv][:group_users]
end

user node[:rbenv][:user] do
  shell "/bin/bash"
  group node[:rbenv][:group]
  supports :manage_home => node[:rbenv][:manage_home]
  home node[:rbenv][:user_home]
end

directory node[:rbenv][:root] do
  owner node[:rbenv][:user]
  group node[:rbenv][:group]
  mode "2775"
  recursive true
end

with_home_for_user(node[:rbenv][:user]) do

  git node[:rbenv][:root] do
    repository node[:rbenv][:git_repository]
    reference node[:rbenv][:git_revision]
    user node[:rbenv][:user]
    group node[:rbenv][:group]
    action :sync

    notifies :create, "template[/etc/profile.d/rbenv.sh]", :immediately
  end

end

template "/etc/profile.d/rbenv.sh" do
  source "rbenv.sh.erb"
  mode "0644"
  variables(
    :rbenv_root => node[:rbenv][:root],
    :ruby_build_bin_path => node[:ruby_build][:bin_path]
  )

  notifies :create, "ruby_block[initialize_rbenv]", :immediately
end

ruby_block "initialize_rbenv" do
  block do
    ENV['RBENV_ROOT'] = node[:rbenv][:root]
    ENV['PATH'] = "#{node[:rbenv][:root]}/bin:#{node[:rbenv][:root]}/shims:#{node[:ruby_build][:bin_path]}:#{ENV['PATH']}"
  end

  action :nothing
end

# rbenv init creates these directories as root because it is called
# from /etc/profile.d/rbenv.sh But we want them to be owned by rbenv
# check https://github.com/sstephenson/rbenv/blob/master/libexec/rbenv-init#L71
%w{shims versions plugins}.each do |dir_name|
  directory "#{node[:rbenv][:root]}/#{dir_name}" do
    owner node[:rbenv][:user]
    group node[:rbenv][:group]
    mode "2775"
    action [:create]
  end
end
