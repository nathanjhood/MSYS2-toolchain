#!/usr/bin/env cmake

##-- For the original source code, please see:
# vcpkg - C++ Library Manager for Windows, Linux, and MacOS
# Copyright (c) Microsoft Corporation
# vcpkg is distributed under the MIT License
# https://github.com/microsoft/vcpkg.git

# message("Reading MSYS.cmake from the top...")

# Mark variables as used so cmake doesn't complain about them
mark_as_advanced(CMAKE_TOOLCHAIN_FILE)

# NOTE: to figure out what cmake versions are required for different things,
# grep for `CMake 3`. All version requirement comments should follow that format.

# Attention: Changes to this file do not affect ABI hashing.

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

set(Z_MSYS_CMAKE_REQUIRED_MINIMUM_VERSION "3.7.2")
if(CMAKE_VERSION VERSION_LESS Z_MSYS_CMAKE_REQUIRED_MINIMUM_VERSION)
    # message(FATAL_ERROR "MSYS2.cmake requires at least CMake ${Z_MSYS_CMAKE_REQUIRED_MINIMUM_VERSION}.")
    z_msys_add_fatal_error("MSYS2.cmake requires at least CMake ${Z_MSYS_CMAKE_REQUIRED_MINIMUM_VERSION}.")
endif()
cmake_policy(PUSH)
cmake_policy(VERSION 3.7.2)

# message("Reading MSYS.cmake from ${CMAKE_CURRENT_LIST_LINE}")

# set(TOOLCHAIN_LIST)
# list(APPEND TOOLCHAIN_LIST "x86_64-pc-windows-msys") # (usr)
# list(APPEND TOOLCHAIN_LIST "x86_64-w64-windows-gnu") # (clang64)
# list(APPEND TOOLCHAIN_LIST "i686-w64-mingw32") # (opt)
# list(APPEND TOOLCHAIN_LIST "x86_64-w64-mingw32") # (opt)
# list(APPEND TOOLCHAIN_LIST "x86_64-pc-msys") # (usr)
# list(APPEND TOOLCHAIN_LIST "x86_64-w64-mingw32") # (mingw64)
# list(APPEND TOOLCHAIN_LIST "x86_64-w64-mingw32") # (ucrt64)

# Prevents multiple inclusions...
if(MSYS_TOOLCHAIN)
    # message("Leaving MSYS.cmake at ${CMAKE_CURRENT_LIST_LINE}")
    cmake_policy(POP)
    return()
endif()

include(CMakeDependentOption)

if(DEFINED MSYSTEM)
    set(MSYSTEM "${MSYSTEM}" CACHE STRING "<MSYSTEM>" FORCE)
endif()

# MSYS toolchain options.
if(DEFINED ENV{VERBOSE})
    set(MSYS_VERBOSE ON)
endif()
option(MSYS_VERBOSE "Enables messages from the MSYS toolchain for debugging purposes." ON)
mark_as_advanced(MSYS_VERBOSE)

message(STATUS "Msys2 Build system loading...")

if(MSYS_VERBOSE)
    set(CMAKE_VERBOSE_MAKEFILE ON CACHE BOOL "Enable verbose output from Makefile builds." FORCE)
endif()

option(MSYS_APPLOCAL_DEPS "Automatically copy dependencies into the output directory for executables." ON)
option(X_MSYS_APPLOCAL_DEPS_INSTALL "(experimental) Automatically copy dependencies into the install target directory for executables. Requires CMake 3.14." OFF)
option(X_MSYS_APPLOCAL_DEPS_SERIALIZED "(experimental) Add USES_TERMINAL to MSYS_APPLOCAL_DEPS to force serialization." OFF)
option(MSYS_PREFER_SYSTEM_LIBS "Appends the msys paths to CMAKE_PREFIX_PATH, CMAKE_LIBRARY_PATH and CMAKE_FIND_ROOT_PATH so that <MSYSTEM> libraries/packages are found after MSYS2 libraries/packages." OFF)
# if(MSYS_PREFER_SYSTEM_LIBS)
#     message(WARNING "MSYS_PREFER_SYSTEM_LIBS has been deprecated. Use empty overlay ports instead.")
# endif()

# CMake helper utilities

#[===[.md:
# z_msys_function_arguments

Get a list of the arguments which were passed in.
Unlike `ARGV`, which is simply the arguments joined with `;`,
so that `(A B)` is not distinguishable from `("A;B")`,
this macro gives `"A;B"` for the first argument list,
and `"A\;B"` for the second.

```cmake
z_msys_function_arguments(<out-var> [<N>])
```

`z_msys_function_arguments` gets the arguments between `ARGV<N>` and the last argument.
`<N>` defaults to `0`, so that all arguments are taken.

## Example:
```cmake
function(foo_replacement)
    z_msys_function_arguments(ARGS)
    foo(${ARGS})
    ...
endfunction()
```
#]===]

# NOTE: this function definition is copied directly from vcpkg's 'scripts/cmake/z_vcpkg_function_arguments.cmake' :)
macro(z_msys_function_arguments OUT_VAR)

    if("${ARGC}" EQUAL "1")
        set(z_msys_function_arguments_FIRST_ARG "0")
    elseif("${ARGC}" EQUAL "2")
        set(z_msys_function_arguments_FIRST_ARG "${ARGV1}")
    else()
        # bug
        message(FATAL_ERROR "z_msys_function_arguments: invalid arguments (${ARGV})")
    endif()

    set("${OUT_VAR}" "")

    # this allows us to get the value of the enclosing function's ARGC
    set(z_msys_function_arguments_ARGC_NAME "ARGC")
    set(z_msys_function_arguments_ARGC "${${z_msys_function_arguments_ARGC_NAME}}")

    math(EXPR z_msys_function_arguments_LAST_ARG "${z_msys_function_arguments_ARGC} - 1")
    if(z_msys_function_arguments_LAST_ARG GREATER_EQUAL z_msys_function_arguments_FIRST_ARG)
        foreach(z_msys_function_arguments_N RANGE "${z_msys_function_arguments_FIRST_ARG}" "${z_msys_function_arguments_LAST_ARG}")
            string(REPLACE ";" "\\;" z_msys_function_arguments_ESCAPED_ARG "${ARGV${z_msys_function_arguments_N}}")
            # adds an extra `;` on the first time through
            set("${OUT_VAR}" "${${OUT_VAR}};${z_msys_function_arguments_ESCAPED_ARG}")
        endforeach()
        # remove leading `;`
        string(SUBSTRING "${${OUT_VAR}}" "1" "-1" "${OUT_VAR}")
    endif()
