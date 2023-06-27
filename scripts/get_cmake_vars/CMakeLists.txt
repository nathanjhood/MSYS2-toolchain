cmake_minimum_required(VERSION 3.20)

if(NOT MSYS_OUTPUT_FILE)
    message(FATAL_ERROR "MSYS_OUTPUT_FILE is required to be defined")
endif()

if(NOT CMAKE_BUILD_TYPE)
    message(FATAL_ERROR "CMAKE_BUILD_TYPE is required to be defined")
else()
    string(TOUPPER "${CMAKE_BUILD_TYPE}" MSYS_CONFIGS)
endif()

set(MSYS_LANGUAGES "C;CXX" CACHE STRING "Languages to enables for this project")

project(get_cmake_vars LANGUAGES ${MSYS_LANGUAGES})


set(OUTPUT_STRING "# Generator: ${CMAKE_CURRENT_LIST_FILE}\n")

function(escaped out_var value)
    string(REPLACE "\\" "\\\\" value "${value}")
    string(REPLACE "\"" "\\\"" value "${value}")
    string(REPLACE "\$" "\\\$" value "${value}")
    set(${out_var} "${value}" PARENT_SCOPE)
endfunction()

# Build default checklists
list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_CROSSCOMPILING
                                        CMAKE_SYSTEM_NAME
                                        CMAKE_HOST_SYSTEM_NAME
                                        CMAKE_SYSTEM_PROCESSOR
                                        CMAKE_HOST_SYSTEM_PROCESSOR)
if(APPLE)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_OSX_DEPLOYMENT_TARGET
                                            CMAKE_OSX_SYSROOT)
endif()
# Programs to check
set(PROGLIST AR RANLIB STRIP NM OBJDUMP DLLTOOL MT LINKER)
foreach(prog IN LISTS PROGLIST)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${prog})
endforeach()
set(COMPILERS ${MSYS_LANGUAGES} RC)
foreach(prog IN LISTS COMPILERS)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${prog}_COMPILER CMAKE_${prog}_COMPILER_ID CMAKE_${prog}_COMPILER_FRONTEND_VARIANT)
endforeach()
# Variables to check
foreach(_lang IN LISTS MSYS_LANGUAGES)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_STANDARD_INCLUDE_DIRECTORIES)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_STANDARD_LIBRARIES)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_STANDARD)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_COMPILE_FEATURES)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_EXTENSION)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
    list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_COMPILER_TARGET)

    # Probably never required since implicit.
    #list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)
    #list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_IMPLICIT_INCLUDE_DIRECTORIES)
    #list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_IMPLICIT_LINK_DIRECTORIES)
    #list(APPEND MSYS_DEFAULT_VARS_TO_CHECK CMAKE_${_lang}_IMPLICIT_LINK_LIBRARIES)
endforeach()
list(REMOVE_DUPLICATES MSYS_DEFAULT_VARS_TO_CHECK)

# Environment variables to check.
list(APPEND MSYS_DEFAULT_ENV_VARS_TO_CHECK PATH INCLUDE C_INCLUDE_PATH CPLUS_INCLUDE_PATH LIB LIBPATH LIBRARY_PATH LD_LIBRARY_PATH)
list(REMOVE_DUPLICATES MSYS_DEFAULT_ENV_VARS_TO_CHECK)

#Flags to check. Flags are a bit special since they are configuration aware.
set(FLAGS ${MSYS_LANGUAGES} RC SHARED_LINKER STATIC_LINKER EXE_LINKER MODULE_LINKER)
foreach(flag IN LISTS FLAGS)
    list(APPEND MSYS_DEFAULT_FLAGS_TO_CHECK CMAKE_${flag}_FLAGS)
endforeach()
list(REMOVE_DUPLICATES MSYS_DEFAULT_FLAGS_TO_CHECK)

#Language-specific flags.
foreach(_lang IN LISTS MSYS_LANGUAGES)
    list(APPEND MSYS_LANG_FLAGS CMAKE_${_lang}_FLAGS)
endforeach()
list(REMOVE_DUPLICATES MSYS_LANG_FLAGS)

# TODO if ever necessary: Properties to check

set(MSYS_VAR_PREFIX "MSYS_DETECTED" CACHE STRING "Variable prefix to use for detected flags")
set(MSYS_VARS_TO_CHECK "${MSYS_DEFAULT_VARS_TO_CHECK}" CACHE STRING "Variables to check. If not given there is a list of defaults")
set(MSYS_FLAGS_TO_CHECK "${MSYS_DEFAULT_FLAGS_TO_CHECK}" CACHE STRING "Variables to check. If not given there is a list of defaults")
set(MSYS_ENV_VARS_TO_CHECK "${MSYS_DEFAULT_ENV_VARS_TO_CHECK}" CACHE STRING "Variables to check. If not given there is a list of defaults")

foreach(VAR IN LISTS MSYS_VARS_TO_CHECK)
    escaped(value "${${VAR}}")
    string(APPEND OUTPUT_STRING "set(${MSYS_VAR_PREFIX}_${VAR} \"${value}\")\n")
endforeach()

foreach(_env IN LISTS MSYS_ENV_VARS_TO_CHECK)
    if(CMAKE_HOST_WIN32)
        string(REPLACE "\\" "/" value "$ENV{${_env}}")
        escaped(value "${value}")
    else()
        escaped(value "$ENV{${_env}}")
    endif()
    string(APPEND OUTPUT_STRING "set(${MSYS_VAR_PREFIX}_ENV_${_env} \"${value}\")\n")
endforeach()

