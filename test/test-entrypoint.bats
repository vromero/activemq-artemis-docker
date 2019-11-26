#!/usr/bin/env bats

@test "docker-entrypoint.sh must be a valid posix script" {
  shellcheck src/assets/docker-entrypoint.sh
}
