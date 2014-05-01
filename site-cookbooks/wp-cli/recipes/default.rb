# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

packages = %w{git subversion}

packages.each do |pkg|
  package pkg do
    action [:install, :upgrade]
  end
end

# create wpcli dir
directory node['wp-cli']['wpcli-dir'] do
  recursive true
end

# download installer
remote_file File.join(node['wp-cli']['wpcli-dir'], 'wp-cli.phar') do
  source node['wp-cli']['installer']
  mode 0755
  action :create_if_missing
end

# link wp bin
link node['wp-cli']['wpcli-link'] do
  to File.join(node['wp-cli']['wpcli-dir'], 'wp-cli.phar')
end
