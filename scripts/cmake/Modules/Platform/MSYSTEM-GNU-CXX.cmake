if(TRACE_MODE)
    message("Enter: ${CMAKE_CURRENT_LIST_FILE}")
endif()

include(Platform/MSYSTEM-GNU)
__msystem_mingw_compiler_gnu(CXX)

if(TRACE_MODE)
    message("Exit: ${CMAKE_CURRENT_LIST_FILE}")
endif()
