#
# Cookbook Name:: rbenv
# Recipe:: ohai_plugin
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

include_recipe "ohai"

bin_path = ::File.join(rbenv_bin_path, "rbenv")

template "#{node[:ohai][:plugin_path]}/rbenv.rb" do
  source 'plugins/rbenv.rb.erb'
  owner 'root'
  group 'root'
  mode 0755

  variables(
    :rbenv_bin => bin_path
  )

  notifies :reload, "ohai[custom_plugins]", :immediately
end
