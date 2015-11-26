# VCCW

This is a Vagrant configuration designed for development of WordPress plugins, themes, or websites.

To get started, check out <http://vccw.cc/>

## Configuration

1. Copy `provision/default.yml` to `site.yml`.
1. Edit the `site.yml`.
1. Run `vagrant up`.

### Note

* The `site.yml` has to be in the same directory with Vagrantfile.
* You can put just difference to the `site.yml`.

## Contribute

### Setting up

1. Clone this git repository on your local machine.
2. Run `bundle install` to fetch all dependencies.

### Running and writing tests

There is automated tests using [Serverspec](http://serverspec.org/).

The tests files are in the `spec/` directory.


Before running the serverspec tests, you'll need some dependencies.

```
$ bundle install --path=vendor/bundle
```

Then to run the tests, just execute following.

```
$ bundle exec rake spec
```
