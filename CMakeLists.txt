
# Use CMake to build a Debian package

project( web-softplc-net-config )

cmake_minimum_required( VERSION 3.5 FATAL_ERROR )

set( CPACK_PACKAGE_VERSION_MAJOR 1 )

set( CPACK_PACKAGE_VERSION_MINOR 1 )        # 15-Feb-2020
#set( CPACK_PACKAGE_VERSION_MINOR 0 )        # 9-Feb-2020

set( CPACK_PACKAGE_VERSION_PATCH 0 )
set( CPACK_PACKAGE_CONTACT "Dick Hollenbeck <dick@softplc.com>" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "SoftPLC Network Configuration Web UI" )

set( DOCROOT web-root/softplc-net-config )

install(
    FILES
        web-softplc-net-config.service
    DESTINATION
        etc/systemd/system
    )

install(
    FILES
        web-softplc-net-config.conf
    DESTINATION
        etc
    )

install(
    FILES
        ${DOCROOT}/httpd.conf
    DESTINATION
        ${DOCROOT}
    )

install(
    FILES
        ${DOCROOT}/favicon.ico
        ${DOCROOT}/index.html
        js
        css
    DESTINATION
        ${DOCROOT}
    )

install(
    FILES
        ${DOCROOT}/cgi-bin/net-config-form-handler.sh
        ${DOCROOT}/cgi-bin/net-config-restart.sh
        ${DOCROOT}/cgi-bin/net-config-read-current-settings.sh
        ${DOCROOT}/cgi-bin/cgi-funcs.sh
    DESTINATION
        ${DOCROOT}/cgi-bin
    PERMISSIONS
        OWNER_READ  OWNER_WRITE OWNER_EXECUTE
        GROUP_READ              GROUP_EXECUTE
        WORLD_READ
    )

install(
    FILES
        ${DOCROOT}/favicon.ico
        ${DOCROOT}/index.html
        ${DOCROOT}/saved.html
        ${DOCROOT}/net-config.js
    DESTINATION
        ${DOCROOT}
    )

install(
    FILES
        ${DOCROOT}/config/NETWORKS.LST
    DESTINATION
        ${DOCROOT}/config
    )

install(
    FILES
        ${DOCROOT}/images/sm_splc_colorlogo_trans.png
    DESTINATION
        ${DOCROOT}/images
    )


file( WRITE ${CMAKE_BINARY_DIR}/conffiles
    "/etc/http-net-config.conf" "\n"
    )
set( CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA ${CMAKE_BINARY_DIR}/conffiles )


set( CMAKE_INSTALL_PREFIX "" )

# CPack variables
set( CPACK_DEBIAN_PACKAGE_NAME web-softplc-net-config )
set( CPACK_DEBIAN_PACKAGE_ARCHITECTURE all )
set( CPACK_DEBIAN_PACKAGE_SECTION embedded )
set( CPACK_DEBIAN_PACKAGE_PRIORITY optional )
set( CPACK_DEBIAN_PACKAGE_DEPENDS "busybox, web-bootstrap" )
set( CPACK_DEBIAN_PACKAGE_CONTROL_EXTRA
    ${CMAKE_CURRENT_SOURCE_DIR}/postinst
    ${CMAKE_CURRENT_SOURCE_DIR}/prerm
    )

set( CPACK_GENERATOR "DEB" )
set( CPACK_SET_DESTDIR ON )
set( CPACK_PACKAGE_VERSION "${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}" )
set( CPACK_PACKAGE_FILE_NAME "${CPACK_DEBIAN_PACKAGE_NAME}_${CPACK_PACKAGE_VERSION}_${CPACK_DEBIAN_PACKAGE_ARCHITECTURE}" )

include( CPack )
