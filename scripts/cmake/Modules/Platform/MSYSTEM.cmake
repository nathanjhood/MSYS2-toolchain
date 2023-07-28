if(TRACE_MODE)
    message("Enter: ${CMAKE_CURRENT_LIST_FILE}")
endif()

if(NOT DEFINED Z_MSYS_ROOT_DIR)
    z_msys_add_fatal_error("Could not find '/msys2.ini' - make sure you have the 'MSYSTEM-initilize' file in 'Modules/Platforms'!")
endif()

## 2. Set MSYSTEM vars
include(z_msys_set_msystem_vars)
z_msys_set_msystem_vars()
# ## 3. Set pwsh path
# include(z_msys_set_powershell_path)
# z_msys_set_powershell_path()
# ## 4. Inherit or dismiss the Windows %PATH% variable
# include(z_msys_set_msystem_path_type)
# z_msys_set_msystem_path_type()

include(z_msys_add_msystem_cmake_to_system_prefix_path)
z_msys_add_msystem_cmake_to_system_prefix_path()
#z_msys_add_win32_program_files_to_cmake_system_prefix_path()


# #If set to 'ON', the paths under the current 'MSYSTEM' directory
# #will be scanned first during file/program/lib lookup routines
# option(OPTION_MSYS_PREFER_MSYSTEM_PATHS "If set to 'ON', the paths under the current 'MSYSTEM' directory will be scanned before the '<msysRoot>/usr' directory during file/program/lib lookup routines." ON)
# if(OPTION_MSYS_PREFER_MSYSTEM_PATHS)
#     include(z_msys_get_msystem_paths)
#     z_msys_get_msystem_paths()

#     include(z_msys_get_base_paths)
#     z_msys_get_base_paths()
# else()
#     include(z_msys_get_base_paths)
#     z_msys_get_base_paths()

#     include(z_msys_get_msystem_paths)
#     z_msys_get_msystem_paths()
# endif()

option(OPTION_MSYS_PREFER_WIN32_PATHS "If set to 'ON', the paths under the calling environment's 'PATH' variable will be scanned before any other paths, during file/program/lib lookup routines" OFF)
if(ORIGINAL_PATH) # If ORIGINAL_PATH is empty, don't do anything with it, regardless of MSYS_PATH_TYPE (i.e., skip over it)
    if(OPTION_MSYS_PREFER_WIN32_PATHS)
        list(INSERT MSYS_PATH 0 "${ORIGINAL_PATH}")
    else()
        list(APPEND MSYS_PATH "${ORIGINAL_PATH}")
    endif()
endif()

if(DEFINED Z_MSYS_POWERSHELL_PATH)
    list(APPEND MSYS_PATH "${Z_MSYS_POWERSHELL_PATH}")
else()
    list(APPEND MSYS_PATH "${WIN_ROOT}/System32/WindowsPowerShell/v1.0/")
endif()



if(NOT DEFINED CMAKE_SYSTEM_PROGRAM_PATH)
    set(CMAKE_SYSTEM_PROGRAM_PATH)
endif()
list(APPEND CMAKE_SYSTEM_PROGRAM_PATH "${MSYS_PATH}")
include(z_msys_add_msystem_path_to_cmake_path)
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_PREFIX_PATH "")
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_PROGRAM_PATH "/bin")
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_INCLUDE_PATH "/include")
z_msys_add_msystem_path_to_cmake_path(CMAKE_SYSTEM_LIBRARY_PATH "/lib")
z_msys_add_msystem_path_to_cmake_path(CMAKE_FIND_ROOT_PATH "")

set(_ignored_msystems)
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw32")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/mingw64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang32")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clang64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/clangarm64")
list(APPEND _ignored_msystems "${Z_MSYS_ROOT_DIR}/ucrt64")
list(REMOVE_ITEM _ignored_msystems "${Z_MSYS_ROOT_DIR}${MINGW_PREFIX}")
if(NOT DEFINED CMAKE_SYSTEM_IGNORE_PREFIX_PATH)
    set(CMAKE_SYSTEM_IGNORE_PREFIX_PATH)
endif()
list(APPEND CMAKE_SYSTEM_IGNORE_PREFIX_PATH "${_ignored_msystems}")
unset(_ignored_msystems)

# z_msys_set_msystem_env_vars()

option(OPTION_USE_DSX_BINUTILS "(Inactive) Use the BinUtils programs found under '<rootDir>/<packagePrefix>' for DirectX compatibility instead of standard BinUtils." OFF)
mark_as_advanced(OPTION_USE_DSX_BINUTILS)



