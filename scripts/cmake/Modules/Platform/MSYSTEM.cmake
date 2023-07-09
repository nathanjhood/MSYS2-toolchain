
message(STATUS "Enter: ${CMAKE_CURRENT_LIST_FILE}")

# message(STATUS "MSYSTEM Platform info loading...")


#set(UNIX 1) # Don't set 'UNIX' for MinGW!!! ;)
set(MINGW 1) # ``True`` when using MinGW
set(WIN32 1) # Set to ``True`` when the target system is Windows, including Win64.



option(OPTION_USE_DSX_BINUTILS "(Inactive) Use the BinUtils programs found under '<rootDir>/<packagePrefix>' for DirectX compatibility instead of standard BinUtils." OFF)
mark_as_advanced(OPTION_USE_DSX_BINUTILS)


#########################################################################
# GLOBAL PACKAGE OPTIONS
#   These are default values for the options=() settings
#########################################################################
#
# Makepkg defaults: OPTIONS=(!strip docs libtool staticlibs emptydirs !zipman !purge !debug !lto)
#  A negated option will do the opposite of the comments below.
#
#-- strip:      Strip symbols from binaries/libraries
#-- docs:       Save doc directories specified by DOC_DIRS
#-- libtool:    Leave libtool (.la) files in packages
#-- staticlibs: Leave static library (.a) files in packages
#-- emptydirs:  Leave empty directories in packages
#-- zipman:     Compress manual (man and info) pages in MAN_DIRS with gzip
#-- purge:      Remove files specified by PURGE_TARGETS
#-- debug:      Add debugging flags as specified in DEBUG_* variables
#-- lto:        Add compile flags for building with link time optimization


# Options handler...

option(OPTION_DOCS "Save doc directories specified by <DOC_DIRS>." ON)
option(OPTION_LIBTOOL "Leave libtool (.la) files in packages." OFF)
option(OPTION_STATIC_LIBS "Leave static library (.a) files in packages." ON)
option(OPTION_EMPTY_DIRS "Leave empty directories in packages." ON)
option(OPTION_ZIPMAN "Compress manual (man and info) pages in <MAN_DIRS> with gzip." ON)
option(OPTION_PURGE "Remove files specified by <PURGE_TARGETS>." ON)
option(OPTION_DEBUG "Add debugging flags as specified in <DEBUG_*> variables." OFF)
option(OPTION_LTO "Add compile flags for building with link time optimization." OFF)

mark_as_advanced(OPTION_DOCS)
mark_as_advanced(OPTION_LIBTOOL)
mark_as_advanced(OPTION_STATIC_LIBS)
mark_as_advanced(OPTION_EMPTY_DIRS)
mark_as_advanced(OPTION_ZIPMAN)
mark_as_advanced(OPTION_PURGE)
mark_as_advanced(OPTION_DEBUG)
mark_as_advanced(OPTION_LTO)
# option(OPTION_STRIP "Strip symbols from binaries/libraries." ON)
# if(OPTION_STRIP)
#     set(OPTION_STRIP_FLAG strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
#     #-- Options to be used when stripping binaries. See `man strip' for details.
#     if(NOT DEFINED STRIP_BINARIES)
#         set(STRIP_BINARIES --strip-all CACHE STRING "Options to be used when stripping binaries. See `man strip' for details." FORCE)
#     endif()
# else()
#     set(OPTION_STRIP_FLAG !strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

if(OPTION_DOCS)
    set(OPTION_DOCS_FLAG docs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_DOCS_FLAG !docs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_LIBTOOL)
    set(OPTION_LIBTOOL_FLAG libtool) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_LIBTOOL_FLAG !libtool) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_STATIC_LIBS)
    set(OPTION_STATIC_LIBS_FLAG staticlibs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_STATIC_LIBS_FLAG !staticlibs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_EMPTY_DIRS)
    set(OPTION_EMPTY_DIRS_FLAG emptydirs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_EMPTY_DIRS_FLAG !emptydirs) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_ZIPMAN)
    set(OPTION_ZIPMAN_FLAG zipman) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_ZIPMAN_FLAG !zipman) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_PURGE)
    set(OPTION_PURGE_FLAG purge) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_PURGE_FLAG !purge) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_DEBUG)
    set(OPTION_DEBUG_FLAG debug) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_DEBUG_FLAG !debug) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_LTO)
    set(OPTION_LTO_FLAG lto) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_LTO_FLAG !lto) # CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()


