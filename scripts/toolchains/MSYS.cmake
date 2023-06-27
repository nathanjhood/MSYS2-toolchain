if(NOT _MSYS_TOOLCHAIN)
    set(_MSYS_TOOLCHAIN 1)

    # if(ENABLE_MINGW64)

    #     set(CARCH "x86_64")
    #     set(CHOST "x86_64-pc-msys")

    #     #set(MSYSTEM_TITLE               "MinGW x64"                         CACHE STRING    "MinGW x64: Name of the build system." FORCE)
    #     set(MSYSTEM_TOOLCHAIN_VARIANT   gcc                                 CACHE STRING    "MinGW x64: Identification string of the compiler toolchain variant." FORCE)
    #     set(MSYSTEM_CRT_LIBRARY         msvcrt                              CACHE STRING    "MinGW x64: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    #     set(MSYSTEM_CXX_STD_LIBRARY     libstdc++                           CACHE STRING    "MinGW x64: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    #     set(MSYSTEM_PREFIX              "/usr"                          CACHE STRING    "MinGW x64: Sub-system prefix." FORCE)
    #     set(MSYSTEM_ARCH                "x86_64"                            CACHE STRING    "MinGW x64: Sub-system architecture." FORCE)
    #     set(MSYSTEM_PLAT                "x86_64-w64-mingw32"                CACHE STRING    "MinGW x64: Sub-system name string." FORCE)
    #     set(MSYSTEM_PACKAGE_PREFIX      "mingw-w64-x86_64"                  CACHE STRING    "MinGW x64: Sub-system package prefix." FORCE)
    #     set(MSYSTEM_ROOT                "${Z_MINGW64_ROOT_DIR}"     CACHE PATH      "MinGW x64: Root of the build system." FORCE)

    # endif()

    # if(ENABLE_MSYS2)
    set(MSYS2_TITLE               "MSYS2 MSYS"                        CACHE STRING    "Msys x64: Name of the build system." FORCE)
    set(MSYS2_TOOLCHAIN_VARIANT   gcc                                 CACHE STRING    "Msys x64: Identification string of the compiler toolchain variant." FORCE)
    set(MSYS2_CRT_LIBRARY         cygwin                              CACHE STRING    "Msys x64: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(MSYS2_CXX_STD_LIBRARY     libstdc++                           CACHE STRING    "Msys x64: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    set(MSYS2_PREFIX              "/mingw64"                          CACHE STRING    "Msys x64: Sub-system prefix." FORCE)
    set(MSYS2_ARCH                "x86_64"                            CACHE STRING    "Msys x64: Sub-system architecture." FORCE)
    set(MSYS2_PLAT                "x86_64-pc-msys"                    CACHE STRING    "Msys x64: Sub-system name string." FORCE)
    set(MSYS2_PACKAGE_PREFIX      "mingw-w64-x86_64"                  CACHE STRING    "Msys x64: Sub-system package prefix." FORCE)
    #set(MSYS2_ROOT                "${MSYS_ROOT}${MINGW64_PREFIX}"     CACHE PATH      "Msys x64: Root of the build system." FORCE)
    # endif()

    # Set toolchain package suffixes (i.e., '{mingw-w64-clang-x86_64}-avr-toolchain')...
    set(MSYSTEM_TOOLCHAIN_NATIVE_ARM_NONE_EABI          "${MSYSTEM_PACKAGE_PREFIX}-arm-none-eabi-toolchain" CACHE STRING "" FORCE)
    set(MSYSTEM_TOOLCHAIN_NATIVE_AVR                    "${MSYSTEM_PACKAGE_PREFIX}-avr-toolchain" CACHE STRING "" FORCE)
    set(MSYSTEM_TOOLCHAIN_NATIVE_RISCV64_UNKOWN_ELF     "${MSYSTEM_PACKAGE_PREFIX}-riscv64-unknown-elf-toolchain" CACHE STRING "The 'unknown elf' toolchain! Careful with this elf, it is not known." FORCE)
    set(MSYSTEM_TOOLCHAIN_NATIVE                        "${MSYSTEM_PACKAGE_PREFIX}-toolchain" CACHE STRING "" FORCE)

    # DirectX compatibility environment variable
    set(MSYSTEM_DXSDK_DIR "${MSYSTEM_ROOT}/${MINGW_CHOST}" CACHE PATH "DirectX compatibility environment variable." FORCE)

    # set(ACLOCAL_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${Z_MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
    list(APPEND ACLOCAL_PATH
        "${MSYSTEM_ROOT}/share/aclocal"
        "${MSYSTEM_ROOT}/usr/share"
    )

    # set(PKG_CONFIG_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)
    list(APPEND PKG_CONFIG_PATH
        "${MSYSTEM_ROOT}/lib/pkgconfig"
        "${MSYSTEM_ROOT}/share/pkgconfig"
    )

    if(NOT DEFINED CRT_LINKAGE)
        set(CRT_LINKAGE "static")
    endif()

    # Need to override MinGW from MSYS_CMAKE_SYSTEM_NAME
    set(CMAKE_SYSTEM_NAME Windows CACHE STRING "The name of the operating system for which CMake is to build." FORCE)
    set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE)

    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")

        set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "Intended to indicate whether CMake is cross compiling, but note limitations discussed below.")

    endif() # (CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")

    set(__USE_MINGW_ANSI_STDIO  "1")                                   # CACHE STRING   "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2")                                   # CACHE STRING   "Fortify source definition." FORCE)

    find_program(LD  "ld" NO_CACHE) # DOC "The full path to the compiler for <LD>.")
    if(NOT DEFINED LDFLAGS)
        set(LDFLAGS "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for all build types.")
        string(APPEND LDFLAGS "-pipe ")

        set(LDFLAGS_DEBUG "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Debug> builds.")
        set(LDFLAGS_RELEASE "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Release> builds.")
        set(LDFLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <MinSizeRel> builds.")
        set(LDFLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <RelWithDebInfo> builds.")

    endif() # (NOT DEFINED LDFLAGS)
    set(LDFLAGS_FLAGS "${LDFLAGS}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for all build types." FORCE)
    set(LDFLAGS_DEBUG "${LDFLAGS_DEBUG}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Debug> builds.")
    set(LDFLAGS_RELEASE "${LDFLAGS_RELEASE}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Release> builds.")
    set(LDFLAGS_MINSIZEREL "${LDFLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <MinSizeRel> builds.")
    set(LDFLAGS_RELWITHDEBINFO "${LDFLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <RelWithDebInfo> builds.")
    set(LD_COMMAND "${LD} ${LDFLAGS}") # CACHE STRING "The 'C/C++' language linker utility command." FORCE)



    # set(LD                      "${MSYSTEM_ROOT}/bin/ld")              #CACHE FILEPATH "The full path to the linker <LD>." FORCE)
    # set(RC                      "${MSYSTEM_ROOT}/bin/windres")         #CACHE FILEPATH "" FORCE)

    find_program(MINGW64_CXX  "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-g++")
    find_program(CXX "c++" DOC "The full path to the compiler for <CXX>.")
    if(NOT DEFINED CXX_FLAGS)
        set(CXX_FLAGS "" CACHE STRING "Flags for the 'C++' language utility, for all build types.")
        string(APPEND CXX_FLAGS "-march=nocona ")
        string(APPEND CXX_FLAGS "-msahf ")
        string(APPEND CXX_FLAGS "-mtune=generic ")
        string(APPEND CXX_FLAGS "-pipe ")

        set(CXX_FLAGS_DEBUG "") # CACHE STRING "Flags for the 'C++' language utility, for <Debug> builds.")
        set(CXX_FLAGS_RELEASE "") # CACHE STRING "Flags for the 'C++' language utility, for <Release> builds.")
        set(CXX_FLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C++' language utility, for <MinSizeRel> builds.")
        set(CXX_FLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C++' language utility, for <RelWithDebInfo> builds.")

    endif() # (NOT DEFINED CC_FLAGS)
    set(CXX_FLAGS "${CXX_FLAGS}") # CACHE STRING "Flags for the 'C++' language utility, for all build types." FORCE)
    set(CXX_FLAGS_DEBUG "${CXX_FLAGS_DEBUG}") # CACHE STRING "Flags for the 'C++' language utility, for <Debug> builds.")
    set(CXX_FLAGS_RELEASE "${CXX_FLAGS_RELEASE}") # CACHE STRING "Flags for the 'C++' language utility, for <Release> builds.")
    set(CXX_FLAGS_MINSIZEREL "${CXX_FLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C++' language utility, for <MinSizeRel> builds.")
    set(CXX_FLAGS_RELWITHDEBINFO "${CXX_FLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C++' language utility, for <RelWithDebInfo> builds.")
    set(CXX_COMMAND "${CXX} ${CXX_FLAGS}") # CACHE STRING "The 'C++' language utility command." FORCE)

    set(MINGW64_CXX_FLAGS "${CXX_FLAGS}" CACHE STRING "Flags for the 'C++' language utility, for all build types." FORCE)
    set(MINGW64_CXX_FLAGS_DEBUG "${CXX_FLAGS_DEBUG}" CACHE STRING "Flags for the 'C++' language utility, for <Debug> builds.")
    set(MINGW64_CXX_FLAGS_RELEASE "${CXX_FLAGS_RELEASE}" CACHE STRING "Flags for the 'C++' language utility, for <Release> builds.")
    set(MINGW64_CXX_FLAGS_MINSIZEREL "${CXX_FLAGS_MINSIZEREL}" CACHE STRING "Flags for the 'C++' language utility, for <MinSizeRel> builds.")
    set(MINGW64_CXX_FLAGS_RELWITHDEBINFO "${CXX_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags for the 'C++' language utility, for <RelWithDebInfo> builds.")
    set(MINGW64_CXX_COMMAND "${MINGW64_CXX} ${CXX_FLAGS}" CACHE STRING "The 'C++' language utility command." FORCE)

    find_program(CC "cc" NO_CACHE) # DOC "The full path to the compiler for <CC>.")
    if(NOT DEFINED CC_FLAGS)
        set(CC_FLAGS "")
        string(APPEND CC_FLAGS "-march=nocona ")
        string(APPEND CC_FLAGS "-msahf ")
        string(APPEND CC_FLAGS "-mtune=generic ")
        # string(APPEND CC_FLAGS "-O2 ")
        string(APPEND CC_FLAGS "-pipe ")
        string(APPEND CC_FLAGS "-Wp,-D_FORTIFY_SOURCE=2 ")
        string(APPEND CC_FLAGS "-fstack-protector-strong ")

        set(CC_FLAGS_DEBUG "") # CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
        set(CC_FLAGS_RELEASE "") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
        set(CC_FLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
        set(CC_FLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")

    endif() # (NOT DEFINED CC_FLAGS)
    set(CC_FLAGS "${CC_FLAGS}") # CACHE STRING "Flags for the 'C' language utility." FORCE)
    set(CC_FLAGS_DEBUG "${CC_FLAGS_DEBUG}") # CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
    set(CC_FLAGS_RELEASE "${CC_FLAGS_RELEASE}") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
    set(CC_FLAGS_MINSIZEREL "${CC_FLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
    set(CC_FLAGS_RELWITHDEBINFO "${CC_FLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    set(CC_COMMAND "${CC} ${CC_FLAGS}") # CACHE STRING "The 'C' language utility command." FORCE)

    find_program(CPP "cc" "c++" NO_CACHE)
    set(CPP "${CPP} -E") # CACHE STRING "The full path to the pre-processor for <CC/CXX>." FORCE)
    if(NOT DEFINED CPP_FLAGS)
        set(CPP_FLAGS "")
        string(APPEND CPP_FLAGS "-D__USE_MINGW_ANSI_STDIO=1 ")
    endif() # (NOT DEFINED CPP_FLAGS)
    set(CPP_FLAGS "${CPP_FLAGS}") # CACHE STRING "Flags for the 'C/C++' language pre-processor utility, for all build types." FORCE)
    set(CPP_COMMAND "${CC} ${CPP_FLAGS}") # CACHE STRING "The 'C' language pre-processor utility command." FORCE)

    find_program(RC "rc" NO_CACHE) # DOC "The full path to the compiler for <RC>.")
    if(NOT DEFINED RC_FLAGS)
        set(RC_FLAGS "")
        set(RC_FLAGS_DEBUG "") # CACHE STRING "Flags for the 'C' language resource compiler utility, for <Debug> builds.")
        set(RC_FLAGS_RELEASE "") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
        set(RC_FLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
        set(RC_FLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")

    endif() # (NOT DEFINED RC_FLAGS)
    set(RC_FLAGS "${RC_FLAGS}") # CACHE STRING "Flags for the 'C' language utility." FORCE)
    set(RC_FLAGS_DEBUG "${RC_FLAGS_DEBUG}") # CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
    set(RC_FLAGS_RELEASE "${RC_FLAGS_RELEASE}") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
    set(RC_FLAGS_MINSIZEREL "${RC_FLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
    set(RC_FLAGS_RELWITHDEBINFO "${RC_FLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    set(RC_COMMAND "${RC} ${RC_FLAGS}") # CACHE STRING "The 'C' language utility command." FORCE)

    find_program(AR "ar" NO_CACHE) # DOC "The full path to the archiving utility.")
    find_program(MINGW64_AR  "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc-ar")
    if(NOT DEFINED RC_FLAGS)
        set(AR_FLAGS "-rv")
    endif() # (NOT DEFINED AR_FLAGS)
    set(AR_FLAGS "${AR_FLAGS}") # CACHE STRING "Flags for the archiving utility." FORCE)
    set(AR_COMMAND "${AR} ${AR_FLAGS}")


    find_program(CMAKE_C_COMPILER   "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc")
    find_program(CMAKE_CXX_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-g++")



    find_program(CMAKE_RC_COMPILER  "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-windres")
    if(NOT CMAKE_RC_COMPILER)
        find_program(CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres")
        if(NOT CMAKE_RC_COMPILER)
            find_program(CMAKE_RC_COMPILER "windres")
        endif() # (NOT CMAKE_RC_COMPILER)
    endif() # (NOT CMAKE_RC_COMPILER)

    find_program(CMAKE_AR   "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc-ar")
    if(NOT CMAKE_AR)
        find_program(CMAKE_AR "${Z_MINGW64_ROOT_DIR}/bin/ar")
        if(NOT CMAKE_AR)
            find_program(CMAKE_AR "ar")
        endif() # (NOT CMAKE_AR)
    endif() # (NOT CMAKE_AR)

    foreach(lang C CXX)

        set(CMAKE_${lang}_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
        # set(CMAKE_${lang}_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "") # this breaks the Kitware default flags etc...
        # set(CMAKE_${lang}_COMPILER_ID "GNU 13.1.0" CACHE STRING "")

    endforeach() # (lang C CXX)

    set(CMAKE_RC_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    get_property( _MSYS_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

    if(NOT _MSYS_IN_TRY_COMPILE)

        string(APPEND CMAKE_CXX_FLAGS_INIT " ${CXX_FLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT " ${CXX_FLAGS_RELEASE} ")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT " ${CXX_FLAGS_DEBUG} ")
        string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT " ${CXX_FLAGS_RELWITHDEBINFO} ")
        string(APPEND CMAKE_CXX_FLAGS_MINZIZEREL_INIT " ${CXX_FLAGS_MINZIZEREL} ")

        string(APPEND CMAKE_C_FLAGS_INIT " ${CC_FLAGS} ")
        string(APPEND CMAKE_C_FLAGS_DEBUG_INIT " ${CC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_C_FLAGS_RELEASE_INIT " ${CC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_C_FLAGS_MINSIZEREL_INIT " ${CC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_C_FLAGS_RELWITHDEBINFO_INIT " ${CC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_RC_FLAGS_INIT " ${RC_FLAGS} ")
        string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT " ${RC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_RC_FLAGS_RELEASE_INIT " ${RC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_RC_FLAGS_MINSIZEREL_INIT " ${RC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_RC_FLAGS_RELWITHDEBINFO_INIT " ${RC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_SHARED} ") # These strip flags should be enabled via cmake options...
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_BINARIES} ")

        if(CRT_LINKAGE STREQUAL "static")

            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT "-static ")
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT "-static ")

        endif() # (CRT_LINKAGE STREQUAL "static")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")

        string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")

    endif() # (NOT _MSYS_IN_TRY_COMPILE)

endif()

#[===[

#########################################################################
# BASE
#########################################################################

# Source:

NAME              = Msys x64 (???)                    Name of the build system (descriptive).
MSYSTEM           = MSYS                                Name of the build system (descriptive).
TOOLCHAIN_VARIANT = gcc                                 Identification string of the compiler toolchain variant.
CRT_LIBRARY       = cygwin                              Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds).
CXX_STD_LIBRARY   = libstdc++                           Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation).
PREFIX            = /mingw64                            Sub-system prefix.
ARCH              = x86_64                              Sub-system architecture.
PLAT              = x86_64-pc-msys                      Sub-system name string.
PACKAGE_PREFIX    = mingw-w64-x86_64                    Sub-system package prefix.
ROOT              = ${Z_MSYS_ROOT_DIR}                  Root of the build system.

# Source: $(msys64)/msys2.ini

#MSYS=winsymlinks:nativestrict
#MSYS=error_start:mingw64/bin/qtcreator.exe|-debug|<process-id>
#CHERE_INVOKING=1
#MSYS2_PATH_TYPE=inherit

# Source: ../../etc/profile.sh (condensed)

MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
MANPATH='/usr/local/man:/usr/share/man:/usr/man:/share/man'
INFOPATH='/usr/local/info:/usr/share/info:/usr/info:/share/info'

case "${MSYS2_PATH_TYPE:-minimal}" in
  strict)
    # Do not inherit any path configuration, and allow for full customization
    # of external path. This is supposed to be used in special cases such as
    # debugging without need to change this file, but not daily usage.
    unset ORIGINAL_PATH
    ;;
  inherit)
    # Inherit previous path. Note that this will make all of the Windows path
    # available in current shell, with possible interference in project builds.
    ORIGINAL_PATH="${ORIGINAL_PATH:-${PATH}}"
    ;;
  *)
    # Do not inherit any path configuration but configure a default Windows path
    # suitable for normal usage with minimal external interference.
    WIN_ROOT="$(PATH=${MSYS2_PATH} exec cygpath -Wu)"
    ORIGINAL_PATH="${WIN_ROOT}/System32:${WIN_ROOT}:${WIN_ROOT}/System32/Wbem:${WIN_ROOT}/System32/WindowsPowerShell/v1.0/"
esac

PATH="${MSYS2_PATH}:/opt/bin${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig"

ORIGINAL_TMP="${ORIGINAL_TMP:-${TMP}}"
ORIGINAL_TEMP="${ORIGINAL_TEMP:-${TEMP}}"
TMP="/tmp"
TEMP="/tmp"

#########################################################################
# MSYSTEM
#########################################################################

# Source: ../../etc/msystem.sh (condensed)

MSYSTEM="${MSYSTEM:-MSYS}"

# unset MINGW_CHOST
# unset MINGW_PREFIX
# unset MINGW_PACKAGE_PREFIX

MSYSTEM_PREFIX='/usr'
MSYSTEM_CARCH="$(/usr/bin/uname -m)"
MSYSTEM_CHOST="${MSYSTEM_CARCH}-pc-msys"


#########################################################################
# SOURCE ACQUISITION
#########################################################################

# Source: ../../etc/makepkg.conf

#-- The download utilities that makepkg should use to acquire sources

#  Format: '<protocol>::<agent> <flags>'

DLAGENTS=('file::/usr/bin/curl -gqC - -o %o %u'
          'ftp::/usr/bin/curl -gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u'
          'http::/usr/bin/curl -gqb "" -fLC - --retry 3 --retry-delay 3 -o %o %u'
          'https::/usr/bin/curl -gqb "" -fLC - --retry 3 --retry-delay 3 -o %o %u'
          'rsync::/usr/bin/rsync --no-motd -z %u %o'
          'scp::/usr/bin/scp -C %u %o')

#-- Other common tools:

# /usr/bin/snarf
# /usr/bin/lftpget -c
# /usr/bin/wget

#-- The package required by makepkg to download VCS sources:

#  Format: '<protocol>::<package>'

VCSCLIENTS=('bzr::bzr'
            'fossil::fossil'
            'git::git'
            'hg::mercurial'
            'svn::subversion')

#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################

CARCH="x86_64"
CHOST="x86_64-pc-msys"

#-- Compiler and Linker Flags
# -march (or -mcpu) builds exclusively for an architecture
# -mtune optimizes for an architecture, but builds for whole processor family

CC=gcc
CXX=g++
CPPFLAGS=
CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
LDFLAGS="-pipe"

#-- Make Flags: change this for DistCC/SMP systems
MAKEFLAGS="-j$(($(nproc)+1))"

#-- Debugging flags
DEBUG_CFLAGS="-ggdb -Og"
DEBUG_CXXFLAGS="-ggdb -Og"

#########################################################################
# BUILD ENVIRONMENT
#########################################################################

# Makepkg defaults: BUILDENV=(!distcc !color !ccache check !sign)
#  A negated environment option will do the opposite of the comments below.

#-- distcc:   Use the Distributed C/C++/ObjC compiler
#-- color:    Colorize output messages
#-- ccache:   Use ccache to cache compilation
#-- check:    Run the check() function if present in the PKGBUILD
#-- sign:     Generate PGP signature file

BUILDENV=(!distcc color !ccache check !sign)

#-- If using DistCC, your MAKEFLAGS will also need modification. In addition,
#-- specify a space-delimited list of hosts running in the DistCC cluster.
#DISTCC_HOSTS=""

#-- Specify a directory for package building.
#BUILDDIR=/tmp/makepkg

#########################################################################
# GLOBAL PACKAGE OPTIONS
#   These are default values for the options=() settings
#########################################################################

# Makepkg defaults: OPTIONS=(!strip docs libtool staticlibs emptydirs !zipman !purge !debug !lto)
#  A negated option will do the opposite of the comments below.

#-- strip:      Strip symbols from binaries/libraries
#-- docs:       Save doc directories specified by DOC_DIRS
#-- libtool:    Leave libtool (.la) files in packages
#-- staticlibs: Leave static library (.a) files in packages
#-- emptydirs:  Leave empty directories in packages
#-- zipman:     Compress manual (man and info) pages in MAN_DIRS with gzip
#-- purge:      Remove files specified by PURGE_TARGETS
#-- debug:      Add debugging flags as specified in DEBUG_* variables
#-- lto:        Add compile flags for building with link time optimization

OPTIONS=(strip docs !libtool staticlibs emptydirs zipman purge !debug !lto)

#-- File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512
INTEGRITY_CHECK=(sha256)
#-- Options to be used when stripping binaries. See `man strip' for details.
STRIP_BINARIES="--strip-all"
#-- Options to be used when stripping shared libraries. See `man strip' for details.
STRIP_SHARED="--strip-unneeded"
#-- Options to be used when stripping static libraries. See `man strip' for details.
STRIP_STATIC="--strip-debug"
#-- Manual (man and info) directories to compress (if zipman is specified)
MAN_DIRS=({{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info})
#-- Doc directories to remove (if !docs is specified)
DOC_DIRS=({,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc})
#-- Files to be removed from all packages (if purge is specified)
PURGE_TARGETS=({,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod)

#########################################################################
# PACKAGE OUTPUT
#########################################################################

# Default: put built package and cached source in build directory

#-- Destination: specify a fixed directory where all packages will be placed
PKGDEST=/var/packages
#-- Source cache: specify a fixed directory where source files will be cached
SRCDEST=/var/sources
#-- Source packages: specify a fixed directory where all src packages will be placed
SRCPKGDEST=/var/srcpackages
#-- Log files: specify a fixed directory where all log files will be placed
LOGDEST=/var/makepkglogs
#-- Packager: name/email of the person or organization building packages
PACKAGER="John Doe <john@doe.com>"
#-- Specify a key to use for package signing
GPGKEY=""

#########################################################################
# COMPRESSION DEFAULTS
#########################################################################

COMPRESSGZ=(gzip -c -f -n)
COMPRESSBZ2=(bzip2 -c -f)
COMPRESSXZ=(xz -c -z -T0 -)
COMPRESSZST=(zstd -c -T0 --ultra -20 -)
COMPRESSLRZ=(lrzip -q)
COMPRESSLZO=(lzop -q)
COMPRESSZ=(compress -c -f)
COMPRESSLZ4=(lz4 -q)
COMPRESSLZ=(lzip -c -f)

#########################################################################
# EXTENSION DEFAULTS
#########################################################################

PKGEXT='.pkg.tar.zst'
SRCEXT='.src.tar.zst'

#########################################################################
# OTHER
#########################################################################

#-- Command used to run pacman as root, instead of trying sudo and su
PACMAN_AUTH=()

#########################################################################
# TOOLCHAIN ACQUISITION
#########################################################################

# Source: ../get_cmake_vars/CMakeLists.txt (condensed)

# Programs:

CMAKE_AR
CMAKE_<LANG>_COMPILER_AR (Wrapper)
CMAKE_RANLIB
CMAKE_<LANG>_COMPILER_RANLIB
CMAKE_STRIP
CMAKE_NM
CMAKE_OBJDUMP
CMAKE_DLLTOOL
CMAKE_MT
CMAKE_LINKER
CMAKE_C_COMPILER
CMAKE_CXX_COMPILER
CMAKE_RC_COMPILER

# Flags:
CMAKE_<LANG>_FLAGS
CMAKE_<LANG>_FLAGS_<CONFIG>
CMAKE_RC_FLAGS
CMAKE_SHARED_LINKER_FLAGS
CMAKE_STATIC_LINKER_FLAGS
CMAKE_STATIC_LINKER_FLAGS_<CONFIG>
CMAKE_EXE_LINKER_FLAGS
CMAKE_EXE_LINKER_FLAGS_<CONFIG>

#########################################################################
# PACMAN OPTIONS
#########################################################################

# Source: ./etc/pacman.conf

# See the pacman.conf(5) manpage for option and repository directives

[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
HoldPkg     = pacman
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto


#########################################################################
# PACMAN REPOSITORIES
#########################################################################

#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have $repo replaced by the name of the current repo
#   - URLs will have $arch replaced by the name of the architecture

# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.

# See https://www.msys2.org/dev/mirrors

## Primary
Server = https://mirror.msys2.org/msys/$arch/
Server = https://repo.msys2.org/msys/$arch/

## Tier 1
Server = https://mirror.umd.edu/msys2/msys/$arch/
Server = https://mirror.yandex.ru/mirrors/msys2/msys/$arch/
Server = https://download.nus.edu.sg/mirror/msys2/msys/$arch/
Server = https://ftp.acc.umu.se/mirror/msys2.org/msys/$arch/
Server = https://ftp.nluug.nl/pub/os/windows/msys2/builds/msys/$arch/
Server = https://ftp.osuosl.org/pub/msys2/msys/$arch/
Server = https://mirror.internet.asn.au/pub/msys2/msys/$arch/
Server = https://mirror.selfnet.de/msys2/msys/$arch/
Server = https://mirror.ufro.cl/msys2/msys/$arch/
Server = https://mirrors.dotsrc.org/msys2/msys/$arch/
Server = https://mirrors.bfsu.edu.cn/msys2/msys/$arch/
Server = https://mirrors.tuna.tsinghua.edu.cn/msys2/msys/$arch/
Server = https://mirrors.ustc.edu.cn/msys2/msys/$arch/
Server = https://mirror.nju.edu.cn/msys2/msys/$arch/
Server = https://repo.extreme-ix.org/msys2/msys/$arch/
Server = https://mirrors.hit.edu.cn/msys2/msys/$arch/
Server = https://mirror.clarkson.edu/msys2/msys/$arch/
Server = https://quantum-mirror.hu/mirrors/pub/msys2/msys/$arch/
Server = https://mirror2.sandyriver.net/pub/software/msys2/msys/$arch/
Server = https://mirror.archlinux.tw/MSYS2/msys/$arch/

## Tier 2
Server = https://fastmirror.pp.ua/msys2/msys/$arch/
Server = https://ftp.cc.uoc.gr/mirrors/msys2/msys/$arch/
Server = https://mirror.jmu.edu/pub/msys2/msys/$arch/
Server = https://mirrors.piconets.webwerks.in/msys2-mirror/msys/$arch/
Server = https://www2.futureware.at/~nickoe/msys2-mirror/msys/$arch/
Server = https://mirrors.sjtug.sjtu.edu.cn/msys2/msys/$arch/
Server = https://mirrors.bit.edu.cn/msys2/msys/$arch/
Server = https://repo.casualgamer.ca/msys/$arch/
Server = https://mirrors.aliyun.com/msys2/msys/$arch/
Server = https://mirror.iscas.ac.cn/msys2/msys/$arch/
Server = https://mirrors.tencent.com/msys2/msys/$arch/

#]===]
