#
# Author:: Sean OMeara (<someara@getchef.com>)
# Recipe:: yum::default
#
# Copyright 2013, Chef
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

yum_globalconfig '/etc/yum.conf' do
  cachedir node['yum']['main']['cachedir']
  keepcache node['yum']['main']['keepcache']
  debuglevel node['yum']['main']['debuglevel']
  exclude node['yum']['main']['exclude']
  logfile node['yum']['main']['logfile']
  exactarch node['yum']['main']['exactarch']
  obsoletes node['yum']['main']['obsoletes']
  proxy node['yum']['main']['proxy']
  installonly_limit node['yum']['main']['installonly_limit']
  installonlypkgs node['yum']['main']['installonlypkgs']
  installroot node['yum']['main']['installroot']
  distroverpkg node['yum']['main']['distroverpkg']
  action :create
end
