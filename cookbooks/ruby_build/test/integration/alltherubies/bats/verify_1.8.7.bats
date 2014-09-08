#!/usr/bin/env bats

export ruby_root="/home/app/.rubies/ruby-1.8.7-p371"
export def="$(basename $ruby_root)"

load _verify_tests

user_setup() {
  export HOME="/home/app"
  export GEM_HOME="$HOME/.gem/$RUBY_ENGINE/$RUBY_VERSION"
  export GEM_PATH="$GEM_HOME:$GEM_ROOT"
  export PATH="$GEM_HOME/bin:$GEM_ROOT/bin:$PATH"
}

@test "ruby $def can use openssl from stdlib" {
  user_setup
  run_openssl_test
}

@test "ruby $def can install nokogiri gem" {
  user_setup
  run_nokogiri_install_test
}

# pending
# @test "ruby $def can use nokogiri with openssl" {
#   user_setup
#   run_nokogiri_openssl_test
# }
