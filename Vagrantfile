# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

WORDPRESS_LANG = "ja"
WORDPRESS_LANG_VERSION = "3.6.x"
WORDPRESS_HOSTNAME = "wordpress.local"
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
      :wordpress => {
        :languages => {
          :lang => WORDPRESS_LANG,
          :version => WORDPRESS_LANG_VERSION
        }
      },
      :mysql => {
        :server_debian_password => "wordpress",
        :server_root_password => "wordpress",
        :server_repl_password => "wordpress"
      }
    }

    chef.add_recipe "yum::epel"
    chef.add_recipe "iptables"
    chef.add_recipe "wordpress::default"
    chef.add_recipe "wordpress::languages"
    chef.add_recipe "wp-cli"

  end

end
