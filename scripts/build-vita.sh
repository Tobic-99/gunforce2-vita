#!/bin/sh
# PS Vita build: build/vita/gunforce2.vpk. Needs scripts/translate.sh first.
set -e
R=$(cd "$(dirname "$0")/.." && pwd)
cmake -S "$R/vita" -B "$R/build/vita" -G Ninja
ninja -C "$R/build/vita" ${GF2_JOBS:+-j$GF2_JOBS}
sha256sum "$R/build/vita/eboot.bin"
