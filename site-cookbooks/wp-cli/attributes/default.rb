#
# Cookbook Name:: wp-cli
# Attributes:: deafault
#
# Author:: Takayuki Miyauchi
# License: MIT
#

default['wp-cli']['wpcli-dir'] = '/usr/local/share/wp-cli'
default['wp-cli']['wpcli-link'] = '/usr/local/bin/wp'
default['wp-cli']['installer'] = 'https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'

default['wp-cli']['locale'] = ""
default['wp-cli']['wp_version'] = "latest"

default['wp-cli']['url'] = ""
default['wp-cli']['wpdir'] = "/var/www/wordpress"
default['wp-cli']['title'] = "Welcome to the WordPress"

default['wp-cli']['dbhost'] = "localhost"
default['wp-cli']['dbname'] = "wordpress"
default['wp-cli']['dbuser'] = "wordpress"
default['wp-cli']['dbprefix'] = "wp_"

default['wp-cli']['admin_user'] = "admin"
default['wp-cli']['admin_password'] = "admin"
default['wp-cli']['admin_email'] = "vagrant@example.com"

default['wp-cli']['default_plugins'] = []
default['wp-cli']['default_theme'] = ''

default['wp-cli']['is_multisite'] = false
default['wp-cli']['debug_mode'] = false
default['wp-cli']['savequeries'] = false

default['wp-cli']['theme_unit_test'] = true
default['wp-cli']['theme_unit_test_data_url'] = 'https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
default['wp-cli']['theme_unit_test_data'] = '/tmp/theme-unit-test-data.xml'

default['wp-cli']['gitignore_url'] = 'https://raw.githubusercontent.com/github/gitignore/master/WordPress.gitignore'
default['wp-cli']['gitignore'] = '/var/www/wordpress/.gitignore'

default['wp-cli']['is_multisite'] = false
default['wp-cli']['force_ssl_admin'] = false
default['wp-cli']['always_reset'] = true

