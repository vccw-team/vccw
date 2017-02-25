#!/usr/bin/env bash

set -eux

rm -fr .bundle
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
rm -f Movefile
rm -f Rakefile
rm -fr vendor

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
EOF

sed -e "s/vccw_version = 'nightly';/vccw_version = '${TRAVIS_TAG}';/" Vagrantfile > Vagrantfile.tmp
mv Vagrantfile.tmp Vagrantfile

cd ..
zip -r vccw-${TRAVIS_TAG}.zip vccw
mv vccw-${TRAVIS_TAG}.zip vccw/
cd vccw
