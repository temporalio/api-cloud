$(VERBOSE).SILENT:
############################# Main targets #############################
ci-build: install proto

# Install dependencies.
install: buf-install grpc-install openapiv2-install

# Run all linters and compile proto files.
proto: buf-lint buf-breaking clean $(PROTO_OUT) proto-go proto-openapiv2
########################################################################

##### Variables ######
ifndef GOPATH
GOPATH := $(shell go env GOPATH)
endif

GOBIN := $(if $(shell go env GOBIN),$(shell go env GOBIN),$(GOPATH)/bin)
SHELL := PATH=$(GOBIN):$(PATH) /bin/sh

COLOR := "\e[1;36m%s\e[0m\n"

PROTO_ROOT := .
TEMPORAL_API_ROOT := $(PROTO_ROOT)/.temporal-api
PROTO_FILES = $(shell find $(PROTO_ROOT)/temporal -name "*.proto")
SERVICE_PROTO_FILES = $(shell find $(PROTO_ROOT)/temporal -name "*service.proto")
PROTO_DIRS = $(sort $(dir $(PROTO_FILES)))
SERVICE_PROTO_DIRS = $(sort $(dir $(SERVICE_PROTO_FILES)))
PROTO_OUT := .gen
PROTO_IMPORTS = -I=$(PROTO_ROOT) -I=$(TEMPORAL_API_ROOT)

$(PROTO_OUT): clean
	mkdir -p $(PROTO_OUT)/go
	mkdir -p $(PROTO_OUT)/openapiv2

##### Copy the proto files from the temporal api repo #####
copy-temporal-api:
	@printf $(COLOR) "Copy temporal apis..."
	rm -rf $(TEMPORAL_API_ROOT)
	mkdir -p $(TEMPORAL_API_ROOT)
	git clone git@github.com:temporalio/api --depth=1 --branch master --single-branch $(PROTO_ROOT)/.temporal-api-tmp
	mv -f $(PROTO_ROOT)/.temporal-api-tmp/temporal $(TEMPORAL_API_ROOT)/temporal
	mv -f $(PROTO_ROOT)/.temporal-api-tmp/dependencies $(TEMPORAL_API_ROOT)/dependencies
	mv -f $(PROTO_ROOT)/.temporal-api-tmp/google $(TEMPORAL_API_ROOT)/google
	rm -rf $(PROTO_ROOT)/.temporal-api-tmp

##### Compile proto files for go #####
proto-go:
	printf $(COLOR) "Compile for go-gRPC..."
	$(foreach PROTO_DIR,$(PROTO_DIRS),protoc \
		--fatal_warnings \
		$(PROTO_IMPORTS) \
		--go_out $(PROTO_OUT)/go --go_opt paths=source_relative \
		--go-grpc_out $(PROTO_OUT)/go --go-grpc_opt paths=source_relative \
		$(PROTO_DIR)*.proto;)

##### Compile proto files for openapiv2 #####
proto-openapiv2: 
	$(foreach SERVICE_PROTO_DIR,$(SERVICE_PROTO_DIRS),protoc \
		--fatal_warnings \
		$(PROTO_IMPORTS) \
		--openapiv2_out $(PROTO_OUT)/openapiv2 --openapiv2_opt output_format=yaml --openapiv2_opt allow_delete_body \
		$(SERVICE_PROTO_DIR)*service.proto;)


##### Plugins & tools #####
buf-install:
	printf $(COLOR) "Install/update buf..."
	go install github.com/bufbuild/buf/cmd/buf@v1.25.1

grpc-install:
	printf $(COLOR) "Install/update go and grpc protoc gen ..."
	go install google.golang.org/protobuf/cmd/protoc-gen-go@v1.31
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@v1.3

openapiv2-install:
	printf $(COLOR) "Install/update openapiv2 protoc gen..."
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@v2.16.2

##### Linters #####
buf-lint:
	printf $(COLOR) "Run buf linter..."
	buf lint

buf-breaking:
	@printf $(COLOR) "Run buf breaking changes check against main branch..."
	buf breaking --against 'https://github.com/temporalio/temporal.git#branch=main'

##### Clean #####
clean:
	printf $(COLOR) "Delete generated files..."
	rm -rf $(PROTO_OUT)
