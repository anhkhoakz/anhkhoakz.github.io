#!/usr/bin/env bash

function normalize_name {
    echo "$1" | tr '[:upper:]' '[:lower:]' | tr ' ' '-'
}

function create_new_content {
    content_name=$1
    content_name_normalized=$(normalize_name "$content_name")
    hugo new content content/blog/"$content_name_normalized".md
}
