#!/bin/bash

set -e

echo "Setting up Defender Automotive OS build environment..."

# Check if build directory exists
if [ ! -d "build" ]; then
    mkdir -p build
fi

# Source the Yocto environment if poky-source exists
if [ -d "poky-source" ]; then
    source poky-source/oe-init-build-env build

    # Check if the conf files exist, otherwise copy from meta-defender
    if [ ! -f "conf/local.conf" ]; then
        cp -v ../conf/local.conf conf/
    fi

    if [ ! -f "conf/bblayers.conf" ]; then
        cp -v ../conf/bblayers.conf conf/
    fi

    echo "Build environment configured."
    echo ""
    echo "To build the full image, run:"
    echo "  bitbake defender-automotive-image"
    echo ""
    echo "To build just the dashboard app, run:"
    echo "  bitbake defender-dashboard"
    echo ""
    echo "To run in QEMU (after building), run:"
    echo "  runqemu defender-automotive"

    cat conf/bblayers.conf | grep meta-defender
else
    echo "ERROR: poky-source directory not found!"
    echo "Please run the initial setup script first."
    exit 1
fi

find meta-defender -type d | sort

mkdir -p meta-defender/recipes-core/images/
# Copy your defender-automotive-image.bb here

bitbake-layers show-recipes "*-image-*"