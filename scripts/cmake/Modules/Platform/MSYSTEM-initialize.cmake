#[===[.md

# Source: CMakeSystemSpecificInitialization.cmake

This file is included by 'cmGlobalGenerator::EnableLanguage'.
It is included before the compiler has been determined.

The 'CMAKE_EFFECTIVE_SYSTEM_NAME' is used to load compiler and compiler
wrapper configuration files. By default it equals to 'CMAKE_SYSTEM_NAME'
but could be overridden in the '${CMAKE_SYSTEM_NAME}-Initialize' files.

It is useful to share the same aforementioned configuration files and
avoids duplicating them in case of tightly related platforms.

An example are the platforms supported by Xcode (macOS, iOS, tvOS,
and watchOS). For all of those the 'CMAKE_EFFECTIVE_SYSTEM_NAME' is
set to Apple which results in using
'Platform/Apple-AppleClang-CXX.cmake' for the Apple C++ compiler.

```cmake
set(CMAKE_EFFECTIVE_SYSTEM_NAME "${CMAKE_SYSTEM_NAME}")

include(Platform/${CMAKE_SYSTEM_NAME}-Initialize OPTIONAL)

set(CMAKE_SYSTEM_SPECIFIC_INITIALIZE_LOADED 1)
```

#]===]

# message("MSYSTEM: ${MSYSTEM}")
# message("CMAKE_TOOLCHAIN_FILE: ${CMAKE_TOOLCHAIN_FILE}")

#[===[.md:
# z_msys_add_fatal_error
Add a fatal error.

```cmake
z_msys_add_fatal_error(<message>...)
```

We use this system, instead of `message(FATAL_ERROR)`,
since cmake prints a lot of nonsense if the toolchain errors out before it's found the build tools.

This `Z_MSYS_HAS_FATAL_ERROR` must be checked before any filesystem operations are done,
since otherwise you might be doing something with bad variables set up.
#]===]

# this is defined above everything else so that it can be used.
set(Z_MSYS_FATAL_ERROR)
set(Z_MSYS_HAS_FATAL_ERROR OFF)

#Sensible error logging.
function(z_msys_add_fatal_error ERROR)
    if(NOT Z_MSYS_HAS_FATAL_ERROR)
        set(Z_MSYS_HAS_FATAL_ERROR ON PARENT_SCOPE)
        set(Z_MSYS_FATAL_ERROR "${ERROR}" PARENT_SCOPE)
    else()
        string(APPEND Z_MSYS_FATAL_ERROR "\n${ERROR}")
    endif()
endfunction()

