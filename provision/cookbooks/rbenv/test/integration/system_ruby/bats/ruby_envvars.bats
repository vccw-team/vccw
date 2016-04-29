#!/usr/bin/env bats
# To build ree properly, a configure flag needs to be passed to the install
# command, which makes for a good test case. If ree does not build properly,
# it will fails these tests. For more background, see:
# https://github.com/sstephenson/rbenv/issues/297

rubie="ree-1.8.7-2012.02"

setup() {
  unset GEM_HOME
  unset GEM_PATH
  unset GEM_CACHE
  source /etc/profile.d/rbenv.sh
}

@test "$rubie can use nokogiri with openssl" {
  export RBENV_VERSION=$rubie
  https_url="https://google.com"
  requires="require 'nokogiri';"
  script="$requires puts Nokogiri::HTML(open('$https_url')).css('input')"

  run gem install nokogiri -v 1.5.11 --no-document
  [ $status -eq 0 ]

  run ruby -rrubygems -ropen-uri -e "$script"
  [ "$status" -eq 0 ]
}
