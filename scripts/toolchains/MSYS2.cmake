if(NOT _MSYS_MSYS2_TOOLCHAIN)
set(_MSYS_MSYS2_TOOLCHAIN 1)

message(STATUS "MSYS2 x64 toolchain loading...")

set(CMAKE_SYSROOT "/usr" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag." FORCE)
set(CMAKE_SYSROOT_COMPILE "/usr" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag when compiling source files." FORCE)
set(CMAKE_SYSROOT_LINK "/usr" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag when linking." FORCE)

if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
    set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
endif()

# Need to override MinGW from MSYS_CMAKE_SYSTEM_NAME
set(CMAKE_SYSTEM_NAME "MSYS" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)

if(MSYS_TARGET_ARCHITECTURE STREQUAL "x86")
    set(CMAKE_SYSTEM_PROCESSOR i686 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "x64")
    set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm")
    set(CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm64")
    set(CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
endif()

# # Detect <Z_MSYS_ROOT_DIR>/msys2.ini to figure MSYS2_ROOT_DIR
# set(Z_MSYS2_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
# while(NOT DEFINED Z_MSYS2_ROOT_DIR)
#     if(EXISTS "${Z_MSYS2_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
#         set(Z_MSYS2_ROOT_DIR "${Z_MSYS2_ROOT_DIR_CANDIDATE}msys64/usr" CACHE INTERNAL "MSYS2 x64 root directory")
#     elseif(IS_DIRECTORY "${Z_MSYS2_ROOT_DIR_CANDIDATE}")
#         get_filename_component(Z_MSYS2_ROOT_DIR_TEMP "${Z_MSYS2_ROOT_DIR_CANDIDATE}" DIRECTORY)
#         if(Z_MSYS2_ROOT_DIR_TEMP STREQUAL Z_MSYS2_ROOT_DIR_CANDIDATE)
#             message(WARNING "Could not find 'msys2.ini'... Check your installation!")
#             break() # If unchanged, we have reached the root of the drive without finding vcpkg.
#         endif()
#         set(Z_MSYS2_ROOT_DIR_CANDIDATE "${Z_MSYS2_ROOT_DIR_TEMP}")
#         unset(Z_MSYS2_ROOT_DIR_TEMP)
#     else()
#         message(WARNING "Could not find 'msys2.ini'... Check your installation!")
#         break()
#     endif()
# endwhile()
# unset(Z_MSYS2_ROOT_DIR_CANDIDATE)

set(Z_MSYS2_ROOT_DIR "/usr" CACHE PATH "MSYS2 x64 root directory")

## Set Env vars
# set(ENV{CARCH} "x86_64")
# set(ENV{CHOST} "x86_64-pc-msys")
# set(ENV{CC} "gcc")
# set(ENV{CXX} "g++")
# set(ENV{CPPFLAGS} "")
# set(ENV{CFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe")
# set(ENV{CXXFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe")
# set(ENV{LDFLAGS} "-pipe")
# set(ENV{DEBUG_CFLAGS} "-ggdb -Og")
# set(ENV{DEBUG_CXXFLAGS} "-ggdb -Og")

foreach(lang C CXX) # Fortran OBJC OBJCXX ASM

    set(CMAKE_${lang}_COMPILER_TARGET "x86_64-pc-msys" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

    set(CMAKE_${lang}_COMPILER_ID "GNU 11.3.0" CACHE STRING "")

    # set(CMAKE_${lang}_COMPILER_FRONTEND_VARIANT "GNU" CACHE STRING "")
    # set(CMAKE_${lang}_COMPILER_VERSION "11.3.0" CACHE STRING "")

endforeach()

set(CMAKE_MAKE_PROGRAM "/usr/bin/make.exe" CACHE FILEPATH "Tool that can launch the native build system." FORCE)

set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include")
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include-fixed")
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include")
set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <C>." FORCE)
mark_as_advanced(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0")
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/usr/lib/w32api")
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/usr/x86_64-pc-msys/lib/ldscripts") # Hmm.... DSX dir??
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "/usr/lib")
set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${CMAKE_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>." FORCE)
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <C>." FORCE)
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_LIBRARIES)
list(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES
    "-mingw32"
    "-gcc"
    "-moldname"
    "-mingwex"
    "-kernel32"
    "-pthread"
    "-advapi32"
    "-shell32"
    "-user32"
)
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "${CMAKE_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>." FORCE)
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_LIBRARIES)

set(CMAKE_C_SOURCE_FILE_EXTENSIONS)
list(APPEND CMAKE_C_SOURCE_FILE_EXTENSIONS
    "c"
    "m"
)
set(CMAKE_C_SOURCE_FILE_EXTENSIONS "${CMAKE_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>." FORCE)
mark_as_advanced(CMAKE_C_SOURCE_FILE_EXTENSIONS)


find_program(CMAKE_C_COMPILER "x86_64-pc-msys-gcc"
    HINTS "/usr/bin"
    REQUIRED
    NO_DEFAULT_PATH
)
mark_as_advanced(CMAKE_C_COMPILER)

set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include/cygwin")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/include/w32api")
# list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MSYS2_ROOT_DIR}/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/...")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/backward")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/bits")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/debug")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/decimal")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/ext")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/parallel")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/pstl")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/tr1")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/tr2")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/x86_64-pc-msys/bits")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/x86_64-pc-msys/ext")
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <CXX>." FORCE)
mark_as_advanced(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/usr/lib/gcc/x86_64-pc-msys/11.3.0")
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/usr/lib/w32api")
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/usr/x86_64-pc-msys/lib/ldscripts") # Hmm.... DSX dir??
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "/usr/lib")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>." FORCE)
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <CXX>." FORCE)
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)
list(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES
    "stdc++"
    "mingw32"
    "gcc_s"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
    "pthread"
    "advapi32"
    "shell32"
    "user32"
)
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "${CMAKE_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>." FORCE)
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)

