IMAGE_NAME=ghcr.io/e-learning-by-sse/dev-env-javascript
INSTALL_FISH=false
INSTALL_DOCKER=false
INSTALL_NODEJS=false

# Override the default values if the flags are set
ifdef FISH
    INSTALL_FISH=true
endif

ifdef DOCKER
    INSTALL_DOCKER=true
endif

ifdef NODEJS
    INSTALL_NODEJS=true
endif

# Default tag if IMAGE_TAG is not set
ifdef IMAGE_TAG
    TAG=$(IMAGE_TAG)
else
    TAG=latest
endif

# Split TAG into an array
TAGS_ARRAY=$(shell echo $(TAG) | tr ',' ' ')

# Build the Docker image
.PHONY: image
image:
	@echo "Building Docker image with:"
	@echo "  - INSTALL_FISH=$(INSTALL_FISH)"
	@echo "  - INSTALL_DOCKER=$(INSTALL_DOCKER)"
	@echo "  - INSTALL_NODEJS=$(INSTALL_NODEJS)"
	@echo "  - TAGS=$(TAGS_ARRAY)"
	# Build the image with the first tag
	docker build \
		--build-arg INSTALL_FISH=$(INSTALL_FISH) \
		--build-arg INSTALL_DOCKER=$(INSTALL_DOCKER) \
		--build-arg INSTALL_NODEJS=$(INSTALL_NODEJS) \
		-t $(IMAGE_NAME):$(firstword $(TAGS_ARRAY)) .
	# Tag the image with all specified tags
	for tag in $(wordlist 2,$(words $(TAGS_ARRAY)),$(TAGS_ARRAY)); do \
		echo "Tagging image with: $$tag"; \
		docker tag $(IMAGE_NAME):$(firstword $(TAGS_ARRAY)) $(IMAGE_NAME):$$tag; \
	done

# Publish the Docker image with optional tags
.PHONY: publish
publish:
	@echo "Publishing Docker image with tags: $(TAGS_ARRAY)"
	for tag in $(TAGS_ARRAY); do \
		echo "Publishing tag: $$tag"; \
		docker push $(IMAGE_NAME):$$tag; \
	done
