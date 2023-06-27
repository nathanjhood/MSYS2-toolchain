# elseif(MSYSTEM STREQUAL CLANG32)

#     set(BUILDSYSTEM             "MinGW Clang x32"                     CACHE STRING    "Name of the build system." FORCE)
#     set(BUILDSYSTEM_ROOT        "${MSYS_ROOT}/clang32"                CACHE PATH      "Root of the build system." FORCE)

#     set(TOOLCHAIN_VARIANT       llvm                                  CACHE STRING    "Identification string of the compiler toolchain variant." FORCE)
#     set(CRT_LIBRARY             ucrt                                  CACHE STRING    "Identification string of the C Runtime variant. Can be 'ucrt' (modern, 64-bit only) or 'msvcrt' (compatibilty for legacy builds)." FORCE)
#     set(CXX_STD_LIBRARY         libc++                                CACHE STRING    "Identification string of the C++ Standard Library variant. Can be 'libstdc++' (GNU implementation) or 'libc++' (LLVM implementation)." FORCE)

#     set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
#     set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)

#     set(CC                      "clang"                               CACHE FILEPATH  "The full path to the compiler for <CC>." FORCE)
#     set(CXX                     "clang++"                             CACHE FILEPATH  "The full path to the compiler for <CXX>." FORCE)
#     set(LD                      "lld"                                 CACHE FILEPATH  "The full path to the linker <LD>." FORCE)

#     set(CFLAGS                  "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong" CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
#     set(CXXFLAGS                "-march=pentium4 -mtune=generic -O2 -pipe" CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
#     set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1"         CACHE STRING     "Default <CPPFLAGS> flags for all build types." FORCE)
#     set(LDFLAGS                 "-pipe -Wl,--no-seh -Wl,--large-address-aware" CACHE STRING "Default <LD> flags for linker for all build types." FORCE)

#     set(PREFIX                  "/clang32"                            CACHE PATH      "")
#     set(CARCH                   "i686"                                CACHE STRING    "")
#     set(CHOST                   "i686-w64-mingw32"                    CACHE STRING    "")

#     set(MSYSTEM_PREFIX          "/clang32"                            CACHE PATH      "")
#     set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
#     set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")

#     set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
#     set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
#     set(MINGW_PACKAGE_PREFIX    "mingw-w64-clang-${MSYSTEM_CARCH}"    CACHE STRING    "")
