# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# message(WARNING "ping")

# Try to find out how many CPUs we have and set the -j argument for make accordingly
set(_MSYSTEM_MAKE_INITIAL_MAKE_ARGS "")

include(ProcessorCount)
processorcount(_MSYSTEM_MAKE_PROCESSOR_COUNT)

# Only set -j if we are under UNIX and if the make-tool used actually has "make" in the name
# (we may also get here in the future e.g. for ninja)
if("${_MSYSTEM_MAKE_PROCESSOR_COUNT}" GREATER 1
    #AND  CMAKE_HOST_UNIX
    AND  "${CMAKE_MAKE_PROGRAM}" MATCHES make
    )
  set(_MSYSTEM_MAKE_INITIAL_MAKE_ARGS "-j${_MSYSTEM_MAKE_PROCESSOR_COUNT}")
endif()

#-- Make Flags: change this for DistCC/SMP systems
set(MAKEFLAGS "-j${_MSYSTEM_MAKE_PROCESSOR_COUNT}" CACHE STRING "" FORCE)

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
mark_as_advanced(MAKE)

set(MAKE_COMMAND "${MAKE} ${MAKEFLAGS}" CACHE STRING "" FORCE)
mark_as_advanced(MAKE_COMMAND)

set(CMAKE_EXTRA_GENERATOR "${MAKE}")
mark_as_advanced(CMAKE_EXTRA_GENERATOR)

# Determine builtin macros and include dirs:
include(CMakeExtraGeneratorDetermineCompilerMacrosAndIncludeDirs)
