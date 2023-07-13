# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

if(TRACE_MODE)
    message("Enter: ${CMAKE_CURRENT_LIST_FILE}")
endif()

if(NOT _MSYSTEM_MAKEFILE_GENERATOR)
set(_MSYSTEM_MAKEFILE_GENERATOR 1) # include guard

message(STATUS "Loading ${CONTITLE} Makefile generator...")

if(MINGW)

    find_program(MAKE "mingw32-make.exe"
    PATHS
    # # Typical install path for 64-bit MSYS2 MINGW64 toolchain (https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe)
    "${Z_${MSYSTEM}_ROOT_DIR}/bin"
    # "C:/msys64/mingw64/bin"
    # "/mingw64/bin"
    # "/c/msys64/mingw64/bin"
    REQUIRED
    DOC "Makefile generator."
)
    if(NOT MAKE)
        message(FATAL_ERROR "Getting ${Z_${MSYSTEM}_ROOT_DIR}/bin/mingw32-make.exe failed")
    endif()

elseif(MSYS)

    find_program(MAKE "make.exe"
    PATHS
    # # Typical install path for 64-bit MSYS2 MINGW64 toolchain (https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe)
    "${Z_MSYS_ROOT_DIR}/usr/bin"
    # "C:/msys64/mingw64/bin"
    # "/mingw64/bin"
    # "/c/msys64/mingw64/bin"
    REQUIRED
    DOC "Makefile generator."
)
    if(NOT MAKE)
        message(FATAL_ERROR "Getting ${Z_MSYS_ROOT_DIR}/usr/bin/make.exe failed")
    endif()
# else()
#     message(FATAL_ERROR "We shouldnt be here now")
endif()

if(MAKE)
    mark_as_advanced(MAKE)

    if(NOT DEFINED CMAKE_VERBOSE_MAKEFILE)
        set(CMAKE_VERBOSE_MAKEFILE FALSE CACHE BOOL "If this value is on, makefiles will be generated without the .SILENT directive, and all commands will be echoed to the console during the make.  This is useful for debugging only. With Visual Studio IDE projects all commands are done without /nologo.")
    endif()

    if(NOT DEFINED CMAKE_EXPORT_COMPILE_COMMANDS)
        set(CMAKE_EXPORT_COMPILE_COMMANDS "$ENV{CMAKE_EXPORT_COMPILE_COMMANDS}" CACHE BOOL "Enable/Disable output of compile commands during generation.")
        mark_as_advanced(CMAKE_EXPORT_COMPILE_COMMANDS)
    endif()

    if(NOT DEFINED CMAKE_COLOR_DIAGNOSTICS)
        if(DEFINED ENV{CMAKE_COLOR_DIAGNOSTICS} AND NOT DEFINED CACHE{CMAKE_COLOR_DIAGNOSTICS})
        set(CMAKE_COLOR_DIAGNOSTICS $ENV{CMAKE_COLOR_DIAGNOSTICS} CACHE BOOL "Enable colored diagnostics throughout.")
        endif()
    endif()

    if(NOT DEFINED CMAKE_COLOR_DIAGNOSTICS)
        set(CMAKE_COLOR_MAKEFILE ON CACHE BOOL "Enable/Disable color output during build.")
    endif()
    mark_as_advanced(CMAKE_COLOR_MAKEFILE)

    if(DEFINED CMAKE_RULE_MESSAGES)
        set_property(GLOBAL PROPERTY RULE_MESSAGES ${CMAKE_RULE_MESSAGES})
    endif()

    if(DEFINED CMAKE_TARGET_MESSAGES)
        set_property(GLOBAL PROPERTY TARGET_MESSAGES ${CMAKE_TARGET_MESSAGES})
    endif()


    # Try to find out how many CPUs we have and set the -j argument for make accordingly
    set(_MSYSTEM_MAKE_INITIAL_MAKE_ARGS "")

    include(ProcessorCount)
    processorcount(_MSYSTEM_MAKE_PROCESSOR_COUNT)

    #-- Make Flags: change this for DistCC/SMP systems
    if(NOT DEFINED MAKEFLAGS)
        set(MAKEFLAGS)
    endif()

    string(APPEND MAKEFLAGS "-j${_MSYSTEM_MAKE_PROCESSOR_COUNT} ")

    # Only set -j if we are under UNIX and if the make-tool used actually has "make" in the name
    # (we may also get here in the future e.g. for ninja)
    if("${_MSYSTEM_MAKE_PROCESSOR_COUNT}" GREATER 1)
        set(_MSYSTEM_MAKE_INITIAL_MAKE_ARGS "-j${_MSYSTEM_MAKE_PROCESSOR_COUNT}")
    endif()

    string(STRIP "${MAKEFLAGS}" MAKEFLAGS)
    set(MAKEFLAGS "${MAKEFLAGS}")
    set(ENV{MAKEFLAGS} "${MAKEFLAGS}")


    set(MAKE_COMMAND "${MAKE} ${MAKEFLAGS}")
    mark_as_advanced(MAKE_COMMAND)

    set(CMAKE_EXTRA_GENERATOR "${MAKE}")
    mark_as_advanced(CMAKE_EXTRA_GENERATOR)

    # Determine builtin macros and include dirs:
    include(CMakeExtraGeneratorDetermineCompilerMacrosAndIncludeDirs)

    # message(STATUS "Using makefile generator: ${MAKE}")
    message(STATUS "...loaded ${CONTITLE} Makefile generator.")
else()
    unset(MAKE)
    message(WARNING "Could not find GNU Make for ${CONTITLE} (${MSYSTEM})?")
endif()

endif(NOT _MSYSTEM_MAKEFILE_GENERATOR) # Include guard

if(TRACE_MODE)
    message("Exit: ${CMAKE_CURRENT_LIST_FILE}")
endif()
