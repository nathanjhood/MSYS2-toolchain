# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.


find_program(CMAKE_MAKE_PROGRAM mingw32-make
  REGISTRY_VIEW 64
  PATHS
      # Typical install path for 32-bit MSYS2 (https://repo.msys2.org/distrib/msys2-i686-latest.sfx.exe)
      "C:/msys64/mingw64/usr/bin"
      # Typical install path for MINGW32 (https://sourceforge.net/projects/mingw)
      "C:/mingw64/msys"
      # Git for Windows 32-bit (https://gitforwindows.org/)
      "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GitForWindows;InstallPath]/usr")

mark_as_advanced(CMAKE_MAKE_PROGRAM)
