SUMMARY = "Defender Automotive Dashboard"
DESCRIPTION = "Dashboard UI for displaying car data and metrics"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase qtdeclarative qtquickcontrols2 qtwebsockets"

SRC_URI = "file://src/ \
           file://CMakeLists.txt \
           file://defender-dashboard.desktop \
          "

S = "${WORKDIR}"

inherit qt6-cmake pkgconfig

do_install:append() {
    install -d ${D}${datadir}/applications
    install -m 0644 ${WORKDIR}/defender-dashboard.desktop ${D}${datadir}/applications/

    install -d ${D}${bindir}
    install -m 0755 ${B}/defender-dashboard ${D}${bindir}/
}

FILES:${PN} += "${datadir}/applications/defender-dashboard.desktop"

RDEPENDS:${PN} += "qtbase qtdeclarative qtquickcontrols2 qtwebsockets"