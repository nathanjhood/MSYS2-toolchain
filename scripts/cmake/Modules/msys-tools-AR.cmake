#[===[.md

# <AR>

UNDEFINED.

Report bugs to <https://sourceware.org/bugzilla/>

#]===]
option(ENABLE_AR "Enable the <AR> archiving utility." ON)
if(ENABLE_AR)
    include("./msys-FindAR.cmake")
    #[===[.md
    Usage:
    $ .\ar.exe [emulation options] [-]{dmpqrstx}[abcDfilMNoOPsSTuvV] [--plugin <name>] [member-name] [count] archive-file file...
    $ .\ar.exe -M [<mri-script]
    #]===]

    if(NOT DEFINED AR_FLAGS)
        #[===[.md
        commands:
        d            - delete file(s) from the archive
        m[ab]        - move file(s) in the archive
        p            - print file(s) found in the archive
        q[f]         - quick append file(s) to the archive
        r[ab][f][u]  - replace existing or insert new file(s) into the archive
        s            - act as ranlib
        t[O][v]      - display contents of the archive
        x[o]         - extract file(s) from the archive
        command specific modifiers:
        [a]          - put file(s) after [member-name]
        [b]          - put file(s) before [member-name] (same as [i])
        [D]          - use zero for timestamps and uids/gids (default)
        [U]          - use actual timestamps and uids/gids
        [N]          - use instance [count] of name
        [f]          - truncate inserted file names
        [P]          - use full path names when matching
        [o]          - preserve original dates
        [O]          - display offsets of files in the archive
        [u]          - only replace files that are newer than current archive contents
        generic modifiers:
        [c]          - do not warn if the library had to be created
        [s]          - create an archive index (cf. ranlib)
        [l <text> ]  - specify the dependencies of this library
        [S]          - do not build a symbol table
        [T]          - deprecated, use --thin instead
        [v]          - be verbose
        [V]          - display the version number
        @<file>      - read options from <file>
        --target=BFDNAME - specify the target object format as BFDNAME
        --output=DIRNAME - specify the output directory for extraction operations
        --record-libdeps=<text> - specify the dependencies of this library
        --thin       - make a thin archive
        optional:
        --plugin <p> - load the specified plugin
        emulation options:
        No emulation specific options
        #]===]
        set(AR_FLAGS "")
        set(AR_FLAGS "-r") #-- replace existing or insert new file(s) into the archive
        if(MSYS_VERBOSE)
            set(AR_FLAGS "-v") #-- verbose
        endif()
    endif() # (NOT DEFINED AR_FLAGS)
    set(AR_FLAGS "${AR_FLAGS}" CACHE STRING "Flags for the archiving utility." FORCE)
    set(AR_COMMAND "${AR} ${AR_FLAGS}")

    include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
    find_package_handle_standard_args(UnixCommands
        REQUIRED_VARS AR
    )
endif()
