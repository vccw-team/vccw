#
# Cookbook Name:: rbenv
# Library:: provider_rbenv_rubygems
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

require_relative 'chef_mixin_rbenv'

class Chef
  class Provider
    class Package
      class RbenvRubygems < Chef::Provider::Package::Rubygems
        include Chef::Mixin::Rbenv

        class RbenvGemEnvironment < AlternateGemEnvironment
          attr_reader :ruby_version
          attr_reader :rbenv_root_path

          alias_method :original_shell_out!, :shell_out!

          include Chef::Mixin::Rbenv

          def initialize(gem_binary_path, ruby_version, rbenv_root)
            @ruby_version    = ruby_version
            @rbenv_root_path = rbenv_root
            super(gem_binary_path)
          end

          def shell_out!(*args)
            options = args.last.is_a?(Hash) ? args.pop : Hash.new
            options.merge!(env: {
              "RBENV_ROOT"    => rbenv_root_path,
              "RBENV_VERSION" => ruby_version,
              "PATH"          => ([ rbenv_shims_path, rbenv_bin_path ] + system_path).join(':')
            })
            original_shell_out!(*args, options)
          end

          private

            def system_path
              original_shell_out!("echo $PATH").stdout.chomp.split(':')
            end
        end

        attr_reader :gem_binary_path

        def initialize(new_resource, run_context = nil)
          super
          @gem_binary_path = gem_binary_path_for(new_resource.ruby_version)
          @rbenv_root      = node[:rbenv][:root_path]
          @gem_env         = RbenvGemEnvironment.new(gem_binary_path, new_resource.ruby_version, @rbenv_root)
        end

        def install_package(name, version)
          install_via_gem_command(name, version)
          rbenv_command("rehash")

          true
        end

        def remove_package(name, version)
          uninstall_via_gem_command(name, version)

          true
        end

        def install_via_gem_command(name, version = nil)
          src            = @new_resource.source && "  --source=#{@new_resource.source} --source=http://rubygems.org"
          version_option = (version.nil? || version.empty?) ? "" : " -v \"#{version}\""

          shell_out!(
            "#{gem_binary_path} install #{name} -q --no-rdoc --no-ri #{version_option} #{src}#{opts}",
            :user => node[:rbenv][:user],
            :group => node[:rbenv][:group],
            :env => {
              'RBENV_VERSION' => @new_resource.ruby_version,
              'RBENV_ROOT'    => @rbenv_root
            }
          )
        end
      end
    end
  end
end
