macro(set_msys_target_triplet)
    set(MSYS_DEFAULT_TARGET_TRIPLET "${MSYS_DEFAULT_TARGET_TRIPLET_default}" CACHE STRING
    "Default target for which Msys64 will generate code." )
    if (TARGET_TRIPLET)
        message(WARNING "TARGET_TRIPLET is deprecated and will be removed in a future release. "
        "Please use MSYS_DEFAULT_TARGET_TRIPLET instead.")
        set(MSYS_TARGET_TRIPLET "${TARGET_TRIPLET}")
    else()
        set(MSYS_TARGET_TRIPLET "${MSYS_DEFAULT_TARGET_TRIPLET}")
    endif()
    message(STATUS "Msys64 host triplet: ${MSYS_HOST_TRIPLET}")
    message(STATUS "Msys64 default target triplet: ${MSYS_DEFAULT_TARGET_TRIPLET}")
endmacro()
