#!/usr/bin/env cmake

# Mark variables as used so cmake doesn't complain about them
mark_as_advanced(CMAKE_TOOLCHAIN_FILE)

# this is defined above everything else so that it can be used.
set(Z_MSYS_FATAL_ERROR)
set(Z_MSYS_HAS_FATAL_ERROR OFF)

#Sensible error logging.
function(z_msys_add_fatal_error ERROR)
    if(NOT Z_MSYS_HAS_FATAL_ERROR)
        set(Z_MSYS_HAS_FATAL_ERROR ON PARENT_SCOPE)
        set(Z_MSYS_FATAL_ERROR "${ERROR}" PARENT_SCOPE)
    else()
        string(APPEND Z_MSYS_FATAL_ERROR "\n${ERROR}")
    endif()
endfunction()

##-- To activate windows native symlinks uncomment next line
#MSYS=winsymlinks:nativestrict
##-- Set debugging program for errors
#MSYS=error_start:mingw64/bin/qtcreator.exe|-debug|<process-id>
#CHERE_INVOKING=1
##-- To export full current PATH from environment into MSYS2 use '-use-full-path' parameter
##-- or uncomment next line
#MSYS2_PATH_TYPE=inherit

if(DEFINED MSYSTEM)
    set(MSYSTEM "${MSYSTEM}")
elseif(DEFINED ENV{MSYSTEM})
    set(MSYSTEM "$ENV{MSYSTEM}")
else()
    set(MSYSTEM "MINGW64") # Fallthrough default MSYSTEM...
endif()

