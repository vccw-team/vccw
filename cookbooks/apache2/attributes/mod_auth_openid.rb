#
# Author:: Joshua Timberman <joshua@opscode.com>
# Copyright:: Copyright (c) 2011, Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['apache']['mod_auth_openid']['ref']  = "95043901eab868400937642d9bc55d17e9dd069f"
default['apache']['mod_auth_openid']['source_url'] = "https://github.com/bmuller/mod_auth_openid/archive/#{node['apache']['mod_auth_openid']['ref']}.tar.gz"
default['apache']['mod_auth_openid']['cache_dir']  = "/var/cache/mod_auth_openid"
default['apache']['mod_auth_openid']['dblocation'] = "#{node['apache']['mod_auth_openid']['cache_dir']}/mod_auth_openid.db"

case node['platform_family']
when "freebsd"
  default['apache']['mod_auth_openid']['configure_flags'] = [
    "CPPFLAGS=-I/usr/local/include",
    "LDFLAGS=-I/usr/local/lib -lsqlite3"
  ]
else
  default['apache']['mod_auth_openid']['configure_flags'] = []
end
