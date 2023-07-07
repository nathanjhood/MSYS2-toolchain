# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# Block multiple inclusion because "CMakeCInformation.cmake" includes
# "Platform/${CMAKE_SYSTEM_NAME}" even though the generic module
# "CMakeSystemSpecificInformation.cmake" already included it.
# The extra inclusion is a work-around documented next to the include()
# call, so this can be removed when the work-around is removed.
if(__MSYSTEM_PATHS_INCLUDED)
    return()
endif()
set(__MSYSTEM_PATHS_INCLUDED 1)

# message(WARNING "ping")

# set(MINGW64 1)
#set(UNIX 1) # Set to ``True`` when the target system is UNIX or UNIX-like (e.g. ``APPLE`` and ``CYGWIN``
set(MINGW 1) # ``True`` when using MinGW
set(WIN32 1) # Set to ``True`` when the target system is Windows, including Win64.

# also add the install directory of the running cmake to the search directories
# CMAKE_ROOT is CMAKE_INSTALL_PREFIX/share/cmake, so we need to go two levels up
get_filename_component(_CMAKE_INSTALL_DIR "${CMAKE_ROOT}" PATH)
get_filename_component(_CMAKE_INSTALL_DIR "${_CMAKE_INSTALL_DIR}" PATH)

# List common installation prefixes.  These will be used for all
# search types.
set(CMAKE_SYSTEM_PREFIX_PATH)
list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${_CMAKE_INSTALL_DIR}")


#[===[.md:
# z_msys_set_powershell_path

Gets either the path to powershell or powershell core,
and places it in the variable Z_MSYS_POWERSHELL_PATH.
#]===]
function(z_msys_set_powershell_path)
    # Attempt to use pwsh if it is present; otherwise use powershell
    if(NOT DEFINED Z_MSYS_POWERSHELL_PATH)
        find_program(Z_MSYS_PWSH_PATH pwsh)
        if(Z_MSYS_PWSH_PATH)
            set(Z_MSYS_POWERSHELL_PATH "${Z_MSYS_PWSH_PATH}" CACHE INTERNAL "The path to the PowerShell implementation to use.")
        else()
            message(DEBUG "msys2: Could not find PowerShell Core; falling back to PowerShell")
            find_program(Z_MSYS_BUILTIN_POWERSHELL_PATH powershell REQUIRED)
            if(Z_MSYS_BUILTIN_POWERSHELL_PATH)
                set(Z_MSYS_POWERSHELL_PATH "${Z_MSYS_BUILTIN_POWERSHELL_PATH}" CACHE INTERNAL "The path to the PowerShell implementation to use.")
            else()
                message(WARNING "msys2: Could not find PowerShell; using static string 'powershell.exe'")
                set(Z_MSYS_POWERSHELL_PATH "powershell.exe" CACHE INTERNAL "The path to the PowerShell implementation to use.")
            endif()
        endif()
    endif() # Z_MSYS_POWERSHELL_PATH
endfunction()

z_msys_set_powershell_path()

