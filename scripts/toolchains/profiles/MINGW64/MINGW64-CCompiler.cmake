if(NOT _MINGW64_C_COMPILER_ID_RUN)
set(_MINGW64_C_COMPILER_ID_RUN 1)

set(MINGW64_C_COMPILER_ENV_VAR "CC")
set(MINGW64_C_COMPILER_ID_RUN 1)
set(MINGW64_COMPILER_IS_GNUCC 1)

mark_as_advanced(MINGW64_C_COMPILER_ENV_VAR)
mark_as_advanced(MINGW64_C_COMPILER_ID_RUN)
mark_as_advanced(MINGW64_COMPILER_IS_GNUCC)

find_program(MINGW64_C_COMPILER              "${Z_MINGW64_ROOT_DIR}/bin/x86_64-w64-mingw32-gcc.exe")
find_program(MINGW64_C_COMPILER_AR           "${Z_MINGW64_ROOT_DIR}/bin/gcc-ar.exe")
find_program(MINGW64_C_COMPILER_RANLIB       "${Z_MINGW64_ROOT_DIR}/bin/gcc-ranlib.exe")

set(MINGW64_C_COMPILER              "${MINGW64_C_COMPILER}")
set(MINGW64_C_COMPILER_AR           "${MINGW64_C_COMPILER_AR}")
set(MINGW64_C_COMPILER_RANLIB       "${MINGW64_C_COMPILER_RANLIB}")

mark_as_advanced(MINGW64_C_COMPILER)
mark_as_advanced(MINGW64_C_COMPILER_AR)
mark_as_advanced(MINGW64_C_COMPILER_RANLIB)

set(MINGW64_C_PLATFORM_ID                   "MinGW")
set(MINGW64_C_COMPILER_ID                   "GNU")
set(MINGW64_C_COMPILER_VERSION              "13.1.0")
set(MINGW64_C_COMPILER_VERSION_INTERNAL     "")
set(MINGW64_C_COMPILER_FRONTEND_VARIANT     "GNU")
set(MINGW64_C_SIMULATE_ID                   "")
set(MINGW64_C_SIMULATE_VERSION              "")
set(MINGW64_C_STANDARD_COMPUTED_DEFAULT     "17")
set(MINGW64_C_EXTENSIONS_COMPUTED_DEFAULT   "ON")

mark_as_advanced(MINGW64_C_PLATFORM_ID)
mark_as_advanced(MINGW64_C_COMPILER_ID)
mark_as_advanced(MINGW64_C_COMPILER_VERSION)
mark_as_advanced(MINGW64_C_COMPILER_VERSION_INTERNAL)
mark_as_advanced(MINGW64_C_COMPILER_FRONTEND_VARIANT)
mark_as_advanced(MINGW64_C_SIMULATE_ID)
mark_as_advanced(MINGW64_C_SIMULATE_VERSION)
mark_as_advanced(MINGW64_C_STANDARD_COMPUTED_DEFAULT)
mark_as_advanced(MINGW64_C_EXTENSIONS_COMPUTED_DEFAULT)

