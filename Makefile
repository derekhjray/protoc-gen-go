SOURCES=$(shell find . -name "*.go")
VERSION=$(shell git describe --tags --long --abbrev=8)
RC?=0
TEST_PROTO_FILES=$(shell find testdata -name "*.proto")

protoc-gen-go: $(SOURCES)
	go build -ldflags '-s -w -X main.version=$(VERSION) -X main.rc=$(RC)' -o $@ .


.PHONY: install
install: $(SOURCES)
	go install -ldflags '-s -w -X main.version=$(VERSION) -X main.rc=$(RC)'

.PHONY: test
test: install $(TEST_PROTO_FILES)
	protoc --proto_path=. --go_out=paths=source_relative:. $(TEST_PROTO_FILES)

.PHONY: clean
clean:
	@rm -f protoc-gen-go