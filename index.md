---
layout: default
title: VCCW - Vagrant based development environment for WordPress
og_url: http://vccw.cc/
og_image: http://vccw.cc/images/ogp.png
description: VCCW is a Vagrant based development environment for WordPress plugins, themes, or websites.
---

# Vagrant + Chef + WordPress

This is a [Vagrant](http://www.vagrantup.com/) configuration designed for development of WordPress plugins, themes, or websites.

<ul id="navmenu"></ul>

## Overview

* This Vagrant configuration has various settings you can change:
     * Multisite
     * Force SSL Admin
     * Subdirectory installation (e.g. `http://wordpress.local/wp/`)
* Customizable URL (default: `http://wordpress.local/`)
* Debug mode is enabled by default
* SSL is enabled by default
* Automatic installation & activation of plugins and themes at the time of provisioning:
     * default plugins: theme-check, plugin-check, dynamic-hostname
     * default theme: none
* Optional import of theme unit test data
* Pre-installed [WP-CLI](http://wp-cli.org), [PHPUnit](http://phpunit.de/), [Grunt](http://gruntjs.com/), [Composer](https://getcomposer.org/)
* Shares folders between Host and Guest OS

{{ site.scroll_to_top }}

## Requires

* Vagrant 1.5 or later
* VirtualBox 4.3 or later

{{ site.scroll_to_top }}

## Getting Started

### 1. Install VirtualBox.

[https://www.virtualbox.org/](https://www.virtualbox.org/)

### 2. Install Vagrant.

[http://www.vagrantup.com/](http://www.vagrantup.com/)

### 3. Install the vagrant-hostsupdater plugin.

```
$ vagrant plugin install vagrant-hostsupdater
```

### 4. Clone the repository into a local directory.

```
$ git clone git@github.com:miya0001/vccw.git
```

Or

```
$ git clone https://github.com/miya0001/vccw.git
````

Or please download from link in the right sidebar. 

### 5. Change into a new directory.

```
$ cd vccw
```

### 6. Copy the default Vagrantfile.

```
$ cp Vagrantfile.sample Vagrantfile
```

### 7. Start a Vagrant environment.

```
$ vagrant up
```

### 8. Visit WordPress on the Vagrant in your browser

Visit [http://wordpress.local/](http://wordpress.local/) or [http://192.168.33.10/](http://192.168.33.10/)

{{ site.scroll_to_top }}

## Environments

### WordPress

This tool installs a WordPress environment with these settings by default.

* Default user
     * Username: admin
     * Password: admin
* Debug mode is enabled
* Default plugins
     * dynamic-hostname
     * theme-check
     * plugin-check
     * wp-multibyte-patch (`ja` locale only)

### Guest OS

* CentOS 6.5.x
     * PHP 5.4.x
     * MySQL 5.5.x
     * Apache 2.2.x
* [WP-CLI](http://wp-cli.org/)
* [PHPUnit](http://phpunit.de/)
* [WordPress i18n Tools](http://i18n.svn.wordpress.org/tools/trunk/)
* [Grunt](http://gruntjs.com/)
* [Composer](https://getcomposer.org/)

{{ site.scroll_to_top }}

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
* `WP_DB_HOST = 'localhost'`
    * The host name of the MySQL database.
    * 'localhost' or WP_IP
* `WP_DEFAULT_PLUGINS = %w(theme-check plugin-check dynamic-hostname)`
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

{{ site.scroll_to_top }}

## About WP-CLI

* [WP-CLI](http://wp-cli.org/) is pre-installed in this Vagrant environments.
* If you install WP-CLI in your Host OS, you can fire WP-CLI commands from the Host OS.

### Example for WP-CLI commands

You have to install [WP-CLI](wp-cli.org) in your Host OS.

```
$ cd www/wordpress

# Exports the database using mysqldump to Desktop.
$ wp db export ~/Desktop/export.sql

# Export content to a WXR file.
$ mkdir /Users/foo/Desktop/export
$ wp export --dir=/Users/foo/Desktop/export

# Activate the contect-form-7 plugin.
$ wp plugin install contact-form-7 --activate

# Update WordPress.
$ wp core update
```

{{ site.scroll_to_top }}

## About WordPress i18n Tools

If your plugin is not in the repository, you can use the WordPress i18n tools and then run the makepot.php script like this:

```
$ makepot.php wp-plugin your-plugin-directory
```

To generate the POT file for a theme, use:

```
$ makepot.php wp-theme your-theme-directory
```

After it's finished you should see the POT file in the current directory.

{{ site.scroll_to_top }}

## About WordPress plugin unit testing

### Getting Started

#### 1. SSH into your Vagrant machine.

```
$ vagrant ssh
```

#### 2. Change into your plugin directory.

```
$ cd /var/www/wordpress/wp-content/plugins/my-plugin
```

#### 3. Generate the plugin test files.

```
$ wp scaffold plugin-tests my-plugin
```

This command will generate all the files needed for running tests, including a .travis.yml file. If you host your plugin on Github and enable [Travis CI](http://docs.travis-ci.com/), the tests will be run automatically after every commit you make to the plugin.

#### 4. Run the plugin tests.

```
$ phpunit
```

### Writing PHPUnit test

* [Nikolay Bachiyski: Unit Testing Will Change Your Life](http://wordpress.tv/2011/08/20/nikolay-bachiyski-unit-testing-will-change-your-life/)
* [WordPress › Automated Testing « Make WordPress Core](http://make.wordpress.org/core/handbook/automated-testing/)
* [Documentation for PHPUnit – The PHP Testing Framework](http://phpunit.de/documentation.html)
* [/trunk/tests/phpunit](http://develop.svn.wordpress.org/trunk/tests/phpunit/)

{{ site.scroll_to_top }}

## Changelog

### 1.2

[https://github.com/miya0001/vccw/compare/1.1...1.2](https://github.com/miya0001/vccw/compare/1.1...1.2)

* Add Composer
* Setup the plugin unit tests suite automatically.

### 1.1

[https://github.com/miya0001/vccw/compare/1.0...1.1](https://github.com/miya0001/vccw/compare/1.0...1.1)

* Add Grunt
* Upgrade PHP5.3 to PHP5.4

### 1.0

* Add PHPUnit
* Some fix


{{ site.scroll_to_top }}
