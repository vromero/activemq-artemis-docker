
.PHONY: help build test run all

VERSIONS_FILE=tags.csv

ALL_VERSION_TAGS=$(shell awk -F "," '{print $$1}' tags.csv)

getPart=$(word $2,$(subst -, ,$1))

# Returns the version from a tag, e.g: 1.1.0-alpine will return 1.1.0
versionFromTag=$(call getPart,$1, 1)

# Returns the variant from a tag, e.g: 1.1.0 will return nothing, 1.1.0-alpine will return alpine
variantFromTag=$(call getPart,$1, 2)

# Lookup tags.csv for a base image using the tag as key
baseImageFromTag=$(shell awk -F "," '$$1 == "$1" {print $$2}' tags.csv)

# Returns the appropriate dockerfile to build a given tag
dockerfileFromTag="Dockerfile$(and $(call getPart,$1,2),.$(call getPart,$1,2))"

# Lookup tags.csv for tag aliases using the tag as key
aliasesFromTag=$(shell awk -F "," '$$1 == "$1" {print $$3}' tags.csv)

# Returns a full tag from a given short tag, e.g: 2.6.1-alpine -> vromero/activemq-artemis:2.6.1
fullTagNameFromTag=vromero/activemq-artemis:$(call versionFromTag,$1)$(if $(call variantFromTag,$1),-$(call variantFromTag,$1),"")

# Convert aliases into full image coordinates
fullAliasesTagNames=$(foreach var,$(call aliasesFromTag,$1), vromero/activemq-artemis:$(var))

# Temporary directories have to have 777 just in case this is run by a user different than 1000:1000
# See the following for more info: https://github.com/moby/moby/issues/7198
TMP_DIR = $(shell DIR=$$(mktemp -d) && chmod 777 -R $${DIR} && echo $${DIR})

%: testdockerfile_% testentrypoint_% build_% test_% tag_%
	

build_%:
	cd src && \
	docker build --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call versionFromTag,$*) --build-arg BASE_IMAGE=$(call baseImageFromTag,$*) $(BUILD_ARGS) -t $(call fullTagNameFromTag,$*) -f $(call dockerfileFromTag,$*) .

testentrypoint_%:
	shellcheck --version
	shellcheck src/assets/docker-entrypoint.sh

tag_%:
	for alias in $(call fullAliasesTagNames,$*); do docker tag $(call fullTagNameFromTag,$*) $$alias ; done

push_%:
	docker push $(call fullTagNameFromTag,$*)
	for alias in $(call fullAliasesTagNames,$1); do docker push $$alias ; done

run_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

testdockerfile_%:
	cd src && \
	docker run --rm -i hadolint/hadolint < $(call dockerfileFromTag,$*)

test_%: test_can_run_% test_can_set_username_password_% test_can_autorun_perf_journal_% test_can_skip_perf_journal_% test_can_enable_jmx_% test_can_enable_jmx_exporter_% test_can_enable_jmx_exporter_with_custom_config_% test_can_set_memory_limits_% test_can_disable_security_% test_can_disable_security_% test_can_override_etc_% test_can_override_etc_% test_can_set_critical_analyzer_%
	

test_can_run_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_username_password_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_autorun_perf_journal_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=AUTO $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_skip_perf_journal_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=NEVER $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_exporter_with_custom_config_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true -e TEST_CUSTOM_JMX_EXPORTER_CONFIG=true -v $$(pwd)/test/etc-override:/opt/jmx-exporter/etc-override $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_critical_analyzer_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e CRITICAL_ANALYZER=false -e CRITICAL_ANALYZER_TIMEOUT=123 -e CRITICAL_ANALYZER_CHECK_PERIOD=456 -e CRITICAL_ANALYZER_POLICY=LOG $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_exporter_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_enable_jmx_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 \
		-e JAVA_OPTS="-Dmyjavaopt=yes" -e BROKER_CONFIG_GLOBAL_MAX_SIZE=9500 $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_set_memory_limits_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_MIN_MEMORY=1512M -e ARTEMIS_MAX_MEMORY=3048M $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_disable_security_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e DISABLE_SECURITY=true $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_override_etc_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars-etc-override.yaml" dgoss run -it --rm -h testHostName.local -v $$(pwd)/test/$$(echo "$*" | cut -d "." -f 1).x.x/etc-override:/var/lib/artemis/etc-override $(call fullTagNameFromTag,$*) > /dev/null 2>&1

test_can_override_etc_%:
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -v "$(TMP_DIR):/var/lib/artemis/etc" -e RESTORE_CONFIGURATION=true $(call fullTagNameFromTag,$*) > /dev/null 2>&1
