message("Loading ${CMAKE_CURRENT_LIST_FILE}")

function(z_msys_get_cmake_vars out_file)
    message("Calling ${CMAKE_CURRENT_FUNCTION}")

    cmake_parse_arguments(PARSE_ARGV 1 arg "" "" "")

    if(DEFINED arg_UNPARSED_ARGUMENTS)
        message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was passed extra arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(DEFINED MSYS_BUILD_TYPE)
        set(cmake_vars_file "${CURRENT_BUILDTREES_DIR}/cmake-vars-${TARGET_TRIPLET}-${MSYS_BUILD_TYPE}.cmake.log")
        set(cache_var "Z_MSYS_GET_CMAKE_VARS_FILE_${MSYS_BUILD_TYPE}")
    else()
        set(cmake_vars_file "${CURRENT_BUILDTREES_DIR}/cmake-vars-${TARGET_TRIPLET}.cmake.log")
        set(cache_var Z_MSYS_GET_CMAKE_VARS_FILE)
    endif()
    if(NOT DEFINED CACHE{${cache_var}})
        set(${cache_var}  "${cmake_vars_file}"
            CACHE PATH "The file to include to access the CMake variables from a generated project.")
        msys_configure_cmake(
            SOURCE_PATH "${SCRIPTS}/get_cmake_vars"
            OPTIONS_DEBUG "-DMSYS_OUTPUT_FILE:PATH=${CURRENT_BUILDTREES_DIR}/cmake-vars-${TARGET_TRIPLET}-dbg.cmake.log"
            OPTIONS_RELEASE "-DMSYS_OUTPUT_FILE:PATH=${CURRENT_BUILDTREES_DIR}/cmake-vars-${TARGET_TRIPLET}-rel.cmake.log"
            PREFER_NINJA
            LOGNAME get-cmake-vars-${TARGET_TRIPLET}
            Z_GET_CMAKE_VARS_USAGE # ignore msys_cmake_configure, be quiet, don't set variables...
        )

        set(include_string "")
        if(NOT DEFINED MSYS_BUILD_TYPE OR MSYS_BUILD_TYPE STREQUAL "release")
            string(APPEND include_string "include(\"\${CMAKE_CURRENT_LIST_DIR}/cmake-vars-${TARGET_TRIPLET}-rel.cmake.log\")\n")
        endif()
        if(NOT DEFINED MSYS_BUILD_TYPE OR MSYS_BUILD_TYPE STREQUAL "debug")
            string(APPEND include_string "include(\"\${CMAKE_CURRENT_LIST_DIR}/cmake-vars-${TARGET_TRIPLET}-dbg.cmake.log\")\n")
        endif()
        file(WRITE "${cmake_vars_file}" "${include_string}")
    endif()

    set("${out_file}" "${${cache_var}}" PARENT_SCOPE)
endfunction()
