#!/bin/bash

SRC_DIR="../../.."
LINTER_DIR="$SRC_DIR/src/test/linter"

collect_sources () {
    mapfile -d $'\0' bash_files < <(find "$LINTER_DIR" -name "*.sh" -print0)
}

process () {
    for file in "${bash_files[@]}"; do
        shellcheck "$file"
    done
}

collect_sources
process
