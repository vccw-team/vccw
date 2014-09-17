#!/usr/bin/env bats

@test "ruby-build binary is installed" {
  run /usr/local/bin/ruby-build --definitions
  [ $status -eq 0 ]
}
