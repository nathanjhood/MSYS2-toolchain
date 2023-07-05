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

# set(MINGW64 1)

# also add the install directory of the running cmake to the search directories
# CMAKE_ROOT is CMAKE_INSTALL_PREFIX/share/cmake, so we need to go two levels up
get_filename_component(_CMAKE_INSTALL_DIR "${CMAKE_ROOT}" PATH)
get_filename_component(_CMAKE_INSTALL_DIR "${_CMAKE_INSTALL_DIR}" PATH)

# List common installation prefixes.  These will be used for all
# search types.
set(CMAKE_SYSTEM_PREFIX_PATH)
#
# Reminder when adding new locations computed from environment variables
# please make sure to keep Help/variable/CMAKE_SYSTEM_PREFIX_PATH.rst
# synchronized
list(APPEND CMAKE_SYSTEM_PREFIX_PATH
    # Standard
    "${Z_${MSYSTEM}_ROOT_DIR}/usr/local"
    "${Z_${MSYSTEM}_ROOT_DIR}/usr"
    "${Z_${MSYSTEM}_ROOT_DIR}/"

    # CMake install location
    "${_CMAKE_INSTALL_DIR}"
)
if (NOT CMAKE_FIND_NO_INSTALL_PREFIX)

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
    # "${Z_${MSYSTEM}_ROOT_DIR}/usr/X11R6"
    # "${Z_${MSYSTEM}_ROOT_DIR}/usr/pkg"
    # "${Z_${MSYSTEM}_ROOT_DIR}/opt"
    "${Z_${MSYSTEM}_ROOT_DIR}/x86_64-w64-mingw32"
)

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

# if(ENABLE_${MSYSTEM})
#     set(${MSYSTEM}_ROOT                    "${Z_${MSYSTEM}_ROOT_DIR}")            # CACHE PATH      "<MINGW64>: Root of the build system." FORCE)

#     set(${MSYSTEM}_PREFIX                  "${MINGW64_ROOT}")                  # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(${MSYSTEM}_BUILD_PREFIX            "${MINGW64_PREFIX}/usr")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_INSTALL_PREFIX          "${MINGW64_PREFIX}/usr/local")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_INCLUDEDIR              "${MINGW64_PREFIX}/include")        # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SRCDIR                  "${MINGW64_PREFIX}/src")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SYSCONFDIRDIR           "${MINGW64_PREFIX}/etc")            # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_DATAROOTDIR             "${MINGW64_PREFIX}/share")          # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_DATADIR                 "${MINGW64_DATAROOTDIR}")           # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_DOCDIR                  "${MINGW64_DATAROOTDIR}/doc")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_MANDIR                  "${MINGW64_DATAROOTDIR}/man")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_INFODIR                 "${MINGW64_DATAROOTDIR}/info")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LOCALEDIR               "${MINGW64_DATAROOTDIR}/locale")    # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_CMAKEDIR                "${MINGW64_DATAROOTDIR}/cmake")     # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     set(MINGW64_EXEC_PREFIX             "${MINGW64_PREFIX}")                # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_BINDIR                  "${MINGW64_EXEC_PREFIX}/bin")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_SBINDIR                 "${MINGW64_EXEC_PREFIX}/sbin")      # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LIBDIR                  "${MINGW64_EXEC_PREFIX}/lib")       # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)
#     set(MINGW64_LIBEXECDIR              "${MINGW64_EXEC_PREFIX}/libexec")   # CACHE PATH      "<MINGW64>: Sub-system prefix." FORCE)

#     # DirectX compatibility environment variable
#     set(MINGW64_DXSDK_DIR               "${MINGW64_ROOT}/x86_64-w64-mingw32")   # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

#     # set(ACLOCAL_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/aclocal" "${Z_MSYS_ROOT}/usr/share" CACHE PATH "By default, aclocal searches for .m4 files in the following directories." FORCE)
#     set(MINGW64_ACLOCAL_PATH)
#     list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/share/aclocal")
#     list(APPEND MINGW64_ACLOCAL_PATH "${Z_MINGW64_ROOT_DIR}/usr/share")
#     set(MINGW64_ACLOCAL_PATH "${MINGW64_ACLOCAL_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)

#     # set(PKG_CONFIG_PATH "${Z_MSYS_ROOT}/${MINGW_PREFIX}/lib/pkgconfig" "${Z_MSYS_ROOT}/${MINGW_PREFIX}/share/pkgconfig" CACHE PATH "A colon-separated (on Windows, semicolon-separated) list of directories to search for .pc files. The default directory will always be searched after searching the path." FORCE)
#     set(MINGW64_PKG_CONFIG_PATH)
#     list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/lib/pkgconfig")
#     list(APPEND MINGW64_PKG_CONFIG_PATH "${Z_MINGW64_ROOT_DIR}/share/pkgconfig")
#     set(MINGW64_PKG_CONFIG_PATH "${MINGW64_PKG_CONFIG_PATH}") # CACHE PATH "<MINGW64>: DirectX compatibility environment variable." FORCE)
# endif()

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
