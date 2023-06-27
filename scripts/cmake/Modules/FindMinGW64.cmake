# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindMsys
--------

.. versionadded:: 3.21

Find MSYS, a POSIX-compatible environment that runs natively
on Microsoft Windows
#]=======================================================================]

if (WIN32)
    if(MINGW64_INSTALL_PATH)
        set(MINGW64 "${MINGW64_INSTALL_PATH}/msys2_shell.cmd")
    endif()

    find_program(MINGW64_CMD
        NAMES msys2_shell.cmd
        PATHS
            # Typical install path for MSYS2 (https://repo.msys2.org/distrib/msys2-i686-latest.sfx.exe)
            "C:/msys32"
            # Typical install path for MSYS2 (https://repo.msys2.org/distrib/msys2-x86_64-latest.sfx.exe)
            "C:/msys64"
            # Git for Windows (https://gitforwindows.org/)
            "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GitForWindows;InstallPath]"
    )
    set(MINGW64_CMD "${MINGW64_CMD} -mingw64" CACHE STRING "Path to MinGW x64" FORCE)
    get_filename_component(MINGW64_INSTALL_PATH "${MINGW64_CMD}" DIRECTORY)
    mark_as_advanced(MINGW64_CMD)

endif ()