# option(OPTION_ENABLE_DLAGENTS "" ON)
# mark_as_advanced(OPTION_ENABLE_DLAGENTS)
# if(OPTION_ENABLE_DLAGENTS)
#     include(DLAGENTS OPTIONAL)
# endif()

# set(SYSCONFDIR "${Z_MSYS_ROOT_DIR}/etc}")
# set(CONFIG_SITE "${SYSCONFDIR}/config.site")

# set(ORIGINAL_TMP "${ORIGINAL_TMP:-${TMP}}")
# set(ORIGINAL_TEMP "${ORIGINAL_TEMP:-${TEMP}}")
set(TMP "${Z_MSYS_ROOT_DIR}/tmp")
set(TEMP "${Z_MSYS_ROOT_DIR}/tmp")

if(MSYSTEM STREQUAL "MSYS2")

    if(CMAKE_CROSSCOMPILING AND NOT CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        # MinGW (useful when cross compiling from linux with CMAKE_FIND_ROOT_PATH set)
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH /)
    endif()

    include(Platform/MSYS)

    # set(CMAKE_EXTRA_GENERATOR "MSYS Makefiles" CACHE STRING "The extra generator used to build the project." FORCE)

else()
    set(MINGW 1)
    set(WIN32 1)
    # Don't set 'UNIX' for MinGW :)
    # include(Platform/Windows)

    #set(CMAKE_EXTRA_GENERATOR "MSYS Makefiles" CACHE STRING "The extra generator used to build the project." FORCE)

    set(CMAKE_STATIC_LIBRARY_SUFFIX ".a")
    set(CMAKE_STATIC_LIBRARY_PREFIX "lib")
    set(CMAKE_SHARED_LIBRARY_PREFIX "lib")
    set(CMAKE_SHARED_LIBRARY_SUFFIX ".dll")
    set(CMAKE_SHARED_MODULE_PREFIX "lib")
    set(CMAKE_SHARED_MODULE_SUFFIX ".dll")
    set(CMAKE_IMPORT_LIBRARY_PREFIX "lib")
    set(CMAKE_IMPORT_LIBRARY_SUFFIX ".dll.a")

    set(CMAKE_EXECUTABLE_SUFFIX ".exe")          # .exe

    # Modules have a different default prefix that shared libs.
    set(CMAKE_MODULE_EXISTS 1)

    set(CMAKE_FIND_LIBRARY_PREFIXES "lib" "")
    set(CMAKE_FIND_LIBRARY_SUFFIXES ".dll" ".dll.a" ".a" ".lib")

    # Shared libraries on cygwin can be named with their version number.
    set(CMAKE_SHARED_LIBRARY_NAME_WITH_VERSION 1)

    # ##-- Source: Platform/GNU

    # # GCC is the default compiler on GNU/Hurd.
    # set(CMAKE_DL_LIBS "dl")
    # set(CMAKE_SHARED_LIBRARY_C_FLAGS "-fPIC")
    # set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")
    # set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG "-Wl,-rpath,")
    # set(CMAKE_SHARED_LIBRARY_RUNTIME_C_FLAG_SEP ":")
    # set(CMAKE_SHARED_LIBRARY_RPATH_LINK_C_FLAG "-Wl,-rpath-link,")
    # set(CMAKE_SHARED_LIBRARY_SONAME_C_FLAG "-Wl,-soname,")
    # set(CMAKE_EXE_EXPORTS_C_FLAG "-Wl,--export-dynamic")

    # # Debian policy requires that shared libraries be installed without
    # # executable permission.  Fedora policy requires that shared libraries
    # # be installed with the executable permission.  Since the native tools
    # # create shared libraries with execute permission in the first place a
    # # reasonable policy seems to be to install with execute permission by
    # # default.  In order to support debian packages we provide an option
    # # here.  The option default is based on the current distribution, but
    # # packagers can set it explicitly on the command line.
    # if(DEFINED CMAKE_INSTALL_SO_NO_EXE)

    #     # Store the decision variable in the cache.  This preserves any
    # # setting the user provides on the command line.
    # set(CMAKE_INSTALL_SO_NO_EXE "${CMAKE_INSTALL_SO_NO_EXE}" CACHE INTERNAL "Install .so files without execute permission.")

    # else()

    #     # Store the decision variable as an internal cache entry to avoid
    #     # checking the platform every time.  This option is advanced enough
    #     # that only package maintainers should need to adjust it.  They are
    #     # capable of providing a setting on the command line.
    #     if(EXISTS "/etc/debian_version")
    #         set(CMAKE_INSTALL_SO_NO_EXE 1 CACHE INTERNAL "Install .so files without execute permission.")
    #     else()
    #         set(CMAKE_INSTALL_SO_NO_EXE 0 CACHE INTERNAL "Install .so files without execute permission.")
    #     endif()

    # endif()

    # set(CMAKE_LIBRARY_ARCHITECTURE_REGEX "[a-z0-9_]+(-[a-z0-9_]+)?-gnu[a-z0-9_]*")

    # # These paths do their lookup backwards to prevent drive letter mangling!
    # #include(Platform/MSYSTEMPaths)

    list(APPEND CMAKE_SYSTEM_PREFIX_PATH

        # Standard
        "${MSYS_PATH}"

        # CMake install location
        "${_CMAKE_INSTALL_DIR}"
    )

    if(NOT CMAKE_FIND_NO_INSTALL_PREFIX) # Add other locations.
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


    # mingw can also link against dlls which can also be in '/bin', so list this too
    if (NOT CMAKE_FIND_NO_INSTALL_PREFIX)
        list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_INSTALL_PREFIX}/bin")
        if (CMAKE_STAGING_PREFIX)
            list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_STAGING_PREFIX}/bin")
        endif()
    endif()
    list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${_CMAKE_INSTALL_DIR}/bin")
    # list(APPEND CMAKE_SYSTEM_LIBRARY_PATH /bin)
    # list(APPEND CMAKE_SYSTEM_PROGRAM_PATH)

    # # # Non "standard" but common install prefixes
    # # list(APPEND CMAKE_SYSTEM_PREFIX_PATH
    # #     # "${Z_${MSYSTEM}_ROOT_DIR}/usr/X11R6"
    # #     # "${Z_${MSYSTEM}_ROOT_DIR}/usr/pkg"
    # #     # "${Z_${MSYSTEM}_ROOT_DIR}/opt"
    # #     # "${Z_${MSYSTEM}_ROOT_DIR}/x86_64-w64-mingw32"
    # # )

    if(OPTION_USE_DSX_BINUTILS) # This should probably be some sort of 'COMPATIBILITY' switcheroo...
        list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${MSYS_DXSDK_DIR}")
    endif()

    option(OPTION_ENABLE_X11 "Adds '/include/X11' to 'CMAKE_SYSTEM_INCLUDE_PATH', and '/lib/X11' to 'CMAKE_SYSTEM_LIBRARY_PATH' for lookup." ON)
    if(OPTION_ENABLE_X11)
        list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
            # X11
            "${Z_${MSYSTEM}_ROOT_DIR}/include/X11"
        )
        list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
            # X11
            "${Z_${MSYSTEM}_ROOT_DIR}/lib/X11"
        )
    endif()

    list(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
        "${Z_${MSYSTEM}_ROOT_DIR}/lib"
        "${Z_${MSYSTEM}_ROOT_DIR}/lib32"
        "${Z_${MSYSTEM}_ROOT_DIR}/lib64"
        "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib"
        "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib32"
        "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib64"
    )

    # ##-- This one is for 'FindMSYS'
    # set(MSYS_INSTALL_PATH "${Z_MSYS_ROOT_DIR}" CACHE PATH " This one is for 'FindMSYS'." FORCE)

    set(CMAKE_SYSROOT "${MSYSTEM_SYSROOT}" CACHE STRING "Path to pass to the compiler in the ``--sysroot`` flag.")
    set(CMAKE_SYSROOT_LINK "${MSYSTEM_SYSROOT}" CACHE STRING "Path to pass to the compiler in the ``--sysroot`` flag when linking.")
    set(CMAKE_SYSROOT_COMPILE "${MSYSTEM_SYSROOT}" CACHE STRING "Path to pass to the compiler in the ``--sysroot`` flag when compiling source files.")

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

endif()


# message(STATUS "...MSYSTEM Platform info loaded.")

if(Z_MSYS_HAS_FATAL_ERROR)
    message(FATAL_ERROR "MSYS_FATAL_ERROR = ${Z_MSYS_FATAL_ERROR}")
endif()

if(TRACE_MODE)
    message("Exit: ${CMAKE_CURRENT_LIST_FILE}")
endif()
