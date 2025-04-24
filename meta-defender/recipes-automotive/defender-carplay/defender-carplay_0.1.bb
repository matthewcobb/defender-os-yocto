SUMMARY = "Defender CarPlay Integration"
DESCRIPTION = "Apple CarPlay integration for the Defender Automotive System"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase qtdeclarative qtmultimedia qtwebengine libusb1 avahi libplist usbmuxd"

SRC_URI = "file://src/ \
           file://CMakeLists.txt \
           file://defender-carplay.desktop \
          "

S = "${WORKDIR}"

inherit qt6-cmake pkgconfig systemd

SYSTEMD_SERVICE:${PN} = "defender-carplay.service"

do_install_append() {
    install -d ${D}${datadir}/applications
    install -m 0644 ${WORKDIR}/defender-carplay.desktop ${D}${datadir}/applications/

    install -d ${D}${bindir}
    install -m 0755 ${B}/defender-carplay ${D}${bindir}/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/src/defender-carplay.service ${D}${systemd_unitdir}/system/
}

FILES:${PN} += "${datadir}/applications/defender-carplay.desktop \
                ${systemd_unitdir}/system/defender-carplay.service"

RDEPENDS:${PN} += "qtbase qtdeclarative qtmultimedia qtwebengine libusb1 avahi libplist usbmuxd"