set(extra_flags "")
if(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN)
    if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
        string(APPEND extra_flags " \"${CMAKE_CXX_COMPILE_OPTIONS_EXTERNAL_TOOLCHAIN}${CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN}\"")
    else()
        string(APPEND extra_flags " ${CMAKE_CXX_COMPILE_OPTIONS_EXTERNAL_TOOLCHAIN} \"${CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN}\"")
    endif()
endif()
if(CMAKE_SYSROOT AND CMAKE_CXX_COMPILE_OPTIONS_SYSROOT)
    string(APPEND extra_flags " \"${CMAKE_CXX_COMPILE_OPTIONS_SYSROOT}${CMAKE_SYSROOT}\"")
endif()

macro(_MSYS_adjust_flags flag_var)
    if(MSVC) # Transform MSVC /flags to -flags due to msys2 runtime intepreting /flag as a path.
        string(REGEX REPLACE "(^| )/" "\\1-" ${flag_var} "${${flag_var}}")
        if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
            if("${flag_var}" STREQUAL "CMAKE_CXX_FLAGS")
                string(APPEND ${flag_var} " -ZW:nostdlib")
            endif()
        endif()
    endif()
    if(APPLE)
        set(flags_to_add_osx_arch_sysroot "${MSYS_LANG_FLAGS}" CMAKE_SHARED_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_EXE_LINKER_FLAGS)
        if("${flag_var}" IN_LIST flags_to_add_osx_arch_sysroot)
            # macOS - append arch and isysroot if cross-compiling
            if(NOT "${CMAKE_OSX_ARCHITECTURES}" STREQUAL "${CMAKE_HOST_SYSTEM_PROCESSOR}")
                foreach(arch IN LISTS CMAKE_OSX_ARCHITECTURES)
                    string(APPEND ${flag_var} " -arch ${arch}")
                endforeach()
            endif()
            string(APPEND ${flag_var} " -isysroot ${CMAKE_OSX_SYSROOT}")
            if (CMAKE_OSX_DEPLOYMENT_TARGET)
                list(GET MSYS_LANGUAGES 0 lang)
                string(APPEND ${flag_var} " ${CMAKE_${lang}_OSX_DEPLOYMENT_TARGET_FLAG}${CMAKE_OSX_DEPLOYMENT_TARGET}")
                unset(lang)
            endif()
        endif()
        unset(flags_to_add_osx_arch_sysroot)
    endif()
    set(flags_to_add_target "${MSYS_LANG_FLAGS}" CMAKE_SHARED_LINKER_FLAGS CMAKE_MODULE_LINKER_FLAGS CMAKE_EXE_LINKER_FLAGS)
    list(GET MSYS_LANGUAGES 0 lang)
    if(CMAKE_${lang}_COMPILER_TARGET AND "${flag_var}" IN_LIST flags_to_add_target)
        if (CMAKE_${lang}_COMPILER_ID STREQUAL Clang)
            string(PREPEND ${flag_var} "${CMAKE_${lang}_COMPILE_OPTIONS_TARGET}${CMAKE_${lang}_COMPILER_TARGET} ")
        elseif(CMAKE_${lang}_COMPILE_OPTIONS_TARGET)
            string(PREPEND ${flag_var} "${CMAKE_${lang}_COMPILE_OPTIONS_TARGET} ${CMAKE_${lang}_COMPILER_TARGET} ")
        endif()
    endif()
    if("${flag_var}" IN_LIST flags_to_add_target)
        string(APPEND ${flag_var} " ${extra_flags}")
    endif()
    unset(lang)
    unset(flags_to_add_target)
endmacro()

foreach(flag IN LISTS MSYS_FLAGS_TO_CHECK)
    string(STRIP "${${flag}}" ${flag}) # Strip leading and trailing whitespaces
    _MSYS_adjust_flags(${flag})
    escaped(value "${${flag}}")
    string(APPEND OUTPUT_STRING "set(${MSYS_VAR_PREFIX}_RAW_${flag} \" ${value}\")\n")
    foreach(config IN LISTS MSYS_CONFIGS)
        escaped(raw_value "${CMAKE_${flag}_FLAGS_${config}}")
        string(APPEND OUTPUT_STRING "set(${MSYS_VAR_PREFIX}_RAW_${flag}_${config} \"${raw_value}\")\n")
        string(STRIP "${${flag}_${config}}" ${flag}_${config})
        _MSYS_adjust_flags(${flag}_${config})
        escaped(combined_value "${${flag}} ${${flag}_${config}}")
        string(STRIP "${combined_value}" combined_value)
        string(APPEND OUTPUT_STRING "set(${MSYS_VAR_PREFIX}_${flag}_${config} \"${combined_value}\")\n")
    endforeach()
endforeach()

file(WRITE "${MSYS_OUTPUT_FILE}" "${OUTPUT_STRING}")

# Programs:
# CMAKE_AR
# CMAKE_<LANG>_COMPILER_AR (Wrapper)
# CMAKE_RANLIB
# CMAKE_<LANG>_COMPILER_RANLIB
# CMAKE_STRIP
# CMAKE_NM
# CMAKE_OBJDUMP
# CMAKE_DLLTOOL
# CMAKE_MT
# CMAKE_LINKER
# CMAKE_C_COMPILER
# CMAKE_CXX_COMPILER
# CMAKE_RC_COMPILER

# Flags:
# CMAKE_<LANG>_FLAGS
# CMAKE_<LANG>_FLAGS_<CONFIG>
# CMAKE_RC_FLAGS
# CMAKE_SHARED_LINKER_FLAGS
# CMAKE_STATIC_LINKER_FLAGS
# CMAKE_STATIC_LINKER_FLAGS_<CONFIG>
# CMAKE_EXE_LINKER_FLAGS
# CMAKE_EXE_LINKER_FLAGS_<CONFIG>
