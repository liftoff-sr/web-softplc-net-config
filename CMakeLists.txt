
# Use CMake to build a Debian package

project( web-softplc-net-config )

cmake_minimum_required( VERSION 3.5 FATAL_ERROR )

set( CMAKE_MODULE_PATH /opt/gatecraft/softplc-toolkit/cmake/Modules )

include(DebFunctions)

set( CPACK_PACKAGE_VERSION_MAJOR 1 )

set( CPACK_PACKAGE_VERSION_MINOR 0 )        # 9-Feb-2020

set( CPACK_PACKAGE_VERSION_PATCH 0 )
set( CPACK_PACKAGE_CONTACT "Dick Hollenbeck <dick@softplc.com>" )
set( CPACK_PACKAGE_DESCRIPTION_SUMMARY "SoftPLC Network Configuration Web UI" )

install(
    FILES
        cgi-funcs.sh
    DESTINATION
        web-root/cgi-bin
    )

install(
    FILES
        http-busybox.service
    DESTINATION
        etc/systemd/system
    )

install(
    FILES
        httpd.conf
    DESTINATION
        etc
    )

install(
    FILES
        web-root/favicon.ico
        web-root/index.html
    DESTINATION
        web-root
    )

install(
    FILES
        web-root/cgi-bin/net-config-form-handler.sh
        web-root/cgi-bin/net-config-restart.sh
    DESTINATION
        web-root/cgi-bin
    PERMISSIONS
        OWNER_READ  OWNER_WRITE OWNER_EXECUTE
        GROUP_READ              GROUP_EXECUTE
        WORLD_READ
    )

install(
    FILES
        web-root/softplc-net-config/favicon.ico
        web-root/softplc-net-config/index.html
        web-root/softplc-net-config/saved.html
        web-root/softplc-net-config/net-config.js
    DESTINATION
        web-root/softplc-net-config
    )

install(
    FILES
        web-root/softplc-net-config/config/NETWORKS.LST
        web-root/softplc-net-config/config/LAST-NETWORKS.LST
    DESTINATION
        web-root/softplc-net-config/config
    )

install(
    FILES
        web-root/softplc-net-config/images/sm_splc_colorlogo_trans.png
    DESTINATION
        web-root/softplc-net-config/images
    )

add_conffiles(
    /web-root/softplc-net-config/config/NETWORKS.LST
    /web-root/softplc-net-config/config/LAST-NETWORKS.LST
    )


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