endmacro()

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

macro(z_msys_find_toolchains_dir)
    # Detect MINGW64.cmake to figure MSYS_TOOLCHAINS_ROOT_DIR
    set(Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
    while(NOT DEFINED Z_MSYS_TOOLCHAINS_ROOT_DIR)
        if(EXISTS "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}/MINGW64.cmake")
            set(Z_MSYS_TOOLCHAINS_ROOT_DIR "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}/toolchains" CACHE INTERNAL "msys root directory")
        elseif(EXISTS "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}/toolchains/MINGW64.cmake")
            set(Z_MSYS_TOOLCHAINS_ROOT_DIR "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}/toolchains" CACHE INTERNAL "msys root directory")
        elseif(IS_DIRECTORY "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}")
            get_filename_component(Z_MSYS_TOOLCHAINS_ROOT_DIR "${Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE}" DIRECTORY)
            if(Z_MSYS_TOOLCHAINS_ROOT_DIR STREQUAL Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE)
                z_msys_add_fatal_error("Unable to determine default chainload toolchain files directory!")
                break() # If unchanged, we have reached the root of the drive without finding 'MINGW64.cmake'.
            endif()
            set(Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE "${Z_MSYS_TOOLCHAINS_ROOT_DIR}")
            unset(Z_MSYS_TOOLCHAINS_ROOT_DIR)
        else()
            break()
        endif()
    endwhile()
    unset(Z_MSYS_TOOLCHAINS_ROOT_DIR_CANDIDATE)
endmacro()

# Determine whether the toolchain is loaded during a try-compile configuration
get_property(Z_MSYS_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

# Tricky default selection business!
# we actually need this var to vacate to avoid multiple inclusion.
# When the var clears on a re-run and lands on a fall-through value, we
# end up including this file without the intention of doing so.
# Honestly, this is probably best handled on the CLI/invocation...
if(MSYS_CHAINLOAD_TOOLCHAIN_FILE)
    include("${MSYS_CHAINLOAD_TOOLCHAIN_FILE}")
    unset(MSYS_CHAINLOAD_TOOLCHAIN_FILE)
elseif(DEFINED Z_MSYS_CHAINLOAD_TOOLCHAIN_FILE)
    set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${Z_MSYS_CHAINLOAD_TOOLCHAIN_FILE}")
    include("${MSYS_CHAINLOAD_TOOLCHAIN_FILE}")
    unset(MSYS_CHAINLOAD_TOOLCHAIN_FILE)
elseif(DEFINED MSYSTEM)
    z_msys_find_toolchains_dir()
    set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${Z_MSYS_TOOLCHAINS_ROOT_DIR}/${MSYSTEM}.cmake")
    include("${MSYS_CHAINLOAD_TOOLCHAIN_FILE}")
    unset(MSYS_CHAINLOAD_TOOLCHAIN_FILE)
else()
    unset(MSYS_CHAINLOAD_TOOLCHAIN_FILE)
endif()

if(MSYS_TOOLCHAIN)
    # message("Leaving MSYS.cmake at ${CMAKE_CURRENT_LIST_LINE}")
    cmake_policy(POP)
    return()
endif()

option(ENABLE_IMPORTED_CONFIGS "If CMake does not have a mapping for MinSizeRel and RelWithDebInfo in imported targets it will map those configuration to the first valid configuration in <CMAKE_CONFIGURATION_TYPES> or the targets <IMPORTED_CONFIGURATIONS> (in most cases this is the debug configuration which is wrong)." OFF)
    if(ENABLE_IMPORTED_CONFIGS)
    # If CMake does not have a mapping for MinSizeRel and RelWithDebInfo in imported targets
    # it will map those configuration to the first valid configuration in CMAKE_CONFIGURATION_TYPES or the targets IMPORTED_CONFIGURATIONS.
    # In most cases this is the debug configuration which is wrong.
    if(NOT DEFINED CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL)
        set(CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL "MinSizeRel;Release;")
        if(MSYS_VERBOSE)
            message(STATUS "CMAKE_MAP_IMPORTED_CONFIG_MINSIZEREL set to MinSizeRel;Release;")
        endif()
    endif()
    if(NOT DEFINED CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO)
        set(CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO "RelWithDebInfo;Release;")
        if(MSYS_VERBOSE)
            message(STATUS "CMAKE_MAP_IMPORTED_CONFIG_RELWITHDEBINFO set to RelWithDebInfo;Release;")
        endif()
    endif()
endif()

if(MSYS_TARGET_TRIPLET)

    # This is required since a user might do: 'set(MSYS_TARGET_TRIPLET somevalue)' [no CACHE] before the first project() call
    # Latter within the toolchain file we do: 'set(MSYS_TARGET_TRIPLET somevalue CACHE STRING "")' which
    # will otherwise override the user setting of MSYS_TARGET_TRIPLET in the current scope of the toolchain since the CACHE value
    # did not exist previously. Since the value is newly created CMake will use the CACHE value within this scope since it is the more
    # recently created value in directory scope. This 'strange' behaviour only happens on the very first configure call since subsequent
    # configure call will see the user value as the more recent value. The same logic must be applied to all cache values within this file!
    # The FORCE keyword is required to ALWAYS lift the user provided/previously set value into a CACHE value.
    set(MSYS_TARGET_TRIPLET "${MSYS_TARGET_TRIPLET}" CACHE STRING "msys2 target triplet (ex. x86_64-msys-pc)" FORCE)

elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Ww][Ii][Nn]32$")
    set(Z_MSYS_TARGET_TRIPLET_ARCH x86)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Xx]64$")
    set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Aa][Rr][Mm]$")
    set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
