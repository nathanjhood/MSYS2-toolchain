# MSYS2 toolchain

Full CMake build support for all <a href="msys2.org">Msys64</a> sub-systems, with optonal <a href="">vcpkg</a> integration.

Currently being developed in tandem with my specialized fork of <a href="https://github.com/StoneyDSP/msys2-pacman.git">MSYS2-Pacman</a>, with the aim of bringing the building of package binaries from hosted source repositories to msys2 environments for Windows.

As a means of thoroughly testing the toolchains, I have simultaneously developed several small projects that require a more extensive usage of the libraries and headers available in each subsystem; A <a href="https://github.com/StoneyDSP/CMakeProject1.git">simple CMake application</a> suitable for templating new projects, a specialized fork of <a href="https://github.com/StoneyDSP/msys2-pacman.git">MSYS2-Pacman</a> for package management, and a <a href="https://github.com/StoneyDSP/CxxWin.git">native windowed application using the Win32 API and Direct2D graphics</a>.

# <b>Usage</b>

Simply pass the <a href="">scripts/buildsystems/MSYS2.cmake</a> file as your "<b>CMAKE_TOOLCHAIN_FILE</b>", along with a desired "<b>MSYSTEM</b>".

```
$ cmake -S "<path/to/project>" -B "<path/to/project>/build" "-DMSYSTEM=MINGW64" "-DCMAKE_TOOLCHAIN_FILE=<path/to/this/repo>/scripts/buildsystems/MSYS2.cmake" "-DCMAKE_MODULE_PATH=<path/to/this/repo>/scripts/cmake/Modules" -G "Ninja Multi-Config"
```

Choose an "<b>MSYSTEM</b>" from one of the following  options:

* UCRT64
* MINGW64
* MINGW32
* CLANG64
* CLANG32
* CLANGARM64
* MSYS2

<u><i>IMPORTANT</i></u> - Make sure you include this part of the above command, to enable the '<b>MSYSTEM</b>' platform for CMake:

-D<b>CMAKE_MODULE_PATH</b>=<i>\<path/to/this/repo\></i>/scripts/cmake/Modules"

# <b>Requirements</b>

* Windows Host machine
* MSYS2 installation (please try to use the default install location)
* CMake

Note that will need to have run the standard init commands for Msys development;

```pacman -Syuu```

```pacman -S --needed base-devel```

```pacman -S cmake```

```pacman -S autotools```

```pacman -S ming-w64-{msystem}-{arch}-toolchain```

```pacman -S ming-w64-{msystem}-{arch}-cmake```

```pacman -S ming-w64-{msystem}-{arch}-toolchain```

```pacman -S ming-w64-{msystem}-{arch}-autotools```

Corresponding to the chosen MSYSTEM in order to have the toolchain installed and available to for use by this project. See the MSYS2 (and Packages page) docs for more.


# <b>Description</b>

This independent project is an ongoing investigation into the potential of cross-pollinating <a href="">MSYS2</a>'s multi-verse of build envinronments and toolchains, with the source code package registry access and management of <a href="">Microsoft's vcpkg</a>, thanks to the power and flexibility of <a href="">CMake</a>.

Fortunately, for this project to achieve it's targets, much of the required configurations are already available within a standard CMake, Msys64, and optionally vcpkg, installation; we have simply defined an additional set of standard processes for directing the flow of file-hopping that CMake does under the hood when configuring/building/etc to pick up combinations of native CMake files that otherwise wouldn't be specified together, using the provided configs alone.

Doing this involves porting the contents of several configuration as found in Windows MSYS2 installations:

* <a href="">etc/makepkg.conf</a>*
* <a href="">etc/makepkg_mingw.conf</a>**

(*for "<b>MSYS2</b>")

(**for "<b>MINGW32</b>/<b>64</b>", "<b>CLANG32</b>/<b>64</b>/<b>ARM64</b>", and "<b>URCRT64</b>")

These files are typically used to drive configurations for "<b>PKGBUILD</b>", which is the integrated package-building/bundling mechanism used by '<b>pacman</b>' in typical development scenarios when using MSYS2.

This project aims to port as much of the above as possible to a natively-CMake-driven process, including the integration of a port Microsoft's 'vcpkg' package manager and its' useful "triplet/toolchain/buildsystem" paradigm:

