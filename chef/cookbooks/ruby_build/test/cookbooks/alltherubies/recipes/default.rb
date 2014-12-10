#
# Cookbook Name:: alltherubies
# Recipe:: default
#
# Copyright 2012, Fletcher Nichol
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

cores         = node['cpu']['total'].to_i
system_rubies = %w{ 1.9.2-p320 1.9.3-p362 2.0.0-preview2
                    jruby-1.7.1 rbx-2.0.0-rc1 }

include_recipe "java"

if %{ubuntu debian}.include?(node['platform'])
  package "default-jre-headless"
end

log "Forcing update of java alternatives" do
  notifies :create, "ruby_block[update-java-alternatives]", :immediately
end

system_rubies.each do |rubie|
  ruby_build_ruby rubie do
    environment({ 'MAKE_OPTS' => "-j #{cores + 1}" })
  end
end

# Woah, REE, crazy bananas! For more details see:
# * https://github.com/sstephenson/rbenv/issues/297
# * https://github.com/sstephenson/ruby-build/issues/186
ruby_build_ruby "ree-1.8.7-2012.02" do
  environment({
    'MAKE_OPTS'       => "-j #{cores + 1}",
    'CONFIGURE_OPTS'  => "--no-tcmalloc",
  })
end

user_account "app" do
  home "/home/app"
end

ruby_build_ruby "1.8.7-p371" do
  prefix_path "/home/app/.rubies/ruby-1.8.7-p371"
  user        "app"
  group       "app"
  environment({ 'MAKE_OPTS' => "-j #{cores + 1}" })
end
