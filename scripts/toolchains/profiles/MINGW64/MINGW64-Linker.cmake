    # # <LD>
    # find_program(LD  "ld" NO_CACHE) # DOC "The full path to the compiler for <LD>.")
    # mark_as_advanced(LD)
    # if(NOT DEFINED LDFLAGS)
    #     set(LDFLAGS "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for all build types.")
    #     string(APPEND LDFLAGS "-pipe ")

    #     set(LDFLAGS_DEBUG "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Debug> builds.")
    #     set(LDFLAGS_RELEASE "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Release> builds.")
    #     set(LDFLAGS_MINSIZEREL "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <MinSizeRel> builds.")
    #     set(LDFLAGS_RELWITHDEBINFO "") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <RelWithDebInfo> builds.")

    # endif() # (NOT DEFINED LDFLAGS)
    # set(LDFLAGS_FLAGS "${LDFLAGS}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for all build types." FORCE)
    # set(LDFLAGS_DEBUG "${LDFLAGS_DEBUG}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Debug> builds.")
    # set(LDFLAGS_RELEASE "${LDFLAGS_RELEASE}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <Release> builds.")
    # set(LDFLAGS_MINSIZEREL "${LDFLAGS_MINSIZEREL}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <MinSizeRel> builds.")
    # set(LDFLAGS_RELWITHDEBINFO "${LDFLAGS_RELWITHDEBINFO}") # CACHE STRING "Flags for the 'C/C++' language linker utility, for <RelWithDebInfo> builds.")
    # set(LD_COMMAND "${LD} ${LDFLAGS}") # CACHE STRING "The 'C/C++' language linker utility command." FORCE)
