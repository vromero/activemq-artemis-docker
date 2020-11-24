
.PHONY: help build test run all

VERSIONS_FILE=tags.csv

ALL_VERSION_TAGS=$(shell awk -F "," 'NR>1  {print $$2}' ${VERSIONS_FILE})
lookupFromTag=$(shell awk -F "," '$$2 == "$1" {print $$$2}' ${VERSIONS_FILE})
lookupRepositoryFromTag=$(call lookupFromTag,$1, 1)
lookupBaseImageFromTag=$(call lookupFromTag,$1, 3)
lookupÀliasesFromTag=$(call lookupFromTag,$1, 4)
lookupDockerfileFromTag=$(call lookupFromTag,$1, 5)

getPart=$(word $2,$(subst -, ,$1))
getVersionFromTag=$(call getPart,$1, 1)
getVariantFromTag=$(call getPart,$1, 2)
getFullTagNameFromTag=$(call lookupRepositoryFromTag,$1):$(call getVersionFromTag,$1)$(if $(call getVariantFromTag,$1),-$(call getVariantFromTag,$1),"")

%: build_% test_% tag_%
	

build_%:
	@cd src && \
	echo Building version $* && \
	docker build --quiet --build-arg ACTIVEMQ_ARTEMIS_VERSION=$(call getVersionFromTag,$*) --build-arg BASE_IMAGE=$(call lookupBaseImageFromTag,$*) $(BUILD_ARGS) -t $(call getFullTagNameFromTag,$*) -f $(call lookupDockerfileFromTag,$*) .

tag_%:
	@for alias in $(call lookupÀliasesFromTag,$*); do docker tag $(call getFullTagNameFromTag,$*) $$alias ; done

push_%:
	@docker push $(call getFullTagNameFromTag,$*)
	@for alias in $(call lookupÀliasesFromTag,$*); do docker push $$alias ; done

run_%: build
	docker run -i -t --rm $(call getFullTagNameFromTag,$*)

runsh_%: build
	docker run -i -t --rm $(call getFullTagNameFromTag,$*) /bin/sh

all: $(ALL_VERSION_TAGS)

test_%:
	@DOCKER_FILE=$(call lookupDockerfileFromTag,$*) COORDINATES=$(call getFullTagNameFromTag,$*) ACTIVEMQ_ARTEMIS_VERSION=$(call getVersionFromTag,$*) TAG=$* bats test/*.bats
	@echo

	
