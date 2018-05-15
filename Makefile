
.PHONY: help build test run all

ALL_VERSIONS=1.1.0 1.2.0 1.3.0 1.4.0 1.5.0 1.5.1 1.5.2 1.5.3 1.5.4 1.5.5 2.0.0 2.1.0 2.2.0 2.3.0 2.4.0 2.5.0
ALL_VARIANTS=default alpine
ALL_VERSION_TAGS=$(foreach remdefault, $(foreach aver, $(ALL_VERSIONS), $(foreach avar, $(ALL_VARIANTS), $(aver)-$(avar) ) ), $(remdefault:-default=) )

getPart=$(word $2,$(subst -, ,$1))
versionFromTag=$(call getPart,$1, 1)
fullTagNameFromTag=vromero/activemq-artemis:$(or ${TAG},$1)
dockerfileFromTag="Dockerfile$(and $(call getPart,$1,2),.$(call getPart,$1,2))"

%: testdockerfile_% testentrypoint_% build_% test_% 
	

build_%:
	cd src && \
	docker build --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call versionFromTag,$*) -t $(call fullTagNameFromTag,$*) -f $(call dockerfileFromTag,$*) .

test_%: 
	cd test && \
	dgoss run -it --rm $(call fullTagNameFromTag,$*) && \
	dgoss run -it --rm -e ARTEMIS_USERNAME=myusername -e ARTEMIS_PASSWORD=mypassword $(call fullTagNameFromTag,$*) && \
	dgoss run -it --rm -e ARTEMIS_PERF_JOURNAL=AUTO $(call fullTagNameFromTag,$*) && \
	dgoss run -it --rm -e ENABLE_JMX=true -e JMX_PORT=2222 -e JMX_RMI_PORT=3333 $(call fullTagNameFromTag,$*) && \
	dgoss run -it --rm -e ARTEMIS_MIN_MEMORY=1512M -e ARTEMIS_MAX_MEMORY=3048M $(call fullTagNameFromTag,$*)

testdockerfile_%: 
	cd src && \
	docker run --rm -i hadolint/hadolint < $(call dockerfileFromTag,$*)

testentrypoint_%: 
	shellcheck src/assets/docker-entrypoint.sh

push_%: 
	docker push $(call fullTagNameFromTag,$*) 

run_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call fullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

