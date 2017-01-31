#!/bin/sh

set -e
set -x

stack build
stack test
