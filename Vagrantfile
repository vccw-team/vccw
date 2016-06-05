# encoding: utf-8
# vim: ft=ruby expandtab shiftwidth=2 tabstop=2

require 'yaml'

Vagrant.require_version '>= 1.8'

Vagrant.configure(2) do |config|

  vccw_version = '2.18.0';

  _conf = YAML.load(
    File.open(
      File.join(File.dirname(__FILE__), 'provision/default.yml'),
      File::RDONLY
    ).read
  )

  if File.exists?(File.join(ENV["HOME"], '.vccw/config.yml'))
    _custom = YAML.load(
      File.open(
        File.join(ENV["HOME"], '.vccw/config.yml'),
        File::RDONLY
      ).read
    )
    _conf.merge!(_custom) if _custom.is_a?(Hash)
  end

  if File.exists?(File.join(File.dirname(__FILE__), 'site.yml'))
    _site = YAML.load(
      File.open(
        File.join(File.dirname(__FILE__), 'site.yml'),
        File::RDONLY
      ).read
    )
    _conf.merge!(_site) if _site.is_a?(Hash)
  end

  if File.exists?(_conf['chef_cookbook_path'])
    chef_cookbooks_path = _conf['chef_cookbook_path']
  elsif File.exists?(File.join(File.dirname(__FILE__), _conf['chef_cookbook_path']))
    chef_cookbooks_path = File.join(File.dirname(__FILE__), _conf['chef_cookbook_path'])
  else
    puts "Can't find "+_conf['chef_cookbook_path']+'. Please check chef_cookbooks_path in the config.'
    exit 1
  end

  config.vm.define _conf['hostname'] do |v|
  end

  config.vm.box = ENV['wp_box'] || _conf['wp_box']
  config.ssh.forward_agent = true

  config.vm.box_check_update = true

  config.vm.hostname = _conf['hostname']
  config.vm.network :private_network, ip: _conf['ip']

  config.vm.synced_folder ".", "/vagrant", :mount_options => ['dmode=755', 'fmode=644']
  config.vm.synced_folder _conf['sync_folder'], _conf['document_root'], :create => "true", :mount_options => ['dmode=755', 'fmode=644']

  if Vagrant.has_plugin?('vagrant-hostsupdater')
    config.hostsupdater.remove_on_suspend = true
  end

  if Vagrant.has_plugin?('vagrant-vbguest')
    config.vbguest.auto_update = true
  end

  config.vm.provider :virtualbox do |vb|
    vb.linked_clone = _conf['linked_clone']
    vb.name = _conf['hostname']
    vb.memory = _conf['memory'].to_i
    vb.cpus = _conf['cpus'].to_i
    if 1 < _conf['cpus'].to_i
      vb.customize ['modifyvm', :id, '--ioapic', 'on']
    end
    vb.customize ['modifyvm', :id, '--natdnsproxy1', 'on']
    vb.customize ['modifyvm', :id, '--natdnshostresolver1', 'on']
  end

  if 'miya0001/vccw' != config.vm.box && 'provision' != ARGV[0]
    config.vm.provision 'shell',
        inline: 'curl -L https://www.opscode.com/chef/install.sh | sudo bash -s -- -v 11'
  end

  if File.exists?(File.join(File.dirname(__FILE__), 'provision-pre.sh')) then
    config.vm.provision :shell, :path => File.join( File.dirname(__FILE__), 'provision-pre.sh' )
  end

  config.vm.provision :chef_solo do |chef|

    chef.cookbooks_path = [
      File.join(chef_cookbooks_path, 'cookbooks'),
      File.join(chef_cookbooks_path, 'site-cookbooks')
    ]

    chef.json = {
      :apache => {
        :docroot_dir  => _conf['document_root'],
        :user         => _conf['user'],
        :group        => _conf['group'],
        :listen_ports => ['80', '443']
      },
      :php => {
        :packages => %w(php php-cli php-devel php-mbstring php-gd php-xml php-mysql php-pecl-xdebug php-mcrypt),
        :directives => {
            'default_charset'            => 'UTF-8',
            'mbstring.language'          => 'neutral',
            'mbstring.internal_encoding' => 'UTF-8',
            'date.timezone'              => 'UTC',
            'short_open_tag'             => 'Off',
            'session.save_path'          => '/tmp',
            'upload_max_filesize'        => '32M'
        }
      },
      :mysql => {
        :bind_address           => '0.0.0.0',
        :server_debian_password => 'wordpress',
        :server_root_password   => 'wordpress',
        :server_repl_password   => 'wordpress'
      },
      'wpcli' => {
        :user              => _conf['user'],
        :group              => _conf['group'],
        :wp_version        => ENV['wp_version'] || _conf['version'],
        :wp_host           => _conf['hostname'],
        :wp_home           => _conf['wp_home'],
        :wp_siteurl        => _conf['wp_siteurl'],
        :wp_docroot        => _conf['document_root'],
        :locale            => ENV['wp_lang'] || _conf['lang'],
        :admin_user        => _conf['admin_user'],
        :admin_password    => _conf['admin_pass'],
        :admin_email       => _conf['admin_email'],
        :default_plugins   => _conf['plugins'],
        :default_theme     => _conf['theme'],
        :title             => _conf['title'],
        :is_multisite      => _conf['multisite'],
        :force_ssl_admin   => _conf['force_ssl_admin'],
        :debug_mode        => _conf['wp_debug'],
        :savequeries       => _conf['savequeries'],
        :theme_unit_test   => _conf['theme_unit_test'],
        :theme_unit_test_data_url => _conf['theme_unit_test_uri'],
        :gitignore         => File.join(_conf['document_root'], ".gitignore"),
        :always_reset      => _conf['reset_db_on_provision'],
        :dbhost            => _conf['db_host'],
        :dbprefix          => _conf['db_prefix'],
        :options           => _conf['options'],
        :multisite_options => _conf['multisite_options'],
        :rewrite_structure => _conf['rewrite_structure']
      },
      :vccw => {
        :version           => vccw_version,
        :user              => _conf['user'],
        :group              => _conf['group'],
        :wordmove => {
          :movefile        => File.join('/vagrant', 'Movefile'),
          :url             => 'http://' << File.join(_conf['hostname'], _conf['wp_home']),
          :wpdir           => File.join(_conf['document_root'], _conf['wp_siteurl']),
          :dbhost          => _conf['db_host']
        },
        :phpenv => {
          :php_version     => _conf['php_version']
        }
      },
      :rbenv => {
        'rubies'  => ['2.1.2'],
        'global'  => '2.1.2',
        'gems'    => {
          '2.1.2' => [
            {
              name: 'bundler',
              options: '--no-document'
            },
            {
              name: 'sass',
              options: '--no-document'
            },
            {
              name: 'wordmove',
              options: '--no-document'
            },
            {
              name: 'mailcatcher',
              options: '--no-document'
            }
          ]
        }
      }
    }

    chef.add_recipe 'wpcli'
    chef.add_recipe 'wpcli::install'
    if true != _conf['disable_vccw_cookbook']
      chef.add_recipe 'vccw'
    end

  end

  if File.exists?(File.join(File.dirname(__FILE__), 'provision-post.sh')) then
    config.vm.provision :shell, :path => File.join( File.dirname(__FILE__), 'provision-post.sh' )
  end
end
