#!/bin/sh

set -e

. ./sh-lib

set -x

cabal --version
echo "$(ghc --version) [$(ghc --print-project-git-commit-id 2> /dev/null || echo '?')]"
custom_retry cabal update -v
sed -i 's/^jobs:/-- jobs:/' ${HOME}/.cabal/config
cabal install $CABAL_CONSTRAINTS --only-dependencies --enable-tests --enable-benchmarks --dry -v > installplan.txt
sed -i -e '1,/^Resolving /d' installplan.txt; cat installplan.txt

cabsnap_dir=$HOME/.cabsnap/s-${CABALVER}

# check whether current requested install-plan matches cached package-db snapshot
if [ x"NO_CABAL_CACHE" = x ] && diff -u ${cabsnap_dir}/installplan.txt installplan.txt;
then
    echo "cabal build-cache HIT";
    rm -rfv .ghc;
    cp -a ${cabsnap_dir}/ghc $HOME/.ghc;
    cp -a ${cabsnap_dir}/lib ${cabsnap_dir}/share ${cabsnap_dir}/bin $HOME/.cabal/;
else
    echo "cabal build-cache MISS";
    rm -rf ${cabsnap_dir};
    mkdir -p $HOME/.ghc $HOME/.cabal/lib $HOME/.cabal/share $HOME/.cabal/bin;
    cabal install $CABAL_CONSTRAINTS --only-dependencies --enable-tests --enable-benchmarks;
fi

# snapshot package-db on cache miss
if [ ! -d ${cabsnap_dir} ];
then
    echo "snapshotting package-db to build-cache";
    mkdir -p ${cabsnap_dir};
    cp -a $HOME/.ghc ${cabsnap_dir}/ghc;
    cp -a $HOME/.cabal/lib $HOME/.cabal/share $HOME/.cabal/bin installplan.txt ${cabsnap_dir}/;
fi
