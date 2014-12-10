#
# Cookbook Name:: rbenv
# Library:: Chef::Rbenv::ShellHelpers
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

class Chef
  module Rbenv
    module ScriptHelpers
      def rbenv_root
        if new_resource.root_path
          new_resource.root_path
        elsif new_resource.user
          ::File.join(user_home, '.rbenv')
        else
          node['rbenv']['root_path']
        end
      end

      def user_home
        return nil unless new_resource.user

        Etc.getpwnam(new_resource.user).dir
      end

      def which_rbenv
        "(#{new_resource.user || 'system'})"
      end

      def current_global_version
        version_file = ::File.join(rbenv_root, 'version')

        ::File.exists?(version_file) && ::IO.read(version_file).chomp
      end

      def wrap_shim_cmd(cmd)
        [ %{export RBENV_ROOT="#{rbenv_root}"},
          %{export PATH="$RBENV_ROOT/bin:$RBENV_ROOT/shims:$PATH"},
          %{export RBENV_VERSION="#{new_resource.rbenv_version}"},
          %{$RBENV_ROOT/shims/#{cmd}}
        ].join(' && ')
      end

      def set_updated
        r = yield
        new_resource.updated_by_last_action(r.updated_by_last_action?)
      end
    end
  end
end
