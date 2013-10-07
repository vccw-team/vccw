#
# Cookbook Name:: wordpress
# Recipe:: languages
# Author:: Koseki Kengo <koseki@gmail.com>
#
# Copyright 2013, Opscode, Inc.
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

include_recipe "wordpress"

directory "#{node['wordpress']['dir']}/wp-content/languages" do
  owner "vagrant"
  group "vagrant"
  mode "0755"
  action :create
  recursive true
end

unless node['wordpress']['languages']['lang'].to_s.empty? &&
       node['wordpress']['languages']['version'].to_s.empty?
  urls = node['wordpress']['languages']['urls']
  node['wordpress']['languages']['projects'].to_a.each do |project|
    next unless urls[project]

    file = "#{node['wordpress']['dir']}/wp-content/languages/"
    file += "#{project.tr('_', '-')}-" if project != 'main'
    file += "#{node['wordpress']['languages']['lang']}.mo"

    remote_file file do
      source urls[project]
      owner "vagrant"
      group "vagrant"
      mode "0644"
      action :create_if_missing
    end
  end

  node['wordpress']['languages']['themes'].to_a.each do |project|
    next unless urls[project]

    file = "#{node['wordpress']['dir']}/wp-content/themes/#{project}/languages/"
    file += "#{node['wordpress']['languages']['lang']}.mo"

    remote_file file do
      source urls[project]
      owner "vagrant"
      group "vagrant"
      mode "0644"
      action :create_if_missing
    end
  end
end
