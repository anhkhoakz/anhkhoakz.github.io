# list available commands
_default: _help
    @just --list

# usage information
_help:
    @echo "Usage: just [recipe]"

# check code style and quality
lint:
    @echo "Running linter..."
    markdownlint --fix content/

# compile or package the project
build: clean
    @echo "Building project..."
    hugo build
    hugo --minify

# remove build artifacts
clean:
    @echo "Cleaning build artifacts..."
    -rm -rf public
    -rm site.tar.gz
    -rm -rf .hugo_build.lock

# publish to sr.ht
publish-srht: build
    @echo "Publishing to sr.ht..."
    tar -C public -cvz . > site.tar.gz
    hut pages publish -d anhkhoakz.srht.site site.tar.gz

# create a new post
new_content content_name:
    @echo "Creating new content..."
    @hugo new content/blog/{{ content_name }}.md
    @echo "Content created successfully."

# edit a post
edit:
        fd --extension=md --full-path content/blog | fzf | xargs nvim

# Dev mode
dev:
    hugo server
    sleep 3
    open http://localhost:1313
