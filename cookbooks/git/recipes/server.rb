#
# Cookbook Name:: git
# Recipe:: server
#
# Copyright 2009-2014, Chef Software, Inc.
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

return "#{node['platform']} is not supported by the #{cookbook_name}::#{recipe_name} recipe" if node['platform'] == 'windows'

include_recipe 'git'

directory node['git']['server']['base_path'] do
  owner 'root'
  group 'root'
  mode '0755'
end

case node['platform_family']
when 'debian'
  package 'xinetd'
when 'rhel'
  package 'git-daemon'
else
  log 'Platform requires setting up a git daemon service script.'
  log "Hint: /usr/bin/git daemon --export-all --user=nobody --group=daemon --base-path=#{node['git']['server']['base_path']}"
  return
end

template '/etc/xinetd.d/git' do
  backup false
  source 'git-xinetd.d.erb'
  owner 'root'
  group 'root'
  mode '0644'
  variables(
    :git_daemon_binary => value_for_platform_family(
      'debian' => '/usr/lib/git-core/git-daemon',
      'rhel' => '/usr/libexec/git-core/git-daemon'
      )
    )
end

service 'xinetd' do
  action [:enable, :restart]
end