#
#if MSYS2_PATH_TYPE == "-inherit"
#
#    Inherit previous path. Note that this will make all of the
#    Windows path available in current shell, with possible
#    interference in project builds.
#
#if MSYS2_PATH_TYPE == "-minimal"
#
#if MSYS2_PATH_TYPE == "-strict"
#
#    Do not inherit any path configuration, and allow for full
#    customization of external path. This is supposed to be used
#    in special cases such as debugging without need to change
#    this file, but not daily usage.
#
macro(set_msystem_path_type)

    if(NOT DEFINED MSYS2_PATH_TYPE)
        set(MSYS2_PATH_TYPE "inherit")
    endif()
    set(MSYS2_PATH_TYPE "${MSYS2_PATH_TYPE}" CACHE STRING " " FORCE)

    if(ENV{VERBOSE})
        message(STATUS "Msys64 path type: '${MSYS2_PATH_TYPE}'")
    endif()

    if(MSYS2_PATH_TYPE STREQUAL "strict")

        # Do not inherit any path configuration, and allow for full customization
        # of external path. This is supposed to be used in special cases such as
        # debugging without need to change this file, but not daily usage.
        unset(ORIGINAL_PATH)

    elseif(MSYS2_PATH_TYPE STREQUAL "inherit")

        # Inherit previous path. Note that this will make all of the Windows path
        # available in current shell, with possible interference in project builds.
        # ORIGINAL_PATH="${ORIGINAL_PATH:-${PATH}}"
        set(ORIGINAL_PATH "$ENV{Path}")

    elseif(MSYS2_PATH_TYPE STREQUAL "minimal")

        # WIN_ROOT="$(PATH=${MSYS2_PATH} exec cygpath -Wu)"
        if(DEFINED ENV{WINDIR})
            set(WIN_ROOT "$ENV{WINDIR}" CACHE FILEPATH "" FORCE)
        else()
            if(DEFINED ENV{HOMEDRIVE})
                set(WIN_ROOT "$ENV{HOMEDRIVE}/Windows" CACHE FILEPATH "" FORCE)
            else()
                message(FATAL_ERROR "HELP!")
            endif()
        endif()
        set(ORIGINAL_PATH)
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32")
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}")
        list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32/Wbem")
        if(DEFINED Z_MSYS_POWERSHELL_PATH)
            list(APPEND ORIGINAL_PATH "${Z_MSYS_POWERSHELL_PATH}")
        else()
            list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32/WindowsPowerShell/v1.0/")
        endif()
        set(ORIGINAL_PATH "${ORIGINAL_PATH}")

    endif()

    set(ORIGINAL_PATH "${ORIGINAL_PATH}" CACHE STRING "<PATH> environment variable." FORCE)

endmacro()

set_msystem_path_type()

