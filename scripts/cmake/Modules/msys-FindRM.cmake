find_program(RM
  rm
#   ${CYGWIN_INSTALL_PATH}/bin
  ${Z_MSYS_ROOT_DIR}/usr/bin
)
mark_as_advanced(
  RM
)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(UnixCommands
  REQUIRED_VARS RM
)
