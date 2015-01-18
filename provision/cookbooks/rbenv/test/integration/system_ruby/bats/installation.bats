#!/usr/bin/env bats

@test "creates profile.d file" {
  [ -f "/etc/profile.d/rbenv.sh" ]
}

@test "creates rbenv directory" {
  [ -d "/usr/local/rbenv" ]
}

@test "loads environment" {
  source /etc/profile.d/rbenv.sh
  [ "$(type rbenv | head -1)" = "rbenv is a function" ]
}
