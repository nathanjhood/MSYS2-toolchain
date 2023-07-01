
find_program(MINGW64_MAKE       "${MINGW64_BINDIR}/mingw32-make.exe")

find_program(MINGW64_AR         "${MINGW64_BINDIR}/ar.exe")
find_program(MINGW64_AS         "${MINGW64_BINDIR}/as.exe")
find_program(MINGW64_LD         "${MINGW64_BINDIR}/ld.exe")
find_program(MINGW64_MT         "${MINGW64_BINDIR}/mt.exe")
find_program(MINGW64_NM         "${MINGW64_BINDIR}/nm.exe")

find_program(MINGW64_ADDR2LINE  "${MINGW64_BINDIR}/addr2line.exe")
find_program(MINGW64_DLLTOOL    "${MINGW64_BINDIR}/dlltool.exe")
find_program(MINGW64_LINKER     "${MINGW64_BINDIR}/ld.exe")
find_program(MINGW64_OBJCOPY    "${MINGW64_BINDIR}/objcopy.exe")
find_program(MINGW64_OBJDUMP    "${MINGW64_BINDIR}/objdump.exe")
find_program(MINGW64_RANLIB     "${MINGW64_BINDIR}/ranlib.exe")
find_program(MINGW64_READELF    "${MINGW64_BINDIR}/readelf.exe")
find_program(MINGW64_STRIP      "${MINGW64_BINDIR}/strip.exe")

set(MINGW64_MAKE       "${MINGW64_AR}" CACHE FILEPATH "<MINGW64>: The full path to the <MAKE> utility." FORCE)

set(MINGW64_AR         "${MINGW64_AR}" CACHE FILEPATH "<MINGW64>: The full path to the <AR> utility." FORCE)
set(MINGW64_AS         "${MINGW64_AS}" CACHE FILEPATH "<MINGW64>: The full path to the <AS> utility." FORCE)
set(MINGW64_LD         "${MINGW64_LD}" CACHE FILEPATH "<MINGW64>: The full path to the <LD> utility." FORCE)
set(MINGW64_MT         "${MINGW64_MT}" CACHE FILEPATH "<MINGW64>: The full path to the <MT> utility." FORCE)
set(MINGW64_NM         "${MINGW64_NM}" CACHE FILEPATH "<MINGW64>: The full path to the <NM> utility." FORCE)

set(MINGW64_ADDR2LINE  "${MINGW64_ADDR2LINE}" CACHE FILEPATH "<MINGW64>: The full path to the 'addr2line' utility." FORCE)
set(MINGW64_DLLTOOL    "${MINGW64_DLLTOOL}" CACHE FILEPATH "<MINGW64>: The full path to the 'dlltool' utility." FORCE)
set(MINGW64_LINKER     "${MINGW64_LINKER}" CACHE FILEPATH "<MINGW64>: The full path to the linker utility." FORCE)
set(MINGW64_OBJCOPY    "${MINGW64_OBJCOPY}" CACHE FILEPATH "<MINGW64>: The full path to the 'objcopy' utility." FORCE)
set(MINGW64_OBJDUMP    "${MINGW64_BINDIR}" CACHE FILEPATH "<MINGW64>: The full path to the 'objdump' utility." FORCE)
set(MINGW64_RANLIB     "${MINGW64_BINDIR}" CACHE FILEPATH "<MINGW64>: The full path to the 'ranlib' utility." FORCE)
set(MINGW64_READELF    "${MINGW64_BINDIR}" CACHE FILEPATH "<MINGW64>: The full path to the 'readelf' utility." FORCE)
set(MINGW64_STRIP      "${MINGW64_BINDIR}" CACHE FILEPATH "<MINGW64>: The full path to the 'strip' utility." FORCE)

mark_as_advanced(MINGW64_MAKE)

mark_as_advanced(MINGW64_AR)
mark_as_advanced(MINGW64_AS)
mark_as_advanced(MINGW64_LD)
mark_as_advanced(MINGW64_MT)
mark_as_advanced(MINGW64_NM)

mark_as_advanced(MINGW64_ADDR2LINE)
mark_as_advanced(MINGW64_DLLTOOL)
mark_as_advanced(MINGW64_LINKER)
mark_as_advanced(MINGW64_OBJCOPY)
mark_as_advanced(MINGW64_OBJDUMP)
mark_as_advanced(MINGW64_RANLIB)
mark_as_advanced(MINGW64_READELF)
mark_as_advanced(MINGW64_STRIP)


# # <AR>
# find_program(AR "ar" NO_CACHE) # DOC "The full path to the archiving utility.")
# mark_as_advanced(AR)
# if(NOT DEFINED AR_FLAGS)
#     set(AR_FLAGS "-rv")
# endif() # (NOT DEFINED AR_FLAGS)
# set(AR_FLAGS "${AR_FLAGS}") # CACHE STRING "Flags for the archiving utility." FORCE)
# set(AR_COMMAND "${AR} ${AR_FLAGS}")

# find_program(CMAKE_AR   "${Z_MINGW64_ROOT_DIR}/bin/${CMAKE_SYSTEM_PROCESSOR}-w64-mingw32-gcc-ar")
# if(NOT CMAKE_AR)
#     find_program(CMAKE_AR "${Z_MINGW64_ROOT_DIR}/bin/ar")
#     if(NOT CMAKE_AR)
#         find_program(CMAKE_AR "ar")
#     endif() # (NOT CMAKE_AR)
# endif() # (NOT CMAKE_AR)
