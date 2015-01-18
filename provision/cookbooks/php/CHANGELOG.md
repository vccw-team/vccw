php Cookbook CHANGELOG
======================
This file is used to list changes made in each version of the php cookbook.


v1.2.4
------
### Improvement
- **[COOK-3047](https://tickets.opscode.com/browse/COOK-3047)** - Sort directives in `php.ini`
- **[COOK-2928](https://tickets.opscode.com/browse/COOK-2928)** - Abstract `php.ini` directives into variables

### Bug
- **[COOK-2378](https://tickets.opscode.com/browse/COOK-2378)** - Fix `php_pear` for libevent

v1.2.2
------
### Bug
- [COOK-3050]: `lib_dir` declared in wrong place for redhat
- [COOK-3102]: remove fileinfo recipe from php cookbook

### Improvement
- [COOK-3101]: use a method to abstract range of "el 5" versions in php recipes

v1.2.0
------
### Improvement
- [COOK-2516]: Better support for SUSE distribution for php cookbook
- [COOK-3035]: update php::source to install 5.4.15 by default

### Bug
- [COOK-2463]: PHP PEAR Provider Installs Most Recent Version, Without Respect to Preferred State
- [COOK-2514]: php_pear: does not handle more exotic version strings

v1.1.8
------
- [COOK-1998] - Enable override of PHP packages in attributes

v1.1.6
------
- [COOK-2324] - adds Oracle linux support

v1.1.4
------
- [COOK-2106] - `php_pear` cannot find available packages

v1.1.2
------
- [COOK-1803] - use better regexp to match package name
- [COOK-1926] - support Amazon linux

v1.1.0
------
- [COOK-543] - php.ini template should be configurable
- [COOK-1067] - support for PECL zend extensions
- [COOK-1193] - update package names for EPEL 6
- [COOK-1348] - rescue Mixlib::ShellOut::ShellCommandFailed (chef 0.10.10)
- [COOK-1465] - fix pear extension template

v1.0.2
------
- [COOK-993] Add mhash-devel to centos php source libs
- [COOK-989] - bump version of php to 5.3.10
- Also download the .tar.gz instead of .tar.bz2 as bzip2 may not be in the base OS (e.g., CentOS 6 minimal)
