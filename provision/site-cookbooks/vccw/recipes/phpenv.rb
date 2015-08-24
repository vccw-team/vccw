# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

if /^[0-9]/ =~ node[:vccw][:phpenv][:php_version].to_s

  execute node[:vccw][:phpenv][:install] do
    user "root"
    group "root"
    environment ({
      'PHPENV_ROOT' => node[:vccw][:phpenv][:phpenv_root]
    })
    not_if { ::File.exists?(node[:vccw][:phpenv][:phpenv_root]) }
  end

  execute node[:vccw][:phpenv][:install] do
    user "root"
    group "root"
    environment ({
      'PHPENV_ROOT' => node[:vccw][:phpenv][:phpenv_root],
      'UPDATE' => 'yes'
    })
    only_if { ::File.exists?(node[:vccw][:phpenv][:phpenv_root]) }
  end

  template "/etc/profile.d/phpenv.sh" do
    source "phpenv.sh.erb"
    owner "root"
    group "root"
    mode "0755"
    variables(
      :phpenv_root => node[:vccw][:phpenv][:phpenv_root]
    )
    action :create_if_missing
  end

  directory File.join(node[:vccw][:phpenv][:phpenv_root], "/shims") do
    recursive true
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  directory File.join(node[:vccw][:phpenv][:phpenv_root], "/versions") do
    recursive true
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  directory File.join(node[:vccw][:phpenv][:phpenv_root], "/plugins") do
    recursive true
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  git File.join(node[:vccw][:phpenv][:phpenv_root], "/plugins/php-build") do
    repository "https://github.com/php-build/php-build.git"
    reference  "master"
    user "root"
    group "root"
    action :sync
  end

  template File.join(node[:vccw][:phpenv][:phpenv_root], "/plugins/php-build/share/php-build/default_configure_options") do
    source "default_configure_options.erb"
    owner "root"
    group "root"
    mode "0755"
    action :create
  end

  execute "install-php" do
    user "root"
    group "root"
    command <<-EOF
      rm -fr /tmp/php-build*
      #{File.join(node[:vccw][:phpenv][:phpenv_root], '/bin/phpenv')} install #{Shellwords.shellescape(node[:vccw][:phpenv][:php_version].to_s)}
      #{File.join(node[:vccw][:phpenv][:phpenv_root], '/bin/phpenv')} global #{Shellwords.shellescape(node[:vccw][:phpenv][:php_version].to_s)}
      #{File.join(node[:vccw][:phpenv][:phpenv_root], '/bin/phpenv')} rehash
    EOF
    environment ({
      'PHPENV_ROOT' => node[:vccw][:phpenv][:phpenv_root]
    })
    returns [0, 1]
    notifies :restart, "service[apache2]"
  end

  template File.join(node[:vccw][:phpenv][:phpenv_root], 'versions/', node[:vccw][:phpenv][:php_version].to_s, '/etc/conf.d/vccw.ini') do
    source "vccw.ini.erb"
    owner "root"
    group "root"
    mode "0644"
    variables(:directives => node['php']['directives'])
    notifies :restart, "service[apache2]"
  end

  template "/etc/sudoers.d/phpenv" do
    source "sudoers.erb"
    owner "root"
    group "root"
    mode "0400"
    variables(
      :phpenv_root => node[:vccw][:phpenv][:phpenv_root]
    )
    action :create
  end

end
