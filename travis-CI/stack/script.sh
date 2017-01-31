#!/bin/sh

set -e
set -x

script_build() {
    STACK_YAML=stack-travis.yaml stack build
    STACK_YAML=stack-travis.yaml stack test
}

script_build
