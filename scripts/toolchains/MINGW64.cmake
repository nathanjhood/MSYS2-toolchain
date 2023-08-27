if(NOT _MSYS_MINGW64_TOOLCHAIN)
	set(_MSYS_MINGW64_TOOLCHAIN 1)

	message(STATUS "MinGW GNU x64 toolchain loading...")

	set(CMAKE_SYSTEM_NAME "Windows" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)

	if(CMAKE_HOST_SYSTEM_NAME STREQUAL "Windows")
		set(CMAKE_CROSSCOMPILING OFF CACHE BOOL "")
	endif()

	if(MSYS_TARGET_ARCHITECTURE STREQUAL "x86")
		set(CMAKE_SYSTEM_PROCESSOR i686 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
	elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "x64")
		set(CMAKE_SYSTEM_PROCESSOR x86_64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
	elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm")
		set(CMAKE_SYSTEM_PROCESSOR armv7 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
	elseif(MSYS_TARGET_ARCHITECTURE STREQUAL "arm64")
		set(CMAKE_SYSTEM_PROCESSOR aarch64 CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable.")
	endif()

	# Detect <Z_MSYS_ROOT_DIR>/mingw64.ini to figure MINGW64_ROOT_DIR
	set(Z_MINGW64_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
	while(NOT DEFINED Z_MINGW64_ROOT_DIR)
		if(EXISTS "${Z_MINGW64_ROOT_DIR_CANDIDATE}msys64/mingw64.ini")
			set(Z_MINGW64_ROOT_DIR "${Z_MINGW64_ROOT_DIR_CANDIDATE}msys64/mingw64" CACHE INTERNAL "MinGW64 root directory")
		elseif(IS_DIRECTORY "${Z_MINGW64_ROOT_DIR_CANDIDATE}")
			get_filename_component(Z_MINGW64_ROOT_DIR_TEMP "${Z_MINGW64_ROOT_DIR_CANDIDATE}" DIRECTORY)
			if(Z_MINGW64_ROOT_DIR_TEMP STREQUAL Z_MINGW64_ROOT_DIR_CANDIDATE)
				break() # If unchanged, we have reached the root of the drive without finding <Z_MSYS_ROOT_DIR>/mingw64.ini.
			endif()
			set(Z_MINGW64_ROOT_DIR_CANDIDATE "${Z_MINGW64_ROOT_DIR_TEMP}")
			unset(Z_MINGW64_ROOT_DIR_TEMP)
		else()
			message(WARNING "Could not find 'mingw64.ini'... Check your installation!")
			break()
		endif()
	endwhile()
	unset(Z_MINGW64_ROOT_DIR_CANDIDATE)

	# set(CMAKE_SYSROOT "${Z_MINGW64_ROOT_DIR}" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag." FORCE)
	# set(CMAKE_SYSROOT_COMPILE "${Z_MINGW64_ROOT_DIR}" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag when compiling source files." FORCE)
	# set(CMAKE_SYSROOT_LINK "${Z_MINGW64_ROOT_DIR}" CACHE PATH "Path to pass to the compiler in the ``--sysroot`` flag when compiling source files." FORCE)

	# ## Set Env vars
	# set(ENV{CARCH} "x86_64")
	# set(ENV{CHOST} "x86_64-w64-mingw32")
	# set(ENV{CC} "gcc")
	# set(ENV{CXX} "g++")
	# set(ENV{CPPFLAGS} "-D__USE_MINGW_ANSI_STDIO=1")
	# set(ENV{CFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
	# set(ENV{CXXFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe")
	# set(ENV{LDFLAGS} "-pipe")
	# set(ENV{DEBUG_CFLAGS} "-ggdb -Og")
	# set(ENV{DEBUG_CXXFLAGS} "-ggdb -Og")

	foreach(lang C CXX Fortran OBJC OBJCXX ASM)

		set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")
		#set(CMAKE_USER_MAKE_RULES_OVERRIDE_${lang} Compiler/MINGW64-FindBinUtils)

	endforeach()

	set(CMAKE_MAKE_PROGRAM "${Z_MINGW64_ROOT_DIR}/bin/mingw32-make.exe" CACHE FILEPATH "Tool that can launch the native build system." FORCE)
	set(Z_MINGW64_C_COMPILER_NAME "GNU" CACHE STRING "<C> Compiler NAME string")
	set(Z_MINGW64_C_COMPILER_VERSION "13.2.0" CACHE STRING "<C> Compiler version string")
	set(Z_MINGW64_C_COMPILER_ID "${Z_MINGW64_C_COMPILER_NAME} ${Z_MINGW64_C_COMPILER_VERSION}" CACHE STRING "<C> Compiler ID string")
	mark_as_advanced(Z_MINGW64_C_COMPILER_NAME)
	mark_as_advanced(Z_MINGW64_C_COMPILER_VERSION)
	mark_as_advanced(Z_MINGW64_C_COMPILER_ID)

	set(Z_MINGW64_C_STANDARD_LIBRARIES)
	string(APPEND Z_MINGW64_C_STANDARD_LIBRARIES
		"-lmingw32" " "
		"-lgcc" " "
		"-lmoldname" " "
		"-lmingwex" " "
		"-lkernel32" " "
		"-lpthread" " "
		"-ladvapi32" " "
		"-lshell32" " "
		"-luser32" " "

		"-lgdi32" " "
		"-lwinspool" " "
		"-lole32" " "
		"-loleaut32" " "
		"-luuid" " "
		"-lcomdlg32" " "
	)
	string(STRIP "${Z_MINGW64_C_STANDARD_LIBRARIES}" Z_MINGW64_C_STANDARD_LIBRARIES)
	set(Z_MINGW64_C_STANDARD_LIBRARIES "${Z_MINGW64_C_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <C>." FORCE)

	set(Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES)
	list(APPEND Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}/include"
		"${Z_MINGW64_ROOT_DIR}/include"
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}/include-fixed"
	)
	set(Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files.")
	mark_as_advanced(Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES)

	set(Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES)
	list(APPEND Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}"
		"${Z_MINGW64_ROOT_DIR}/lib/gcc"
		"${Z_MINGW64_ROOT_DIR}/x86_64-w64-mingw32/lib"
		"${Z_MINGW64_ROOT_DIR}/lib"
	)
	set(Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>.")
	mark_as_advanced(Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES)

	set(Z_MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <C>.")
	mark_as_advanced(Z_MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

	set(Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES)
	list(APPEND Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES
		"mingw32"
		"gcc"
		"moldname"
		"mingwex"
		"kernel32"
		"pthread"
		"advapi32"
		"shell32"
		"user32"

		"gdi32"
		"winspool"
		"ole32"
		"oleaut32"
		"uuid"
		"comdlg32"
	)
	set(Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES "${Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>.")
	mark_as_advanced(Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES)

	set(Z_MINGW64_C_SOURCE_FILE_EXTENSIONS)
	list(APPEND Z_MINGW64_C_SOURCE_FILE_EXTENSIONS "c" "m")
	set(Z_MINGW64_C_SOURCE_FILE_EXTENSIONS "${Z_MINGW64_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>.")
	mark_as_advanced(Z_MINGW64_C_SOURCE_FILE_EXTENSIONS)

	find_program(Z_MINGW64_C_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc-${Z_MINGW64_C_COMPILER_VERSION}.exe")
	mark_as_advanced(Z_MINGW64_C_COMPILER)

	set(CMAKE_C_STANDARD_LIBRARIES 												"${Z_MINGW64_C_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <C>." FORCE)
	set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES 									"${Z_MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files.")
	set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES 										"${Z_MINGW64_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>.")
	set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES 							"${Z_MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES}" CACHE PATH "Implicit linker framework search path detected for language <C>.")
	set(CMAKE_C_IMPLICIT_LINK_LIBRARIES 										"${Z_MINGW64_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>.")
	set(CMAKE_C_SOURCE_FILE_EXTENSIONS 											"${Z_MINGW64_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>.")
	set(CMAKE_C_COMPILER 														"${Z_MINGW64_C_COMPILER}" CACHE FILEPATH "The full path to the compiler for <C>." FORCE)

	mark_as_advanced(CMAKE_C_STANDARD_LIBRARIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_LIBRARIES)
	mark_as_advanced(CMAKE_C_SOURCE_FILE_EXTENSIONS)
	mark_as_advanced(CMAKE_C_COMPILER)


	set(Z_MINGW64_CXX_STANDARD_LIBRARIES)
	string(APPEND Z_MINGW64_CXX_STANDARD_LIBRARIES
		"-lstdc++" " "
		"-lmingw32" " "
		"-lgcc_s" " "
		"-lgcc" " "
		"-lmoldname" " "
		"-lmingwex" " "
		"-lkernel32" " "
		"-lpthread" " "
		"-ladvapi32" " "
		"-lshell32" " "
		"-luser32" " "

		"-lgdi32" " "
		"-lwinspool" " "
		"-lole32" " "
		"-loleaut32" " "
		"-luuid" " "
		"-lcomdlg32" " "
	)
	string(STRIP "${Z_MINGW64_CXX_STANDARD_LIBRARIES}" Z_MINGW64_CXX_STANDARD_LIBRARIES)
	set(Z_MINGW64_CXX_STANDARD_LIBRARIES "${Z_MINGW64_CXX_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <CXX>." FORCE)


	set(Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
	list(APPEND Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES
		"${Z_MINGW64_ROOT_DIR}/include/c++/${Z_MINGW64_C_COMPILER_VERSION}"
		"${Z_MINGW64_ROOT_DIR}/include/c++/${Z_MINGW64_C_COMPILER_VERSION}/x86_64-w64-mingw32"
		"${Z_MINGW64_ROOT_DIR}/include/c++/${Z_MINGW64_C_COMPILER_VERSION}/backward"
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}/include"
		"${Z_MINGW64_ROOT_DIR}/include"
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}/include-fixed")
	set(Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <CXX>.")
	mark_as_advanced(Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES)

	set(Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES)
	list(APPEND Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES
		"${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_MINGW64_C_COMPILER_VERSION}"
		"${Z_MINGW64_ROOT_DIR}/lib/gcc"
		"${Z_MINGW64_ROOT_DIR}/x86_64-w64-mingw32/lib"
		"${Z_MINGW64_ROOT_DIR}/lib")
	set(Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>.")
	mark_as_advanced(Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES)

	set(Z_MINGW64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <CXX>.")
	mark_as_advanced(Z_MINGW64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

	set(Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES)
	list(APPEND Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES
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

		"gdi32"
		"winspool"
		"ole32"
		"oleaut32"
		"uuid"
		"comdlg32"
	)
	set(Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES "${Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>.")
	mark_as_advanced(Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES)

	set(Z_MINGW64_CXX_SOURCE_FILE_EXTENSIONS)
	list(APPEND Z_MINGW64_CXX_SOURCE_FILE_EXTENSIONS
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
	set(Z_MINGW64_CXX_SOURCE_FILE_EXTENSIONS "${Z_MINGW64_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>." FORCE)
	mark_as_advanced(Z_CLANG64_CXX_SOURCE_FILE_EXTENSIONS)

	find_program(Z_MINGW64_CXX_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
	mark_as_advanced(Z_MINGW64_CXX_COMPILER)

	set(CMAKE_CXX_STANDARD_LIBRARIES 											"${Z_MINGW64_CXX_STANDARD_LIBRARIES}" CACHE PATH "Libraries linked into every executable and shared library linked for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES 									"${Z_MINGW64_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <CXX>.")
	set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES 									"${Z_MINGW64_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES 							"${Z_MINGW64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES}" CACHE PATH "Implicit linker framework search path detected for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES 										"${Z_MINGW64_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>.")
	set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS 										"${Z_MINGW64_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <CXX>.")
	set(CMAKE_CXX_COMPILER 														"${Z_MINGW64_CXX_COMPILER}" CACHE FILEPATH "The full path to the compiler for <CXX>." FORCE)

	mark_as_advanced(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)
	mark_as_advanced(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)
	mark_as_advanced(CMAKE_CXX_COMPILER)

	# #"C:\msys64\mingw64\bin\x86_64-w64-mingw32-gfortran.exe"
	# find_program(CMAKE_Fortran_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gfortran.exe")
	# mark_as_advanced(CMAKE_Fortran_COMPILER)

	# #"C:\msys64\mingw64\bin\x86_64-w64-mingw32-gcc.exe"
	# find_program(CMAKE_OBJC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
	# mark_as_advanced(CMAKE_OBJC_COMPILER)

	# #"C:\msys64\mingw64\bin\x86_64-w64-mingw32-g++.exe"
	# find_program(CMAKE_OBJCXX_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
	# mark_as_advanced(CMAKE_OBJCXX_COMPILER)

	# if(NOT DEFINED CMAKE_ASM_COMPILER)
	# 	find_program(CMAKE_ASM_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/as.exe")
	# endif()
	# mark_as_advanced(CMAKE_ASM_COMPILER)

	find_program(CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres.exe")
	if(NOT CMAKE_RC_COMPILER)
		find_program (CMAKE_RC_COMPILER "${Z_MINGW64_ROOT_DIR}/bin/windres" NO_CACHE)
		if(NOT CMAKE_RC_COMPILER)
			find_program(CMAKE_RC_COMPILER "windres" NO_CACHE)
		endif()
	endif()
	mark_as_advanced(CMAKE_RC_COMPILER)

	get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE )

	# The following flags come from 'PORT' files (i.e., build config files for packages)
	if(NOT _CMAKE_IN_TRY_COMPILE)

		# set(LDFLAGS)
		# string(APPEND LDFLAGS " -pipe")
		# set(LDFLAGS "${LDFLAGS}")
		# set(ENV{LDFLAGS} "${LDFLAGS}")

		# set(CFLAGS)
		# string(APPEND CFLAGS " -march=nocona")
		# string(APPEND CFLAGS " -msahf")
		# string(APPEND CFLAGS " -mtune=generic")
		# string(APPEND CFLAGS " -pipe")
		# string(APPEND CFLAGS " -Wp,-D_FORTIFY_SOURCE=2")
		# string(APPEND CFLAGS " -fstack-protector-strong")
		# set(CFLAGS "${CFLAGS}")
		# set(ENV{CFLAGS} "${CFLAGS}")

		# set(CXXFLAGS)
		# string(APPEND CXXFLAGS " -march=nocona")
		# string(APPEND CXXFLAGS " -msahf")
		# string(APPEND CXXFLAGS " -mtune=generic")
		# string(APPEND CXXFLAGS " -pipe")
		# set(CXXFLAGS "${CXXFLAGS}")
		# set(ENV{CXXFLAGS} "${CXXFLAGS}")

		# # Initial configuration flags.
		# foreach(lang C CXX ASM Fortran OBJC OBJCXX)
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=nocona")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -msahf")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
		#     if(${lang} STREQUAL C)
		#         string(APPEND CMAKE_${lang}_FLAGS_INIT " -Wp,-D_FORTIFY_SOURCE=2")
		#         string(APPEND CMAKE_${lang}_FLAGS_INIT " -fstack-protector-strong")
		#     endif()
		# endforeach()

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

	message(STATUS "MinGW GNU x64 toolchain loaded")

	endif()