# Detect msys2.ini to figure MSYS_ROOT_DIR
set(Z_MSYS_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
while(NOT DEFINED Z_MSYS_ROOT_DIR)
    if(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(IS_DIRECTORY "${Z_MSYS_ROOT_DIR_CANDIDATE}")
        get_filename_component(Z_MSYS_ROOT_DIR_TEMP "${Z_MSYS_ROOT_DIR_CANDIDATE}" DIRECTORY)
        if(Z_MSYS_ROOT_DIR_TEMP STREQUAL Z_MSYS_ROOT_DIR_CANDIDATE)
            break() # If unchanged, we have reached the root of the drive without finding vcpkg.
        endif()
        set(Z_MSYS_ROOT_DIR_CANDIDATE "${Z_MSYS_ROOT_DIR_TEMP}")
        unset(Z_MSYS_ROOT_DIR_TEMP)
    else()
        break()
    endif()
endwhile()
unset(Z_MSYS_ROOT_DIR_CANDIDATE)
if(NOT Z_MSYS_ROOT_DIR)
    z_msys_add_fatal_error("Could not find '/msys2.ini' - is your msys64 installation in a strange place?")
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}")

##-- This one is for 'FindMSYS'
set(MSYS_INSTALL_PATH "${Z_MSYS_ROOT_DIR}" CACHE PATH "This one is for 'FindMSYS'." FORCE)

# ##-- This one is for the compiler implicit includes...
# set(CMAKE_EXTRA_GENERATOR "MSYS Makefiles" CACHE STRING "The extra generator used to build the project." FORCE)


if(NOT DEFINED CMAKE_SYSTEM_PREFIX_PATH)
    set(CMAKE_SYSTEM_PREFIX_PATH)
endif()
if(NOT DEFINED CMAKE_SYSTEM_INCLUDE_PATH)
    set(CMAKE_SYSTEM_INCLUDE_PATH)
endif()
if(NOT DEFINED CMAKE_SYSTEM_LIBRARY_PATH)
    set(CMAKE_SYSTEM_LIBRARY_PATH)
endif()
if(NOT DEFINED CMAKE_SYSTEM_PROGRAM_PATH)
    set(CMAKE_SYSTEM_PROGRAM_PATH)
endif()
if(NOT DEFINED CMAKE_SYSTEM_IGNORE_PATH)
    set(CMAKE_SYSTEM_LIBRARY_PATH)
endif()
if(NOT DEFINED CMAKE_SYSTEM_IGNORE_PREFIX_PATH)
    set(CMAKE_SYSTEM_PROGRAM_PATH)
endif()
if(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_LIBRARY STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_PACKAGE STREQUAL "ONLY")
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${Z_MSYS_ROOT_DIR}/")
endif()

if(NOT DEFINED MSYS_PATH)
    set(MSYS_PATH) # Create a new list if we haven't already
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/bin")
    list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/usr/local/bin")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/bin")
    list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/usr/bin")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/bin")
    list(APPEND MSYS_PATH "${Z_MSYS_ROOT_DIR}/bin")
endif()
if(NOT DEFINED MSYS_PATH)
    z_msys_add_fatal_error("Could not set 'MSYS_PATH' - check your msys64 installation!")
endif()

if(NOT DEFINED MSYS_MANPATH)
    set(MSYS_MANPATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/man")
    list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/local/man")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/man")
    list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/share/man")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/man")
    list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/usr/man")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/share/man")
    list(APPEND MSYS_MANPATH "${Z_MSYS_ROOT_DIR}/share/man")
endif()
if(NOT DEFINED MSYS_MANPATH)
    z_msys_add_fatal_error("Could not set 'MSYS_MANPATH' - check your msys64 installation!")
endif()


if(NOT DEFINED MSYS_INFOPATH)
    set(MSYS_INFOPATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/info")
    list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/local/info")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/info")
    list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/share/info")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/info")
    list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/usr/info")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/share/info")
    list(APPEND MSYS_INFOPATH "${Z_MSYS_ROOT_DIR}/share/info")
endif()
if(NOT DEFINED MSYS_INFOPATH)
    z_msys_add_fatal_error("Could not set 'MSYS_INFOPATH' - check your msys64 installation!")
endif()


