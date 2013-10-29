# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

case node['platform']
when "centos", "rhel"
  yum_repository "nginx" do
    description "nginx repo"
    url node['yum']['nginx']['url']
    failovermethod "priority"
    action :add
  end
end
