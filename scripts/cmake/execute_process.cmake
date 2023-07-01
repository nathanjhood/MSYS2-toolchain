message("Loading ${CMAKE_CURRENT_LIST_FILE}")

if (NOT DEFINED Z_MSYS_OVERRIDEN_EXECUTE_PROCESS)
    set(Z_MSYS_OVERRIDEN_EXECUTE_PROCESS ON)

    if (DEFINED MSYS_DOWNLOAD_MODE)
        function(execute_process)
            message(FATAL_ERROR "This command cannot be executed in Download Mode.\nHalting portfile execution.\n")
        endfunction()
            set(Z_MSYS_EXECUTE_PROCESS_NAME "_execute_process")
    else()
        set(Z_MSYS_EXECUTE_PROCESS_NAME "execute_process")
    endif()
endif()
