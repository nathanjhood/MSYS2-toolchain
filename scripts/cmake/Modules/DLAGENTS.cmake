# Source: ${MSYS_ROOT}/etc/makepkg_mingw.conf
#########################################################################
# SOURCE ACQUISITION
#########################################################################
#
#-- The download utilities that makepkg should use to acquire sources
#
#########################################################################

# DLAGENT_<PROTOCOL> - psuedo-code for a wrapper function...
macro(create_download_agent _protocol _program _args _output_file _user)
    option(ENABLE_DLAGENT_${_protocol} "Enable the file download agent utility <${_protocol}>." ON)
    if(ENABLE_DLAGENT_${_protocol})
        find_program(DLAGENT_ "${Z_MSYS_ROOT_DIR}/usr/bin/${_program}")
        mark_as_advanced(DLAGENT_${_protocol})
        set(DLAGENT_${_protocol}_FLAGS "")
        string(APPEND DLAGENT_${_protocol}_FLAGS "${_args} ")
        # string(APPEND DLAGENT_${_protocol}_FLAGS "- ")
        # string(APPEND DLAGENT_${_protocol}_FLAGS "-o ")
        # string(APPEND DLAGENT_${_protocol}_FLAGS "- ")
        string(APPEND DLAGENT_${_protocol}_FLAGS "${_output_file} ") # %o
        if(DEFINED _user)
            string(APPEND DLAGENT_${_protocol}_FLAGS "${_user} ") # %u
        endif()
        set(DLAGENT_${_protocol}_FLAGS "${DLAGENT_${_protocol}_FLAGS}" CACHE STRING "The arguments passed to the standard download agent utility command (file)." FORCE)
        set(DLAGENT_${_protocol}_COMMAND "${DLAGENT_${_protocol}} ${DLAGENT_${_protocol}_FLAGS}" CACHE STRING "The standard command for the download agent utility (file)." FORCE)
        set(DLAGENT_${_protocol} "${_protocol}::${DLAGENT_${_protocol}_COMMAND}" CACHE STRING "The standard download agent utility (file)." FORCE)
    endif()
    unset(_protocol)
    unset(_program)
    unset(_args)
    unset(_output_file)
    if(DEFINED _user)
        unset(_user)
    endif()
endmacro()


# Something like this with perhaps wrapping CMake custom command (to use as a build target)
# would be pretty awesome...eventually.
# Currently it's not clear how to patch the correct path to the namespace, whether the
# string(s) might best be something like 'ftp::/c/msys64/usr/bin/curl'

# macro(create_download_agent _protocol _program _args _output_file _user)
#     string(TOUPPER "${_protocol}" _protocol_upper)
#     string(TOLOWER "${_protocol}" _protocol_lower)
#     option(ENABLE_DLAGENT_${_protocol_upper} "Enable the file download agent utility <${_protocol_upper}>." ON)
#     if(ENABLE_DLAGENT_${_protocol_upper})
#         find_program(DLAGENT_${_protocol_upper} "${_program}")
#         mark_as_advanced(DLAGENT_${_protocol_upper})
#         set(DLAGENT_${_protocol_upper}_FLAGS "")
#         string(APPEND DLAGENT_${_protocol_upper}_FLAGS "${_args} ")
#         # string(APPEND DLAGENT_${_protocol}_FLAGS "- ")
#         # string(APPEND DLAGENT_${_protocol}_FLAGS "-o ")
#         # string(APPEND DLAGENT_${_protocol}_FLAGS "- ")
#         string(APPEND DLAGENT_${_protocol_upper}_FLAGS "${_output_file} ") # %o
#         if(DEFINED _user)
#             string(APPEND DLAGENT_${_protocol_upper}_FLAGS "${_user} ") # %u
#         endif()
#         set(DLAGENT_${_protocol_upper}_FLAGS "${DLAGENT_${_protocol_upper}_FLAGS}" CACHE STRING "The arguments passed to the standard download agent utility command (file)." FORCE)
#         set(DLAGENT_${_protocol_upper}_COMMAND "${DLAGENT_${_protocol_upper}} ${DLAGENT_${_protocol_upper}_FLAGS}" CACHE STRING "The standard command for the download agent utility (file)." FORCE)
#         set(DLAGENT_${_protocol_upper} "${_protocol_lower}::${DLAGENT_${_protocol_upper}_COMMAND}" CACHE STRING "The standard download agent utility (file)." FORCE)
#     endif()
#     unset(_protocol)
#     unset(_protocol_upper)
#     unset(_protocol_lower)
#     unset(_program)
#     unset(_args)
#     unset(_output_file)
#     if(DEFINED _user)
#         unset(_user)
#     endif()
# endmacro()

