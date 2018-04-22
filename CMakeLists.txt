  # project name
    project (notifier)

    #some variables
set (GIT_PREFIX com.github.Timecraft.)
set (GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
set (EXEC_NAME ${GIT_PREFIX}${CMAKE_PROJECT_NAME})
set (DAEMON_EXEC_NAME ${GIT_PREFIX}${CMAKE_PROJECT_NAME}-daemon)
set (DAEMON_NAME ${GIT_PREFIX}${CMAKE_PROJECT_NAME}-daemon)
set (ICON_NAME ${CMAKE_PROJECT_NAME})
set (APP_NAME "Notifier")
set (GENERIC_NAME "Reminders")
set (RELEASE_NAME "Loki")
set (COMMENT "A Reminders app")
set (DAEMON_COMMENT "Daemon that deals with sending reminder notifications.")
set (VERSION "0.1.2")
set (VERSION_INFO "Frequency support")

#data directory stuff
include (GNUInstallDirs)
set (PREFIX ${CMAKE_INSTALL_PREFIX})
set (DATADIR ${CMAKE_INSTALL_PREFIX}/share)
set (PKG_DATADIR ${DATADIR}/${CMAKE_PROJECT_NAME})
set (DOLLAR "$")


# Add 'make dist' command for creating release tarball
set (CPACK_PACKAGE_VERSION ${VERSION})
set (CPACK_SOURCE_GENERATOR "TGZ")
set (CPACK_SOURCE_PACKAGE_FILE_NAME "${CMAKE_PROJECT_NAME}-${CPACK_PACKAGE_VERSION}")
set (CPACK_SOURCE_IGNORE_FILES "/build/;/.bzr/;/.bzrignore;~$;${CPACK_SOURCE_IGNORE_FILES}")
    # the oldest stable cmake version we support
    cmake_minimum_required (VERSION 2.6)

    # tell cmake where its modules can be found in our project directory
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)
    list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/src)

    # where we install data directory (if we have any)
    set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")

    # what to call that directory where we install data too
    set (PKGDATADIR "${DATADIR}/com.github.Timecraft.notifier")

    set (EXEC_NAME "com.github.timecraft.notifier")
    set (RELEASE_NAME "Notify how often?")
    set (VERSION "0.1.2")
    set (VERSION_INFO "Notifier now supports reminder frequencies.")

    #configuration file
configure_file (${CMAKE_SOURCE_DIR}/src/Config.vala.cmake ${CMAKE_SOURCE_DIR}/src/Config.vala)

    #some definitions
add_definitions(-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\")
add_definitions(-DVALA_VERSION="${VALA_SHORTVER}")
add_definitions(-w) # Disable gcc warnings

    # we're about to use pkgconfig to make sure dependencies are installed so let's find pkgconfig first
    find_package(PkgConfig)

    # now let's actually check for the required dependencies
    pkg_check_modules(DEPS REQUIRED gtk+-3.0)


pkg_check_modules(SQLITE3 REQUIRED sqlite3)
set(CFLAGS
    ${SQLITE3_CFLAGS} ${SQLITE3_CFLAGS_OTHER} )
add_definitions(${CFLAGS})

set(LIBS
    ${SQLITE3_LIBRARIES}
    )
link_libraries(${LIBS})

set(LIB_PATHS
    ${SQLITE3_LIBRARY_DIRS}
    )
link_directories(${LIB_PATHS})



    # make sure we have vala
    find_package(Vala REQUIRED)

    # make sure we use vala
    include(ValaVersion)
    # make sure it's the desired version of vala
    ensure_vala_version("0.16" MINIMUM)

    # files we want to compile
    include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME}
        src/notifier.vala


    # tell what libraries to use when compiling
    PACKAGES

        gtk+-3.0
        sqlite3



    )

    #some other necessary things

set(NORMAL_CFLAGS ${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
set(NORMAL_LINK_DIRS ${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})
set(NORMAL_LIBRARIES ${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})

add_definitions (${DEPS_CFLAGS} ${LIBSOURCE_CFLAGS} ${GCONF_CFLAGS})
link_libraries (${DEPS_LIBRARIES} ${LIBSOURCE_LIBRARIES} ${GCONF_LIBRARIES})
link_directories (${DEPS_LIBRARY_DIRS} ${LIBSOURCE_LIBRARY_DIRS} ${GCONF_LIBRARY_DIRS})


#include source path
include_directories(${CMAKE_BINARY_DIR}/src)
    # tell cmake what to call the executable we just made
    add_executable(${EXEC_NAME} ${VALA_C})

    # install the binaries we just made
    install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)



    #install daemon .desktop
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.timecraft.notifier-daemon.desktop DESTINATION /etc/xdg/autostart)

    #install icons
    install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/icons/16/com.github.timecraft.notifier.svg"
  DESTINATION share/icons/hicolor/16x16/apps)

   install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/icons/32/com.github.timecraft.notifier.svg"
  DESTINATION share/icons/hicolor/32x32/apps)

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/icons/64/com.github.timecraft.notifier.svg"
  DESTINATION share/icons/hicolor/64x64/apps)

  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/icons/128/com.github.timecraft.notifier.svg"
  DESTINATION share/icons/hicolor/128x128/apps)

  install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/data/icons/256/com.github.timecraft.notifier.svg"
  DESTINATION share/icons/hicolor/128x128/apps)


    # install our .desktop file so the Applications Menu will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.timecraft.notifier.desktop DESTINATION ${DATADIR}/applications/)
    # install our .appdata.xml file so AppCenter will see it
    install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/com.github.timecraft.notifier.appdata.xml DESTINATION ${DATADIR}/metainfo/)


add_subdirectory(src)
