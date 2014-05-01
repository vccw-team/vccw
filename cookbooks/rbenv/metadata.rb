name             "rbenv"
maintainer       "Riot Games"
maintainer_email "jamie@vialstudios.com"
license          "Apache 2.0"
description      "Installs and configures rbenv"
version          "1.7.1"

recipe "rbenv", "Installs and configures rbenv"
recipe "rbenv::ruby_build", "Installs and configures ruby_build"
recipe "rbenv::ohai_plugin", "Installs an rbenv Ohai plugin to populate automatic_attrs about rbenv and ruby_build"
recipe "rbenv::rbenv_vars", "Installs an rbenv plugin rbenv-vars that lets you set global and project-specific environment variables before spawning Ruby processes"

%w{ centos redhat fedora ubuntu debian amazon oracle}.each do |os|
  supports os
end

%w{ git build-essential apt }.each do |cb|
  depends cb
end

depends 'ohai', '>= 1.1'
