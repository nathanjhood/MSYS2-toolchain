message("Loading ${CMAKE_CURRENT_LIST_FILE}")

function(msys_add_to_path)
    message("Calling ${CMAKE_CURRENT_FUNCTION}")

    cmake_parse_arguments(PARSE_ARGV 0 "arg" "PREPEND" "" "")
    if(arg_PREPEND)
        set(operation PREPEND)
    else()
        set(operation APPEND)
    endif()

    msys_host_path_list("${operation}" ENV{PATH} ${arg_UNPARSED_ARGUMENTS})
endfunction()
