# Copyright (c) 2023
# Nathan J. Hood (@StoneyDSP) <nathanjhood@googlemail.com>.
# Licensed under the MIT License.
# All rights reserved.

# if(DEFINED ENV{MSYSTEM})
#     set(MSYSTEM "$ENV{MSYSTEM}" CACHE STRING "The detected MSYS sub-system in use." FORCE)
# elseif(DEFINED MSYSTEM)
#     set(MSYSTEM "${MSYSTEM}" CACHE STRING "The detected MSYS sub-system in use." FORCE)
# else()
#     set(MSYSTEM "MSYS" CACHE STRING "The detected MSYS sub-system in use." FORCE)
#     message(WARNING "Cannot find any valid msys2 subsystem specification...")
#     message(WARNING "please try passing '-DMSYSTEM:STRING=UCRT64' on the CMake invocation.")
#     message(WARNING "Attempting to use MSYS as a fallback.")
# endif()

set(MSYSTEM "MINGW64" CACHE STRING "The detected MSYS sub-system in use." FORCE)

# Find your msys64 installation root '<MSYS_ROOT>'...
if(NOT DEFINED MSYS_ROOT)
    if(EXISTS "$ENV{HOMEDRIVE}/msys64")
        set(MSYS_ROOT "$ENV{HOMEDRIVE}/msys64" CACHE PATH "Msys2 installation root directory." FORCE)
    else()
        message(FATAL_ERROR "Cannot find any valid msys2 installation..."
        "please try passing '-DMSYS_ROOT:PATH=<path/to/msys64>' on the CMake invocation."
        )
        # cmake_policy(POP)
        return()
    endif()
endif()

# Could keep these all exposed for potential cross-compiling...?
set(CLANGARM64_ROOT "${MSYS_ROOT}/clangarm64") #CACHE PATH "")
set(CLANG64_ROOT "${MSYS_ROOT}/clang64") #CACHE PATH "")
set(CLANG32_ROOT "${MSYS_ROOT}/clang32") #CACHE PATH "")
set(MINGW32_ROOT "${MSYS_ROOT}/mingw32") #CACHE PATH "")
set(MINGW64_ROOT "${MSYS_ROOT}/mingw64") #CACHE PATH "")
set(UCRT64_ROOT "${MSYS_ROOT}/ucrt64")  #CACHE PATH "")

if(EXISTS "$ENV{HOMEDRIVE}/cygwin64")
    set(CYGWIN64_ROOT "$ENV{HOMEDRIVE}/cygwin64") #CACHE PATH "Path to cygwin installation (64-bit)." FORCE)
endif()
if(EXISTS "$ENV{HOMEDRIVE}/cygwin32")
    set(CYGWIN32_ROOT "$ENV{HOMEDRIVE}/cygwin32") #CACHE PATH "Path to cygwin installation (32-bit)." FORCE)
endif()

# Create the standard MSYS2 filepath...
set(MSYS2_DEV_DIR "${MSYS_ROOT}/dev" CACHE PATH "")
set(MSYS2_ETC_DIR "${MSYS_ROOT}/etc" CACHE PATH "")
set(MSYS2_HOME_DIR "${MSYS_ROOT}/home" CACHE PATH "")
set(MSYS2_SHARE_DIR "${MSYS_ROOT}/share" CACHE PATH "")
set(MSYS2_TMP_DIR "${MSYS_ROOT}/tmp" CACHE PATH "")
set(MSYS2_USR_DIR "${MSYS_ROOT}/usr" CACHE PATH "")
set(MSYS2_VAR_DIR "${MSYS_ROOT}/var" CACHE PATH "")
# Additional cross-compiler toolchains are in here...
set(MSYS2_OPT_DIR "${MSYS_ROOT}/opt" CACHE PATH "")

# /etc/profile.sh...

# need prefixing...
set(MSYS2_PATH
    "/usr/local/bin"
    "/usr/bin"
    "/bin"
)
set(MANPATH
    "/usr/local/man"
    "/usr/share/man"
    "/usr/man"
    "/share/man"
)
set(INFOPATH
    "/usr/local/info"
    "/usr/share/info"
    "/usr/info"
    "/share/info"
)

# if(MSYS2_PATH_TYPE STREQUAL "strict")
#     # Do not inherit any path configuration, and allow for full customization
#     # of external path. This is supposed to be used in special cases such as
#     # debugging without need to change this file, but not daily usage.
#     unset (ORIGINAL_PATH)

# elseif(MSYS2_PATH_TYPE STREQUAL "inherit")
#     # Inherit previous path. Note that this will make all of the Windows path
#     # available in current shell, with possible interference in project builds.
#     set(ORIGINAL_PATH "${ORIGINAL_PATH}" "${PATH}")

# elseif(NOT DEFINED MSYS2_PATH_TYPE OR (MSYS2_PATH_TYPE STREQUAL "minimal"))
#     # Do not inherit any path configuration but configure a default Windows path
#     # suitable for normal usage with minimal external interference.
#     set(WIN_ROOT "$(PATH=${MSYS2_PATH} exec cygpath -Wu)") # Using cygpath to turn Window's PATH to unix vals... needs CMake-ifying.
#     set(ORIGINAL_PATH "${WIN_ROOT}/System32:${WIN_ROOT}:${WIN_ROOT}/System32/Wbem:${WIN_ROOT}/System32/WindowsPowerShell/v1.0/") # can use 'get_powershell_path()' here....

# endif()

# unset(MINGW_MOUNT_POINT)

#########################################################################
# ARCHITECTURE, COMPILE FLAGS
#########################################################################
#-- Compiler and Linker Flags
# -march (or -mcpu) builds exclusively for an architecture
# -mtune optimizes for an architecture, but builds for whole processor family