set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS
    "C"
    "M"
    "c++"
    "cc"
    "cpp"
    "cxx"
    "mm"
    "mpp"
    "CPP"
    "ixx"
    "cppm"
)
set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS "${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <CXX>." FORCE)
mark_as_advanced(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)

find_program(CMAKE_CXX_COMPILER "x86_64-pc-msys-g++"
    HINTS "/usr/bin"
    #"${Z_MSYS2_ROOT_DIR}/usr/bin"
    REQUIRED
    NO_DEFAULT_PATH
)
mark_as_advanced(CMAKE_CXX_COMPILER)

# find_program(CMAKE_Fortran_COMPILER "${Z_MSYS2_ROOT_DIR}/bin/x86_64-w64-mingw32-gfortran.exe")
# mark_as_advanced(CMAKE_Fortran_COMPILER)

# find_program(CMAKE_OBJC_COMPILER "${Z_MSYS2_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
# mark_as_advanced(CMAKE_OBJC_COMPILER)

# find_program(CMAKE_OBJCXX_COMPILER "${Z_MSYS2_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
# mark_as_advanced(CMAKE_OBJCXX_COMPILER)

# if(NOT DEFINED CMAKE_ASM_COMPILER)
#     find_program(CMAKE_ASM_COMPILER "${Z_MSYS2_ROOT_DIR}/bin/as.exe")
# endif()
# mark_as_advanced(CMAKE_ASM_COMPILER)

find_program(CMAKE_RC_COMPILER "windres"
    HINTS "/usr/bin"
    NO_DEFAULT_PATH
)
mark_as_advanced(CMAKE_RC_COMPILER)


get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

