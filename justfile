is_hugo_installed := `$(shell command -v hugo 2> /dev/null)`

# list available commands
default: help
    @just --list

# usage information
help:
    @echo "Usage: just [recipe]"

# install dependencies
setup:
    @echo "Installing dependencies..."

# check code style and quality
lint:
    @echo "Running linter..."
    markdownlint content/

# run tests
test: lint
    @echo "Running tests..."

# compile or package the project
build: test
    @echo "Building project..."
    if [ -z "$(is_hugo_installed)" ]; then \
        echo "Hugo is not installed. Please install it first."; \
        exit 1; \
    fi
    hugo build
    hugo --minify

# remove build artifacts
clean:
    @echo "Cleaning build artifacts..."
    rm -rf public
    rm site.tar.gz
    rm -rf .hugo_build.lock

# publish to sr.ht
publish-srht: build
    @echo "Publishing to sr.ht..."
    @just clean
    tar -C public -cvz . > site.tar.gz
    if ! command -v hut &> /dev/null; then
        echo "hut could not be found, please install it."
        exit 1
    fi
    hut pages publish -d anhkhoakz.srht.site site.tar.gz