if(MSYSTEM STREQUAL MINGW64)

    if(NOT _VCPKG_MSYS_MINGW64_TOOLCHAIN)
    set(_VCPKG_MSYS_MINGW64_TOOLCHAIN 1)

    set(BUILDSYSTEM             "MinGW x64")                           #CACHE STRING   "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/mingw64")                #CACHE PATH     "Root of the build system." FORCE)

    if(NOT DEFINED CRT_LINKAGE)
        set(CRT_LINKAGE "static") # CACHE STRING "" FORCE)
    endif()

    set(TOOLCHAIN_VARIANT       gcc                                   CACHE STRING   "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             msvcrt                                CACHE STRING   "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libstdc++                             CACHE STRING   "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    set(CRT_LINKAGE             "${CRT_LINKAGE}"                      CACHE STRING   "" FORCE)
    set(MINGW64_ROOT            "${MSYS_ROOT}/mingw64"                CACHE PATH     "")

    set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING   "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING   "Fortify source definition." FORCE)

    set(CC                      "${MINGW64_ROOT}/bin/gcc")             #CACHE FILEPATH "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "${MINGW64_ROOT}/bin/g++")             #CACHE FILEPATH "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "${MINGW64_ROOT}/bin/ld")              #CACHE FILEPATH "The full path to the linker <LD>." FORCE)
    set(RC                      "${MINGW64_ROOT}/bin/windres")         #CACHE FILEPATH "" FORCE)

    set(CFLAGS                  "-march=nocona -msahf -mtune=generic -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong") #CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=nocona -msahf -mtune=generic -pipe") #CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1")          #CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe")                               #CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

    #-- Release build flags
    # set(RELEASE_CFLAGS          "-O2")                                 #CACHE STRING    "Default <CFLAGS_RELEASE> flags." FORCE)
    # set(RELEASE_CXXFLAGS        "-O2")                                 #CACHE STRING    "Default <CXXFLAGS_RELEASE> flags." FORCE)

    # #-- Debug build flags
    # set(DEBUG_CFLAGS            "-ggdb -Og")                           #CACHE STRING    "Default <CFLAGS_DEBUG> flags." FORCE)
    # set(DEBUG_CXXFLAGS          "-ggdb -Og")                           #CACHE STRING    "Default <CXXFLAGS_DEBUG> flags." FORCE)

    set(PREFIX                  "/mingw64")                            #CACHE PATH      "Sub-system prefix." FORCE)
    set(CARCH                   "x86_64")                              #CACHE STRING    "Sub-system architecture." FORCE)
    set(CHOST                   "x86_64-w64-mingw32")                  #CACHE STRING    "Sub-system name string." FORCE)

    set(MSYSTEM_PREFIX          "/mingw64"                            CACHE PATH      "Msystem prefix." FORCE)
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "Msystem architecture." FORCE)
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "Msystem name string." FORCE)

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "Sub-system prefix." FORCE)
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "Sub-system prefix." FORCE)
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-${MSYSTEM_CARCH}"          CACHE STRING    "Sub-system prefix." FORCE)

    # Need to override MinGW from VCPKG_CMAKE_SYSTEM_NAME
    set(CMAKE_SYSTEM_NAME Windows CACHE STRING "" FORCE)

    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
    endif()

    set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "")

    foreach(lang C CXX)
        set(CMAKE_${lang}_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-windows-gnu" CACHE STRING "")
    endforeach()

    find_program(CMAKE_C_COMPILER "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc")
    find_program(CMAKE_CXX_COMPILER "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-g++")
    find_program(CMAKE_RC_COMPILER "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-windres")

    if(NOT CMAKE_RC_COMPILER)
        find_program(CMAKE_RC_COMPILER "windres")
    endif()

    get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )
    if(NOT _CMAKE_IN_TRY_COMPILE)
        string(APPEND CMAKE_C_FLAGS_INIT " ${CFLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_INIT " ${CXXFLAGS} ")
        string(APPEND CMAKE_C_FLAGS_DEBUG_INIT " ${DEBUG_CFLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT " ${DEBUG_CXXFLAGS} ")
        string(APPEND CMAKE_C_FLAGS_RELEASE_INIT " ${RELEASE_CFLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT " ${RELEASE_CXXFLAGS} ")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_SHARED} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_BINARIES} ")
        if(CRT_LINKAGE STREQUAL "static")
            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT "-static ")
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT "-static ")
        endif()
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")
    endif()
    endif()

