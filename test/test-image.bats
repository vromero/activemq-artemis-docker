#!/usr/bin/env bats

@test "docker container can run with no arguments" {
  	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local ${COORDINATES}
}

@test "docker container can have JSON output" {

	# Only 2.10 and later supported
  	if $(echo "${ACTIVEMQ_ARTEMIS_VERSION}" | grep -Eq "1\.[0-9]+\.[0-9]+|2\.[0-9]{1}.[0-9]+"); then
		skip
		return
	fi

	export UUID="$(uuidgen)"
	
	docker run -d --name "$UUID" -h testHostName.local -e LOG_FORMATTER=JSON ${COORDINATES}
    
	n=0; until [ "$n" -ge 5 ]
   	do
        sleep 2
       	[ "$(docker logs --tail 1 $UUID | jq -r '.hostName')" = "testhostname.local" ] && break
       	n=$((n+1))
   	done
    
	docker stop "$UUID"
   	[ $n -lt 5 ]
}

@test "docker container can set username and password" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword ${COORDINATES}
}

@test "docker container can set java opts" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e "JAVA_OPTS=-Djavax.net.ssl.keyStore=/var/lib/artemis/etc/keystore.jks -Djavax.net.ssl.keyStorePassword=changeit" ${COORDINATES}
}

@test "docker container can autorun performance journal tuning" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=AUTO ${COORDINATES}
}

@test "docker container can skip performance journal tuning" {
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=NEVER ${COORDINATES}
}

@test "docker container can enable JMX" {
  	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 -e BROKER_CONFIG_GLOBAL_MAX_SIZE=9500 ${COORDINATES}
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
	# Seems like Docker plays well with the Apple's filesystem sandbox guidelines but mktemp doesn't?
	# Using mkdir instead of mktemp
	# see: https://stackoverflow.com/questions/45122459/docker-mounts-denied-the-paths-are-not-shared-from-os-x-and-are-not-known
  	TMP_DIR=$(mkdir -p tmp)
	GOSS_FILES_PATH=$BATS_TEST_DIRNAME/assets GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -v "${TMP_DIR}:/var/lib/artemis/etc" -e RESTORE_CONFIGURATION=true ${COORDINATES}
	rm -Rf "${TMP_DIR}"
}

