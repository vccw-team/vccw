#
# Cookbook Name:: apache2
# Attributes:: apache
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

default['apache']['root_group']  = "root"

# Where the various parts of apache are
case platform
when "redhat", "centos", "scientific", "fedora", "suse", "amazon", "oracle"
  default['apache']['package'] = "httpd"
  default['apache']['dir']     = "/etc/httpd"
  default['apache']['log_dir'] = "/var/log/httpd"
  default['apache']['error_log'] = "error.log"
  default['apache']['access_log'] = "access.log"
  default['apache']['user']    = "apache"
  default['apache']['group']   = "apache"
  default['apache']['binary']  = "/usr/sbin/httpd"
  default['apache']['docroot_dir'] = "/var/www/html"
  default['apache']['cgibin_dir'] = "/var/www/cgi-bin"
  default['apache']['icondir'] = "/var/www/icons"
  default['apache']['cache_dir'] = "/var/cache/httpd"
  if node['platform_version'].to_f >= 6 then
    default['apache']['pid_file'] = "/var/run/httpd/httpd.pid"
  else
    default['apache']['pid_file'] = "/var/run/httpd.pid"
  end
  default['apache']['lib_dir'] = node['kernel']['machine'] =~ /^i[36]86$/ ? "/usr/lib/httpd" : "/usr/lib64/httpd"
  default['apache']['libexecdir'] = "#{node['apache']['lib_dir']}/modules"
  default['apache']['default_site_enabled'] = false
when "debian", "ubuntu"
  default['apache']['package'] = "apache2"
  default['apache']['dir']     = "/etc/apache2"
  default['apache']['log_dir'] = "/var/log/apache2"
  default['apache']['error_log'] = "error.log"
  default['apache']['access_log'] = "access.log"
  default['apache']['user']    = "www-data"
  default['apache']['group']   = "www-data"
  default['apache']['binary']  = "/usr/sbin/apache2"
  default['apache']['docroot_dir'] = "/var/www"
  default['apache']['cgibin_dir'] = "/usr/lib/cgi-bin"
  default['apache']['icondir'] = "/usr/share/apache2/icons"
  default['apache']['cache_dir'] = "/var/cache/apache2"
  default['apache']['pid_file']  = "/var/run/apache2.pid"
  default['apache']['lib_dir'] = "/usr/lib/apache2"
  default['apache']['libexecdir'] = "#{node['apache']['lib_dir']}/modules"
  default['apache']['default_site_enabled'] = false
when "arch"
  default['apache']['package'] = "apache"
  default['apache']['dir']     = "/etc/httpd"
  default['apache']['log_dir'] = "/var/log/httpd"
  default['apache']['error_log'] = "error.log"
  default['apache']['access_log'] = "access.log"
  default['apache']['user']    = "http"
  default['apache']['group']   = "http"
  default['apache']['binary']  = "/usr/sbin/httpd"
  default['apache']['docroot_dir'] = "/srv/http"
  default['apache']['cgibin_dir'] = "/usr/share/httpd/cgi-bin"
  default['apache']['icondir'] = "/usr/share/httpd/icons"
  default['apache']['cache_dir'] = "/var/cache/httpd"
  default['apache']['pid_file']  = "/var/run/httpd/httpd.pid"
  default['apache']['lib_dir'] = "/usr/lib/httpd"
  default['apache']['libexecdir'] = "#{node['apache']['lib_dir']}/modules"
  default['apache']['default_site_enabled'] = false
when "freebsd"
  default['apache']['package'] = "apache22"
  default['apache']['dir']     = "/usr/local/etc/apache22"
  default['apache']['log_dir'] = "/var/log"
  default['apache']['error_log'] = "httpd-error.log"
  default['apache']['access_log'] = "httpd-access.log"
  default['apache']['root_group'] = "wheel"
  default['apache']['user']    = "www"
  default['apache']['group']    = "www"
  default['apache']['binary']  = "/usr/local/sbin/httpd"
  default['apache']['docroot_dir'] = "/usr/local/www/apache22/data"
  default['apache']['cgibin_dir'] = "/usr/local/www/apache22/cgi-bin"
  default['apache']['icondir'] = "/usr/local/www/apache22/icons"
  default['apache']['cache_dir'] = "/var/run/apache22"
  default['apache']['pid_file']  = "/var/run/httpd.pid"
  default['apache']['lib_dir'] = "/usr/local/libexec/apache22"
  default['apache']['libexecdir'] = node['apache']['lib_dir']
  default['apache']['default_site_enabled'] = false
else
  default['apache']['dir']     = "/etc/apache2"
  default['apache']['log_dir'] = "/var/log/apache2"
  default['apache']['error_log'] = "error.log"
  default['apache']['access_log'] = "access.log"
  default['apache']['user']    = "www-data"
  default['apache']['group']   = "www-data"
  default['apache']['binary']  = "/usr/sbin/apache2"
  default['apache']['docroot_dir'] = "/var/www"
  default['apache']['cgibin_dir'] = "/usr/lib/cgi-bin"
  default['apache']['icondir'] = "/usr/share/apache2/icons"
  default['apache']['cache_dir'] = "/var/cache/apache2"
  default['apache']['pid_file']  = "logs/httpd.pid"
  default['apache']['lib_dir'] = "/usr/lib/apache2"
  default['apache']['libexecdir'] = "#{node['apache']['lib_dir']}/modules"
  default['apache']['default_site_enabled'] = false
end

###
# These settings need the unless, since we want them to be tunable,
# and we don't want to override the tunings.
###

# General settings
default['apache']['listen_ports'] = ["80"]
default['apache']['contact'] = "ops@example.com"
default['apache']['timeout'] = 300
default['apache']['keepalive'] = "On"
default['apache']['keepaliverequests'] = 100
default['apache']['keepalivetimeout'] = 5

# Security
default['apache']['servertokens'] = "Prod"
default['apache']['serversignature'] = "On"
default['apache']['traceenable'] = "On"

# mod_auth_openids
default['apache']['allowed_openids'] = Array.new

# mod_status Allow list, space seprated list of allowed entries.  
default['apache']['status_allow_list'] = "localhost ip6-localhost"

# mod_status ExtendedStatus, set to 'true' to enable
default['apache']['ext_status'] = false

# Prefork Attributes
default['apache']['prefork']['startservers'] = 16
default['apache']['prefork']['minspareservers'] = 16
default['apache']['prefork']['maxspareservers'] = 32
default['apache']['prefork']['serverlimit'] = 400
default['apache']['prefork']['maxclients'] = 400
default['apache']['prefork']['maxrequestsperchild'] = 10000

# Worker Attributes
default['apache']['worker']['startservers'] = 4
default['apache']['worker']['serverlimit'] = 16
default['apache']['worker']['maxclients'] = 1024
default['apache']['worker']['minsparethreads'] = 64
default['apache']['worker']['maxsparethreads'] = 192
default['apache']['worker']['threadsperchild'] = 64
default['apache']['worker']['maxrequestsperchild'] = 0

# Default modules to enable via include_recipe

default['apache']['default_modules'] = %w{
  status alias auth_basic authn_file authz_default authz_groupfile authz_host authz_user autoindex
  dir env mime negotiation setenvif
}

%w{ log_config logio }.each do |log_mod|
  default['apache']['default_modules'] << log_mod if ["rhel", "fedora", "suse", "arch", "freebsd"].include?(node['platform_family'])
end