# The following flags come from 'PORT' files (i.e., build config files for packages)
if(NOT _CMAKE_IN_TRY_COMPILE)

    set(LDFLAGS)
    string(APPEND LDFLAGS " -pipe")
    set(LDFLAGS "${LDFLAGS}")
    set(ENV{LDFLAGS} "${LDFLAGS}")

    # set(CFLAGS)
    # string(APPEND CFLAGS " -march=nocona")
    # string(APPEND CFLAGS " -msahf")
    # string(APPEND CFLAGS " -mtune=generic")
    # string(APPEND CFLAGS " -pipe")
    # set(CFLAGS "${CFLAGS}")
    # set(ENV{CFLAGS} "${CFLAGS}")

    # set(CXXFLAGS)
    # string(APPEND CXXFLAGS " -march=nocona")
    # string(APPEND CXXFLAGS " -msahf")
    # string(APPEND CXXFLAGS " -mtune=generic")
    # string(APPEND CXXFLAGS " -pipe")
    # set(CXXFLAGS "${CXXFLAGS}")
    # set(ENV{CXXFLAGS} "${CXXFLAGS}")

    # Initial configuration flags.
    foreach(lang C CXX ASM Fortran OBJC OBJCXX)
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=nocona")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -msahf")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
    endforeach()

    string(APPEND CMAKE_C_FLAGS_INIT                        " ${MSYS_C_FLAGS} ")
    string(APPEND CMAKE_C_FLAGS_DEBUG_INIT                  " ${MSYS_C_FLAGS_DEBUG} ")
    string(APPEND CMAKE_C_FLAGS_RELEASE_INIT                " ${MSYS_C_FLAGS_RELEASE} ")
    string(APPEND CMAKE_C_FLAGS_MINSIZEREL_INIT             " ${MSYS_C_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_C_FLAGS_RELWITHDEBINFO_INIT         " ${MSYS_C_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_CXX_FLAGS_INIT                      " ${MSYS_CXX_FLAGS} ")
    string(APPEND CMAKE_CXX_FLAGS_DEBUG_INIT                " ${MSYS_CXX_FLAGS_DEBUG} ")
    string(APPEND CMAKE_CXX_FLAGS_RELEASE_INIT              " ${MSYS_CXX_FLAGS_RELEASE} ")
    string(APPEND CMAKE_CXX_FLAGS_MINSIZEREL_INIT           " ${MSYS_CXX_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT       " ${MSYS_CXX_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_ASM_FLAGS_INIT                      " ${MSYS_ASM_FLAGS} ")
    string(APPEND CMAKE_ASM_FLAGS_DEBUG_INIT                " ${MSYS_ASM_FLAGS_DEBUG} ")
    string(APPEND CMAKE_ASM_FLAGS_RELEASE_INIT              " ${MSYS_ASM_FLAGS_RELEASE} ")
    string(APPEND CMAKE_ASM_FLAGS_MINSIZEREL_INIT           " ${MSYS_ASM_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_ASM_FLAGS_RELWITHDEBINFO_INIT       " ${MSYS_ASM_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_Fortran_FLAGS_INIT                  " ${MSYS_Fortran_FLAGS} ")
    string(APPEND CMAKE_Fortran_FLAGS_DEBUG_INIT            " ${MSYS_Fortran_FLAGS_DEBUG} ")
    string(APPEND CMAKE_Fortran_FLAGS_RELEASE_INIT          " ${MSYS_Fortran_FLAGS_RELEASE} ")
    string(APPEND CMAKE_Fortran_FLAGS_MINSIZEREL_INIT       " ${MSYS_Fortran_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_Fortran_FLAGS_RELWITHDEBINFO_INIT   " ${MSYS_Fortran_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_OBJC_FLAGS_INIT                     " ${MSYS_OBJC_FLAGS} ")
    string(APPEND CMAKE_OBJC_FLAGS_DEBUG_INIT               " ${MSYS_OBJC_FLAGS_DEBUG} ")
    string(APPEND CMAKE_OBJC_FLAGS_RELEASE_INIT             " ${MSYS_OBJC_FLAGS_RELEASE} ")
    string(APPEND CMAKE_OBJC_FLAGS_MINSIZEREL_INIT          " ${MSYS_OBJC_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_OBJC_FLAGS_RELWITHDEBINFO_INIT      " ${MSYS_OBJC_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_OBJCXX_FLAGS_INIT                   " ${MSYS_OBJCXX_FLAGS} ")
    string(APPEND CMAKE_OBJCXX_FLAGS_DEBUG_INIT             " ${MSYS_OBJCXX_FLAGS_DEBUG} ")
    string(APPEND CMAKE_OBJCXX_FLAGS_RELEASE_INIT           " ${MSYS_OBJCXX_FLAGS_RELEASE} ")
    string(APPEND CMAKE_OBJCXX_FLAGS_MINSIZEREL_INIT        " ${MSYS_OBJCXX_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_OBJCXX_FLAGS_RELWITHDEBINFO_INIT    " ${MSYS_OBJCXX_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_RC_FLAGS_INIT                       " ${MSYS_RC_FLAGS} ")
    string(APPEND CMAKE_RC_FLAGS_DEBUG_INIT                 " ${MSYS_RC_FLAGS_DEBUG} ")
    string(APPEND CMAKE_RC_FLAGS_RELEASE_INIT               " ${MSYS_RC_FLAGS_RELEASE} ")
    string(APPEND CMAKE_RC_FLAGS_MINSIZEREL_INIT            " ${MSYS_RC_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_RC_FLAGS_RELWITHDEBINFO_INIT        " ${MSYS_RC_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
    string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_INIT            " ${MSYS_LINKER_FLAGS} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT               " ${MSYS_LINKER_FLAGS} ")

    if(OPTION_STRIP_BINARIES)
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT               " --strip-all")
    endif()

    if(OPTION_STRIP_SHARED)
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT            " --strip-unneeded")
    endif()

    if(OPTION_STRIP_STATIC)
        string(APPEND CMAKE_STATIC_LINKER_FLAGS_INIT            " --strip-debug")
    endif()

    if(MSYS_CRT_LINKAGE STREQUAL "static")
        string(APPEND CMAKE_SHARED_LINKER_FLAGS_INIT        " -static")
        string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT           " -static")
    endif()

    string(APPEND CMAKE_SHARED_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_SHARED_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_STATIC_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_STATIC_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_STATIC_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_STATIC_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_MODULE_LINKER_FLAGS_DEBUG_INIT              " ${MSYS_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELEASE_INIT            " ${MSYS_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_MINSIZEREL_INIT         " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_MODULE_LINKER_FLAGS_RELWITHDEBINFO_INIT     " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

    string(APPEND CMAKE_EXE_LINKER_FLAGS_DEBUG_INIT                 " ${MSYS_LINKER_FLAGS_DEBUG} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_RELEASE_INIT               " ${MSYS_LINKER_FLAGS_RELEASE} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_MINSIZEREL_INIT            " ${MSYS_LINKER_FLAGS_MINSIZEREL} ")
    string(APPEND CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO_INIT        " ${MSYS_LINKER_FLAGS_RELWITHDEBINFO} ")

endif()

message(STATUS "MSYS2 x64 toolchain loaded")

endif()

#[===[

    ```
    "C:/msys64/usr/include",
    "C:/msys64/usr/include/cygwin",
    "C:/msys64/usr/include/w32api",

    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include-fixed",

    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/backward",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/bits",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/debug",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/decimal",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/experimental",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/ext",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/parallel",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/pstl",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/tr1",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/tr2",

    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/x86_64-pc-msys/bits",
    "C:/msys64/usr/lib/gcc/x86_64-pc-msys/11.3.0/include/c++/x86_64-pc-msys/ext"
    ```
]===]
