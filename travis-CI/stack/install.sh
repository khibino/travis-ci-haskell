#!/bin/sh

set -x

checkout_root=$(pwd)

install_package() {
    sed "s/^resolver: .*/resolver: ${STACK_RESOLVER}/" \
        < $checkout_root/travis-CI/stack/template.yaml \
        > stack-travis.yaml
    ##    stack.yaml must be located the same directory which has *.cabal -- constraint of stack?

    STACK_YAML=stack-travis.yaml stack setup
    STACK_YAML=stack-travis.yaml stack install --only-dependencies
}

install_package
