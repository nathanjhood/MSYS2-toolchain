find_program(GZ
  gzip
#   ${CYGWIN_INSTALL_PATH}/bin
  ${Z_MSYS_ROOT_DIR}/usr/bin
)
mark_as_advanced(
  GZ
)

include(${CMAKE_CURRENT_LIST_DIR}/FindPackageHandleStandardArgs.cmake)
find_package_handle_standard_args(UnixCommands
  REQUIRED_VARS GZ
)

# z_vcpkg_acquire_msys_declare_package(
#     URL "https://mirror.msys2.org/msys/x86_64/gzip-1.12-2-x86_64.pkg.tar.zst"
#     SHA512 107754050a4b0f8633d680fc05aae443ff7326f67517f0542ce2d81b8a1eea204a0006e8dcf3de42abb3be3494b7107c30aba9a4d3d03981e9cacdc9a32ea854
#     DEPS bash
# )
