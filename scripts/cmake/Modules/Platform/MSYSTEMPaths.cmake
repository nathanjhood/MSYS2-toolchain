# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

# Block multiple inclusion because "CMakeCInformation.cmake" includes
# "Platform/${CMAKE_SYSTEM_NAME}" even though the generic module
# "CMakeSystemSpecificInformation.cmake" already included it.
# The extra inclusion is a work-around documented next to the include()
# call, so this can be removed when the work-around is removed.
if(__MSYSTEM_PATHS_INCLUDED)
    return()
endif()
set(__MSYSTEM_PATHS_INCLUDED 1)

# message(WARNING "ping")

#set(UNIX 1) # Don't set 'UNIX' for MinGW!!! ;)
set(MINGW 1) # ``True`` when using MinGW
set(WIN32 1) # Set to ``True`` when the target system is Windows, including Win64.


# Reminder when adding new locations computed from environment variables
# please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
# synchronized
list(APPEND CMAKE_SYSTEM_PREFIX_PATH

    # Standard
    "${MSYS_PATH}"

    # CMake install location
    "${_CMAKE_INSTALL_DIR}"
)

if (NOT CMAKE_FIND_NO_INSTALL_PREFIX) # Add other locations.
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

list(APPEND CMAKE_SYSTEM_INCLUDE_PATH)

# mingw can also link against dlls which can also be in '/bin', so list this too
if (NOT CMAKE_FIND_NO_INSTALL_PREFIX)
    list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_INSTALL_PREFIX}/bin")
    if (CMAKE_STAGING_PREFIX)
        list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${CMAKE_STAGING_PREFIX}/bin")
    endif()
endif()
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH "${_CMAKE_INSTALL_DIR}/bin")
list(APPEND CMAKE_SYSTEM_LIBRARY_PATH /bin)

list(APPEND CMAKE_SYSTEM_PROGRAM_PATH)


# # Non "standard" but common install prefixes
# list(APPEND CMAKE_SYSTEM_PREFIX_PATH
#     # "${Z_${MSYSTEM}_ROOT_DIR}/usr/X11R6"
#     # "${Z_${MSYSTEM}_ROOT_DIR}/usr/pkg"
#     # "${Z_${MSYSTEM}_ROOT_DIR}/opt"
#     # "${Z_${MSYSTEM}_ROOT_DIR}/x86_64-w64-mingw32"
# )
if(DEFINED MSYS_DXSDK_DIR) # This should probably be some sort of 'COMPATIBILITY' switcheroo...
    list(APPEND CMAKE_SYSTEM_PREFIX_PATH "${MSYS_DXSDK_DIR}")
endif()

# List common include file locations not under the common prefixes.
list(APPEND CMAKE_SYSTEM_INCLUDE_PATH
    # X11
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/include/X11"
)

list(APPEND CMAKE_SYSTEM_LIBRARY_PATH
    # X11
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib/X11"
)

list(APPEND CMAKE_PLATFORM_IMPLICIT_LINK_DIRECTORIES
    "${Z_${MSYSTEM}_ROOT_DIR}/lib"
    "${Z_${MSYSTEM}_ROOT_DIR}/lib32"
    "${Z_${MSYSTEM}_ROOT_DIR}/lib64"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib32"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/lib64"
)

##-- This one is for 'FindMSYS'
set(MSYS_INSTALL_PATH "${Z_MSYS_ROOT_DIR}" CACHE PATH " This one is for 'FindMSYS'." FORCE)

# Later, this triggers 'include("CMakeFind${CMAKE_EXTRA_GENERATOR}" OPTIONAL)'
# Which picks up several useful include dirs...
set(CMAKE_EXTRA_GENERATOR "MSYS Makefiles" CACHE STRING "" FORCE)

# include(FindMSYSTEMCommands)

# find_program(BASH
#   bash
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
#   DOC "GNU Bash."
# )
# mark_as_advanced(BASH)

