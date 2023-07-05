if(NOT _MSYS_CLANG32_TOOLCHAIN)
set(_MSYS_CLANG32_TOOLCHAIN 1)

    message(STATUS "MinGW Clang x32 toolchain loading...")

    # set(CMAKE_MODULE_PATH)
    # list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake/Modules")

    # # set(ENABLE_CLANG32 ON CACHE BOOL "Enable sub-system: MinGW Clang x32 <CLANG32>." FORCE)

    # Detect <Z_MSYS_ROOT_DIR>/clang32.ini to figure CLANG32_ROOT_DIR
    set(Z_CLANG32_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
    while(NOT DEFINED Z_CLANG32_ROOT_DIR)
        if(EXISTS "${Z_CLANG32_ROOT_DIR_CANDIDATE}msys64/clang32.ini")
            set(Z_CLANG32_ROOT_DIR "${Z_CLANG32_ROOT_DIR_CANDIDATE}msys64/mingw32" CACHE INTERNAL "MinGW Clang x32 root directory")
        elseif(IS_DIRECTORY "${Z_CLANG32_ROOT_DIR_CANDIDATE}")
            get_filename_component(Z_CLANG32_ROOT_DIR_TEMP "${Z_CLANG32_ROOT_DIR_CANDIDATE}" DIRECTORY)
            if(Z_CLANG32_ROOT_DIR_TEMP STREQUAL Z_CLANG32_ROOT_DIR_CANDIDATE)
                break() # If unchanged, we have reached the root of the drive without finding <CLANG32>.ini.
            endif()
            set(Z_CLANG32_ROOT_DIR_CANDIDATE "${Z_CLANG32_ROOT_DIR_TEMP}")
            unset(Z_CLANG32_ROOT_DIR_TEMP)
        else()
            message(WARNING "Could not find 'clang32.ini'... Check your installation!")
            break()
        endif()
    endwhile()
    unset(Z_CLANG32_ROOT_DIR_CANDIDATE)

    if(ENABLE_CLANG32 AND (MSYSTEM STREQUAL "CLANG32"))

    set(CARCH                       "i686")
    set(CHOST                       "i686-w64-mingw32")
    set(MINGW_CHOST                 "i686-w64-mingw32")
    set(MINGW_PREFIX                "/clang32")
    set(MINGW_PACKAGE_PREFIX        "mingw-w64-clang-i686")
    set(MINGW_MOUNT_POINT           "${MINGW_PREFIX}")

    set(MSYSTEM_TITLE               "MinGW Clang x32"                   CACHE STRING    "MinGW Clang x32: Name of the build system." FORCE)
    set(MSYSTEM_TOOLCHAIN_VARIANT   llvm                                CACHE STRING    "MinGW x32: Identification string of the compiler toolchain variant." FORCE)
    set(MSYSTEM_CRT_LIBRARY         msvcrt                              CACHE STRING    "MinGW x32: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(MSYSTEM_CXX_STD_LIBRARY     libc++                              CACHE STRING    "MinGW x32: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    set(MSYSTEM_PREFIX              "/clang32"                          CACHE STRING    "MinGW x32: Sub-system prefix." FORCE)
    set(MSYSTEM_ARCH                "i686"                              CACHE STRING    "MinGW x32: Sub-system architecture." FORCE)
    set(MSYSTEM_PLAT                "i686-w64-mingw32"                  CACHE STRING    "MinGW x32: Sub-system name string." FORCE)
    set(MSYSTEM_PACKAGE_PREFIX      "mingw-w64-clang-i686"              CACHE STRING    "MinGW x32: Sub-system package prefix." FORCE)
    set(MSYSTEM_ROOT                "${Z_CLANG32_ROOT_DIR}"             CACHE PATH      "MinGW x32: Root of the build system." FORCE)

    endif()

    #set(__USE_MINGW_ANSI_STDIO  "1")                                   # CACHE STRING   "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    #set(_FORTIFY_SOURCE         "2")                                   # CACHE STRING   "Fortify source definition." FORCE)


    # ###########################################################################
    # # CMake vars...
    # ###########################################################################

    #set(CMAKE_SYSTEM "MINGW64" CACHE STRING "Composite name of operating system CMake is compiling for." FORCE)
    # Need to override MinGW from MSYS_CMAKE_SYSTEM_NAME
    set(CMAKE_SYSTEM_NAME "MSYSTEM" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)

    if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
        set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
    endif()

    if(MSYS_TARGET_ARCHITECTURE STREQUAL "x86")
        set(CMAKE_SYSTEM_PROCESSOR i686 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
    elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "x64")
        set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
    elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm")
        set(CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
    elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm64")
        set(CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
    endif()

    foreach(lang C CXX ASM Fortran OBJC OBJCXX)
        ##-- CMakeCXXInformation: include(Compiler/<CMAKE_CXX_COMPILER_ID>-<LANG>)
        #set(CMAKE_${lang}_COMPILER_ID "CLANG32 13.1.0" CACHE STRING "" FORCE) # - actually, let's fallback to Kitware's GNU
        ##-- 'TARGET' tells the compiler in question what it's '--target:' is.
        set(CMAKE_${lang}_COMPILER_TARGET "i686-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=i686-w64-mingw32'")

    endforeach()
    set(CMAKE_RC_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    find_program(CMAKE_C_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/i686-mingw32-clang.exe")
    mark_as_advanced(CMAKE_C_COMPILER)

    find_program(CMAKE_CXX_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/i686-w64-clang++.exe")
    mark_as_advanced(CMAKE_CXX_COMPILER)

    find_program(CMAKE_RC_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/windres.exe")
    mark_as_advanced(CMAKE_RC_COMPILER)

    find_program(CMAKE_ASM_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/as.exe")
    mark_as_advanced(CMAKE_ASM_COMPILER)

    find_program(CMAKE_OBJC_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/i686-w64-mingw32-clang.exe")
    mark_as_advanced(CMAKE_OBJC_COMPILER)

    find_program(CMAKE_OBJCXX_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/i686-mingw32-clang++.exe")
    mark_as_advanced(CMAKE_OBJCXX_COMPILER)

    find_program(CMAKE_RC_COMPILER "${Z_CLANG32_ROOT_DIR}/bin/llvm-rc.exe")
    mark_as_advanced(CMAKE_RC_COMPILER)

    if(NOT CMAKE_RC_COMPILER)
        find_program (CMAKE_RC_COMPILER "${Z_MINGW32_ROOT_DIR}/bin/windres" NO_CACHE)
        if(NOT CMAKE_RC_COMPILER)
            find_program(CMAKE_RC_COMPILER "windres" NO_CACHE)
        endif()
    endif()


    get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

    # The following flags come from 'PORT' files (i.e., build config files for packages)
    if(NOT _CMAKE_IN_TRY_COMPILE)

        set(LDFLAGS)
        string(APPEND LDFLAGS " -pipe")
        string(APPEND LDFLAGS " -Wl,--no-seh")
        string(APPEND LDFLAGS " -Wl,--large-address-aware")
        set(LDFLAGS "${LDFLAGS}")
        set(ENV{LDFLAGS} "${LDFLAGS}")

        # set(CFLAGS)
        # string(APPEND CFLAGS " -march=pentium4")
        # string(APPEND CFLAGS " -mtune=generic")
        # string(APPEND CFLAGS " -pipe")
        # string(APPEND CFLAGS " -Wp,-D_FORTIFY_SOURCE=2")
        # string(APPEND CFLAGS " -fstack-protector-strong")
        # set(CFLAGS "${CFLAGS}")
        # set(ENV{CFLAGS} "${CFLAGS}")

        # set(CXXFLAGS)
        # string(APPEND CXXFLAGS " -march=pentium4")
        # string(APPEND CXXFLAGS " -mtune=generic")
        # string(APPEND CXXFLAGS " -pipe")
        # set(CXXFLAGS "${CXXFLAGS}")
        # set(ENV{CXXFLAGS} "${CXXFLAGS}")

        # Initial configuration flags.
        foreach(lang C CXX ASM Fortran OBJC OBJCXX)
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=pentium4")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
            if(${lang} STREQUAL C)
                string(APPEND CMAKE_${lang}_FLAGS_INIT " -Wp,-D_FORTIFY_SOURCE=2")
                string(APPEND CMAKE_${lang}_FLAGS_INIT " -fstack-protector-strong")
            endif()
        endforeach()

        string(APPEND CMAKE_C_FLAGS_INIT                        " ${MSYS_C_FLAGS} ")
        string(APPEND CMAKE_C_FLAGS_DEBUG_INIT                  " ${MSYS_C_FLAGS_DEBUG} ")
        string(APPEND CMAKE_C_FLAGS_RELEASE_INIT                " ${MSYS_C_FLAGS_RELEASE} ")
        string(APPEND CMAKE_C_FLAGS_MINSIZEREL_INIT             " ${MSYS_C_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_C_FLAGS_RELWITHDEBINFO_INIT         " ${MSYS_C_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_CXX_FLAGS_INIT                      " ${MSYS_CXX_FLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT                " ${MSYS_CXX_FLAGS_DEBUG} ")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT              " ${MSYS_CXX_FLAGS_RELEASE} ")
        string(APPEND CMAKE_CXX_FLAGS_MINSIZEREL_INIT           " ${MSYS_CXX_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT       " ${MSYS_CXX_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_ASM_FLAGS_INIT                      " ${MSYS_ASM_FLAGS} ")
        string(APPEND CMAKE_ASM_FLAGS_DEBUG_INIT                " ${MSYS_ASM_FLAGS_DEBUG} ")
        string(APPEND CMAKE_ASM_FLAGS_RELEASE_INIT              " ${MSYS_ASM_FLAGS_RELEASE} ")
        string(APPEND CMAKE_ASM_FLAGS_MINSIZEREL_INIT           " ${MSYS_ASM_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT       " ${MSYS_ASM_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_Fortran_FLAGS_INIT                  " ${MSYS_Fortran_FLAGS} ")
        string(APPEND CMAKE_Fortran_FLAGS_DEBUG_INIT            " ${MSYS_Fortran_FLAGS_DEBUG} ")
        string(APPEND CMAKE_Fortran_FLAGS_RELEASE_INIT          " ${MSYS_Fortran_FLAGS_RELEASE} ")
        string(APPEND CMAKE_Fortran_FLAGS_MINSIZEREL_INIT       " ${MSYS_Fortran_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT   " ${MSYS_Fortran_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_OBJC_FLAGS_INIT                     " ${MSYS_OBJC_FLAGS} ")
        string(APPEND CMAKE_OBJC_FLAGS_DEBUG_INIT               " ${MSYS_OBJC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_OBJC_FLAGS_RELEASE_INIT             " ${MSYS_OBJC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_OBJC_FLAGS_MINSIZEREL_INIT          " ${MSYS_OBJC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_OBJC_FLAGS_RELWITHDEBINFO_INIT      " ${MSYS_OBJC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_OBJCXX_FLAGS_INIT                   " ${MSYS_OBJCXX_FLAGS} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_DEBUG_INIT             " ${MSYS_OBJCXX_FLAGS_DEBUG} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_RELEASE_INIT           " ${MSYS_OBJCXX_FLAGS_RELEASE} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_MINSIZEREL_INIT        " ${MSYS_OBJCXX_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO_INIT    " ${MSYS_OBJCXX_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_RC_FLAGS_INIT                       " ${MSYS_RC_FLAGS} ")
        string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT                 " ${MSYS_RC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_RC_FLAGS_RELEASE_INIT               " ${MSYS_RC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_RC_FLAGS_MINSIZEREL_INIT            " ${MSYS_RC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_RC_FLAGS_RELWITHDEBINFO_INIT        " ${MSYS_RC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT               " ${MSYS_LINKER_FLAGS} ")

        if(OPTION_STRIP_BINARIES)
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT               " --strip-all")
        endif()

        if(OPTION_STRIP_SHARED)
            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT            " --strip-unneeded")
        endif()

        if(OPTION_STRIP_STATIC)
            string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT            " --strip-debug")
        endif()

        if(MSYS_CRT_LINKAGE STREQUAL "static")
            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT        " -static")
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT           " -static")
        endif()

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_STATIC_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT                 " ${MSYS_LINKER_FLAGS_DEBUG} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT               " ${MSYS_LINKER_FLAGS_RELEASE} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT            " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT        " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

        # unset(LDFLAGS)
        # unset(CFLAGS)
        # unset(CXXFLAGS)
        # unset(CPPFLAGS)

    endif()

    message(STATUS "MinGW Clang x32 toolchain loaded")

endif()
