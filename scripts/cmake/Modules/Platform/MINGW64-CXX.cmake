# include(Platform/CYGWIN-GNU)
# __cygwin_compiler_gnu(CXX)

# message(WARNING "ping")

# TODO: Is -Wl,--enable-auto-import now always default?
set(CMAKE_EXE_LINKER_FLAGS_INIT)
string(APPEND CMAKE_EXE_LINKER_FLAGS_INIT " -Wl,--enable-auto-import")
set(CMAKE_EXE_LINKER_FLAGS_INIT "${CMAKE_EXE_LINKER_FLAGS_INIT}")

set(CMAKE_GNULD_IMAGE_VERSION "-Wl,--major-image-version,<TARGET_VERSION_MAJOR>,--minor-image-version,<TARGET_VERSION_MINOR>")
set(CMAKE_GENERATOR_RC windres)

# Features for LINK_LIBRARY generator expression
## check linker capabilities
if(NOT DEFINED _CMAKE_LINKER_PUSHPOP_STATE_SUPPORTED)
    execute_process(COMMAND "${CMAKE_LINKER}" --help
                    OUTPUT_VARIABLE __linker_help
                    ERROR_VARIABLE __linker_help)
    if(__linker_help MATCHES "--push-state" AND __linker_help MATCHES "--pop-state")
        set(_CMAKE_LINKER_PUSHPOP_STATE_SUPPORTED TRUE CACHE INTERNAL "linker supports push/pop state")
    else()
        set(_CMAKE_LINKER_PUSHPOP_STATE_SUPPORTED FALSE CACHE INTERNAL "linker supports push/pop state")
    endif()
    unset(__linker_help)
endif()

## WHOLE_ARCHIVE: Force loading all members of an archive
if(_CMAKE_LINKER_PUSHPOP_STATE_SUPPORTED)
set(CMAKE_LINK_LIBRARY_USING_WHOLE_ARCHIVE "LINKER:--push-state,--whole-archive"
                                            "<LINK_ITEM>"
                                            "LINKER:--pop-state")
else()
set(CMAKE_LINK_LIBRARY_USING_WHOLE_ARCHIVE "LINKER:--whole-archive"
                                            "<LINK_ITEM>"
                                            "LINKER:--no-whole-archive")
endif()
set(CMAKE_LINK_LIBRARY_USING_WHOLE_ARCHIVE_SUPPORTED TRUE)

# macro(__mingw64_compiler_gnu lang)

# Binary link rules.
set(CMAKE_CXX_CREATE_SHARED_MODULE "<CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_MODULE_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS> -o <TARGET> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES>")
set(CMAKE_CXX_CREATE_SHARED_LIBRARY "<CMAKE_CXX_COMPILER> <LANGUAGE_COMPILE_FLAGS> <CMAKE_SHARED_LIBRARY_CXX_FLAGS> <LINK_FLAGS> <CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> ${CMAKE_GNULD_IMAGE_VERSION} <OBJECTS> <LINK_LIBRARIES>")
set(CMAKE_CXX_LINK_EXECUTABLE "<CMAKE_CXX_COMPILER> <FLAGS> <CMAKE_CXX_LINK_FLAGS> <LINK_FLAGS> <OBJECTS> -o <TARGET> -Wl,--out-implib,<TARGET_IMPLIB> ${CMAKE_GNULD_IMAGE_VERSION} <LINK_LIBRARIES>")
set(CMAKE_CXX_CREATE_WIN32_EXE "-mwindows")

# No -fPIC on cygwin
set(CMAKE_CXX_COMPILE_OPTIONS_PIC "")
set(CMAKE_CXX_COMPILE_OPTIONS_PIE "")
set(_CMAKE_CXX_PIE_MAY_BE_SUPPORTED_BY_LINKER NO)
set(CMAKE_CXX_LINK_OPTIONS_PIE "")
set(CMAKE_CXX_LINK_OPTIONS_NO_PIE "")
set(CMAKE_SHARED_LIBRARY_CXX_FLAGS "")

# Initialize C link type selection flags.  These flags are used when
# building a shared library, shared module, or executable that links
# to other libraries to select whether to use the static or shared
# versions of the libraries.
foreach(type SHARED_LIBRARY SHARED_MODULE EXE)
    set(CMAKE_${type}_LINK_STATIC_CXX_FLAGS "-Wl,-Bstatic")
    set(CMAKE_${type}_LINK_DYNAMIC_CXX_FLAGS "-Wl,-Bdynamic")
endforeach()

set(CMAKE_EXE_EXPORTS_CXX_FLAG "-Wl,--export-all-symbols")

# TODO: Is -Wl,--enable-auto-import now always default?
string(APPEND CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS " -Wl,--enable-auto-import")
set(CMAKE_SHARED_MODULE_CREATE_CXX_FLAGS "${CMAKE_SHARED_LIBRARY_CREATE_CXX_FLAGS}")

if(NOT CMAKE_RC_COMPILER_INIT)
  set(CMAKE_RC_COMPILER_INIT windres)
endif()


if(NOT CMAKE_RC_COMPILER_INIT)
    set(CMAKE_RC_COMPILER_INIT windres)
endif()
enable_language(RC)


# enable_language(RC)
# endmacro()

# __mingw64_compiler_gnu(CXX)
