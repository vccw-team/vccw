#!/usr/bin/env bats

setup() {
  source /etc/profile.d/rbenv.sh
}

@test "installs rbenv vars" {
  rbenv vars
}
