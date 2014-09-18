# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'shellwords'

include_recipe 'ruby_build'
include_recipe 'rbenv::system'

packages = %w{gettext subversion npm}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

#
# Setup WordPress i18n Tools
#

subversion "Checkout WordPress i18n tools." do
  repository    node[:vccw][:i18ntools_repositry]
  revision      "HEAD"
  destination   File.join(node[:vccw][:src_path], 'wp-i18n');
  action        :sync
  user          "root"
  group         "root"
end

execute "echo 'alias makepot.php=\"#{node[:vccw][:makepot]}\"' >> #{node[:vccw][:bash_profile]}" do
  not_if "grep 'alias makepot.php' #{node[:vccw][:bash_profile]}"
end


#
# Setup Grunt
#

execute "npm install -g grunt-init grunt-cli" do
  user "root"
  group "root"
end

#execute "gem install sass" do
#  user "root"
#  group "root"
#end

directory '/home/vagrant/.grunt-init' do
  recursive true
  user "vagrant"
  group "vagrant"
end

git "/home/vagrant/.grunt-init/hatamoto" do
  repository node[:vccw][:hatamoto_repository]
  reference  "master"
  user "vagrant"
  group "vagrant"
  action :sync
end

git "/home/vagrant/.grunt-init/iemoto" do
  repository node[:vccw][:iemoto_repositry]
  reference  "master"
  user "vagrant"
  group "vagrant"
  action :sync
end

template  "/home/vagrant/.grunt-init/defaults.json" do
  source  "defaults.json.erb"
  owner   "vagrant"
  group   "vagrant"
  mode    "0600"
end


#
# Setup PHPUnit
#

directory File.join(node[:vccw][:src_path], 'phpunit') do
  recursive true
end

remote_file File.join(node[:vccw][:src_path], 'phpunit/phpunit.phar') do
  source node[:vccw][:phpunit][:src]
  mode 0755
  action :create_if_missing
end

link node[:vccw][:phpunit][:link] do
  to File.join(node[:vccw][:src_path], 'phpunit/phpunit.phar')
end

execute "wp-test-install" do
  command <<-EOH
#{node[:vccw][:phpunit][:wp_test_install]} \
#{Shellwords.shellescape(node[:vccw][:phpunit][:mysql_name])} \
root \
#{Shellwords.shellescape(node[:mysql][:server_root_password])} \
localhost \
#{Shellwords.shellescape(node[:vccw][:phpunit][:wp_version])}
  EOH
  action :nothing
end

template node[:vccw][:phpunit][:wp_test_install] do
  source "wp-test-install.sh.erb"
  owner "root"
  group "root"
  mode "0755"
  notifies :run, "execute[wp-test-install]", :immediately
end

directory "/tmp/wordpress/wp-content/uploads" do
  recursive true
end

#
# Setup Composer
#

directory File.join(node[:vccw][:src_path], 'composer') do
  recursive true
end

execute node[:vccw][:composer][:install] do
  user  "root"
  group "root"
  cwd   File.join(node[:vccw][:src_path], 'composer')
end

link node[:vccw][:composer][:link] do
  to File.join(node[:vccw][:src_path], 'composer/composer.phar')
end

directory node[:vccw][:composer_home] do
  user  "vagrant"
  group "vagrant"
  recursive true
end

execute "phpcs-install" do
  user  "vagrant"
  group "vagrant"
  environment ({'COMPOSER_HOME' => node[:vccw][:composer_home]})
  command <<-EOH
    #{node[:vccw][:composer][:link]} global require #{Shellwords.shellescape(node[:vccw][:phpcs][:composer])}
  EOH
end

directory File.join(node[:vccw][:src_path], node[:vccw][:phpcs][:sniffs]) do
  recursive true
end

git File.join(node[:vccw][:src_path], node[:vccw][:phpcs][:sniffs]) do
  repository node[:vccw][:phpcs][:wordpress_repo]
  reference  "master"
  user "root"
  group "root"
  action :sync
end

execute "echo 'export PATH=~/.composer/vendor/bin:$PATH' >> #{node[:vccw][:bash_profile]}" do
  not_if "grep 'export PATH=~/.composer/vendor/bin:$PATH' #{node[:vccw][:bash_profile]}"
end

execute "phpcs-set-config" do
  user  "vagrant"
  group "vagrant"
  command <<-EOH
    /home/vagrant/.composer/vendor/bin/phpcs --config-set installed_paths #{File.join(node[:vccw][:src_path], node[:vccw][:phpcs][:sniffs])}
  EOH
end

execute "phpcs-add-alias" do
  user  "vagrant"
  group "vagrant"
  command <<-EOH
    echo 'alias #{node[:vccw][:phpcs][:alias]}="phpcs -p -s -v --standard=WordPress-Core"' >> #{node[:vccw][:bash_profile]}
  EOH
  not_if "grep 'alias #{node[:vccw][:phpcs][:alias]}=' #{node[:vccw][:bash_profile]}"
end

# Generate Movefile
template node[:vccw][:wordmove][:movefile] do
  source "Movefile.erb"
  owner "vagrant"
  group "vagrant"
  mode "0600"
  variables(
    :url        => node[:vccw][:wordmove][:url],
    :wpdir      => node[:vccw][:wordmove][:wpdir],
    :dbhost     => node[:vccw][:wordmove][:dbhost],
    :dbname     => node[:vccw][:wordmove][:dbname],
    :dbuser     => node[:vccw][:wordmove][:dbuser],
    :dbpassword => node[:vccw][:wordmove][:dbpassword]
  )
  action :create_if_missing
end

