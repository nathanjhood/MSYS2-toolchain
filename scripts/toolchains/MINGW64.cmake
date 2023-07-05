if(NOT _MSYS_MINGW64_TOOLCHAIN)
    set(_MSYS_MINGW64_TOOLCHAIN 1)
    message(STATUS "MinGW x64 toolchain loading...")

    # set(CMAKE_MODULE_PATH)
    # list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/../cmake/Modules")

    # # set(ENABLE_MINGW64 ON CACHE BOOL "Enable sub-system: MinGW x64 <MINGW64>." FORCE)

    # Detect <Z_MSYS_ROOT_DIR>/mingw64.ini to figure MINGW64_ROOT_DIR
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
            message(WARNING "Could not find 'mingw64.ini'... Check your installation!")
            break()
        endif()
    endwhile()
    unset(Z_MINGW64_ROOT_DIR_CANDIDATE)

    if(ENABLE_MINGW64 AND (MSYSTEM STREQUAL "MINGW64"))

    set(CARCH                       "x86_64")
    set(CHOST                       "x86_64-w64-mingw32")
    set(MINGW_CHOST                 "x86_64-w64-mingw32")
    set(MINGW_PREFIX                "/mingw64")
    set(MINGW_PACKAGE_PREFIX        "mingw-w64-x86_64")
    set(MINGW_MOUNT_POINT           "${MINGW_PREFIX}")

    set(MSYSTEM_TITLE               "MinGW x64")                         #CACHE STRING    "MinGW x64: Name of the build system." FORCE)
    set(MSYSTEM_TOOLCHAIN_VARIANT   gcc)                                 #CACHE STRING    "MinGW x64: Identification string of the compiler toolchain variant." FORCE)
    set(MSYSTEM_CRT_LIBRARY         msvcrt)                              #CACHE STRING    "MinGW x64: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(MSYSTEM_CXX_STD_LIBRARY     libstdc++)                           #CACHE STRING    "MinGW x64: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    set(MSYSTEM_PREFIX              "/mingw64")                          #CACHE STRING    "MinGW x64: Sub-system prefix." FORCE)
    set(MSYSTEM_ARCH                "x86_64")                            #CACHE STRING    "MinGW x64: Sub-system architecture." FORCE)
    set(MSYSTEM_PLAT                "x86_64-w64-mingw32")                #CACHE STRING    "MinGW x64: Sub-system name string." FORCE)
    set(MSYSTEM_PACKAGE_PREFIX      "mingw-w64-x86_64")                  #CACHE STRING    "MinGW x64: Sub-system package prefix." FORCE)
    set(MSYSTEM_ROOT                "${Z_MINGW64_ROOT_DIR}")             #CACHE PATH      "MinGW x64: Root of the build system." FORCE)

    endif()

    #set(__USE_MINGW_ANSI_STDIO  "1")                                   # CACHE STRING   "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    #set(_FORTIFY_SOURCE         "2")                                   # CACHE STRING   "Fortify source definition." FORCE)


    # ###########################################################################
    # # CMake vars...
    # ###########################################################################

    ## set(MSYS_TARGET_TRIPLET "x64-mingw-dynamic") ############## One more time!

    set(Z_MSYS_TARGET_TRIPLET_PLAT mingw-dynamic)
    set(Z_MSYS_TARGET_TRIPLET_ARCH x64)

    set(MSYS_TARGET_ARCHITECTURE x64)
    set(MSYS_CRT_LINKAGE dynamic)
    set(MSYS_LIBRARY_LINKAGE dynamic)
    set(MSYS_ENV_PASSTHROUGH PATH)

    set(MSYS_CMAKE_SYSTEM_NAME MinGW)
    set(MSYS_POLICY_DLLS_WITHOUT_LIBS enabled)

    set(MSYS_TARGET_TRIPLET "${Z_MSYS_TARGET_TRIPLET_ARCH}-${Z_MSYS_TARGET_TRIPLET_PLAT}" CACHE STRING "Msys target triplet (ex. x86-windows)" FORCE)


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

    # Targets for vars

    set(CMAKE_SYSTEM "MINGW64" CACHE STRING "Composite name of operating system CMake is compiling for." FORCE)
    # Need to override MinGW from MSYS_CMAKE_SYSTEM_NAME
    set(CMAKE_SYSTEM_NAME "MINGW64" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)

    #set(CMAKE_SYSTEM_PROCESSOR "x86_64" CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE) # include(Platform/${CMAKE_EFFECTIVE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-CXX-${CMAKE_SYSTEM_PROCESSOR} OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)                             #CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE)


    foreach(lang C CXX ASM Fortran OBJC OBJCXX)
        ##-- CMakeCXXInformation: include(Compiler/<CMAKE_CXX_COMPILER_ID>-<LANG>)
        ##-- set(CMAKE_${lang}_COMPILER_ID "GNU" CACHE STRING "" FORCE) - actually, let's fallback to Kitware's GNU
        ##-- 'TARGET' tells the compiler in question what it's '--target:' is.
        set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    endforeach()
    set(CMAKE_RC_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    find_program(CMAKE_C_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
    mark_as_advanced(CMAKE_C_COMPILER)

    find_program(CMAKE_CXX_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
    mark_as_advanced(CMAKE_CXX_COMPILER)

    find_program(CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres.exe")
    mark_as_advanced(CMAKE_RC_COMPILER)

    if(NOT CMAKE_RC_COMPILER)
        find_program (CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres" NO_CACHE)
        if(NOT CMAKE_RC_COMPILER)
            find_program(CMAKE_RC_COMPILER "windres" NO_CACHE)
        endif()
    endif()


    get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

    # The following flags come from 'PORT' files (i.e., build config files for packages)
    if(NOT _CMAKE_IN_TRY_COMPILE)

        set(LDFLAGS "-pipe")
        set(ENV{LDFLAGS} "${LDFLAGS}")

        # Initial configuration flags.
        foreach(lang C CXX ASM Fortran OBJC OBJCXX)
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=nocona")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -msahf")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
            if(${lang} STREQUAL C)
                string(APPEND CMAKE_${lang}_FLAGS_INIT " -Wp,-D_FORTIFY_SOURCE=2")
                string(APPEND CMAKE_${lang}_FLAGS_INIT " -fstack-protector-strong")
            endif()
        endforeach()

        string(APPEND CMAKE_C_FLAGS_INIT                    " ${MSYS_C_FLAGS} ")
        string(APPEND CMAKE_C_FLAGS_DEBUG_INIT              " ${MSYS_C_FLAGS_DEBUG} ")
        string(APPEND CMAKE_C_FLAGS_RELEASE_INIT            " ${MSYS_C_FLAGS_RELEASE} ")
        string(APPEND CMAKE_C_FLAGS_MINSIZEREL_INIT         " ${MSYS_C_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_C_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_C_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_CXX_FLAGS_INIT                  " ${MSYS_CXX_FLAGS} ")
        string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT            " ${MSYS_CXX_FLAGS_DEBUG} ")
        string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT          " ${MSYS_CXX_FLAGS_RELEASE} ")
        string(APPEND CMAKE_CXX_FLAGS_MINSIZEREL_INIT       " ${MSYS_CXX_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT   " ${MSYS_CXX_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_OBJC_FLAGS_INIT                    " ${MSYS_OBJC_FLAGS} ")
        string(APPEND CMAKE_OBJC_FLAGS_DEBUG_INIT              " ${MSYS_OBJC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_OBJC_FLAGS_RELEASE_INIT            " ${MSYS_OBJC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_OBJC_FLAGS_MINSIZEREL_INIT         " ${MSYS_OBJC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_OBJC_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_OBJC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_OBJCXX_FLAGS_INIT                  " ${MSYS_OBJCXX_FLAGS} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_DEBUG_INIT            " ${MSYS_OBJCXX_FLAGS_DEBUG} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_RELEASE_INIT          " ${MSYS_OBJCXX_FLAGS_RELEASE} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_MINSIZEREL_INIT       " ${MSYS_OBJCXX_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO_INIT   " ${MSYS_OBJCXX_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_RC_FLAGS_INIT                   " ${MSYS_RC_FLAGS} ")
        string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT             " ${MSYS_RC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_RC_FLAGS_RELEASE_INIT           " ${MSYS_RC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_RC_FLAGS_MINSIZEREL_INIT        " ${MSYS_RC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_RC_FLAGS_RELWITHDEBINFO_INIT    " ${MSYS_RC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT           " ${MSYS_LINKER_FLAGS} ")

        if(MSYS_CRT_LINKAGE STREQUAL "static")
            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT    "-static ")
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT       "-static ")
        endif()

        foreach(type SHARED STATIC MODULE EXE)
            # string(APPEND CMAKE_${type}_LINKER_FLAGS_DEBUG_INIT             " -g ")
            string(APPEND CMAKE_${type}_LINKER_FLAGS_RELEASE_INIT           " -O3 ")
            string(APPEND CMAKE_${type}_LINKER_FLAGS_MINSIZEREL_INIT        " -Os ")
            string(APPEND CMAKE_${type}_LINKER_FLAGS_RELWITHDEBINFO_INIT    " -O2 ")
            # string(APPEND CMAKE_${type}_LINKER_FLAGS_RELWITHDEBINFO_INIT    " -g ")
        endforeach()

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

        unset(LDFLAGS)

    endif()

    # # optionally include a file which can do extra-generator specific things, e.g.
    # # CMakeFindEclipseCDT4.cmake asks gcc for the system include dirs for the Eclipse CDT4 generator
    # set(CMAKE_EXTRA_GENERATOR "MINGW64Make" CACHE STRING "" FORCE)

    # # Set toolchain package suffixes (i.e., '{mingw-w64-clang-x86_64}-avr-toolchain')...
    # set(MINGW64_TOOLCHAIN_NATIVE_ARM_NONE_EABI          "mingw-w64-x86_64-arm-none-eabi-toolchain") # CACHE STRING "" FORCE)
    # set(MINGW64_TOOLCHAIN_NATIVE_AVR                    "mingw-w64-x86_64-avr-toolchain") # CACHE STRING "" FORCE)
    # set(MINGW64_TOOLCHAIN_NATIVE_RISCV64_UNKOWN_ELF     "mingw-w64-x86_64-riscv64-unknown-elf-toolchain") # CACHE STRING "The 'unknown elf' toolchain! Careful with this elf, it is not known." FORCE)
    # set(MINGW64_TOOLCHAIN_NATIVE                        "mingw-w64-x86_64-toolchain") # CACHE STRING "" FORCE)

    message(STATUS "MinGW x64 toolchain loaded")

endif()
