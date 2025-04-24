#!/bin/bash

set -e

echo "Defender Automotive OS Setup Script"
echo "===================================="
echo "This script will set up all required repositories for building."
echo ""

# Check if we've already cloned the repositories
if [ -d "poky-source" ]; then
    echo "Repositories already exist. Do you want to update them? (y/n)"
    read update_repos
    if [ "$update_repos" == "y" ]; then
        echo "Updating Poky..."
        cd poky-source
        git pull
        cd ..

        echo "Updating meta-qt6..."
        cd meta-qt6
        git pull
        cd ..

        echo "Updating meta-openembedded..."
        cd meta-openembedded
        git pull
        cd ..

        echo "Updating meta-virtualization..."
        cd meta-virtualization
        git pull
        cd ..

        echo "Updating meta-browser..."
        cd meta-browser
        git pull
        cd ..
    fi
else
    echo "Cloning repositories. This might take a while..."

    echo "Cloning Poky (Yocto base)..."
    git clone -b kirkstone git://git.yoctoproject.org/poky poky-source

    echo "Cloning meta-qt6..."
    git clone https://code.qt.io/yocto/meta-qt6.git

    echo "Cloning meta-openembedded..."
    git clone -b kirkstone git://git.openembedded.org/meta-openembedded

    echo "Cloning meta-virtualization..."
    git clone -b kirkstone git://git.yoctoproject.org/meta-virtualization

    echo "Cloning meta-browser..."
    git clone -b kirkstone https://github.com/OSSystems/meta-browser.git
fi

# Create build directory structure
mkdir -p build

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run ./build.sh to set up the build environment"
echo "2. Build the image using: bitbake defender-automotive-image"