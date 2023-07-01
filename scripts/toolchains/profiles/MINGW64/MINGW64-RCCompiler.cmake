set(MINGW64_RC_COMPILER "C:/msys64/mingw64/bin/windres.exe")
# set(MINGW64_RC_COMPILER_ARG1 "")
# set(MINGW64_RC_COMPILER_LOADED 1)
set(MINGW64_RC_SOURCE_FILE_EXTENSIONS rc;RC)
set(MINGW64_RC_OUTPUT_EXTENSION .obj)
set(MINGW64_RC_COMPILER_ENV_VAR "RC")


# # <RC>
# find_program(RC "rc" NO_CACHE) # DOC "The full path to the compiler for <RC>.")
# mark_as_advanced(RC)
# if(NOT DEFINED RC_FLAGS)
#     set(RC_FLAGS "")
#     if(MSYS_VERBOSE)
#         string(APPEND RC_FLAGS "--verbose")
#     endif()
#     set(RC_FLAGS_DEBUG "") # CACHE STRING "Flags for the 'C' language resource compiler utility, for <Debug> builds.")
#     set(RC_FLAGS_RELEASE "") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
#     set(RC_FLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
#     set(RC_FLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
# endif()
# set(RC_FLAGS "${RC_FLAGS}") # CACHE STRING "Flags for the 'C' language utility." FORCE)
# set(RC_FLAGS_DEBUG "${RC_FLAGS_DEBUG}") # CACHE STRING "Flags for the 'C' language utility, for <Debug> builds.")
# set(RC_FLAGS_RELEASE "${RC_FLAGS_RELEASE}") # CACHE STRING "Flags for the 'C' language utility, for <Release> builds.")
# set(RC_FLAGS_MINSIZEREL "${RC_FLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C' language utility, for <MinSizeRel> builds.")
# set(RC_FLAGS_RELWITHDEBINFO "${RC_FLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C' language utility, for <RelWithDebInfo> builds.")
# set(RC_COMMAND "${RC} ${RC_FLAGS}") # CACHE STRING "The 'C' language utility command." FORCE)

# # if(NOT CMAKE_RC_COMPILER)
# #     find_program (CMAKE_RC_COMPILER
# #         "${Z_MINGW64_ROOT_DIR}/bin/windres"
# #     )
# #     if(NOT CMAKE_RC_COMPILER)
# #         find_program (CMAKE_RC_COMPILER
# #             "windres"
# #         )
# #     endif() # (NOT CMAKE_RC_COMPILER)
# # endif() # (NOT CMAKE_RC_COMPILER)
