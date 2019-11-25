
.PHONY: help build test run all

VERSIONS_FILE=tags.csv

ALL_VERSION_TAGS=$(shell awk -F "," 'NR>2  {print $$2}' ${VERSIONS_FILE})
lookupFromTag=$(shell awk -F "," '$$2 == "$1" {print $$$2}' ${VERSIONS_FILE})
lookupRepositoryFromTag=$(call lookupFromTag,$1, 1)
lookupBaseImageFromTag=$(call lookupFromTag,$1, 3)
lookupÀliasesFromTag=$(call lookupFromTag,$1, 4)
lookupDockerfileFromTag=$(call lookupFromTag,$1, 5)

getPart=$(word $2,$(subst -, ,$1))
getVersionFromTag=$(call getPart,$1, 1)
getVariantFromTag=$(call getPart,$1, 2)
getFullTagNameFromTag=$(call lookupRepositoryFromTag,$1):$(call getVersionFromTag,$1)$(if $(call getVariantFromTag,$1),-$(call getVariantFromTag,$1),"")

# Temporary directories have to have 777 just in case this is run by a user different than 1000:1000
# See the following for more info: https://github.com/moby/moby/issues/7198
TMP_DIR = $(shell DIR=$$(mktemp -d) && chmod 777 -R $${DIR} && echo $${DIR})

%: testdockerfile_% testentrypoint_% build_% test_% tag_%
	

build_%:
	cd src && \
	docker build --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call getVersionFromTag,$*) --build-arg BASE_IMAGE=$(call lookupBaseImageFromTag,$*) $(BUILD_ARGS) -t $(call getFullTagNameFromTag,$*) -f $(call lookupDockerfileFromTag,$*) .

testentrypoint_%:
	shellcheck --version
	shellcheck src/assets/docker-entrypoint.sh

tag_%:
	for alias in $(call lookupÀliasesFromTag,$*); do docker tag $(call getFullTagNameFromTag,$*) $$alias ; done

push_%:
	docker push $(call getFullTagNameFromTag,$*)
	for alias in $(call lookupÀliasesFromTag,$1); do docker push $$alias ; done

run_%: build
	docker run -i -t --rm $(call getFullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call getFullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

testdockerfile_%:
	cd src && \
	docker run --rm -i hadolint/hadolint < $(call lookupDockerfileFromTag,$*)

test_%: test_can_run_% test_can_set_username_password_% test_can_autorun_perf_journal_% test_can_skip_perf_journal_% test_can_enable_jmx_% test_can_enable_jmx_exporter_% test_can_enable_jmx_exporter_with_custom_config_% test_can_set_memory_limits_% test_can_disable_security_% test_can_disable_security_% test_can_override_etc_% test_can_override_etc_% test_can_set_critical_analyzer_%
	

test_can_run_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_username_password_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_autorun_perf_journal_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=AUTO $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_skip_perf_journal_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=NEVER $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_exporter_with_custom_config_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true -e TEST_CUSTOM_JMX_EXPORTER_CONFIG=true -v $$(pwd)/test/etc-override:/opt/jmx-exporter/etc-override $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_critical_analyzer_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e CRITICAL_ANALYZER=false -e CRITICAL_ANALYZER_TIMEOUT=123 -e CRITICAL_ANALYZER_CHECK_PERIOD=456 -e CRITICAL_ANALYZER_POLICY=LOG $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_exporter_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 \
		-e JAVA_OPTS="-Dmyjavaopt=yes" -e BROKER_CONFIG_GLOBAL_MAX_SIZE=9500 $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_memory_limits_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_MIN_MEMORY=1512M -e ARTEMIS_MAX_MEMORY=3048M $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_disable_security_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e DISABLE_SECURITY=true $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_override_etc_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars-etc-override.yaml" dgoss run -it --rm -h testHostName.local -v $$(pwd)/test/$$(echo "$*" | cut -d "." -f 1).x.x/etc-override:/var/lib/artemis/etc-override $(call getFullTagNameFromTag,$*) > /dev/null 2>&1

test_can_override_etc_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -v "$(TMP_DIR):/var/lib/artemis/etc" -e RESTORE_CONFIGURATION=true $(call getFullTagNameFromTag,$*) > /dev/null 2>&1
