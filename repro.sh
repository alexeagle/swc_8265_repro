#!/usr/bin/env bash
set -o errexit -o nounset

TMP=$(mktemp -d)
mkdir -p $TMP/src/modules/moduleA
mkdir -p $TMP/src/modules/moduleB
mkdir -p $TMP/bazel-out/arch/bin

ln -s $PWD/.swcrc $TMP
ln -s $PWD/src/index.ts $TMP/src
ln -s $PWD/src/modules/moduleA/index.ts $TMP/src/modules/moduleA
ln -s $PWD/src/modules/moduleB/index.ts $TMP/src/modules/moduleB

cd $TMP
ls -alR
wget --quiet --output-document swc https://github.com/swc-project/swc/releases/download/v1.3.107/swc-darwin-arm64
chmod u+x swc
xattr -c swc

./swc --version
./swc compile --source-maps false --config-file .swcrc --out-file bazel-out/arch/bin/src/index.js src/index.ts
grep require bazel-out/arch/bin/src/index.js
