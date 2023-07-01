# We still need to set some sort of default Z_MSYS_ROOT_DIR in case this file
# is being loaded outside of the MSYS buildsystem file... Let's just use the MSYSTEM name.

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

set(MINGW64_ROOT                    "${Z_MINGW64_ROOT_DIR}"         CACHE PATH      "<MINGW64>: Root of the build system." FORCE)

set(MINGW64_TITLE                   "MinGW x64"                         CACHE STRING    "<MINGW64>: Name of the build system." FORCE)
set(MINGW64_PACKAGE_PREFIX          "mingw-w64-x86_64"                  CACHE STRING    "<MINGW64>: Sub-system package prefix." FORCE)
set(MINGW64_TOOLCHAIN_VARIANT       gcc                                 CACHE STRING    "<MINGW64>: Identification string of the compiler toolchain variant." FORCE)
set(MINGW64_CRT_LIBRARY             msvcrt                              CACHE STRING    "<MINGW64>: Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
set(MINGW64_CRT_LINKAGE             static                              CACHE STRING    "<MINGW64>: C Runtime Library linkage type." FORCE)
set(MINGW64_CXX_STD_LIBRARY         libstdc++                           CACHE STRING    "<MINGW64>: Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)
set(MINGW64_ARCH                    "x86_64"                            CACHE STRING    "<MINGW64>: Sub-system architecture." FORCE)
set(MINGW64_PLAT                    "x86_64-w64-mingw32"                CACHE STRING    "<MINGW64>: Sub-system name string." FORCE)

set(MINGW64_PREFIX                  "${MINGW64_ROOT}"                   CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_BUILD_PREFIX            "${MINGW64_PREFIX}/usr"             CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_INSTALL_PREFIX          "${MINGW64_PREFIX}/usr/local"       CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)

set(MINGW64_INCLUDEDIR              "${MINGW64_PREFIX}/include")
set(MINGW64_SRCDIR                  "${MINGW64_PREFIX}/src")
set(MINGW64_SYSCONFDIRDIR           "${MINGW64_PREFIX}/etc")

set(MINGW64_DATAROOTDIR             "${MINGW64_PREFIX}/share")
set(MINGW64_DATADIR                 "${MINGW64_DATAROOTDIR}")
set(MINGW64_DOCDIR                  "${MINGW64_DATAROOTDIR}/doc")
set(MINGW64_MANDIR                  "${MINGW64_DATAROOTDIR}/man")
set(MINGW64_INFODIR                 "${MINGW64_DATAROOTDIR}/info")
set(MINGW64_LOCALEDIR               "${MINGW64_DATAROOTDIR}/locale")

set(MINGW64_CMAKEDIR                "${MINGW64_DATAROOTDIR}/cmake")

set(MINGW64_EXEC_PREFIX             "${MINGW64_PREFIX}"                 CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_BINDIR                  "${MINGW64_EXEC_PREFIX}/bin"        CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_SBINDIR                 "${MINGW64_EXEC_PREFIX}/sbin"       CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_LIBDIR                  "${MINGW64_EXEC_PREFIX}/lib"        CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)
set(MINGW64_LIBEXECDIR              "${MINGW64_EXEC_PREFIX}/libexec"    CACHE STRING    "<MINGW64>: Sub-system prefix." FORCE)


# DirectX compatibility environment variable
set(MINGW64_DXSDK_DIR               "${MINGW64_ROOT}/x86_64-w64-mingw32"    CACHE PATH "DirectX compatibility environment variable." FORCE)

# set(ACLOCAL_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${Z_MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
set(MINGW64_ACLOCAL_PATH "")
list(APPEND MINGW64_ACLOCAL_PATH
    "${Z_MINGW64_ROOT_DIR}/share/aclocal"
    "${Z_MINGW64_ROOT_DIR}/usr/share"
)
set(MINGW64_ACLOCAL_PATH "${MINGW64_ACLOCAL_PATH}")

# set(PKG_CONFIG_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)
set(MINGW64_PKG_CONFIG_PATH "")
list(APPEND MINGW64_PKG_CONFIG_PATH
    "${Z_MINGW64_ROOT_DIR}/lib/pkgconfig"
    "${Z_MINGW64_ROOT_DIR}/share/pkgconfig"
)
set(MINGW64_PKG_CONFIG_PATH "${MINGW64_PKG_CONFIG_PATH}")

# Set toolchain package suffixes (i.e., '{mingw-w64-clang-x86_64}-avr-toolchain')...
set(MINGW64_TOOLCHAIN_NATIVE_ARM_NONE_EABI          "mingw-w64-x86_64-arm-none-eabi-toolchain") # CACHE STRING "" FORCE)
set(MINGW64_TOOLCHAIN_NATIVE_AVR                    "mingw-w64-x86_64-avr-toolchain") # CACHE STRING "" FORCE)
set(MINGW64_TOOLCHAIN_NATIVE_RISCV64_UNKOWN_ELF     "mingw-w64-x86_64-riscv64-unknown-elf-toolchain") # CACHE STRING "The 'unknown elf' toolchain! Careful with this elf, it is not known." FORCE)
set(MINGW64_TOOLCHAIN_NATIVE                        "mingw-w64-x86_64-toolchain") # CACHE STRING "" FORCE)


#######################################################################################################################
# LANG
#######################################################################################################################


# Programs:
# CMAKE_AR
# CMAKE_<LANG>_COMPILER_AR (Wrapper)
# CMAKE_RANLIB
# CMAKE_<LANG>_COMPILER_RANLIB
# CMAKE_STRIP
# CMAKE_NM
# CMAKE_OBJDUMP
# CMAKE_DLLTOOL
# CMAKE_MT
# CMAKE_LINKER
# CMAKE_C_COMPILER
# CMAKE_CXX_COMPILER
# CMAKE_RC_COMPILER

# Flags:
# CMAKE_<LANG>_FLAGS
# CMAKE_<LANG>_FLAGS_<CONFIG>
# CMAKE_RC_FLAGS
# CMAKE_SHARED_LINKER_FLAGS
# CMAKE_STATIC_LINKER_FLAGS
# CMAKE_STATIC_LINKER_FLAGS_<CONFIG>
# CMAKE_EXE_LINKER_FLAGS
# CMAKE_EXE_LINKER_FLAGS_<CONFIG>

# find_program(MINGW64_AR "${MINGW64_BINDIR}/ar.exe")
# find_program(MINGW64_AS "${MINGW64_BINDIR}/as.exe")
# find_program(MINGW64_CC "${MINGW64_BINDIR}/cc.exe")
# find_program(MINGW64_CXX "${MINGW64_BINDIR}/c++.exe")
# find_program(MINGW64_LD "${MINGW64_BINDIR}/ld.exe")
# find_program(MINGW64_NM "${MINGW64_BINDIR}/nm.exe")

# find_program(MINGW64_ADDR2LINE "${MINGW64_BINDIR}/addr2line.exe")
# find_program(MINGW64_DLLTOOL "${MINGW64_BINDIR}/dlltool.exe")
# find_program(MINGW64_OBJCOPY "${MINGW64_BINDIR}/objcopy.exe")
# find_program(MINGW64_OBJDUMP "${MINGW64_BINDIR}/objdump.exe")
# find_program(MINGW64_RANLIB "${MINGW64_BINDIR}/ranlib.exe")
# find_program(MINGW64_READELF "${MINGW64_BINDIR}/readelf.exe")
# find_program(MINGW64_STRIP "${MINGW64_BINDIR}/strip.exe")

# foreach(lang C CXX) # <MINGW64_ENABLED_LANGUAGES>....
#     set(MINGW64_${lang}_COMPILER_ID "GNU")
#     set(MINGW64_${lang}_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "") # this breaks the Kitware default flags etc...
#     set(MINGW64_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
# endforeach()
