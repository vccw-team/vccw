#
# Cookbook Name:: wpcli
# Attributes:: default
#
# Author:: Takayuki Miyauchi
# License: MIT
#

# default[:wpcli][:wpcli-dir] = '/usr/local/share/wpcli'
# default[:wpcli][:wpcli-link] = '/usr/local/bin/wp'
# default[:wpcli][:installer] = 'https://raw.github.com/wpcli/builds/gh-pages/phar/wpcli.phar'

default[:wpcli][:config_path] = '/home/vagrant/.wp-cli/config.yml'
default[:wpcli][:user] = 'vagrant'
default[:wpcli][:group] = 'vagrant'

default[:wpcli][:dir] = '/usr/share/wp-cli'
default[:wpcli][:link] = '/usr/local/bin/wp'

default[:wpcli][:locale] = ""
default[:wpcli][:wp_version] = "latest"

default[:wpcli][:wp_host] = "wordpress.local"
default[:wpcli][:wp_home] = ""
default[:wpcli][:wp_siteurl] = ""
default[:wpcli][:wp_docroot] = "/var/www/wordpress"
default[:wpcli][:title] = "Welcome to the WordPress"

default[:wpcli][:dbhost] = "localhost"
default[:wpcli][:dbname] = "wordpress"
default[:wpcli][:dbuser] = "wordpress"
default[:wpcli][:dbpassword] = "wordpress"
default[:wpcli][:dbprefix] = "wp_"

default[:wpcli][:admin_user] = "admin"
default[:wpcli][:admin_password] = "admin"
default[:wpcli][:admin_email] = "vagrant@example.com"

default[:wpcli][:default_plugins] = []
default[:wpcli][:default_theme] = ''

default[:wpcli][:is_multisite] = false
default[:wpcli][:debug_mode] = false
default[:wpcli][:savequeries] = false

default[:wpcli][:theme_unit_test] = true
default[:wpcli][:theme_unit_test_data_url] = 'https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
default[:wpcli][:theme_unit_test_data] = '/tmp/theme-unit-test-data.xml'

default[:wpcli][:gitignore_url] = 'https://raw.githubusercontent.com/github/gitignore/master/WordPress.gitignore'
default[:wpcli][:gitignore] = '/var/www/wordpress/.gitignore'

default[:wpcli][:is_multisite] = false
default[:wpcli][:force_ssl_admin] = false
default[:wpcli][:always_reset] = true

default[:wpcli][:options] = {}
default[:wpcli][:multisite_options] = {}
default[:wpcli][:rewrite_structure] = '/archives/%post_id%'
