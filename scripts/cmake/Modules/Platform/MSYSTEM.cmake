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

# message(WARNING "ping")

if(NOT DEFINED MSYS_DEFAULT_MSYSTEM)
    set(MSYS_DEFAULT_MSYSTEM "MINGW64")
endif()

if(NOT DEFINED MSYSTEM)
    set(MSYSTEM "${MSYS_DEFAULT_MSYSTEM}")
endif()

string(TOLOWER "${MSYSTEM}" _msystem)
# Detect <_msystem>.ini to figure <MSYSTEM>_ROOT_DIR
set(Z_${MSYSTEM}_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
while(NOT DEFINED Z_${MSYSTEM}_ROOT_DIR)
    if(EXISTS "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}${_msystem}.ini")
        set(Z_${MSYSTEM}_ROOT_DIR "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(EXISTS "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}msys64/${_msystem}.ini")
        set(Z_${MSYSTEM}_ROOT_DIR "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(IS_DIRECTORY "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}")
        get_filename_component(Z_${MSYSTEM}_ROOT_DIR_TEMP "${Z_${MSYSTEM}_ROOT_DIR_CANDIDATE}" DIRECTORY)
        if(Z_MSYS_ROOT_DIR_TEMP STREQUAL Z_MSYS_ROOT_DIR_CANDIDATE)
            break() # If unchanged, we have reached the root of the drive without finding <MSYSTEM> root.
        endif()
        set(Z_${MSYSTEM}_ROOT_DIR_CANDIDATE "${Z_${MSYSTEM}_ROOT_DIR_TEMP}")
        unset(Z_${MSYSTEM}_ROOT_DIR_TEMP)
    else()
        break()
    endif()
endwhile()
unset(Z_${MSYSTEM}_ROOT_DIR_CANDIDATE)
unset(_msystem)

if(DEFINED MSYSTEM)
    if(MSYSTEM STREQUAL "MSYS2")
        include(Platform/MSYS)
    else()
        set(MINGW 1)
        set(WIN32 1)

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

        ##-- Source: Platform/GNU

        # GCC is the default compiler on GNU/Hurd.
        set(CMAKE_DL_LIBS "dl")
        set(CMAKE_SHARED_LIBRARY_C_FLAGS "-fPIC")
        set(CMAKE_SHARED_LIBRARY_CREATE_C_FLAGS "-shared")
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

        # These paths do their lookup backwards to prevent drive letter mangling!
        include(Platform/MSYSTEMPaths)

        # # Windows API on Cygwin
        # list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
        #   /usr/include/w32api
        # )

        # # Windows API on Cygwin
        # list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
        #   /usr/lib/w32api
        # )

        ##-- We perhaps have some custom path handling here in the case of the optional
        # appending of environment paths, etc, as part of the toolchain file. Or, it might
        # be better handled in that file itself.

        # Also could be the exact spot to provide the DX BinUtils compatibility file paths...


        ##-- These two vars also get overridden in Platform/MSYS... might be worth investigating
        # for equivalents!
        #set(CMAKE_SHARED_LIBRARY_PREFIX "msys-")
        #set(CMAKE_SHARED_MODULE_PREFIX "msys-")

    endif()
endif()

set(CMAKE_USER_MAKE_RULES_OVERRIDE "CMakeMSYSTEMFindMake" CACHE FILEPATH "" FORCE)