elseif(MSYSTEM STREQUAL MINGW32)

    set(BUILDSYSTEM             "MinGW x32"                           CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/mingw32"                CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       gcc                                   CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             msvcrt                                CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libstdc++                             CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

    set(CC                      "gcc"                                 CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "g++"                                 CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "ld"                                  CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=pentium4 -mtune=generic -O2 -pipe" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"          CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe -Wl,--no-seh -Wl,--large-address-aware" CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

    #-- Debugging flags
    set(DEBUG_CFLAGS            "-ggdb -Og"                           CACHE STRING    "Default <CFLAGS_DEBUG> flags." FORCE)
    set(DEBUG_CXXFLAGS          "-ggdb -Og"                           CACHE STRING    "Default <CXXFLAGS_DEBUG> flags." FORCE)

    set(PREFIX                  "/mingw32"                            CACHE PATH      "")
    set(CARCH                   "i686"                                CACHE STRING    "")
    set(CHOST                   "i686-w64-mingw32"                    CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/mingw32"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
    set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-${MSYSTEM_CARCH}"          CACHE STRING    "")

elseif(MSYSTEM STREQUAL CLANG64)

    set(BUILDSYSTEM             "MinGW Clang x64"                     CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/clang64"                CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       llvm                                  CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             ucrt                                  CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libc++                                CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

    set(CC                      "clang"                               CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "clang++"                             CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "lld"                                 CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=nocona -msahf -mtune=generic -O2 -pipe" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"          CACHE STRING "Default <CPPFLAGS> flags for pre-processor runs for all build types." FORCE)
    set(LDFLAGS                 "-pipe"                               CACHE STRING "Default <LD> flags for linker for all build types." FORCE)

    #-- Debugging flags
    set(DEBUG_CFLAGS            "-ggdb -Og"                           CACHE STRING "Default <CFLAGS_DEBUG> flags." FORCE)
    set(DEBUG_CXXFLAGS          "-ggdb -Og"                           CACHE STRING "Default <CXXFLAGS_DEBUG> flags." FORCE)

    set(PREFIX                  "/clang64"                            CACHE PATH      "")
    set(CARCH                   "x86_64"                              CACHE STRING    "")
    set(CHOST                   "x86_64-w64-mingw32"                  CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/clang64"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "")
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "")

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")

elseif(MSYSTEM STREQUAL CLANG32)

    set(BUILDSYSTEM             "MinGW Clang x32"                     CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/clang32"                CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       llvm                                  CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             ucrt                                  CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libc++                                CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

    set(CC                      "clang"                               CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "clang++"                             CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "lld"                                 CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=pentium4 -mtune=generic -O2 -pipe" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"         CACHE STRING     "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe -Wl,--no-seh -Wl,--large-address-aware" CACHE STRING "Default <LD> flags for linker for all build types." FORCE)

    set(PREFIX                  "/clang32"                            CACHE PATH      "")
    set(CARCH                   "i686"                                CACHE STRING    "")
    set(CHOST                   "i686-w64-mingw32"                    CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/clang32"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
    set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")

elseif(MSYSTEM STREQUAL CLANGARM64)

    set(BUILDSYSTEM             "MinGW Clang ARM64"                   CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/clangarm64"             CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       llvm                                  CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             ucrt                                  CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libc++                                CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

    set(CC                      "clang"                               CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "clang++"                             CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "lld"                                 CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-O2 -pipe"                           CACHE STRING    "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"          CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe"                               CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

    set(PREFIX                  "/clangarm64"                         CACHE PATH      "")
    set(CARCH                   "aarch64"                             CACHE STRING    "")
    set(CHOST                   "aarch64-w64-mingw32"                 CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/clangarm64"                         CACHE PATH      "")
    set(MSYSTEM_CARCH           "aarch64"                             CACHE STRING    "")
    set(MSYSTEM_CHOST           "aarch64-w64-mingw32"                 CACHE STRING    "")

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")

elseif(MSYSTEM STREQUAL UCRT64)

    set(BUILDSYSTEM             "MinGW UCRT x64"                      CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/ucrt64"                 CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       gcc                                   CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             ucrt                                  CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libstdc++                             CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(__USE_MINGW_ANSI_STDIO "1"                                    CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

    set(CC                      "gcc"                                 CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "g++"                                 CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "ld"                                  CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=nocona -msahf -mtune=generic -O2 -pipe" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"          CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe"                               CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

    set(PREFIX                  "/ucrt64"                             CACHE PATH      "")
    set(CARCH                   "x86_64"                              CACHE STRING    "")
    set(CHOST                   "x86_64-w64-mingw32"                  CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/ucrt64"                             CACHE PATH      "")
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "")
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "")

    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-ucrt-${MSYSTEM_CARCH}"     CACHE STRING    "")

elseif(MSYSTEM STREQUAL "MSYS")

    set(BUILDSYSTEM             "MSYS2 MSYS"                          CACHE STRING    "Name of the build system." FORCE)
    set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}"                        CACHE PATH      "Root of the build system." FORCE)

    set(TOOLCHAIN_VARIANT       gcc                                   CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
    set(CRT_LIBRARY             cygwin                                CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(CXX_STD_LIBRARY         libstdc++                             CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

    set(CARCH                   "x86_64"                              CACHE STRING    "" FORCE)
    set(CHOST                   "x86_64-pc-msys"                      CACHE STRING    "" FORCE)

    set(CC                      "gcc"                                 CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
    set(CXX                     "g++"                                 CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
    set(LD                      "ld"                                  CACHE FILEPATH "The full path to the linker <LD>." FORCE)

    set(CFLAGS                  "-march=nocona -msahf -mtune=generic -O2 -pipe" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
    set(CXXFLAGS                "-march=nocona -msahf -mtune=generic -O2 -pipe" CACHE STRING "" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
    set(CPPFLAGS                ""                                    CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
    set(LDFLAGS                 "-pipe"                               CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

    #-- Debugging flags
    set(DEBUG_CFLAGS "-ggdb -Og" CACHE STRING "" FORCE)
    set(DEBUG_CXXFLAGS "-ggdb -Og" CACHE STRING "" FORCE)

    execute_process(
        COMMAND "${MSYS_ROOT}/usr/bin/uname -m"
        WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
        OUTPUT_VARIABLE DETECTED_CARCH
        # COMMAND_ERROR_IS_FATAL ANY
    )

    set(PREFIX                  "/msys64"                     CACHE PATH      "")
    set(CARCH                   "${DETECTED_CARCH}"           CACHE STRING    "")
    set(CHOST                   "${DETECTED_CARCH}-pc-msys"   CACHE STRING    "")

    set(MSYSTEM_PREFIX          "/usr"                        CACHE PATH      "")
    set(MSYSTEM_CARCH           "${DETECTED_CARCH}"           CACHE STRING    "")
    set(MSYSTEM_CHOST           "${DETECTED_CARCH}-pc-msys"   CACHE STRING    "")

else()
    message(FATAL_ERROR "Unsupported MSYSTEM: ${MSYSTEM}")
    # cmake_policy(POP)
    return()
endif()


# Note that some packages cannot be mixed together, likely to prevent setting
# linkage between mixed C runtimes (which is widely unsupported and not recommended).
set(MINGW_W64_CROSS_CLANG_TOOLCHAIN_PACKAGES
    mingw-w64-cross-clang
    mingw-w64-cross-clang-crt
    mingw-w64-cross-clang-headers
    CACHE STRING "Packages from command: 'pacman -S mingw-w64-cross-clang-toolchain'."
)
set(MINGW_W64_CROSS_UCRT_TOOLCHAIN_PACKAGES
    mingw-w64-cross-ucrt-ucrt
    mingw-w64-cross-ucrt-headers
    CACHE STRING "Packages from command: 'pacman -S mingw-w64-cross-ucrt-toolchain'."
)
set(MINGW_W64_CROSS_TOOLCHAIN_PACKAGES
    mingw-w64-cross-binutils
    mingw-w64-cross-crt
    mingw-w64-cross-gcc
    mingw-w64-cross-headers
    mingw-w64-cross-tools
    mingw-w64-cross-windows-default-manifest
    mingw-w64-cross-winpthreads
    mingw-w64-cross-winstorecompat
    mingw-w64-cross-zlib
    CACHE STRING "Packages from command: 'pacman -S mingw-w64-cross-toolchain'."
)
set(MINGW_W64_CROSS_PACKAGES
    mingw-w64-cross-binutils
    mingw-w64-cross-crt
    mingw-w64-cross-gcc
    mingw-w64-cross-headers
    mingw-w64-cross-tools
    mingw-w64-cross-windows-default-manifest
    mingw-w64-cross-winpthreads
    mingw-w64-cross-winstorecompat
    mingw-w64-cross-zlib
    CACHE STRING "Packages from command: 'pacman -S mingw-w64-cross'."
) # Actually identical to the previous var...

if ((MSYSTEM STREQUAL MINGW64) OR
    (MSYSTEM STREQUAL MINGW32) OR
    (MSYSTEM STREQUAL CLANG64) OR
    (MSYSTEM STREQUAL CLANG32) OR
    (MSYSTEM STREQUAL CLANGARM64) OR
    (MSYSTEM STREQUAL UCRT64)
    )

    # Flag config name fixup...
    set(CFLAGS_DEBUG              "${DEBUG_CFLAGS}")                  #CACHE STRING "Default <CFLAGS_DEBUG> flags." FORCE)
    set(CFLAGS_RELEASE            "${RELEASE_CFLAGS}")                #CACHE STRING "Default <CFLAGS_RELEASE> flags." FORCE)
    set(CFLAGS_MINSIZEREL         "${MINSIZEREL_CFLAGS}")             #CACHE STRING "Default <CFLAGS_MINSIZEREL> flags." FORCE)
    set(CFLAGS_RELWITHDEBINFO     "${RELWITHDEBINFO_CFLAGS}")         #CACHE STRING "Default <CFLAGS_RELWITHDEBINFO> flags." FORCE)

    set(CXXFLAGS_DEBUG            "${DEBUG_CXXFLAGS}")                #CACHE STRING "Default <CXXFLAGS_DEBUG> flags." FORCE)
    set(CXXFLAGS_RELEASE          "${RELEASE_CXXFLAGS}")              #CACHE STRING "Default <CXXFLAGS_RELEASE> flags." FORCE)
    set(CXXFLAGS_MINSIZEREL       "${MINSIZEREL_CXXFLAGS}")           #CACHE STRING "Default <CXXFLAGS_MINSIZEREL> flags." FORCE)
    set(CXXFLAGS_RELWITHDEBINFO   "${RELWITHDEBINFO_CXXFLAGS}")       #CACHE STRING "Default <CXXFLAGS_RELWITHDEBINFO> flags." FORCE)

    set(CPPFLAGS_DEBUG            "${DEBUG_CPPFLAGS}")                #CACHE STRING "Default <CPPFLAGS_DEBUG> flags." FORCE)
    set(CPPFLAGS_RELEASE          "${RELEASE_CPPFLAGS}")              #CACHE STRING "Default <CPPFLAGS_RELEASE> flags." FORCE)
    set(CPPFLAGS_MINSIZEREL       "${MINSIZEREL_CPPFLAGS}")           #CACHE STRING "Default <CPPFLAGS_MINSIZEREL> flags." FORCE)
    set(CPPFLAGS_RELWITHDEBINFO   "${RELWITHDEBINFO_CPPFLAGS}")       #CACHE STRING "Default <CPPFLAGS_RELWITHDEBINFO> flags." FORCE)

    set(RCFLAGS_DEBUG             "${DEBUG_RCFLAGS}")                 #CACHE STRING "Default <CFLAGS_DEBUG> flags." FORCE)
    set(RCFLAGS_RELEASE           "${RELEASE_RCFLAGS}")               #CACHE STRING "Default <CFLAGS_RELEASE> flags." FORCE)
    set(RCFLAGS_MINSIZEREL        "${MINSIZEREL_RCFLAGS}")            #CACHE STRING "Default <CFLAGS_MINSIZEREL> flags." FORCE)
    set(RCFLAGS_RELWITHDEBINFO    "${RELWITHDEBINFO_RCFLAGS}")        #CACHE STRING "Default <CFLAGS_RELWITHDEBINFO> flags." FORCE)

    # Set toolchain package suffixes (i.e., '{mingw-w64-clang-x86_64}-avr-toolchain')...
    set(TOOLCHAIN_NATIVE_ARM_NONE_EABI          "${MINGW_PACKAGE_PREFIX}-arm-none-eabi-toolchain" CACHE STRING "" FORCE)
    set(TOOLCHAIN_NATIVE_AVR                    "${MINGW_PACKAGE_PREFIX}-avr-toolchain" CACHE STRING "" FORCE)
    set(TOOLCHAIN_NATIVE_RISCV64_UNKOWN_ELF     "${MINGW_PACKAGE_PREFIX}-riscv64-unknown-elf-toolchain" CACHE STRING "The 'unknown elf' toolchain! Careful with this elf, it is not known." FORCE)
    set(TOOLCHAIN_NATIVE                        "${MINGW_PACKAGE_PREFIX}-toolchain" CACHE STRING "" FORCE)

    # DirectX compatibility environment variable
    set(DXSDK_DIR "${MSYS_ROOT}/${MINGW_PREFIX}/${MINGW_CHOST}" CACHE PATH "DirectX compatibility environment variable." FORCE)

    #-- Make Flags: change this for DistCC/SMP systems
    # This var is attempting to pass '-j' to the underlying buildtool - this flag controls the number of processors to build with.
    # A trypical logical default (as expressed here) is 'number of logical cores' + 1.
    # The var is currently attempting to call 'nproc' from the PATH - CMake has its own vars that are probably better suited for this...
    if(NOT DEFINED MAKEFLAGS)
        set(MAKEFLAGS "-j$(($(nproc)+1))" CACHE STRING "Make Flags: change this for DistCC/SMP systems")
    endif()

    set(ACLOCAL_PATH          "${MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
    set(PKG_CONFIG_PATH       "${MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)

endif()

#########################################################################
# SOURCE ACQUISITION
#########################################################################
#
#-- The download utilities that makepkg should use to acquire sources
#
#########################################################################

set(DLAGENT_FILE "${MSYS_ROOT}/usr/bin/curl")
set(DLAGENT_FTP "${MSYS_ROOT}/usr/bin/curl")
set(DLAGENT_HTTP "${MSYS_ROOT}/usr/bin/curl")
set(DLAGENT_HTTPS "${MSYS_ROOT}/usr/bin/curl")
set(DLAGENT_RSYNC "${MSYS_ROOT}/usr/bin/rsync")
set(DLAGENT_SCP "${MSYS_ROOT}/usr/bin/scp")
# Here were set the <agent> flags for each <protocol>
set(DLAGENT_FILE_FLAGS "-gqC - -o %o %u")
set(DLAGENT_FTP_FLAGS "-gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u")
set(DLAGENT_HTTP_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
set(DLAGENT_HTTPS_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
set(DLAGENT_RSYNC_FLAGS "--no-motd -z %u %o")
set(DLAGENT_SCP_FLAGS "-C %u %o")
# Compile agents with their flags
set(DLAGENT_FILE_COMMAND "file::${DLAGENT_FILE} ${DLAGENT_FILE_FLAGS}" CACHE STRING "The standard command for downloads (file)." FORCE)
set(DLAGENT_FTP_COMMAND  "ftp::${DLAGENT_FTP} ${DLAGENT_FTP_FLAGS}"    CACHE STRING "The standard command for downloads (ftp)." FORCE)
set(DLAGENT_HTTP_COMMAND "http::${DLAGENT_HTTP} ${DLAGENT_HTTP_FLAGS}" CACHE STRING "The standard command for downloads (http)." FORCE)
set(DLAGENT_HTTPS_COMMAND "https::${DLAGENT_HTTPS} ${DLAGENT_HTTPS_FLAGS}" CACHE STRING "The standard command for downloads (https)." FORCE)
set(DLAGENT_RSYNC_COMMAND "rsync::${DLAGENT_RSYNC} ${DLAGENT_RSYNC_FLAGS}" CACHE STRING "The standard command for downloads (rsync)." FORCE)
set(DLAGENT_SCP_COMMAND "scp::${DLAGENT_SCP} ${DLAGENT_SCP_FLAGS}" CACHE STRING "The standard command for downloads (scp)." FORCE)
#  Format: 'protocol::agent'
set(DLAGENTS)
list(APPEND DLAGENTS
    "${DLAGENT_FILE}"
    "${DLAGENT_FTP}"
    "${DLAGENT_HTTP}"
    "${DLAGENT_HTTPS}"
    "${DLAGENT_RSYNC}"
    "${DLAGENT_SCP}"
)
set(DLAGENTS "${DLAGENTS}" CACHE STRING "" FORCE)

# In other words...
# set(DLAGENTS
#     "file::/usr/bin/curl -gqC - -o %o %u"
#     "ftp::/usr/bin/curl -gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u"
#     "http::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
#     "https::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
#     "rsync::/usr/bin/rsync --no-motd -z %u %o"
#     "scp::/usr/bin/scp -C %u %o"
# )

# Other common tools:
# /usr/bin/snarf
# /usr/bin/lftpget -c
# /usr/bin/wget (instead of curl? Could be on a switch...)

#-- The package required by makepkg to download VCS sources.
# We can use vcpkg to fetch these for linking our packages with.
# Format: 'protocol::package'
set(VCSCLIENTS)
list(APPEND VCSCLIENTS
    bzr::bzr
    fossil::fossil
    git::git
    hg::mercurial
    svn::subversion
)
set(VCSCLIENTS "${VCSCLIENTS}" CACHE STRING "The package(s) required by makepkg to download VCS sources." FORCE)

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
option(ENABLE_DISTCC "Use the Distributed C/C++/ObjC compiler." OFF)
option(ENABLE_COLOR "Colorize output messages." ON)
option(ENABLE_CCACHE "Use ccache to cache compilation." OFF)
option(ENABLE_CHECK "Run the check() function if present in the build." ON)
option(ENABLE_SIGN "Generate PGP signature file." OFF)

if(NOT DEFINED BUILDENV)
    set(BUILDENV)
    list(APPEND BUILDENV "!distcc" "color" "!ccache" "check" "!sign")
endif()
set(BUILDENV "${BUILDENV}" CACHE STRING "A negated environment option will do the opposite of the comments below." FORCE)

#-- If using DistCC, your MAKEFLAGS will also need modification. In addition,
#-- specify a space-delimited list of hosts running in the DistCC cluster.
#DISTCC_HOSTS=""
#
#-- Specify a directory for package building.
#BUILDDIR=/tmp/makepkg

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
#

# Options handler...

option(OPTION_DOCS "Save doc directories specified by <DOC_DIRS>." ON)
option(OPTION_LIBTOOL "Leave libtool (.la) files in packages." OFF)
option(OPTION_STATIC_LIBS "Leave static library (.a) files in packages." ON)
option(OPTION_EMPTY_DIRS "Leave empty directories in packages." ON)
option(OPTION_ZIPMAN "Compress manual (man and info) pages in <MAN_DIRS> with gzip." ON)
option(OPTION_PURGE "Remove files specified by <PURGE_TARGETS>." ON)
option(OPTION_DEBUG "Add debugging flags as specified in <DEBUG_*> variables." OFF)
option(OPTION_LTO "Add compile flags for building with link time optimization." OFF)

option(OPTION_STRIP "Strip symbols from binaries/libraries." ON)
if(OPTION_STRIP)
    set(OPTION_STRIP_FLAG strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
    #-- Options to be used when stripping binaries. See `man strip' for details.
    if(NOT DEFINED STRIP_BINARIES)
        set(STRIP_BINARIES --strip-all CACHE STRING "Options to be used when stripping binaries. See `man strip' for details." FORCE)
    endif()
else()
    set(OPTION_STRIP_FLAG !strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

# And so forth, or nah...?

if(OPTION_DOCS)
    set(OPTION_DOCS_FLAG docs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_DOCS_FLAG !docs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_LIBTOOL)
    set(OPTION_LIBTOOL_FLAG libtool CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_LIBTOOL_FLAG !libtool CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_STATIC_LIBS)
    set(OPTION_STATIC_LIBS_FLAG staticlibs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_STATIC_LIBS_FLAG !staticlibs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_EMPTY_DIRS)
    set(OPTION_EMPTY_DIRS_FLAG emptydirs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_EMPTY_DIRS_FLAG !emptydirs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_ZIPMAN)
    set(OPTION_ZIPMAN_FLAG zipman CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_ZIPMAN_FLAG !zipman CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_PURGE)
    set(OPTION_PURGE_FLAG purge CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_PURGE_FLAG !purge CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_DEBUG)
    set(OPTION_DEBUG_FLAG debug CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_DEBUG_FLAG !debug CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(OPTION_LTO)
    set(OPTION_LTO_FLAG lto CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
else()
    set(OPTION_LTO_FLAG !lto CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
endif()

if(NOT DEFINED OPTIONS)
    set(OPTIONS "${OPTION_STRIP_FLAG} ${OPTION_DOCS_FLAG} ${OPTION_LIBTOOL_FLAG} ${OPTION_STATIC_LIBS_FLAG} ${OPTION_EMPTY_DIRS_FLAG} ${OPTION_ZIPMAN_FLAG} ${OPTION_PURGE_FLAG} ${OPTION_DEBUG_FLAG} ${OPTION_LTO_FLAG}")
endif()
set(OPTIONS "${OPTIONS}" CACHE STRING "These are the values for the CMake 'option()' settings." FORCE)

# if(NOT DEFINED OPTIONS)
#     set(OPTIONS "" CACHE STRING "")
#     list(APPEND OPTIONS strip docs !libtool staticlibs emptydirs zipman purge !debug !lto)
# endif()

#-- File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512
if(NOT DEFINED INTEGRITY_CHECK OR (INTEGRITY_CHECK STREQUAL ""))
    set(INTEGRITY_CHECK sha256)
endif()
set(INTEGRITY_CHECK "${INTEGRITY_CHECK}" CACHE STRING "File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512" FORCE)

#-- Options to be used when stripping shared libraries. See `man strip' for details.
set(STRIP_SHARED --strip-unneeded CACHE STRING "Options to be used when stripping shared libraries. See `man strip' for details." FORCE)
#-- Options to be used when stripping static libraries. See `man strip' for details.
set(STRIP_STATIC --strip-debug CACHE STRING "Options to be used when stripping static libraries. See `man strip' for details." FORCE)

#-- Manual (man and info) directories to compress (if zipman is specified)
if(NOT DEFINED MAN_DIRS)
    if(DEFINED MINGW_PREFIX)
        set(MAN_DIRS "\"\${MINGW_PREFIX#/}\"{{,/local}{,/share},/opt/*}/{man,info}" CACHE STRING "Manual (man and info) directories to compress (if zipman is specified)" FORCE)
    else()
        set(MAN_DIRS "{{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info}" CACHE STRING "Manual (man and info) directories to compress (if zipman is specified)" FORCE)
    endif()
endif()
#-- Doc directories to remove (if !docs is specified)
if(NOT DEFINED DOC_DIRS)
    if(DEFINED MINGW_PREFIX)
        set(DOC_DIRS "\"\${MINGW_PREFIX#/}\"/{,local/}{,share/}{doc,gtk-doc}" CACHE STRING "Doc directories to remove (if !docs is specified)" FORCE)
    else()
        set(DOC_DIRS "{,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc}" CACHE STRING "Doc directories to remove (if !docs is specified)" FORCE)
    endif()
endif()
#-- Files to be removed from all packages (if purge is specified)
if(NOT DEFINED PURGE_TARGETS)
    if(DEFINED MINGW_PREFIX)
        set(PURGE_TARGETS "{,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod" CACHE STRING "Files to be removed from all packages (if purge is specified)" FORCE)
    else()
        set(PURGE_TARGETS "\"\${MINGW_PREFIX#/}\"/{,share}/info/dir .packlist *.pod" CACHE STRING "Files to be removed from all packages (if purge is specified)" FORCE)
    endif()
endif()


#########################################################################
# PACKAGE OUTPUT
#########################################################################
#
# Default: put built package and cached source in build directory.
#
#########################################################################

#-- Destination: specify a fixed directory where all packages will be placed
if(NOT DEFINED PKGDEST)
    set(PKGDEST "/var/packages-mingw64") # If not yet defined, set a default...
endif() # ...then, write the resulting definition to the cache, with a description attached.
set(PKGDEST "${PKGDEST}" CACHE PATH "Destination: specify a fixed directory where all packages will be placed." FORCE)

#-- Source cache: specify a fixed directory where source files will be cached
if(NOT DEFINED SRCDEST)
    set(SRCDEST "/var/sources")
endif()
set(SRCDEST "${SRCDEST}" CACHE PATH "Source cache: specify a fixed directory where source files will be cached." FORCE)

#-- Source packages: specify a fixed directory where all src packages will be placed
if(NOT DEFINED SRCPKGDEST)
    set(SRCPKGDEST "/var/srcpackages-mingw64")
endif()
set(SRCPKGDEST "${SRCPKGDEST}" CACHE PATH "Source packages: specify a fixed directory where all src packages will be placed" FORCE)

#-- Log files: specify a fixed directory where all log files will be placed
if(NOT DEFINED LOGDEST)
    set(LOGDEST "/var/makepkglogs")
endif()
set(LOGDEST "${LOGDEST}" CACHE PATH "Log files: specify a fixed directory where all log files will be placed" FORCE)

#########################################################################
# EXTENSION DEFAULTS
#########################################################################

set(MSYS_PKGEXT ".pkg.tar.zst" CACHE STRING "File extension to use for packages." FORCE)
set(MSYS_SRCEXT ".src.tar.zst" CACHE STRING "File extension to use for packages containing source code." FORCE)

#########################################################################
# OTHER
#########################################################################

#-- Command used to run pacman as root, instead of trying sudo and su
if(NOT DEFINED PACMAN_AUTH)
    set(PACMAN_AUTH "()")
endif()
set(PACMAN_AUTH "${PACMAN_AUTH}" CACHE STRING "Command used to run pacman as root, instead of trying sudo and su" FORCE)

#-- Packager: name/email of the person or organization building packages
if(DEFINED PACKAGER)
    set(PACKAGER "${PACKAGER}" CACHE STRING "Packager: name/email of the person or organization building packages (optional)." FORCE)
else()
    set(PACKAGER "John Doe <john@doe.com>" CACHE STRING "Packager: name/email of the person or organization building packages (Default)." FORCE)
endif()

if(ENABLE_SIGN)
    #-- Specify a key to use for package signing
    if(DEFINED GPGKEY)
        set(GPGKEY "${GPGKEY}" CACHE STRING "Specify a key to use for package signing (User-specified)." FORCE)
    elseif(DEFINED ENV{GPGKEY})
        set(GPGKEY "$ENV{GPGKEY}" CACHE STRING "Specify a key to use for package signing (Environment-detected)." FORCE)
    else()
        set(GPGKEY "UNDEFINED" CACHE STRING "Specify a key to use for package signing (Undefined)." FORCE)
    endif()
endif()

#########################################################################
# COMPRESSION DEFAULTS
#########################################################################
option(ENABLE_GZIP "Enable the 'gzip' compression utility." ON)
if(ENABLE_GZIP)
    find_program(GZ "${MSYS_ROOT}/usr/bin/gzip")
    if(NOT DEFINED GZ_FLAGS)
        set(GZ_FLAGS)
        string(APPEND GZ_FLAGS "-c ") # --stdout (write on standard output, keep original files unchanged)
        string(APPEND GZ_FLAGS "-f ") # --force (force overwrite of output file and compress links)
        string(APPEND GZ_FLAGS "-n ") # --no-name (do not save or restore the original name and timestamp)
    endif() # (NOT DEFINED GZ_FLAGS)
    set(GZ_FLAGS "${GZ_FLAGS}" CACHE STRING "Flags for the 'gzip' compression utility." FORCE)
    set(GZ_COMMAND "${GZ} ${GZ_FLAGS}" CACHE STRING "The 'gzip' compression utility command." FORCE)
    unset(GZ_FLAGS)
endif() # (ENABLE_GZIP)

#[===[.md
# bzip2

bzip2, a block-sorting file compressor.

#]===]
option(ENABLE_BZ2 "Enable the 'bzip2' compression utility." ON)
if(ENABLE_BZ2)
    find_program(BZ2 "${MSYS_ROOT}/usr/bin/bzip2")
    #[===[.md
    # bzip2_usage

    usage: bzip2 [flags and input files in any order]

    If invoked as `bzip2', default action is to compress.
    If invoked as `bunzip2',  default action is to decompress.
    If invoked as `bzcat', default action is to decompress to stdout.

    If no file names are given, bzip2 compresses or decompresses
    from standard input to standard output.  You can combine
    short flags, so `-v -4' means the same as -v4 or -4v, &c.

    ]===]
    if(NOT DEFINED BZ2_FLAGS)
        set(BZ2_FLAGS)
        #[===[.md
        # bzip2_flags

        Flags for the 'bzip2' compression utility.

        -h --help           print this message
        -d --decompress     force decompression
        -z --compress       force compression
        -k --keep           keep (don't delete) input files
        -f --force          overwrite existing output files
        -t --test           test compressed file integrity
        -c --stdout         output to standard out
        -q --quiet          suppress noncritical error messages
        -v --verbose        be verbose (a 2nd -v gives more)
        -L --license        display software version & license
        -V --version        display software version & license
        -s --small          use less memory (at most 2500k)
        -1 .. -9            set block size to 100k .. 900k
        --fast              alias for -1
        --best              alias for -9

        #]===]
        string(APPEND BZ2_FLAGS "-c ")
        string(APPEND BZ2_FLAGS "-f ")
    endif() # (NOT DEFINED BZ2_FLAGS)
    set(BZ2_FLAGS "${BZ2_FLAGS}" CACHE STRING "Flags for the 'bzip2' compression utility." FORCE)
    set(BZ2_COMMAND "${BZ2} ${BZ2_FLAGS}" CACHE STRING "The 'bzip2' compression utility command." FORCE)
    unset(BZ2_FLAGS)
endif() # (ENABLE_BZ2)

option(ENABLE_XZ "Enable the 'bzip2' compression utility." ON)
if(ENABLE_XZ)
    if(NOT DEFINED XZ_FLAGS)
        set(XZ_FLAGS "-c -z -T0 -") # CACHE STRING "Flags for the xz compression utility." FORCE)
    endif()
endif()

if(NOT DEFINED ZST_FLAGS)
    set(ZST_FLAGS "-c -T0 --ultra -20 -") # CACHE STRING "Flags for the zstd compression utility." FORCE)
endif()
if(NOT DEFINED LRZ_FLAGS)
    set(LRZ_FLAGS "-q") # CACHE STRING "Flags for the lrzip compression utility." FORCE)
endif()
if(NOT DEFINED LZO_FLAGS)
    set(LZO_FLAGS "-q") # CACHE STRING "Flags for the lzop compression utility." FORCE)
endif()
if(NOT DEFINED Z_FLAGS)
    set(Z_FLAGS "-c -f") # CACHE STRING "Flags for the compress compression utility." FORCE)
endif()
if(NOT DEFINED LZ4_FLAGS)
    set(LZ4_FLAGS "-q") # CACHE STRING "Flags for the lz4 compression utility." FORCE)
endif()
if(NOT DEFINED LZ_FLAGS)
    set(LZ_FLAGS "-c -f") # CACHE STRING "Flags for the lzip compression utility." FORCE)
endif()

set(COMPRESS_XZ_COMMAND "xz ${XZ_FLAGS}" CACHE STRING "The xz compression utility command." FORCE)
set(COMPRESS_ZST_COMMAND "zstd ${ZST_FLAGS}" CACHE STRING "The zst compression utility command." FORCE)
set(COMPRESS_LRZ_COMMAND "lrzip ${LRZ_FLAGS}" CACHE STRING "The lrzip compression utility command." FORCE)
set(COMPRESS_LZO_COMMAND "lzop ${LZO_FLAGS}" CACHE STRING "The lzop compression utility command." FORCE)
set(COMPRESS_Z_COMMAND "compress ${Z_FLAGS}" CACHE STRING "The compress compression utility command." FORCE)
set(COMPRESS_LZ4_COMMAND "lz4 ${LZ4_FLAGS}" CACHE STRING "The lz4 compression utility command." FORCE)
set(COMPRESS_LZ_COMMAND "lzip ${LZ_FLAGS}" CACHE STRING "The lzip compression utility command." FORCE)

unset(XZ_FLAGS)
unset(ZST_FLAGS)
unset(LRZ_FLAGS)
unset(LZO_FLAGS)
unset(Z_FLAGS)
unset(LZ4_FLAGS)
unset(LZ_FLAGS)

# cmake_policy(POP)

set(ENV_VARS_FILE_PATH "${CMAKE_CURRENT_BINARY_DIR}/.${TARGET_TRIPLET}.env")
# file(WRITE ${ENV_VARS_FILE_PATH} "Generator: Toolchain file.\n")

execute_process(COMMAND "${CMAKE_COMMAND}" -E environment
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    OUTPUT_VARIABLE ENV_VARS_FILE
)

file(APPEND ${ENV_VARS_FILE_PATH} "${ENV_VARS_FILE}")

unset(CC)
unset(CXX)
unset(LD)
unset(RC)
unset(LDFLAGS)
unset(LDFLAGS_DEBUG)
unset(LDFLAGS_MINSIZEREL)
unset(LDFLAGS_RELEASE)
unset(LDFLAGS_RELWITHDEBINFO)
unset(RCFLAGS)
unset(RCFLAGS_DEBUG)
unset(RCFLAGS_MINSIZEREL)
unset(RCFLAGS_RELEASE)
unset(RCFLAGS_RELWITHDEBINFO)
unset(CFLAGS)
unset(CFLAGS_DEBUG)
unset(CFLAGS_MINSIZEREL)
unset(CFLAGS_RELEASE)
unset(CFLAGS_RELWITHDEBINFO)
unset(CXXFLAGS)
unset(CXXFLAGS_DEBUG)
unset(CXXFLAGS_MINSIZEREL)
unset(CXXFLAGS_RELEASE)
unset(CXXFLAGS_RELWITHDEBINFO)
unset(CPPFLAGS)
unset(CPPFLAGS_DEBUG)
unset(CPPFLAGS_MINSIZEREL)
unset(CPPFLAGS_RELEASE)
unset(CPPFLAGS_RELWITHDEBINFO)
unset(DEBUG_CFLAGS)
unset(DEBUG_CPPFLAGS)
unset(DEBUG_CXXFLAGS)
unset(DEBUG_LDFLAGS)
unset(DEBUG_RCFLAGS)
unset(RELEASE_CFLAGS)
unset(RELEASE_CPPFLAGS)
unset(RELEASE_CXXFLAGS)
unset(RELEASE_LDFLAGS)
unset(RELEASE_RCFLAGS)
unset(CARCH)
unset(CHOST)

#[===[.md:
# toolchain_programs

Info: packages.msys2.org/groups/

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
#]===]

#[===[.md:
# flags

CMAKE_<LANG>_FLAGS
CMAKE_<LANG>_FLAGS_<CONFIG>
CMAKE_RC_FLAGS
CMAKE_SHARED_LINKER_FLAGS
CMAKE_STATIC_LINKER_FLAGS
CMAKE_STATIC_LINKER_FLAGS_<CONFIG>
CMAKE_EXE_LINKER_FLAGS
CMAKE_EXE_LINKER_FLAGS_<CONFIG>
#]===]

#[===[.md:

# Todo

#########################################################################
# NOTES
#########################################################################

# Pick up the relevant root-level files for just-in-case purposes...?
string(TOLOWER ${MSYSTEM} MSYSTEM_NAME)
set(MSYSTEM_CONFIG_FILE "${MSYS_ROOT}/${MSYSTEM_NAME}.ini")
set(MSYSTEM_LAUNCH_FILE "${MSYS_ROOT}/${MSYSTEM_NAME}.exe")
set(MSYSTEM_ICON_FILE "${MSYS_ROOT}/${MSYSTEM_NAME}.ico")

These vars (examples) can be detected in Windows system environments...

UCRTVersion := 10.0.22621.0
UniversalCRTSdkDir := C:\Program Files (x86)\Windows Kits\10\
VCIDEInstallDir := C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\Common7\IDE\VC\
VCINSTALLDIR := C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\
VCToolsRedistDir := C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Redist\MSVC\14.36.32532\
VisualStudioVersion := 17.0
VSINSTALLDIR := C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\
WindowsLibPath := C:\Program Files (x86)\Windows Kits\10\UnionMetadata\10.0.22621.0;C:\Program Files (x86)\Windows Kits\10\References\10.0.22621.0
WindowsSdkBinPath := C:\Program Files (x86)\Windows Kits\10\bin\
WindowsSdkDir := C:\Program Files (x86)\Windows Kits\10\
WindowsSDKLibVersion := 10.0.22621.0\
WindowsSDKVersion := 10.0.22621.0\
TMP := C:\Users\natha\AppData\Local\Temp


# The below is the equivalent to /etc/msystem but for cmake...
if(MSYSTEM STREQUAL MINGW32)
    set(MSYSTEM_PREFIX          "/mingw32"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
    set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-${MSYSTEM_CARCH}"          CACHE STRING    "")
elseif(MSYSTEM STREQUAL MINGW64)
    set(MSYSTEM_PREFIX          "/mingw64"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "")
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-${MSYSTEM_CARCH}"          CACHE STRING    "")
elseif(MSYSTEM STREQUAL CLANG32)
    set(MSYSTEM_PREFIX          "/clang32"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
    set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")
elseif(MSYSTEM STREQUAL CLANG64)
    set(MSYSTEM_PREFIX          "/clang64"                            CACHE PATH      "")
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "")
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")
elseif(MSYSTEM STREQUAL CLANGARM64)
    set(MSYSTEM_PREFIX          "/clangarm64"                         CACHE PATH      "")
    set(MSYSTEM_CARCH           "aarch64"                             CACHE STRING    "")
    set(MSYSTEM_CHOST           "aarch64-w64-mingw32"                 CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")
elseif(MSYSTEM STREQUAL UCRT64)
    set(MSYSTEM_PREFIX          "/ucrt64"                             CACHE PATH      "")
    set(MSYSTEM_CARCH           "x86_64"                              CACHE STRING    "")
    set(MSYSTEM_CHOST           "x86_64-w64-mingw32"                  CACHE STRING    "")
    set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
    set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
    set(MINGW_PACKAGE_PREFIX    "mingw-w64-ucrt-${MSYSTEM_CARCH}"     CACHE STRING    "")
else()
    execute_process(
        COMMAND /usr/bin/uname -m
        WORKING_DIRECTORY "."
        OUTPUT_VARIABLE MSYSTEM_CARCH
    )
    set(MSYSTEM_PREFIX          "/usr"                                CACHE PATH      "")
    set(MSYSTEM_CARCH           "${MSYSTEM_CARCH}"                    CACHE STRING    "")
    set(MSYSTEM_CHOST           "${MSYSTEM_CARCH}-pc-msys"            CACHE STRING    "")
    set(MSYSTEM "MSYS")
endif()


# A round of custom vars...
if(MSYSTEM STREQUAL "MSYS")
    set(MSYSTEM_TITLE "MSYS2 MSYS")
    set(MSYSTEM_TOOLCHAIN_VARIANT gcc)
    set(MSYSTEM_C_LIBRARY cygwin)
    set(MSYSTEM_CXX_LIBRARY libstdc++)
elseif(MSYSTEM STREQUAL UCRT64)
    set(MSYSTEM_TITLE "MinGW UCRT x64")
    set(MSYSTEM_TOOLCHAIN_VARIANT gcc)
    set(MSYSTEM_C_LIBRARY ucrt)
    set(MSYSTEM_CXX_LIBRARY libstdc++)
elseif(MSYSTEM STREQUAL CLANG64)
    set(MSYSTEM_TITLE "MinGW Clang x64")
    set(MSYSTEM_TOOLCHAIN_VARIANT llvm)
    set(MSYSTEM_C_LIBRARY ucrt)
    set(MSYSTEM_CXX_LIBRARY libc++)
elseif(MSYSTEM STREQUAL CLANGARM64)
    set(MSYSTEM_TITLE "MinGW Clang ARM64")
    set(MSYSTEM_TOOLCHAIN_VARIANT llvm)
    set(MSYSTEM_C_LIBRARY ucrt)
    set(MSYSTEM_CXX_LIBRARY libc++)
elseif(MSYSTEM STREQUAL CLANG32)
    set(MSYSTEM_TITLE "MinGW Clang x32")
    set(MSYSTEM_TOOLCHAIN_VARIANT llvm)
    set(MSYSTEM_C_LIBRARY ucrt)
    set(MSYSTEM_CXX_LIBRARY libc++)
elseif(MSYSTEM STREQUAL MINGW64)
    set(MSYSTEM_TITLE "MinGW x64")
    set(MSYSTEM_TOOLCHAIN_VARIANT gcc)
    set(MSYSTEM_C_LIBRARY msvcrt)
    set(MSYSTEM_CXX_LIBRARY libstdc++)
elseif(MSYSTEM STREQUAL MINGW32)
    set(MSYSTEM_TITLE "MinGW x32")
    set(MSYSTEM_TOOLCHAIN_VARIANT gcc)
    set(MSYSTEM_C_LIBRARY msvcrt)
    set(MSYSTEM_CXX_LIBRARY libstdc++)
endif()

#]===]
