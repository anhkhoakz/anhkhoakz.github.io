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
build:
    @echo "Building project..."
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
    hut pages publish -d anhkhoakz.srht.site site.tar.gz

new_content content_name:
    @echo "Creating new content..."
    @hugo new content/blog/{{ content_name }}.md
    @echo "Content created successfully."
