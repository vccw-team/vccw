#
# Cookbook Name:: phpmyadmin
# Recipe:: default
#
# Copyright 2014, tanshio
#
# All rights reserved - Do Not Redistribute
#

%w{php-mcrypt gd-last php-gd ImageMagick-last phpmyadmin sshpass}.each do |p|
  package p do
    action [:install, :upgrade]
    options "--enablerepo=remi"
  end
end

template "/etc/httpd/conf.d/phpMyAdmin.conf" do
  source "phpMyAdmin.conf.erb"
  owner "root"
  notifies :restart, "service[apache2]"
end