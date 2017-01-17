#
# Environments settings for the VCCW
#

# For WP-CLI package tests
export WP_CLI_BIN_DIR=/tmp/wp-cli-phar

# For wp plugin's unit testing
export WP_TESTS_DIR=/tmp/wordpress-tests-lib
export WP_CORE_DIR=/tmp/wordpress/

export COMPOSER_HOME=$HOME/.composer
export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=$HOME/.npm-packages/bin:$PATH

if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if which phpcs >/dev/null; then
  alias wpcs="phpcs --standard=WordPress"
fi

if [ -e $HOME/.wp-i18n/makepot.php ]; then
alias makepot="/usr/bin/env php $HOME/.wp-i18n/makepot.php"
fi

# For wp plugin's unit testing
function install-wp-tests {
  set -ex;

  echo 'DROP DATABASE IF EXISTS wordpress_test;' | mysql -u root

  if [ -e /tmp/wordpress ]; then
    rm -fr /tmp/wordpress
  fi

  if [ -e /tmp/wordpress-tests-lib ]; then
    rm -fr /tmp/wordpress-tests-lib
  fi

  bash bin/install-wp-tests.sh wordpress_test root 'wordpress' localhost latest;
}

# For WP-CLI package tests
function install-package-tests {
  bash bin/install-package-tests.sh
}
