# message(WARNING "ping")

if(NOT CMAKE_CXX_COMPILER_NAMES)
    set(CMAKE_CXX_COMPILER_NAMES)
    list(APPEND CMAKE_CXX_COMPILER_NAMES x86_64-w64-mingw32-g++)
    list(APPEND CMAKE_CXX_COMPILER_NAMES x86_64-w64-mingw32-c++)
    list(APPEND CMAKE_CXX_COMPILER_NAMES g++)
    list(APPEND CMAKE_CXX_COMPILER_NAMES c++)
    set(CMAKE_CXX_COMPILER_NAMES "${CMAKE_CXX_COMPILER_NAMES}")
endif()

# Exclude C++ compilers differing from C compiler only by case
# because this platform may have a case-insensitive filesystem.
set(CMAKE_CXX_COMPILER_EXCLUDE CC aCC xlC)