elseif(CMAKE_GENERATOR_PLATFORM MATCHES "^[Aa][Rr][Mm]64$")
    set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
else()

    if(CMAKE_GENERATOR STREQUAL "Visual Studio 14 2015 Win64")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 14 2015 ARM")
        set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 14 2015")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x86)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 15 2017 Win64")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 15 2017 ARM")
        set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 15 2017")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x86)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 16 2019" AND CMAKE_VS_PLATFORM_NAME_DEFAULT STREQUAL "ARM64")
        set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 16 2019")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 17 2022" AND CMAKE_VS_PLATFORM_NAME_DEFAULT STREQUAL "ARM64")
        set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
    elseif(CMAKE_GENERATOR STREQUAL "Visual Studio 17 2022")
        set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
    else()

        find_program(Z_MSYS_CL cl)

        if(Z_MSYS_CL MATCHES "amd64/cl.exe$" OR Z_MSYS_CL MATCHES "x64/cl.exe$")
            set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
        elseif(Z_MSYS_CL MATCHES "arm/cl.exe$")
            set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
        elseif(Z_MSYS_CL MATCHES "arm64/cl.exe$")
            set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
        elseif(Z_MSYS_CL MATCHES "bin/cl.exe$" OR Z_MSYS_CL MATCHES "x86/cl.exe$")
            set(Z_MSYS_TARGET_TRIPLET_ARCH x86)

        elseif(CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin" AND DEFINED CMAKE_SYSTEM_NAME AND NOT CMAKE_SYSTEM_NAME STREQUAL "Darwin")
            list(LENGTH CMAKE_OSX_ARCHITECTURES Z_MSYS_OSX_ARCH_COUNT)
            if(Z_MSYS_OSX_ARCH_COUNT EQUAL "0")
                # message(WARNING "Unable to determine target architecture. "
                #                 "Consider providing a value for the CMAKE_OSX_ARCHITECTURES cache variable. "
                #                 "Continuing without msys.")
                z_msys_add_fatal_error("Unable to determine target architecture")
                set(MSYS_TOOLCHAIN ON)
                # message("Leaving MSYS.cmake at ${CMAKE_CURRENT_LIST_LINE}")
                cmake_policy(POP)
                return()
            endif()
            if(Z_MSYS_OSX_ARCH_COUNT GREATER "1")
                message(WARNING "Detected more than one target architecture. Using the first one.")
            endif()
            list(GET CMAKE_OSX_ARCHITECTURES "0" Z_MSYS_OSX_TARGET_ARCH)
            if(Z_MSYS_OSX_TARGET_ARCH STREQUAL "arm64")
                set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
            elseif(Z_MSYS_OSX_TARGET_ARCH STREQUAL "arm64s")
                set(Z_MSYS_TARGET_TRIPLET_ARCH arm64s)
            elseif(Z_MSYS_OSX_TARGET_ARCH STREQUAL "armv7s")
                set(Z_MSYS_TARGET_TRIPLET_ARCH armv7s)
            elseif(Z_MSYS_OSX_TARGET_ARCH STREQUAL "armv7")
                set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
            elseif(Z_MSYS_OSX_TARGET_ARCH STREQUAL "x86_64")
                set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
            elseif(Z_MSYS_OSX_TARGET_ARCH STREQUAL "i386")
                set(Z_MSYS_TARGET_TRIPLET_ARCH x86)
            else()
                # message(WARNING "Unable to determine target architecture, continuing without msys.")
                z_msys_add_fatal_error("Unable to determine target architecture")
                set(MSYS_TOOLCHAIN ON)
                # message("Leaving MSYS.cmake at ${CMAKE_CURRENT_LIST_LINE}")
                cmake_policy(POP)
                return()
            endif()
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "x86_64" OR
               CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "AMD64" OR
               CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "amd64")
            set(Z_MSYS_TARGET_TRIPLET_ARCH x64)
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "s390x")
            set(Z_MSYS_TARGET_TRIPLET_ARCH s390x)
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "ppc64le")
            set(Z_MSYS_TARGET_TRIPLET_ARCH ppc64le)
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "armv7l")
            set(Z_MSYS_TARGET_TRIPLET_ARCH arm)
        elseif(CMAKE_HOST_SYSTEM_PROCESSOR MATCHES "^(aarch64|arm64|ARM64)$")
            set(Z_MSYS_TARGET_TRIPLET_ARCH arm64)
	elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "riscv32")
	    set(Z_MSYS_TARGET_TRIPLET_ARCH riscv32)
	elseif(CMAKE_HOST_SYSTEM_PROCESSOR STREQUAL "riscv64")
	    set(Z_MSYS_TARGET_TRIPLET_ARCH riscv64)
        else()
            if(Z_MSYS_CMAKE_IN_TRY_COMPILE)
                message(STATUS "Unable to determine target architecture, continuing without msys.")
            else()
                #message(WARNING "Unable to determine target architecture, continuing without msys.")
                z_msys_add_fatal_error("Unable to determine target architecture")
            endif()
            set(MSYS_TOOLCHAIN ON)
            # message("Leaving MSYS.cmake at ${CMAKE_CURRENT_LIST_LINE}")
            cmake_policy(POP)
            return()
        endif()
    endif()
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" OR CMAKE_SYSTEM_NAME STREQUAL "WindowsPhone")
    set(Z_MSYS_TARGET_TRIPLET_PLAT uwp)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux" OR (NOT CMAKE_SYSTEM_NAME AND CMAKE_HOST_SYSTEM_NAME STREQUAL "Linux"))
    set(Z_MSYS_TARGET_TRIPLET_PLAT linux)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin" OR (NOT CMAKE_SYSTEM_NAME AND CMAKE_HOST_SYSTEM_NAME STREQUAL "Darwin"))
    set(Z_MSYS_TARGET_TRIPLET_PLAT osx)
elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS")
    set(Z_MSYS_TARGET_TRIPLET_PLAT ios)
elseif(MINGW)
    set(Z_MSYS_TARGET_TRIPLET_PLAT mingw-dynamic)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Windows" OR (NOT CMAKE_SYSTEM_NAME AND CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows"))
    if(XBOX_CONSOLE_TARGET STREQUAL "scarlett")
        set(Z_MSYS_TARGET_TRIPLET_PLAT xbox-scarlett)
    elseif(XBOX_CONSOLE_TARGET STREQUAL "xboxone")
        set(Z_MSYS_TARGET_TRIPLET_PLAT xbox-xboxone)
    else()
        set(Z_MSYS_TARGET_TRIPLET_PLAT windows)
    endif()
elseif(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD" OR (NOT CMAKE_SYSTEM_NAME AND CMAKE_HOST_SYSTEM_NAME STREQUAL "FreeBSD"))
    set(Z_MSYS_TARGET_TRIPLET_PLAT freebsd)
endif()

if(EMSCRIPTEN)
    set(Z_MSYS_TARGET_TRIPLET_ARCH wasm32)
    set(Z_MSYS_TARGET_TRIPLET_PLAT emscripten)
endif()

set(MSYS_TARGET_TRIPLET "${Z_MSYS_TARGET_TRIPLET_ARCH}-${Z_MSYS_TARGET_TRIPLET_PLAT}" CACHE STRING "Msys target triplet (ex. x86-windows)" FORCE)
set(Z_MSYS_TOOLCHAIN_DIR "${CMAKE_CURRENT_LIST_DIR}")

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
    z_msys_add_fatal_error("Could not find '/msys2.ini'")
endif()

if(DEFINED MSYS_INSTALLED_DIR)
    set(Z_MSYS_INSTALLED_DIR_INITIAL_VALUE "${MSYS_INSTALLED_DIR}")
elseif(DEFINED _MSYS_INSTALLED_DIR)
    set(Z_MSYS_INSTALLED_DIR_INITIAL_VALUE "${_MSYS_INSTALLED_DIR}")
# elseif(MSYS_MANIFEST_MODE)
#     set(Z_MSYS_INSTALLED_DIR_INITIAL_VALUE "${CMAKE_BINARY_DIR}/msys_installed")
else()
    set(Z_MSYS_INSTALLED_DIR_INITIAL_VALUE "${Z_MSYS_ROOT_DIR}/usr/local")
endif()

set(MSYS_INSTALLED_DIR "${Z_MSYS_INSTALLED_DIR_INITIAL_VALUE}" CACHE PATH "The directory which contains the installed libraries for each triplet" FORCE)
set(_MSYS_INSTALLED_DIR "${MSYS_INSTALLED_DIR}" CACHE PATH "The directory which contains the installed libraries for each triplet" FORCE)

function(z_msys_add_msys_to_cmake_path list suffix)
    set(msys_paths
        "${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}${suffix}"
        "${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}/debug${suffix}"
    )
    if(NOT DEFINED CMAKE_BUILD_TYPE OR CMAKE_BUILD_TYPE MATCHES "^[Dd][Ee][Bb][Uu][Gg]$")
        list(REVERSE msys_paths) # Debug build: Put Debug paths before Release paths.
    endif()
    if(MSYS_PREFER_SYSTEM_LIBS)
        list(APPEND "${list}" "${msys_paths}")
    else()
        list(INSERT "${list}" "0" "${msys_paths}") # CMake 3.15 is required for list(PREPEND ...).
    endif()
    set("${list}" "${${list}}" PARENT_SCOPE)
endfunction()
# z_msys_add_msys_to_cmake_path(CMAKE_PREFIX_PATH "")
# z_msys_add_msys_to_cmake_path(CMAKE_LIBRARY_PATH "/lib/manual-link")
# z_msys_add_msys_to_cmake_path(CMAKE_FIND_ROOT_PATH "")

if(NOT MSYS_PREFER_SYSTEM_LIBS)
    set(CMAKE_FIND_FRAMEWORK "LAST") # we assume that frameworks are usually system-wide libs, not msys-built
    set(CMAKE_FIND_APPBUNDLE "LAST") # we assume that appbundles are usually system-wide libs, not msys-built
endif()

# If one CMAKE_FIND_ROOT_PATH_MODE_* variables is set to ONLY, to  make sure that ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}
# and ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET}/debug are searched, it is not sufficient to just add them to CMAKE_FIND_ROOT_PATH,
# as CMAKE_FIND_ROOT_PATH specify "one or more directories to be prepended to all other search directories", so to make sure that
# the libraries are searched as they are, it is necessary to add "/" to the CMAKE_PREFIX_PATH
if(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_LIBRARY STREQUAL "ONLY" OR
    CMAKE_FIND_ROOT_PATH_MODE_PACKAGE STREQUAL "ONLY")
    list(APPEND CMAKE_PREFIX_PATH "${Z_MSYS_ROOT_DIR}/")
endif()

set(MSYS_CMAKE_FIND_ROOT_PATH "${CMAKE_FIND_ROOT_PATH}" CACHE PATH "" STRING)

# CMAKE_EXECUTABLE_SUFFIX is not yet defined
if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(Z_MSYS_EXECUTABLE "${Z_MSYS_ROOT_DIR}/msys2.exe")
    set(Z_MSYS_BOOTSTRAP_SCRIPT "${Z_VCPKG_ROOT_DIR}/autorebase.bat")
else()
    set(Z_MSYS_EXECUTABLE "${Z_MSYS_ROOT_DIR}/msys2")
    set(Z_MSYS_BOOTSTRAP_SCRIPT "${Z_VCPKG_ROOT_DIR}/autorebase")
endif()

option(MSYS_SETUP_CMAKE_PROGRAM_PATH  "Enable the setup of CMAKE_PROGRAM_PATH to msys paths" OFF)
set(MSYS_CAN_USE_HOST_TOOLS OFF)
if(DEFINED MSYS_HOST_TRIPLET AND NOT MSYS_HOST_TRIPLET STREQUAL "")
    set(MSYS_CAN_USE_HOST_TOOLS ON)
endif()
cmake_dependent_option(MSYS_USE_HOST_TOOLS "Setup CMAKE_PROGRAM_PATH to use host tools" ON "MSYS_CAN_USE_HOST_TOOLS" OFF)
unset(MSYS_CAN_USE_HOST_TOOLS)

if(MSYS_SETUP_CMAKE_PROGRAM_PATH)
    set(tools_base_path "${MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}/tools")
    if(MSYS_USE_HOST_TOOLS)
        set(tools_base_path "${MSYS_INSTALLED_DIR}/${MSYS_HOST_TRIPLET}/tools")
    endif()
    list(APPEND CMAKE_PROGRAM_PATH "${tools_base_path}")
    file(GLOB Z_MSYS_TOOLS_DIRS LIST_DIRECTORIES true "${tools_base_path}/*")
    file(GLOB Z_MSYS_TOOLS_FILES LIST_DIRECTORIES false "${tools_base_path}/*")
    file(GLOB Z_MSYS_TOOLS_DIRS_BIN LIST_DIRECTORIES true "${tools_base_path}/*/bin")
    file(GLOB Z_MSYS_TOOLS_FILES_BIN LIST_DIRECTORIES false "${tools_base_path}/*/bin")
    list(REMOVE_ITEM Z_MSYS_TOOLS_DIRS ${Z_MSYS_TOOLS_FILES} "") # need at least one item for REMOVE_ITEM if CMake <= 3.19
    list(REMOVE_ITEM Z_MSYS_TOOLS_DIRS_BIN ${Z_MSYS_TOOLS_FILES_BIN} "")
    string(REPLACE "/bin" "" Z_MSYS_TOOLS_DIRS_TO_REMOVE "${Z_MSYS_TOOLS_DIRS_BIN}")
    list(REMOVE_ITEM Z_MSYS_TOOLS_DIRS ${Z_MSYS_TOOLS_DIRS_TO_REMOVE} "")
    list(APPEND Z_MSYS_TOOLS_DIRS ${Z_MSYS_TOOLS_DIRS_BIN})
    foreach(Z_MSYS_TOOLS_DIR IN LISTS Z_MSYS_TOOLS_DIRS)
        list(APPEND CMAKE_PROGRAM_PATH "${Z_MSYS_TOOLS_DIR}")
    endforeach()
    unset(Z_MSYS_TOOLS_DIR)
    unset(Z_MSYS_TOOLS_DIRS)
    unset(Z_MSYS_TOOLS_FILES)
    unset(Z_MSYS_TOOLS_DIRS_BIN)
    unset(Z_MSYS_TOOLS_FILES_BIN)
    unset(Z_MSYS_TOOLS_DIRS_TO_REMOVE)
    unset(tools_base_path)
endif()

message(STATUS "Msys2 Build system loaded")

cmake_policy(POP)

##-- Any policies applied to the below macros and functions appear to leak into consumers

function(add_executable)

    z_msys_function_arguments(ARGS)
    _add_executable(${ARGS})
    set(target_name "${ARGV0}")

    # if(MSYS_VERBOSE)
    #     message(STATUS "${PROJECT_NAME}: Calling ${CMAKE_CURRENT_FUNCTION}(${target_name})")
    # endif()

    list(FIND ARGV "IMPORTED" IMPORTED_IDX)
    list(FIND ARGV "ALIAS" ALIAS_IDX)
    list(FIND ARGV "MACOSX_BUNDLE" MACOSX_BUNDLE_IDX)
    if(IMPORTED_IDX EQUAL "-1" AND ALIAS_IDX EQUAL "-1")
        if(MSYS_APPLOCAL_DEPS)
            if(Z_MSYS_TARGET_TRIPLET_PLAT MATCHES "windows|uwp|xbox")
                z_msys_set_powershell_path()
                set(EXTRA_OPTIONS "")
                if(X_MSYS_APPLOCAL_DEPS_SERIALIZED)
                    set(EXTRA_OPTIONS USES_TERMINAL)
                endif()
                add_custom_command(TARGET "${target_name}" POST_BUILD
                    COMMAND "${Z_MSYS_POWERSHELL_PATH}" -noprofile -executionpolicy Bypass -file "${Z_MSYS_TOOLCHAIN_DIR}/msbuild/applocal.ps1"
                        -targetBinary "$<TARGET_FILE:${target_name}>"
                        -installedDir "${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}$<$<CONFIG:Debug>:/debug>/bin"
                        -OutVariable out
                    VERBATIM
                    ${EXTRA_OPTIONS}
                )
            elseif(Z_MSYS_TARGET_TRIPLET_PLAT MATCHES "osx")
                if(NOT MACOSX_BUNDLE_IDX EQUAL "-1")
                    find_package(Python COMPONENTS Interpreter)
                    add_custom_command(TARGET "${target_name}" POST_BUILD
                        COMMAND "${Python_EXECUTABLE}" "${Z_MSYS_TOOLCHAIN_DIR}/osx/applocal.py"
                            "$<TARGET_FILE:${target_name}>"
                            "${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}$<$<CONFIG:Debug>:/debug>"
                        VERBATIM
                    )
                endif()
            endif()
        endif()
        set_target_properties("${target_name}" PROPERTIES VS_USER_PROPS do_not_import_user.props)
        set_target_properties("${target_name}" PROPERTIES VS_GLOBAL_MsysEnabled false)
    endif()
endfunction()

function(add_library)
    z_msys_function_arguments(ARGS)
    _add_library(${ARGS})
    set(target_name "${ARGV0}")

    # if(MSYS_VERBOSE)
    #     message(STATUS "${PROJECT_NAME}: Calling ${CMAKE_CURRENT_FUNCTION}(${target_name})")
    # endif()

    list(FIND ARGS "IMPORTED" IMPORTED_IDX)
    list(FIND ARGS "INTERFACE" INTERFACE_IDX)
    list(FIND ARGS "ALIAS" ALIAS_IDX)
    if(IMPORTED_IDX EQUAL "-1" AND INTERFACE_IDX EQUAL "-1" AND ALIAS_IDX EQUAL "-1")
        get_target_property(IS_LIBRARY_SHARED "${target_name}" TYPE)
        if(MSYS_APPLOCAL_DEPS AND Z_MSYS_TARGET_TRIPLET_PLAT MATCHES "windows|uwp|xbox" AND (IS_LIBRARY_SHARED STREQUAL "SHARED_LIBRARY" OR IS_LIBRARY_SHARED STREQUAL "MODULE_LIBRARY"))
            z_msys_set_powershell_path()
            add_custom_command(TARGET "${target_name}" POST_BUILD
                COMMAND "${Z_MSYS_POWERSHELL_PATH}" -noprofile -executionpolicy Bypass -file "${Z_MSYS_TOOLCHAIN_DIR}/msbuild/applocal.ps1"
                    -targetBinary "$<TARGET_FILE:${target_name}>"
                    -installedDir "${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}$<$<CONFIG:Debug>:/debug>/bin"
                    -OutVariable out
                    VERBATIM
            )
        endif()
        set_target_properties("${target_name}" PROPERTIES VS_USER_PROPS do_not_import_user.props)
        set_target_properties("${target_name}" PROPERTIES VS_GLOBAL_MsysEnabled false)
    endif()
endfunction()

# This is an experimental function to enable applocal install of dependencies as part of the `make install` process
# Arguments:
#   TARGETS - a list of installed targets to have dependencies copied for
#   DESTINATION - the runtime directory for those targets (usually `bin`)
#   COMPONENT - the component this install command belongs to (optional)
#
# Note that this function requires CMake 3.14 for policy CMP0087
function(x_msys_install_local_dependencies)

    if(CMAKE_VERSION VERSION_LESS "3.14")
        message(FATAL_ERROR "x_msys_install_local_dependencies and X_MSYS_APPLOCAL_DEPS_INSTALL require at least CMake 3.14 (current version: ${CMAKE_VERSION})")
    endif()

    cmake_parse_arguments(PARSE_ARGV "0" arg
        ""
        "DESTINATION;COMPONENT"
        "TARGETS"
    )
    if(DEFINED arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was passed extra arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED arg_DESTINATION)
        message(FATAL_ERROR "DESTINATION must be specified")
    endif()

    if(MSYS_VERBOSE)
        message(STATUS "${PROJECT_NAME}: Calling ${CMAKE_CURRENT_FUNCTION}(${target_name})")
    endif()

    if(Z_MSYS_TARGET_TRIPLET_PLAT MATCHES "^(windows|uwp|xbox-.*)$")
        # Install CODE|SCRIPT allow the use of generator expressions
        cmake_policy(SET CMP0087 NEW) # CMake 3.14

        z_msys_set_powershell_path()
        if(NOT IS_ABSOLUTE "${arg_DESTINATION}")
            set(arg_DESTINATION "\${CMAKE_INSTALL_PREFIX}/${arg_DESTINATION}")
        endif()

        set(component_param "")
        if(DEFINED arg_COMPONENT)
            set(component_param COMPONENT "${arg_COMPONENT}")
        endif()

        foreach(target IN LISTS arg_TARGETS)
            get_target_property(target_type "${target}" TYPE)
            if(NOT target_type STREQUAL "INTERFACE_LIBRARY")
                install(CODE "message(\"-- Installing app dependencies for ${target}...\")
                    execute_process(COMMAND \"${Z_MSYS_POWERSHELL_PATH}\" -noprofile -executionpolicy Bypass -file \"${Z_MSYS_TOOLCHAIN_DIR}/msbuild/applocal.ps1\"
                        -targetBinary \"${arg_DESTINATION}/$<TARGET_FILE_NAME:${target}>\"
                        -installedDir \"${_MSYS_INSTALLED_DIR}/${MSYS_TARGET_TRIPLET}$<$<CONFIG:Debug>:/debug>/bin\"
                        -OutVariable out)"
                    ${component_param}
                )
            endif()
        endforeach()
    endif()
endfunction()

if(X_MSYS_APPLOCAL_DEPS_INSTALL)
    function(install)
        z_msys_function_arguments(ARGS)
        _install(${ARGS})
        if(MSYS_VERBOSE)
            message(STATUS "${PROJECT_NAME}: Calling ${CMAKE_CURRENT_FUNCTION}(${target_name})")
        endif()

        if(ARGV0 STREQUAL "TARGETS")
            # Will contain the list of targets
            set(parsed_targets "")

            # Destination - [RUNTIME] DESTINATION argument overrides this
            set(destination "bin")

            set(component_param "")

            # Parse arguments given to the install function to find targets and (runtime) destination
            set(modifier "") # Modifier for the command in the argument
            set(last_command "") # Last command we found to process
            foreach(arg IN LISTS ARGS)
                if(arg MATCHES "^(ARCHIVE|LIBRARY|RUNTIME|OBJECTS|FRAMEWORK|BUNDLE|PRIVATE_HEADER|PUBLIC_HEADER|RESOURCE|INCLUDES)$")
                    set(modifier "${arg}")
                    continue()
                endif()
                if(arg MATCHES "^(TARGETS|DESTINATION|PERMISSIONS|CONFIGURATIONS|COMPONENT|NAMELINK_COMPONENT|OPTIONAL|EXCLUDE_FROM_ALL|NAMELINK_ONLY|NAMELINK_SKIP|EXPORT)$")
                    set(last_command "${arg}")
                    continue()
                endif()

                if(last_command STREQUAL "TARGETS")
                    list(APPEND parsed_targets "${arg}")
                endif()

                if(last_command STREQUAL "DESTINATION" AND (modifier STREQUAL "" OR modifier STREQUAL "RUNTIME"))
                    set(destination "${arg}")
                endif()
                if(last_command STREQUAL "COMPONENT")
                    set(component_param "COMPONENT" "${arg}")
                endif()
            endforeach()

            x_msys_install_local_dependencies(
                TARGETS ${parsed_targets}
                DESTINATION "${destination}"
                ${component_param}
            )
        endif()
    endfunction()
endif()

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

# option(ENABLE_DISTCC "Use the Distributed C/C++/ObjC compiler." OFF)
# option(ENABLE_COLOR "Colorize output messages." ON)
# option(ENABLE_CCACHE "Use ccache to cache compilation." OFF)
# option(ENABLE_CHECK "Run the check() function if present in the build." ON)
# option(ENABLE_SIGN "Generate PGP signature file." OFF)

# if(NOT DEFINED BUILDENV)
#     set(BUILDENV)
#     list(APPEND BUILDENV "!distcc" "color" "!ccache" "check" "!sign")
# endif()
# set(BUILDENV "${BUILDENV}" CACHE STRING "A negated environment option will do the opposite of the comments below." FORCE)

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


# Options handler...

# option(OPTION_DOCS "Save doc directories specified by <DOC_DIRS>." ON)
# option(OPTION_LIBTOOL "Leave libtool (.la) files in packages." OFF)
# option(OPTION_STATIC_LIBS "Leave static library (.a) files in packages." ON)
# option(OPTION_EMPTY_DIRS "Leave empty directories in packages." ON)
# option(OPTION_ZIPMAN "Compress manual (man and info) pages in <MAN_DIRS> with gzip." ON)
# option(OPTION_PURGE "Remove files specified by <PURGE_TARGETS>." ON)
# option(OPTION_DEBUG "Add debugging flags as specified in <DEBUG_*> variables." OFF)
# option(OPTION_LTO "Add compile flags for building with link time optimization." OFF)

# option(OPTION_STRIP "Strip symbols from binaries/libraries." ON)
# if(OPTION_STRIP)
#     set(OPTION_STRIP_FLAG strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
#     #-- Options to be used when stripping binaries. See `man strip' for details.
#     if(NOT DEFINED STRIP_BINARIES)
#         set(STRIP_BINARIES --strip-all CACHE STRING "Options to be used when stripping binaries. See `man strip' for details." FORCE)
#     endif()
# else()
#     set(OPTION_STRIP_FLAG !strip CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# # And so forth, or nah...?

# if(OPTION_DOCS)
#     set(OPTION_DOCS_FLAG docs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_DOCS_FLAG !docs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_LIBTOOL)
#     set(OPTION_LIBTOOL_FLAG libtool CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_LIBTOOL_FLAG !libtool CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_STATIC_LIBS)
#     set(OPTION_STATIC_LIBS_FLAG staticlibs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_STATIC_LIBS_FLAG !staticlibs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_EMPTY_DIRS)
#     set(OPTION_EMPTY_DIRS_FLAG emptydirs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_EMPTY_DIRS_FLAG !emptydirs CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_ZIPMAN)
#     set(OPTION_ZIPMAN_FLAG zipman CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_ZIPMAN_FLAG !zipman CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_PURGE)
#     set(OPTION_PURGE_FLAG purge CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_PURGE_FLAG !purge CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_DEBUG)
#     set(OPTION_DEBUG_FLAG debug CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_DEBUG_FLAG !debug CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(OPTION_LTO)
#     set(OPTION_LTO_FLAG lto CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# else()
#     set(OPTION_LTO_FLAG !lto CACHE STRING "A negated option will do the opposite of the comments below." FORCE)
# endif()

# if(NOT DEFINED OPTIONS)
#     set(OPTIONS "${OPTION_STRIP_FLAG} ${OPTION_DOCS_FLAG} ${OPTION_LIBTOOL_FLAG} ${OPTION_STATIC_LIBS_FLAG} ${OPTION_EMPTY_DIRS_FLAG} ${OPTION_ZIPMAN_FLAG} ${OPTION_PURGE_FLAG} ${OPTION_DEBUG_FLAG} ${OPTION_LTO_FLAG}")
# endif()
# set(OPTIONS "${OPTIONS}" CACHE STRING "These are the values for the CMake 'option()' settings." FORCE)

# # if(NOT DEFINED OPTIONS)
# #     set(OPTIONS "" CACHE STRING "")
# #     list(APPEND OPTIONS strip docs !libtool staticlibs emptydirs zipman purge !debug !lto)
# # endif()

# #-- File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512
# if(NOT DEFINED INTEGRITY_CHECK OR (INTEGRITY_CHECK STREQUAL ""))
#     set(INTEGRITY_CHECK sha256)
# endif()
# set(INTEGRITY_CHECK "${INTEGRITY_CHECK}" CACHE STRING "File integrity checks to use. Valid: md5, sha1, sha256, sha384, sha512" FORCE)

# #-- Options to be used when stripping shared libraries. See `man strip' for details.
# set(STRIP_SHARED --strip-unneeded CACHE STRING "Options to be used when stripping shared libraries. See `man strip' for details." FORCE)
# #-- Options to be used when stripping static libraries. See `man strip' for details.
# set(STRIP_STATIC --strip-debug CACHE STRING "Options to be used when stripping static libraries. See `man strip' for details." FORCE)

# #-- Manual (man and info) directories to compress (if zipman is specified)
# if(NOT DEFINED MAN_DIRS)
#     if(DEFINED MINGW_PREFIX)
#         set(MAN_DIRS "\"\${MINGW_PREFIX#/}\"{{,/local}{,/share},/opt/*}/{man,info}" CACHE STRING "Manual (man and info) directories to compress (if zipman is specified)" FORCE)
#     else()
#         set(MAN_DIRS "{{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info}" CACHE STRING "Manual (man and info) directories to compress (if zipman is specified)" FORCE)
#     endif()
# endif()
# #-- Doc directories to remove (if !docs is specified)
# if(NOT DEFINED DOC_DIRS)
#     if(DEFINED MINGW_PREFIX)
#         set(DOC_DIRS "\"\${MINGW_PREFIX#/}\"/{,local/}{,share/}{doc,gtk-doc}" CACHE STRING "Doc directories to remove (if !docs is specified)" FORCE)
#     else()
#         set(DOC_DIRS "{,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc}" CACHE STRING "Doc directories to remove (if !docs is specified)" FORCE)
#     endif()
# endif()
# #-- Files to be removed from all packages (if purge is specified)
# if(NOT DEFINED PURGE_TARGETS)
#     if(DEFINED MINGW_PREFIX)
#         set(PURGE_TARGETS "{,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod" CACHE STRING "Files to be removed from all packages (if purge is specified)" FORCE)
#     else()
#         set(PURGE_TARGETS "\"\${MINGW_PREFIX#/}\"/{,share}/info/dir .packlist *.pod" CACHE STRING "Files to be removed from all packages (if purge is specified)" FORCE)
#     endif()
# endif()


# #########################################################################
# # PACKAGE OUTPUT
# #########################################################################
# #
# # Default: put built package and cached source in build directory.
# #
# #########################################################################

# #-- Destination: specify a fixed directory where all packages will be placed
# if(NOT DEFINED PKGDEST)
#     set(PKGDEST "/var/packages-mingw64") # If not yet defined, set a default...
# endif() # ...then, write the resulting definition to the cache, with a description attached.
# set(PKGDEST "${PKGDEST}" CACHE PATH "Destination: specify a fixed directory where all packages will be placed." FORCE)

# #-- Source cache: specify a fixed directory where source files will be cached
# if(NOT DEFINED SRCDEST)
#     set(SRCDEST "/var/sources")
# endif()
# set(SRCDEST "${SRCDEST}" CACHE PATH "Source cache: specify a fixed directory where source files will be cached." FORCE)

# #-- Source packages: specify a fixed directory where all src packages will be placed
# if(NOT DEFINED SRCPKGDEST)
#     set(SRCPKGDEST "/var/srcpackages-mingw64")
# endif()
# set(SRCPKGDEST "${SRCPKGDEST}" CACHE PATH "Source packages: specify a fixed directory where all src packages will be placed" FORCE)

# #-- Log files: specify a fixed directory where all log files will be placed
# if(NOT DEFINED LOGDEST)
#     set(LOGDEST "/var/makepkglogs")
# endif()
# set(LOGDEST "${LOGDEST}" CACHE PATH "Log files: specify a fixed directory where all log files will be placed" FORCE)

# #########################################################################
# # EXTENSION DEFAULTS
# #########################################################################

# set(MSYS_PKGEXT ".pkg.tar.zst" CACHE STRING "File extension to use for packages." FORCE)
# set(MSYS_SRCEXT ".src.tar.zst" CACHE STRING "File extension to use for packages containing source code." FORCE)

# #########################################################################
# # OTHER
# #########################################################################

# #-- Command used to run pacman as root, instead of trying sudo and su
# if(NOT DEFINED PACMAN_AUTH)
#     set(PACMAN_AUTH "()")
# endif()
# set(PACMAN_AUTH "${PACMAN_AUTH}") # CACHE STRING "Command used to run pacman as root, instead of trying sudo and su" FORCE)

# #-- Packager: name/email of the person or organization building packages
# if(DEFINED PACKAGER)
#     set(PACKAGER "${PACKAGER}") # CACHE STRING "Packager: name/email of the person or organization building packages (optional)." FORCE)
# else()
#     set(PACKAGER "John Doe <john@doe.com>") # CACHE STRING "Packager: name/email of the person or organization building packages (Default)." FORCE)
# endif()

# if(ENABLE_SIGN)
#     #-- Specify a key to use for package signing
#     if(DEFINED GPGKEY)
#         set(GPGKEY "${GPGKEY}") # CACHE STRING "Specify a key to use for package signing (User-specified)." FORCE)
#     elseif(DEFINED ENV{GPGKEY})
#         set(GPGKEY "$ENV{GPGKEY}") # CACHE STRING "Specify a key to use for package signing (Environment-detected)." FORCE)
#     else()
#         set(GPGKEY "UNDEFINED") # CACHE STRING "Specify a key to use for package signing (Undefined)." FORCE)
#     endif()
# endif()


# include("${Z_MSYS_ROOT_DIR}/scripts/cmake/msys_compression_defaults.cmake")


#[===[.md

# Todo

#########################################################################
# NOTES
#########################################################################


elseif(MSYSTEM STREQUAL CLANG64)
    set(MSYSTEM_TITLE "MinGW Clang x64")
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

cmake_policy(PUSH)
cmake_policy(VERSION 3.7.2)

# message("Reading MSYS.cmake from ${CMAKE_CURRENT_LIST_LINE}")

set(MSYS_TOOLCHAIN ON)
set(Z_MSYS_UNUSED "${CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION}")
set(Z_MSYS_UNUSED "${CMAKE_EXPORT_NO_PACKAGE_REGISTRY}")
set(Z_MSYS_UNUSED "${CMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY}")
set(Z_MSYS_UNUSED "${CMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY}")
set(Z_MSYS_UNUSED "${CMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP}")

# Propogate these values to try-compile configurations so the triplet and toolchain load
if(NOT Z_MSYS_CMAKE_IN_TRY_COMPILE)
    list(APPEND CMAKE_TRY_COMPILE_PLATFORM_VARIABLES
        MSYS_TARGET_TRIPLET
        MSYS_TARGET_ARCHITECTURE
        MSYS_APPLOCAL_DEPS
        MSYS_CHAINLOAD_TOOLCHAIN_FILE
        Z_MSYS_ROOT_DIR
    )
endif()

if(Z_MSYS_HAS_FATAL_ERROR)
    message(FATAL_ERROR "MSYS_FATAL_ERROR = ${Z_MSYS_FATAL_ERROR}")
endif()

# message("Leaving MSYS.cmake from the bottom...")
cmake_policy(POP)
