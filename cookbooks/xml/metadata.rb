name             "xml"
maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Installs xml"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.1.2"

recipe "xml", "Installs libxml development packages"

%w{ centos redhat scientific suse fedora amazon ubuntu debian freebsd arch }.each do |os|
  supports os
end
depends "build-essential"