set(MINGW64_C90_COMPILE_FEATURES)
list(APPEND MINGW64_C90_COMPILE_FEATURES c_std_90)
list(APPEND MINGW64_C90_COMPILE_FEATURES c_function_prototypes)
set(MINGW64_C90_COMPILE_FEATURES "${MINGW64_C90_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C90_COMPILE_FEATURES)

set(MINGW64_C99_COMPILE_FEATURES)
list(APPEND MINGW64_C90_COMPILE_FEATURES c_std_99)
list(APPEND MINGW64_C90_COMPILE_FEATURES c_restrict)
list(APPEND MINGW64_C90_COMPILE_FEATURES c_variadic_macros)
set(MINGW64_C99_COMPILE_FEATURES "${MINGW64_C99_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C99_COMPILE_FEATURES)

set(MINGW64_C11_COMPILE_FEATURES)
list(APPEND MINGW64_C11_COMPILE_FEATURES c_std_11)
list(APPEND MINGW64_C11_COMPILE_FEATURES c_static_assert)
set(MINGW64_C11_COMPILE_FEATURES "${MINGW64_C11_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C11_COMPILE_FEATURES)

set(MINGW64_C17_COMPILE_FEATURES)
list(APPEND MINGW64_C17_COMPILE_FEATURES c_std_17)
set(MINGW64_C17_COMPILE_FEATURES "${MINGW64_C17_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C17_COMPILE_FEATURES)

set(MINGW64_C23_COMPILE_FEATURES)
list(APPEND MINGW64_C23_COMPILE_FEATURES c_std_23)
set(MINGW64_C23_COMPILE_FEATURES "${MINGW64_C23_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C23_COMPILE_FEATURES)

set(MINGW64_C_COMPILE_FEATURES)
list(APPEND MINGW64_C_COMPILE_FEATURES "${MINGW64_C90_COMPILE_FEATURES}")
list(APPEND MINGW64_C_COMPILE_FEATURES "${MINGW64_C99_COMPILE_FEATURES}")
list(APPEND MINGW64_C_COMPILE_FEATURES "${MINGW64_C11_COMPILE_FEATURES}")
list(APPEND MINGW64_C_COMPILE_FEATURES "${MINGW64_C17_COMPILE_FEATURES}")
list(APPEND MINGW64_C_COMPILE_FEATURES "${MINGW64_C23_COMPILE_FEATURES}")
set(MINGW64_C_COMPILE_FEATURES "${MINGW64_C_COMPILE_FEATURES}")
mark_as_advanced(MINGW64_C_COMPILE_FEATURES)

set(MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES)
list(APPEND MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${MINGW64_C_COMPILER_VERSION}/include-fixed")
list(APPEND MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${MINGW64_C_COMPILER_VERSION}/include")
list(APPEND MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/include")
set(MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES "${MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES}")
mark_as_advanced(MINGW64_C_IMPLICIT_INCLUDE_DIRECTORIES)

set(MINGW64_C_IMPLICIT_LINK_DIRECTORIES)
list(APPEND MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/lib/gcc/x86_64-w64-mingw32/${MINGW64_C_COMPILER_VERSION}")
list(APPEND MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/lib/gcc")
list(APPEND MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/x86_64-w64-mingw32/lib")
list(APPEND MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${Z_MINGW64_ROOT_DIR}/lib")
set(MINGW64_C_IMPLICIT_LINK_DIRECTORIES "${MINGW64_C_IMPLICIT_LINK_DIRECTORIES}")
mark_as_advanced(MINGW64_C_IMPLICIT_LINK_DIRECTORIES)

set(MINGW64_C_IMPLICIT_LINK_LIBRARIES)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES mingw32)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES gcc)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES moldname)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES mingwex)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES pthread)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES advapi32)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES shell32)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES user32)
list(APPEND MINGW64_C_IMPLICIT_LINK_LIBRARIES kernel32)
set(MINGW64_C_IMPLICIT_LINK_LIBRARIES "${MINGW64_C_IMPLICIT_LINK_LIBRARIES}")
mark_as_advanced(MINGW64_C_IMPLICIT_LINK_LIBRARIES)

set(MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")
mark_as_advanced(MINGW64_C_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES)

set(MINGW64_C_SOURCE_FILE_EXTENSIONS)
list(APPEND MINGW64_C_SOURCE_FILE_EXTENSIONS c)
list(APPEND MINGW64_C_SOURCE_FILE_EXTENSIONS m)
set(MINGW64_C_SOURCE_FILE_EXTENSIONS "${MINGW64_C_SOURCE_FILE_EXTENSIONS}")
mark_as_advanced(MINGW64_C_SOURCE_FILE_EXTENSIONS)

set(MINGW64_C_IGNORE_EXTENSIONS)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS h)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS H)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS o)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS O)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS obj)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS OBJ)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS def)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS DEF)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS rc)
list(APPEND MINGW64_C_IGNORE_EXTENSIONS RC)
set(MINGW64_C_IGNORE_EXTENSIONS "${MINGW64_C_IGNORE_EXTENSIONS}")
mark_as_advanced(MINGW64_C_IGNORE_EXTENSIONS)

set(MINGW64_C_CL_SHOWINCLUDES_PREFIX "")
mark_as_advanced(MINGW64_C_CL_SHOWINCLUDES_PREFIX)

