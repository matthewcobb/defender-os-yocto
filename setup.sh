#!/bin/bash

set -e

echo "Defender Automotive OS Setup Script"
echo "===================================="
echo "This script will set up all required repositories for building."
echo ""

# Function to clone or update a repo
clone_or_update() {
    local repo_url=$1
    local branch=$2
    local dir_name=$3

    if [ -d "$dir_name" ]; then
        echo "Updating $dir_name..."
        cd $dir_name
        git pull
        cd ..
    else
        echo "Cloning $dir_name..."
        if [ -n "$branch" ]; then
            git clone -b $branch $repo_url $dir_name
        else
            git clone $repo_url $dir_name
        fi
    fi
}

# Create a complete bblayers.conf
create_bblayers_conf() {
    mkdir -p conf
    BASEDIR=$(pwd)
    cat > conf/bblayers.conf << EOF
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \\
  ${BASEDIR}/poky-source/meta \\
  ${BASEDIR}/poky-source/meta-poky \\
  ${BASEDIR}/poky-source/meta-yocto-bsp \\
  ${BASEDIR}/meta-openembedded/meta-oe \\
  ${BASEDIR}/meta-openembedded/meta-multimedia \\
  ${BASEDIR}/meta-openembedded/meta-networking \\
  ${BASEDIR}/meta-openembedded/meta-python \\
  ${BASEDIR}/meta-openembedded/meta-filesystems \\
  ${BASEDIR}/meta-qt6 \\
  ${BASEDIR}/meta-clang \\
  ${BASEDIR}/meta-rust \\
  ${BASEDIR}/meta-browser/meta-chromium \\
  ${BASEDIR}/meta-virtualization \\
  ${BASEDIR}/meta-raspberrypi \\
  ${BASEDIR}/meta-defender \\
  "
EOF
    echo "Created conf/bblayers.conf with all required layers"
}

# Clone all repositories
echo "Cloning repositories. This might take a while..."

# Core Yocto
clone_or_update "git://git.yoctoproject.org/poky" "kirkstone" "poky-source"

# Qt6
clone_or_update "https://code.qt.io/yocto/meta-qt6.git" "" "meta-qt6"

# OpenEmbedded
clone_or_update "git://git.openembedded.org/meta-openembedded" "kirkstone" "meta-openembedded"

# Clang (required by Chromium)
clone_or_update "https://github.com/kraj/meta-clang.git" "kirkstone" "meta-clang"

# Rust (required by some dependencies)
clone_or_update "https://github.com/meta-rust/meta-rust.git" "kirkstone" "meta-rust"

# Virtualization
clone_or_update "git://git.yoctoproject.org/meta-virtualization" "kirkstone" "meta-virtualization"

# Browser
clone_or_update "https://github.com/OSSystems/meta-browser.git" "kirkstone" "meta-browser"

# Raspberry Pi
clone_or_update "https://git.yoctoproject.org/meta-raspberrypi" "kirkstone" "meta-raspberrypi"

# Create build directory structure if it doesn't exist
mkdir -p build

# Create bblayers.conf that will be used by build.sh
create_bblayers_conf

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'source ./build.sh' to set up the build environment"
echo "2. Build the image using: bitbake defender-automotive-image"