#
# Cookbook Name:: apache2
# Recipe:: perl
#
# adapted from the mod_python recipe by Jeremy Bingham
#
# Copyright 2008-2009, Opscode, Inc.
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

case node['platform_family']
when "debian"
  %w{libapache2-mod-perl2 libapache2-request-perl apache2-mpm-prefork}.each do |pkg|

    package pkg

  end
when "rhel", "fedora"

  package "mod_perl" do
    notifies :run, "execute[generate-module-list]", :immediately
  end

  package "perl-libapreq2"

end

file "#{node['apache']['dir']}/conf.d/perl.conf" do
  action :delete
  backup false
end

apache_module "perl"
