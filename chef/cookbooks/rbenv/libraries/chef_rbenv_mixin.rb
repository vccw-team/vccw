#
# Cookbook Name:: rbenv
# Library:: Chef::Rbenv::Mixin
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
    module Mixin
      module ShellOut
        def shell_out!(*command_args)
          options = command_args.last.is_a?(Hash) ? command_args.pop : Hash.new
          options[:env] = shell_environment.merge(options[:env] || Hash.new)

          super(*command_args.push(options))
        end

        def shell_environment
          if rbenv_user
            { 'USER' => rbenv_user, 'HOME' => Etc.getpwnam(rbenv_user).dir }
          else
            {}
          end
        end
      end

      module ResourceString
        def to_s
          "#{@resource_name}[#{@rbenv_version || 'global'}::#{@name}] (#{@user || 'system'})"
        end
      end
    end
  end
end
