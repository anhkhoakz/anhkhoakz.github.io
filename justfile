is_hugo_installed := `$(shell command -v hugo 2> /dev/null)`

# list available commands
default: help
    @just --list

# usage information
help:
    @echo "Usage: just [command]"

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

# copy binaries or artifacts to system path
install: build
    @echo "Installing binary/artifacts..."

# remove installed binaries/artifacts
uninstall:
    @echo "Uninstalling binary/artifacts..."
    # Override with language-specific uninstall commands:
    @echo "Please edit the 'uninstall' recipe to uninstall your project."

# remove build artifacts
clean:
    @echo "Cleaning build artifacts..."
    # Override with language-specific clean commands:
    # e.g., rm -rf node_modules dist, cargo clean, etc.
    @echo "Please edit the 'clean' recipe to clean your project."

# publish package to registry
publish: test
    @echo "Publishing package..."

# publish to sr.ht
publish-srht: build
    @echo "Publishing to sr.ht..."
    trash site.tar.gz
    tar -C public -cvz . > site.tar.gz
    if ! command -v hut &> /dev/null; then
        echo "hut could not be found, please install it."
        exit 1
    fi
    hut pages publish -d anhkhoakz.srht.site site.tar.gz
