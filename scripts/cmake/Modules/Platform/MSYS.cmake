# Source: cmake/Modules/Platform/MSYS.cmake
set(MSYS 1)
# include(Platform/CYGWIN)
# Source: cmake/Modules/Platform/CYGWIN.cmake
set(CYGWIN 1)
set(CMAKE_SHARED_LIBRARY_PREFIX "cyg")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
set(CMAKE_SHARED_MODULE_PREFIX "cyg")
set(CMAKE_SHARED_MODULE_SUFFIX ".dll")
set(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
set(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")
set(CMAKE_EXECUTABLE_SUFFIX ".exe")          # .exe
# Modules have a different default prefix that shared libs.
set(CMAKE_MODULE_EXISTS 1)
set(CMAKE_FIND_LIBRARY_PREFIXES "lib")
set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll.a" ".a")
# Shared libraries on cygwin can be named with their version number.
set(CMAKE_SHARED_LIBRARY_NAME_WITH_VERSION 1)
# include(Platform/UnixPaths)
# Source: cmake/Modules/Platform/UnixPaths.cmake
# Block multiple inclusion because "CMakeCInformation.cmake" includes
# "Platform/${CMAKE_SYSTEM_NAME}" even though the generic module
# "CMakeSystemSpecificInformation.cmake" already included it.
# The extra inclusion is a work-around documented next to the include()
# call, so this can be removed when the work-around is removed.
if(__UNIX_PATHS_INCLUDED)
    return()
endif()
set(__UNIX_PATHS_INCLUDED 1)
set(UNIX 1)
# also add the install directory of the running cmake to the search directories
# CMAKE_ROOT is CMAKE_INSTALL_PREFIX/share/cmake, so we need to go two levels up
get_filename_component(_CMAKE_INSTALL_DIR "${CMAKE_ROOT}" PATH)
get_filename_component(_CMAKE_INSTALL_DIR "${_CMAKE_INSTALL_DIR}" PATH)
# List common installation prefixes.  These will be used for all search types.
# Reminder when adding new locations computed from environment variables
# please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst synchronized
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
    # Standard
    /usr/local
    /usr
    /
    # CMake install location
    "${_CMAKE_INSTALL_DIR}"
)
if(NOT CMAKE_FIND_NO_INSTALL_PREFIX)
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        # Project install destination.
        "${CMAKE_INSTALL_PREFIX}"
    )
    if(CMAKE_STAGING_PREFIX)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH
        # User-supplied staging prefix.
        "${CMAKE_STAGING_PREFIX}"
    )
    endif()
endif()
_cmake_record_install_prefix()
# Non "standard" but common install prefixes
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
    /usr/X11R6
    /usr/pkg
    /opt
)
# List common include file locations not under the common prefixes.
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
    # X11
    /usr/include/X11
)
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
    # X11
    /usr/lib/X11
)
list(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
    /lib
    /lib32
    /lib64
    /usr/lib
    /usr/lib32
    /usr/lib64
)
if(CMAKE_SYSROOT_COMPILE)
    set(_cmake_sysroot_compile "${CMAKE_SYSROOT_COMPILE}")
else()
    set(_cmake_sysroot_compile "${CMAKE_SYSROOT}")
endif()
# Default per-language values.  These may be later replaced after
# parsing the implicit directory information from compiler output.
set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT
    ${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}
    "${_cmake_sysroot_compile}/usr/include"
)
set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT
    ${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}
    "${_cmake_sysroot_compile}/usr/include"
)
set(_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT
    ${CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES}
    "${_cmake_sysroot_compile}/usr/include"
)
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
# Source: cmake/Modules/Platform/CYGWIN.cmake
# Windows API on Cygwin
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
  /usr/include/w32api
)
# Windows API on Cygwin
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
  /usr/lib/w32api
)
# Source: cmake/Modules/Platform/MSYS.cmake
set(CMAKE_SHARED_LIBRARY_PREFIX "msys-")
set(CMAKE_SHARED_MODULE_PREFIX "msys-")
