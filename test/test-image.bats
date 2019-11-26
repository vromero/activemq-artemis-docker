#!/usr/bin/env bats

@test "docker container can run with no arguments" {
  	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local ${COORDINATES}
}

@test "docker container can set username and password" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword ${COORDINATES}
}

@test "docker container can autorun performance journal tuning" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=AUTO ${COORDINATES}
}

@test "docker container can skip performance journal tuning" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=NEVER ${COORDINATES}
}

@test "docker container can enable JMX" {
  	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 -e JAVA_OPTS="-Dmyjavaopt=yes" -e BROKER_CONFIG_GLOBAL_MAX_SIZE=9500 ${COORDINATES}
}

@test "docker container can enable JMX exporter" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true ${COORDINATES}
}

@test "docker container can enable JMX exporter with custom config" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true -e TEST_CUSTOM_JMX_EXPORTER_CONFIG=true -v $BATS_TEST_DIRNAME/assets/etc-override:/opt/jmx-exporter/etc-override ${COORDINATES}
}

@test "docker container can set critical analyzer" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e CRITICAL_ANALYZER=false -e CRITICAL_ANALYZER_TIMEOUT=123 -e CRITICAL_ANALYZER_CHECK_PERIOD=456 -e CRITICAL_ANALYZER_POLICY=LOG ${COORDINATES}
}

@test "docker container can set memory limits" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_MIN_MEMORY=1512M -e ARTEMIS_MAX_MEMORY=3048M ${COORDINATES}
}

@test "docker container can disable security" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e DISABLE_SECURITY=true ${COORDINATES}
}

@test "docker container can override etc" {
  	MAYOR=$(echo "${TAG}" | cut -d "." -f 1)
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars-etc-override.yaml" dgoss run -it --rm -h testHostName.local -v $BATS_TEST_DIRNAME/assets/$MAYOR.x.x/etc-override:/var/lib/artemis/etc-override ${COORDINATES}
}

@test "docker container can replace etc" {
  	# Temporary directories have to have 777 just in case this is run by a user different than 1000:1000
  	# See the following for more info: https://github.com/moby/moby/issues/7198
  	TMP_DIR=$(DIR=$(mktemp -d) && chmod 777 -R ${DIR} && echo ${DIR})
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -v "${TMP_DIR}:/var/lib/artemis/etc" -e RESTORE_CONFIGURATION=true ${COORDINATES}
	rm -Rf "${TMP_DIR}"
}












