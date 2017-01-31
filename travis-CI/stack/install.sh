#!/bin/sh

set -x

install_package() {
    sed "s/^resolver: .*/resolver: ${STACK_RESOLVER}/" \
        < $HOME/travis-CI/stack/template.yaml \
        > stack-travis.yaml
    ##    stack.yaml must be located the same directory which has *.cabal -- constraint of stack?

    STACK_YAML=stack-travis.yaml stack setup
    STACK_YAML=stack-travis.yaml stack install --only-dependencies
}

install_package
