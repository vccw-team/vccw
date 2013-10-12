vagrant-chef-centos-wordpress
=============================

This is a [Vagrant](http://www.vagrantup.com/) configuration focused on development of WordPress plugins, themes, websites.

## Overview

* This Vagrant configuration has many settings which you can change.
 * Multisite
 * Force SSL Admin
 * Installed in subdirectory. (e.g. http://wordpress.local/wp/)
* Allow you to customize URL. (Default: http://wordpress.local/)
* Debug mode already enabled.
* SSL already enabled.
* It is possible to install & activate plugins automatically when provisioning.(Default: theme-check, plugin-check, hotfix)
* It is possible to install theme automatically when provisioning.(Default: none)
* Allow you to import theme unit test data.(Default: not import)
* [wp-cli](http://wp-cli.org) already installed.
* Share folders between Host and Guest OS

## Getting Started

1. Install VirtualBox.
 * https://www.virtualbox.org/
2. Install Vagrant.
 * http://www.vagrantup.com/
3. Install the vagrant-hostsupdater plugin.
 * `vagrant plugin install vagrant-hostsupdater`
4. Clone the repository into a local directory
 * `git clone https://github.com/miya0001/vagrant-chef-centos-wordpress.git vagrant-wp`
5. Change into the new directory.
 * `cd vagrant-wp`
6. Copy the default Vagrantfile.
 * `cp Vagrantfile.sample Vagrantfile`
6. Start the Vagrant environment.
 * `vagrant up`
7. Visit http://wordpress.local/

## About WordPress environment

* Default user.
 * User Name: admin
 * Password: admin
* Debug mode enabled.
* Defalut plugins.
 * hotfix
 * theme-check
 * plugin-check
 * wp-multibyte-patch (ja only)

## Customize

This Vagrant configuration has many customizable constants.

* `WP_VERSION = 'latest'`
 * Set which version you want to install. (WordPress 3.4 or later)
 * Default value is the `latest`.
 * Allow you to set [Beta](http://wordpress.org/download/release-archive/) releases. (e.g.: 3.7-beta2)
* `WP_LANG = ""`
 * Select which language you want to download. (e.g. `ja`)
 * If you have an error, please set `""`.
* `WP_HOSTNAME = "wordpress.local"`
 * Select which hostname for Guest OS. (e.g. `exmaple.com` 、`digitalcube.jp` など)
* `WP_DIR = ''`
 * If you want to install WordPress in the subdirectory. Please set directory name to this constant. (e.g. `wp` or `/wp`)
 * http:// + `WP_HOSTNAME` + `WP_DIR` is your WordPress URL.
* `WP_TITLE = "Welcome to the Vagrant"`
 * The title of the new site.
* `WP_ADMIN_USER = "admin"`
 * The default user name of the new site.
* `WP_ADMIN_PASS = "admin"`
 * The default user's password.
* `WP_DB_PREFIX = 'wp_'`
 * Database prefix.
* `WP_DEFAULT_PLUGINS = %w(theme-check plugin-check hotfix)`
 * Set an ARRAY of plugins.
 * Allow you to set plugin slug, the path to a local zip file, or URL to a remote zip file.
* `WP_DEFAULT_THEME = ''`
 * Set a default theme.
 * Allow you to set theme slug, the path to a local zip file, or URL to a remote zip file.
* `WP_IS_MULTISITE = false`
 * If set `true` then multi-site install.
 * The network will use subdirectories by default.
* `WP_FORCE_SSL_ADMIN = false`
 * If set `true` then enable and enforce administration over SSL.
* `WP_DEBUG = true`
 * If set `true` then trigger the debug mode. (Default)
* `WP_THEME_UNIT_TEST = false`
 * If set `true` then [Theme unit test data](http://codex.wordpress.org/Theme_Unit_Test) will import automatically.
* `WP_ALWAYS_RESET = true`
 * If set `true` then always reset database when `vagrant provision`.
 * You will lost all MySQL data when reset database.
* `WP_IP = "192.168.33.10"`
 * Private IP address for Guest OS.

### How to apply Vagrant configuration after `vagrant up`

1. `vagrant up` - Start guest machine.
2. Ednit Vagrantfile. (`WP_ALWAYS_RESET` should be set `true`.)
3. `vagrant provision` - Re-Provison.
4. `vagrant reload` - Re-Start guest machine.

File under the wp-content directory will be not deleted.

## wp-cliについて

* [wp-cli](http://wp-cli.org/) is pre-installed in this Vagrant environments.
* If you install wp-cli in your Host OS, you can fire wp-cli commands from the Host OS.

### Example for wp-cli commands

You have to install [wp-cli](wp-cli.org) in Host OS.

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


## Guest OS environments

* Allowed ports on iptables
 * 22 - SSH
 * 80 - HTTP
 * 443 - HTTPS
 * 3306 - MySQL(Allow you to operate wp-cli from the Host OS)
* CentOS 6.4.x
 * PHP 5.3.x
 * MySQL 5.1.x
 * Apache 2.2.x

## Feedback

Let us have it! If you have tips that we need to know, open a new issue.

* https://github.com/miya0001/vagrant-chef-centos-wordpress/issues

## Contibutors

* [@miya0001](http://twitter.com/miya0001) - http://wpist.me/
