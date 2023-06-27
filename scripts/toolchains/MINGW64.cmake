if(NOT _MSYS_MINGW64_TOOLCHAIN)
    set(_MSYS_MINGW64_TOOLCHAIN 1)

    message(STATUS "[toolchain] -- [mingw64] -- Toolchain loading...")
    # message(":: [toolchain] -- MinGW x64 toolchain loading...")

    # We still need to set some sort of default Z_MSYS_ROOT_DIR in case this file
    # is being loaded outside of the MSYS buildsystem file... Let's just use the MSYSTEM name.

    # Detect msys2.ico to figure MSYS_ROOT_DIR
    set(Z_MINGW64_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
    while(NOT DEFINED Z_MINGW64_ROOT_DIR)
        if(EXISTS "${Z_MINGW64_ROOT_DIR_CANDIDATE}msys64/mingw64.ini")
            set(Z_MINGW64_ROOT_DIR "${Z_MINGW64_ROOT_DIR_CANDIDATE}msys64/mingw64" CACHE INTERNAL "MinGW64 root directory")
        elseif(IS_DIRECTORY "${Z_MINGW64_ROOT_DIR_CANDIDATE}")
            get_filename_component(Z_MINGW64_ROOT_DIR_TEMP "${Z_MINGW64_ROOT_DIR_CANDIDATE}" DIRECTORY)
            if(Z_MINGW64_ROOT_DIR_TEMP STREQUAL Z_MINGW64_ROOT_DIR_CANDIDATE)
                break() # If unchanged, we have reached the root of the drive without finding vcpkg.
            endif()
            set(Z_MINGW64_ROOT_DIR_CANDIDATE "${Z_MINGW64_ROOT_DIR_TEMP}")
            unset(Z_MINGW64_ROOT_DIR_TEMP)
        else()
            message(WARNING "Could not find '/mingw64.ini'")
            break()
        endif()
    endwhile()
    unset(Z_MINGW64_ROOT_DIR_CANDIDATE)

    set(ENABLE_MINGW64 ON CACHE BOOL "" FORCE)

    ## Globals...
    # MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    # MANPATH='/usr/local/man:/usr/share/man:/usr/man:/share/man'
    # INFOPATH='/usr/local/info:/usr/share/info:/usr/info:/share/info'


    ## MINGW64-specific...

    # CC="gcc"
    # CXX="g++"
    # CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    # CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    # CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    # LDFLAGS="-pipe"

    # CARCH="x86_64"
    # CHOST="x86_64-w64-mingw32"

    # MINGW_CHOST="x86_64-w64-mingw32"
    # MINGW_PREFIX="/mingw64"
    # MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
    # MINGW_MOUNT_POINT="/mingw64"

    # MSYSTEM_PREFIX='/mingw64'
    # MSYSTEM_CARCH='x86_64'
    # MSYSTEM_CHOST='x86_64-w64-mingw32'

    # MINGW_CHOST="${MSYSTEM_CHOST}"
    # MINGW_PREFIX="${MSYSTEM_PREFIX}"
    # MINGW_PACKAGE_PREFIX="mingw-w64-${MSYSTEM_CARCH}"
    # MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    # PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    # PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    # PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    # PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    # ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    # MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    # INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"

    # set(MSYSTEM_TITLE           "MinGW x64"                     CACHE STRING    "Name of the build system." FORCE)
    # set(MSYSTEM_ROOT            "${Z_MSYS_ROOT_DIR}/mingw64"    CACHE PATH      "Root of the build system." FORCE)

    if(ENABLE_MINGW64)

        set(CARCH "x86_64")
        set(CHOST "x86_64-w64-mingw32")
        set(MINGW_CHOST "x86_64-w64-mingw32")
        set(MINGW_PREFIX "/mingw64")
        set(MINGW_PACKAGE_PREFIX "mingw-w64-x86_64")
        set(MINGW_MOUNT_POINT "${MINGW_PREFIX}")

        set(MSYSTEM_TITLE               "MinGW x64"                         CACHE STRING    "MinGW x64: Name of the build system." FORCE)
        set(MSYSTEM_TOOLCHAIN_VARIANT   gcc                                 CACHE STRING    "MinGW x64: Identification string of the compiler toolchain variant." FORCE)
        set(MSYSTEM_CRT_LIBRARY         msvcrt                              CACHE STRING    "MinGW x64: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
        set(MSYSTEM_CXX_STD_LIBRARY     libstdc++                           CACHE STRING    "MinGW x64: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
        set(MSYSTEM_PREFIX              "/mingw64"                          CACHE STRING    "MinGW x64: Sub-system prefix." FORCE)
        set(MSYSTEM_ARCH                "x86_64"                            CACHE STRING    "MinGW x64: Sub-system architecture." FORCE)
        set(MSYSTEM_PLAT                "x86_64-w64-mingw32"                CACHE STRING    "MinGW x64: Sub-system name string." FORCE)
        set(MSYSTEM_PACKAGE_PREFIX      "mingw-w64-x86_64"                  CACHE STRING    "MinGW x64: Sub-system package prefix." FORCE)
        set(MSYSTEM_ROOT                "${Z_MINGW64_ROOT_DIR}"     CACHE PATH      "MinGW x64: Root of the build system." FORCE)

    endif()

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

    find_program(RC "rc" NO_CACHE) # DOC "The full path to the compiler for <RC>.")

    # set(LD                      "${MSYSTEM_ROOT}/bin/ld")              #CACHE FILEPATH "The full path to the linker <LD>." FORCE)
    # set(RC                      "${MSYSTEM_ROOT}/bin/windres")         #CACHE FILEPATH "" FORCE)

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
    set(CPP_COMMAND "${CC} ${CC_FLAGS}") # CACHE STRING "The 'C' language pre-processor utility command." FORCE)

    set(ENABLED_LANGUAGES C CXX)
    foreach(lang ${ENABLED_LANGUAGES})

        set(CMAKE_${lang}_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    endforeach() # (lang C CXX)

    find_program(CMAKE_C_COMPILER   "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc")
    find_program(CMAKE_CXX_COMPILER "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-g++")
    find_program(CMAKE_RC_COMPILER  "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-windres")

    if(NOT CMAKE_RC_COMPILER)

        find_program(CMAKE_RC_COMPILER "windres")

    endif() # (NOT CMAKE_RC_COMPILER)

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

    message(STATUS "[toolchain] -- [mingw64] -- Toolchain loaded.")
    # message(":: [toolchain] -- MinGW x64 toolchain loaded.")

endif()
