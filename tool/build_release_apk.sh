#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# Flutter 3.47 embeds absolute host path for dart_plugin_registrant.dart via -D string literal
# even with --obfuscate (compile.dart ignores method-level fileSystemRoots). Staging under /tmp
# guarantees a neutral path free of /Users/<developer>.
STAGE_DIR="/tmp/akar_release_build"

cleanup() {
  rm -rf "$STAGE_DIR"
}
trap cleanup EXIT

echo "==> Staging clean build workspace at $STAGE_DIR..."
rm -rf "$STAGE_DIR"
mkdir -p "$STAGE_DIR"
rsync -a \
  --exclude='.git' \
  --exclude='build' \
  --exclude='.dart_tool' \
  --exclude='ios/Pods' \
  --exclude='tools' \
  --exclude='test_reports' \
  --exclude='docs' \
  "$ROOT_DIR/" "$STAGE_DIR/"

BUILD_ARGS=(
  build apk
  --release
  --obfuscate
  --split-per-abi
  --split-debug-info=build/app/outputs/symbols
)

if [[ -f "$STAGE_DIR/.env" ]]; then
  BUILD_ARGS+=(--dart-define-from-file=.env)
fi

echo "==> Building obfuscated release APKs from neutral path..."
(
  cd "$STAGE_DIR"
  flutter pub get --offline || flutter pub get
  flutter "${BUILD_ARGS[@]}"
)

echo "==> Copying verified build outputs back to workspace..."
mkdir -p "$ROOT_DIR/build/app/outputs/flutter-apk" "$ROOT_DIR/build/app/outputs/symbols"
rm -f "$ROOT_DIR/build/app/outputs/flutter-apk/"*-release.apk*
cp -f "$STAGE_DIR/build/app/outputs/flutter-apk/"*-release.apk* "$ROOT_DIR/build/app/outputs/flutter-apk/"
cp -f "$STAGE_DIR/build/app/outputs/symbols/"* "$ROOT_DIR/build/app/outputs/symbols/"

echo "==> Verifying APKs for credential & developer path leaks..."
cd "$ROOT_DIR"
python3 - <<'PY'
import glob
import os
import re
import sys
import zipfile

apks = sorted(glob.glob("build/app/outputs/flutter-apk/*-release.apk"))
if not apks:
    print("FAIL: No release APKs found in build/app/outputs/flutter-apk/", file=sys.stderr)
    sys.exit(1)

secret_path_re = re.compile(r"(^|/)crd/|akar-504702", re.IGNORECASE)
secret_body_re = re.compile(rb"BEGIN PRIVATE KEY|\"type\"\s*:\s*\"service_account\"")
dev_path_re = re.compile(rb"(/Users/|/home/|C:\\\\Users\\\\)[^\x00\r\n]{0,120}")
host_user = os.environ.get("USER", "").encode("utf-8")

failed = False
for apk in apks:
    issues = []
    with zipfile.ZipFile(apk) as z:
        for name in z.namelist():
            if secret_path_re.search(name):
                issues.append(f"forbidden credential asset path: {name}")
            if name.endswith((".json", ".pem", ".key")):
                if secret_body_re.search(z.read(name)):
                    issues.append(f"private key / service account content in: {name}")
            if name.startswith("lib/") and name.endswith("/libapp.so"):
                data = z.read(name)
                matches = dev_path_re.findall(data)
                if matches:
                    issues.append(f"developer path leaked in {name} ({len(matches)} match)")
                if host_user and len(host_user) >= 4 and (b"/" + host_user + b"/") in data:
                    issues.append(f"host username path leaked in {name}")
    if issues:
        failed = True
        print(f"FAIL: {apk}")
        for item in issues:
            print(f"  - {item}")
    else:
        print(f"PASS: {apk} (0 service account keys, 0 developer paths)")

if failed:
    sys.exit(1)
PY
