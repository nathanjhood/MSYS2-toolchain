# elseif(MSYSTEM STREQUAL MINGW32)

#     set(ENABLE_MINGW32 ON CACHE BOOL "" FORCE)

#     set(MSYSTEM_TITLE       "MinGW x32"                              CACHE STRING   "Name of the build system." FORCE)
#     set(MSYSTEM_ROOT        "${MSYS_ROOT}/mingw32"                   CACHE PATH     "Root of the build system." FORCE)

#     if(NOT DEFINED CRT_LINKAGE)
#         set(CRT_LINKAGE "static")
#     endif()

#     set(CC                      "${MSYSTEM_ROOT}/bin/gcc")             #CACHE FILEPATH "The full path to the compiler for <CC>." FORCE)
#     set(CXX                     "${MSYSTEM_ROOT}/bin/g++")             #CACHE FILEPATH "The full path to the compiler for <CXX>." FORCE)
#     set(LD                      "${MSYSTEM_ROOT}/bin/ld")              #CACHE FILEPATH "The full path to the linker <LD>." FORCE)
#     set(RC                      "${MSYSTEM_ROOT}/bin/windres")         #CACHE FILEPATH "" FORCE)

#     set(CFLAGS                  "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong") #CACHE STRING "Default <CFLAGS> flags for all build types." FORCE)
#     set(CXXFLAGS                "-march=pentium4 -mtune=generic -O2 -pipe") #CACHE STRING "Default <CXXFLAGS> flags for all build types." FORCE)
#     set(CPPFLAGS                "-D__USE_MINGW_ANSI_STDIO=1")          #CACHE STRING    "Default <CPPFLAGS> flags for all build types." FORCE)
#     set(LDFLAGS                 "-pipe -Wl,--no-seh -Wl,--large-address-aware") #CACHE STRING    "Default <LD> flags for linker for all build types." FORCE)

#     set(__USE_MINGW_ANSI_STDIO  "1"                                   CACHE STRING    "Use the MinGW ANSI definition for 'stdio.h'." FORCE)
#     set(_FORTIFY_SOURCE         "2"                                   CACHE STRING    "Fortify source definition." FORCE)


#     #-- Debugging flags
#     set(DEBUG_CFLAGS            "-ggdb -Og"                           CACHE STRING    "Default <CFLAGS_DEBUG> flags." FORCE)
#     set(DEBUG_CXXFLAGS          "-ggdb -Og"                           CACHE STRING    "Default <CXXFLAGS_DEBUG> flags." FORCE)

#     set(PREFIX                  "/mingw32"                            CACHE PATH      "")
#     set(CARCH                   "i686"                                CACHE STRING    "")
#     set(CHOST                   "i686-w64-mingw32"                    CACHE STRING    "")

#     set(MSYSTEM_PREFIX          "/mingw32"                            CACHE PATH      "")
#     set(MSYSTEM_CARCH           "i686"                                CACHE STRING    "")
#     set(MSYSTEM_CHOST           "i686-w64-mingw32"                    CACHE STRING    "")

#     set(MINGW_CHOST             "${MSYSTEM_CHOST}"                    CACHE STRING    "")
#     set(MINGW_PREFIX            "${MSYSTEM_PREFIX}"                   CACHE PATH      "")
#     set(MINGW_PACKAGE_PREFIX    "mingw-w64-${MSYSTEM_CARCH}"          CACHE STRING    "")