# find_program(CP
#   cp
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
#   DOC "Copy SOURCE to DEST, or multiple SOURCE(s) to DIRECTORY."
# )
# mark_as_advanced(CP)

# find_program(CYGPATH
#   cygpath
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(CYGPATH)

# find_program(GZIP
#   gzip
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(GZIP)

# find_program(MV
#   mv
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(MV)

# find_program(RM
#   rm
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
#   DOC "Remove (unlink) the FILE(s)."
# )
# mark_as_advanced(RM)

# find_program(TAR
#   NAMES
#   tar
#   gtar
#   PATHS
#   ${MSYS_INSTALL_PATH}/usr/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(TAR)

# include(FindPackageHandleStandardArgs)
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS BASH
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS CP
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS CYGPATH
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS GZIP
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS MV
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS RM
# )
# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS TAR
# )

# find_program(AS
#   NAMES
#   as
#   PATHS
#   ${Z_${MSYSTEM}_ROOT_DIR}/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(AS)

# find_program(CC
#   NAMES
#   cc
#   PATHS
#   ${Z_${MSYSTEM}_ROOT_DIR}/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(CC)

# find_program(CXX
#   NAMES
#   c++
#   PATHS
#   ${Z_${MSYSTEM}_ROOT_DIR}/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(CC)

# find_program(OBJC
#   NAMES
#   cc
#   PATHS
#   ${Z_${MSYSTEM}_ROOT_DIR}/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(OBJC)

# find_program(OBJCXX
#   NAMES
#   c++
#   PATHS
#   ${Z_${MSYSTEM}_ROOT_DIR}/bin
#   NO_DEFAULT_PATH
# )
# mark_as_advanced(OBJCXX)

# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS CC
# )

# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS CXX
# )

# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS OBJC
# )

# find_package_handle_standard_args(UnixCommands
#   REQUIRED_VARS OBJCXX
# )

# set(CMAKE_USER_MAKE_RULES_OVERRIDE "CMakeMSYSTEMFindMake" CACHE FILEPATH "" FORCE)



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


###############################################################################


# set(CMAKE_SYSTEM_NAME "MINGW64_NT" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)
# set(CMAKE_SYSTEM_VERSION "${CMAKE_HOST_SYSTEM_VERSION}" CACHE STRING "The version of the operating system for which CMake is to build." FORCE)
# #set(CMAKE_SYSTEM "${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_SYSTEM_NAME}-${CMAKE_SYSTEM_VERSION}" CACHE STRING "Composite name of operating system CMake is compiling for.." FORCE)

#[===[
set(CMAKE_SYSTEM_PREFIX_PATH
    "C:/msys64/mingw64/usr/local"
    "C:/msys64/mingw64/usr"
    "C:/msys64/mingw64/"
    "C:/msys64/mingw64"
    "c:/Users/natha/Development/StoneyDSP/MSYS2-toolchain/usr/local"
    "C:/msys64/mingw64/usr/X11R6"
    "C:/msys64/mingw64/usr/pkg"
    "C:/msys64/mingw64/opt"
)

set(CMAKE_SYSTEM_INCLUDE_PATH "C:/msys64/mingw64/usr/include/X11")
set(CMAKE_SYSTEM_LIBRARY_PATH "C:/msys64/mingw64/usr/lib/X11")

