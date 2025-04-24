SUMMARY = "Defender Automotive Launcher"
DESCRIPTION = "Main launcher application for the Defender Automotive System"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

DEPENDS = "qtbase qtdeclarative qtquickcontrols2 qtsvg qtgraphicaleffects"

SRC_URI = "file://src/ \
           file://CMakeLists.txt \
           file://defender-launcher.desktop \
           file://defender-launcher.service \
          "

S = "${WORKDIR}"

inherit cmake_qt6 pkgconfig systemd

SYSTEMD_SERVICE_${PN} = "defender-launcher.service"

do_install_append() {
    install -d ${D}${datadir}/applications
    install -m 0644 ${WORKDIR}/defender-launcher.desktop ${D}${datadir}/applications/

    install -d ${D}${bindir}
    install -m 0755 ${B}/defender-launcher ${D}${bindir}/

    install -d ${D}${systemd_unitdir}/system
    install -m 0644 ${WORKDIR}/defender-launcher.service ${D}${systemd_unitdir}/system/
}

FILES_${PN} += "${datadir}/applications/defender-launcher.desktop \
                ${systemd_unitdir}/system/defender-launcher.service"

RDEPENDS_${PN} += "qtbase qtdeclarative qtquickcontrols2 qtsvg qtgraphicaleffects weston"