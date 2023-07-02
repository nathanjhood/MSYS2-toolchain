# Source: cmake/Modules/Platform/MSYS.cmake
set(MSYS 1)
# include(Platform/CYGWIN)
# Source: cmake/Modules/Platform/CYGWIN.cmake
set(MINGW64 1)

# GCC is the default compiler on GNU/Hurd.
set(CMAKE_DL_LIBS "dl")
set(CMAKE_SHARED_LIBRARY_C_FLAGS " -fPIC")
set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS " -shared")
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")
set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP ":")
set(CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG "-Wl,-rpath-link,")
set(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-Wl,-soname,")
set(CMAKE_EXE_EXPORTS_C_FLAG "-Wl,--export-dynamic")

# Debian policy requires that shared libraries be installed without
# executable permission.  Fedora policy requires that shared libraries
# be installed with the executable permission.  Since the native tools
# create shared libraries with execute permission in the first place a
# reasonable policy seems to be to install with execute permission by
# default.  In order to support debian packages we provide an option
# here.  The option default is based on the current distribution, but
# packagers can set it explicitly on the command line.
if(DEFINED CMAKE_INSTALL_SO_NO_EXE)
    # Store the decision variable in the cache.  This preserves any
    # setting the user provides on the command line.
    set(CMAKE_INSTALL_SO_NO_EXE "${CMAKE_INSTALL_SO_NO_EXE}" CACHE INTERNAL "Install .so files without execute permission.")
else()
    # Store the decision variable as an internal cache entry to avoid
    # checking the platform every time.  This option is advanced enough
    # that only package maintainers should need to adjust it.  They are
    # capable of providing a setting on the command line.
    if(EXISTS "/etc/debian_version")
        set(CMAKE_INSTALL_SO_NO_EXE 1 CACHE INTERNAL "Install .so files without execute permission.")
    else()
        set(CMAKE_INSTALL_SO_NO_EXE 0 CACHE INTERNAL "Install .so files without execute permission.")
    endif()
endif()

set(CMAKE_LIBRARY_ARCHITECTURE_REGEX "[a-z0-9_]+(-[a-z0-9_]+)?-gnu[a-z0-9_]*")

set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
set(CMAKE_SHARED_MODULE_PREFIX "lib")
set(CMAKE_SHARED_MODULE_SUFFIX ".dll")
set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
set(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
set(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")
set(CMAKE_EXECUTABLE_SUFFIX ".exe")
# Modules have a different default prefix that shared libs.
set(CMAKE_MODULE_EXISTS 1)
set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")
set(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
# # Shared libraries on cygwin can be named with their version number.
# set(CMAKE_SHARED_LIBRARY_NAME_WITH_VERSION 1 CACHE STRING "" FORCE)

# include(Platform/UnixPaths)
# Source: cmake/Modules/Platform/UnixPaths.cmake
# Block multiple inclusion because "CMakeCInformation.cmake" includes
# "Platform/${CMAKE_SYSTEM_NAME}" even though the generic module
# "CMakeSystemSpecificInformation.cmake" already included it.
# The extra inclusion is a work-around documented next to the include()
# call, so this can be removed when the work-around is removed.
if(__MINGW64_PATHS_INCLUDED)
    return()
endif()
set(__MINGW64_PATHS_INCLUDED 1)
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
    set(_cmake_sysroot_compile "${Z_MINGW64_ROOT_DIR}/${CMAKE_SYSROOT}")
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

# set(CMAKE_ROOT "${CMAKE_ROOT}" CACHE PATH "Install directory for running cmake." FORCE)
# set(CMAKE_SYSROOT "${CMAKE_SYSROOT}" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag." FORCE)
# set(CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES "${CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "" FORCE)
# set(CMAKE_SYSTEM_PREFIX_PATH "${CMAKE_SYSTEM_PREFIX_PATH}" CACHE PATH ":`Semicolon-separated list <CMake Language Lists>` of directories specifying installation *prefixes* to be searched by the ``find_package()``, ``find_program()``, ``find_library()``, ``find_file()``, and ``find_path()`` commands." FORCE)
# set(CMAKE_SYSTEM_INCLUDE_PATH "${CMAKE_SYSTEM_INCLUDE_PATH}" CACHE PATH ":`Semicolon-separated list <CMake Language Lists>` of directories specifying a search path for the ``find_file()`` and ``find_path()`` commands." FORCE)
# set(CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_SYSTEM_LIBRARY_PATH}" CACHE PATH ":`Semicolon-separated list <CMake Language Lists>` of directories specifying a search path for the ``find_library()`` command." FORCE)

# set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files." FORCE)
# set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files." FORCE)
