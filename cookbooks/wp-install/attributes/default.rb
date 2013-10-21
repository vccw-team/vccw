default['wp-install']['locale'] = ""
default['wp-install']['wp_version'] = "latest"

default['wp-install']['url'] = ""
default['wp-install']['wpdir'] = "/var/www/wordpress"
default['wp-install']['title'] = "Welcome to the WordPress"

default['wp-install']['dbhost'] = "localhost"
default['wp-install']['dbname'] = "wordpress"
default['wp-install']['dbuser'] = "wordpress"
default['wp-install']['dbprefix'] = "wp_"

default['wp-install']['admin_user'] = "admin"
default['wp-install']['admin_password'] = "admin"
default['wp-install']['admin_email'] = "vagrant@example.com"

default['wp-install']['default_plugins'] = []

default['wp-install']['is_multisite'] = false
default['wp-install']['debug_mode'] = true
default['wp-install']['theme_unit_test'] = true
default['wp-install']['theme_unit_test_data_url'] = 'https://wpcom-themes.svn.automattic.com/demo/theme-unit-test-data.xml'
default['wp-install']['theme_unit_test_data'] = '/tmp/theme-unit-test-data.xml'

default['wp-install']['gitignore_url'] = 'https://raw.github.com/github/gitignore/master/WordPress.gitignore'
default['wp-install']['gitignore'] = '/var/www/wordpress/.gitignore'

default['wp-install']['is_multisite'] = false
default['wp-install']['force_ssl_admin'] = false
default['wp-install']['always_reset'] = true