# Detect msys2.ini to figure MSYS_ROOT_DIR
set(Z_MSYS_ROOT_DIR_CANDIDATE "${CMAKE_CURRENT_LIST_DIR}")
while(NOT DEFINED Z_MSYS_ROOT_DIR)
    if(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(EXISTS "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64/msys2.ini")
        set(Z_MSYS_ROOT_DIR "${Z_MSYS_ROOT_DIR_CANDIDATE}msys64" CACHE INTERNAL "msys root directory")
    elseif(IS_DIRECTORY "${Z_MSYS_ROOT_DIR_CANDIDATE}")
        get_filename_component(Z_MSYS_ROOT_DIR_TEMP "${Z_MSYS_ROOT_DIR_CANDIDATE}" DIRECTORY)
        if(Z_MSYS_ROOT_DIR_TEMP STREQUAL Z_MSYS_ROOT_DIR_CANDIDATE)
            break() # If unchanged, we have reached the root of the drive without finding vcpkg.
        endif()
        set(Z_MSYS_ROOT_DIR_CANDIDATE "${Z_MSYS_ROOT_DIR_TEMP}")
        unset(Z_MSYS_ROOT_DIR_TEMP)
    else()
        break()
    endif()
endwhile()
unset(Z_MSYS_ROOT_DIR_CANDIDATE)

if(NOT Z_MSYS_ROOT_DIR)
    z_msys_add_fatal_error("Could not find '<Z_MSYS_ROOT_DIR>/msys2.ini' your msys64 installation may be broken?")
endif()

find_program(BASH bash "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(BASH)
set(LOGINSHELL "${BASH}")
#set(msys2_shiftCounter 0)

find_program(MINTTY mintty "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(MINTTY)

find_program(PACMAN pacman "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(PACMAN)

find_program(CYGPATH cygpath "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(CYGPATH)

find_program(ENV_EXECUTABLE env "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH) # Nice but not a clever name...
mark_as_advanced(ENV_EXECUTABLE)

find_program(NPROC nproc "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(NPROC)

find_program(UNAME uname "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(UNAME)

find_program(WHEREIS whereis "${Z_MSYS_ROOT_DIR}/usr/bin" NO_SYSTEM_ENVIRONMENT_PATH)
mark_as_advanced(WHEREIS)

function(printhelp)
    message(" Usage:")
    message("     %~1 [options] [login shell parameters]")
    message(" \n")
    message(" Options:")
    message("     -mingw32 ^| -mingw64 ^| -ucrt64 ^| -clang64 ^| -msys[2]   Set shell type")
    message("     -defterm ^| -mintty ^| -conemu                            Set terminal type")
    message("     -here                            Use current directory as working")
    message("                                      directory")
    message("     -where DIRECTORY                 Use specified DIRECTORY as working")
    message("                                      directory")
    message("     -[use-]full-path                 Use full current PATH variable")
    message("                                      instead of trimming to minimal")
    message("     -no-start                        Do not use \"start\" command and")
    message("                                      return login shell resulting")
    message("                                      errorcode as this batch file")
    message("                                      resulting errorcode")
    message("     -shell SHELL                     Set login shell")
    message("     -help ^| --help ^| -? ^| /?      Display this help and exit")
    message(" \n")
    message(" Any parameter that cannot be treated as valid option and all")
    message(" following parameters are passed as login shell command parameters.")
    message(" \n")
endfunction()

function(checkparams _param)
    # Help option
    if (_param STREQUAL "x-help") # Arg 1 == "x-help"
        printhelp()
        return()
    elseif (_param STREQUAL "x--help")
        printhelp()
        return()
    elseif (_param STREQUAL "x-?")
        printhelp()
        return()
    elseif (_param STREQUAL "x/?")
        printhelp()
        return()
    else()
        z_msys_add_fatal_error("checkparams() Could not find a matching parameter for ${_param}")
        return()
    endif()
endfunction()

function(cleanvars)
    set(msys2_arg "")
    set(msys2_shiftCounter "")
    set(msys2_full_cmd "")
    unset(msys2_arg)
    unset(msys2_shiftCounter)
    unset(msys2_full_cmd)
endfunction()

function(conemudetect)
    unset(ComEmuCommand)
    if (DEFINED ConEmuDir)
        if(EXISTS "${ConEmuDir}/ConEmu64.exe")
            set(ComEmuCommand "${ConEmuDir}/ConEmu64.exe")
            set(MSYSCON conemu64.exe)
        elseif(EXISTS "${ConEmuDir}/ConEmu.exe")
            set(ComEmuCommand "${ConEmuDir}/ConEmu.exe")
            set(MSYSCON conemu.exe)
        endif()
    endif()
    if(NOT DEFINED ComEmuCommand)
        execute_process(
            COMMAND ConEmu64.exe "/Exit" # 2>nul
        )
            set(ComEmuCommand ConEmu64.exe)
            set(MSYSCON conemu64.exe)
        # If the above fails then test the below as well
        execute_process(
            COMMAND ConEmu.exe "/Exit" # 2>nul &&
        )
            set(ComEmuCommand ConEmu.exe)
            set(MSYSCON conemu.exe)
    endif()
    if(NOT DEFINED ComEmuCommand)
    #   FOR /F "tokens=*" %%A IN ('reg.exe QUERY "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\ConEmu64.exe" /ve 2^>nul ^| find "REG_SZ"') DO (
    #     set(ComEmuCommand "%%A")
    #   )
        if(DEFINED ComEmuCommand)
            #call set "ComEmuCommand=%%ComEmuCommand:*REG_SZ    =%%"
            set(MSYSCON conemu64.exe)
        else()
            #FOR /F "tokens=*" %%A IN ('reg.exe QUERY "HKLM\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\App Paths\\ConEmu.exe" /ve 2^>nul ^| find "REG_SZ"') DO (
            set(ComEmuCommand "%%A")
        endif()
        if(DEFINED ComEmuCommand)
            #call set "ComEmuCommand=%%ComEmuCommand:*REG_SZ    =%%"
            set(MSYSCON conemu.exe)
        endif()
    endif()
    if(NOT DEFINED ComEmuCommand)# exit /b 2
        #exit /b 0
        set(CONSOLE_EMULATOR_FOUND FALSE  PARENT_SCOPE)
    else()
        set(CONSOLE_EMULATOR_FOUND TRUE PARENT_SCOPE)
        set(MSYSCON "${MSYSCON}" PARENT_SCOPE)
        set(CONSOLE_EMULATOR_COMMAND "${ComEmuCommand}" PARENT_SCOPE)
        set(CONSOLE_EMULATOR_DIRECTORY "${ComEmuDir}" PARENT_SCOPE)
    endif()
endfunction()

function(startmintty)
    if (NOT DEFINED MSYS2_NOSTART)
        #start "%CONTITLE%" "%WD%mintty" -i "/%CONICON%" -t "%CONTITLE%" "/usr/bin/%LOGINSHELL%" -l !SHELL_ARGS!
        execute_process(
            COMMAND "${CONTITLE}" "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mintty" -i "/${CONICON}" -t "${CONTITLE}" "${Z_MSYS_ROOT_DIR}/usr/bin/${LOGINSHELL}" -l "${SHELL_ARGS}"
        )
    else()
        #"%WD%mintty" -i "/%CONICON%" -t "%CONTITLE%" "/usr/bin/%LOGINSHELL%" -l !SHELL_ARGS!
        #exit /b %ERRORLEVEL%
        execute_process(
            COMMAND "${CMAKE_CURRENT_FUNCTION_LIST_DIR}/mintty" -i "/${CONICON}" -t "${CONTITLE}" "${Z_MSYS_ROOT_DIR}/usr/bin/${LOGINSHELL}" -l "${SHELL_ARGS}"
        )
    endif()
endfunction()

function(startconemu)
    conemudetect()
    if(NOT CONSOLE_EMULATOR_FOUND)
        # If the above detection function fails, then print this and exit.
        z_msys_add_fatal_error("ConEmu not found. Exiting.")
        return()
    else()
        if (NOT DEFINED MSYS2_NOSTART)
            #start "%CONTITLE%" "%ComEmuCommand%" /Here /Icon "%WD%..\..\%CONICON%" /cmd "%WD%\%LOGINSHELL%" -l !SHELL_ARGS!
        else()
            #"%ComEmuCommand%" /Here /Icon "%WD%..\..\%CONICON%" /cmd "%WD%\%LOGINSHELL%" -l !SHELL_ARGS!
            #exit /b %ERRORLEVEL%
        endif()
    endif()
endfunction()

function(startsh)
    unset(MSYSCON)
    if (NOT DEFINED MSYS2_NOSTART)
        #start "%CONTITLE%" "%WD%\%LOGINSHELL%" -l !SHELL_ARGS!
    else()
        #"%WD%\%LOGINSHELL%" -l !SHELL_ARGS!
        #exit /b %ERRORLEVEL%
    endif()
endfunction()

set(MIRROR_URL "https://mirror.msys2.org") # geo redirection service for Tier 1 mirrors
set(REPO_URL "https://repo.msys2.org/") # primary

set(MSYS2_PATH)
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/usr/local/bin")
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/usr/bin")
list(APPEND MSYS2_PATH "${Z_MSYS_ROOT_DIR}/bin")
set(MSYS2_PATH "${MSYS2_PATH}" CACHE PATH "<MSYS2_PATH>" FORCE)
set(MANPATH)
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/local/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/share/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/usr/man")
list(APPEND MANPATH "${Z_MSYS_ROOT_DIR}/share/man")
set(MANPATH "${MANPATH}" CACHE PATH "<MANPATH>" FORCE)
set(INFOPATH)
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/local/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/share/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/usr/info")
list(APPEND INFOPATH "${Z_MSYS_ROOT_DIR}/share/info")
set(INFOPATH "${INFOPATH}" CACHE PATH "<INFOPATH>" FORCE)


if(MSYS2_PATH_TYPE STREQUAL "-strict")

    # Do not inherit any path configuration, and allow for full customization
    # of external path. This is supposed to be used in special cases such as
    # debugging without need to change this file, but not daily usage.
    unset(ORIGINAL_PATH)

elseif(MSYS2_PATH_TYPE STREQUAL "-inherit")

    # Inherit previous path. Note that this will make all of the Windows path
    # available in current shell, with possible interference in project builds.
    # ORIGINAL_PATH="${ORIGINAL_PATH:-${PATH}}"
    set(ORIGINAL_PATH "$ENV{Path}")

elseif(MSYS2_PATH_TYPE STREQUAL "-minimal")

    # WIN_ROOT="$(PATH=${MSYS2_PATH} exec cygpath -Wu)"
    if(DEFINED ENV{WINDIR})
        set(WIN_ROOT "$ENV{WINDIR}")
    else()
        set(WIN_ROOT "C:/Windows")
    endif()
    set(ORIGINAL_PATH "${WIN_ROOT}/System32" "${WIN_ROOT}" "${WIN_ROOT}/System32/Wbem" "${WIN_ROOT}/System32/WindowsPowerShell/v1.0/")

endif()

set(MSYS_LIBRARY_LINKAGE "dynamic")

if(MSYSTEM STREQUAL "MINGW32")

    set(CONTITLE "MinGW x32")
    set(CONICON "mingw32.ico")

    set(CARCH "i686")
    set(CHOST "i686-w64-mingw32")

    set(MINGW_CHOST "i686-w64-mingw32")
    set(MINGW_PREFIX "/mingw32")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/mingw32")
    set(MSYSTEM_CARCH "i686")
    set(MSYSTEM_CHOST "i686-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/i686/mingw32.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw32")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-i686-")

    #set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "gcc")
    set(CXX "g++")

    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-march=pentium4 -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe -Wl,--no-seh -Wl,--large-address-aware")

    # set(MAN_DIRS("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info}) )
    # set(DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc}) )
    # set(PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod) )

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "MINGW64")

    set(CONTITLE "MinGW x64")
    set(CONICON "mingw64.ico")

    set(CARCH "x86_64")
    set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/mingw64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/mingw64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/x86_64/mingw64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.mingw64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-x86_64-")

    # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "gcc")
    set(CXX "g++")

    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "UCRT64")

    set(CONTITLE "MinGW UCRT x64")
    set(CONICON "ucrt64.ico")

    set(CARCH "x86_64")
    set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/ucrt64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-ucrt-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/ucrt64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/ucrt64/ucrt64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.ucrt64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-ucrt-x86_64-")

    # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "gcc")
    set(CXX "g++")
    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "CLANG64")

    set(CONTITLE "MinGW Clang x64")
    set(CONICON "clang64.ico")

    set(CARCH "x86_64")
    set(CHOST "x86_64-w64-mingw32")

    set(MINGW_CHOST "x86_64-w64-mingw32")
    set(MINGW_PREFIX "/clang64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-x86_64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clang64/clang64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-x86_64-")

    # set(PATH "${MINGW_MOUNT_POINT}/bin" "${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "clang")
    set(CXX "clang++")
    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "CLANG32")

    set(CONTITLE "MinGW Clang x32")
    set(CONICON "clang32.ico")

    set(CARCH "i686")
    set(CHOST "i686-w64-mingw32")

    set(MINGW_CHOST "i686-w64-mingw32")
    set(MINGW_PREFIX "/mingw32")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-i686")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang32")
    set(MSYSTEM_CARCH "i686")
    set(MSYSTEM_CHOST "i686-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clang32/clang32.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clang32")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-i686-")

    # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "gcc")
    set(CXX "g++")
    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-march=pentium4 -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe -Wl,--no-seh -Wl,--large-address-aware")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "CLANGARM64")

    set(CONTITLE "MinGW Clang ARM64")
    set(CONICON "clangarm64.ico")

    set(CARCH "aarch64")
    set(CHOST "aarch64-w64-mingw32")

    set(MINGW_CHOST "aarch64-w64-mingw32")
    set(MINGW_PREFIX "/clangarm64")
    set(MINGW_PACKAGE_PREFIX "mingw-w64-clang-aarch64")
    set(MINGW_MOUNT_POINT "${Z_MSYS_ROOT_DIR}/${MINGW_PREFIX}")

    set(MSYSTEM_PREFIX "/clang64")
    set(MSYSTEM_CARCH "x86_64")
    set(MSYSTEM_CHOST "x86_64-w64-mingw32")

    set(REPO_DB_URL "${MIRROR_URL}/mingw/clangarm64/clangarm64.db")
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.clangarm64")
    set(REPO_PACKAGE_COMMON_PREFIX "mingw-w64-clang-aarch64-")

    # set(PATH "${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}")
    set(PKG_CONFIG_PATH "${MINGW_MOUNT_POINT}/lib/pkgconfig" "${MINGW_MOUNT_POINT}/share/pkgconfig")
    set(PKG_CONFIG_SYSTEM_INCLUDE_PATH "${MINGW_MOUNT_POINT}/include")
    set(PKG_CONFIG_SYSTEM_LIBRARY_PATH "${MINGW_MOUNT_POINT}/lib")
    set(ACLOCAL_PATH "${MINGW_MOUNT_POINT}/share/aclocal" "/usr/share/aclocal")
    set(MANPATH "${MINGW_MOUNT_POINT}/local/man" "${MINGW_MOUNT_POINT}/share/man" "${MANPATH}")
    set(INFOPATH "${MINGW_MOUNT_POINT}/local/info" "${MINGW_MOUNT_POINT}/share/info" "${INFOPATH}")
    set(DXSDK_DIR "${MINGW_MOUNT_POINT}/${MINGW_CHOST}")

    set(CC "clang")
    set(CXX "clang++")
    set(CPPFLAGS "-D__USE_MINGW_ANSI_STDIO=1")
    set(CFLAGS "-O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong")
    set(CXXFLAGS "-O2 -pipe")
    set(LDFLAGS "-pipe")

    # MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    # PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${MINGW_MOUNT_POINT}/var/packages-mingw64")
    set(SRCDEST "${MINGW_MOUNT_POINT}/var/sources")
    set(SRCPKGDEST "${MINGW_MOUNT_POINT}/var/srcpackages-mingw64")
    set(LOGDEST "${MINGW_MOUNT_POINT}/var/makepkglogs")

elseif (MSYSTEM STREQUAL "MSYS2")

    # Note that this currently *assumes* and only accounts for 'x86_64' msys installs...
    set(CONTITLE "MSYS2 MSYS")
    set(CONICON "msys2.ico")

    set(CARCH "x86_64") # Should probably either use 'uname -m' or host/target triplets
    set(CHOST "x86_64-pc-msys")

    #MINGW_CHOST="UNUSED"
    #MINGW_PREFIX="UNUSED"
    #MINGW_PACKAGE_PREFIX="UNUSED"

    set(MSYSTEM_PREFIX "/usr")
    set(MSYSTEM_CARCH "$(/usr/bin/uname -m)")
    set(MSYSTEM_CHOST "${MSYSTEM_CARCH}-pc-msys")

    set(REPO_DB_URL "${MIRROR_URL}/msys/x86_64/msys.db") # https://repo.msys2.org/msys/x86_64/msys.db
    set(REPO_MIRROR_LIST "${Z_MSYS_ROOT_DIR}/etc/pacman.d/mirrorlist.msys")
    set(REPO_PACKAGE_COMMON_PREFIX "")

    # set(PATH="${MSYS2_PATH}:/opt/bin${ORIGINAL_PATH:+:${ORIGINAL_PATH}}" # There are some cross-compiler dirs to add...
    set(PKG_CONFIG_PATH "${Z_MSYS_ROOT_DIR}/usr/lib/pkgconfig" "${Z_MSYS_ROOT_DIR}/usr/share/pkgconfig" "${Z_MSYS_ROOT_DIR}/lib/pkgconfig")

    #DXSDK_DIR="UNUSED"

    set(CC "gcc")
    set(CXX "g++")

    set(CPPFLAGS "")
    set(CFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    set(CXXFLAGS "-march=nocona -msahf -mtune=generic -O2 -pipe")
    set(LDFLAGS "-pipe")

    # MAN_DIRS=({{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info})
    # DOC_DIRS=({,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc})
    # PURGE_TARGETS=({,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod)

    set(PKGDEST "${Z_MSYS_ROOT_DIR}/usr/var/packages")
    set(SRCDEST "${Z_MSYS_ROOT_DIR}/usr/var/sources")
    set(SRCPKGDEST "${Z_MSYS_ROOT_DIR}/usr/var/srcpackages")
    set(LOGDEST "${Z_MSYS_ROOT_DIR}/usr/var/makepkglogs")

else()
    message(FATAL_ERROR "Unsupported MSYSTEM: ${MSYSTEM}")
    return()
endif()

set(CONFIG_SITE "/etc/config.site")

# set(SYSCONFDIR "${SYSCONFDIR:=/etc}")

# set(ORIGINAL_TMP "${ORIGINAL_TMP:-${TMP}}")
# set(ORIGINAL_TEMP "${ORIGINAL_TEMP:-${TEMP}}")
set(TMP "/tmp")
set(TEMP "/tmp")

# Source: ./etc/makepkg.conf
set(MAKEFLAGS "-j$(($(nproc)+1))")
set(DEBUG_CFLAGS "-ggdb -Og")
set(DEBUG_CXXFLAGS "-ggdb -Og")

set(BUILDENV !distcc color !ccache check !sign)
#DISTCC_HOSTS=""
#BUILDDIR=/tmp/makepkg

set(OPTIONS strip docs !libtool staticlibs emptydirs zipman purge !debug !lto)

set(INTEGRITY_CHECK sha256)

set(STRIP_BINARIES "--strip-all")
set(STRIP_SHARED "--strip-unneeded")
set(STRIP_STATIC "--strip-debug")

#PACKAGER="John Doe <john@doe.com>"
#GPGKEY=""

# Sources:
# ./etc/makepkg.conf
# ./etc/makepkg-mingw.conf

set(DLAGENTS
    "file::/usr/bin/curl -gqC - -o %o %u"
    "ftp::/usr/bin/curl -gqfC - --ftp-pasv --retry 3 --retry-delay 3 -o %o %u"
    "http::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
    "https::/usr/bin/curl -gqb \"\" -fLC - --retry 3 --retry-delay 3 -o %o %u"
    "rsync::/usr/bin/rsync --no-motd -z %u %o"
    "scp::/usr/bin/scp -C %u %o"
)
# Other common tools:
# /usr/bin/snarf
# /usr/bin/lftpget -c
# /usr/bin/wget

set(VCSCLIENTS
    bzr::bzr
    fossil::fossil
    git::git
    hg::mercurial
    svn::subversion
)

set(COMPRESSGZ "gzip -c -f -n")
set(COMPRESSBZ2 "bzip2 -c -f")
set(COMPRESSXZ "xz -c -z -T0 -")
set(COMPRESSZST "zstd -c -T0 --ultra -20 -")
set(COMPRESSLRZ "lrzip -q")
set(COMPRESSLZO "lzop -q")
set(COMPRESSZ "compress -c -f")
set(COMPRESSLZ4 "lz4 -q")
set(COMPRESSLZ "lzip -c -f")

set(PKGEXT ".pkg.tar.zst")
set(SRCEXT ".src.tar.zst")

set(PACMAN_AUTH "()")

# Suffix of the package archives, such as `-any.pkg.tar.zst`. Can be "-any${PKGEXT}" if used carefully.
# Can be a space-separated lists of such suffixes, those will be tried in the specified order when downloading packages.
# At some point pacman switched from `.tar.zst` to `.tar.xz`, but MSYS2 repos still have `.tar.xz` around for old packages, so we have to support both.
set(REPO_PACKAGE_ARCHIVE_SUFFIXES "-any.pkg.tar.zst" "-any.pkg.tar.xz")

# All these servers are registered with pacman under /etc/pacman.d/mirrorlist.*.
# The first URL in those lists is the primary mirror, all others will be used as
# a fallback. You can make another mirror the primary one by moving it to the top.

##-- Primary Server
set(PRIMARY_SERVERS)
list(APPEND PRIMARY_SERVERS "repo.msys2.org") # primary
list(APPEND PRIMARY_SERVERS "mirror.msys2.org") # geo redirection service for Tier 1 mirrors
set(PRIMARY_SERVERS "${PRIMARY_SERVERS}" CACHE STRING "" FORCE)

set(PRIMARY_SERVERS_HTTPS) # <HTTPS>
list(APPEND PRIMARY_SERVERS_HTTPS "https://repo.msys2.org/") # primary
list(APPEND PRIMARY_SERVERS_HTTPS "https://mirror.msys2.org/") # geo redirection service for Tier 1 mirrors
set(PRIMARY_SERVERS_HTTPS "${PRIMARY_SERVERS_HTTPS}" CACHE STRING "" FORCE)

set(PRIMARY_SERVERS_RSYNC) # <RSYNC>
list(APPEND PRIMARY_SERVERS_RSYNC "rsync://repo.msys2.org/builds/") # primary
set(PRIMARY_SERVERS_RSYNC "${PRIMARY_SERVERS_RSYNC}" CACHE STRING "" FORCE)


##-- Tier 1 mirrors
# Requirements: Reliable, 1GBit/s+ with enough free bandwidth, rsync server support (*), HTTPS support, synced at least once per day from the primary server.
# Map: https://mirror.msys2.org/?mirrorstats
set(MIRRORS_TIER_1) # <HTTPS|RSYNC>
list(APPEND MIRRORS_TIER_1 "mirror.umd.edu") # https://mirror.umd.edu/
list(APPEND MIRRORS_TIER_1 "ftp.acc.umu.se") # ftp-adm@acc.umu.se
list(APPEND MIRRORS_TIER_1 "ftp.nluug.nl") # ftp-admin@nluug.nl
list(APPEND MIRRORS_TIER_1 "ftp.osuosl.org") # hosting-request@osuosl.org
list(APPEND MIRRORS_TIER_1 "mirror.internet.asn.au") # peering@ix.asn.au
list(APPEND MIRRORS_TIER_1 "mirror.selfnet.de") # https://github.com/carrotIndustries
list(APPEND MIRRORS_TIER_1 "mirror.yandex.ru") # -
list(APPEND MIRRORS_TIER_1 "mirrors.dotsrc.org") # staff@dotsrc.org
list(APPEND MIRRORS_TIER_1 "mirrors.tuna.tsinghua.edu.cn") # -
list(APPEND MIRRORS_TIER_1 "mirrors.ustc.edu.cn") # lug@ustc.edu.cn
list(APPEND MIRRORS_TIER_1 "mirror.nju.edu.cn") # https://github.com/msys2/msys2.github.io/issues/155
list(APPEND MIRRORS_TIER_1 "mirrors.bfsu.edu.cn") # https://github.com/msys2/MSYS2-packages/issues/2775
list(APPEND MIRRORS_TIER_1 "repo.extreme-ix.org") # sysadmin@x3me.net
list(APPEND MIRRORS_TIER_1 "mirrors.hit.edu.cn") # https://github.com/msys2/msys2.github.io/issues/180
list(APPEND MIRRORS_TIER_1 "mirror.clarkson.edu") # https://github.com/msys2/msys2.github.io/issues/185
list(APPEND MIRRORS_TIER_1 "quantum-mirror.hu") # https://quantum-mirror.hu/web/contact_en.html
list(APPEND MIRRORS_TIER_1 "fastmirror.pp.ua") # https://fastmirror.pp.ua/
set(MIRRORS_TIER_1 "${MIRRORS_TIER_1}" CACHE STRING "Tier 1 mirrors <HTTPS|RSYNC>. Requirements: Reliable, 1GBit/s+ with enough free bandwidth, rsync server support (*), HTTPS support, synced at least once per day from the primary server. rsync is required by mirrorbits, which we use to auto-redirect users to a local mirror via mirror.msys2.org. Map: https://mirror.msys2.org/?mirrorstats" FORCE)

set(MIRRORS_TIER_1_HTTPS) # <HTTPS>
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.umd.edu/msys2/") # https://mirror.umd.edu/
list(APPEND MIRRORS_TIER_1_HTTPS "https://ftp.acc.umu.se/mirror/msys2.org/") # ftp-adm@acc.umu.se
list(APPEND MIRRORS_TIER_1_HTTPS "https://ftp.nluug.nl/pub/os/windows/msys2/builds/") # ftp-admin@nluug.nl
list(APPEND MIRRORS_TIER_1_HTTPS "https://ftp.osuosl.org/pub/msys2/") # hosting-request@osuosl.org
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.internet.asn.au/pub/msys2/") # peering@ix.asn.au
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.selfnet.de/msys2/") # https://github.com/carrotIndustries
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.yandex.ru/mirrors/msys2/") # -
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirrors.dotsrc.org/msys2/") # staff@dotsrc.org
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirrors.tuna.tsinghua.edu.cn/msys2/") # -
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirrors.ustc.edu.cn/msys2/") # lug@ustc.edu.cn
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.nju.edu.cn/msys2/") # https://github.com/msys2/msys2.github.io/issues/155
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirrors.bfsu.edu.cn/msys2/") # https://github.com/msys2/MSYS2-packages/issues/2775
list(APPEND MIRRORS_TIER_1_HTTPS "https://repo.extreme-ix.org/msys2/") # sysadmin@x3me.net
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirrors.hit.edu.cn/msys2/") # https://github.com/msys2/msys2.github.io/issues/180
list(APPEND MIRRORS_TIER_1_HTTPS "https://mirror.clarkson.edu/msys2/") # https://github.com/msys2/msys2.github.io/issues/185
list(APPEND MIRRORS_TIER_1_HTTPS "https://quantum-mirror.hu/mirrors/pub/msys2/") # https://quantum-mirror.hu/web/contact_en.html
list(APPEND MIRRORS_TIER_1_HTTPS "https://fastmirror.pp.ua/msys2/") # https://fastmirror.pp.ua/
set(MIRRORS_TIER_1_HTTPS "${MIRRORS_TIER_1_HTTPS}" CACHE STRING "Tier 1 servers <HTTPS>. Requirements: Reliable, 1GBit/s+ with enough free bandwidth, synced at least once per day from the primary server." FORCE)

set(MIRRORS_TIER_1_RSYNC) # <RSYNC>
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.umd.edu/msys2/") # https://mirror.umd.edu/
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://ftp.acc.umu.se/mirror/msys2.org/") # ftp-adm@acc.umu.se
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://ftp.nluug.nl/msys2/builds/") # ftp-admin@nluug.nl
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://rsync.osuosl.org/msys2/") # hosting-request@osuosl.org
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.internet.asn.au/msys2/") # peering@ix.asn.au
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.selfnet.de/msys2/") # https://github.com/carrotIndustries
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.yandex.ru/mirrors/msys2/") # -
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirrors.dotsrc.org/msys2/") # staff@dotsrc.org
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirrors.tuna.tsinghua.edu.cn/msys2/") # -
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://rsync.mirrors.ustc.edu.cn/repo/msys2/") # lug@ustc.edu.cn
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.nju.edu.cn/msys2/") # https://github.com/msys2/msys2.github.io/issues/155
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirrors.bfsu.edu.cn/msys2/") # https://github.com/msys2/MSYS2-packages/issues/2775
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://repo.extreme-ix.org/msys2/") # sysadmin@x3me.net
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirrors.hit.edu.cn/msys2/") # https://github.com/msys2/msys2.github.io/issues/180
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://mirror.clarkson.edu/msys2/") # https://github.com/msys2/msys2.github.io/issues/185
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://quantum-mirror.hu/msys2/") # https://quantum-mirror.hu/web/contact_en.html
list(APPEND MIRRORS_TIER_1_RSYNC "rsync://fastmirror.pp.ua/msys2/") # https://fastmirror.pp.ua/
set(MIRRORS_TIER_1_RSYNC "${MIRRORS_TIER_1_RSYNC}" CACHE STRING "Tier 1 servers <RSYNC>. Requirements: Reliable, 1GBit/s+ with enough free bandwidth, synced at least once per day from the primary server." FORCE)

##-- Tier 2 mirrors
# Requirements: Synced regularly.
set(MIRRORS_TIER_2) # <HTTPS>
list(APPEND MIRRORS_TIER_2 "ftp.cc.uoc.gr") # mirrors@cc.uoc.gr
list(APPEND MIRRORS_TIER_2 "mirrors.bit.edu.cn") # webmaster@bitnp.net
list(APPEND MIRRORS_TIER_2 "mirror.jmu.edu") # mirrormaster@jmu.edu
list(APPEND MIRRORS_TIER_2 "mirrors.piconets.webwerks.in") # mirrors@piconets.com
list(APPEND MIRRORS_TIER_2 "mirrors.sjtug.sjtu.edu.cn") # -
list(APPEND MIRRORS_TIER_2 "www2.futureware.at") # oe.nick@gmail.com
list(APPEND MIRRORS_TIER_2 "repo.casualgamer.ca") # -
list(APPEND MIRRORS_TIER_2 "mirrors.aliyun.com") # ali-yum@alibaba-inc.com
list(APPEND MIRRORS_TIER_2 "mirror.iscas.ac.cn") # -
list(APPEND MIRRORS_TIER_2 "mirrors.tencent.com") # petzhou@tencent.com
list(APPEND MIRRORS_TIER_2 "mirror.ufro.cl") # jonathan.gutierrez@ufrontera.cl
list(APPEND MIRRORS_TIER_2 "download.nus.edu.sg") # download@nus.edu.sg
set(MIRRORS_TIER_2 "${MIRRORS_TIER_2}" CACHE STRING "Tier 2 mirrors <HTTPS>. Requirements: Reliable, 1GBit/s+ with enough free bandwidth, rsync server support (*), HTTPS support, synced at least once per day from the primary server. rsync is required by mirrorbits, which we use to auto-redirect users to a local mirror via mirror.msys2.org. Map: https://mirror.msys2.org/?mirrorstats" FORCE)

set(MIRRORS_TIER_2_HTTPS) # <HTTPS>
list(APPEND MIRRORS_TIER_2_HTTPS "https://ftp.cc.uoc.gr/mirrors/msys2/") # # mirrors@cc.uoc.gr
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirrors.bit.edu.cn/msys2/") # webmaster@bitnp.net
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirror.jmu.edu/pub/msys2/") # mirrormaster@jmu.edu
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirrors.piconets.webwerks.in/msys2-mirror/") # mirrors@piconets.com
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirrors.sjtug.sjtu.edu.cn/msys2/") # -
list(APPEND MIRRORS_TIER_2_HTTPS "https://www2.futureware.at/~nickoe/msys2-mirror/") # oe.nick@gmail.com
list(APPEND MIRRORS_TIER_2_HTTPS "https://repo.casualgamer.ca/") # -
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirrors.aliyun.com/msys2/") # ali-yum@alibaba-inc.com
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirror.iscas.ac.cn/msys2/") # -
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirrors.tencent.com/msys2/") # petzhou@tencent.com
list(APPEND MIRRORS_TIER_2_HTTPS "https://mirror.ufro.cl/msys2/") # jonathan.gutierrez@ufrontera.cl
list(APPEND MIRRORS_TIER_2_HTTPS "https://download.nus.edu.sg/mirror/msys2/") # download@nus.edu.sg
set(MIRRORS_TIER_2_HTTPS "${MIRRORS_TIER_2_HTTPS}" CACHE STRING "Tier 2 mirrors <HTTPS>. Requirements: Reliable, 1GBit/s+ with enough free bandwidth, synced at least once per day from the primary server." FORCE)


##-- May or may not be worth grouping the mirrors into some sort of class-like routine?
# Could easily populate lists of mirrors with a function... But this suits C++ itself
# more easily than CMake!

# if(MIRROR_A)
#     set(MIRROR_A_TYPES      HTTP RSYNC)
#     set(MIRROR_A_LABEL      "mirror.umd.edu")
#     set(MIRROR_A_URL_HTTPS  "https://mirror.umd.edu/msys2/")
#     set(MIRROR_A_URL_RSYNC  "rsync://mirror.umd.edu/msys2/")
#     set(MIRROR_A_NOTES      "https://mirror.umd.edu/")
#     set(MIRROR_A_TIER       "1")
# endif()

# if(MIRROR_B)
#     set(MIRROR_B_TYPES      HTTP RSYNC)
#     set(MIRROR_B_LABEL      "mirror.umd.edu")
#     set(MIRROR_B_URL_HTTPS  "https://mirror.umd.edu/msys2/")
#     set(MIRROR_B_URL_RSYNC  "rsync://mirror.umd.edu/msys2/")
#     set(MIRROR_B_NOTES      "https://mirror.umd.edu/")
#     set(MIRROR_B_TIER       "1")
# endif()

#[===[.conf
###############################################################################
# PACMAN OPTIONS
###############################################################################
[options]
# The following paths are commented out with their default values listed.
# If you wish to use different paths, uncomment and update the paths.
#RootDir     = /
#DBPath      = /var/lib/pacman/
#CacheDir    = /var/cache/pacman/pkg/
#LogFile     = /var/log/pacman.log
#GPGDir      = /etc/pacman.d/gnupg/
HoldPkg     = pacman
#XferCommand = /usr/bin/curl -L -C - -f -o %o %u
#XferCommand = /usr/bin/wget --passive-ftp -c -O %o %u
#CleanMethod = KeepInstalled
Architecture = auto

# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
#IgnorePkg   =
#IgnoreGroup =

#NoUpgrade   =
#NoExtract   =

# Misc options
#UseSyslog
Color
#NoProgressBar
CheckSpace
#VerbosePkgLists
ParallelDownloads = 5

# By default, pacman accepts packages signed by keys that its local keyring
# trusts (see pacman-key and its man page), as well as unsigned packages.
#SigLevel = Never
SigLevel    = Required
LocalFileSigLevel = Optional
#RemoteFileSigLevel = Required

#
# REPOSITORIES
#   - can be defined here or included from another file
#   - pacman will search repositories in the order defined here
#   - local/custom mirrors can be added here or in separate files
#   - repositories listed first will take precedence when packages
#     have identical names, regardless of version number
#   - URLs will have $repo replaced by the name of the current repo
#   - URLs will have $arch replaced by the name of the architecture
#
# Repository entries are of the format:
#       [repo-name]
#       Server = ServerName
#       Include = IncludePath
#
# The header [repo-name] is crucial - it must be present and
# uncommented to enable the repo.
#

# The testing repositories are disabled by default. To enable, uncomment the
# repo name header and Include lines. You can add preferred servers immediately
# after the header, and they will be used before the default mirrors.

# Staging packages: enable at your own risk
# [staging]
# Server = https://repo.msys2.org/staging/
# SigLevel = Never

[clangarm64]
Include = /etc/pacman.d/mirrorlist.mingw

[mingw32]
Include = /etc/pacman.d/mirrorlist.mingw

[mingw64]
Include = /etc/pacman.d/mirrorlist.mingw

[ucrt64]
Include = /etc/pacman.d/mirrorlist.mingw

[clang32]
Include = /etc/pacman.d/mirrorlist.mingw

[clang64]
Include = /etc/pacman.d/mirrorlist.mingw

[msys]
Include = /etc/pacman.d/mirrorlist.msys

# An example of a custom package repository.  See the pacman manpage for
# tips on creating your own repositories.
#[custom]
#SigLevel = Optional TrustAll
#Server = file:///home/custompkgs
]===]#
