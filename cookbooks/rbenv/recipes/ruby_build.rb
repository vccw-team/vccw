#
# Cookbook Name:: rbenv
# Recipe:: ruby_build
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

include_recipe "git"

with_home_for_user(node[:rbenv][:user]) do

  git node[:ruby_build][:prefix] do
    repository node[:ruby_build][:git_repository]
    reference node[:ruby_build][:git_revision]
    action :sync
    user node[:rbenv][:user]
    group node[:rbenv][:group]
  end

end
