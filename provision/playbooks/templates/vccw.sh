#
# Environments settings for the VCCW
#

export WP_CLI_BIN_DIR=/tmp/wp-cli-phar
export COMPOSER_HOME=$HOME/.composer
export PATH=$HOME/.composer/vendor/bin:$PATH
export PATH=$HOME/.npm-packages/bin:$PATH

if which ruby >/dev/null && which gem >/dev/null; then
  PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
fi

if which phpcs >/dev/null; then
  alias wpcs="phpcs --standard=WordPress"
fi

alias makepot="/usr/bin/env php $HOME/.wp-i18n/makepot.php"
