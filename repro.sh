#!/usr/bin/env bash
set -o errexit -o nounset

TMP=$(mktemp -d)
mkdir -p $TMP/src/modules/moduleA
mkdir -p $TMP/src/modules/moduleB

ln -s $PWD/.swcrc $TMP
ln -s $PWD/src/index.ts $TMP/src
ln -s $PWD/src/modules/moduleA/index.ts $TMP/src/modules/moduleA
ln -s $PWD/src/modules/moduleB/index.ts $TMP/src/modules/moduleB

cd $TMP
ls -alR
~/Downloads/swc-darwin-arm64 compile --source-maps false --config-file .swcrc --out-file src/index.js src/index.ts
grep require src/index.js
