---
layout: default
title: VCCW - A WordPress development environment.
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
* Pre-installed tools
    * [WP-CLI](http://wp-cli.org)
        * [Dictator](https://github.com/danielbachhuber/dictator)
    * [Grunt](http://gruntjs.com/)
    * [Composer](https://getcomposer.org/)
    * [WordPress i18n Tools](http://i18n.svn.wordpress.org/tools/trunk/)
    * [PHPUnit](http://phpunit.de/)
        * [WordPress Unit Tests](http://develop.svn.wordpress.org/trunk/tests/phpunit/)
    * [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
        * [WordPress Coding Standards for PHP_CodeSniffer](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)
    * [WordMove](https://github.com/welaika/wordmove)
* Shares folders between Host and Guest OS

### It is very easy to switch your WordPress environments.

It is enabled to switch theme.

```
$ wp_theme=http://example.com/path/to/your-theme.zip vagrant provision
```

WordPress version.

```
$ wp_version=3.5.2 vagrant provision
```

Languages.

```
$ wp_lang=ja vagrant provision
```

So, switching back is easy too.

```
$ vagrant provision
```


{{ site.scroll_to_top }}


## Getting Started

### 1. Install VirtualBox.

[https://www.virtualbox.org/](https://www.virtualbox.org/)

### 2. Install Vagrant.

[http://www.vagrantup.com/](http://www.vagrantup.com/)

### 3. Install the vagrant-hostsupdater plugin. (Optional)

```
$ vagrant plugin install vagrant-hostsupdater
```

Windows is not allow to change hosts-file. Please add 'wordpress.local 192.168.31.10' by yourself!

### 4. Please download <a class="latest-zipball">.zip</a> or <a class="latest-tarball">.tar.gz</a>.

<a class="button latest-zipball" style="float: left;"><small>Download</small>.zip</a>
<a class="button latest-tarball" style="float: left;"><small>Download</small>.tar.gz</a>

<br clear="all" />

or

```
$ git clone git@github.com:miya0001/vccw.git
```

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

## Requires

* Vagrant 1.5 or later
* VirtualBox 4.3 or later

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
* [WP-CLI](http://wp-cli.org)
* [Grunt](http://gruntjs.com/)
* [Composer](https://getcomposer.org/)
* [WordPress i18n Tools](http://i18n.svn.wordpress.org/tools/trunk/)
* [PHPUnit](http://phpunit.de/)
    * [WordPress Unit Tests](http://develop.svn.wordpress.org/trunk/tests/phpunit/)
* [PHP_CodeSniffer](https://github.com/squizlabs/PHP_CodeSniffer)
    * [WordPress Coding Standards for PHP_CodeSniffer](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards)

{{ site.scroll_to_top }}

## Custom Variables

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
* `WP_HOME              = "" # path to WP_HOME, e.g blank or /wp or ...`
    * If you want to install WordPress in a subdirectory, set the directory name
    * http:// + `WP_HOSTNAME` + `WP_HOME` will be your WordPress URL.
* `WP_SITEURL           = "" # path to WP_SITEURL, e.g or /wp or ...`
    * If you want to install WordPress in a subdirectory, set the directory name in this constant (e.g. `wp` or `/wp`)
    * http:// + `WP_HOSTNAME` + `WP_SITEURL` will be your WordPress SITE URL.
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
* `WP_OPTIONS = {}`
    * WordPress options like blogname, blogdescription ...
* `WP_REWRITE_STRUCTURE = '/archives/%post_id%'`
    * WordPress permalink structure.

{{ site.scroll_to_top }}

## Run pre/post provision scripts

You can place shell scripts, so it will run at pre/post provision.

* `provision/provision-pre.sh` - Run before chef provision.
* `provision/provision-post.sh` - Run after chef provision.

### Example shcell script.

`provision/provision-post.sh`

```
#!/usr/bin/env bash

set -ex

$ cd /var/www/wordpress
$ /usr/local/bin/wp db import /vagrant/import.sql
```

{{ site.scroll_to_top }}

## For theme reviewers

You can have a clean and appropriate theme review environment very easily.

* the theme activated
* needed plugins activated ( theme-check debogger log-deprecated-notices monster-widget wordpress-beta-tester regenerate-thumbnails )
* long blogname & blogdescription set
* posts_per_page set to 5
* thread_comments set to 1
* thread_comments_depth set to 3
* page_comments set to 1
* comments_per_page to 5
* large_size_w & large_size_h set to '' (empty)
* rewrite structure '/%year%/%monthnum%/%postname%' with .htaccess generated

### 1. Go to vccw directory

```
$ cd vccw
```

### 2. Copy the Vagrantfile.theme-review

```
$ cp Vagrantfile.theme-review Vagrantfile
```

### 3. Specify the theme's zip file url and vagrant up

```
$ wp_theme=http://example.com/path/to/zipped/theme/file.zip vagrant up
```

or

```
$ wp_theme=http://example.com/path/to/zipped/theme/file.zip vagrant provision
```

## About WP-CLI

* [WP-CLI](http://wp-cli.org/) is pre-installed in this Vagrant environments.
* If you install WP-CLI in your Host OS, you can fire WP-CLI commands from the Host OS.


```
$ cd /vagrant/www/wordpress

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

* [WordPress › Automated Testing « Make WordPress Core](http://make.wordpress.org/core/handbook/automated-testing/)
* [Documentation for PHPUnit – The PHP Testing Framework](http://phpunit.de/documentation.html)
* [Nikolay Bachiyski: Unit Testing Will Change Your Life](http://wordpress.tv/2011/08/20/nikolay-bachiyski-unit-testing-will-change-your-life/)
* [Automated Testing in WordPress, Really?!](http://www.slideshare.net/ptahdunbar/automated-testing-in-wordpress-really)
* [/trunk/tests/phpunit](http://develop.svn.wordpress.org/trunk/tests/phpunit/)

{{ site.scroll_to_top }}

## WordMove - Multistaging deploy for WordPress

### Edit Movefile

Movefile will be generated automatically, so you can start quickly.

[https://github.com/welaika/wordmove](https://github.com/welaika/wordmove)

### Deploying

SSH to your vagrant.

```
$ vagrant ssh
```

Pull contents from production.

```
$ wordmove pull --all
```

Push contents to your production.

```
$ wordmove push --all
```

Options of wordmove.

```
$ wordmove help
Commands:
  wordmove help [COMMAND]  # Describe available commands or one specific command
  wordmove init            # Generates a brand new Movefile
  wordmove pull            # Pulls WP data from remote host to the local machine
  wordmove push            # Pushes WP data from local machine to remote host
```

```
$ wordmove help pull
Usage:
  wordmove pull

Options:
  -w, [--wordpress], [--no-wordpress]  
  -u, [--uploads], [--no-uploads]
  -t, [--themes], [--no-themes]
  -p, [--plugins], [--no-plugins]
  -l, [--languages], [--no-languages]  
  -d, [--db], [--no-db]
  -v, [--verbose], [--no-verbose]
  -s, [--simulate], [--no-simulate]
  -e, [--environment=ENVIRONMENT]
  -c, [--config=CONFIG]
      [--no-adapt], [--no-no-adapt]
      [--all], [--no-all]

Pulls WP data from remote host to the local machine
```

```
$ wordmove help push
Usage:
  wordmove push

Options:
  -w, [--wordpress], [--no-wordpress]  
  -u, [--uploads], [--no-uploads]
  -t, [--themes], [--no-themes]
  -p, [--plugins], [--no-plugins]
  -l, [--languages], [--no-languages]  
  -d, [--db], [--no-db]
  -v, [--verbose], [--no-verbose]
  -s, [--simulate], [--no-simulate]
  -e, [--environment=ENVIRONMENT]
  -c, [--config=CONFIG]
      [--no-adapt], [--no-no-adapt]
      [--all], [--no-all]

Pushes WP data from local machine to remote host
```

{{ site.scroll_to_top }}

## How to run serverspec

`vagrant up` with vagrant-serverspec plugin.

```
$ vagrant plugin install vagrant-serverspec
$ VAGRANT_VAGRANTFILE=Vagrantfile.sample vagrant up
```

Or use `rake`.

```
$ bundle install
$ rake spec
```

{{ site.scroll_to_top }}

## Changelog

### 1.8.0

<i class="fa fa-wrench"></i> [1.7.1...1.8.0](https://github.com/miya0001/vccw/compare/1.7.1...1.8.0)

### 1.7.1

<i class="fa fa-wrench"></i> [1.7.0...1.7.1](https://github.com/miya0001/vccw/compare/1.7.0...1.7.1)

* Add template .htaccess

### 1.7

<i class="fa fa-wrench"></i> [1.6.0...1.7.0](https://github.com/miya0001/vccw/compare/1.6.0...1.7.0)

* Add dictator.
* Add environment variables for switching WordPress.
* Add Vagrantfile.theme-review

### 1.6

<i class="fa fa-wrench"></i> [1.5.0...1.6.0](https://github.com/miya0001/vccw/compare/1.5.0...1.6.0)

* Change cookbook name `wp-cli` to `wpcli`
* It's become to sync with latest wp-cli when vagrant provision.

### 1.5

<i class="fa fa-wrench"></i> [1.4...1.5.0](https://github.com/miya0001/vccw/compare/1.4...1.5.0)

* Add serverspec testing.
* Some fix

### 1.4

<i class="fa fa-wrench"></i> [1.3...1.4](https://github.com/miya0001/vccw/compare/1.3...1.4)

* Add WordMove.
* Some fix.

### 1.3

<i class="fa fa-wrench"></i> [1.2...1.3](https://github.com/miya0001/vccw/compare/1.2...1.3)

* Add PHP_CodeSniffer.
* Add WordPress Coding Standards for PHP_CodeSniffer.

### 1.2

<i class="fa fa-wrench"></i> [1.1...1.2](https://github.com/miya0001/vccw/compare/1.1...1.2)

* Add Composer.
* Setup the plugin unit tests suite automatically.

### 1.1

<i class="fa fa-wrench"></i> [1.0...1.1](https://github.com/miya0001/vccw/compare/1.0...1.1)

* Add Grunt
* Upgrade PHP5.3 to PHP5.4

### 1.0

* Add PHPUnit
* Some fix


{{ site.scroll_to_top }}
