## 0.7.1 (unreleased)


## 0.7.2 (December 31, 2012)

### Bug Fixes

* Pull request [#26](https://github.com/fnichol/chef-rbenv/pull/26): Don't
  call libexec commands directly. ([@mhoran][])

### Improvements

* Add integration tests for a system Ruby version. ([@fnichol][])


## 0.7.0 (November 21, 2012)

### Bug Fixes

* Issue [#14](https://github.com/fnichol/chef-rbenv/pull/14): Create
  /etc/profile.d on system-wide and add note for Mac. ([@fnichol][])

### New features

* Pull request [#20](https://github.com/fnichol/chef-rbenv/pull/20): Set an
  attribute to create profile.d for user install. ([@jtimberman][])

### Improvements

* Pull request [#12](https://github.com/fnichol/chef-rbenv/pull/12): Add name
  attribute to metadata. ([@jtimberman][])
* Update foodcritic configuration and update .travis.yml. ([@fnichol][])
* Update Installation section of README (welcome Berkshelf). ([@fnichol][])


## 0.6.10 (May 18, 2012)

### New features

* Pull request [#11](https://github.com/fnichol/chef-rbenv/pull/11): Add
  FreeBSD support. ([@jssjr][])

### Improvements

* Add other platform supports in metadata.rb and README. ([@fnichol][])


## 0.6.8 (May 6, 2012)

### Improvements

* Add official hook resource log[rbenv-post-init-\*] for inter-cookbook
  integration. ([@fnichol][])


## 0.6.6 (May 4, 2012)

### Bug Fixes

* Fix FC022: Resource condition within loop may not behave as expected.
  ([@fnichol][])
* Add plaform equivalents in default attrs (FC024). ([@fnichol][])
* Ensure update-java-alternatives is called before JRuby is built.
  ([@fnichol][])
* Pull request [#8](https://github.com/fnichol/chef-rbenv/pull/8): Add
  /etc/profile.d/rbenv.sh support for user installs. ([@thoughtless][])

### Improvements

* Add TravisCI to run Foodcritic linter. ([@fnichol][])
* Pull request [#10](https://github.com/fnichol/chef-rbenv/pull/10): README
  proofreading. ([@jdsiegel][])
* README updates. ([@fnichol][])
* Confirm debian platform support. ([@fnichol][])


## 0.6.4 (February 23, 2012)

### Bug Fixes

* Set `root_path` on rbenv\_rehash in rbenv\_gem provider. ([@fnichol][])

### Improvements

* Foodcritic lint-driven code updates. ([@fnichol][])
* Update Git URL in README. ([@hedgehog][])


## 0.6.2 (February 22, 2012)

### Bug Fixes

* Issues [#1](https://github.com/fnichol/chef-rbenv/issues/1),
  [#2](https://github.com/fnichol/chef-rbenv/issues/2): Stub mixins in
  RbenvRubygems to avoid libraries load ordering issues. ([@fnichol][])
* Pull request [#5](https://github.com/fnichol/chef-rbenv/pull/5): Include
  user setting in rehash calls. ([@magnetised][])
* Issue [#4](https://github.com/fnichol/chef-rbenv/issues/4): Fix rbenv/gems
  hash parsing. ([@fnichol][])

### Improvements

* Large formatting updates to README. ([@fnichol][])
* Add gh-pages branch for sectioned README at
  https://fnichol.github.com/chef-rbenv


## 0.6.0 (December 21, 2011)

The initial release.

[@fnichol]: https://github.com/fnichol
[@jdsiegel]: https://github.com/jdsiegel
[@jssjr]: https://github.com/jssjr
[@jtimberman]: https://github.com/jtimberman
[@hedgehog]: https://github.com/hedgehog
[@magnetised]: https://github.com/magnetised
[@mhoran]: https://github.com/mhoran
[@thoughtless]: https://github.com/thoughtless
