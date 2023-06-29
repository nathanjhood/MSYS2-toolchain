if(NOT _MSYS_GENERIC_TOOLCHAIN)
    set(_MSYS_GENERIC_TOOLCHAIN 1)

    set(ENABLE_GENERIC ON CACHE BOOL "Enable sub-system: Generic <GENERIC>." FORCE)

    message(STATUS "Generic toolchain loading...")

    #[===[.md

    PATH="${MSYS2_PATH}:/opt/bin${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig"

    CONFIG_SITE="/etc/config.site"
    SYSCONFDIR="${SYSCONFDIR:=/etc}"

    ORIGINAL_TMP="${ORIGINAL_TMP:-${TMP}}"
    ORIGINAL_TEMP="${ORIGINAL_TEMP:-${TEMP}}"

    TMP="/tmp"
    TEMP="/tmp"

    In 'makepkg.conf' we find the standard MSYS defaults;

    CARCH="x86_64"
    CHOST="x86_64-pc-msys"

    ##-- Compiler and Linker Flags
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

    #]===]

    #[===[.md

    CPPFLAGS - is the variable name for flags to the C preprocessor.
    CXXFLAGS - is the standard variable name for flags to the C++ compiler.
    CFLAGS is - the standard name for a variable with compilation flags.
    LDFLAGS - should be used for search flags/paths (-L) - i.e. -L/usr/lib (/usr/lib are library binaries).
    LDLIBS - for linking libraries.

    #]===]

    # <LD>
    find_program(LD ld DOC "The full path to the compiler for <LD>.")
    mark_as_advanced(LD)
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

    # <CXX>
    find_program(CXX "c++" DOC "The full path to the compiler for <CXX>.")
    mark_as_advanced(CXX)
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


    # <CC>
    find_program(CC "cc" DOC "The full path to the compiler for <CC>.")
    mark_as_advanced(CC)
    if(NOT DEFINED C_FLAGS)
        set(C_FLAGS "")
        string(APPEND C_FLAGS "-march=nocona ")
        string(APPEND C_FLAGS "-mtune=generic ")

        set(C_FLAGS_DEBUG "") # "-g" CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
        set(C_FLAGS_RELEASE "") # "-O3 -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
        set(C_FLAGS_MINSIZEREL "") # "-Os -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
        set(C_FLAGS_RELWITHDEBINFO "") # "-O2 -g -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")

    endif()
    set(C_FLAGS "${C_FLAGS}" CACHE STRING "Flags for the 'C' language utility." FORCE)
    set(C_FLAGS_DEBUG "${C_FLAGS_DEBUG}" CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
    set(C_FLAGS_RELEASE "${C_FLAGS_RELEASE}" CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
    set(C_FLAGS_MINSIZEREL "${C_FLAGS_MINSIZEREL}" CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
    set(C_FLAGS_RELWITHDEBINFO "${C_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    set(C_COMMAND "${CC} ${C_FLAGS}" CACHE STRING "The 'C' language utility command." FORCE)

    # <CPP>
    find_program(CPP cc c++ DOC "The full path to the pre-processor for <CC/CXX>.")
    mark_as_advanced(CPP)
    set(CPP "${CPP} -E")
    if(NOT DEFINED CPP_FLAGS)
        set(CPP_FLAGS "")
        string(APPEND CPP_FLAGS "-D__USE_MINGW_ANSI_STDIO=1 ")
    endif()
    set(CPP_FLAGS "${CPP_FLAGS}") # CACHE STRING "Flags for the 'C/C++' language pre-processor utility, for all build types." FORCE)
    set(CPP_COMMAND "${CC} ${CPP_FLAGS}") # CACHE STRING "The 'C' language pre-processor utility command." FORCE)

    # <RC>
    find_program(RC rc DOC "The full path to the compiler for <RC>.")
    mark_as_advanced(RC)
    if(NOT DEFINED RC_FLAGS)
        set(RC_FLAGS "")
        if(VERBOSE)
            string(APPEND RC_FLAGS "--verbose")
        endif()
        set(RC_FLAGS_DEBUG "") # CACHE STRING "Flags for the 'C' language resource compiler utility, for <Debug> builds.")
        set(RC_FLAGS_RELEASE "") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
        set(RC_FLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
        set(RC_FLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    endif()
    set(RC_FLAGS "${RC_FLAGS}") # CACHE STRING "Flags for the 'C' language utility." FORCE)
    set(RC_FLAGS_DEBUG "${RC_FLAGS_DEBUG}") # CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
    set(RC_FLAGS_RELEASE "${RC_FLAGS_RELEASE}") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
    set(RC_FLAGS_MINSIZEREL "${RC_FLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
    set(RC_FLAGS_RELWITHDEBINFO "${RC_FLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    set(RC_COMMAND "${RC} ${RC_FLAGS}") # CACHE STRING "The 'C' language utility command." FORCE)

    # <AR>
    find_program(AR "ar" NO_CACHE) # DOC "The full path to the archiving utility.")
    if(NOT DEFINED AR_FLAGS)
        set(AR_FLAGS "-rv")
    endif() # (NOT DEFINED AR_FLAGS)
    set(AR_FLAGS "${AR_FLAGS}") # CACHE STRING "Flags for the archiving utility." FORCE)
    set(AR_COMMAND "${AR} ${AR_FLAGS}")


    # CMake vars...
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
        set(CMAKE_${lang}_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "") # this breaks the Kitware default flags etc...

    endforeach() # (lang C CXX)

    set(CMAKE_C_COMPILER_ID "")

    set(CMAKE_C_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
    set(CMAKE_CXX_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
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

endif() # (MSYS_GENERIC_TOOLCHAIN)
