
.PHONY: help build test run all

ALL_VERSIONS=1.1.0 1.2.0 1.3.0 1.4.0 1.5.0 1.5.1 1.5.2 1.5.3 1.5.4 1.5.5 1.5.6 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0 2.6.0 2.6.1 2.6.2
ALL_VARIANTS=default alpine centos
ALL_VERSION_TAGS=$(foreach remdefault, $(foreach aver, $(ALL_VERSIONS), $(foreach avar, $(ALL_VARIANTS), $(aver)-$(avar) ) ), $(remdefault:-default=) )

getPart=$(word $2,$(subst -, ,$1))
versionFromTag=$(call getPart,$1, 1)
fullTagNameFromTag=vromero/activemq-artemis:$(or ${TAG},$1)
dockerfileFromTag="Dockerfile$(and $(call getPart,$1,2),.$(call getPart,$1,2))"

# Temporary directories have to have 777 just in case this is run by a user different than 1000:1000
# See the following for more info: https://github.com/moby/moby/issues/7198
TMP_DIR = $(shell DIR=$$(mktemp -d) && chmod 777 -R $${DIR} && echo $${DIR})

%: testdockerfile_% testentrypoint_% build_% test_% 
	

build_%:
	cd src && \
	docker build --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call versionFromTag,$*) -t $(call fullTagNameFromTag,$*) -f $(call dockerfileFromTag,$*) .

test_%: 
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=AUTO -e ENABLE_CLUSTER=true \
	-e CLUSTER_NAME=supercluster -e HA_ROLE=master -e HA_GROUP_NAME=myclsgrp -e CLUSTER_USER=cluser -e CLUSTER_PASSWORD=clpass \
	-e CLUSTER_URI=tcp://127.0.0.1:61616 -e CLUSTER_CONNECTIONS="tcp://localhost:61616" $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_PERF_JOURNAL=NEVER $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 -e BROKER_CONFIG_GLOBAL_MAX_SIZE=9500 $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ENABLE_JMX_EXPORTER=true $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e ARTEMIS_MIN_MEMORY=1512M -e ARTEMIS_MAX_MEMORY=3048M $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e DISABLE_SECURITY=true $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars-etc-override.yaml" dgoss run -it --rm -h testHostName.local -v $$(pwd)/test/$$(echo "$*" | cut -d "." -f 1).x.x/etc-override:/var/lib/artemis/etc-override $(call fullTagNameFromTag,$*)  && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -v "$(TMP_DIR):/var/lib/artemis/etc" -e RESTORE_CONFIGURATION=true $(call fullTagNameFromTag,$*) && \
	GOSS_FILES_PATH=$$(pwd)/test GOSS_VARS="vars.yaml" dgoss run -it --rm -h testHostName.local -e JAVA_ARGS_EXTRAS="-Dmyextraarg=myvalue" \
		-e HAWTIO_ROLE=myhawtrole -e HAWTIO_REALM=myhawtrealm \
		-e ARTEMIS_JAAS_DOMAIN=newjass -e LDAP_ENABLED=true -e LDAP_CONNECTION_URL=ldap://localhost:389 $(call fullTagNameFromTag,$*) && \
  rm -Rf tmp

testdockerfile_%: 
	cd src && \
	docker run --rm -i hadolint/hadolint < $(call dockerfileFromTag,$*)

testentrypoint_%: 
	shellcheck --version
	shellcheck src/assets/docker-entrypoint.sh

push_%: 
	docker push $(call fullTagNameFromTag,$*) 

run_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

