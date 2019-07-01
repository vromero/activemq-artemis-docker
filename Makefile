
.PHONY: help build test run all

# All the versions supported, useful to build all versions locally with a single command
ALL_VERSIONS=1.1.0 1.2.0 1.3.0 1.4.0 1.5.0 1.5.1 1.5.2 1.5.3 1.5.4 1.5.5 1.5.6 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0 2.6.0 2.6.1 2.6.2 2.6.3 2.6.4 2.7.0 2.8.0 2.9.0
# Variants supported for each version
ALL_VARIANTS=default alpine
# All pairs of versions-variants. `default` will not appear in the tag for the rest an `-variant` will be added
ALL_VERSION_TAGS=$(foreach remdefault, $(foreach aver, $(ALL_VERSIONS), $(foreach avar, $(ALL_VARIANTS), $(aver)-$(avar) ) ), $(remdefault:-default=) )

getPart=$(word $2,$(subst -, ,$1))
versionFromTag=$(call getPart,$1, 1)
variantFromTag=$(call getPart,$1, 2)
dockerfileFromTag="Dockerfile$(and $(call getPart,$1,2),.$(call getPart,$1,2))"

fullTagNameFromTag=vromero/activemq-artemis:$(call versionFromTag,$1)$(if $(call variantFromTag,$1),-$(call variantFromTag,$1),"")

# If an environment variable `ALIASES` is present, this will return space-separated full image coordinates from each space-separated element in there
# This is useful to not to repeat builds for aliases like latest or 2.4-latest
fullAliasesTagNames=$(foreach var,${ALIASES}, vromero/activemq-artemis:$(var))

# Temporary directories have to have 777 just in case this is run by a user different than 1000:1000
# See the following for more info: https://github.com/moby/moby/issues/7198
TMP_DIR = $(shell DIR=$$(mktemp -d) && chmod 777 -R $${DIR} && echo $${DIR})

%: testdockerfile_% testentrypoint_% build_% test_% tag_%
	

build_%:
	cd src && \
	docker build --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call versionFromTag,$*) $(BUILD_ARGS) -t $(call fullTagNameFromTag,$*) -f $(call dockerfileFromTag,$*) .

testentrypoint_%:
	shellcheck --version
	shellcheck src/assets/docker-entrypoint.sh

tag_%:
	for alias in $(call fullAliasesTagNames); do docker tag $(call fullTagNameFromTag,$*) $$alias ; done

push_%:
	docker push $(call fullTagNameFromTag,$*)
	for alias in $(call fullAliasesTagNames); do docker push $$alias ; done

run_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

testdockerfile_%:
	cd src && \
	docker run --rm -i hadolint/hadolint < $(call dockerfileFromTag,$*)

test_%: test_can_run_% test_can_set_username_password_% test_can_autorun_perf_journal_% test_can_skip_perf_journal_% test_can_enable_jmx_% test_can_enable_jmx_exporter_% test_can_enable_jmx_exporter_with_custom_config_% test_can_set_memory_limits_% test_can_disable_security_% test_can_disable_security_% test_can_override_etc_% test_can_override_etc_%
	

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
