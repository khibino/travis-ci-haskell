#!/bin/sh

set -e

. ./travis-CI/sh-lib

set -x

mkdir -p ~/.local/bin
custom_retry curl -L https://www.stackage.org/stack/linux-x86_64 \
    | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'
sed "s/^resolver: .*/resolver: ${STACK_RESOLVER}/" \
    < travis-CI/stack/template.yaml \
    > stack-travis.yaml
##    stack.yaml must be located the same directory which has *.cabal -- constraint of stack?
