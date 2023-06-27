
#########################################################################
# COMPRESSION DEFAULTS
#########################################################################

# include("${CMAKE_CURRENT_LIST_DIR}/../../cmake/msys-gzip.cmake")

#[===[.md
# bzip2

bzip2, a block-sorting file compressor.

#]===]
option(ENABLE_BZ2 "Enable the 'bzip2' compression utility." ON)
if(ENABLE_BZ2)
    find_program(BZ2 "${Z_MSYS_ROOT_DIR}/usr/bin/bzip2" NO_CACHE)
    #[===[.md
    # bzip2_usage

    usage: bzip2 [flags and input files in any order]

    If invoked as `bzip2', default action is to compress.
    If invoked as `bunzip2',  default action is to decompress.
    If invoked as `bzcat', default action is to decompress to stdout.

    If no file names are given, bzip2 compresses or decompresses
    from standard input to standard output.  You can combine
    short flags, so `-v -4' means the same as -v4 or -4v, &c.

    ]===]
    if(NOT DEFINED BZ2_FLAGS)
        set(BZ2_FLAGS)
        #[===[.md
        # bzip2_flags

        Flags for the 'bzip2' compression utility.

        -h --help           print this message
        -d --decompress     force decompression
        -z --compress       force compression
        -k --keep           keep (don't delete) input files
        -f --force          overwrite existing output files
        -t --test           test compressed file integrity
        -c --stdout         output to standard out
        -q --quiet          suppress noncritical error messages
        -v --verbose        be verbose (a 2nd -v gives more)
        -L --license        display software version & license
        -V --version        display software version & license
        -s --small          use less memory (at most 2500k)
        -1 .. -9            set block size to 100k .. 900k
        --fast              alias for -1
        --best              alias for -9

        #]===]
        string(APPEND BZ2_FLAGS "-c ")
        string(APPEND BZ2_FLAGS "-f ")
    endif() # (NOT DEFINED BZ2_FLAGS)
    set(BZ2_FLAGS "${BZ2_FLAGS}") # CACHE STRING "Flags for the 'bzip2' compression utility." FORCE)
    set(BZ2_COMMAND "${BZ2} ${BZ2_FLAGS}") # CACHE STRING "The 'bzip2' compression utility command." FORCE)
    set(COMPRESSBZ2 "${BZ2_COMMAND}") # CACHE STRING "The 'bzip2' compression utility." FORCE)
    unset(BZ2_FLAGS)
endif() # (ENABLE_BZ2)

option(ENABLE_XZ "Enable the 'xz' compression utility." ON)
if(ENABLE_XZ)
    find_program(XZ "${Z_MSYS_ROOT_DIR}/usr/bin/xz" NO_CACHE)
    if(NOT DEFINED XZ_FLAGS)
        set(XZ_FLAGS) # CACHE STRING "Flags for the xz compression utility." FORCE)
        set(XZ_FLAGS "-c ")
        set(XZ_FLAGS "-z ")
        set(XZ_FLAGS "-T0 ")
        set(XZ_FLAGS "- ")
    endif() # (NOT DEFINED XZ_FLAGS)
    set(XZ_FLAGS "${XZ_FLAGS}") # CACHE STRING "Flags for the 'xz' compression utility." FORCE)
    set(XZ_COMMAND "${XZ} ${XZ_FLAGS}") # CACHE STRING "The 'xz' compression utility command." FORCE)
    set(COMPRESSXZ "${XZ_COMMAND}") # CACHE STRING "The 'xz' compression utility." FORCE)
    unset(XZ_FLAGS)
endif() # (ENABLE_XZ)

if(NOT DEFINED ZST_FLAGS)
    set(ZST_FLAGS "-c -T0 --ultra -20 -") # CACHE STRING "Flags for the zstd compression utility." FORCE)
endif()
if(NOT DEFINED LRZ_FLAGS)
    set(LRZ_FLAGS "-q") # CACHE STRING "Flags for the lrzip compression utility." FORCE)
endif()
if(NOT DEFINED LZO_FLAGS)
    set(LZO_FLAGS "-q") # CACHE STRING "Flags for the lzop compression utility." FORCE)
endif()
if(NOT DEFINED Z_FLAGS)
    set(Z_FLAGS "-c -f") # CACHE STRING "Flags for the compress compression utility." FORCE)
endif()
if(NOT DEFINED LZ4_FLAGS)
    set(LZ4_FLAGS "-q") # CACHE STRING "Flags for the lz4 compression utility." FORCE)
endif()
if(NOT DEFINED LZ_FLAGS)
    set(LZ_FLAGS "-c -f") # CACHE STRING "Flags for the lzip compression utility." FORCE)
endif()

set(COMPRESS_XZ_COMMAND "xz ${XZ_FLAGS}") # CACHE STRING "The xz compression utility command." FORCE)
set(COMPRESS_ZST_COMMAND "zstd ${ZST_FLAGS}") # CACHE STRING "The zst compression utility command." FORCE)
set(COMPRESS_LRZ_COMMAND "lrzip ${LRZ_FLAGS}") # CACHE STRING "The lrzip compression utility command." FORCE)
set(COMPRESS_LZO_COMMAND "lzop ${LZO_FLAGS}") # CACHE STRING "The lzop compression utility command." FORCE)
set(COMPRESS_Z_COMMAND "compress ${Z_FLAGS}") # CACHE STRING "The compress compression utility command." FORCE)
set(COMPRESS_LZ4_COMMAND "lz4 ${LZ4_FLAGS}") # CACHE STRING "The lz4 compression utility command." FORCE)
set(COMPRESS_LZ_COMMAND "lzip ${LZ_FLAGS}") # CACHE STRING "The lzip compression utility command." FORCE)

unset(XZ_FLAGS)
unset(ZST_FLAGS)
unset(LRZ_FLAGS)
unset(LZO_FLAGS)
unset(Z_FLAGS)
unset(LZ4_FLAGS)
unset(LZ_FLAGS)
