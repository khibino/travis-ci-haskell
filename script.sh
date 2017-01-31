#!/bin/sh

set -e

. ./sh-lib

set -x

if [ x"$STACK_RESOLVER" != x ]; then
    stack build
    stack test
else
    if [ -f configure.ac ]; then autoreconf -i; fi
    cabal configure $CABAL_CONSTRAINTS --enable-tests --enable-benchmarks -v2  # -v2 provides useful information for debugging
    cabal build   # this builds all libraries and executables (including tests/benchmarks)
    cabal test
    cabal check
    cabal sdist   # tests that a source-distribution can be generated

    # Check that the resulting source distribution can be built & installed.
    # If there are no other `.tar.gz` files in `dist`, this can be even simpler:
    # `cabal install --force-reinstalls dist/*-*.tar.gz`
    SRC_TGZ=$(cabal info . | awk '{print $2;exit}').tar.gz && \
        (cd dist && cabal install --force-reinstalls "$SRC_TGZ")
fi
