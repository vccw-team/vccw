# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'yaml'

Vagrant.require_version '>= 1.5'

_conf = YAML.load(
  File.open(
    File.join(File.dirname(__FILE__), 'config.yml'),
    File::RDONLY
  ).read
)

chef_cookbooks_path = File.join(File.dirname(__FILE__), 'chef') # path to the cookbooks (e.g. ~/vccw)

if (ENV['wp_lang'] || _conf['wp']['lang']) === 'ja' then
  theme_unit_test_data_uri = 'https://raw.githubusercontent.com/jawordpressorg/theme-test-data-ja/master/wordpress-theme-test-date-ja.xml'
else
  theme_unit_test_data_uri = 'https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
end


Vagrant.configure(2) do |config|

  config.vm.box = ENV['wp_box'] || _conf['wp_box']
  config.ssh.forward_agent = true

  config.vm.box_check_update = true

  config.vm.hostname = _conf['network']['hostname']
  config.vm.network :private_network, ip: _conf['network']['ip']

  config.vm.synced_folder 'www/wordpress/', '/var/www/wordpress', :create => 'true'

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = true
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize [
      'modifyvm', :id,
      '--natdnsproxy1', 'on',
      '--natdnshostresolver1', 'on'
    ]
  end

  if 'miya0001/vccw' != config.vm.box && 'provision' != ARGV[0]
    config.vm.provision 'shell',
        inline: 'curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -v 11'
  end

  if File.exists?(File.join(File.expand_path(File.dirname(__FILE__)), 'provision', 'provision-pre.sh')) then
    config.vm.provision :shell, :path => File.join( 'provision', 'provision-pre.sh' )
  end

  config.vm.provision :chef_solo do |chef|

    chef.cookbooks_path = [
      File.join(chef_cookbooks_path, 'cookbooks'),
      File.join(chef_cookbooks_path, 'site-cookbooks')
    ]

    chef.json = {
      :apache => {
        :docroot_dir  => '/var/www/wordpress',
        :user         => 'vagrant',
        :group        => 'vagrant',
        :listen_ports => ['80', '443']
      },
      :php => {
        :packages => %w(php php-cli php-devel php-mbstring php-gd php-xml php-mysql),
        :directives => {
            'default_charset'            => 'UTF-8',
            'mbstring.language'          => 'neutral',
            'mbstring.internal_encoding' => 'UTF-8',
            'date.timezone'              => 'UTC',
            'short_open_tag'             => 'Off',
            'session.save_path'          => '/tmp'
        }
      },
      :mysql => {
        :bind_address           => '0.0.0.0',
        :server_debian_password => 'wordpress',
        :server_root_password   => 'wordpress',
        :server_repl_password   => 'wordpress'
      },
      'wpcli' => {
        :wp_version        => ENV['wp_version'] || _conf['wp']['version'],
        :wp_host           => _conf['network']['hostname'],
        :wp_home           => _conf['wp']['wp_home'],
        :wp_siteurl        => _conf['wp']['wp_siteurl'],
        :locale            => ENV['wp_lang'] || _conf['wp']['lang'],
        :admin_user        => _conf['wp']['admin']['user'],
        :admin_password    => _conf['wp']['admin']['pass'],
        :default_plugins   => _conf['wp']['plugins'],
        :default_theme     => _conf['wp']['theme'],
        :title             => _conf['wp']['title'],
        :is_multisite      => _conf['wp']['multisite'],
        :force_ssl_admin   => _conf['wp']['force_ssl_admin'],
        :debug_mode        => _conf['wp']['wp_debug'],
        :savequeries       => _conf['wp']['savequeries'],
        :theme_unit_test   => _conf['wp']['theme_unit_test'],
        :theme_unit_test_data_url => theme_unit_test_data_uri,
        :always_reset      => _conf['wp']['reset_db'],
        :dbhost            => _conf['wp']['db']['host'],
        :dbprefix          => _conf['wp']['db']['prefix'],
        :options           => _conf['wp']['options'],
        :rewrite_structure => _conf['wp']['rewrite_structure']
      },
      :vccw => {
        :wordmove => {
          :movefile        => File.join('/vagrant', 'Movefile'),
          :url             => 'http://' << File.join(_conf['network']['hostname'], _conf['wp']['wp_home']),
          :wpdir           => File.join('www/wordpress', _conf['wp']['wp_siteurl']),
          :dbhost          => _conf['wp']['db']['host']
        }
      },
      :rbenv => {
        'rubies'  => ['2.1.2'],
        'global'  => '2.1.2',
        'gems'    => {
          '2.1.2' => [
            {
              name: 'bundler',
              options: '--no-ri --no-rdoc'
            },
            {
              name: 'sass',
              options: '--no-ri --no-rdoc'
            },
            {
              name: 'wordmove',
              options: '--no-ri --no-rdoc'
            }
          ]
        }
      }
    }

    chef.add_recipe 'yum::remi'
    chef.add_recipe 'iptables'
    chef.add_recipe 'apache2'
    chef.add_recipe 'apache2::mod_php5'
    chef.add_recipe 'apache2::mod_ssl'
    chef.add_recipe 'mysql::server'
    chef.add_recipe 'mysql::ruby'
    chef.add_recipe 'php::package'
    chef.add_recipe 'wpcli'
    chef.add_recipe 'wpcli::install'
    chef.add_recipe 'vccw'

  end

  if File.exists?(File.join(File.expand_path(File.dirname(__FILE__)), 'provision', 'provision-post.sh')) then
    config.vm.provision :shell, :path => File.join( 'provision', 'provision-post.sh' )
  end

end
