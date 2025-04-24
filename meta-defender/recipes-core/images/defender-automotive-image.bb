SUMMARY = "Defender Automotive In-Car Entertainment System"
DESCRIPTION = "Custom image for in-car entertainment system featuring Qt UI, CarPlay support, and automotive dashboard"
LICENSE = "MIT"

inherit core-image

IMAGE_FEATURES += " \
    debug-tweaks \
    splash \
    package-management \
    ssh-server-openssh \
    tools-debug \
    tools-profile \
    tools-sdk \
"

# Base packages
IMAGE_INSTALL = " \
    packagegroup-core-boot \
    packagegroup-core-full-cmdline \
    kernel-modules \
    linux-firmware \
    packagegroup-core-buildessential \
    openssh-sftp-server \
    htop \
    nano \
    usbutils \
    pciutils \
    iw \
    networkmanager \
    connman \
    bluez5 \
"

# Wayland/Weston compositor
IMAGE_INSTALL += " \
    wayland \
    weston \
    weston-init \
    weston-examples \
    libwayland-server \
"

# Qt packages
IMAGE_INSTALL += " \
    qtbase \
    qtdeclarative \
    qtmultimedia \
    qtwebview \
    qtquickcontrols2 \
    qtlocation \
    qtconnectivity \
    qtwebchannel \
    qtsvg \
    qtwayland \
    qtgraphicaleffects \
    qttools \
    qtcharts \
"

# Defender automotive specific packages
IMAGE_INSTALL += " \
    defender-dashboard \
    defender-carplay \
    defender-launcher \
    defender-settings \
    packagegroup-defender-automotive \
"

# For debugging and development
EXTRA_IMAGE_FEATURES += "debug-tweaks dev-pkgs tools-sdk tools-debug tools-profile"

# Set the root password to 'defender'
inherit extrausers
EXTRA_USERS_PARAMS = "usermod -P defender root;"

# Set default distro features
DISTRO_FEATURES += "systemd wayland"

# Image size - make it enough for the system and apps
IMAGE_ROOTFS_SIZE ?= "8192"
IMAGE_ROOTFS_EXTRA_SPACE:append = "${@bb.utils.contains("DISTRO_FEATURES", "systemd", " + 4096", "", d)}"