if(NOT DEFINED PKG_CONFIG_PATH)
    set(PKG_CONFIG_PATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig")
    list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig")
    list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")
    list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/share/pkgconfig")
    list(APPEND PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/share/pkgconfig")
endif()
if(NOT DEFINED PKG_CONFIG_PATH)
    z_msys_add_fatal_error("Could not set 'PKG_CONFIG_PATH' - check your msys64 installation!")
else()

    set(Z_MSYS_PKG_CONFIG_PATH "${PKG_CONFIG_PATH}" CACHE PATH "Default value(s) for <MSYS_PKG_CONFIG_PATH>. These are overwritten if that variable is defined." FORCE)
    mark_as_advanced(Z_MSYS_PKG_CONFIG_PATH)

    if(NOT DEFINED MSYS_PKG_CONFIG_PATH)
        set(MSYS_PKG_CONFIG_PATH "${PKG_CONFIG_PATH}")
    endif()

endif()


if(NOT DEFINED PKG_CONFIG_SYSTEM_INCLUDE_PATH)
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/include")
    list(APPEND PKG_CONFIG_SYSTEM_INCLUDE_PATH "${Z_MSYS_ROOT_DIR}/usr/include")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/include")
    list(APPEND PKG_CONFIG_SYSTEM_INCLUDE_PATH "${Z_MSYS_ROOT_DIR}/include")
endif()
if(NOT DEFINED PKG_CONFIG_SYSTEM_INCLUDE_PATH)
    z_msys_add_fatal_error("Could not set 'PKG_CONFIG_SYSTEM_INCLUDE_PATH' - check your msys64 installation!")
else()

    set(Z_MSYS_PKG_CONFIG_SYSTEM_INCLUDE_PATH "${PKG_CONFIG_SYSTEM_INCLUDE_PATH}" CACHE PATH "Default value(s) for <MSYS_PKG_CONFIG_SYSTEM_INCLUDE_PATH>. These are overwritten if that variable is defined." FORCE)
    mark_as_advanced(Z_MSYS_PKG_CONFIG_SYSTEM_INCLUDE_PATH)

    if(NOT DEFINED MSYS_PKG_CONFIG_SYSTEM_INCLUDE_PATH)
        set(MSYS_PKG_CONFIG_SYSTEM_INCLUDE_PATH "${PKG_CONFIG_SYSTEM_INCLUDE_PATH}")
    endif()

endif()

if(NOT DEFINED PKG_CONFIG_SYSTEM_LIBRARY_PATH)
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/lib")
    list(APPEND PKG_CONFIG_SYSTEM_LIBRARY_PATH "${Z_MSYS_ROOT_DIR}/usr/lib")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/lib")
    list(APPEND PKG_CONFIG_SYSTEM_LIBRARY_PATH "${Z_MSYS_ROOT_DIR}/lib")
endif()
if(NOT DEFINED PKG_CONFIG_SYSTEM_LIBRARY_PATH)
    z_msys_add_fatal_error("Could not set 'PKG_CONFIG_SYSTEM_LIBRARY_PATH' - check your msys64 installation!")
else()

    set(Z_MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH "${PKG_CONFIG_SYSTEM_LIBRARY_PATH}" CACHE PATH "Default value(s) for <MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH>. These are overwritten if that variable is defined." FORCE)
    mark_as_advanced(Z_MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH)

    if(NOT DEFINED MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH)
        set(MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH "${Z_MSYS_PKG_CONFIG_SYSTEM_LIBRARY_PATH}")
    endif()

endif()

if(NOT DEFINED ACLOCAL_PATH)
    set(ACLOCAL_PATH)
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/local/share/aclocal")
    list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/usr/local/share/aclocal")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/usr/share/aclocal")
    list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/usr/share/aclocal")
endif()
if(EXISTS "${Z_MSYS_ROOT_DIR}/share/aclocal")
    list(APPEND ACLOCAL_PATH "${Z_MSYS_ROOT_DIR}/share/aclocal")
endif()
if(NOT DEFINED ACLOCAL_PATH)
    z_msys_add_fatal_error("Could not set 'ACLOCAL_PATH' - check your msys64 installation!")
else()
    set(Z_MSYS_ACLOCAL_PATH "${ACLOCAL_PATH}" CACHE PATH "Default value(s) for <MSYS_ACLOCAL_PATH>. These are overwritten if that variable is defined." FORCE)
    mark_as_advanced(Z_MSYS_ACLOCAL_PATH)
    if(NOT DEFINED MSYS_ACLOCAL_PATH)
        set(MSYS_ACLOCAL_PATH "${Z_MSYS_ACLOCAL_PATH}")
    endif()
endif()


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

    if(NOT DEFINED CMAKE_SYSTEM_PREFIX_PATH)
        set(CMAKE_SYSTEM_PREFIX_PATH)
    endif()
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${_programfiles}")

endif()
unset(_programfiles)


#[===[.md:
# z_msys_set_powershell_path

Gets either the path to powershell or powershell core,
and places it in the variable Z_MSYS_POWERSHELL_PATH.
#]===]
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


#
#if MSYS_PATH_TYPE == "-inherit"
#
#    Inherit previous path. Note that this will make all of the
#    Windows path available in current shell, with possible
#    interference in project builds.
#
#if MSYS_PATH_TYPE == "-minimal"
#
#if MSYS_PATH_TYPE == "-strict"
#
#    Do not inherit any path configuration, and allow for full
#    customization of external path. This is supposed to be used
#    in special cases such as debugging without need to change
#    this file, but not daily usage.
#
if(NOT DEFINED MSYS_PATH_TYPE)
    set(MSYS_PATH_TYPE "inherit")
endif()
set(MSYS_PATH_TYPE "${MSYS_PATH_TYPE}" CACHE STRING " " FORCE)

if(MSYS_PATH_TYPE STREQUAL "strict")

    # Do not inherit any path configuration, and allow for full customization
    # of external path. This is supposed to be used in special cases such as
    # debugging without need to change this file, but not daily usage.
    unset(ORIGINAL_PATH)

elseif(MSYS_PATH_TYPE STREQUAL "inherit")

    if(NOT DEFINED ORIGINAL_PATH)
        set(ORIGINAL_PATH "$ENV{Path}" CACHE PATH "Inherited path from calling environment")
    endif()

    set(ORIGINAL_PATH "${ORIGINAL_PATH}")

    list(APPEND _clean_env_path "${ORIGINAL_PATH}")

    # This won't work if no MSYSTEM is known...
    if(DEFINED MSYSTEM)
        set(_ignored_msystems)
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw32")
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw64")
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang32")
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang64")
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clangarm64")
        list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/ucrt64")
        list(REMOVE_ITEM _ignored_msystems "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")
        foreach(_ignore ${_ignored_msystems})
            list(REMOVE_ITEM _clean_env_path "${_ignore}/bin")
        endforeach()
        unset(_ignored_msystems)
    endif()


    # message(STATUS "Found Env PATH:")
    # foreach(_dir ${_clean_env_path})
    #     message(STATUS "'${_dir}'")
    # endforeach()
    # message(STATUS " ")
    # unset(_dir)

    # Inherit previous path. Note that this will make all of the Windows path
    # available in current run, with possible interference in project builds.
    # We have taken extra care to strip out all the other sub-systems (in case
    # they happen to exist on your env PATH).
    set(ORIGINAL_PATH "${_clean_env_path}" CACHE PATH "<PATH> environment variable." FORCE) # This one makes CMake transform the path seperators...
    unset(_clean_env_path)

elseif(MSYS_PATH_TYPE STREQUAL "minimal")

    if(DEFINED ENV{WINDIR})
        set(WIN_ROOT "$ENV{WINDIR}" CACHE FILEPATH "" FORCE)
    else()
        if(DEFINED ENV{HOMEDRIVE})
            set(WIN_ROOT "$ENV{HOMEDRIVE}/Windows" CACHE FILEPATH "" FORCE)
        else()
            z_msys_add_fatal_error("HELP! You have no WINDIR nor HOMEDRIVE in your calling environment??")
        endif()
    endif()

    if(NOT DEFINED ORIGINAL_PATH)
        set(ORIGINAL_PATH)
    endif()
    list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32")
    list(APPEND ORIGINAL_PATH "${WIN_ROOT}")
    list(APPEND ORIGINAL_PATH "${WIN_ROOT}/System32/Wbem")

    set(ORIGINAL_PATH "${ORIGINAL_PATH}" CACHE PATH "<PATH> environment variable." FORCE)

endif()



if(Z_MSYS_HAS_FATAL_ERROR)
    message(FATAL_ERROR "MSYS_FATAL_ERROR = ${Z_MSYS_FATAL_ERROR}")
endif()
