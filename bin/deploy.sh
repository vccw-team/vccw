#!/usr/bin/env bash

set -eux

rm -fr .git
rm -fr .github
rm -fr bin
rm -fr spec
rm -f .envrc
rm -f .gitattribute
rm -f .rspec
rm -f .travis.yml
rm -f Gemfile
rm -f Gemfile.lock
rm -f Rakefile

cat <<EOF > .gitignore
.DS_Store
.ansible
.bundle
.envrc
.github/
.idea/
.travis.yml
.vagrant
npm-debug.log
package.box
playbook.retry
vendor
EOF

zip -r vccw.zip .
