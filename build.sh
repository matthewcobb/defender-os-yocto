#!/bin/bash

# Get the absolute path of the current directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check for required layers
check_layers() {
    local missing_layers=""

    # Check for essential layers
    if [ ! -d "${SCRIPT_DIR}/poky-source/meta" ]; then
        missing_layers="${missing_layers}\n - poky-source/meta (Yocto base)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-openembedded/meta-oe" ]; then
        missing_layers="${missing_layers}\n - meta-openembedded/meta-oe (Core OpenEmbedded layer)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-openembedded/meta-multimedia" ]; then
        missing_layers="${missing_layers}\n - meta-openembedded/meta-multimedia (Multimedia support)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-openembedded/meta-networking" ]; then
        missing_layers="${missing_layers}\n - meta-openembedded/meta-networking (Networking support)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-openembedded/meta-python" ]; then
        missing_layers="${missing_layers}\n - meta-openembedded/meta-python (Python support)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-openembedded/meta-filesystems" ]; then
        missing_layers="${missing_layers}\n - meta-openembedded/meta-filesystems (Additional filesystems)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-qt6" ]; then
        missing_layers="${missing_layers}\n - meta-qt6 (Qt 6 support)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-raspberrypi" ]; then
        missing_layers="${missing_layers}\n - meta-raspberrypi (Raspberry Pi support)"
    fi

    if [ ! -d "${SCRIPT_DIR}/meta-defender" ]; then
        missing_layers="${missing_layers}\n - meta-defender (Defender Automotive OS layer)"
    fi

    if [ -n "$missing_layers" ]; then
        echo -e "ERROR: The following layers are missing:${missing_layers}"
        echo ""
        echo "Please run ./setup.sh to create or update the required repositories."
        return 1
    fi

    return 0
}

# Create build directory if it doesn't exist
if [ ! -d "${SCRIPT_DIR}/build" ]; then
    mkdir -p "${SCRIPT_DIR}/build"
    echo "Created build directory."
fi

# Check if all required layers are present
if ! check_layers; then
    echo "Build environment setup failed due to missing layers."
    return 1
fi

# Back up conf files if they exist
if [ -f "${SCRIPT_DIR}/build/conf/bblayers.conf" ]; then
    cp "${SCRIPT_DIR}/build/conf/bblayers.conf" "${SCRIPT_DIR}/build/conf/bblayers.conf.bak"
    echo "Backed up existing bblayers.conf"
fi

if [ -f "${SCRIPT_DIR}/build/conf/local.conf" ]; then
    cp "${SCRIPT_DIR}/build/conf/local.conf" "${SCRIPT_DIR}/build/conf/local.conf.bak"
    echo "Backed up existing local.conf"
fi

# Source the Yocto environment
cd "${SCRIPT_DIR}"
source poky-source/oe-init-build-env build

# Restore configurations if backups exist, otherwise create them
if [ -f "${SCRIPT_DIR}/build/conf/bblayers.conf.bak" ]; then
    cp "${SCRIPT_DIR}/build/conf/bblayers.conf.bak" "${SCRIPT_DIR}/build/conf/bblayers.conf"
    echo "Restored custom bblayers.conf"
else
    cat "${SCRIPT_DIR}/conf/bblayers.conf" > "${SCRIPT_DIR}/build/conf/bblayers.conf"
    echo "Created bblayers.conf from template"
fi

if [ -f "${SCRIPT_DIR}/build/conf/local.conf.bak" ]; then
    cp "${SCRIPT_DIR}/build/conf/local.conf.bak" "${SCRIPT_DIR}/build/conf/local.conf"
    echo "Restored custom local.conf"
else
    # Add specific configurations for Raspberry Pi
    sed -i "s/^MACHINE .*/MACHINE = \"raspberrypi4\"/" conf/local.conf
    echo "" >> conf/local.conf
    echo "# Configure for Raspberry Pi 4" >> conf/local.conf
    echo "GPU_MEM = \"256\"" >> conf/local.conf
    echo "DISABLE_OVERSCAN = \"1\"" >> conf/local.conf
    echo "ENABLE_UART = \"1\"" >> conf/local.conf
    echo "RPI_EXTRA_CONFIG = \"hdmi_drive=2\"" >> conf/local.conf
    echo "LICENSE_FLAGS_ACCEPTED += \"commercial\"" >> conf/local.conf
    echo "DISTRO_FEATURES_append = \" wayland\"" >> conf/local.conf

    # Disable inotify on macOS to avoid issues
    if [[ "$(uname)" == "Darwin" ]]; then
        echo "# Disable inotify on macOS" >> conf/local.conf
        echo "BB_GENERATE_MIRROR_TARBALLS = \"1\"" >> conf/local.conf
        echo "BB_FSDEVICE = \"harddisk\"" >> conf/local.conf
        echo "INHERIT_remove = \"inotify2\"" >> conf/local.conf
    fi

    echo "Created default local.conf for Raspberry Pi 4"
fi

echo "Verifying build environment..."
echo ""
echo "Build environment is ready. You can now:"
echo "1. Build the full image: bitbake defender-automotive-image"
echo "2. Build a specific component: bitbake <package-name>"