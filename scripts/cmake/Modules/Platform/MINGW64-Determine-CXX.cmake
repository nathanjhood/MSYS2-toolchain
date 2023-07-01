if(NOT CMAKE_CXX_COMPILER_NAMES)
    set(CMAKE_CXX_COMPILER_NAMES x86_64-w64-mingw32-g++ g++ c++)
endif()

# Exclude C++ compilers differing from C compiler only by case
# because this platform may have a case-insensitive filesystem.
set(CMAKE_CXX_COMPILER_EXCLUDE CC aCC xlC)
