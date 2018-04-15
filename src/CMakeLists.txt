
set (PKGDATADIR "${DATADIR}/com.github.timecraft.notifier")
set (EXEC_NAME "com.github.timecraft.notifier")
set (EXEC_NAME_DAEMON "com.github.timecraft.notifier-daemon")



if( NOT CMAKE_BUILD_TYPE )
	set(CMAKE_BUILD_TYPE Release)
endif()

# make sure we have vala
find_package(Vala REQUIRED)
# make sure we use vala
include(ValaVersion)
# make sure it's the desired version of vala
ensure_vala_version("0.16" MINIMUM)

find_package(PkgConfig)


pkg_check_modules(DEPS REQUIRED gtk+-3.0 sqlite3 glib-2.0)

 include(ValaPrecompile)
    vala_precompile(VALA_C ${EXEC_NAME_DAEMON}

        notifier-daemon.vala
       # config.vala
PACKAGES
        gtk+-3.0
        sqlite3
        glib-2.0

    )

add_executable(${EXEC_NAME_DAEMON} ${VALA_C})
install (TARGETS ${EXEC_NAME_DAEMON} RUNTIME DESTINATION bin)