macro(set_msys_system_paths)
    find_program(BASH "${Z_MSYS_ROOT_DIR}/usr/bin/bash.exe")
    find_program(ECHO "${Z_MSYS_ROOT_DIR}/usr/bin/echo.exe")

    execute_process(
        COMMAND ${ECHO} {{,usr/}{,local/}{,share/},opt/*/}{man} mingw{32,64}{{,/local}{,/share},/opt/*}/{man}
        WORKING_DIRECTORY ${Z_MSYS_ROOT_DIR}
        OUTPUT_VARIABLE MAN_DIRS
    )
    string(REPLACE " " ";\n" MAN_DIRS "${MAN_DIRS}")
    message(STATUS "MAN_DIRS = \n${MAN_DIRS}")

    execute_process(
        COMMAND ${ECHO} {{,usr/}{,local/}{,share/},opt/*/}{info} mingw{32,64}{{,/local}{,/share},/opt/*}/{info}
        WORKING_DIRECTORY ${Z_MINGW64_ROOT_DIR}
        OUTPUT_VARIABLE INFO_DIRS
    )
    string(REPLACE " " "\n" INFO_DIRS "${INFO_DIRS}")
    message(STATUS "INFO_DIRS = \n${INFO_DIRS}")
endmacro()

# set_msys_system_paths()

set(MSYS2_PATH)
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/usr/local/bin")
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/usr/bin")
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/bin")


set(MSYS2_MANPATH)
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/local/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/share/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/share/man")


set(MSYS2_INFOPATH)
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/local/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/share/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/share/info")


if(MSYSTEM STREQUAL "MSYS2")
else()
    # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(MSYS2_PATH "${MINGW_MOUNT_POINT}/bin" "${MSYS2_PATH}" "${ORIGINAL_PATH}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MSYS2_MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(MSYS2_INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(MSYS2_DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")
endif()

set(MSYS2_PATH "${MSYS2_PATH}" CACHE PATH "<MSYS2_PATH>" FORCE)
set(MSYS2_MANPATH "${MSYS2_MANPATH}" CACHE PATH "<MSYS2_MANPATH>" FORCE)
set(MSYS2_INFOPATH "${MSYS2_INFOPATH}" CACHE PATH "<MSYS2_INFOPATH>" FORCE)

# Reminder when adding new locations computed from environment variables
# please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
# synchronized
list(APPEND CMAKE_SYSTEM_PREFIX_PATH

    # Standard
    "${MSYS2_PATH}"

    # CMake install location
    "${_CMAKE_INSTALL_DIR}"
)

#
#Add the program-files folder(s) to the list of installation
#prefixes.
#
#Windows 64-bit Binary:
#
#    ENV{ProgramFiles(x86)} = [C:\Program Files (x86)]
#    ENV{ProgramFiles}      = [C:\Program Files]
#    ENV{ProgramW6432}      = [C:\Program Files] or <not set>
#
#Windows 32-bit Binary on 64-bit Windows:
#
#    ENV{ProgramFiles(x86)} = [C:\Program Files (x86)]
#    ENV{ProgramFiles}      = [C:\Program Files (x86)]
#    ENV{ProgramW6432}      = [C:\Program Files]
#
#Reminder when adding new locations computed from environment variables
#please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
#synchronized
macro(add_win32_program_files_to_cmake_system_prefix_path)
    set(_programfiles "")
    foreach(v "ProgramW6432" "ProgramFiles" "ProgramFiles(x86)")
        if(DEFINED "ENV{${v}}")
            file(TO_CMAKE_PATH "$ENV{${v}}" _env_programfiles)
            list(APPEND _programfiles "${_env_programfiles}")
            unset(_env_programfiles)
        endif()
    endforeach()
    if(DEFINED "ENV{SystemDrive}")
        foreach(d "Program Files" "Program Files (x86)")
            if(EXISTS "$ENV{SystemDrive}/${d}")
                list(APPEND _programfiles "$ENV{SystemDrive}/${d}")
            endif()
        endforeach()
    endif()
    if(_programfiles)
        list(REMOVE_DUPLICATES _programfiles)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH ${_programfiles})
    endif()
    unset(_programfiles)
endmacro()

add_win32_program_files_to_cmake_system_prefix_path()

if (NOT CMAKE_FIND_NO_INSTALL_PREFIX) # Add other locations.
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_INSTALL_PREFIX}") # Project install destination.
    if(CMAKE_STAGING_PREFIX)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_STAGING_PREFIX}") # User-supplied staging prefix.
    endif()
endif()
_cmake_record_install_prefix()

if(CMAKE_CROSSCOMPILING AND NOT CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
    # MinGW (useful when cross compiling from linux with CMAKE_FIND_ROOT_PATH set)
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH /)
endif()

list(APPEND CMAKE_SYSTEM_INCLUDE_PATH)

# mingw can also link against dlls which can also be in '/bin', so list this too
if (NOT CMAKE_FIND_NO_INSTALL_PREFIX)
    list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_INSTALL_PREFIX}/bin")
    if (CMAKE_STAGING_PREFIX)
        list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_STAGING_PREFIX}/bin")
    endif()
endif()
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${_CMAKE_INSTALL_DIR}/bin")
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH /bin)

list(APPEND CMAKE_SYSTEM_PROGRAM_PATH)


# Non "standard" but common install prefixes
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
    # "${Z_${MSYSTEM}_ROOT_DIR}/usr/X11R6"
    # "${Z_${MSYSTEM}_ROOT_DIR}/usr/pkg"
    # "${Z_${MSYSTEM}_ROOT_DIR}/opt"
    # "${Z_${MSYSTEM}_ROOT_DIR}/x86_64-w64-mingw32"
)
if(DEFINED MSYS2_DXSDK_DIR) # This should probably be some sort of 'COMPATIBILITY' switcheroo...
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${MSYS2_DXSDK_DIR}")
endif()

# List common include file locations not under the common prefixes.
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
    # X11
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/include/X11"
)

list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
    # X11
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib/X11"
)

list(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
    "${Z_${MSYSTEM}_ROOT_DIR}/lib"
    "${Z_${MSYSTEM}_ROOT_DIR}/lib32"
    "${Z_${MSYSTEM}_ROOT_DIR}/lib64"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib32"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib64"
)

if(CMAKE_SYSROOT_COMPILE)
    set(_cmake_sysroot_compile "${CMAKE_SYSROOT_COMPILE}")
else()
    set(_cmake_sysroot_compile "${CMAKE_SYSROOT}")
endif()

# Default per-language values.  These may be later replaced after
# parsing the implicit directory information from compiler output.
set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT)
list(APPEND _CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}")
list(APPEND _CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_cmake_sysroot_compile}/usr/include")
set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT}")

set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT)
list(APPEND _CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}")
list(APPEND _CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_cmake_sysroot_compile}/usr/include")
set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT}")

set(_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT)
list(APPEND _CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES}")
list(APPEND _CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_cmake_sysroot_compile}/usr/include")
set(_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT "${_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT}")

unset(_cmake_sysroot_compile)

# Reminder when adding new locations computed from environment variables
# please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
# synchronized
if(CMAKE_COMPILER_SYSROOT)
    list(PREPEND CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_COMPILER_SYSROOT}")

    if(DEFINED ENV{CONDA_PREFIX} AND EXISTS "$ENV{CONDA_PREFIX}")
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH "$ENV{CONDA_PREFIX}")
    endif()
endif()

# Enable use of lib32 and lib64 search path variants by default.
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB32_PATHS TRUE)
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIB64_PATHS TRUE)
set_property(GLOBAL PROPERTY FIND_LIBRARY_USE_LIBX32_PATHS TRUE)


###############################################################################





# if(ENABLE_${MSYSTEM})
#     set(${MSYSTEM}_ROOT                    "${Z_${MSYSTEM}_ROOT_DIR}")            # CACHE PATH      "<MINGW64>: Root of the build system." FORCE)

#     set(${MSYSTEM}_PREFIX                  "${MINGW64_ROOT}")                  # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(${MSYSTEM}_BUILD_PREFIX            "${MINGW64_PREFIX}/usr")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_INSTALL_PREFIX          "${MINGW64_PREFIX}/usr/local")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_INCLUDEDIR              "${MINGW64_PREFIX}/include")        # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SRCDIR                  "${MINGW64_PREFIX}/src")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SYSCONFDIRDIR           "${MINGW64_PREFIX}/etc")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_DATAROOTDIR             "${MINGW64_PREFIX}/share")          # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_DATADIR                 "${MINGW64_DATAROOTDIR}")           # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_DOCDIR                  "${MINGW64_DATAROOTDIR}/doc")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_MANDIR                  "${MINGW64_DATAROOTDIR}/man")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_INFODIR                 "${MINGW64_DATAROOTDIR}/info")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LOCALEDIR               "${MINGW64_DATAROOTDIR}/locale")    # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_CMAKEDIR                "${MINGW64_DATAROOTDIR}/cmake")     # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_EXEC_PREFIX             "${MINGW64_PREFIX}")                # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_BINDIR                  "${MINGW64_EXEC_PREFIX}/bin")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SBINDIR                 "${MINGW64_EXEC_PREFIX}/sbin")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LIBDIR                  "${MINGW64_EXEC_PREFIX}/lib")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LIBEXECDIR              "${MINGW64_EXEC_PREFIX}/libexec")   # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     # DirectX compatibility environment variable
#     set(MINGW64_DXSDK_DIR               "${MINGW64_ROOT}/x86_64-w64-mingw32")   # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

#     # set(ACLOCAL_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${Z_MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
#     set(MINGW64_ACLOCAL_PATH)
#     list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/share/aclocal")
#     list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/usr/share")
#     set(MINGW64_ACLOCAL_PATH "${MINGW64_ACLOCAL_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

#     # set(PKG_CONFIG_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)
#     set(MINGW64_PKG_CONFIG_PATH)
#     list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/lib/pkgconfig")
#     list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/share/pkgconfig")
#     set(MINGW64_PKG_CONFIG_PATH "${MINGW64_PKG_CONFIG_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)
# endif()

#[===[
set(CMAKE_SYSTEM_PREFIX_PATH
    "C:/msys64/mingw64/usr/local"
    "C:/msys64/mingw64/usr"
    "C:/msys64/mingw64/"
    "C:/msys64/mingw64"
    "c:/Users/natha/Development/StoneyDSP/MSYS2-toolchain/usr/local"
    "C:/msys64/mingw64/usr/X11R6"
    "C:/msys64/mingw64/usr/pkg"
    "C:/msys64/mingw64/opt"
)

set(CMAKE_SYSTEM_INCLUDE_PATH "C:/msys64/mingw64/usr/include/X11")
set(CMAKE_SYSTEM_LIBRARY_PATH "C:/msys64/mingw64/usr/lib/X11")

set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include")
set(_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include"
set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include")

CMAKE_C_IGNORE_EXTENSIONS="h;H;o;O;obj;OBJ;def;DEF;rc;RC"
CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_C_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES
    "mingw32"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
    "pthread"
    "advapi32"
    "shell32"
    "user32"
    "kernel32"
    "mingw32"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
)

set(CMAKE_CXX_IGNORE_EXTENSIONS "inl;h;hpp;HPP;H;o;O;obj;OBJ;def;DEF;rc;RC")
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/mingw64/include/c++/13.1.0;C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/mingw64/include/c++/13.1.0/backward;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib")
set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES
    "stdc++"
    "mingw32"
    "gcc_s"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
    "pthread"
    "advapi32"
    "shell32"
    "user32"
)

CMAKE_Fortran_IGNORE_EXTENSIONS="h;H;o;O;obj;OBJ;def;DEF;rc;RC"
CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES="gfortran;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;quadmath;m;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32"

CMAKE_OBJCXX_IGNORE_EXTENSIONS="inl;h;hpp;HPP;H;o;O"
CMAKE_OBJCXX_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/include/c++/13.1.0;C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/mingw64/include/c++/13.1.0/backward;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_OBJCXX_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_OBJCXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_OBJCXX_IMPLICIT_LINK_LIBRARIES="stdc++;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32"

CMAKE_OBJC_IGNORE_EXTENSIONS="h;H;o;O"
CMAKE_OBJC_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_OBJC_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_OBJC_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_OBJC_IMPLICIT_LINK_LIBRARIES="mingw32;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc;moldname;mingwex;kernel32"
]===]


#[===[
    {
	"kind" : "toolchains",
	"toolchains" :
	[
		{
            "language" : "ASM",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" : {},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-gcc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"s",
				"S",
				"asm"
			]
		},
		{
            "language" : "C",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-gcc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
            "sourceFileExtensions" :
			[
				"c"
			]
		},
		{
            "language" : "CXX",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/include/c++/13.1.0",
						"C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32",
						"C:/msys64/mingw64/include/c++/13.1.0/backward",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"stdc++",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-g++.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"C",
				"c++",
				"cc",
				"cpp",
				"cxx",
				"mpp",
				"CPP",
				"ixx",
				"cppm"
			]
		},
		{
            "language" : "Fortran",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"gfortran",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"quadmath",
						"m",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/gfortran.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"f",
				"F",
				"fpp",
				"FPP",
				"f77",
				"F77",
				"f90",
				"F90",
				"for",
				"For",
				"FOR",
				"f95",
				"F95"
			]
		},
		{
            "language" : "OBJC",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-cc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"m"
			]
		},
		{
            "language" : "OBJCXX",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/include/c++/13.1.0",
						"C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32",
						"C:/msys64/mingw64/include/c++/13.1.0/backward",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"stdc++",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-c++.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"M",
				"mm"
			]
		},
		{
            "language" : "RC",
			"compiler" :
			{
				"implicit" : {},
				"path" : "C:/msys64/mingw64/bin/windres.exe",
				"target" : "x86_64-w64-mingw32"
			},
			"sourceFileExtensions" :
			[
				"rc",
				"RC"
			]
		}
	],
	"version" :
	{
		"major" : 1,
		"minor" : 0
	}
}

]===]
