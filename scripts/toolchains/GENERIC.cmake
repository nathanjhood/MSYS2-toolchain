if()
    # <LD>
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

    # <CXX>
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

    ###########################################################################
    # <CC>
    ###########################################################################
    # Compiler defaults...
    set(MINGW64_C_PLATFORM_ID "MinGW" CACHE STRING "" FORCE)
    set(MINGW64_C_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "Identification string of the compiler frontend variant." FORCE)
    set(MINGW64_C_COMPILE_FEATURES "c_std_90;c_function_prototypes;c_std_99;c_restrict;c_variadic_macros;c_std_11;c_static_assert;c_std_17;c_std_23" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C90_COMPILE_FEATURES "c_std_90;c_function_prototypes" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C99_COMPILE_FEATURES "c_std_99;c_restrict;c_variadic_macros" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C11_COMPILE_FEATURES "c_std_11;c_static_assert" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C17_COMPILE_FEATURES "c_std_17" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C23_COMPILE_FEATURES "c_std_23" CACHE STRING "List of features known to the <CC> compiler." FORCE)
    set(MINGW64_C_SIZEOF_DATA_PTR "8" CACHE STRING "Size of pointer-to-data types for language <CC>." FORCE)
    set(MINGW64_SIZEOF_VOID_P "${MINGW64_C_SIZEOF_DATA_PTR}" CACHE STRING "Size of a ``void`` pointer." FORCE)
    # Implicit include dirs...
    set(MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES
        "${Z_MINGW64_ROOT_DIR}/include"
        "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include"
        "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
        CACHE PATH "Directories implicitly searched by the compiler for header files for language <CC>." FORCE
    )
    # Implicit link dirs...
    set(MINGW64_C_IMPLICIT_LINK_DIRECTORIES
        "${Z_MINGW64_ROOT_DIR}/lib"
        "${Z_MINGW64_ROOT_DIR}/lib/gcc"
        "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0"
        "${Z_MINGW64_ROOT_DIR}/x86_64-w64-mingw32/lib"
        CACHE PATH "Implicit linker search path detected for language <CC>." FORCE
    )
    # Implicit link libs...
    set(MINGW64_C_IMPLICIT_LINK_LIBRARIES "" CACHE STRING "Implicit link libraries and flags detected for language <CC>.")
    string(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES
        gcc
        mingw32
        mingwex
        moldname
        pthread
        advapi32
        kernel32
        shell32
        user32
    )
    set(MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <CC>." FORCE)
    # add_compile_definitions(__USE_MINGW_ANSI_STDIO=1)
    # add_compile_definitions($<$<COMPILE_LANGUAGE:C>:_FORTIFY_SOURCE=2>)
    # add_compile_options(-march=nocona -msahf -mtune=generic -pipe $<$<COMPILE_LANGUAGE:C>:-Wp,-D_FORTIFY_SOURCE=2> $<$<COMPILE_LANGUAGE:C>:-fstack-protector-strong>)
    # set(MINGW64_C_SRCFILE_EXTENSIONS c m) # CACHE STRING "" FORCE)

    find_program(MINGW64_CC "cc" DOC "The full path to the compiler for <CC>.")
    mark_as_advanced(MINGW64_CC)
    if(NOT DEFINED MINGW64_C_FLAGS)
        set(MINGW64_C_FLAGS "")
        string(APPEND MINGW64_C_FLAGS "-march=nocona ")
        string(APPEND MINGW64_C_FLAGS "-msahf ")
        string(APPEND MINGW64_C_FLAGS "-mtune=generic ")
        # string(APPEND C_FLAGS "-O2 ")
        string(APPEND MINGW64_C_FLAGS "-pipe ")
        string(APPEND MINGW64_C_FLAGS "-Wp,-D_FORTIFY_SOURCE=2 ")
        string(APPEND MINGW64_C_FLAGS "-fstack-protector-strong ")

        set(MINGW64_C_FLAGS_DEBUG "") # "-g" CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
        set(MINGW64_C_FLAGS_RELEASE "") # "-O3 -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
        set(MINGW64_C_FLAGS_MINSIZEREL "") # "-Os -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
        set(MINGW64_C_FLAGS_RELWITHDEBINFO "") # "-O2 -g -DNDEBUG" CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")

    endif()
    set(MINGW64_C_FLAGS "${MINGW64_C_FLAGS}" CACHE STRING "Flags for the 'C' language utility." FORCE)
    set(MINGW64_C_FLAGS_DEBUG "${MINGW64_C_FLAGS_DEBUG}" CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
    set(MINGW64_C_FLAGS_RELEASE "${MINGW64_C_FLAGS_RELEASE}" CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
    set(MINGW64_C_FLAGS_MINSIZEREL "${MINGW64_C_FLAGS_MINSIZEREL}" CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
    set(MINGW64_C_FLAGS_RELWITHDEBINFO "${MINGW64_C_FLAGS_RELWITHDEBINFO}" CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
    set(MINGW64_C_COMMAND "${MINGW64_CC} ${MINGW64_C_FLAGS}" CACHE STRING "The 'C' language utility command." FORCE)

    set(MINGW64_C_SOURCE_FILE_EXTENSIONS "" CACHE STRING "Extensions of source files for the given language <CC>." FORCE)
    list(APPEND MINGW64_C_SOURCE_FILE_EXTENSIONS "c")
    list(APPEND MINGW64_C_SOURCE_FILE_EXTENSIONS "m")
    set(MINGW64_C_IGNORE_EXTENSIONS "" CACHE STRING "File extensions that should be ignored by the build." FORCE)
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "h")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "H")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "o")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "O")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "obj")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "OBJ")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "def")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "DEF")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "rc")
    list(APPEND MINGW64_C_IGNORE_EXTENSIONS "RC")

    # <CPP>
    find_program(CPP "cc" "c++" NO_CACHE)
    set(CPP "${CPP} -E") # CACHE STRING "The full path to the pre-processor for <CC/CXX>." FORCE)
    if(NOT DEFINED CPP_FLAGS)
        set(CPP_FLAGS "")
        string(APPEND CPP_FLAGS "-D__USE_MINGW_ANSI_STDIO=1 ")
    endif()
    set(CPP_FLAGS "${CPP_FLAGS}") # CACHE STRING "Flags for the 'C/C++' language pre-processor utility, for all build types." FORCE)
    set(CPP_COMMAND "${CC} ${CPP_FLAGS}") # CACHE STRING "The 'C' language pre-processor utility command." FORCE)

    # <RC>
    find_program(RC "rc" NO_CACHE) # DOC "The full path to the compiler for <RC>.")
    if(NOT DEFINED RC_FLAGS)
        set(RC_FLAGS "")
        if(MSYS_VERBOSE)
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
endif()
