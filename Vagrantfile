# encoding: utf-8
# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

WORDPRESS_VERSION = 'latest' # latest or 3.4 or later
WORDPRESS_LANG = "ja"

WORDPRESS_TITLE = "Welcome to the Vagrant"
WORDPRESS_HOSTNAME = "wordpress.local"
WORDPRESS_ADMIN_USER = "admin"
WORDPRESS_ADMIN_PASS = "admin"

WORDPRESS_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix)
WORDPRESS_DEFAULT_THEME = ''

WORDPRESS_IP = "192.168.33.10"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "cent64_minimal_i386"
  config.vm.box_url = "http://developer.nrel.gov/downloads/vagrant-boxes/CentOS-6.4-i386-v20130427.box"

  config.vm.hostname = WORDPRESS_HOSTNAME
  config.vm.network :private_network, ip: WORDPRESS_IP

  config.vm.synced_folder "www/", "/var/www", :create => "true"

  config.vm.provision :chef_solo do |chef|

    chef.cookbooks_path = ["cookbooks", "site-cookbooks"]

    chef.json = {
      :apache => {
        :docroot_dir => '/var/www/wordpress',
        :user => 'vagrant',
        :group => 'vagrant'
      },
      :php => {
        :packages => %w(php php-cli php-devel php-mbstring php-gd php-xml php-mysql)
      },
      :mysql => {
        :server_debian_password => "wordpress",
        :server_root_password => "wordpress",
        :server_repl_password => "wordpress"
      },
      :"wp-install" => {
        :wp_version => WORDPRESS_VERSION,
        :url => "http://" << WORDPRESS_HOSTNAME,
        :wpdir => '/var/www/wordpress',
        :locale => WORDPRESS_LANG,
        :admin_user => WORDPRESS_ADMIN_USER,
        :admin_password => WORDPRESS_ADMIN_PASS,
        :dbprefix => 'wp_',
        :default_plugins => WORDPRESS_DEFAULT_PLUGINS,
        :default_theme => WORDPRESS_DEFAULT_THEME,
        :title => WORDPRESS_TITLE
      }
    }

    chef.add_recipe "yum::epel"
    chef.add_recipe "iptables"
    chef.add_recipe "apache2"
    chef.add_recipe "apache2::mod_php5"
    chef.add_recipe "mysql::server"
    chef.add_recipe "mysql::ruby"
    chef.add_recipe "php::package"
    chef.add_recipe "wp-cli"
    chef.add_recipe "wp-install"

  end

end
