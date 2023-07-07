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
#set(CMAKE_SYSTEM_PROCESSOR "x86_64" CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE) # include(Platform/${CMAKE_EFFECTIVE_SYSTEM_NAME}-${CMAKE_CXX_COMPILER_ID}-CXX-${CMAKE_SYSTEM_PROCESSOR} OPTIONAL RESULT_VARIABLE _INCLUDED_FILE)                             #CACHE STRING "When not cross-compiling, this variable has the same value as the ``CMAKE_HOST_SYSTEM_PROCESSOR`` variable." FORCE)


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

foreach(lang C CXX ASM Fortran OBJC OBJCXX)
    ##-- CMakeCXXInformation: include(Compiler/<CMAKE_CXX_COMPILER_ID>-<LANG>)
    #set(CMAKE_${lang}_COMPILER_ID "UCRT64 13.1.0" CACHE STRING "" FORCE) # - actually, let's fallback to Kitware's GNU
    ##-- 'TARGET' tells the compiler in question what it's '--target:' is.
    set(CMAKE_${lang}_COMPILER_TARGET "x86_64-w64-mingw32" CACHE STRING "The target for cross-compiling, if supported. '--target=x86_64-w64-mingw32'")

endforeach()

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_C_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
mark_as_advanced(CMAKE_C_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_CXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-g++.exe")
mark_as_advanced(CMAKE_CXX_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_Fortran_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gfortran.exe")
mark_as_advanced(CMAKE_Fortran_COMPILER)

#"C:\msys64\ucrt64\bin\x86_64-w64-mingw32-gfortran.exe"
find_program(CMAKE_OBJCXX_COMPILER "${Z_UCRT64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
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
    foreach(lang C CXX ASM Fortran OBJC OBJCXX)
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -march=nocona")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -msahf")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -mtune=generic")
        string(APPEND CMAKE_${lang}_FLAGS_INIT " -pipe")
        if(${lang} STREQUAL C)
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -Wp,-D_FORTIFY_SOURCE=2")
            string(APPEND CMAKE_${lang}_FLAGS_INIT " -fstack-protector-strong")
        endif()
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

message(STATUS "MinGW UCRT x64 toolchain loaded")

endif()
