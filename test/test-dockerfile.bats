#!/usr/bin/env bats

@test "docker file must pass lint" {
	cd src && docker run --rm -i hadolint/hadolint < ${DOCKER_FILE}
}
