ifeq ($(OS),Windows_NT)
	detected_OS := Windows
else
	detected_OS := $(shell sh -c 'uname 2>/dev/null || echo Unknown')
endif

NO_COLOR=\x1b[0m
OK_COLOR=\x1b[32;01m
ERROR_COLOR=\x1b[31;01m
WARN_COLOR=\x1b[33;01m
OK_STRING=$(OK_COLOR)[OK]$(NO_COLOR)
ERROR_STRING=$(ERROR_COLOR)[ERRORS]$(NO_COLOR)
WARN_STRING=$(WARN_COLOR)[WARNINGS]$(NO_COLOR)

default: install

install:
	-@make $(detected_OS)

Windows:
	@echo $(ERROR_STRING) "OS not supported"

Darwin:
	@echo "Installing dependencies..."
	@brew update || brew update
	@echo "Brew updated $(OK_STRING)"
	@brew bundle --file ./build/dev/osx/Brewfile
	@echo "Install go $(OK_STRING)"
	go get github.com/deepmap/oapi-codegen/cmd/oapi-codegen
	@echo "Install oapi-codegen $(OK_STRING)"

openapi:
	oapi-codegen --generate types,client --package openvidu api/swagger.yml > pkg/client/openvidu.go
