message(STATUS "Enter: ${CMAKE_CURRENT_LIST_FILE}")

macro(z_msys_find_installation_dir)
    # Detect msys2.ini to figure MSYS_ROOT_DIR
    set(Z_MSYS_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
    while(NOT DEFINED Z_MSYS_ROOT_DIR)
        if(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys2.ini")
            message(STATUS "Found ${Z_MSYS_ROOT_DIR_CANDIDATE}msys2.ini")
            set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
        elseif(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
            message(STATUS "Found ${Z_MSYS_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
            set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
        elseif(IS_DIRECTORY "${Z_MSYS_ROOT_DIR_CANDIDATE}")
            get_filename_component(Z_MSYS_ROOT_DIR_TEMP "${Z_MSYS_ROOT_DIR_CANDIDATE}" DIRECTORY)
            if(Z_MSYS_ROOT_DIR_TEMP STREQUAL Z_MSYS_ROOT_DIR_CANDIDATE)
                message(FATAL_ERROR "We have reached the root of the drive without finding '/msys2.ini'")
                break() # If unchanged, we have reached the root of the drive without finding '/msys2.ini'.
            endif()
            set(Z_MSYS_ROOT_DIR_CANDIDATE "${Z_MSYS_ROOT_DIR_TEMP}")
            unset(Z_MSYS_ROOT_DIR_TEMP)
        else()
            break()
        endif()
    endwhile()
    unset(Z_MSYS_ROOT_DIR_CANDIDATE)
endmacro()

macro(z_msys_set_msystem_vars)
    if(MSYSTEM STREQUAL "MINGW32")

        set(CONTITLE "MinGW x32")
        set(CONICON "${Z_MSYS_ROOT_DIR}/mingw32.ico")

        set(CARCH "i686")
        set(CHOST "i686-w64-mingw32")

        set(MINGW_CHOST "i686-w64-mingw32")
        set(MINGW_PREFIX "/mingw32")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/mingw32")
        set(MSYSTEM_CARCH "i686")
        set(MSYSTEM_CHOST "i686-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/i686/mingw32.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw32")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-i686-")

        # set(MAN_DIRS("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info}) )
        # set(DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc}) )
        # set(PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod) )

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "MINGW64")

        set(CONTITLE "MinGW x64")
        set(CONICON "${Z_MSYS_ROOT_DIR}/mingw64.ico")

        # set(CARCH "x86_64")
        # set(CHOST "x86_64-w64-mingw32")

        set(MINGW_CHOST "x86_64-w64-mingw32")
        set(MINGW_PREFIX "/mingw64")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-x86_64")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/mingw64")
        set(MSYSTEM_CARCH "x86_64")
        set(MSYSTEM_CHOST "x86_64-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/x86_64/mingw64.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw64")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-x86_64-")

        # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
        # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "UCRT64")

        set(CONTITLE "MinGW UCRT x64")
        set(CONICON "${Z_MSYS_ROOT_DIR}/ucrt64.ico")

        set(CARCH "x86_64")
        set(CHOST "x86_64-w64-mingw32")

        set(MINGW_CHOST "x86_64-w64-mingw32")
        set(MINGW_PREFIX "/ucrt64")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-ucrt-x86_64")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/ucrt64")
        set(MSYSTEM_CARCH "x86_64")
        set(MSYSTEM_CHOST "x86_64-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/ucrt64/ucrt64.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.ucrt64")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-ucrt-x86_64-")

        # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
        # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "CLANG64")

        set(CONTITLE "MinGW Clang x64")
        set(CONICON "clang64.ico")

        set(CARCH "x86_64")
        set(CHOST "x86_64-w64-mingw32")

        set(MINGW_CHOST "x86_64-w64-mingw32")
        set(MINGW_PREFIX "/clang64")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-x86_64")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/clang64")
        set(MSYSTEM_CARCH "x86_64")
        set(MSYSTEM_CHOST "x86_64-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/clang64/clang64.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang64")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-x86_64-")

        # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
        # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "CLANG32")

        set(CONTITLE "MinGW Clang x32")
        set(CONICON "clang32.ico")

        set(CARCH "i686")
        set(CHOST "i686-w64-mingw32")

        set(MINGW_CHOST "i686-w64-mingw32")
        set(MINGW_PREFIX "/mingw32")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/clang32")
        set(MSYSTEM_CARCH "i686")
        set(MSYSTEM_CHOST "i686-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/clang32/clang32.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang32")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-i686-")

        # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
        # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "CLANGARM64")

        set(CONTITLE "MinGW Clang ARM64")
        set(CONICON "clangarm64.ico")

        set(CARCH "aarch64")
        set(CHOST "aarch64-w64-mingw32")

        set(MINGW_CHOST "aarch64-w64-mingw32")
        set(MINGW_PREFIX "/clangarm64")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-aarch64")
        set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")

        set(MSYSTEM_PREFIX "/clang64")
        set(MSYSTEM_CARCH "x86_64")
        set(MSYSTEM_CHOST "x86_64-w64-mingw32")

        set(REPO_DB_URL "${MIRROR_URL}/mingw/clangarm64/clangarm64.db")
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clangarm64")
        set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-aarch64-")

        # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
        # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
        set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
        set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
        set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

    elseif (MSYSTEM STREQUAL "MSYS2")

        # Note that this currently *assumes* and only accounts for 'x86_64' msys installs...
        set(CONTITLE "MSYS2 MSYS")
        set(CONICON "msys2.ico")

        set(CARCH "x86_64") # Should probably either use 'uname -m' or host/target triplets
        set(CHOST "x86_64-pc-msys")

        #MINGW_CHOST="UNUSED"
        #MINGW_PREFIX="UNUSED"
        #MINGW_PACKAGE_PREFIX="UNUSED"

        set(MSYSTEM_PREFIX "/usr")
        set(MSYSTEM_CARCH "$(/usr/bin/uname -m)")
        set(MSYSTEM_CHOST "${MSYSTEM_CARCH}-pc-msys")

        set(REPO_DB_URL "${MIRROR_URL}/msys/x86_64/msys.db") # https://repo.msys2.org/msys/x86_64/msys.db
        set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.msys")
        set(REPO_PACKAGE_COMMON_PREFIX "")

        # set(PATH="${MSYS2_PATH}:/opt/bin${ORIGINAL_PATH:+:${ORIGINAL_PATH}}" # There are some cross-compiler dirs to add...
        set(PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig" "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig" "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")

        #DXSDK_DIR="UNUSED"

        # MAN_DIRS=({{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info})
        # DOC_DIRS=({,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc})
        # PURGE_TARGETS=({,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod)

        set(PKGDEST "${Z_MSYS_ROOT_DIR}/usr/var/packages")
        set(SRCDEST "${Z_MSYS_ROOT_DIR}/usr/var/sources")
        set(SRCPKGDEST "${Z_MSYS_ROOT_DIR}/usr/var/srcpackages")
        set(LOGDEST "${Z_MSYS_ROOT_DIR}/usr/var/makepkglogs")

    else()
        # message(FATAL_ERROR "Unsupported MSYSTEM: ${MSYSTEM}")
    endif()
endmacro()

macro(z_msys_set_msystem_env_vars)

    set(ENV{CONTITLE} "${CONTITLE}")
    set(ENV{CONICON} "${CONICON}")

    set(ENV{CARCH} "${CARCH}")
    set(ENV{CHOST} "${CHOST}")

    set(ENV{MINGW_CHOST} "${MINGW_CHOST}")
    set(ENV{MINGW_PREFIX} "${MINGW_PREFIX}")
    set(ENV{MINGW_PACKAGE_PREFIX} "${MINGW_PACKAGE_PREFIX}")
    set(ENV{MINGW_MOUNT_POINT} "${MINGW_MOUNT_POINT}")

    set(ENV{MSYSTEM_PREFIX} "${MSYSTEM_PREFIX}")
    set(ENV{MSYSTEM_CARCH} "${MSYSTEM_CARCH}")
    set(ENV{MSYSTEM_CHOST} "${MSYSTEM_CHOST}")

    set(ENV{REPO_DB_URL} "${REPO_DB_URL}")
    set(ENV{REPO_MIRROR_LIST} "${REPO_MIRROR_LIST}")
    set(ENV{REPO_PACKAGE_COMMON_PREFIX} "${REPO_PACKAGE_COMMON_PREFIX}")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(ENV{PKGDEST} "${PKGDEST}")
    set(ENV{SRCDEST} "${SRCDEST}")
    set(ENV{SRCPKGDEST} "${SRCPKGDEST}")
    set(ENV{LOGDEST} "${LOGDEST}")

    set(ENV{PATH} "${MSYS_PATH}")
    set(ENV{INFOPATH} "${MSYS_INFOPATH}")
    set(ENV{MANPATH} "${MSYS_MANPATH}")

endmacro()

macro(z_msys_get_base_paths)

    if(NOT DEFINED MSYS_PATH)
        set(MSYS_PATH) # Create a new list if we haven't already
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/bin")
        list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/usr/local/bin")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/bin")
        list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/usr/bin")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/bin")
        list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/bin")
    endif()

    if(NOT DEFINED MSYS_MANPATH)
        set(MSYS_MANPATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/man")
        list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/local/man")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/man")
        list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/share/man")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/man")
        list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/man")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/share/man")
        list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/share/man")
    endif()

    if(NOT DEFINED MSYS_INFOPATH)
        set(MSYS_INFOPATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/info")
        list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/local/info")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/info")
        list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/share/info")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/info")
        list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/info")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/share/info")
        list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/share/info")
    endif()

    if(NOT DEFINED PKG_CONFIG_PATH)
        set(PKG_CONFIG_PATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig")
        list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig")
        list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")
        list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/share/pkgconfig")
        list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/share/pkgconfig")
    endif()

    if(NOT DEFINED PKG_CONFIG_SYSTEM_INCLUDE_PATH)
        set(PKG_CONFIG_SYSTEM_INCLUDE_PATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/include")
        list(APPEND PKG_CONFIG_SYSTEM_INCLUDE_PATH "${Z_MSYS_ROOT_DIR}/usr/include")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/include")
        list(APPEND PKG_CONFIG_SYSTEM_INCLUDE_PATH "${Z_MSYS_ROOT_DIR}/include")
    endif()

    if(NOT DEFINED PKG_CONFIG_SYSTEM_LIBRARY_PATH)
        set(PKG_CONFIG_SYSTEM_LIBRARY_PATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/lib")
        list(APPEND PKG_CONFIG_SYSTEM_LIBRARY_PATH "${Z_MSYS_ROOT_DIR}/usr/lib")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/lib")
        list(APPEND PKG_CONFIG_SYSTEM_LIBRARY_PATH "${Z_MSYS_ROOT_DIR}/lib")
    endif()

    if(NOT DEFINED ACLOCAL_PATH)
        set(ACLOCAL_PATH)
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/share/aclocal")
        list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/usr/local/share/aclocal")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/aclocal")
        list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/usr/share/aclocal")
    endif()
    if(EXISTS "${Z_MSYS_ROOT_DIR}/share/aclocal")
        list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/share/aclocal")
    endif()
endmacro()

macro(z_msys_get_msystem_paths)

    if(MSYSTEM STREQUAL "MSYS2")

    elseif(DEFINED MSYSTEM)

        ## Original logic here...
        # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
        # set(MSYS2_PATH "${MINGW_MOUNT_POINT}/bin" "${MSYS2_PATH}" "${ORIGINAL_PATH}")

        if(NOT DEFINED MSYS_PATH)
            set(MSYS_PATH) # Start a list incase we didn't already...
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/bin")
            list(APPEND MSYS_PATH "${MINGW_MOUNT_POINT}/bin")
        endif()

        if(NOT DEFINED MSYS_MANPATH)
            set(MSYS_MANPATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/local/man")
            list(APPEND MSYS_MANPATH "${MINGW_MOUNT_POINT}/local/man")
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/share/man")
            list(APPEND MSYS_MANPATH "${MINGW_MOUNT_POINT}/share/man")
        endif()

        if(NOT DEFINED MSYS_INFOPATH)
            set(MSYS_INFOPATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/local/info")
            list(APPEND MSYS_INFOPATH "${MINGW_MOUNT_POINT}/local/info")
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/share/info")
            list(APPEND MSYS_INFOPATH "${MINGW_MOUNT_POINT}/share/info")
        endif()

        if(NOT DEFINED PKG_CONFIG_PATH)
            set(PKG_CONFIG_PATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/lib/pkgconfig")
            list(APPEND PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig")
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/share/pkgconfig")
            list(APPEND PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/share/pkgconfig")
        endif()

        if(NOT DEFINED PKG_CONFIG_SYSTEM_INCLUDE_PATH)
            set(PKG_CONFIG_SYSTEM_INCLUDE_PATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/include")
            list(APPEND PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
        endif()

        if(NOT DEFINED PKG_CONFIG_SYSTEM_LIBRARY_PATH)
            set(PKG_CONFIG_SYSTEM_LIBRARY_PATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/lib")
            list(APPEND PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
        endif()

        if(NOT DEFINED ACLOCAL_PATH)
            set(ACLOCAL_PATH)
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/usr/local/share/aclocal")
            list(APPEND ACLOCAL_PATH "${MINGW_MOUNT_POINT}/usr/local/share/aclocal")
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/usr/share/aclocal")
            list(APPEND ACLOCAL_PATH "${MINGW_MOUNT_POINT}/usr/share/aclocal")
        endif()
        if(EXISTS "${MINGW_MOUNT_POINT}/share/aclocal")
            list(APPEND ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal")
        endif()

        if(EXISTS "${MINGW_MOUNT_POINT}/${MINGW_CHOST}") # check if it exists
            if(NOT DEFINED MSYS_DXSDK_DIR) # check the the user didn't try to set it directly
                set(MSYS_DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}") # set the default
            endif()
            set(MSYS_DXSDK_DIR "${MSYS_DXSDK_DIR}" CACHE PATH "DirectX SDK compatible GNU BinUtils folder" FORCE) # cache the entry (as a PATH to transform the seperators) with a docstring
        endif()

    endif()


    set(MSYSTEM_BUILD_PREFIX         "${MINGW_MOUNT_POINT}/usr" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_INSTALL_PREFIX          "${MINGW_MOUNT_POINT}/usr/local" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)

    set(MSYSTEM_INCLUDEDIR              "${MINGW_MOUNT_POINT}/include" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_SRCDIR                  "${MINGW_MOUNT_POINT}/src" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_SYSCONFDIRDIR           "${MINGW_MOUNT_POINT}/etc" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)

    set(MSYSTEM_DATAROOTDIR             "${MINGW_MOUNT_POINT}" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_DATADIR                 "${MSYSTEM_DATAROOTDIR}/share" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_DOCDIR                  "${MSYSTEM_DATAROOTDIR}/doc" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_MANDIR                  "${MSYSTEM_DATAROOTDIR}/man" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_INFODIR                 "${MSYSTEM_DATAROOTDIR}/info" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_LOCALEDIR               "${MSYSTEM_DATAROOTDIR}/locale" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)

    set(MSYSTEM_CMAKEDIR                "${MSYSTEM_DATAROOTDIR}/cmake" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)

    set(MSYSTEM_EXEC_PREFIX             "${MSYSTEM_DATAROOTDIR}" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_BINDIR                  "${MSYSTEM_DATAROOTDIR}/bin" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_SBINDIR                 "${MSYSTEM_DATAROOTDIR}/sbin" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_LIBDIR                  "${MSYSTEM_DATAROOTDIR}/lib" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)
    set(MSYSTEM_LIBEXECDIR              "${MSYSTEM_DATAROOTDIR}/libexec" CACHE PATH      "<MSYSTEM>: Sub-system prefix." FORCE)


endmacro()

#
#Add the program-files folder(s) to the list of installation
#prefixes.
#
#Windows 64-bit Binary:
#
#    ENV{ProgramFiles(x86)} = [C:\Program Files (x86)]
#    ENV{ProgramFiles}      = [C:\Program Files]
#    ENV{ProgramW6432}      = [C:\Program Files] or <not set>
#
#Windows 32-bit Binary on 64-bit Windows:
#
#    ENV{ProgramFiles(x86)} = [C:\Program Files (x86)]
#    ENV{ProgramFiles}      = [C:\Program Files (x86)]
#    ENV{ProgramW6432}      = [C:\Program Files]
#
#Reminder when adding new locations computed from environment variables
#please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
#synchronized
macro(z_msys_add_win32_program_files_to_cmake_system_prefix_path)
    set(_programfiles "")
    foreach(v "ProgramW6432" "ProgramFiles" "ProgramFiles(x86)")
        if(DEFINED "ENV{${v}}")
            file(TO_CMAKE_PATH "$ENV{${v}}" _env_programfiles)
            list(APPEND _programfiles "${_env_programfiles}")
            unset(_env_programfiles)
        endif()
    endforeach()
    if(DEFINED "ENV{SystemDrive}")
        foreach(d "Program Files" "Program Files (x86)")
            if(EXISTS "$ENV{SystemDrive}/${d}")
                list(APPEND _programfiles "$ENV{SystemDrive}/${d}")
            endif()
        endforeach()
    endif()
    if(_programfiles)
        list(REMOVE_DUPLICATES _programfiles)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ${_programfiles})
    endif()
    unset(_programfiles)

endmacro()

#
#if MSYS_PATH_TYPE == "-inherit"
#
#    Inherit previous path. Note that this will make all of the
#    Windows path available in current shell, with possible
#    interference in project builds.
#
#if MSYS_PATH_TYPE == "-minimal"
#
#if MSYS_PATH_TYPE == "-strict"
#
#    Do not inherit any path configuration, and allow for full
#    customization of external path. This is supposed to be used
#    in special cases such as debugging without need to change
#    this file, but not daily usage.
#
macro(z_msys_set_msystem_path_type)
    if(NOT DEFINED MSYS_PATH_TYPE)
        set(MSYS_PATH_TYPE "inherit")
    endif()
    set(MSYS_PATH_TYPE "${MSYS_PATH_TYPE}" CACHE STRING " " FORCE)

    if(MSYS_PATH_TYPE STREQUAL "strict")

        # Do not inherit any path configuration, and allow for full customization
        # of external path. This is supposed to be used in special cases such as
        # debugging without need to change this file, but not daily usage.
        unset(ORIGINAL_PATH)

    elseif(MSYS_PATH_TYPE STREQUAL "inherit")

        # Inherit previous path. Note that this will make all of the Windows path
        # available in current run, with possible interference in project builds.
        set(ORIGINAL_PATH "$ENV{Path}" CACHE PATH "<PATH> environment variable." FORCE) # This one makes CMake transform the path seperators...
        set(ORIGINAL_PATH "${ORIGINAL_PATH}" CACHE PATH "<PATH> environment variable." FORCE)

    elseif(MSYS_PATH_TYPE STREQUAL "minimal")

        if(DEFINED ENV{WINDIR})
            set(WIN_ROOT "$ENV{WINDIR}" CACHE FILEPATH "" FORCE)
        else()
            if(DEFINED ENV{HOMEDRIVE})
                set(WIN_ROOT "$ENV{HOMEDRIVE}/Windows" CACHE FILEPATH "" FORCE)
            else()
                message(FATAL_ERROR "HELP!")
            endif()
        endif()

        set(ORIGINAL_PATH)
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32")
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}")
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32/Wbem")

        if(DEFINED Z_MSYS_POWERSHELL_PATH)
            list(APPEND ORIGINAL_PATH "${Z_MSYS_POWERSHELL_PATH}")
        else()
            list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32/WindowsPowerShell/v1.0/")
        endif()

        set(ORIGINAL_PATH "${ORIGINAL_PATH}" CACHE PATH "<PATH> environment variable." FORCE)

    endif()

endmacro()

function(z_msys_add_msystem_path_to_cmake_path list suffix)
    string(TOLOWER "${MSYSTEM}" _msystem_lower)
    set(msys_paths
        "${Z_MSYS_ROOT_DIR}/${_msystem_lower}${suffix}"

        #"${Z_MSYS_ROOT_DIR}/${_msystem_lower}/debug${suffix}"
    )
    # if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
    #     list(REVERSE msys_paths) # Debug build: Put Debug paths before Release paths.
    # endif()

    if(MSYS_PREFER_SYSTEM_LIBS)
        list(APPEND "${list}" "${msys_paths}")
    else()
        list(INSERT "${list}" "0" "${msys_paths}")
    endif()
    set("${list}" "${${list}}" PARENT_SCOPE)
endfunction()

macro(z_msys_add_msystem_cmake_to_system_prefix_path)
    if(NOT DEFINED CMAKE_SYSTEM_PREFIX_PATH)
        set(CMAKE_SYSTEM_PREFIX_PATH)
    endif()
    # also add the install directory of the running cmake to the search directories
    # CMAKE_ROOT is CMAKE_INSTALL_PREFIX/share/cmake, so we need to go two levels up
    get_filename_component(_CMAKE_INSTALL_DIR "${CMAKE_ROOT}" PATH)
    get_filename_component(_CMAKE_INSTALL_DIR "${_CMAKE_INSTALL_DIR}" PATH)
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${_CMAKE_INSTALL_DIR}")
endmacro()

#[===[.md:
# z_msys_set_powershell_path

Gets either the path to powershell or powershell core,
and places it in the variable Z_MSYS_POWERSHELL_PATH.
#]===]
function(z_msys_set_powershell_path)
    # Attempt to use pwsh if it is present; otherwise use powershell
    if(NOT DEFINED Z_MSYS_POWERSHELL_PATH)
        find_program(Z_MSYS_PWSH_PATH pwsh)
        if(Z_MSYS_PWSH_PATH)
            set(Z_MSYS_POWERSHELL_PATH "${Z_MSYS_PWSH_PATH}" CACHE INTERNAL "The path to the PowerShell implementation to use.")
        else()
            message(DEBUG "msys2: Could not find PowerShell Core; falling back to PowerShell")
            find_program(Z_MSYS_BUILTIN_POWERSHELL_PATH powershell REQUIRED)
            if(Z_MSYS_BUILTIN_POWERSHELL_PATH)
                set(Z_MSYS_POWERSHELL_PATH "${Z_MSYS_BUILTIN_POWERSHELL_PATH}" CACHE INTERNAL "The path to the PowerShell implementation to use.")
            else()
                message(WARNING "msys2: Could not find PowerShell; using static string 'powershell.exe'")
                set(Z_MSYS_POWERSHELL_PATH "powershell.exe" CACHE INTERNAL "The path to the PowerShell implementation to use.")
            endif()
        endif()
    endif() # Z_MSYS_POWERSHELL_PATH
endfunction()

if(NOT _MSYSTEM_IS_CONFIGURED)
    set(_MSYSTEM_IS_CONFIGURED 1) # include guard


## 1. Find Msys64 installation dir
z_msys_find_installation_dir()
## 2. Set MSYSTEM vars
z_msys_set_msystem_vars()
## 3. Set pwsh path
z_msys_set_powershell_path()
## 4. Inherit or dismiss the Windows %PATH% variable
z_msys_set_msystem_path_type()

z_msys_add_msystem_cmake_to_system_prefix_path()
# z_msys_add_win32_program_files_to_cmake_system_prefix_path()


#If set to 'ON', the paths under the current 'MSYSTEM' directory
#will be scanned first during file/program/lib lookup routines
option(OPTION_MSYS_PREFER_MSYSTEM_PATHS "If set to 'ON', the paths under the current 'MSYSTEM' directory will be scanned before the '<msysRoot>/usr' directory during file/program/lib lookup routines." ON)
if(OPTION_MSYS_PREFER_MSYSTEM_PATHS)
    z_msys_get_msystem_paths()
    z_msys_get_base_paths()
else()
    z_msys_get_base_paths()
    z_msys_get_msystem_paths()
endif()


option(OPTION_MSYS_PREFER_WIN32_PATHS "If set to 'ON', the paths under the calling environment's 'PATH' variable will be scanned before any other paths, during file/program/lib lookup routines" OFF)
if(ORIGINAL_PATH) # If ORIGINAL_PATH is empty, don't do anything with it, regardless of MSYS_PATH_TYPE (i.e., skip over it)
    if(OPTION_MSYS_PREFER_WIN32_PATHS)
        list(INSERT MSYS_PATH 0 "${ORIGINAL_PATH}")
    else()
        list(APPEND MSYS_PATH "${ORIGINAL_PATH}")
    endif()
endif()

# set(CMAKE_SYSTEM_PREFIX_PATH)
# if(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE STREQUAL "ONLY" OR
#     CMAKE_FIND_ROOT_PATH_MODE_LIBRARY STREQUAL "ONLY" OR
#     CMAKE_FIND_ROOT_PATH_MODE_PACKAGE STREQUAL "ONLY")
#     list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${Z_MSYS_ROOT_DIR}/")
# endif()

z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_PREFIX_PATH "")
# z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_PROGRAM_PATH "/bin")
set(CMAKE_SYSTEM_PROGRAM_PATH "${MSYS_PATH}")
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_INCLUDE_PATH "/include")
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_LIBRARY_PATH "/lib")
z_msys_add_msystem_path_to_cmake_path(CMAKE_FIND_ROOT_PATH "")

set(_ignored_msystems)
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw32")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang32")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clangarm64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/ucrt64")
list(REMOVE_ITEM _ignored_msystems "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")
set(CMAKE_SYSTEM_IGNORE_PREFIX_PATH "${_ignored_msystems}")
unset(_ignored_msystems)

z_msys_set_msystem_env_vars()

endif() # include guard

message(STATUS " ")
message(STATUS "Found MSYS2 Root directory:")
message(STATUS "'${Z_MSYS_ROOT_DIR}'")
message(STATUS " ")
message(STATUS "OPTION_MSYS_PREFER_MSYSTEM_PATHS = ${OPTION_MSYS_PREFER_MSYSTEM_PATHS}")
message(STATUS "OPTION_MSYS_PREFER_WIN32_PATHS = ${OPTION_MSYS_PREFER_WIN32_PATHS}")
message(STATUS " ")

set(CMAKE_FIND_ROOT_PATH "${CMAKE_FIND_ROOT_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_FIND_ROOT_PATH:")
foreach(_dir ${CMAKE_FIND_ROOT_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_SYSTEM_PREFIX_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_PREFIX_PATH:")
foreach(_dir ${CMAKE_SYSTEM_PREFIX_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_PREFIX_PATH:")
foreach(_dir ${CMAKE_PREFIX_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_SYSTEM_INCLUDE_PATH "${CMAKE_SYSTEM_INCLUDE_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_INCLUDE_PATH:")
foreach(_dir ${CMAKE_SYSTEM_INCLUDE_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_SYSTEM_PROGRAM_PATH "${CMAKE_SYSTEM_PROGRAM_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_PROGRAM_PATH:")
foreach(_dir ${CMAKE_SYSTEM_PROGRAM_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_SYSTEM_LIBRARY_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_LIBRARY_PATH:")
foreach(_dir ${CMAKE_SYSTEM_LIBRARY_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(CMAKE_SYSTEM_IGNORE_PREFIX_PATH "${CMAKE_SYSTEM_IGNORE_PREFIX_PATH}" CACHE PATH "")
message(STATUS "Found CMAKE_SYSTEM_IGNORE_PREFIX_PATH:")
foreach(_dir ${CMAKE_SYSTEM_IGNORE_PREFIX_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)


set(MSYS_PATH "${MSYS_PATH}" CACHE PATH "")
message(STATUS "Found PATH:")
foreach(_dir ${MSYS_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(MSYS_MANPATH "${MSYS_MANPATH}" CACHE PATH "")
message(STATUS "Found MANPATH:")
foreach(_dir ${MSYS_MANPATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(MSYS_INFOPATH "${MSYS_INFOPATH}" CACHE PATH "")
message(STATUS "Found INFOPATH:")
foreach(_dir ${MSYS_INFOPATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(PKG_CONFIG_PATH "${PKG_CONFIG_PATH}" CACHE PATH "")
message(STATUS "Found PKG_CONFIG_PATH:")
foreach(_dir ${PKG_CONFIG_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${PKG_CONFIG_SYSTEM_INCLUDE_PATH}" CACHE PATH "")
message(STATUS "Found PKG_CONFIG_SYSTEM_INCLUDE_PATH:")
foreach(_dir ${PKG_CONFIG_SYSTEM_INCLUDE_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${PKG_CONFIG_SYSTEM_LIBRARY_PATH}" CACHE PATH "")
message(STATUS "Found PKG_CONFIG_SYSTEM_LIBRARY_PATH:")
foreach(_dir ${PKG_CONFIG_SYSTEM_LIBRARY_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

set(ACLOCAL_PATH "${ACLOCAL_PATH}" CACHE PATH "")
message(STATUS "Found ACLOCAL_PATH:")
foreach(_dir ${ACLOCAL_PATH})
    message(STATUS "'${_dir}'")
endforeach()
message(STATUS " ")
unset(_dir)

# Later, this triggers 'include("CMakeFind${CMAKE_EXTRA_GENERATOR}" OPTIONAL)'
# Which picks up several useful include dirs...
set(CMAKE_EXTRA_GENERATOR "MSYS Makefiles" CACHE STRING "" FORCE)

message(STATUS "Exit: ${CMAKE_CURRENT_LIST_FILE}")
