#
# Cookbook Name:: rbenv
# Recipe:: system_install
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

include_recipe 'rbenv'

upgrade_strategy  = build_upgrade_strategy(node['rbenv']['upgrade'])
git_url           = node['rbenv']['git_url']
git_ref           = node['rbenv']['git_ref']
rbenv_prefix      = node['rbenv']['root_path']

install_rbenv_pkg_prereqs

directory "/etc/profile.d" do
  owner   "root"
  mode    "0755"
end

template "/etc/profile.d/rbenv.sh" do
  source  "rbenv.sh.erb"
  owner   "root"
  mode    "0755"
end

install_or_upgrade_rbenv  :rbenv_prefix => rbenv_prefix,
                          :git_url => git_url,
                          :git_ref => git_ref,
                          :upgrade_strategy => upgrade_strategy
