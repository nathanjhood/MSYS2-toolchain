

msys_configure_cmake(
    SOURCE_PATH "${SOURCE_PATH}"
    OPTIONS
        -DMSYSTEM=MINGW64
    GENERATOR "Unix Makefiles"
    DISABLE_PARALLEL_CONFIGURE
)
