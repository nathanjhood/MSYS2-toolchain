message("Loading ${CMAKE_CURRENT_LIST_FILE}")

function(z_msys_configure_cmake_both_or_neither_set var1 var2)
    if(DEFINED "${var1}" AND NOT DEFINED "${var2}")
        message(FATAL_ERROR "If ${var1} is set, ${var2} must be set.")
    endif()
    if(NOT DEFINED "${var1}" AND DEFINED "${var2}")
        message(FATAL_ERROR "If ${var2} is set, ${var1} must be set.")
    endif()
endfunction()

function(z_msys_configure_cmake_build_cmakecache out_var whereat build_type)
    set(line "build ${whereat}/CMakeCache.txt: CreateProcess\n")
    string(APPEND line "  process = \"${CMAKE_COMMAND}\" -E chdir \"${whereat}\"")
    foreach(arg IN LISTS "${build_type}_command")
        string(APPEND line " \"${arg}\"")
    endforeach()
    set("${out_var}" "${${out_var}}${line}\n\n" PARENT_SCOPE)
endfunction()

function(z_msys_get_visual_studio_generator)
    cmake_parse_arguments(PARSE_ARGV 0 arg "" "OUT_GENERATOR;OUT_ARCH" "")

    if (NOT DEFINED arg_OUT_GENERATOR)
        message(FATAL_ERROR "OUT_GENERATOR must be defined.")
    endif()
    if(NOT DEFINED arg_OUT_ARCH)
        message(FATAL_ERROR "OUT_ARCH must be defined.")
    endif()
    if(DEFINED arg_UNPARSED_ARGUMENTS)
            message(FATAL_ERROR "${CMAKE_CURRENT_FUNCTION} was passed extra arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()

    if(DEFINED ENV{VisualStudioVersion})
        if("$ENV{VisualStudioVersion}" VERSION_LESS_EQUAL  "12.99" AND
           "$ENV{VisualStudioVersion}" VERSION_GREATER_EQUAL  "12.0" AND
           NOT "${MSYS_TARGET_ARCHITECTURE}" STREQUAL "arm64")
            set(generator "Visual Studio 12 2013")
        elseif("$ENV{VisualStudioVersion}" VERSION_LESS_EQUAL  "14.99" AND
               NOT "${MSYS_TARGET_ARCHITECTURE}" STREQUAL "arm64")
            set(generator "Visual Studio 14 2015")
        elseif("$ENV{VisualStudioVersion}" VERSION_LESS_EQUAL  "15.99")
            set(generator "Visual Studio 15 2017")
        elseif("$ENV{VisualStudioVersion}" VERSION_LESS_EQUAL  "16.99")
            set(generator "Visual Studio 16 2019")
        elseif("$ENV{VisualStudioVersion}" VERSION_LESS_EQUAL  "17.99")
            set(generator "Visual Studio 17 2022")
        endif()
    endif()

    if("${MSYS_TARGET_ARCHITECTURE}" STREQUAL "x86")
        set(generator_arch "Win32")
    elseif("${MSYS_TARGET_ARCHITECTURE}" STREQUAL "x64")
        set(generator_arch "x64")
    elseif("${MSYS_TARGET_ARCHITECTURE}" STREQUAL "arm")
        set(generator_arch "ARM")
    elseif("${MSYS_TARGET_ARCHITECTURE}" STREQUAL "arm64")
        set(generator_arch "ARM64")
    endif()
    set(${arg_OUT_GENERATOR} "${generator}" PARENT_SCOPE)
    set(${arg_OUT_ARCH} "${generator_arch}" PARENT_SCOPE)
endfunction()

function(z_msys_select_default_msys_chainload_toolchain)
    # Try avoiding adding more defaults here.
    # Set MSYS_CHAINLOAD_TOOLCHAIN_FILE explicitly in the triplet.
    if(DEFINED Z_MSYS_CHAINLOAD_TOOLCHAIN_FILE)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${Z_MSYS_CHAINLOAD_TOOLCHAIN_FILE}")
    elseif(MSYS_TARGET_IS_MINGW)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/mingw.cmake")
    elseif(MSYS_TARGET_IS_WINDOWS)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/windows.cmake")
    elseif(MSYS_TARGET_IS_LINUX)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/linux.cmake")
    elseif(MSYS_TARGET_IS_ANDROID)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/android.cmake")
    elseif(MSYS_TARGET_IS_OSX)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/osx.cmake")
    elseif(MSYS_TARGET_IS_IOS)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/ios.cmake")
    elseif(MSYS_TARGET_IS_FREEBSD)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/freebsd.cmake")
    elseif(MSYS_TARGET_IS_OPENBSD)
        set(MSYS_CHAINLOAD_TOOLCHAIN_FILE "${SCRIPTS}/toolchains/openbsd.cmake")
    endif()
    set(MSYS_CHAINLOAD_TOOLCHAIN_FILE ${MSYS_CHAINLOAD_TOOLCHAIN_FILE} PARENT_SCOPE)
endfunction()


function(msys_configure_cmake)
    cmake_parse_arguments(PARSE_ARGV 0 arg
        "PREFER_NINJA;DISABLE_PARALLEL_CONFIGURE;NO_CHARSET_FLAG;Z_GET_CMAKE_VARS_USAGE"
        "SOURCE_PATH;GENERATOR;LOGNAME"
        "OPTIONS;OPTIONS_DEBUG;OPTIONS_RELEASE;MAYBE_UNUSED_VARIABLES"
    )

    if(NOT arg_Z_GET_CMAKE_VARS_USAGE AND Z_MSYS_CMAKE_CONFIGURE_GUARD)
        message(FATAL_ERROR "The ${PORT} port already depends on vcpkg-cmake; using both vcpkg-cmake and vcpkg_configure_cmake in the same port is unsupported.")
    endif()

    if(DEFINED arg_UNPARSED_ARGUMENTS)
        message(WARNING "${CMAKE_CURRENT_FUNCTION} was passed extra arguments: ${arg_UNPARSED_ARGUMENTS}")
    endif()
    if(NOT DEFINED arg_SOURCE_PATH)
        message(FATAL_ERROR "SOURCE_PATH must be specified")
    endif()
    if(NOT DEFINED arg_LOGNAME)
        set(arg_LOGNAME "config-${TARGET_TRIPLET}")
    endif()

    msys_list(SET manually_specified_variables)

    if(arg_Z_GET_CMAKE_VARS_USAGE)
        set(configuring_message "Getting CMake variables for ${TARGET_TRIPLET}")
    else()
        set(configuring_message "Configuring ${TARGET_TRIPLET}")

        foreach(option IN LISTS arg_OPTIONS arg_OPTIONS_RELEASE arg_OPTIONS_DEBUG)
            if("${option}" MATCHES "^-D([^:=]*)[:=]")
                msys_list(APPEND manually_specified_variables "${CMAKE_MATCH_1}")
            endif()
        endforeach()
        msys_list(REMOVE_DUPLICATES manually_specified_variables)
        foreach(maybe_unused_var IN LISTS arg_MAYBE_UNUSED_VARIABLES)
            msys_list(REMOVE_ITEM manually_specified_variables "${maybe_unused_var}")
        endforeach()
        debug_message("manually specified variables: ${manually_specified_variables}")
    endif()

    set(ninja_can_be_used ON) # Ninja as generator
    set(ninja_host ON) # Ninja as parallel configurator

    if(NOT arg_PREFER_NINJA AND MSYS_TARGET_IS_WINDOWS AND NOT MSYS_TARGET_IS_MINGW)
        set(ninja_can_be_used OFF)
    endif()

    if(MSYS_HOST_IS_WINDOWS)
        if(DEFINED ENV{PROCESSOR_ARCHITEW6432})
            set(host_arch "$ENV{PROCESSOR_ARCHITEW6432}")
        else()
            set(host_arch "$ENV{PROCESSOR_ARCHITECTURE}")
        endif()

        if("${host_arch}" STREQUAL "x86")
            # Prebuilt ninja binaries are only provided for x64 hosts
            set(ninja_can_be_used OFF)
            set(ninja_host OFF)
        endif()
    endif()

    set(generator "Ninja") # the default generator is always ninja!
    set(generator_arch "")
    if(DEFINED arg_GENERATOR)
        set(generator "${arg_GENERATOR}")
    elseif(NOT ninja_can_be_used)
        set(generator "")
        z_msys_get_visual_studio_generator(OUT_GENERATOR generator OUT_ARCH generator_arch)
        if("${generator}" STREQUAL "" OR "${generator_arch}" STREQUAL "")
            message(FATAL_ERROR
                "Unable to determine appropriate generator for triplet ${TARGET_TRIPLET}:
    ENV{VisualStudioVersion} : $ENV{VisualStudioVersion}
    platform toolset: ${MSYS_PLATFORM_TOOLSET}
    architecture    : ${MSYS_TARGET_ARCHITECTURE}")
        endif()
        if(DEFINED MSYS_PLATFORM_TOOLSET)
            msys_list(APPEND arg_OPTIONS "-T${MSYS_PLATFORM_TOOLSET}")
        endif()
    endif()

    # If we use Ninja, make sure it's on PATH
    if("${generator}" STREQUAL "Ninja" AND NOT DEFINED ENV{MSYS_FORCE_SYSTEM_BINARIES})
        msys_find_acquire_program(NINJA)
        get_filename_component(ninja_path "${NINJA}" DIRECTORY)
        msys_add_to_path("${ninja_path}")
        msys_list(APPEND arg_OPTIONS "-DCMAKE_MAKE_PROGRAM=${NINJA}")
    endif()

    file(REMOVE_RECURSE
        "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
        "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")

    if(DEFINED MSYS_CMAKE_SYSTEM_NAME)
        msys_list(APPEND arg_OPTIONS "-DCMAKE_SYSTEM_NAME=${MSYS_CMAKE_SYSTEM_NAME}")
        if(MSYS_TARGET_IS_UWP AND NOT DEFINED MSYS_CMAKE_SYSTEM_VERSION)
            set(MSYS_CMAKE_SYSTEM_VERSION 10.0)
        elseif(MSYS_TARGET_IS_ANDROID AND NOT DEFINED MSYS_CMAKE_SYSTEM_VERSION)
            set(MSYS_CMAKE_SYSTEM_VERSION 21)
        endif()
    endif()

    if(DEFINED MSYS_XBOX_CONSOLE_TARGET)
        msys_list(APPEND arg_OPTIONS "-DXBOX_CONSOLE_TARGET=${MSYS_XBOX_CONSOLE_TARGET}")
    endif()

    if(DEFINED MSYS_CMAKE_SYSTEM_VERSION)
        msys_list(APPEND arg_OPTIONS "-DCMAKE_SYSTEM_VERSION=${MSYS_CMAKE_SYSTEM_VERSION}")
    endif()

    if("${CRT_LINKAGE}" STREQUAL "dynamic")
        msys_list(APPEND arg_OPTIONS -DBUILD_SHARED_LIBS=ON)
    elseif("${CRT_LINKAGE}" STREQUAL "static")
        msys_list(APPEND arg_OPTIONS -DBUILD_SHARED_LIBS=OFF)
    else()
        message(FATAL_ERROR
            "Invalid setting for CRT_LINKAGE: \"${CRT_LINKAGE}\".
    It must be \"static\" or \"dynamic\"")
    endif()

    z_msys_configure_cmake_both_or_neither_set(MSYS_CXX_FLAGS_DEBUG MSYS_C_FLAGS_DEBUG)
    z_msys_configure_cmake_both_or_neither_set(MSYS_CXX_FLAGS_RELEASE MSYS_C_FLAGS_RELEASE)
    z_msys_configure_cmake_both_or_neither_set(MSYS_CXX_FLAGS MSYS_C_FLAGS)

    set(msys_set_charset_flag ON)
    if(arg_NO_CHARSET_FLAG)
        set(msys_set_charset_flag OFF)
    endif()

    if(NOT MSYS_CHAINLOAD_TOOLCHAIN_FILE)
        z_msys_select_default_msys_chainload_toolchain()
    endif()

    msys_list(APPEND arg_OPTIONS
        "-DMSYS_CHAINLOAD_TOOLCHAIN_FILE=${MSYS_CHAINLOAD_TOOLCHAIN_FILE}"
        "-DMSYS_TARGET_TRIPLET=${TARGET_TRIPLET}"
        "-DMSYS_SET_CHARSET_FLAG=${msys_set_charset_flag}"
        "-DMSYS_PLATFORM_TOOLSET=${MSYS_PLATFORM_TOOLSET}"
        "-DCMAKE_EXPORT_NO_PACKAGE_REGISTRY=ON"
        "-DCMAKE_FIND_PACKAGE_NO_PACKAGE_REGISTRY=ON"
        "-DCMAKE_FIND_PACKAGE_NO_SYSTEM_PACKAGE_REGISTRY=ON"
        "-DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=TRUE"
        "-DCMAKE_VERBOSE_MAKEFILE=ON"
        "-DMSYS_APPLOCAL_DEPS=OFF"
        "-DCMAKE_TOOLCHAIN_FILE=${SCRIPTS}/buildsystems/MSYS2.cmake"
        "-DCMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION=ON"
        "-DMSYS_CXX_FLAGS=${MSYS_CXX_FLAGS}"
        "-DMSYS_CXX_FLAGS_RELEASE=${MSYS_CXX_FLAGS_RELEASE}"
        "-DMSYS_CXX_FLAGS_DEBUG=${MSYS_CXX_FLAGS_DEBUG}"
        "-DMSYS_C_FLAGS=${MSYS_C_FLAGS}"
        "-DMSYS_C_FLAGS_RELEASE=${MSYS_C_FLAGS_RELEASE}"
        "-DMSYS_C_FLAGS_DEBUG=${MSYS_C_FLAGS_DEBUG}"
        "-DMSYS_CRT_LINKAGE=${MSYS_CRT_LINKAGE}"
        "-DMSYS_LINKER_FLAGS=${MSYS_LINKER_FLAGS}"
        "-DMSYS_LINKER_FLAGS_RELEASE=${MSYS_LINKER_FLAGS_RELEASE}"
        "-DMSYS_LINKER_FLAGS_DEBUG=${MSYS_LINKER_FLAGS_DEBUG}"
        "-DMSYS_TARGET_ARCHITECTURE=${MSYS_TARGET_ARCHITECTURE}"
        "-DCMAKE_INSTALL_LIBDIR:STRING=lib"
        "-DCMAKE_INSTALL_BINDIR:STRING=bin"
        "-D_MSYS_ROOT_DIR=${MSYS_ROOT_DIR}"
        "-DZ_MSYS_ROOT_DIR=${MSYS_ROOT_DIR}"
        "-D_MSYS_INSTALLED_DIR=${_MSYS_INSTALLED_DIR}"
        "-DMSYS_MANIFEST_INSTALL=OFF"
    )

    if(NOT "${generator_arch}" STREQUAL "")
        msys_list(APPEND arg_OPTIONS "-A${generator_arch}")
    endif()

    # Sets configuration variables for macOS builds
    foreach(config_var IN ITEMS INSTALL_NAME_DIR OSX_DEPLOYMENT_TARGET OSX_SYSROOT OSX_ARCHITECTURES)
        if(DEFINED "MSYS_${config_var}")
            msys_list(APPEND arg_OPTIONS "-DCMAKE_${config_var}=${MSYS_${config_var}}")
        endif()
    endforeach()

    # Allow overrides / additional configuration variables from triplets
    if(DEFINED MSYS_CMAKE_CONFIGURE_OPTIONS)
        msys_list(APPEND arg_OPTIONS ${MSYS_CMAKE_CONFIGURE_OPTIONS})
    endif()
    if(DEFINED MSYS_CMAKE_CONFIGURE_OPTIONS_RELEASE)
        msys_list(APPEND arg_OPTIONS_RELEASE ${MSYS_CMAKE_CONFIGURE_OPTIONS_RELEASE})
    endif()
    if(DEFINED MSYS_CMAKE_CONFIGURE_OPTIONS_DEBUG)
        msys_list(APPEND arg_OPTIONS_DEBUG ${MSYS_CMAKE_CONFIGURE_OPTIONS_DEBUG})
    endif()

    msys_list(SET rel_command
        "${CMAKE_COMMAND}" "${arg_SOURCE_PATH}"
        -G "${generator}"
        "-DCMAKE_BUILD_TYPE=Release"
        "-DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}"
        ${arg_OPTIONS} ${arg_OPTIONS_RELEASE})
    msys_list(SET dbg_command
        "${CMAKE_COMMAND}" "${arg_SOURCE_PATH}"
        -G "${generator}"
        "-DCMAKE_BUILD_TYPE=Debug"
        "-DCMAKE_INSTALL_PREFIX=${CURRENT_PACKAGES_DIR}/debug"
        ${arg_OPTIONS} ${arg_OPTIONS_DEBUG})

    if(ninja_host AND CMAKE_HOST_WIN32 AND NOT arg_DISABLE_PARALLEL_CONFIGURE)
        msys_list(APPEND arg_OPTIONS "-DCMAKE_DISABLE_SOURCE_CHANGES=ON")

        msys_find_acquire_program(NINJA)
        if(NOT DEFINED ninja_path)
            # if ninja_path was defined above, we've already done this
            get_filename_component(ninja_path "${NINJA}" DIRECTORY)
            msys_add_to_path("${ninja_path}")
        endif()

        #parallelize the configure step
        set(ninja_configure_contents
            "rule CreateProcess\n  command = \$process\n\n"
        )

        if(NOT DEFINED MSYS_BUILD_TYPE OR "${MSYS_BUILD_TYPE}" STREQUAL "release")
            z_msys_configure_cmake_build_cmakecache(ninja_configure_contents ".." "rel")
        endif()
        if(NOT DEFINED MSYS_BUILD_TYPE OR "${MSYS_BUILD_TYPE}" STREQUAL "debug")
            z_msys_configure_cmake_build_cmakecache(ninja_configure_contents "../../${TARGET_TRIPLET}-dbg" "dbg")
        endif()

        file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msys-parallel-configure")
        file(WRITE
            "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msys-parallel-configure/build.ninja"
            "${ninja_configure_contents}")

        message(STATUS "${configuring_message}")
        msys_execute_required_process(
            COMMAND "${NINJA}" -v
            WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel/msys-parallel-configure"
            LOGNAME "${arg_LOGNAME}"
            SAVE_LOG_FILES
                "../../${TARGET_TRIPLET}-dbg/CMakeCache.txt" ALIAS "dbg-CMakeCache.txt.log"
                "../CMakeCache.txt" ALIAS "rel-CMakeCache.txt.log"
        )

        msys_list(APPEND config_logs
            "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-out.log"
            "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-err.log")
    else()
        if(NOT DEFINED MSYS_BUILD_TYPE OR "${MSYS_BUILD_TYPE}" STREQUAL "debug")
            message(STATUS "${configuring_message}-dbg")
            file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg")
            msys_execute_required_process(
                COMMAND ${dbg_command}
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg"
                LOGNAME "${arg_LOGNAME}-dbg"
                SAVE_LOG_FILES CMakeCache.txt
            )
            msys_list(APPEND config_logs
                "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-dbg-out.log"
                "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-dbg-err.log")
        endif()

        if(NOT DEFINED MSYS_BUILD_TYPE OR "${MSYS_BUILD_TYPE}" STREQUAL "release")
            message(STATUS "${configuring_message}-rel")
            file(MAKE_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel")
            msys_execute_required_process(
                COMMAND ${rel_command}
                WORKING_DIRECTORY "${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel"
                LOGNAME "${arg_LOGNAME}-rel"
                SAVE_LOG_FILES CMakeCache.txt
            )
            msys_list(APPEND config_logs
                "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-rel-out.log"
                "${CURRENT_BUILDTREES_DIR}/${arg_LOGNAME}-rel-err.log")
        endif()
    endif()

    # Check unused variables
    msys_list(SET all_unused_variables)
    foreach(config_log IN LISTS config_logs)
        if(NOT EXISTS "${config_log}")
            continue()
        endif()
        file(READ "${config_log}" log_contents)
        debug_message("Reading configure log ${config_log}...")
        if(NOT "${log_contents}" MATCHES "Manually-specified variables were not used by the project:\n\n((    [^\n]*\n)*)")
            continue()
        endif()
        string(STRIP "${CMAKE_MATCH_1}" unused_variables) # remove leading `    ` and trailing `\n`
        string(REPLACE "\n    " ";" unused_variables "${unused_variables}")
        debug_message("unused variables: ${unused_variables}")

        foreach(unused_variable IN LISTS unused_variables)
            if("${unused_variable}" IN_LIST manually_specified_variables)
                debug_message("manually specified unused variable: ${unused_variable}")
                msys_list(APPEND all_unused_variables "${unused_variable}")
            else()
                debug_message("unused variable (not manually specified): ${unused_variable}")
            endif()
        endforeach()
    endforeach()

    if(NOT "${all_unused_variables}" STREQUAL "")
        msys_list(REMOVE_DUPLICATES all_unused_variables)
        msys_list(JOIN all_unused_variables "\n    " all_unused_variables)
        message(WARNING "The following variables are not used in CMakeLists.txt:
    ${all_unused_variables}
Please recheck them and remove the unnecessary options from the `msys_configure_cmake` call.
If these options should still be passed for whatever reason, please use the `MAYBE_UNUSED_VARIABLES` argument.")
    endif()

    if(NOT arg_Z_GET_CMAKE_VARS_USAGE)
        set(Z_MSYS_CMAKE_GENERATOR "${generator}" PARENT_SCOPE)
    endif()
endfunction()
