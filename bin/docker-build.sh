#!/usr/bin/env bash
set -euo pipefail

KEYBOARD="${1:-keyball39}"
KEYMAP="${2:-via}"

echo "=== Building keyball/${KEYBOARD}:${KEYMAP} ==="

# Link keyball source into QMK firmware tree
ln -sfn /keyball/qmk_firmware/keyboards/keyball /qmk_firmware/keyboards/keyball

# Compile
qmk compile -j 4 -kb "keyball/${KEYBOARD}" -km "${KEYMAP}"

# Copy artifacts
mkdir -p /keyball/tmp
cp /qmk_firmware/*.hex /keyball/tmp/

echo "=== Build complete ==="
ls -la /keyball/tmp/*.hex
