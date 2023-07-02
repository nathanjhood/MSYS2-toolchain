if(NOT _MSYS_MINGW64_TOOLCHAIN)
    set(_MSYS_MINGW64_TOOLCHAIN 1)
    message(STATUS "MinGW x64 toolchain loading...")

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

    if(MSYSTEM STREQUAL "MINGW64")

        set(CMAKE_SYSTEM                MINGW64                             CACHE STRING "Composite name of operating system CMake is compiling for." FORCE)
        set(CMAKE_SYSTEM_NAME           MINGW64                             CACHE STRING "The name of the operating system for which CMake is to build." FORCE)
        set(CMAKE_SYSTEM_PROCESSOR      x86_64                              CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE)

        # set(CMAKE_EFFECTIVE_SYSTEM_NAME "MSYS" CACHE STRING "" FORCE)

        set(CARCH                       "x86_64")
        set(CHOST                       "x86_64-w64-mingw32")
        set(MINGW_CHOST                 "x86_64-w64-mingw32")
        set(MINGW_PREFIX                "/mingw64")
        set(MINGW_PACKAGE_PREFIX        "mingw-w64-x86_64")
        set(MINGW_MOUNT_POINT           "${MINGW_PREFIX}")

        set(MSYSTEM_TITLE               "MinGW x64"                         CACHE STRING    "MinGW x64: Name of the build system." FORCE)
        set(MSYSTEM_TOOLCHAIN_VARIANT   gcc                                 CACHE STRING    "MinGW x64: Identification string of the compiler toolchain variant." FORCE)
        set(MSYSTEM_CRT_LIBRARY         msvcrt                              CACHE STRING    "MinGW x64: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
        set(MSYSTEM_CXX_STD_LIBRARY     libstdc++                           CACHE STRING    "MinGW x64: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
        set(MSYSTEM_PREFIX              "/mingw64"                          CACHE STRING    "MinGW x64: Sub-system prefix." FORCE)
        set(MSYSTEM_ARCH                "x86_64"                            CACHE STRING    "MinGW x64: Sub-system architecture." FORCE)
        set(MSYSTEM_PLAT                "x86_64-w64-mingw32"                CACHE STRING    "MinGW x64: Sub-system name string." FORCE)
        set(MSYSTEM_PACKAGE_PREFIX      "mingw-w64-x86_64"                  CACHE STRING    "MinGW x64: Sub-system package prefix." FORCE)
        set(MSYSTEM_ROOT                "${Z_MINGW64_ROOT_DIR}"             CACHE PATH      "MinGW x64: Root of the build system." FORCE)

        if(CMAKE_HOST_SYSTEM_NAME STREQUAL "${CMAKE_SYSTEM_NAME}")
            set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "Intended to indicate whether CMake is cross compiling, but note limitations discussed below.")
        endif()

        # include("${CMAKE_CURRENT_LIST_DIR}/profiles/MINGW64/MINGW64-Tools.cmake")

    endif()

    set(MINGW64_ROOT                    "${Z_MINGW64_ROOT_DIR}")            # CACHE PATH      "<MINGW64>: Root of the build system." FORCE)

    set(MINGW64_TITLE                   "MinGW x64")                        # CACHE STRING    "<MINGW64>: Name of the build system." FORCE)
    set(MINGW64_PACKAGE_PREFIX          "mingw-w64-x86_64")                 # CACHE STRING    "<MINGW64>: Sub-system package prefix." FORCE)
    set(MINGW64_TOOLCHAIN_VARIANT       gcc)                                # CACHE STRING    "<MINGW64>: Identification string of the compiler toolchain variant." FORCE)
    set(MINGW64_CRT_LIBRARY             msvcrt)                             # CACHE STRING    "<MINGW64>: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
    set(MINGW64_CRT_LINKAGE             static)                             # CACHE STRING    "<MINGW64>: C Runtime Library linkage type." FORCE)
    set(MINGW64_CXX_STD_LIBRARY         libstdc++)                          # CACHE STRING    "<MINGW64>: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
    set(MINGW64_ARCH                    "x86_64")                           # CACHE STRING    "<MINGW64>: Sub-system architecture." FORCE)
    set(MINGW64_PLAT                    "x86_64-w64-mingw32")               # CACHE STRING    "<MINGW64>: Sub-system name string." FORCE)

    set(MINGW64_PREFIX                  "${MINGW64_ROOT}")                  # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_BUILD_PREFIX            "${MINGW64_PREFIX}/usr")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_INSTALL_PREFIX          "${MINGW64_PREFIX}/usr/local")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

    set(MINGW64_INCLUDEDIR              "${MINGW64_PREFIX}/include")        # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_SRCDIR                  "${MINGW64_PREFIX}/src")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_SYSCONFDIRDIR           "${MINGW64_PREFIX}/etc")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

    set(MINGW64_DATAROOTDIR             "${MINGW64_PREFIX}/share")          # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_DATADIR                 "${MINGW64_DATAROOTDIR}")           # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_DOCDIR                  "${MINGW64_DATAROOTDIR}/doc")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_MANDIR                  "${MINGW64_DATAROOTDIR}/man")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_INFODIR                 "${MINGW64_DATAROOTDIR}/info")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_LOCALEDIR               "${MINGW64_DATAROOTDIR}/locale")    # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

    set(MINGW64_CMAKEDIR                "${MINGW64_DATAROOTDIR}/cmake")     # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

    set(MINGW64_EXEC_PREFIX             "${MINGW64_PREFIX}")                # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_BINDIR                  "${MINGW64_EXEC_PREFIX}/bin")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_SBINDIR                 "${MINGW64_EXEC_PREFIX}/sbin")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_LIBDIR                  "${MINGW64_EXEC_PREFIX}/lib")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
    set(MINGW64_LIBEXECDIR              "${MINGW64_EXEC_PREFIX}/libexec")   # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

    # DirectX compatibility environment variable
    set(MINGW64_DXSDK_DIR               "${MINGW64_ROOT}/x86_64-w64-mingw32")   # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

    # set(ACLOCAL_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${Z_MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
    set(MINGW64_ACLOCAL_PATH)
    list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/share/aclocal")
    list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/usr/share")
    set(MINGW64_ACLOCAL_PATH "${MINGW64_ACLOCAL_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

    # set(PKG_CONFIG_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)
    set(MINGW64_PKG_CONFIG_PATH)
    list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/lib/pkgconfig")
    list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/share/pkgconfig")
    set(MINGW64_PKG_CONFIG_PATH "${MINGW64_PKG_CONFIG_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

    # Set toolchain package suffixes (i.e., '{mingw-w64-clang-x86_64}-avr-toolchain')...
    set(MINGW64_TOOLCHAIN_NATIVE_ARM_NONE_EABI          "mingw-w64-x86_64-arm-none-eabi-toolchain") # CACHE STRING "" FORCE)
    set(MINGW64_TOOLCHAIN_NATIVE_AVR                    "mingw-w64-x86_64-avr-toolchain") # CACHE STRING "" FORCE)
    set(MINGW64_TOOLCHAIN_NATIVE_RISCV64_UNKOWN_ELF     "mingw-w64-x86_64-riscv64-unknown-elf-toolchain") # CACHE STRING "The 'unknown elf' toolchain! Careful with this elf, it is not known." FORCE)
    set(MINGW64_TOOLCHAIN_NATIVE                        "mingw-w64-x86_64-toolchain") # CACHE STRING "" FORCE)

    find_program(MINGW64_AR         "${MINGW64_BINDIR}/ar.exe" NO_CACHE)
    find_program(MINGW64_AS         "${MINGW64_BINDIR}/as.exe" NO_CACHE)
    find_program(MINGW64_LD         "${MINGW64_BINDIR}/ld.exe" NO_CACHE)
    #find_program(MINGW64_MT         "${MINGW64_BINDIR}/mt.exe" NO_CACHE)
    find_program(MINGW64_NM         "${MINGW64_BINDIR}/nm.exe" NO_CACHE)

    mark_as_advanced(MINGW64_AR)
    mark_as_advanced(MINGW64_AS)
    mark_as_advanced(MINGW64_LD)
    #mark_as_advanced(MINGW64_MT)
    mark_as_advanced(MINGW64_NM)

    set(MINGW64_AR         "${MINGW64_AR}") # CACHE FILEPATH "<MINGW64>: The full path to the <AR> utility." FORCE)
    set(MINGW64_AS         "${MINGW64_AS}") # CACHE FILEPATH "<MINGW64>: The full path to the <AS> utility." FORCE)
    set(MINGW64_LD         "${MINGW64_LD}") # CACHE FILEPATH "<MINGW64>: The full path to the <LD> utility." FORCE)
    #set(MINGW64_MT         "${MINGW64_MT}") # CACHE FILEPATH "<MINGW64>: The full path to the <MT> utility." FORCE)
    set(MINGW64_NM         "${MINGW64_NM}") # CACHE FILEPATH "<MINGW64>: The full path to the <NM> utility." FORCE)

    find_program(MINGW64_ADDR2LINE  "${MINGW64_BINDIR}/addr2line.exe" NO_CACHE)
    find_program(MINGW64_DLLTOOL    "${MINGW64_BINDIR}/dlltool.exe" NO_CACHE)
    find_program(MINGW64_LINKER     "${MINGW64_BINDIR}/ld.exe" NO_CACHE)
    find_program(MINGW64_MAKE       "${MINGW64_BINDIR}/mingw32-make.exe" NO_CACHE)
    find_program(MINGW64_OBJCOPY    "${MINGW64_BINDIR}/objcopy.exe" NO_CACHE)
    find_program(MINGW64_OBJDUMP    "${MINGW64_BINDIR}/objdump.exe" NO_CACHE)
    find_program(MINGW64_RANLIB     "${MINGW64_BINDIR}/ranlib.exe" NO_CACHE)
    find_program(MINGW64_READELF    "${MINGW64_BINDIR}/readelf.exe" NO_CACHE)
    find_program(MINGW64_STRIP      "${MINGW64_BINDIR}/strip.exe" NO_CACHE)

    mark_as_advanced(MINGW64_ADDR2LINE)
    mark_as_advanced(MINGW64_DLLTOOL)
    mark_as_advanced(MINGW64_LINKER)
    mark_as_advanced(MINGW64_MAKE)
    mark_as_advanced(MINGW64_OBJCOPY)
    mark_as_advanced(MINGW64_OBJDUMP)
    mark_as_advanced(MINGW64_RANLIB)
    mark_as_advanced(MINGW64_READELF)
    mark_as_advanced(MINGW64_STRIP)

    set(MINGW64_ADDR2LINE  "${MINGW64_ADDR2LINE}") # CACHE FILEPATH "<MINGW64>: The full path to the 'addr2line' utility." FORCE)
    set(MINGW64_DLLTOOL    "${MINGW64_DLLTOOL}") # CACHE FILEPATH "<MINGW64>: The full path to the 'dlltool' utility." FORCE)
    set(MINGW64_LINKER     "${MINGW64_LINKER}") # CACHE FILEPATH "<MINGW64>: The full path to the linker utility." FORCE)
    set(MINGW64_MAKE       "${MINGW64_MAKE}") # CACHE FILEPATH "<MINGW64>: The full path to the <MAKE> utility." FORCE)
    set(MINGW64_OBJCOPY    "${MINGW64_OBJCOPY}") # CACHE FILEPATH "<MINGW64>: The full path to the 'objcopy' utility." FORCE)
    set(MINGW64_OBJDUMP    "${MINGW64_BINDIR}") # CACHE FILEPATH "<MINGW64>: The full path to the 'objdump' utility." FORCE)
    set(MINGW64_RANLIB     "${MINGW64_BINDIR}") # CACHE FILEPATH "<MINGW64>: The full path to the 'ranlib' utility." FORCE)
    set(MINGW64_READELF    "${MINGW64_BINDIR}") # CACHE FILEPATH "<MINGW64>: The full path to the 'readelf' utility." FORCE)
    set(MINGW64_STRIP      "${MINGW64_BINDIR}") # CACHE FILEPATH "<MINGW64>: The full path to the 'strip' utility." FORCE)

    # set(__USE_MINGW_ANSI_STDIO  "1")                                   # CACHE STRING   "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
    # set(_FORTIFY_SOURCE         "2")                                   # CACHE STRING   "Fortify source definition." FORCE)

    # include("${CMAKE_CURRENT_LIST_DIR}/profiles/MINGW64/MINGW64-RCCompiler.cmake")

    # ###########################################################################
    # # CMake vars...
    # ###########################################################################

    foreach(lang C CXX)
        # This is where we pick some very important config files from
        # "./scripts/cmake/Modules/Compiler/<ID>-<FRONTEND>-<LANG>.cmake"
        # 'ID' points to 'MINGW64' which picks up those compiler files.
        # 'FRONTEND' tells CMake to to use the 'GNU' configs.
        set(CMAKE_${lang}_COMPILER_ID "MINGW64" CACHE STRING "" FORCE)
        set(CMAKE_${lang}_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "" FORCE)
        # 'TARGET' tells the compiler in question what it's '--target:' is.
        set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
    endforeach()

    find_program(CMAKE_C_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe" NO_CACHE)
    find_program(CMAKE_CXX_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe" NO_CACHE)
    find_program(CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-rc.exe" NO_CACHE)

    # get_filename_component(COMPILER_BASENAME "${CMAKE_CXX_COMPILER}" NAME)
    # set(COMPILER_BASENAME        "MINGW64" CACHE STRING "" FORCE)

    if(NOT CMAKE_RC_COMPILER)
        find_program (CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres" NO_CACHE)
        if(NOT CMAKE_RC_COMPILER)
            find_program (CMAKE_RC_COMPILER "windres" NO_CACHE)
        endif()
    endif()
    set(CMAKE_RC_COMPILER_TARGET "${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    mark_as_advanced(CMAKE_C_COMPILER)
    mark_as_advanced(CMAKE_CXX_COMPILER)
    mark_as_advanced(CMAKE_RC_COMPILER)


    get_property( _CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

    # The following flags come from 'PORT' files (i.e., build config files for packages)
    if(NOT _CMAKE_IN_TRY_COMPILE)

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

        string(APPEND CMAKE_RC_FLAGS_INIT                   " ${MSYS_RC_FLAGS} ")
        string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT             " ${MSYS_RC_FLAGS_DEBUG} ")
        string(APPEND CMAKE_RC_FLAGS_RELEASE_INIT           " ${MSYS_RC_FLAGS_RELEASE} ")
        string(APPEND CMAKE_RC_FLAGS_MINSIZEREL_INIT        " ${MSYS_RC_FLAGS_MINSIZEREL} ")
        string(APPEND CMAKE_RC_FLAGS_RELWITHDEBINFO_INIT    " ${MSYS_RC_FLAGS_RELWITHDEBINFO} ")

        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT        " ${MSYS_LINKER_FLAGS} ")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT           " ${MSYS_LINKER_FLAGS} ")

        if(MINGW64_CRT_LINKAGE STREQUAL "static")
            string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT    "-static ")
            string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT       "-static ")
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

    endif()

    # get_property( _MSYS_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

    # if(NOT _MSYS_IN_TRY_COMPILE)

    #     string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_SHARED} ") # These strip flags should be enabled via cmake options...
    #     string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " ${LDFLAGS} ${STRIP_BINARIES} ")

    #     string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
    #     string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")

    #     string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT " ${LDFLAGS_DEBUG} ")
    #     string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT " ${LDFLAGS_RELEASE} ")

    # endif() # (NOT _MSYS_IN_TRY_COMPILE)

    message(STATUS "MinGW x64 toolchain loaded")

endif()
