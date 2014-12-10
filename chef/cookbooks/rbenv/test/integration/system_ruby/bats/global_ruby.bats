#!/usr/bin/env bats

global_ruby="2.1.1"
https_url="https://google.com"

setup() {
  unset GEM_HOME
  unset GEM_PATH
  unset GEM_CACHE
  source /etc/profile.d/rbenv.sh
}

@test "installs $global_ruby" {
  run rbenv versions --bare
  [ $status -eq 0 ]
  [ $(echo "$output" | grep "^$global_ruby$") = "$global_ruby" ]
}

@test "sets $global_ruby as the global Ruby" {
  run rbenv global
  [ $status -eq 0 ]
  [ $output = "$global_ruby" ]
}

@test "global Ruby can use openssl from stdlib" {
  expr="puts OpenSSL::PKey::RSA.new(32).to_pem"
  export RBENV_VERSION=$global_ruby
  run ruby -ropenssl -e "$expr"
  [ $status -eq 0 ]
}

@test "global Ruby can install nokogiri gem" {
  export RBENV_VERSION=$global_ruby
  run gem install nokogiri --no-ri --no-rdoc
  [ $status -eq 0 ]
}

@test "global Ruby can use nokogiri with openssl" {
  export RBENV_VERSION=$global_ruby
  expr="puts Nokogiri::HTML(open('$https_url')).css('input')"
  run ruby -ropen-uri -rnokogiri -e "$expr"
  [ $status -eq 0 ]
}
