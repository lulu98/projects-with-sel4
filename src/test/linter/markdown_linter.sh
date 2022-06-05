#!/bin/bash

SRC_DIR="../../.."
PROJECT_DIR="$SRC_DIR/src/main/projects/my_projects"

collect_sources () {
    mapfile -d $'\0' markdown_files < <(find "$PROJECT_DIR" -name "*.md" -print0)
}

process () {
    mdl -r ~MD024 "$SRC_DIR/README.md"
    for file in "${markdown_files[@]}"; do
        mdl -r ~MD024 "$file"
    done
}

collect_sources
process