#########################################################################
# BUILD ENVIRONMENT
#########################################################################
#
# Makepkg defaults: BUILDENV=(!distcc !color !ccache check !sign)
#  A negated environment option will do the opposite of the comments below.
#
#-- distcc:   Use the Distributed C/C++/ObjC compiler
#-- color:    Colorize output messages
#-- ccache:   Use ccache to cache compilation
#-- check:    Run the check() function if present in the PKGBUILD
#-- sign:     Generate PGP signature file

option(OPTION_ENABLE_DISTCC "(Inactive) Use the Distributed C/C++/ObjC compiler." OFF)
option(OPTION_ENABLE_COLOR "(Inactive) Colorize output messages." ON)
option(OPTION_ENABLE_CCACHE "(Inactive) Use ccache to cache compilation." OFF)
option(OPTION_ENABLE_CHECK "(Inactive) Run the check() function if present in the PKGBUILD." ON)
option(OPTION_ENABLE_SIGN "(Inactive) Generate PGP signature file" OFF)

mark_as_advanced(OPTION_ENABLE_DISTCC)
mark_as_advanced(OPTION_ENABLE_COLOR)
mark_as_advanced(OPTION_ENABLE_CCACHE)
mark_as_advanced(OPTION_ENABLE_CHECK)
mark_as_advanced(OPTION_ENABLE_SIGN)

if(OPTION_ENABLE_DISTCC)
    set(OPTION_ENABLE_DISTCC_FLAG "distcc")
else()
    set(OPTION_ENABLE_DISTCC_FLAG "!distcc")
endif()

if(OPTION_ENABLE_COLOR)
    set(OPTION_ENABLE_COLOR_FLAG "color")
else()
    set(OPTION_ENABLE_COLOR_FLAG "!color")
endif()

if(OPTION_ENABLE_CCACHE)
    set(OPTION_ENABLE_CCACHE_FLAG "ccache")
else()
    set(OPTION_ENABLE_CCACHE_FLAG "!ccache")
endif()

if(OPTION_ENABLE_CHECK)
    set(OPTION_ENABLE_CHECK_FLAG "check")
else()
    set(OPTION_ENABLE_CHECK_FLAG "!check")
endif()

if(OPTION_ENABLE_SIGN)
    set(OPTION_ENABLE_SIGN_FLAG "sign")
else()
    set(OPTION_ENABLE_SIGN_FLAG "!sign")
endif()

set(MSYS_BUILDENV)
list(APPEND MSYS_BUILDENV "${OPTION_ENABLE_DISTCC_FLAG}")
list(APPEND MSYS_BUILDENV "${OPTION_ENABLE_COLOR_FLAG}")
list(APPEND MSYS_BUILDENV "${OPTION_ENABLE_CCACHE_FLAG}")
list(APPEND MSYS_BUILDENV "${OPTION_ENABLE_CHECK_FLAG}")
list(APPEND MSYS_BUILDENV "${OPTION_ENABLE_SIGN_FLAG}")
set(MSYS_BUILDENV "${MSYS_BUILDENV}" CACHE STRING "A negated environment option will do the opposite of the comments." FORCE)

option(OPTION_ENABLE_DLAGENTS "" ON)
mark_as_advanced(OPTION_ENABLE_DLAGENTS)
if(OPTION_ENABLE_DLAGENTS)
    include(DLAGENTS OPTIONAL)
endif()



