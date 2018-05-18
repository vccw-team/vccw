# bc-wordpress-development

This is a Vagrant configuration designed for development of WordPress.

bc-wordpress-development are forked and edited version of VCCW (https://github.com/vccw-team/vccw).

## Installation

* Install Vagrant, VirtualBox and Ansible on your machine.

* Clone this repository with git.

For more information check out <http://vccw.cc/>.

## BC Configuration

* Run ./scripts/bc-wp-init.sh and follow instructions.

## PHP version

By default, PHP version is set to 7.0 if you want to use PHP 5.6 run vagrant up like this

```bash
WPPHP56=True vagrant up
```
