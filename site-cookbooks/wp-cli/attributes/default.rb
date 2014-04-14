#
# Cookbook Name:: wp-cli
# Attributes:: deafault
#
# Author:: Takayuki Miyauchi
# License: MIT
#

default['wp-cli']['wpcli-dir'] = '/usr/share/wp-cli'
default['wp-cli']['wpcli-link'] = '/usr/bin/wp'
default['wp-cli']['installer'] = 'https://raw.github.com/wp-cli/builds/gh-pages/phar/wp-cli.phar'
default['wp-cli']['phpunit'] = 'https://phar.phpunit.de/phpunit.phar'
default['wp-cli']['phpunit-link'] = '/usr/bin/phpunit'
