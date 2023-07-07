
# Detect msys2.ini to figure MSYS_ROOT_DIR
set(Z_MSYS_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
while(NOT DEFINED Z_MSYS_ROOT_DIR)
    if(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(IS_DIRECTORY "${Z_MSYS_ROOT_DIR_CANDIDATE}")
        get_filename_component(Z_MSYS_ROOT_DIR_TEMP "${Z_MSYS_ROOT_DIR_CANDIDATE}" DIRECTORY)
        if(Z_MSYS_ROOT_DIR_TEMP STREQUAL Z_MSYS_ROOT_DIR_CANDIDATE)
            break() # If unchanged, we have reached the root of the drive without finding '/msys2.ini'.
        endif()
        set(Z_MSYS_ROOT_DIR_CANDIDATE "${Z_MSYS_ROOT_DIR_TEMP}")
        unset(Z_MSYS_ROOT_DIR_TEMP)
    else()
        break()
    endif()
endwhile()
unset(Z_MSYS_ROOT_DIR_CANDIDATE)

# If one CMAKE_FIND_ROOT_PATH_MODE_* variables is set to ONLY, to  make sure that ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}
# and ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/debug are searched, it is not sufficient to just add them to CMAKE_FIND_ROOT_PATH,
# as CMAKE_FIND_ROOT_PATH specify "one or more directories to be prepended to all other search directories", so to make sure that
# the libraries are searched as they are, it is necessary to add "/" to the CMAKE_PREFIX_PATH
if(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_LIBRARY STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_PACKAGE STREQUAL "ONLY")
    list(APPEND CMAKE_PREFIX_PATH "/")
endif()

if(MSYSTEM STREQUAL "MINGW32")

    set(CONTITLE "MinGW x32")
    set(CONICON "mingw32.ico")

    # set(CARCH "i686")
    # set(CHOST "i686-w64-mingw32")

    set(MINGW_CHOST "i686-w64-mingw32")
    set(MINGW_PREFIX "/mingw32")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/mingw32")
    set(MSYSTEM_CARCH "i686")
    set(MSYSTEM_CHOST "i686-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/i686/mingw32.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw32")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-i686-")

    # set(CC "gcc")
    # set(CXX "g++")

    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-march=pentium4 -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe -Wl,--no-seh -Wl,--large-address-aware")

    # set(MAN_DIRS("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info}) )
    # set(DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc}) )
    # set(PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod) )

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "MINGW64")

    set(CONTITLE "MinGW x64")
    set(CONICON "mingw64.ico")

    # set(CARCH "x86_64")
    # set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/mingw64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/mingw64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/x86_64/mingw64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-x86_64-")

    # set(CC "gcc")
    # set(CXX "g++")

    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "UCRT64")

    set(CONTITLE "MinGW UCRT x64")
    set(CONICON "ucrt64.ico")

    # set(CARCH "x86_64")
    # set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/ucrt64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-ucrt-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/ucrt64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/ucrt64/ucrt64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.ucrt64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-ucrt-x86_64-")

    # set(CC "gcc")
    # set(CXX "g++")
    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe")

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

    # set(CARCH "x86_64")
    # set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/clang64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clang64/clang64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-x86_64-")

    # set(CC "clang")
    # set(CXX "clang++")
    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe")

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

    # set(CARCH "i686")
    # set(CHOST "i686-w64-mingw32")

    set(MINGW_CHOST "i686-w64-mingw32")
    set(MINGW_PREFIX "/mingw32")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang32")
    set(MSYSTEM_CARCH "i686")
    set(MSYSTEM_CHOST "i686-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clang32/clang32.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang32")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-i686-")

    # set(CC "gcc")
    # set(CXX "g++")
    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-march=pentium4 -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe -Wl,--no-seh -Wl,--large-address-aware")

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

    # set(CARCH "aarch64")
    # set(CHOST "aarch64-w64-mingw32")

    set(MINGW_CHOST "aarch64-w64-mingw32")
    set(MINGW_PREFIX "/clangarm64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-aarch64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clangarm64/clangarm64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clangarm64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-aarch64-")

    # set(CC "clang")
    # set(CXX "clang++")
    # set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    # set(CFLAGS "-O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    # set(CXXFLAGS "-O2 -pipe")
    # set(LDFLAGS "-pipe")

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

    # set(CC "gcc")
    # set(CXX "g++")

    # set(CPPFLAGS "")
    # set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    # set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    # set(LDFLAGS "-pipe")

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

