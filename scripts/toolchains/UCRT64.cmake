if(NOT _MSYS_UCRT64_TOOLCHAIN)
	set(_MSYS_UCRT64_TOOLCHAIN 1)

	message(STATUS "MinGW UCRT x64 toolchain loading...")

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

	# Detect <Z_MSYS_ROOT_DIR>/ucrt64.ini to figure UCRT64_ROOT_DIR
	set(Z_UCRT64_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
	while(NOT DEFINED Z_UCRT64_ROOT_DIR)
		if(EXISTS "${Z_UCRT64_ROOT_DIR_CANDIDATE}msys64/ucrt64.ini")
			set(Z_UCRT64_ROOT_DIR "${Z_UCRT64_ROOT_DIR_CANDIDATE}msys64/ucrt64" CACHE INTERNAL "MinGW UCRT x64 root directory")
		elseif(IS_DIRECTORY "${Z_UCRT64_ROOT_DIR_CANDIDATE}")
			get_filename_component(Z_UCRT64_ROOT_DIR_TEMP "${Z_UCRT64_ROOT_DIR_CANDIDATE}" DIRECTORY)
			if(Z_UCRT64_ROOT_DIR_TEMP STREQUAL Z_UCRT64_ROOT_DIR_CANDIDATE)
				break() # If unchanged, we have reached the root of the drive without finding vcpkg.
			endif()
			set(Z_UCRT64_ROOT_DIR_CANDIDATE "${Z_UCRT64_ROOT_DIR_TEMP}")
			unset(Z_UCRT64_ROOT_DIR_TEMP)
		else()
			message(WARNING "Could not find 'ucrt64.ini'... Check your installation!")
			break()
		endif()
	endwhile()
	unset(Z_UCRT64_ROOT_DIR_CANDIDATE)

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

	# add_definitions(-D__USE_MINGW_ANSI_STDIO=1)

	foreach(lang C CXX) # ASM Fortran OBJC OBJCXX

		set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

	endforeach()

	set(CMAKE_MAKE_PROGRAM "${Z_UCRT64_ROOT_DIR}/bin/mingw32-make.exe" CACHE FILEPATH "Tool that can launch the native build system." FORCE)
	set(Z_UCRT64_C_COMPILER_NAME "GNU" CACHE STRING "<C> Compiler NAME string")
	set(Z_UCRT64_C_COMPILER_VERSION "13.2.0" CACHE STRING "<C> Compiler version string")
	set(Z_UCRT64_C_COMPILER_ID "${Z_UCRT64_C_COMPILER_NAME} ${Z_UCRT64_C_COMPILER_VERSION}" CACHE STRING "<C> Compiler ID string")
	mark_as_advanced(Z_UCRT64_C_COMPILER_NAME)
	mark_as_advanced(Z_UCRT64_C_COMPILER_VERSION)
	mark_as_advanced(Z_UCRT64_C_COMPILER_ID)

	set(Z_UCRT64_C_STANDARD_LIBRARIES)
	string(APPEND Z_UCRT64_C_STANDARD_LIBRARIES
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
	string(STRIP "${Z_UCRT64_C_STANDARD_LIBRARIES}" Z_UCRT64_C_STANDARD_LIBRARIES)
	set(Z_UCRT64_C_STANDARD_LIBRARIES "${Z_UCRT64_C_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <C>." FORCE)

	set(Z_UCRT64_C90_COMPILE_FEATURES "c_std_90")
	list(APPEND Z_UCRT64_C90_COMPILE_FEATURES "c_function_prototypes")
	set(Z_UCRT64_C90_COMPILE_FEATURES "${Z_UCRT64_C90_COMPILE_FEATURES}" CACHE STRING "" FORCE)
	mark_as_advanced(Z_UCRT64_C90_COMPILE_FEATURES)

	set(Z_UCRT64_C99_COMPILE_FEATURES "c_std_99")
	list(APPEND Z_UCRT64_C99_COMPILE_FEATURES "c_restrict" "c_variadic_macros")
	set(Z_UCRT64_C99_COMPILE_FEATURES "${Z_UCRT64_C99_COMPILE_FEATURES}" CACHE STRING "" FORCE)
	mark_as_advanced(Z_UCRT64_C99_COMPILE_FEATURES)

	set(Z_UCRT64_C11_COMPILE_FEATURES "c_std_11")
	list(APPEND Z_UCRT64_C11_COMPILE_FEATURES "c_static_assert")
	set(Z_UCRT64_C11_COMPILE_FEATURES "${Z_UCRT64_C11_COMPILE_FEATURES}" CACHE STRING "" FORCE)
	mark_as_advanced(Z_UCRT64_C11_COMPILE_FEATURES)

	set(Z_UCRT64_C17_COMPILE_FEATURES "c_std_17")
	mark_as_advanced(Z_UCRT64_C17_COMPILE_FEATURES)

	set(Z_UCRT64_C23_COMPILE_FEATURES "c_std_23")
	mark_as_advanced(Z_UCRT64_C23_COMPILE_FEATURES)

	set(Z_UCRT64_C_COMPILE_FEATURES)
	list(APPEND Z_UCRT64_C_COMPILE_FEATURES
		"${Z_UCRT64_C90_COMPILE_FEATURES}"
		"${Z_UCRT64_C99_COMPILE_FEATURES}"
		"${Z_UCRT64_C11_COMPILE_FEATURES}"
		"${Z_UCRT64_C17_COMPILE_FEATURES}"
		"${Z_UCRT64_C23_COMPILE_FEATURES}"
	)
	set(Z_UCRT64_C_COMPILE_FEATURES "${Z_UCRT64_C_COMPILE_FEATURES}" CACHE STRING "List of features known to the compiler <C>." FORCE)
	mark_as_advanced(Z_UCRT64_C_COMPILE_FEATURES)


	set(Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES)
	list(APPEND Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}/include"
		"${Z_UCRT64_ROOT_DIR}/include"
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}/include-fixed"
	)
	set(Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files.")
	mark_as_advanced(Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES)

	set(Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES)
	list(APPEND Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}"
		"${Z_UCRT64_ROOT_DIR}/lib/gcc"
		"${Z_UCRT64_ROOT_DIR}/x86_64-w64-mingw32/lib"
		"${Z_UCRT64_ROOT_DIR}/lib"
	)
	set(Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>.")
	mark_as_advanced(Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES)

	set(Z_UCRT64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <C>.")
	mark_as_advanced(Z_UCRT64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

	set(Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES)
	list(APPEND Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES
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
	set(Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES "${Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>.")
	mark_as_advanced(Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES)

	set(Z_UCRT64_C_SOURCE_FILE_EXTENSIONS)
	list(APPEND Z_UCRT64_C_SOURCE_FILE_EXTENSIONS "c" "m")
	set(Z_UCRT64_C_SOURCE_FILE_EXTENSIONS "${Z_UCRT64_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>.")
	mark_as_advanced(Z_UCRT64_C_SOURCE_FILE_EXTENSIONS)

	find_program(Z_UCRT64_C_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc-${Z_UCRT64_C_COMPILER_VERSION}.exe")
	mark_as_advanced(Z_UCRT64_C_COMPILER)


	set(CMAKE_C_COMPILE_FEATURES 												"${Z_UCRT64_C_COMPILE_FEATURES}" CACHE STRING "List of features known to the C compiler." FORCE)
	set(CMAKE_C90_COMPILE_FEATURES 												"${Z_UCRT64_C90_COMPILE_FEATURES}" CACHE STRING "List of C90 features known to the C compiler." FORCE)
	set(CMAKE_C99_COMPILE_FEATURES 												"${Z_UCRT64_C99_COMPILE_FEATURES}" CACHE STRING "List of C99 features known to the C compiler." FORCE)
	set(CMAKE_C11_COMPILE_FEATURES 												"${Z_UCRT64_C11_COMPILE_FEATURES}" CACHE STRING "List of C11 features known to the C compiler." FORCE)
	set(CMAKE_C17_COMPILE_FEATURES 												"${Z_UCRT64_C17_COMPILE_FEATURES}" CACHE STRING "List of C17 features known to the C compiler." FORCE)
	set(CMAKE_C23_COMPILE_FEATURES 												"${Z_UCRT64_C23_COMPILE_FEATURES}" CACHE STRING "List of C23 features known to the C compiler." FORCE)

	set(CMAKE_C_STANDARD_LIBRARIES 												"${Z_UCRT64_C_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <C>." FORCE)
	set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES 									"${Z_UCRT64_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files.")
	set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES 										"${Z_UCRT64_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>.")
	set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES 							"${Z_UCRT64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES}" CACHE PATH "Implicit linker framework search path detected for language <C>.")
	set(CMAKE_C_IMPLICIT_LINK_LIBRARIES 										"${Z_UCRT64_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>.")
	set(CMAKE_C_SOURCE_FILE_EXTENSIONS 											"${Z_UCRT64_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>.")
	set(CMAKE_C_COMPILER 														"${Z_UCRT64_C_COMPILER}" CACHE FILEPATH "The full path to the compiler for <C>." FORCE)

	mark_as_advanced(CMAKE_C_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C90_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C99_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C11_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C17_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C23_COMPILE_FEATURES)
	mark_as_advanced(CMAKE_C_STANDARD_LIBRARIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
	mark_as_advanced(CMAKE_C_IMPLICIT_LINK_LIBRARIES)
	mark_as_advanced(CMAKE_C_SOURCE_FILE_EXTENSIONS)
	mark_as_advanced(CMAKE_C_COMPILER)


	set(Z_UCRT64_CXX_STANDARD_LIBRARIES)
	string(APPEND Z_UCRT64_CXX_STANDARD_LIBRARIES
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
	string(STRIP "${Z_UCRT64_CXX_STANDARD_LIBRARIES}" Z_UCRT64_CXX_STANDARD_LIBRARIES)
	set(Z_UCRT64_CXX_STANDARD_LIBRARIES "${Z_UCRT64_CXX_STANDARD_LIBRARIES}" CACHE STRING "Libraries linked into every executable and shared library linked for language <CXX>." FORCE)


	set(Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
	list(APPEND Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES
		"${Z_UCRT64_ROOT_DIR}/include/c++/${Z_UCRT64_C_COMPILER_VERSION}"
		"${Z_UCRT64_ROOT_DIR}/include/c++/${Z_UCRT64_C_COMPILER_VERSION}/x86_64-w64-mingw32"
		"${Z_UCRT64_ROOT_DIR}/include/c++/${Z_UCRT64_C_COMPILER_VERSION}/backward"
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}/include"
		"${Z_UCRT64_ROOT_DIR}/include"
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}/include-fixed")
	set(Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <CXX>.")
	mark_as_advanced(Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES)

	set(Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES)
	list(APPEND Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES
		"${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${Z_UCRT64_C_COMPILER_VERSION}"
		"${Z_UCRT64_ROOT_DIR}/lib/gcc"
		"${Z_UCRT64_ROOT_DIR}/x86_64-w64-mingw32/lib"
		"${Z_UCRT64_ROOT_DIR}/lib")
	set(Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>.")
	mark_as_advanced(Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES)

	set(Z_UCRT64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <CXX>.")
	mark_as_advanced(Z_UCRT64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

	set(Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES)
	list(APPEND Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES
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
	set(Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES "${Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>.")
	mark_as_advanced(Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES)

	set(Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS)
	list(APPEND Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS
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
	set(Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS "${Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <CXX>.")
	mark_as_advanced(Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS)

	find_program(Z_UCRT64_CXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
	mark_as_advanced(Z_UCRT64_CXX_COMPILER)

	set(CMAKE_CXX_STANDARD_LIBRARIES 											"${Z_UCRT64_CXX_STANDARD_LIBRARIES}" CACHE PATH "Libraries linked into every executable and shared library linked for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES 									"${Z_UCRT64_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <Cxx>.")
	set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES 									"${Z_UCRT64_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES 							"${Z_UCRT64_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES}" CACHE PATH "Implicit linker framework search path detected for language <CXX>.")
	set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES 										"${Z_UCRT64_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>.")
	set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS 										"${Z_UCRT64_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <CXX>.")
	set(CMAKE_CXX_COMPILER 														"${Z_UCRT64_CXX_COMPILER}" CACHE FILEPATH "The full path to the compiler for <CXX>." FORCE)

	mark_as_advanced(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
	mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)
	mark_as_advanced(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)
	mark_as_advanced(CMAKE_CXX_COMPILER)

	# #"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
	# find_program(CMAKE_Fortran_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gfortran.exe")
	# mark_as_advanced(CMAKE_Fortran_COMPILER)

	# find_program(CMAKE_OBJC_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
	# mark_as_advanced(CMAKE_OBJC_COMPILER)

	# #"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
	# find_program(CMAKE_OBJCXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
	# mark_as_advanced(CMAKE_OBJCXX_COMPILER)

	# #"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
	# if(NOT DEFINED CMAKE_ASM_COMPILER)
	# 	find_program(CMAKE_ASM_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/as.exe")
	# 	mark_as_advanced(CMAKE_ASM_COMPILER)
	# endif()

	#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
	find_program(CMAKE_RC_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/windres.exe")
	mark_as_advanced(CMAKE_RC_COMPILER)
	if(NOT CMAKE_RC_COMPILER)
		find_program (CMAKE_RC_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/windres" NO_CACHE)
		if(NOT CMAKE_RC_COMPILER)
			find_program(CMAKE_RC_COMPILER "windres" NO_CACHE)
		endif()
	endif()

	get_property(_CMAKE_IN_TRY_COMPILE GLOBAL PROPERTY IN_TRY_COMPILE)

	# The following flags come from 'PORT' files (i.e., build config files for packages)
	if(NOT _CMAKE_IN_TRY_COMPILE)

		# if(NOT DEFINED LDFLAGS)
		#     set(LDFLAGS)
		# endif()
		# string(APPEND LDFLAGS "-pipe ") # Use pipes rather than intermediate files.
		# string(STRIP "${LDFLAGS}" LDFLAGS)
		# # set(ENV{LDFLAGS} "${LDFLAGS}")
		# unset(LDFLAGS)
		# # message(STATUS "LDFLAGS = $ENV{LDFLAGS}")

		# if(NOT DEFINED CFLAGS)
		#     set(CFLAGS) # Start a new list, if one doesn't exists
		# endif()
		# string(APPEND CFLAGS "-march=nocona ")
		# string(APPEND CFLAGS "-msahf ")
		# string(APPEND CFLAGS "-mtune=generic ")
		# string(APPEND CFLAGS "-pipe ") # Use pipes rather than intermediate files.
		# string(APPEND CFLAGS "-Wp,-D_FORTIFY_SOURCE=2 ")
		# string(APPEND CFLAGS "-fstack-protector-strong ")
		# string(STRIP "${CFLAGS}" CFLAGS)
		# # set(ENV{CFLAGS} "${CFLAGS}")
		# unset(CFLAGS)
		# # message(STATUS "CFLAGS = $ENV{CFLAGS}")

		# if(NOT DEFINED CXXFLAGS)
		#     set(CXXFLAGS)
		# endif()
		# string(APPEND CXXFLAGS "-march=nocona ")
		# string(APPEND CXXFLAGS "-msahf ")
		# string(APPEND CXXFLAGS "-mtune=generic ")
		# # string(APPEND CXXFLAGS "-std=") # STD version
		# # string(APPEND CXXFLAGS "-stdlib=") # STD lib
		# string(APPEND CXXFLAGS "-pipe ")
		# string(STRIP "${CXXFLAGS}" CXXFLAGS)
		# # set(ENV{CXXFLAGS} "${CXXFLAGS}")
		# unset(CXXFLAGS)
		# # message(STATUS "CXXFLAGS = $ENV{CXXFLAGS}")

		# if(NOT DEFINED CPPFLAGS)
		#     set(CPPFLAGS)
		# endif()
		# string(APPEND CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1 ")
		# string(STRIP "${CPPFLAGS}" CPPFLAGS)
		# set(ENV{CPPFLAGS} "${CPPFLAGS}")
		# unset(CPPFLAGS)
		# # message(STATUS "CPPFLAGS = $ENV{CPPFLAGS}")

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

	message(STATUS "MinGW UCRT x64 toolchain loaded")

	endif()

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

		# Initial configuration flags.
		# foreach(lang C) # ASM Fortran OBJC OBJCXX
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=nocona")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -msahf")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
		#     string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
		#     if(${lang} STREQUAL C)
		#         string(APPEND CMAKE_${lang}_FLAGS_INIT " -Wp,-D_FORTIFY_SOURCE=2")
		#         string(APPEND CMAKE_${lang}_FLAGS_INIT " -fstack-protector-strong")
		#     endif()
		# endforeach()

	# set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/ucrt64/include;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
	# set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "mingw32;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc;moldname;mingwex;kernel32")
	# set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/ucrt64/lib/gcc;C:/msys64/ucrt64/x86_64-w64-mingw32/lib;C:/msys64/ucrt64/lib")
	# set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")

	# set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/ucrt64/include/c++/13.1.0;C:/msys64/ucrt64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/ucrt64/include/c++/13.1.0/backward;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/ucrt64/include;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
	# set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "stdc++;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32")
	# set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/ucrt64/lib/gcc;C:/msys64/ucrt64/x86_64-w64-mingw32/lib;C:/msys64/ucrt64/lib")
	# set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")

	# set(CMAKE_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/ucrt64/include;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
	# set(CMAKE_Fortran_IMPLICIT_LINK_LIBRARIES "gfortran;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;quadmath;m;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32")
	# set(CMAKE_Fortran_IMPLICIT_LINK_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/ucrt64/lib/gcc;C:/msys64/ucrt64/x86_64-w64-mingw32/lib;C:/msys64/ucrt64/lib")
	# set(CMAKE_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")

	# set(CMAKE_OBJC_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/ucrt64/include;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
	# set(CMAKE_OBJC_IMPLICIT_LINK_LIBRARIES "mingw32;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc;moldname;mingwex;kernel32")
	# set(CMAKE_OBJC_IMPLICIT_LINK_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/ucrt64/lib/gcc;C:/msys64/ucrt64/x86_64-w64-mingw32/lib;C:/msys64/ucrt64/lib")
	# set(CMAKE_OBJC_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")

	# set(CMAKE_OBJCXX_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/ucrt64/include/c++/13.1.0;C:/msys64/ucrt64/include/c++/13.1.0/x86_64-w64-mingw32;C:/msys64/ucrt64/include/c++/13.1.0/backward;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/ucrt64/include;C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
	# set(CMAKE_OBJCXX_IMPLICIT_LINK_LIBRARIES "mingw32;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc;moldname;mingwex;kernel32")
	# set(CMAKE_OBJCXX_IMPLICIT_LINK_DIRECTORIES "C:/msys64/ucrt64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/ucrt64/lib/gcc;C:/msys64/ucrt64/x86_64-w64-mingw32/lib;C:/msys64/ucrt64/lib")
	# set(CMAKE_OBJCXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
