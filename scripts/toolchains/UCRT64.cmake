if(NOT _MSYS_UCRT64_TOOLCHAIN)
set(_MSYS_UCRT64_TOOLCHAIN 1)

message(STATUS "MinGW UCRT x64 toolchain loading...")

# Need to override MinGW from MSYS_CMAKE_SYSTEM_NAME
set(CMAKE_SYSTEM_NAME "MSYSTEM" CACHE STRING "The name of the operating system for which CMake is to build." FORCE)

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

## Set Env vars
set(ENV{CARCH} "x86_64")
set(ENV{CHOST} "x86_64-w64-mingw32")
set(ENV{CC} "gcc")
set(ENV{CXX} "g++")
set(ENV{CPPFLAGS} "-D__USE_MINGW_ANSI_STDIO=1")
set(ENV{CFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
set(ENV{CXXFLAGS} "-march=nocona -msahf -mtune=generic -O2 -pipe")
set(ENV{LDFLAGS} "-pipe")
set(ENV{DEBUG_CFLAGS} "-ggdb -Og")
set(ENV{DEBUG_CXXFLAGS} "-ggdb -Og")

foreach(lang C CXX) # ASM Fortran OBJC OBJCXX

    set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

endforeach()
    # -std=<value>                Language standard to compile for
    # -stdlib++-isystem <directory> Use directory as the C++ standard library include path
    # -stdlib=<value>             C++ standard library to use
    # -rtlib=<value>              Compiler runtime library to use
    # -shared-libsan              Dynamically link the sanitizer runtime
    # -static-libsan              Statically link the sanitizer runtime

    # -Wa,<options>               Pass comma-separated <options> on to the assembler.
    # -Wp,<options>               Pass comma-separated <options> on to the preprocessor.
    # -Wl,<options>               Pass comma-separated <options> on to the linker.

    # -Xassembler <arg>           Pass <arg> on to the assembler.
    # -Xpreprocessor <arg>        Pass <arg> on to the preprocessor.
    # -Xlinker <arg>              Pass <arg> on to the linker.

    # -save-temps                 Do not delete intermediate files.
    # -save-temps=<arg>           Do not delete intermediate files.

    # -pipe                       Use pipes rather than intermediate files.
    # -time                       Time the execution of each subprocess.
    # -specs=<file>               Override built-in specs with the contents of <file>.
    # -std=<standard>             Assume that the input sources are for <standard>.
    # --sysroot=<directory>       Use <directory> as the root directory for headers and libraries.
    # -B <directory>              Add <directory> to the compiler's search paths.
    # -v                          Display the programs invoked by the compiler.
    # -###                        Like -v but options quoted and commands not executed.
    # -E                          Preprocess only; do not compile, assemble or link.
    # -S                          Compile only; do not assemble or link.
    # -c                          Compile and assemble, but do not link.
    # -o <file>                   Place the output into <file>.
    # -pie                        Create a dynamically linked position independent executable.
    # -shared                     Create a shared library.

    # -x <language>               Specify the language of the following input files.
    #                             Permissible languages include: c c++ assembler none
    #                             'none' means revert to the default behavior of
    #                             guessing the language based on the file's extension.

    # --extra-warnings            Same as -Wextra.
    # --pedantic-errors           Same as -pedantic-errors.

    # -fpic                       Generate position-independent code if possible (small mode).
    # -fPIC                       Generate position-independent code if possible (large mode).
    # -fpie                       Generate position-independent code for executables if possible (small mode).
    # -fPIE                       Generate position-independent code for executables if possible (large mode).
    # -fplt                       Use PLT for PIC calls (-fno-plt: load the address from GOT at call site).

    # -O<number>                  Set optimization level to <number>.
    # -Ofast                      Optimize for speed disregarding exact standards compliance.
    # -Og                         Optimize for debugging experience rather than speed or size.
    # -Os                         Optimize for space rather than speed.
    # -Oz                         Optimize for space aggressively rather than speed.

    # -gtoggle                    Toggle debug information generation.
    # -g                          Generate debug information in default format.
    # -ggdb                       Generate debug information in default extended format.
    # -gbtf                       Generate BTF debug information at default level.
    # -gcodeview                  Generate debug information in CodeView format.
    # -gctf                       Generate CTF debug information at default level.
    # -gvms                       Generate debug information in VMS format.

    # -gdwarf                     Generate debug information in default version of DWARF format.
    # -gdwarf-                    Generate debug information in DWARF v2 (or later) format.
    # -gdwarf32                   Use 32-bit DWARF format when emitting DWARF debug information.
    # -gdwarf64                   Use 64-bit DWARF format when emitting DWARF debug information.
    # -gpubnames                  Generate DWARF pubnames and pubtypes sections.
    # -ggnu-pubnames              Generate DWARF pubnames and pubtypes sections with GNU extensions.
    # -gno-pubnames               Don't generate DWARF pubnames and pubtypes sections.
    # -gstrict-dwarf              Don't emit DWARF additions beyond selected version.
    # -gsplit-dwarf               Generate debug information in separate .dwo files.

    # -fdbg-cnt-list              List all available debugging counters with their limits and counts.
    # -fdbg-cnt=<counter>[:<lower_limit1>-]<upper_limit1>[:<lower_limit2>-<upper_limit2>:...][,<counter>:...] Set the debug counter limit.
    # -fdebug-prefix-map=<old>=<new> Map one directory name to another in debug information.
    # -fdebug-types-section       Output .debug_types section when using DWARF v4 debuginfo.

    # -gz                         Generate compressed debug sections.
    # -gz=<format>                Generate compressed debug sections in format <format>.

    # -fuse-ld=bfd                Use the bfd linker instead of the default linker.
    # -fuse-ld=gold               Use the gold linker instead of the default linker.
    # -fuse-ld=lld                Use the lld LLVM linker instead of the default linker.
    # -fuse-ld=mold               Use the Modern linker (MOLD) linker instead of the default linker.

    # -flto                       Enable link-time optimization.
    # -flto-compression-level=<0,19> Use zlib/zstd compression level <number> for IL.
    # -flto-odr-type-merging      Does nothing.  Preserved for backward compatibility.
    # -flto-partition=            Specify the algorithm to partition symbols and vars at linktime.
    # -flto-repor                 Report various link-time optimization statistics.
    # -flto-report-wpa            Report various link-time optimization statistics for WPA only.
    # -flto=                      Link-time optimization with number of parallel jobs or jobserver.

    # -fstack-protector-all       Enable stack protectors for all functions
    # -fstack-protector-strong    Enable stack protectors for some functions vulnerable to stack smashing. Compared to -fstack-protector, this uses a stronger heuristic that includes functions containing arrays of any size (and any type), as well as any calls to alloca or the taking of an address from a local variable
    # -fstack-protector           Enable stack protectors for some functions vulnerable to stack smashing. This uses a loose heuristic which considers functions vulnerable if they contain a char (or 8bit integer) array or constant sized calls to alloca, which are of greater size than ssp-buffer-size (default: 8 bytes). All variable sized calls to alloca are considered vulnerable


set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include")
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/include")
list(APPEND CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
set(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files.")
mark_as_advanced(CMAKE_C_IMPLICIT_INCLUDE_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0")
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc")
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/x86_64-w64-mingw32/lib") # Hmm.... DSX dir??
list(APPEND CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib")
set(CMAKE_C_IMPLICIT_LINK_DIRECTORIES "${CMAKE_C_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <C>.")
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <C>.")
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

set(CMAKE_C_IMPLICIT_LINK_LIBRARIES)
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-mingw32" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-gcc" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-moldname" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-mingwex" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-kernel32" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-pthread" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-advapi32" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-shell32" " ")
string(APPEND CMAKE_C_IMPLICIT_LINK_LIBRARIES "-user32" " ")
string(STRIP "${CMAKE_C_IMPLICIT_LINK_LIBRARIES}" CMAKE_C_IMPLICIT_LINK_LIBRARIES)
set(CMAKE_C_IMPLICIT_LINK_LIBRARIES "${CMAKE_C_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <C>.")
mark_as_advanced(CMAKE_C_IMPLICIT_LINK_LIBRARIES)

set(CMAKE_C_SOURCE_FILE_EXTENSIONS)
list(APPEND CMAKE_C_SOURCE_FILE_EXTENSIONS "c")
list(APPEND CMAKE_C_SOURCE_FILE_EXTENSIONS "m")
set(CMAKE_C_SOURCE_FILE_EXTENSIONS "${CMAKE_C_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <C>.")
mark_as_advanced(CMAKE_C_SOURCE_FILE_EXTENSIONS)

find_program(CMAKE_C_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
mark_as_advanced(CMAKE_C_COMPILER)


set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/include/c++/13.1.0")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/include/c++/13.1.0/x86_64-w64-mingw32")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/include/c++/13.1.0/backward")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/include")
list(APPEND CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
set(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES "${CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES}" CACHE PATH "Directories implicitly searched by the compiler for header files <CXX>.")
mark_as_advanced(CMAKE_CXX_IMPLICIT_INCLUDE_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/13.1.0")
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib/gcc")
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/x86_64-w64-mingw32/lib") # Hmm.... DSX dir??
list(APPEND CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${Z_UCRT64_ROOT_DIR}/lib")
set(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES "${CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES}" CACHE PATH "Implicit linker search path detected for language <CXX>.")
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "" CACHE PATH "Implicit linker framework search path detected for language <CXX>.")
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "stdc++" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "mingw32" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "gcc_s" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "gcc" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "moldname" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "mingwex" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "kernel32" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "pthread" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "advapi32" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "shell32" " ")
string(APPEND CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "user32" " ")
string(STRIP "${CMAKE_CXX_IMPLICIT_LINK_LIBRARIES}" CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)
set(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES "${CMAKE_CXX_IMPLICIT_LINK_LIBRARIES}" CACHE STRING "Implicit link libraries and flags detected for language <CXX>.")
mark_as_advanced(CMAKE_CXX_IMPLICIT_LINK_LIBRARIES)

set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "C")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "M")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "c++")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "cc")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "cpp")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "cxx")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "mm")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "mpp")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "CPP")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "ixx")
list(APPEND CMAKE_CXX_SOURCE_FILE_EXTENSIONS "cppm")
set(CMAKE_CXX_SOURCE_FILE_EXTENSIONS "${CMAKE_CXX_SOURCE_FILE_EXTENSIONS}" CACHE STRING "Extensions of source files for the given language <CXX>.")
mark_as_advanced(CMAKE_CXX_SOURCE_FILE_EXTENSIONS)

find_program(CMAKE_CXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
mark_as_advanced(CMAKE_CXX_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_Fortran_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gfortran.exe")
mark_as_advanced(CMAKE_Fortran_COMPILER)


find_program(CMAKE_OBJC_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
mark_as_advanced(CMAKE_OBJC_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_OBJCXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
mark_as_advanced(CMAKE_OBJCXX_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
if(NOT DEFINED CMAKE_ASM_COMPILER)
    find_program(CMAKE_ASM_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/as.exe")
    mark_as_advanced(CMAKE_ASM_COMPILER)
endif()

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