* Known configuration of system to build software on, i.e., the '<b>host</b>'<b>*</b>.
* Desired configuration of system to run software on, i.e., the '<b>target</b>'<b>*</b>.
* Chain of tools to build with, i.e., a '<b>toolchain</b>'.
* A building process invoking all of the above, i.e., a '<b>build system</b>'.

<i><b>*</b>each of these configurations are referred to as '<b>triplets</b>'</i>

In a CMake-driven build environment, these settings can all be pre-defined with configuration scripts ('<b>toolchain files</b>') which configure CMake with a full set of environment variables, binary/library paths, and compiler flags for each of the available invoking MSYS sub-systems (often known as "MSYSTEM"'s), appropriately setting each of the underlying build tool behaviours for each sub-system, enabling CMake to correctly find and use them.

This project does precisely the above with as minimal user requirements as possible. With the desired toolchain(s) on your pacman-driven Msys installation in place, it should be as simple as passing the 'MSYS2.cmake' buildsystem file (as the CMake toolchain) and an 'MSYSTEM' to your CMake invocation, making the entire sub-system readily available to your CMake/Msys64 projects.

Here's what building with each of the sub-systems offers, as per the <a href="">MSYS2 documentation</a>:

## MINGW64

* MinGW-based x64-bit environment
* GNU compilers and binary utlilities
* 'MSVCRT' C Standard Library
* 'libstdc++' C++ Standard Library

## MINGW32

* MinGW-based x32-bit environment
* GNU compilers and binary utlilities
* 'MSVCRT' C Standard Library
* 'libstdc++' C++ Standard Library

## CLANG64

* MinGW-based x64-bit environment
* Clang compilers and LLVM binary utlilities
* 'UCRT' C Standard Library
* 'libc++' C++ Standard Library

## CLANG32

* MinGW-based x32-bit environment
* Clang compilers and LLVM binary utlilities
* 'UCRT' C Standard Library
* 'libc++' C++ Standard Library

## UCRT64

* MinGW-based x64-bit environment
* Support for both GNU *and* Clang compiler toolchains
* 'UCRT' C Standard Library
* 'libstdc++' C++ Standard Library

## MSYS2

* Cygwin-based native environment
* Support for both GNU *and* Clang compiler toolchains
* 'Cygwin' C Standard Library with 'MSYS2' Runtimes
* 'libstdc++' C++ Standard Library

</br>
<i><b>*</b> Microsoft Visual C++ Runtime (<b>MSVCRT</b>)</i>

<i><b>**</b> Universal C Runtime (<b>UCRT</b>)</i>

</br>
</br>
To use the toolchain and buildsystem, first install your MSYSTEM toolchain using pacman as usual, then pass these vars to your CMake invocation when building;

* "-D<b>CMAKE_TOOLCHAIN_FILE</b>=<i>\<path/to/this/repo\></i>/scripts/buildsystem/MSYS2.cmake"

* "-D<b>MSYSTEM</b>=<b>MINGW64</b>"

* "-D<b>CMAKE_MODULE_PATH</b>=<i>\<path/to/this/repo\></i>/scripts/cmake/Modules"

or, to use a sub-system without the encasing buildsystem, just pass it in as the toolchain file directly (this omits usage as a package manager, but still provides a full configured toolchain and utilities);

* -D<b>CMAKE_TOOLCHAIN_FILE</b>=<i>"\<path/to/this/repo\></i>/scripts/toolchains/MINGW64.cmake"

<i>* you may of course swap 'MINGW64' for any of the other available MSYSTEM's - just don't forget to include files indicated in the module path as above. <b><u>CMake will fail without this</b>!</u></i>

The 'chainload' toolchain files ('scripts/toolchains') are named identically to the chosen "<b>MSYSTEM</b>" and *may* provide more thorough default behaviours for invoked "<b>MSYSTEM</b>" settings. Use in tandem for best results. However, there is *some* experimental support for passing just the 'buildsystem' file without any '\<MSYSTEM\>':

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

"<b>CMAKE_TOOLCHAIN_FILE</b>" and "<b>MSYSTEM</b>" can often also be set in your IDE's CMake integration extension's settings, and/or a <i>'CMakePresets.json'</i> in the project root folder.

For best results, it is recommended to use either '<b>Ninja</b>' or '<b>Ninja Multi-Config</b>' as a generator, with the 'preferred' generator set to one of the Makefile generators - '<b>Unix</b>/<b>MinGW</b>/<b>MSYS Makefiles</b>' etc.

# <b>Options</b>

## "<b>MSYS2_PATH_TYPE</b>"

We have a working implementation of Msys64's 'path type' switching option under the custom CMake variable "<b>MSYS2_PATH_TYPE</b>", as follows:

* "-D<b>MSYS2_PATH_TYPE</b>=<b>inherit</b>"

Inherit the Windows environment's "PATH" variable. Note that this will make all of the Windows path available in current shell, with possible interference in project builds.

* "-D<b>MSYS2_PATH_TYPE</b>=<b>minimal</b>"

Provides a minimal set of paths from the Windows environment's system folder; notably, this *excludes* all of your Windows 'Program Files' directories.

* "-D<b>MSYS2_PATH_TYPE</b>=<b>strict</b>"

Do not inherit any paths from the Windows environment, and allow for full customization of external paths. This is supposed to be used in special cases such as debugging without need to change this file, but not daily usage.

## <b>OPTION_MSYS_PREFER_MSYSTEM_PATHS</b>

If set to 'ON', the paths under the current 'MSYSTEM' directory will be scanned before the '\<msysRoot\>/usr' directory during CMake's file/program/lib lookup routines.

Accepts a Boolean value. Defaults to "<b>ON</b>".

## <b>OPTION_MSYS_PREFER_WIN32_PATHS</b>

If set to 'ON', the paths under the calling environment's 'PATH' variable will be scanned before any other paths, during CMake's file/program/lib lookup routines.

Accepts a Boolean value. Defaults to "<b>OFF</b>".

## <b>OPTION_ENABLE_X11</b>

Adds '\<msystemRoot\>/include/X11' to 'CMAKE_SYSTEM_INCLUDE_PATH', and '\<msystemRoot\>/lib/X11' 'to CMAKE_SYSTEM_LIBRARY_PATH' for lookup.

Accepts a Boolean value. Defaults to "<b>OFF</b>".

## <b>OPTION_USE_DSX_BINUTILS</b> (coming soon!)

Also very much worth noting is that several sub-systems offer "DSX-compatibility" GNU Bin Utils, located various differently-named directories here and there. It seems at least a fun idea to leverage a ```cmake_option(OPTION_USE_DSX_BINUTILS)``` or similar, which likewise would favour these directories during file lookups for the tools in question. Again, this is actually all *pretty much* made possible, in fact quite easy, in CMake's design. Currently there are so very many features, permutations, varieties across the entire project that this concept hasn't yet been explored further, but stay tuned.

# Stay tuned for further development!

# Thanks for reading!

# Legal

This Git repo, named "MSYS2-toolchain", is an independant project, created and maintained by <a href="https://github.com/StoneyDSP">StoneyDSP</a> as a project of interest. By "independant", the author specifies that they have no relation to any of the parties further outlined below in this section of the page.

## MSYS2

<i>The below is quoted from <a href="https://www.msys2.org/license/">https://www.msys2.org/license/</a></i>

"MSYS2 is a software distribution consisting of several independent parts, each with their own licenses, comparable to a Linux distribution.

The installer, for example, is based on the qt-installer-framework and pre-packs the direct and indirect dependencies of the base meta package. Each package has its own licenses.

The "pacman" package manager in MSYS2 allows users to install other packages available in our repository, each with their own licenses.

The license information for each package as visible on <a href="https://www.msys2.org/license/">https://packages.msys2.org</a> is maintained on a best effort basis and "we" (quote) make no guarantee that it is accurate or complete."

## vcpkg

vcpkg - C++ Library Manager for Windows, Linux, and MacOS

Copyright (c) Microsoft Corporation

vcpkg is distributed under the MIT License

All rights reserved.

## CMake

CMake - Cross Platform Makefile Generator

Copyright 2000-2023 Kitware, Inc. and Contributors

CMake is distributed under the OSI-approved BSD 3-clause License

All rights reserved.
