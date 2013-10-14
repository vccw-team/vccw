vagrant-chef-centos-wordpress
=============================

This is a [Vagrant](http://www.vagrantup.com/) configuration designed for development of WordPress plugins, themes, or websites.

## Overview

* This Vagrant configuration has various settings you can change:
 * Multisite
 * Force SSL Admin
 * Subdirectory installation (e.g. http://wordpress.local/wp/)
* Customizable URL (default: http://wordpress.local/)
* Debug mode is enabled by default
* SSL is enabled by default
* Automatic installation & activation of plugins and themes at the time of provisioning:
 * default plugins: theme-check, plugin-check, hotfix
 * default theme: none
* Optional import of theme unit test data
* Pre-installed[wp-cli](http://wp-cli.org)
* Shares folders between Host and Guest OS

## Getting Started

1. Install VirtualBox.
 * https://www.virtualbox.org/
2. Install Vagrant.
 * http://www.vagrantup.com/
3. Install the vagrant-hostsupdater plugin.
 * `vagrant plugin install vagrant-hostsupdater`
4. Clone the repository into a local directory.
 * `git clone https://github.com/miya0001/vagrant-chef-centos-wordpress.git vagrant-wp`
5. Change into a new directory.
 * `cd vagrant-wp`
6. Copy the default Vagrantfile.
 * `cp Vagrantfile.sample Vagrantfile`
6. Start a Vagrant environment.
 * `vagrant up`
7. Visit http://wordpress.local/

## About WordPress Environment

This tool installs a WordPress environment with these settings by default.

* Default user
 * Username: admin
 * Password: admin
* Debug mode is enabled
* Default plugins
 * hotfix
 * theme-check
 * plugin-check
 * wp-multibyte-patch (`ja` locale only)

## Customize

This Vagrant configuration has many customizable constants.

* `WP_VERSION = 'latest'`
 * Set the version of WordPress you want to install (WordPress 3.4 or later).
 * Default value is the `latest`.
 * Allows you to install [beta](http://wordpress.org/download/release-archive/) releases (e.g. 3.7-beta2)
* `WP_LANG = ""`
 * Select the [locale](http://svn.automattic.com/wordpress-i18n/) you want to download (e.g. `ja`)
 * If you see any error, use `""`.
* `WP_HOSTNAME = "wordpress.local"`
 * Select the hostname for the Guest OS (e.g. `exmaple.com`, `digitalcube.jp` etc.)
* `WP_DIR = ''`
 * If you want to install WordPress in a subdirectory, set the directory name in this constant (e.g. `wp` or `/wp`)
 * http:// + `WP_HOSTNAME` + `WP_DIR` will be your WordPress URL.
* `WP_TITLE = "Welcome to the Vagrant"`
 * The title of the new site.
* `WP_ADMIN_USER = "admin"`
 * The default username of the new site.
* `WP_ADMIN_PASS = "admin"`
 * The default user's password.
* `WP_DB_PREFIX = 'wp_'`
 * Database prefix.
* `WP_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix)`
 * An ARRAY of plugins.
 * Use a plugin slug, local zip file path, or remote zip file URL.
* `WP_DEFAULT_THEME = ''`
 * Default theme.
 * Use a theme slug, local zip file path, or remote zip file URL.
* `WP_IS_MULTISITE = false`
 * If set to `true`, multisite network is installed.
 * The network uses subdirectories by default.
* `WP_FORCE_SSL_ADMIN = false`
 * If set to `true`, administration over SSL is enabled and enforced.
* `WP_DEBUG = true`
 * If set to `true`, debug mode is triggered (default: true).
* `WP_THEME_UNIT_TEST = false`
 * If set to `true`, the [theme unit test data](http://codex.wordpress.org/Theme_Unit_Test) is automatically imported.
* `WP_ALWAYS_RESET = true`
 * If set to `true`, `vagrant provision` always resets the database.
 * You will lose all of your MySQL data when database is reset.
* `WP_IP = "192.168.33.10"`
 * Private IP address for the Guest OS.

### How to apply Vagrant configuration after `vagrant up`

1. `vagrant up` - Start guest machine.
2. Edit Vagrantfile. (`WP_ALWAYS_RESET` should be set `true`.)
3. `vagrant provision` - Re-Provison.
4. `vagrant reload` - Re-Start guest machine.

File under the wp-content directory will be not deleted.

## About wp-cli

* [wp-cli](http://wp-cli.org/) is pre-installed in this Vagrant environments.
* If you install wp-cli in your Host OS, you can fire wp-cli commands from the Host OS.

### Example for wp-cli commands

You have to install [wp-cli](wp-cli.org) in your Host OS.

    cd vagrant-local
    
    # Exports the database using mysqldump to Desktop.
    wp db export ~/Desktop/export.sql
    
    # Export content to a WXR file.
    mkdir /Users/foo/Desktop/export
    wp export --dir=/Users/foo/Desktop/export
    
    # Activate the contect-form-7 plugin.
    wp plugin install contact-form-7 --activate
    
    # Update WordPress.
    wp core update


## Guest OS Environments

* Allowed ports on iptables
 * 22 - SSH
 * 80 - HTTP
 * 443 - HTTPS
 * 3306 - MySQL (allows you to operate wp-cli from the Host OS)
* CentOS 6.4.x
 * PHP 5.3.x
 * MySQL 5.1.x
 * Apache 2.2.x

## Feedback

Let me know if you have any feedback! Open a new issue if you want to share your tips or report a bug.

* https://github.com/miya0001/vagrant-chef-centos-wordpress/issues

## Contibutors

* [@miya0001](http://twitter.com/miya0001) - http://wpist.me/
* [@naokomc](http://twitter.com/naokomc) - http://naoko.cc/