set(_CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include")
set(_CMAKE_CUDA_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include"
set(_CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES_INIT "/usr/include")

CMAKE_C_IGNORE_EXTENSIONS="h;H;o;O;obj;OBJ;def;DEF;rc;RC"
CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_C_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES
    "mingw32"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
    "pthread"
    "advapi32"
    "shell32"
    "user32"
    "kernel32"
    "mingw32"
    "gcc"
    "moldname"
    "mingwex"
    "kernel32"
)

set(CMAKE_CXX_IGNORE_EXTENSIONS "inl;h;hpp;HPP;H;o;O;obj;OBJ;def;DEF;rc;RC")
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/mingw64/include/c++/13.1.0;C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/mingw64/include/c++/13.1.0/backward;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib")
set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES
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

CMAKE_Fortran_IGNORE_EXTENSIONS="h;H;o;O;obj;OBJ;def;DEF;rc;RC"
CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES="gfortran;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;quadmath;m;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32"

CMAKE_OBJCXX_IGNORE_EXTENSIONS="inl;h;hpp;HPP;H;o;O"
CMAKE_OBJCXX_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/include/c++/13.1.0;C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/mingw64/include/c++/13.1.0/backward;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_OBJCXX_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_OBJCXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_OBJCXX_IMPLICIT_LINK_LIBRARIES="stdc++;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32"

CMAKE_OBJC_IGNORE_EXTENSIONS="h;H;o;O"
CMAKE_OBJC_IMPLICIT_INCLUDE_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
CMAKE_OBJC_IMPLICIT_LINK_DIRECTORIES="C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib"
CMAKE_OBJC_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES=""
CMAKE_OBJC_IMPLICIT_LINK_LIBRARIES="mingw32;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc;moldname;mingwex;kernel32"
]===]


#[===[
    {
	"kind" : "toolchains",
	"toolchains" :
	[
		{
            "language" : "ASM",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" : {},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-gcc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"s",
				"S",
				"asm"
			]
		},
		{
            "language" : "C",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-gcc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
            "sourceFileExtensions" :
			[
				"c"
			]
		},
		{
            "language" : "CXX",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/include/c++/13.1.0",
						"C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32",
						"C:/msys64/mingw64/include/c++/13.1.0/backward",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"stdc++",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-g++.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"C",
				"c++",
				"cc",
				"cpp",
				"cxx",
				"mpp",
				"CPP",
				"ixx",
				"cppm"
			]
		},
		{
            "language" : "Fortran",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"gfortran",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"quadmath",
						"m",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/gfortran.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"f",
				"F",
				"fpp",
				"FPP",
				"f77",
				"F77",
				"f90",
				"F90",
				"for",
				"For",
				"FOR",
				"f95",
				"F95"
			]
		},
		{
            "language" : "OBJC",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-cc.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"m"
			]
		},
		{
            "language" : "OBJCXX",
			"compiler" :
			{
				"id" : "MINGW64",
				"implicit" :
				{
					"includeDirectories" :
					[
						"C:/msys64/mingw64/include/c++/13.1.0",
						"C:/msys64/mingw64/include/c++/13.1.0/x86_64-w64-mingw32",
						"C:/msys64/mingw64/include/c++/13.1.0/backward",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include",
						"C:/msys64/mingw64/include",
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed"
					],
					"linkDirectories" :
					[
						"C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0",
						"C:/msys64/mingw64/lib/gcc",
						"C:/msys64/mingw64/x86_64-w64-mingw32/lib",
						"C:/msys64/mingw64/lib"
					],
					"linkFrameworkDirectories" : [],
					"linkLibraries" :
					[
						"stdc++",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32",
						"pthread",
						"advapi32",
						"shell32",
						"user32",
						"kernel32",
						"mingw32",
						"gcc_s",
						"gcc",
						"moldname",
						"mingwex",
						"kernel32"
					]
				},
				"path" : "C:/msys64/mingw64/bin/x86_64-w64-mingw32-c++.exe",
				"target" : "x86_64-w64-mingw32",
				"version" : ""
			},
			"sourceFileExtensions" :
			[
				"M",
				"mm"
			]
		},
		{
            "language" : "RC",
			"compiler" :
			{
				"implicit" : {},
				"path" : "C:/msys64/mingw64/bin/windres.exe",
				"target" : "x86_64-w64-mingw32"
			},
			"sourceFileExtensions" :
			[
				"rc",
				"RC"
			]
		}
	],
	"version" :
	{
		"major" : 1,
		"minor" : 0
	}
}

]===]
