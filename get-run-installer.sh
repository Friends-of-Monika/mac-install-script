#!/bin/bash

is_mac() {
    [ "$(uname)" == "Darwin" ]
}

gh_get_latest_tag() {
    curl -sL "https://api.github.com/repos/monika-after-story/mas-installer/releases" | perl -nle 'print $1 if /"tag_name":\s*"([^"]+)"/mg'
}

gh_download_binary() {
    curl -L "https://github.com/Monika-After-Story/mas-installer/releases/download/$1/mas-installer-macos" > "$2"
}

if ! is_mac; then
    echo "This script is currently intended to run on MacOS only."
    echo "For updates, visit https://github.com/Friends-of-Monika/mac-install-script"
    exit 1
fi

echo "- Getting latest version..."
release_ver="$(gh_get_latest_tag)"

echo "- Found latest version: $release_ver"
echo "- Downloading the installer..."

tempdir="$(mktemp -d)"
trap 'rm -rf "$tempdir"' EXIT
gh_download_binary "$release_ver" "$tempdir/installer"
echo

echo "- Launching the installer!"
chmod +x "$tempdir/installer"
"$tempdir/installer"
