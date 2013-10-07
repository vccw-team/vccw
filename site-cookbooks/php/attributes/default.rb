#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Cookbook Name:: php
# Attribute:: default
#
# Copyright 2011, Opscode, Inc.
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

lib_dir = 'lib'
default['php']['install_method'] = 'package'
default['php']['directives'] = {}

lib_dir = node['kernel']['machine'] =~ /x86_64/ ? 'lib64' : 'lib'
default['php']['conf_dir']      = '/etc'
default['php']['ext_conf_dir']  = '/etc/php.d'
default['php']['fpm_user']      = 'nobody'
default['php']['fpm_group']     = 'nobody'
default['php']['ext_dir']       = "/usr/#{lib_dir}/php/modules"
if node['platform_version'].to_f < 6 then
    default['php']['packages'] = %w(php53 php53-cli php53-devel php53-mbstring php53-gd php53-xml )
else
    default['php']['packages'] = %w(php php-cli php-devel php-mbstring php-gd php-xml )
end

