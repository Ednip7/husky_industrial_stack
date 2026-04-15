# Load environment variables from .env file
ifneq (,$(wildcard ./.env))
    include .env
    export
endif

# Default user and group IDs if not specified in .env
USER_ID ?= $(shell id -u)
GROUP_ID ?= $(shell id -g)

.PHONY: build up shell stop clean

# Build the development image with host user mapping
build:
	docker compose build --build-arg USER_ID=$(USER_ID) --build-arg GROUP_ID=$(GROUP_ID)

# Start the environment and grant X11 access for GUI apps
up:
	xhost +local:docker > /dev/null
	docker compose up -d

# Open an interactive shell in the running container
shell:
	docker compose exec -it dev_container /bin/bash

# Shut down the environment and revoke X11 access
stop:
	docker compose down
	xhost -local:docker > /dev/null

# Remove ROS 2 build artifacts to ensure a fresh build
clean:
	rm -rf build/ install/ log/