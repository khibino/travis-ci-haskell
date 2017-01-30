#!/bin/sh

set -e

. ./sh-lib

set -x

unset CC
if [ x"$STACK_RESOLVER" != x ]; then
    mkdir -p ~/.local/bin
    PATH=$HOME/.local/bin:$PATH
    export PATH
    custom_retry curl -L https://www.stackage.org/stack/linux-x86_64 | tar xz --wildcards --strip-components=1 -C ~/.local/bin '*/stack'
else
    PATH=/opt/ghc/$GHCVER/bin:/opt/cabal/$CABALVER/bin:$PATH
    export PATH
    case "$DEBIANVER" in
        wheezy)
            export CABAL_CONSTRAINTS='--constraint=transformers==0.3.0.0 --constraint=containers==0.4.2.1 --constraint=bytestring==0.9.2.1 --constraint=text==0.11.2.0 --constraint=time==1.4 --constraint=dlist==0.5 --constraint=convertible==1.0.11.1 --constraint=HDBC==2.3.1.1' ;
            custom_retry cabal update -v ;
            custom_retry cabal install $CABAL_CONSTRAINTS text dlist HDBC ;
            ;;
        '')
            ;;
        *)
            echo "Unsupported DEBIANVER: $DEBIANVER"
            exit 1
            ;;
    esac
fi
