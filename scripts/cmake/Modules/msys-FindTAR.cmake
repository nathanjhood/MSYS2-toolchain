find_program(TAR
  NAMES
    tar
    gtar
  PATH
    # ${CYGWIN_INSTALL_PATH}/bin
    ${Z_MSYS_ROOT_DIR}/usr/bin
)
mark_as_advanced(
  TAR
)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(UnixCommands
  REQUIRED_VARS TAR
)
