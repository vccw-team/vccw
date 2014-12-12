#
# Cookbook Name:: rbenv
# Attributes:: default
#
# Author:: Fletcher Nichol <fnichol@nichol.ca>
#
# Copyright 2011, Fletcher Nichol
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

# git repository containing rbenv
default['rbenv']['git_url'] = "git://github.com/sstephenson/rbenv.git"
default['rbenv']['git_ref'] = "v0.4.0"

# upgrade action strategy
default['rbenv']['upgrade'] = "none"

# extra system-wide tunables
default['rbenv']['root_path'] = "/usr/local/rbenv"
default['rbenv']['vagrant']['system_chef_solo'] = "/opt/ruby/bin/chef-solo"

# a list of user hashes, each an isolated per-user rbenv installation
default['rbenv']['user_installs'] = []

# list of additional rubies that will be installed
default['rbenv']['rubies']      = []
default['rbenv']['user_rubies'] = []

# hash of rubies and their list of additional gems to be installed.
default['rbenv']['gems']      = Hash.new
default['rbenv']['user_gems'] = Hash.new

# list of rbenv plugins to install
default['rbenv']['plugins']      = []
default['rbenv']['user_plugins'] = []

# whether to create profile.d shell script
default['rbenv']['create_profiled'] = true

case platform
when "redhat","centos","fedora", "amazon", "scientific"
  node.set['rbenv']['install_pkgs']   = %w{git grep}
  default['rbenv']['user_home_root']  = '/home'
when "debian","ubuntu","suse"
  node.set['rbenv']['install_pkgs']   = %w{git-core grep}
  default['rbenv']['user_home_root']  = '/home'
when "mac_os_x"
  node.set['rbenv']['install_pkgs']   = %w{git}
  default['rbenv']['user_home_root']  = '/Users'
when "freebsd"
  node.set['rbenv']['install_pkgs']   = %w{git}
  default['rbenv']['user_home_root']  = '/usr/home'
when "gentoo"
  node.set['rbenv']['install_pkgs']   = %w{git}
  default['rbenv']['user_home_root']  = '/home'
end
