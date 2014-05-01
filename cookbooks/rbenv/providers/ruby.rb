#
# Cookbook Name:: rbenv
# Provider:: ruby
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

include Chef::Mixin::Rbenv

action :install do
  if !new_resource.force && ruby_version_installed?(new_resource.name)
    Chef::Log.debug "rbenv_ruby[#{new_resource.name}] is already installed so skipping"
  else
    Chef::Log.info "rbenv_ruby[#{new_resource.name}] is building, this may take a while..."

    start_time = Time.now

    out = rbenv_command("install #{new_resource.name}")

    unless out.exitstatus == 0
      raise Chef::Exceptions::ShellCommandFailed, "\n" + out.format_for_exception
    end

    Chef::Log.debug("rbenv_ruby[#{new_resource.name}] build time was #{(Time.now - start_time)/60.0} minutes.")

    chmod_options = {
      user: node[:rbenv][:user],
      group: node[:rbenv][:group],
      cwd: rbenv_root_path
    }

    unless Chef::Platform.windows?
      shell_out("chmod -R 0775 versions/#{new_resource.name}", chmod_options)
      shell_out("find versions/#{new_resource.name} -type d -exec chmod +s {} \\;", chmod_options)
    end

    new_resource.updated_by_last_action(true)
  end

  if new_resource.global && !rbenv_global_version?(new_resource.name)
    Chef::Log.info "Setting #{new_resource.name} as the rbenv global version"
    out = rbenv_command("global #{new_resource.name}")
    unless out.exitstatus == 0
      raise Chef::Exceptions::ShellCommandFailed, "\n" + out.format_for_exception
    end
    new_resource.updated_by_last_action(true)
  end
end