if(MSYSTEM STREQUAL "MINGW32")

    set(CONTITLE "MinGW x32")
    set(CONICON "${Z_MSYS_ROOT_DIR}/mingw32.ico")

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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)

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
    set(CONICON "${Z_MSYS_ROOT_DIR}/mingw64.ico")

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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)


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
    set(CONICON "${Z_MSYS_ROOT_DIR}/ucrt64.ico")

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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)

    # if(NOT DEFINED CFLAGS)
    #     set(CFLAGS) # Start a new list, if one doesn't exists
    # endif()
    # string(APPEND CFLAGS "-march=nocona ")
    # string(APPEND CFLAGS "-msahf ")
    # string(APPEND CFLAGS "-mtune=generic ")
    # string(APPEND CFLAGS "-pipe ")
    # string(APPEND CFLAGS "-Wp,-D_FORTIFY_SOURCE=2 ")
    # string(APPEND CFLAGS "-fstack-protector-strong ")
    # string(STRIP "${CFLAGS}" CFLAGS)
    # set(ENV{CFLAGS} "${CFLAGS}")
    # message(STATUS "CFLAGS = $ENV{CFLAGS}")

    # if(NOT DEFINED CXXFLAGS)
    #     set(CXXFLAGS)
    # endif()
    # string(APPEND CXXFLAGS "-march=nocona ")
    # string(APPEND CXXFLAGS "-msahf ")
    # string(APPEND CXXFLAGS "-mtune=generic ")
    # # string(APPEND CXXFLAGS "-std=") # STD version
    # # string(APPEND CXXFLAGS "-stdlib=") # STD lib
    # string(APPEND CXXFLAGS "-pipe ")
    # string(STRIP "${CXXFLAGS}" CXXFLAGS)
    # set(ENV{CXXFLAGS} "${CXXFLAGS}")
    # message(STATUS "CXXFLAGS = $ENV{CXXFLAGS}")

    # if(NOT DEFINED CPPFLAGS)
    #     set(CPPFLAGS)
    # endif()
    # string(APPEND CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1 ")
    # string(STRIP "${CPPFLAGS}" CPPFLAGS)
    # set(ENV{CPPFLAGS} "${CPPFLAGS}")
    # message(STATUS "CPPFLAGS = $ENV{CPPFLAGS}")

    # if(NOT DEFINED LDFLAGS)
    #     set(LDFLAGS)
    # endif()
    # string(APPEND LDFLAGS "-pipe ")
    # string(STRIP "${LDFLAGS}" LDFLAGS)
    # set(ENV{LDFLAGS} "${LDFLAGS}")
    # message(STATUS "LDFLAGS = $ENV{LDFLAGS}")

    # find_program(CC "${Z_MSYS_ROOT_DIR}/ucrt64/bin/gcc.exe" NO_CACHE)
    # if(CC)
    #     mark_as_advanced(CC)
    #     set(ENV{CC} "${CC}")
    #     message(STATUS "CC = $ENV{CC}")
    # else()
    #     message(WARNING "Could not set <CC> using path '${Z_MSYS_ROOT_DIR}/ucrt64/bin/gcc.exe'"
    #                     "You might need to run 'pacman -S ${MSYSTEM_CHOST}-toolchain' before
    #                     trying again."
    #     )
    #     unset(CC)
    # endif(CC)

    # find_program(CXX "${Z_MSYS_ROOT_DIR}/ucrt64/bin/g++.exe" NO_CACHE)
    # if(CXX)
    #     mark_as_advanced(CXX)
    #     set(ENV{CXX} "${CXX}")
    #     message(STATUS "CXX = $ENV{CXX}")
    # else()
    #     message(WARNING "Could not set <CC> using path '${Z_MSYS_ROOT_DIR}/ucrt64/bin/g++.exe'"
    #                     "You might need to run 'pacman -S ${MSYSTEM_CHOST}-toolchain' before
    #                     trying again."
    #     )
    #     unset(CXX)
    # endif(CXX)

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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)


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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)


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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)

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

    set(_CMAKE_TOOLCHAIN_PREFIX "${MSYSTEM_CHOST}" CACHE STRING "If the internal cmake variable _CMAKE_TOOLCHAIN_PREFIX is set, this is used as prefix for the Binary utils (e.g. arm-elf-g++.exe, arm-elf-ar.exe etc.)" FORCE)

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

set(SYSCONFDIR "${Z_MSYS_ROOT_DIR}/etc}")
set(CONFIG_SITE "${SYSCONFDIR}/config.site")

# set(ORIGINAL_TMP "${ORIGINAL_TMP:-${TMP}}")
# set(ORIGINAL_TEMP "${ORIGINAL_TEMP:-${TEMP}}")
set(TMP "${Z_MSYS_ROOT_DIR}/tmp")
set(TEMP "${Z_MSYS_ROOT_DIR}/tmp")

if(MSYSTEM STREQUAL "MSYS2")
    include(Platform/MSYS)
else()
    set(MINGW 1)
    set(WIN32 1)
    # Don't set 'UNIX' for MinGW :)

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
    # include(Platform/MSYSTEMPaths)

    # Also could be the exact spot to provide the DX BinUtils compatibility file paths...


    if(__MSYSTEM_PATHS_INCLUDED)
        return()
    endif()
    set(__MSYSTEM_PATHS_INCLUDED 1)

    #set(UNIX 1) # Don't set 'UNIX' for MinGW!!! ;)
    set(MINGW 1) # ``True`` when using MinGW
    set(WIN32 1) # Set to ``True`` when the target system is Windows, including Win64.

endif()

# message(STATUS "...MSYSTEM Platform info loaded.")
message(STATUS "Exit: ${CMAKE_CURRENT_LIST_FILE}")
