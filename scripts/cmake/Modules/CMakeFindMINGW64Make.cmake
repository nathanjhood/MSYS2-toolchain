# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

message(WARNING "ping")

find_program(CMAKE_MAKE_PROGRAM "${Z_MINGW64_ROOT_DIR}/bin/mingw32-make.exe"
    # PATHS
    # # Typical install path for 64-bit MSYS2 MINGW64 toolchain (https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe)
    # "${Z_MINGW64_ROOT_DIR}/bin"
    # "C:/msys64/mingw64/bin"
    # "/mingw64/bin"
    # "/c/msys64/mingw64/bin"
    DOC "Makefile generator."
)

mark_as_advanced(CMAKE_MAKE_PROGRAM)
