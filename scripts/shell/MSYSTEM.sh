#!/usr/bin/env sh

if [[ "$MSYSTEM" == "MINGW32" ]]; then

    CONTITLE="MinGW x32"
    CONICON="mingw32.ico"

    CARCH="i686"
    CHOST="i686-w64-mingw32"

    MINGW_CHOST="i686-w64-mingw32"
    MINGW_PREFIX="/mingw32"
    MINGW_PACKAGE_PREFIX="mingw-w64-i686"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/mingw32"
    MSYSTEM_CARCH="i686"
    MSYSTEM_CHOST="i686-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="gcc"
    CXX="g++"

    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-march=pentium4 -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe -Wl,--no-seh -Wl,--large-address-aware"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)

    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "MINGW64" ]]; then

    CONTITLE="MinGW x64"
    CONICON="mingw64.ico"

    CARCH="x86_64"
    CHOST="x86_64-w64-mingw32"

    MINGW_CHOST="x86_64-w64-mingw32"
    MINGW_PREFIX="/mingw64"
    MINGW_PACKAGE_PREFIX="mingw-w64-x86_64"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/mingw64"
    MSYSTEM_CARCH="x86_64"
    MSYSTEM_CHOST="x86_64-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="gcc"
    CXX="g++"
    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)
    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "UCRT64" ]]; then

    CONTITLE="MinGW UCRT x64"
    CONICON="ucrt64.ico"

    CARCH="x86_64"
    CHOST="x86_64-w64-mingw32"

    MINGW_CHOST="x86_64-w64-mingw32"
    MINGW_PREFIX="/ucrt64"
    MINGW_PACKAGE_PREFIX="mingw-w64-ucrt-x86_64"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/ucrt64"
    MSYSTEM_CARCH="x86_64"
    MSYSTEM_CHOST="x86_64-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="gcc"
    CXX="g++"
    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)
    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "CLANG64" ]]; then

    CONTITLE="MinGW Clang x64"
    CONICON="clang64.ico"

    CARCH="x86_64"
    CHOST="x86_64-w64-mingw32"

    MINGW_CHOST="x86_64-w64-mingw32"
    MINGW_PREFIX="/clang64"
    MINGW_PACKAGE_PREFIX="mingw-w64-clang-x86_64"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/clang64"
    MSYSTEM_CARCH="x86_64"
    MSYSTEM_CHOST="x86_64-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="clang"
    CXX="clang++"
    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)
    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "CLANG32" ]]; then

    CONTITLE="MinGW Clang x32"
    CONICON="clang32.ico"

    CARCH="i686"
    CHOST="i686-w64-mingw32"

    MINGW_CHOST="i686-w64-mingw32"
    MINGW_PREFIX="/mingw32"
    MINGW_PACKAGE_PREFIX="mingw-w64-i686"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/clang32"
    MSYSTEM_CARCH="i686"
    MSYSTEM_CHOST="i686-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="gcc"
    CXX="g++"
    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-march=pentium4 -mtune=generic -O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-march=pentium4 -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe -Wl,--no-seh -Wl,--large-address-aware"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)
    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "CLANGARM64" ]]; then

    CONTITLE="MinGW Clang ARM64"
    CONICON="clangarm64.ico"

    CARCH="aarch64"
    CHOST="aarch64-w64-mingw32"

    MINGW_CHOST="aarch64-w64-mingw32"
    MINGW_PREFIX="/clangarm64"
    MINGW_PACKAGE_PREFIX="mingw-w64-clang-aarch64"
    MINGW_MOUNT_POINT="${MINGW_PREFIX}"

    MSYSTEM_PREFIX="/clang64"
    MSYSTEM_CARCH="x86_64"
    MSYSTEM_CHOST="x86_64-w64-mingw32"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MINGW_MOUNT_POINT}/bin:${MSYS2_PATH}${ORIGINAL_PATH:+:${ORIGINAL_PATH}}"
    PKG_CONFIG_PATH="${MINGW_MOUNT_POINT}/lib/pkgconfig:${MINGW_MOUNT_POINT}/share/pkgconfig"
    PKG_CONFIG_SYSTEM_INCLUDE_PATH="${MINGW_MOUNT_POINT}/include"
    PKG_CONFIG_SYSTEM_LIBRARY_PATH="${MINGW_MOUNT_POINT}/lib"
    ACLOCAL_PATH="${MINGW_MOUNT_POINT}/share/aclocal:/usr/share/aclocal"
    MANPATH="${MINGW_MOUNT_POINT}/local/man:${MINGW_MOUNT_POINT}/share/man:${MANPATH}"
    INFOPATH="${MINGW_MOUNT_POINT}/local/info:${MINGW_MOUNT_POINT}/share/info:${INFOPATH}"
    DXSDK_DIR="${MINGW_PREFIX}/${MINGW_CHOST}"

    CC="clang"
    CXX="clang++"
    CPPFLAGS="-D__USE_MINGW_ANSI_STDIO=1"
    CFLAGS="-O2 -pipe -Wp,-D_FORTIFY_SOURCE=2 -fstack-protector-strong"
    CXXFLAGS="-O2 -pipe"
    LDFLAGS="-pipe"

    MAN_DIRS=("${MINGW_PREFIX#/}"{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=("${MINGW_PREFIX#/}"/{,local/}{,share/}{doc,gtk-doc})
    PURGE_TARGETS=("${MINGW_PREFIX#/}"/{,share}/info/dir .packlist *.pod)
    PKGDEST="/var/packages-mingw64"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages-mingw64"
    LOGDEST="/var/makepkglogs"

elif [[ "$MSYSTEM" == "MSYS2" ]]; then

    CONTITLE="MSYS2 MSYS"
    CONICON="msys2.ico"

    CARCH="x86_64"
    CHOST="x86_64-pc-msys"

    #MINGW_CHOST="UNUSED"
    #MINGW_PREFIX="UNUSED"
    #MINGW_PACKAGE_PREFIX="UNUSED"

    MSYSTEM_PREFIX="/usr"
    MSYSTEM_CARCH="$(/usr/bin/uname -m)"
    MSYSTEM_CHOST="${MSYSTEM_CARCH}-pc-msys"

    MSYS2_PATH="/usr/local/bin:/usr/bin:/bin"
    MANPATH="/usr/local/man:/usr/share/man:/usr/man:/share/man"
    INFOPATH="/usr/local/info:/usr/share/info:/usr/info:/share/info"

    PATH="${MSYS2_PATH}:/opt/bin${ORIGINAL_PATH:+:${ORIGINAL_PATH}}" # There are some cross-compiler dirs to add...
    PKG_CONFIG_PATH="/usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig"

    #DXSDK_DIR="UNUSED"

    CC="gcc"
    CXX="g++"
    CPPFLAGS=""
    CFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    CXXFLAGS="-march=nocona -msahf -mtune=generic -O2 -pipe"
    LDFLAGS="-pipe"

    MAN_DIRS=({{,usr/}{,local/}{,share/},opt/*/}{man,info} mingw{32,64}{{,/local}{,/share},/opt/*}/{man,info})
    DOC_DIRS=({,usr/}{,local/}{,share/}{doc,gtk-doc} mingw{32,64}/{,local/}{,share/}{doc,gtk-doc} opt/*/{doc,gtk-doc})
    PURGE_TARGETS=({,usr/}{,share}/info/dir mingw{32,64}/{,share}/info/dir .packlist *.pod)

    PKGDEST="/var/packages"
    SRCDEST="/var/sources"
    SRCPKGDEST="/var/srcpackages"
    LOGDEST="/var/makepkglogs"

else
    echo "Unsupported MSYSTEM: $MSYSTEM"
    exit 1
fi
