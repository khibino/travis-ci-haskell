#!/bin/sh

set -e

. ./sh-lib

set -x

case "$DEBIANVER" in
    wheezy)
        export CABAL_CONSTRAINTS='--constraint=transformers==0.3.0.0 --constraint=containers==0.4.2.1 --constraint=bytestring==0.9.2.1 --constraint=text==0.11.2.0 --constraint=time==1.4 --constraint=dlist==0.5 --constraint=convertible==1.0.11.1 --constraint=HDBC==2.3.1.1' ;
        ;;
    '')
        ;;
    *)
        echo "Unsupported DEBIANVER: $DEBIANVER"
        exit 1
        ;;
esac
