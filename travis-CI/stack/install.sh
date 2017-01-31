#!/bin/sh

set -x

install_package() {
    stack setup
    stack install --only-dependencies
}

install_package
