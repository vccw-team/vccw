#
# Cookbook Name:: rbenv
# Library:: mixin_rbenv
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

require 'chef/mixin/shell_out'

class Chef
  module Mixin
    module Rbenv
      include Chef::Mixin::ShellOut

      def rbenv_command(cmd, options = {})
        unless rbenv_installed?
          Chef::Log.error("rbenv is not yet installed. Unable to run " +
                          "rbenv_command:`#{cmd}`. Are you trying to use " +
                          "`rbenv_command` at the top level of your recipe? " +
                          "This is known to cause this error")
          raise "rbenv not installed. Can't run rbenv_command"
        end

        default_options = {
          :user => node[:rbenv][:user],
          :group => node[:rbenv][:group],
          :cwd => rbenv_root_path,
          :env => {
            'RBENV_ROOT' => rbenv_root_path
          },
          :timeout => 3600
        }
        shell_out("#{rbenv_bin_path}/rbenv #{cmd}", Chef::Mixin::DeepMerge.deep_merge!(options, default_options))
      end

      def rbenv_installed?
        out = shell_out("ls #{rbenv_bin_path}/rbenv")
        out.exitstatus == 0
      end

      def ruby_version_installed?(version)
        out = rbenv_command("prefix", :env => { 'RBENV_VERSION' => version })
        out.exitstatus == 0
      end

      def rbenv_global_version?(version)
        out = rbenv_command("global")
        unless out.exitstatus == 0
          raise Chef::Exceptions::ShellCommandFailed, "\n" + out.format_for_exception
        end

        global_version = out.stdout.chomp
        global_version == version
      end

      def gem_binary_path_for(version)
        "#{rbenv_prefix_for(version)}/bin/gem"
      end

      def rbenv_prefix_for(version)
        out = rbenv_command("prefix", :env => { 'RBENV_VERSION' => version })

        unless out.exitstatus == 0
          raise Chef::Exceptions::ShellCommandFailed, "\n" + out.format_for_exception
        end

        prefix = out.stdout.chomp
      end

      def rbenv_bin_path
        ::File.join(rbenv_root_path, "bin")
      end

      def rbenv_shims_path
        ::File.join(rbenv_root_path, "shims")
      end

      def rbenv_root_path
        node[:rbenv][:root_path]
      end

      # Ensures $HOME is temporarily set to the given user. The original
      # $HOME is preserved and re-set after the block has been yielded
      # to.
      #
      # This is a workaround for CHEF-3940. TL;DR Certain versions of
      # `git` misbehave if configuration is inaccessible in $HOME.
      #
      # More info here:
      #
      #   https://github.com/git/git/commit/4698c8feb1bb56497215e0c10003dd046df352fa
      #
      def with_home_for_user(username, &block)

        time = Time.now.to_i

        ruby_block "set HOME for #{username} at #{time}" do
          block do
            ENV['OLD_HOME'] = ENV['HOME']
            ENV['HOME'] = begin
              require 'etc'
              Etc.getpwnam(username).dir
            rescue ArgumentError # user not found
              "/home/#{username}"
            end
          end
        end

        yield

        ruby_block "unset HOME for #{username} #{time}" do
          block do
            ENV['HOME'] = ENV['OLD_HOME']
          end
        end
      end
    end
  end
end
