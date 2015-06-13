default[:vccw][:composer_home]         = '/home/vagrant/.composer'
default[:vccw][:src_path]              = '/usr/local/share'
default[:vccw][:makepot]               = '/usr/bin/php /usr/local/share/wp-i18n/makepot.php'
default[:vccw][:bash_profile]          = '/home/vagrant/.bash_profile'
default[:vccw][:i18ntools_repositry]   = 'http://i18n.svn.wordpress.org/tools/trunk/'
default[:vccw][:hatamoto_repository]   = 'https://github.com/megumiteam/hatamoto.git'
default[:vccw][:iemoto_repositry]      = 'https://github.com/megumiteam/iemoto.git'

default[:vccw][:phpunit][:src]         = 'https://phar.phpunit.de/phpunit.phar'
default[:vccw][:phpunit][:link]        = '/usr/local/bin/phpunit'
default[:vccw][:phpunit][:wp_test_install] = '/usr/bin/wp-test-install'

default[:vccw][:composer][:install]    = 'curl -sS https://getcomposer.org/installer | php'
default[:vccw][:composer][:link]       = '/usr/local/bin/composer'

default[:vccw][:phpcs][:composer]      = 'squizlabs/php_codesniffer=*'
default[:vccw][:phpcs][:wordpress_repo] = 'https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git'
default[:vccw][:phpcs][:sniffs]        = 'wpcs'
default[:vccw][:phpcs][:alias]         = 'wpcs'

default[:vccw][:wordmove][:movefile]   = '/vagrant/Movefile'
default[:vccw][:wordmove][:url]        = 'http://wordpress.local'
default[:vccw][:wordmove][:wpdir]      = '/var/www/wordpress'
default[:vccw][:wordmove][:dbhost]     = 'localhost'
default[:vccw][:wordmove][:dbname]     = 'wordpress'
default[:vccw][:wordmove][:dbuser]     = 'wordpress'
default[:vccw][:wordmove][:dbpassword] = 'wordpress'

default[:vccw][:user] = 'vagrant'
default[:vccw][:group] = 'vagrant'

default[:vccw][:phpenv][:phpenv_root]  = '/usr/local/phpenv'
default[:vccw][:phpenv][:install]      = 'curl -L https://raw.github.com/CHH/phpenv/master/bin/phpenv-install.sh | sh'
default[:vccw][:phpenv][:php_version]  = 'default'
