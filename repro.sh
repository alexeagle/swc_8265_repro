#!/usr/bin/env bash
set -o errexit -o nounset

OUTPUT_BASE=$(mktemp -d)
BINDIR=$OUTPUT_BASE/bazel-out/arch/bin
SANDBOX=$OUTPUT_BASE/sandbox/123

mkdir -p $BINDIR/src/modules/moduleA
mkdir -p $BINDIR/src/modules/moduleB
mkdir -p $SANDBOX/src/modules/moduleA
mkdir -p $SANDBOX/src/modules/moduleB

# hard links from BINDIR into src
ln $PWD/.swcrc $BINDIR
ln $PWD/src/index.ts $BINDIR/src
ln $PWD/src/modules/moduleA/index.ts $BINDIR/src/modules/moduleA
ln $PWD/src/modules/moduleB/index.ts $BINDIR/src/modules/moduleB

# soft links from sandbox into bazel-bin
ln -s $BINDIR/.swcrc $SANDBOX
ln -s $BINDIR/src/index.ts $SANDBOX/src
ln -s $BINDIR/src/modules/moduleA/index.ts $SANDBOX/src/modules/moduleA
ln -s $BINDIR/src/modules/moduleB/index.ts $SANDBOX/src/modules/moduleB

echo "OUTPUT_BASE: $OUTPUT_BASE"
cd $SANDBOX
ls -alR
wget --quiet --output-document swc https://github.com/swc-project/swc/releases/download/v1.3.107/swc-darwin-arm64
chmod u+x swc
xattr -c swc

./swc --version
./swc compile --source-maps false --config-file .swcrc --out-file $BINDIR/src/index.js src/index.ts
grep require $BINDIR/src/index.js
