SUMMARY = "Automotive UI icons"
DESCRIPTION = "Common icon set for automotive UI applications"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://automotive-icon.png"

S = "${WORKDIR}"

do_install() {
    install -d ${D}${datadir}/icons
    install -m 0644 ${WORKDIR}/automotive-icon.png ${D}${datadir}/icons/
}

FILES:${PN} += "${datadir}/icons/automotive-icon.png"