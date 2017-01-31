#!/bin/sh

set -x

stack setup
stack install --only-dependencies
