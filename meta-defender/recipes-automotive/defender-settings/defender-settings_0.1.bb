SUMMARY = "Defender Automotive Settings"
DESCRIPTION = "Settings application for the Defender Automotive System"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase qtdeclarative qtquickcontrols2 qtsvg"

SRC_URI = "file://src/ \
           file://CMakeLists.txt \
           file://defender-settings.desktop \
          "

S = "${WORKDIR}"

inherit qt6-cmake pkgconfig

do_install:append() {
    install -d ${D}${datadir}/applications
    install -m 0644 ${WORKDIR}/defender-settings.desktop ${D}${datadir}/applications/

    install -d ${D}${bindir}
    install -m 0755 ${B}/defender-settings ${D}${bindir}/
}

FILES:${PN} += "${datadir}/applications/defender-settings.desktop"

RDEPENDS:${PN} += "qtbase qtdeclarative qtquickcontrols2 qtsvg"