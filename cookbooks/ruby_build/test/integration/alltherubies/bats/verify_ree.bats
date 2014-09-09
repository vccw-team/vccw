#!/usr/bin/env bats

export ruby_root="/usr/local/ruby/ree-1.8.7-2012.02"
export def="$(basename $ruby_root)"

load _verify_tests

@test "ruby $def can use openssl from stdlib" {
  run_openssl_test
}

@test "ruby $def can install nokogiri gem" {
  run_nokogiri_install_test
}

# pending
# @test "ruby $def can use nokogiri with openssl" {
#   run_nokogiri_openssl_test
# }