set(MINGW64_C_FLAGS)
string(APPEND MINGW64_C_FLAGS " -march=nocona ")
string(APPEND MINGW64_C_FLAGS " -msahf ")
string(APPEND MINGW64_C_FLAGS " -mtune=generic ")
string(APPEND MINGW64_C_FLAGS " -pipe ")
string(APPEND MINGW64_C_FLAGS " -Wp,-D_FORTIFY_SOURCE=2 ")
string(APPEND MINGW64_C_FLAGS " -fstack-protector-strong ")
set(MINGW64_C_FLAGS "${MINGW64_C_FLAGS}")
mark_as_advanced(MINGW64_C_FLAGS)

set(MINGW64_C_FLAGS_DEBUG)
string(APPEND MINGW64_C_FLAGS_DEBUG " -ggdb ")
string(APPEND MINGW64_C_FLAGS_DEBUG " -Og ")
set(MINGW64_C_FLAGS_DEBUG "${MINGW64_C_FLAGS_DEBUG}")
mark_as_advanced(MINGW64_C_FLAGS_DEBUG)

set(MINGW64_C_FLAGS_RELEASE)
string(APPEND MINGW64_C_FLAGS_RELEASE " -O2 ")
string(APPEND MINGW64_C_FLAGS_RELEASE " -DNDEBUG ")
set(MINGW64_C_FLAGS_RELEASE "${MINGW64_C_FLAGS_RELEASE}")
mark_as_advanced(MINGW64_C_FLAGS_RELEASE)

set(MINGW64_C_FLAGS_MINSIZEREL)
string(APPEND MINGW64_C_FLAGS_MINSIZEREL " -Os ")
string(APPEND MINGW64_C_FLAGS_MINSIZEREL " -DNDEBUG ")
set(MINGW64_C_FLAGS_MINSIZEREL "${MINGW64_C_FLAGS_MINSIZEREL}")
mark_as_advanced(MINGW64_C_FLAGS_MINSIZEREL)

set(MINGW64_C_FLAGS_RELWITHDEBINFO)
string(APPEND MINGW64_C_FLAGS_RELWITHDEBINFO " -ggdb ")
string(APPEND MINGW64_C_FLAGS_RELWITHDEBINFO " -O2 ")
set(MINGW64_C_FLAGS_RELWITHDEBINFO "${MINGW64_C_FLAGS_RELWITHDEBINFO}")
mark_as_advanced(MINGW64_C_FLAGS_RELWITHDEBINFO)

endif() # if(NOT _MINGW64_CXX_COMPILER_ID_RUN)

# # Save compiler ABI information.
# set(MINGW64_C_SIZEOF_DATA_PTR "8")
# set(MINGW64_C_COMPILER_ABI "")
# set(MINGW64_C_BYTE_ORDER "LITTLE_ENDIAN")
# set(MINGW64_C_LIBRARY_ARCHITECTURE "")

# set(MINGW64_C_COMPILER_ARG1 "")
# set(MINGW64_C_COMPILER_WRAPPER "")
# set(MINGW64_C_COMPILER_LOADED 1)
# set(MINGW64_C_COMPILER_WORKS TRUE)
# set(MINGW64_C_ABI_COMPILED TRUE)
# set(MINGW64_C_LINKER_PREFERENCE 10)

# if(MINGW64_C_SIZEOF_DATA_PTR)
#     set(MINGW64_SIZEOF_VOID_P "${MINGW64_C_SIZEOF_DATA_PTR}")
# endif()
# if(MINGW64_C_COMPILER_ABI)
#     set(MINGW64_INTERNAL_PLATFORM_ABI "${MINGW64_C_COMPILER_ABI}")
# endif()
# if(MINGW64_C_LIBRARY_ARCHITECTURE)
#     set(MINGW64_LIBRARY_ARCHITECTURE "")
# endif()
# if(MINGW64_C_CL_SHOWINCLUDES_PREFIX)
#     set(MINGW64_CL_SHOWINCLUDES_PREFIX "${MINGW64_C_CL_SHOWINCLUDES_PREFIX}")
# endif()