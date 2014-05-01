# rbenv cookbook

Installs and manages your versions of Ruby and Gems in Chef with rbenv and ruby_build

* [rbenv](https://github.com/sstephenson/rbenv)
* [ruby_build](https://github.com/sstephenson/ruby-build)

# Requirements

* Chef 10
* Centos / Redhat / Fedora / Ubuntu / Debian
* Ruby >= 1.9

# Usage

Add a dependency on rbenv to your cookbook's `metadata.rb`

    depends 'rbenv'

## Installing rbenv and ruby_build

To install rbenv and ruby_build; Include each recipe in one of your cookbook's recipes

    include_recipe "rbenv::default"
    include_recipe "rbenv::ruby_build"

## Installing rbenv-vars

To install rbenv-vars; Include this recipe in one of your cookbook's recipes

    include_recipe "rbenv::rbenv_vars"

## Installing a Ruby

And now to install a Ruby use the `rbenv_ruby` LWRP

    rbenv_ruby "1.9.3-p194"

## Installing Gems for rbenv managed Rubies

If you'd like a specific Ruby installed by rbenv to include a Gem, say bundler, use the `rbenv_gem` LWRP

    rbenv_gem "bundler" do
      ruby_version "1.9.3-p194"
    end

Be sure to include a value for the `ruby_version` attribute so the gem is installed for the correct Ruby

# Attributes

## rbenv

* `rbenv[:group_users]`     - Array of users belonging to the rbenv group
* `rbenv[:git_repository]`  - Git url of the rbenv repository to clone
* `rbenv[:git_revision]`    - Revision of the rbenv repository to checkout
* `rbenv[:install_prefix]`  - Path prefix rbenv will be installed into

## ruby_build

* `ruby_build[:git_repository]` - Git url of the ruby_build repository to clone
* `ruby_build[:git_revision]`   - Revision of the ruby_build repository to checkout
* `ruby_build[:prefix]`         - Path prefix where ruby_build will be installed to

# Recipes

## default

Configures a node with a system wide rbenv accessible by users in the rbenv group

## ruby_build

Installs ruby_build to a node which enables the `rbenv_ruby` LWRP to install Rubies to the node

## ohai_plugin

Installs an rbenv Ohai plugin onto the node to automatically populate attributes about the rbenv installation

# Resources / Providers

## rbenv_ruby

Install specified version of Ruby to be managed by rbenv

### Actions
Action  | Description                 | Default
------- |-------------                |---------
install | Install the version of Ruby | Yes

### Attributes
Attribute    | Description                                                 | Default
-------      |-------------                                                |---------
ruby_version | the ruby version and patch level you wish to install        | name
force        | install even if this version is already present (reinstall) | false
global       | set this ruby version as the global version                 | false

### Examples

##### Installing Ruby 1.9.2-p290

    rbenv_ruby "1.9.2-p290"

##### Forcefully install Ruby 1.9.3-p0

    rbenv_ruby "Ruby 1.9.3" do
      ruby_version "1.9.3-p0"
      force true
    end

## rbenv_gem

Install specified RubyGem for the specified ruby_version managed by rbenv

### Actions

Action  | Description                           | Default
------- |-------------                          |---------
install | Install the gem                       | Yes
upgrade | Upgrade the gem to the given version  |
remove  | Remove the gem                        |
purge   | Purge the gem and configuration files |

### Attributes

Attribute     | Description                                        | Default
-------       |-------------                                       |---------
package_name  | Name of given to modify                            | name
ruby_version  | Ruby of version the gem belongs to                 |
version       | Version of the gem to modify                       |
source        | Specified if you have a local .gem file to install |
gem_binary    | Override for path to gem command                   |
response_file |                                                    |
options       | Additional options to the underlying gem command   |

### Examples

##### Installing Bundler for Ruby 1.9.2-p290

    rbenv_gem "bundler" do
      ruby_version "1.9.2-p290"
    end

## rbenv_execute

Safely execute shell commands with RBENV and a particular Ruby activated

### Actions

Action | Description     | Default
-------|-------------    |---------
run    | Run the command | Yes

### Attributes

Attribute    | Description
----------   |------------
command      | The name of the command to be executed
creates      | Indicates that a command to create a file will not be run when that file already exists
cwd          | The current working directory from which a command is run
environment  | A hash of environment variables. These will be automatically merged with the required RBENV environment variables
group        | The group name or group ID that must be changed before running a command
path         | An array of paths to use when searching for a command. These paths will be added to the command's environment `$PATH` and the required RBENV path variables
returns      | The return value for a command. This may be an array of accepted values. An exception is raised when the return value(s) do not match
ruby_version | The version of Ruby to activate when running the command
timeout      | The amount of time (in seconds) a command will wait before timing out
user         | The user name or user ID that should be changed before running a command
umask        | The file mode creation mask, or umask

# Releasing

1. Install the prerequisite gems

        $ bundle install

2. Increment the version number in the metadata.rb file

3. Run the Thor release task to create a tag and push to the community site

        $ bundle exec thor release

# Authors and Contributors

* Jamie Winsor (<jamie@vialstudios.com>)
