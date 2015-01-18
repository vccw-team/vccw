#
# Cookbook Name:: rbenv
# Provider:: plugin
#
# Author:: Joshua Yotty <jyotty@bluebox.net>
#
# Copyright 2014, Joshua Yotty
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

def whyrun_supported?
  true
end

use_inline_resources

include Chef::Rbenv::ScriptHelpers

action :install do
  set_updated { create_plugins_directory }
  set_updated { clone_plugin_repo }
end

def create_plugins_directory
  directory ::File.join(rbenv_root, 'plugins') do
    owner   new_resource.user || 'root'
    mode    00755
    action  :create
  end
end

def clone_plugin_repo
  plugin_path = ::File.join(rbenv_root, 'plugins', new_resource.name)

  git "Install #{new_resource.name} plugin" do
    destination plugin_path
    repository  new_resource.git_url
    reference   new_resource.git_ref || 'master'
    user        new_resource.user if new_resource.user
    action      :sync
  end
end
