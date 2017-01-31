#!/bin/sh

set -e

. ./sh-lib

set -x

if [ x"$STACK_RESOLVER" != x ]; then
    stack_path
    stack --skip-ghc-check --resolver "$STACK_RESOLVER" setup
    stack --resolver "$STACK_RESOLVER" install --only-dependencies
else
    cabal_path
    cabal --version
    echo "$(ghc --version) [$(ghc --print-project-git-commit-id 2> /dev/null || echo '?')]"
    if [ -f $HOME/.cabal/packages/hackage.haskell.org/00-index.tar.gz ];
    then
        zcat $HOME/.cabal/packages/hackage.haskell.org/00-index.tar.gz > \
             $HOME/.cabal/packages/hackage.haskell.org/00-index.tar
    fi
    custom_retry cabal update -v
    sed -i 's/^jobs:/-- jobs:/' ${HOME}/.cabal/config
    cabal install $CABAL_CONSTRAINTS --only-dependencies --enable-tests --enable-benchmarks --dry -v > installplan.txt
    sed -i -e '1,/^Resolving /d' installplan.txt; cat installplan.txt

    # check whether current requested install-plan matches cached package-db snapshot
    # - if diff -u installplan.txt $HOME/.cabsnap/installplan.txt;
    if false;
    then
        echo "cabal build-cache HIT";
        rm -rfv .ghc;
        cp -a $HOME/.cabsnap/ghc $HOME/.ghc;
        cp -a $HOME/.cabsnap/lib $HOME/.cabsnap/share $HOME/.cabsnap/bin $HOME/.cabal/;
    else
        echo "cabal build-cache MISS";
        rm -rf $HOME/.cabsnap;
        mkdir -p $HOME/.ghc $HOME/.cabal/lib $HOME/.cabal/share $HOME/.cabal/bin;
        cabal install $CABAL_CONSTRAINTS --only-dependencies --enable-tests --enable-benchmarks;
    fi

    # snapshot package-db on cache miss
    if [ ! -d $HOME/.cabsnap ];
    then
        echo "snapshotting package-db to build-cache";
        mkdir $HOME/.cabsnap;
        cp -a $HOME/.ghc $HOME/.cabsnap/ghc;
        cp -a $HOME/.cabal/lib $HOME/.cabal/share $HOME/.cabal/bin installplan.txt $HOME/.cabsnap/;
    fi
fi