##create_download_agent(${_protocol} ${_program}                        ${_args}                                                ${_output_file}               ${_user})
# create_download_agent(FTP         "${Z_MSYS_ROOT_DIR}/usr/bin/curl"   "-gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u" "${CMAKE_BINARY_DIR}/ftp.txt" "StoneyDSP")

# Would also perhaps be nice to add an optional switch: 'DLAGENT_<PROTOCOL>_NO_VERBOSE'
# This option would be available only when the tool itself is enabled, *and* verbosity has
# been enabled at a higher level (such as MSYS_VERBOSE or ENV{VERBOSE}) - just in case one
# particular tool or two has a tendency to drown us in output while we're trying to inspect
# other tools in the build chain...

# For now, let's stick with what's in the MSYS-provided makepkg config files and expand a little;

option(ENABLE_DLAGENT_FILE "Enable the file download agent utility <FILE>." ON)
if(ENABLE_DLAGENT_FILE)
    find_program(DLAGENT_FILE "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
    mark_as_advanced(DLAGENT_FILE)
    if(NOT DEFINED DLAGENT_FILE_FLAGS)
        # set(DLAGENT_FILE_FLAGS "-gqC - -o %o %u")
        set(DLAGENT_FILE_FLAGS "")
        string(APPEND DLAGENT_FILE_FLAGS "-gqC ")
        if(MSYS_VERBOSE)
            string(APPEND DLAGENT_FILE_FLAGS "--verbose ")
        endif()
        string(APPEND DLAGENT_FILE_FLAGS "- ")
        string(APPEND DLAGENT_FILE_FLAGS "-o ")
        string(APPEND DLAGENT_FILE_FLAGS "- ")
        # string(APPEND DLAGENT_FILE_FLAGS "${_output_file} ") # %o
        # string(APPEND DLAGENT_FILE_FLAGS "${_user} ") # %u
    endif()
    set(DLAGENT_FILE_FLAGS "${DLAGENT_FILE_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <FILE>." FORCE)
    set(DLAGENT_FILE_COMMAND "${DLAGENT_FILE} ${DLAGENT_FILE_FLAGS}") # CACHE STRING "The file download agent utility command <FILE>." FORCE)
    string(STRIP "${DLAGENT_FILE_COMMAND}" DLAGENT_FILE_COMMAND)
    set(DLAGENT_FILE "file::${DLAGENT_FILE_COMMAND}" CACHE STRING "The standard command for downloads <FILE>." FORCE)
endif()

option(ENABLE_DLAGENT_FTP "Enable the file download agent utility <FTP>." ON)
if(ENABLE_DLAGENT_FTP)
    find_program(DLAGENT_FTP "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
    mark_as_advanced(DLAGENT_FTP)
    if(NOT DEFINED DLAGENT_FTP_FLAGS)
        # set(DLAGENT_FTP_FLAGS "-gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u")
        set(DLAGENT_FTP_FLAGS "")
        string(APPEND DLAGENT_FTP_FLAGS "-gqfC ")
        if(MSYS_VERBOSE)
            string(APPEND DLAGENT_FTP_FLAGS "--verbose ")
        endif()
        string(APPEND DLAGENT_FTP_FLAGS "- ")
        string(APPEND DLAGENT_FTP_FLAGS "--ftp-pasv ")
        string(APPEND DLAGENT_FTP_FLAGS "--retry 3 ")
        string(APPEND DLAGENT_FTP_FLAGS "--retry-delay 3 ")
        string(APPEND DLAGENT_FTP_FLAGS "-o ")
        # string(APPEND DLAGENT_FTP_FLAGS "${_output_file} ") # %o
        # string(APPEND DLAGENT_FTP_FLAGS "${_user} ") # %u
    endif()
    set(DLAGENT_FTP_FLAGS "${DLAGENT_FTP_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <FTP>." FORCE)
    set(DLAGENT_FTP_COMMAND "${DLAGENT_FTP} ${DLAGENT_FTP_FLAGS}") # CACHE STRING "The file download agent utility command <FTP>." FORCE)
    string(STRIP "${DLAGENT_FTP_COMMAND}" DLAGENT_FTP_COMMAND)
    set(DLAGENT_FTP "ftp::${DLAGENT_FTP_COMMAND}" CACHE STRING "The standard command for downloads <FTP>." FORCE)
endif()

option(ENABLE_DLAGENT_HTTP "Enable the file download agent utility <HTTP>." ON)
if(ENABLE_DLAGENT_HTTP)
    find_program(DLAGENT_HTTP "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
    mark_as_advanced(DLAGENT_HTTP)
    if(NOT DEFINED DLAGENT_HTTP_FLAGS)
        # set(DLAGENT_HTTP_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
        set(DLAGENT_HTTP_FLAGS "")
        string(APPEND DLAGENT_HTTP_FLAGS "-gqb ")
        string(APPEND DLAGENT_HTTP_FLAGS "\"\" ")
        string(APPEND DLAGENT_HTTP_FLAGS "-fLC ")
        string(APPEND DLAGENT_HTTP_FLAGS "- ")
        string(APPEND DLAGENT_HTTP_FLAGS "--retry 3 ")
        string(APPEND DLAGENT_HTTP_FLAGS "--retry-delay 3 ")
        string(APPEND DLAGENT_HTTP_FLAGS "-o ")
        # string(APPEND DLAGENT_HTTP_FLAGS "${_output_file} ") # %o
        # string(APPEND DLAGENT_HTTP_FLAGS "${_user} ") # %u
    endif()
    set(DLAGENT_HTTP_FLAGS "${DLAGENT_HTTP_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <HTTP>." FORCE)
    set(DLAGENT_HTTP_COMMAND "${DLAGENT_HTTP} ${DLAGENT_HTTP_FLAGS}") # CACHE STRING "The file download agent utility command <HTTP>." FORCE)
    string(STRIP "${DLAGENT_HTTP_COMMAND}" DLAGENT_HTTP_COMMAND)
    set(DLAGENT_HTTP "http::${DLAGENT_HTTP_COMMAND}" CACHE STRING "The standard command for downloads <HTTP>." FORCE)
endif()

option(ENABLE_DLAGENT_HTTPS "Enable the file download agent utility <HTTPS>." ON)
if(ENABLE_DLAGENT_HTTPS)
    find_program(DLAGENT_HTTPS "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
    mark_as_advanced(DLAGENT_HTTPS)
    if(NOT DEFINED DLAGENT_HTTPS_FLAGS)
        # set(DLAGENT_HTTPS_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
        set(DLAGENT_HTTPS_FLAGS "")
        string(APPEND DLAGENT_HTTPS_FLAGS "-gqb ")
        string(APPEND DLAGENT_HTTPS_FLAGS "\"\" ")
        string(APPEND DLAGENT_HTTPS_FLAGS "-fLC ")
        string(APPEND DLAGENT_HTTPS_FLAGS "- ")
        string(APPEND DLAGENT_HTTPS_FLAGS "--retry 3 ")
        string(APPEND DLAGENT_HTTPS_FLAGS "--retry-delay 3 ")
        string(APPEND DLAGENT_HTTPS_FLAGS "-o ")
        # string(APPEND DLAGENT_HTTPS_FLAGS "${_output_file} ") # %o
        # string(APPEND DLAGENT_HTTPS_FLAGS "${_user} ") # %u
    endif()
    set(DLAGENT_HTTPS_FLAGS "${DLAGENT_HTTPS_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <HTTPS>." FORCE)
    set(DLAGENT_HTTPS_COMMAND "${DLAGENT_HTTPS} ${DLAGENT_HTTPS_FLAGS}") # CACHE STRING "The file download agent utility command <HTTPS>." FORCE)
    string(STRIP "${DLAGENT_HTTPS_COMMAND}" DLAGENT_HTTPS_COMMAND)
    set(DLAGENT_HTTPS "https::${DLAGENT_HTTPS_COMMAND}" CACHE STRING "The standard command for downloads <HTTPS>." FORCE)
endif()


option(ENABLE_DLAGENT_RSYNC "Enable the file download agent utility <RSYNC>." ON)
if(ENABLE_DLAGENT_RSYNC)
    find_program(DLAGENT_RSYNC "${Z_MSYS_ROOT_DIR}/usr/bin/rsync")
    mark_as_advanced(DLAGENT_RSYNC)
    if(NOT DEFINED DLAGENT_RSYNC_FLAGS)
        # set(DLAGENT_RSYNC_FLAGS "--no-motd -z %u %o")
        set(DLAGENT_RSYNC_FLAGS "")
        string(APPEND DLAGENT_RSYNC_FLAGS "--no-motd ")
        if(MSYS_VERBOSE)
            string(APPEND DLAGENT_RSYNC_FLAGS "--verbose ")
        endif()
        string(APPEND DLAGENT_RSYNC_FLAGS "-z ")
        # string(APPEND DLAGENT_RSYNC_FLAGS "${_user} ") # %u
        # string(APPEND DLAGENT_RSYNC_FLAGS "${_output_file} ") # %o
    endif()
    set(DLAGENT_RSYNC_FLAGS "${DLAGENT_RSYNC_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <RSYNC>." FORCE)
    set(DLAGENT_RSYNC_COMMAND "${DLAGENT_RSYNC} ${DLAGENT_RSYNC_FLAGS}") # CACHE STRING "The file download agent utility command <RSYNC>." FORCE)
    string(STRIP "${DLAGENT_RSYNC_COMMAND}" DLAGENT_RSYNC_COMMAND)
    set(DLAGENT_RSYNC "rsync::${DLAGENT_RSYNC_COMMAND}" CACHE STRING "The standard command for downloads <RSYNC>." FORCE)
endif()

option(ENABLE_DLAGENT_SCP "Enable the file download agent utility <SCP>." ON)
if(ENABLE_DLAGENT_SCP)
    find_program(DLAGENT_SCP "${Z_MSYS_ROOT_DIR}/usr/bin/scp")
    mark_as_advanced(DLAGENT_SCP)
    if(NOT DEFINED DLAGENT_SCP_FLAGS)
        # set(DLAGENT_SCP_FLAGS "--no-motd -z %u %o")
        set(DLAGENT_SCP_FLAGS "")
        if(MSYS_VERBOSE)
            string(APPEND DLAGENT_SCP_FLAGS "--verbose ")
        endif()
        string(APPEND DLAGENT_SCP_FLAGS "-C ")
        # string(APPEND DLAGENT_SCP_FLAGS "${_user} ") # %u
        # string(APPEND DLAGENT_SCP_FLAGS "${_output_file} ") # %o
    endif()
    set(DLAGENT_SCP_FLAGS "${DLAGENT_SCP_FLAGS}") # CACHE STRING "The arguments passed to the standard download agent utility command <SCP>." FORCE)
    set(DLAGENT_SCP_COMMAND "${DLAGENT_SCP} ${DLAGENT_SCP_FLAGS}") # CACHE STRING "The file download agent utility command <SCP>." FORCE)
    string(STRIP "${DLAGENT_SCP_COMMAND}" DLAGENT_SCP_COMMAND)
    set(DLAGENT_SCP "scp::${DLAGENT_SCP_COMMAND}" CACHE STRING "The standard command for downloads <SCP>." FORCE)
endif()

#  Format: 'protocol::agent'
set(DLAGENTS "")
list(APPEND DLAGENTS
    "${DLAGENT_FILE}"
    "${DLAGENT_FTP}"
    "${DLAGENT_HTTP}"
    "${DLAGENT_HTTPS}"
    "${DLAGENT_RSYNC}"
    "${DLAGENT_SCP}"
)
set(DLAGENTS "${DLAGENTS}") # CACHE STRING "The standard agents for downloads. Format: 'protocol::agent [flags]'." FORCE)

#-- The package required by makepkg to download VCS sources.
# We can use vcpkg to fetch these for linking our packages with.
# Format: 'protocol::package'
set(VCSCLIENTS "")
list(APPEND VCSCLIENTS bzr::bzr)
list(APPEND VCSCLIENTS fossil::fossil)
list(APPEND VCSCLIENTS git::git)
list(APPEND VCSCLIENTS hg::mercurial)
list(APPEND VCSCLIENTS svn::subversion)
set(VCSCLIENTS "${VCSCLIENTS}" CACHE STRING "The package(s) required by makepkg to download VCS sources." FORCE)

##-- Here were set the <agent> handlers
# set(DLAGENT_FILE "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
# set(DLAGENT_FTP "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
# set(DLAGENT_HTTP "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
# set(DLAGENT_HTTPS "${Z_MSYS_ROOT_DIR}/usr/bin/curl")
# set(DLAGENT_RSYNC "${Z_MSYS_ROOT_DIR}/usr/bin/rsync")
# set(DLAGENT_SCP "${Z_MSYS_ROOT_DIR}/usr/bin/scp")

##-- Here were set the <agent> flags for each <protocol>
# set(DLAGENT_FILE_FLAGS "-gqC - -o %o %u")
# set(DLAGENT_FTP_FLAGS "-gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u")
# set(DLAGENT_HTTP_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
# set(DLAGENT_HTTPS_FLAGS "-gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u")
# set(DLAGENT_RSYNC_FLAGS "--no-motd -z %u %o")
# set(DLAGENT_SCP_FLAGS "-C %u %o")

##-- Wrap agent paths with their flags into commands
# set(DLAGENT_FILE_COMMAND "${DLAGENT_FILE} ${DLAGENT_FILE_FLAGS}" CACHE STRING "The standard command for downloads (file)." FORCE)
# set(DLAGENT_FTP_COMMAND  "ftp::${DLAGENT_FTP} ${DLAGENT_FTP_FLAGS}" CACHE STRING "The standard command for downloads (ftp)." FORCE)
# set(DLAGENT_HTTP_COMMAND "http::${DLAGENT_HTTP} ${DLAGENT_HTTP_FLAGS}" CACHE STRING "The standard command for downloads (http)." FORCE)
# set(DLAGENT_HTTPS_COMMAND "https::${DLAGENT_HTTPS} ${DLAGENT_HTTPS_FLAGS}" CACHE STRING "The standard command for downloads (https)." FORCE)
# set(DLAGENT_RSYNC_COMMAND "rsync::${DLAGENT_RSYNC} ${DLAGENT_RSYNC_FLAGS}" CACHE STRING "The standard command for downloads (rsync)." FORCE)
# set(DLAGENT_SCP_COMMAND "scp::${DLAGENT_SCP} ${DLAGENT_SCP_FLAGS}" CACHE STRING "The standard command for downloads (scp)." FORCE)

##-- In other words...
# set(DLAGENTS
#     "file::/usr/bin/curl -gqC - -o %o %u"
#     "ftp::/usr/bin/curl -gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u"
#     "http::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
#     "https::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
#     "rsync::/usr/bin/rsync --no-motd -z %u %o"
#     "scp::/usr/bin/scp -C %u %o"
# )

##-- Other common tools:
# /usr/bin/snarf
# /usr/bin/lftpget -c
# /usr/bin/wget (instead of curl? Could be on a switch...)
