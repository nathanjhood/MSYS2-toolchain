#[===[.md
# gzip

Compress or uncompress FILEs (by default, compress FILES in-place).

#]===]
option(ENABLE_GZIP "Enable the 'gzip' compression utility." ON)
if(ENABLE_GZIP)
    #[===[.md
    # gzip_usage

    Usage: gzip [OPTION]... [FILE]...

    Compress or uncompress FILEs (by default, compress FILES in-place).

    Mandatory arguments to long options are mandatory for short options too.

    With no FILE, or when FILE is -, read standard input.

    Report bugs to <bug-gzip@gnu.org>.

    ]===]
    find_program(GZ "${Z_MSYS_ROOT_DIR}/usr/bin/gzip" NO_CACHE)
    if(NOT DEFINED GZ_FLAGS)
        set(GZ_FLAGS)
        #[===[.md
        # gzip_flags

        -a, --ascii       ascii text; convert end-of-line using local conventions
        -c, --stdout      write on standard output, keep original files unchanged
        -d, --decompress  decompress
        -f, --force       force overwrite of output file and compress links
        -h, --help        give this help
        -k, --keep        keep (don't delete) input files
        -l, --list        list compressed file contents
        -L, --license     display software license
        -n, --no-name     do not save or restore the original name and timestamp
        -N, --name        save or restore the original name and timestamp
        -q, --quiet       suppress all warnings
        -r, --recursive   operate recursively on directories
            --rsyncable   make rsync-friendly archive
        -S, --suffix=SUF  use suffix SUF on compressed files
            --synchronous synchronous output (safer if system crashes, but slower)
        -t, --test        test compressed file integrity
        -v, --verbose     verbose mode
        -V, --version     display version number
        -1, --fast        compress faster
        -9, --best        compress better

        #]===]
        string(APPEND GZ_FLAGS "-c ")
        string(APPEND GZ_FLAGS "-f ")
        string(APPEND GZ_FLAGS "-n ")
    endif() # (NOT DEFINED GZ_FLAGS)
    set(GZ_FLAGS "${GZ_FLAGS}") # CACHE STRING "Flags for the 'gzip' compression utility." FORCE)
    set(GZ_COMMAND "${GZ} ${GZ_FLAGS}") # CACHE STRING "The 'gzip' compression utility command." FORCE)
    set(COMPRESSGZ "${GZ_COMMAND}") # CACHE STRING "The 'gzip' compression utility" FORCE)
    unset(GZ_FLAGS)
    message(STATUS "gzip compression utility enabled.")
endif() # (ENABLE_GZIP)
