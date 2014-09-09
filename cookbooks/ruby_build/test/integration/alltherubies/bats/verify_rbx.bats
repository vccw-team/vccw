#!/usr/bin/env bats

export ruby_root="/usr/local/ruby/rbx-2.0.0-rc1"
export def="$(basename $ruby_root)"

load _verify_tests

@test "ruby $def can use openssl from stdlib" {
  run_openssl_test
}

@test "ruby $def can install nokogiri gem" {
  run_nokogiri_install_test
}

@test "ruby $def can use nokogiri with openssl" {
  run_nokogiri_openssl_test
}
