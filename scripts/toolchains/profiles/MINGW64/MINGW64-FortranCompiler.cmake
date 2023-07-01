set(MINGW64_Fortran_COMPILER "C:/msys64/mingw64/bin/gfortran.exe")
set(MINGW64_Fortran_COMPILER_ID "GNU")
set(MINGW64_Fortran_COMPILER_VERSION "13.1.0")
# set(MINGW64_Fortran_COMPILER_WRAPPER "")
set(MINGW64_Fortran_PLATFORM_ID "MinGW")
set(MINGW64_Fortran_COMPILER_FRONTEND_VARIANT "GNU")
# set(MINGW64_Fortran_SIMULATE_ID "")
# set(MINGW64_Fortran_SIMULATE_VERSION "")

set(MINGW64_Fortran_IMPLICIT_INCLUDE_DIRECTORIES "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include;C:/msys64/mingw64/include;C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0/include-fixed")
set(MINGW64_Fortran_IMPLICIT_LINK_LIBRARIES "gfortran;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;quadmath;m;mingw32;gcc_s;gcc;moldname;mingwex;kernel32;pthread;advapi32;shell32;user32;kernel32;mingw32;gcc_s;gcc;moldname;mingwex;kernel32")
set(MINGW64_Fortran_IMPLICIT_LINK_DIRECTORIES "C:/msys64/mingw64/lib/gcc/x86_64-w64-mingw32/13.1.0;C:/msys64/mingw64/lib/gcc;C:/msys64/mingw64/x86_64-w64-mingw32/lib;C:/msys64/mingw64/lib")
set(MINGW64_Fortran_IMPLICIT_LINK_FRAMEWORK_DIRECTORIES "")

set(MINGW64_Fortran_COMPILER_AR "C:/msys64/mingw64/bin/gcc-ar.exe")
set(MINGW64_Fortran_COMPILER_RANLIB "C:/msys64/mingw64/bin/gcc-ranlib.exe")
set(MINGW64_COMPILER_IS_GNUG77 1)


set(MINGW64_Fortran_COMPILER_ENV_VAR "FC")

set(MINGW64_Fortran_COMPILER_SUPPORTS_F90 1)


set(MINGW64_Fortran_SOURCE_FILE_EXTENSIONS f;F;fpp;FPP;f77;F77;f90;F90;for;For;FOR;f95;F95)
set(MINGW64_Fortran_IGNORE_EXTENSIONS h;H;o;O;obj;OBJ;def;DEF;rc;RC)

if(UNIX)
    set(MINGW64_Fortran_OUTPUT_EXTENSION .o)
else()
    set(MINGW64_Fortran_OUTPUT_EXTENSION .obj)
endif()

# Save compiler ABI information.
set(MINGW64_Fortran_SIZEOF_DATA_PTR "8")
set(MINGW64_Fortran_COMPILER_ABI "")
set(MINGW64_Fortran_LIBRARY_ARCHITECTURE "")

if(MINGW64_Fortran_SIZEOF_DATA_PTR AND NOT MINGW64_SIZEOF_VOID_P)
    set(MINGW64_SIZEOF_VOID_P "${MINGW64_Fortran_SIZEOF_DATA_PTR}")
endif()

if(MINGW64_Fortran_COMPILER_ABI)
    set(MINGW64_INTERNAL_PLATFORM_ABI "${MINGW64_Fortran_COMPILER_ABI}")
endif()

if(MINGW64_Fortran_LIBRARY_ARCHITECTURE)
    set(MINGW64_LIBRARY_ARCHITECTURE "")
endif()
