.PHONY: clean

BINARY_NAME    ?= zookeepercli
VERSION        ?= $(shell git describe --long --tags --always --dirty  --abbrev=10)
GOLANG_VERSION ?= 1.21-alpine

CURRENT_DIR := $(shell pwd)

.prepare_cmd:
	printf "go build -x -v -o ./bin/%s -ldflags \"-X 'main.Version=%s'\"\n" "$(BINARY_NAME)" "$(VERSION)" > .prepared_cmd

build: .prepare_cmd
	sh .prepared_cmd

build_in_docker: .prepare_cmd
	docker run --rm -v "$(CURRENT_DIR):/app" -w /app \
		-e CGO_ENABLED=0 \
		golang:$(GOLANG_VERSION) /bin/sh .prepared_cmd

deb:
	./scripts/build_deb.sh

clean:
	rm -rf ./bin
	rm -rf ./deb_build
	rm -rf .prepared_cmd
