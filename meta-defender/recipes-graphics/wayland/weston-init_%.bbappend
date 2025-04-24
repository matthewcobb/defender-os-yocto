FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://weston.ini"

do_install:append() {
    install -D -m 0644 ${WORKDIR}/weston.ini ${D}${sysconfdir}/xdg/weston/weston.ini
}

FILES:${PN} += "${sysconfdir}/xdg/weston/weston.ini"