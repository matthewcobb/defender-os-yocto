#!/bin/bash

set -e

echo "Setting up Defender Automotive OS build environment..."

# Check if build directory exists
if [ ! -d "build" ]; then
    mkdir -p build
fi

# Source the Yocto environment if poky-source exists
if [ -d "poky-source" ]; then
    # Backup existing config if it exists
    if [ -f "conf/bblayers.conf" ]; then
        cp conf/bblayers.conf /tmp/bblayers.conf.save
    fi

    source poky-source/oe-init-build-env build

    # Restore full config if backup exists
    if [ -f "/tmp/bblayers.conf.save" ]; then
        cp /tmp/bblayers.conf.save conf/bblayers.conf
    fi

    # Check if the conf files exist, otherwise copy from meta-defender
    if [ ! -f "conf/local.conf" ]; then
        cp -v ../conf/local.conf conf/
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
else
    echo "ERROR: poky-source directory not found!"
    echo "Please run the initial setup script first."
    exit 1
fi