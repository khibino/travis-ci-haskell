#!/bin/sh

set -e

. ./travis-CI/sh-lib
. ./travis-CI/custom-cabal
. ./travis-CI/dirs.list

set -x

cabal --version
echo "$(${HC} --version) [$(${HC} --print-project-git-commit-id 2> /dev/null || echo '?')]"

BENCH=${BENCH---enable-benchmarks}
TEST=${TEST---enable-tests}

custom_retry cabal update -v
sed -i 's/^jobs:/-- jobs:/' ${HOME}/.cabal/config

install_package() {
    rm -fv cabal.project.local
    echo 'packages: .' > cabal.project
    rm -f cabal.project.freeze
    cabal new-build -w ${HC} ${TEST} ${BENCH} --dep -j2 all
    cabal new-build -w ${HC} --disable-tests --disable-benchmarks --dep -j2 all
}

if [ x"$dirs" = x ]; then
    install_package
else
    for d in $dirs; do
        ( cd $d && install_package )
    done
fi
