#!/usr/bin/env bats

export ruby_root="/usr/local/ruby/jruby-1.7.1"
export def="$(basename $ruby_root)"

load _verify_tests

@test "Ruby $def can use openssl from stdlib" {
  run gem install jruby-openssl --no-ri --no-rdoc
  [ $status -eq 0 ]
  run_openssl_test
}

@test "Ruby $def can install nokogiri gem" {
  run_nokogiri_install_test
}

@test "Ruby $def can use nokogiri with openssl" {
  run_nokogiri_openssl_test
}
