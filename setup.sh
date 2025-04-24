#!/bin/bash

set -e

echo "Defender Automotive OS Setup Script"
echo "===================================="
echo "This script will set up all required repositories for building."
echo ""

# Get the absolute path of the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "${SCRIPT_DIR}"

# Function to clone or update a repo
clone_or_update() {
    local repo_url=$1
    local branch=$2
    local dir_name=$3

    if [ -d "${SCRIPT_DIR}/${dir_name}" ]; then
        echo "Updating ${dir_name}..."
        cd "${SCRIPT_DIR}/${dir_name}"
        git pull
        cd "${SCRIPT_DIR}"
    else
        echo "Cloning ${dir_name}..."
        if [ -n "$branch" ] && [ "$branch" != "none" ]; then
            git clone -b $branch $repo_url "${SCRIPT_DIR}/${dir_name}"
        else
            git clone $repo_url "${SCRIPT_DIR}/${dir_name}"
        fi
    fi
}

# Create a complete bblayers.conf
create_bblayers_conf() {
    mkdir -p "${SCRIPT_DIR}/conf"
    cat > "${SCRIPT_DIR}/conf/bblayers.conf" << EOF
# POKY_BBLAYERS_CONF_VERSION is increased each time build/conf/bblayers.conf
# changes incompatibly
POKY_BBLAYERS_CONF_VERSION = "2"

BBPATH = "\${TOPDIR}"
BBFILES ?= ""

BBLAYERS ?= " \\
  ${SCRIPT_DIR}/poky-source/meta \\
  ${SCRIPT_DIR}/poky-source/meta-poky \\
  ${SCRIPT_DIR}/poky-source/meta-yocto-bsp \\
  ${SCRIPT_DIR}/meta-openembedded/meta-oe \\
  ${SCRIPT_DIR}/meta-openembedded/meta-multimedia \\
  ${SCRIPT_DIR}/meta-openembedded/meta-networking \\
  ${SCRIPT_DIR}/meta-openembedded/meta-python \\
  ${SCRIPT_DIR}/meta-openembedded/meta-filesystems \\
  ${SCRIPT_DIR}/meta-qt6 \\
  ${SCRIPT_DIR}/meta-raspberrypi \\
  ${SCRIPT_DIR}/meta-defender \\
  "
EOF
    echo "Created simplified conf/bblayers.conf with essential layers only"
}

# Create or update meta-defender layer if it doesn't exist
create_meta_defender() {
    if [ ! -d "${SCRIPT_DIR}/meta-defender" ]; then
        echo "Creating meta-defender layer..."
        mkdir -p "${SCRIPT_DIR}/meta-defender/conf"
        mkdir -p "${SCRIPT_DIR}/meta-defender/recipes-core/images"
        mkdir -p "${SCRIPT_DIR}/meta-defender/recipes-automotive"

        # Create basic layer configuration
        cat > "${SCRIPT_DIR}/meta-defender/conf/layer.conf" << EOF
# We have a conf and classes directory, add to BBPATH
BBPATH .= ":${LAYERDIR}"

# We have recipes-* directories, add to BBFILES
BBFILES += "${LAYERDIR}/recipes-*/*/*.bb \\
            ${LAYERDIR}/recipes-*/*/*.bbappend"

BBFILE_COLLECTIONS += "defender"
BBFILE_PATTERN_defender = "^${LAYERDIR}/"
BBFILE_PRIORITY_defender = "10"

LAYERDEPENDS_defender = "core qt6-layer openembedded-layer"
LAYERSERIES_COMPAT_defender = "kirkstone"
EOF

        # Create a simple image recipe
        cat > "${SCRIPT_DIR}/meta-defender/recipes-core/images/defender-automotive-image.bb" << EOF
SUMMARY = "Defender Automotive In-Car Entertainment System"
DESCRIPTION = "Custom image for in-car entertainment system featuring Qt UI, CarPlay support, and automotive dashboard"
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += " \\
    debug-tweaks \\
    splash \\
    package-management \\
    ssh-server-openssh \\
    tools-debug \\
    tools-profile \\
    tools-sdk \\
"

# Base packages
IMAGE_INSTALL = " \\
    packagegroup-core-boot \\
    packagegroup-core-full-cmdline \\
    kernel-modules \\
    linux-firmware \\
    openssh-sftp-server \\
    htop \\
    nano \\
    usbutils \\
    pciutils \\
    wireless-tools \\
    networkmanager \\
"

# Wayland compositor
IMAGE_INSTALL += " \\
    wayland \\
    weston \\
    weston-init \\
"

# Qt packages
IMAGE_INSTALL += " \\
    qtbase \\
    qtdeclarative \\
    qtquickcontrols2 \\
    qtsvg \\
    qtwayland \\
"

# Set the root password to 'defender'
inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P defender root;"

# Image size
IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE_append = "\${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"
EOF
        echo "Created meta-defender layer with basic image recipe"
    fi
}

# Clone all repositories
echo "Cloning repositories. This might take a while..."

# Core Yocto
clone_or_update "git://git.yoctoproject.org/poky" "kirkstone" "poky-source"

# Qt6
clone_or_update "https://code.qt.io/yocto/meta-qt6.git" "" "meta-qt6"

# OpenEmbedded
clone_or_update "git://git.openembedded.org/meta-openembedded" "kirkstone" "meta-openembedded"

# Raspberry Pi
clone_or_update "https://git.yoctoproject.org/meta-raspberrypi" "kirkstone" "meta-raspberrypi"

# Create meta-defender layer if it doesn't exist
create_meta_defender

# Create build directory structure if it doesn't exist
mkdir -p "${SCRIPT_DIR}/build"

# Create bblayers.conf that will be used by build.sh
create_bblayers_conf

# Make both scripts executable
chmod +x "${SCRIPT_DIR}/setup.sh" "${SCRIPT_DIR}/build.sh"

echo ""
echo "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run 'source ./build.sh' to set up the build environment"
echo "2. Build the image using: bitbake defender-automotive-image"