set(CONFIG_SITE "${Z_MSYS_ROOT_DIR}/etc/config.site")

# set(SYSCONFDIR "${SYSCONFDIR:=/etc}")

# set(ORIGINAL_TMP "${ORIGINAL_TMP:-${TMP}}")
# set(ORIGINAL_TEMP "${ORIGINAL_TEMP:-${TEMP}}")
set(TMP "${Z_MSYS_ROOT_DIR}/tmp")
set(TEMP "${Z_MSYS_ROOT_DIR}/tmp")


if(MSYSTEM STREQUAL "MSYS2")
    include(Platform/MSYS)
else()
    set(MINGW 1)
    set(WIN32 1)

    set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
    set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
    set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
    set(CMAKE_SHARED_MODULE_PREFIX "lib")
    set(CMAKE_SHARED_MODULE_SUFFIX ".dll")
    set(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
    set(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")

    set(CMAKE_EXECUTABLE_SUFFIX ".exe")          # .exe

    # Modules have a different default prefix that shared libs.
    set(CMAKE_MODULE_EXISTS 1)

    set(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")

    # Shared libraries on cygwin can be named with their version number.
    set(CMAKE_SHARED_LIBRARY_NAME_WITH_VERSION 1)

    ##-- Source: Platform/GNU

    # GCC is the default compiler on GNU/Hurd.
    set(CMAKE_DL_LIBS "dl")
    set(CMAKE_SHARED_LIBRARY_C_FLAGS "-fPIC")
    set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")
    set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")
    set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP ":")
    set(CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG "-Wl,-rpath-link,")
    set(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-Wl,-soname,")
    set(CMAKE_EXE_EXPORTS_C_FLAG "-Wl,--export-dynamic")

    # Debian policy requires that shared libraries be installed without
    # executable permission.  Fedora policy requires that shared libraries
    # be installed with the executable permission.  Since the native tools
    # create shared libraries with execute permission in the first place a
    # reasonable policy seems to be to install with execute permission by
    # default.  In order to support debian packages we provide an option
    # here.  The option default is based on the current distribution, but
    # packagers can set it explicitly on the command line.
    if(DEFINED CMAKE_INSTALL_SO_NO_EXE)

        # Store the decision variable in the cache.  This preserves any
    # setting the user provides on the command line.
    set(CMAKE_INSTALL_SO_NO_EXE "${CMAKE_INSTALL_SO_NO_EXE}" CACHE INTERNAL "Install .so files without execute permission.")

    else()

        # Store the decision variable as an internal cache entry to avoid
        # checking the platform every time.  This option is advanced enough
        # that only package maintainers should need to adjust it.  They are
        # capable of providing a setting on the command line.
        if(EXISTS "/etc/debian_version")
            set(CMAKE_INSTALL_SO_NO_EXE 1 CACHE INTERNAL "Install .so files without execute permission.")
        else()
            set(CMAKE_INSTALL_SO_NO_EXE 0 CACHE INTERNAL "Install .so files without execute permission.")
        endif()

    endif()

    set(CMAKE_LIBRARY_ARCHITECTURE_REGEX "[a-z0-9_]+(-[a-z0-9_]+)?-gnu[a-z0-9_]*")

    # These paths do their lookup backwards to prevent drive letter mangling!
    include(Platform/MSYSTEMPaths)

    # # Windows API on Cygwin
    # list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
    #   /usr/include/w32api
    # )

    # # Windows API on Cygwin
    # list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
    #   /usr/lib/w32api
    # )

    ##-- We perhaps have some custom path handling here in the case of the optional
    # appending of environment paths, etc, as part of the toolchain file. Or, it might
    # be better handled in that file itself.

    # Also could be the exact spot to provide the DX BinUtils compatibility file paths...


    ##-- These two vars also get overridden in Platform/MSYS... might be worth investigating
    # for equivalents!
    #set(CMAKE_SHARED_LIBRARY_PREFIX "msys-")
    #set(CMAKE_SHARED_MODULE_PREFIX "msys-")

endif()


# set(CMAKE_USER_MAKE_RULES_OVERRIDE "CMakeMSYSTEMFindMake" CACHE FILEPATH "" FORCE)
