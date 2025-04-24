DESCRIPTION = "Defender Automotive Package Group"
LICENSE = "MIT"

inherit packagegroup

PACKAGES = "\
    packagegroup-defender-automotive \
    "

RDEPENDS:packagegroup-defender-automotive = "\
    defender-launcher \
    defender-dashboard \
    defender-carplay \
    defender-settings \
    automotive-icons \
    "