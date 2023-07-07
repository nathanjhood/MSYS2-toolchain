# Determine if the compiler has GCC-compatible command-line syntax.

if(NOT DEFINED MSYS_COMPILER_IS_GCC_COMPATIBLE)

    if(CMAKE_COMPILER_IS_GNUCXX)

        set(MSYS_COMPILER_IS_GCC_COMPATIBLE ON)

    elseif(MSVC)

        set(MSYS_COMPILER_IS_GCC_COMPATIBLE OFF)

    elseif( "${CMAKE_CXX_COMPILER_ID}" MATCHES "Clang")

        set(MSYS_COMPILER_IS_GCC_COMPATIBLE ON)

    elseif( "${CMAKE_CXX_COMPILER_ID}" MATCHES "Intel")

        set(MSYS_COMPILER_IS_GCC_COMPATIBLE ON)

    endif()

endif()
