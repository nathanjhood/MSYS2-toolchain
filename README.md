# MSYS2 toolchain

For CMake integration and vcpkg support.

Full build support for all Msys64 sub-systems!

# <b>Usage</b>

Simply pass the <a href="">scripts/buildsystems/MSYS2.cmake</a> file as your "<b>CMAKE_TOOLCHAIN_FILE</b>", along with a desired "<b>MSYSTEM</b>".

```
$ cmake -S "<path/to/project>" -B "<path/to/project>/build" -DCMAKE_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/buildsystems/MSYS2.cmake -DMSYSTEM:STRING=MINGW64 -G "Ninja Multi-Config"
```

Choose an "<b>MSYSTEM</b>" from one of the following  options:

* UCRT64
* MINGW64
* MINGW32
* CLANG64
* CLANG32
* CLANGARM64
* MSYS2

# <b>Requirements</b>

* Windows Host machine
* MSYS2 installation (please try to use the default install location)
* CMake

Note that will need to have run the standard ```pacman -Syuu``` init command, *and* ```pacman -S ming-w64-{arch}-{vendor}-toolchain``` corresponding to each MSYSTEM in order to have the toolchain installed and available to for use by this project. See the MSYS2 (and Packages page) docs for more.

# <b>Description</b>

This independent project is an ongoing investigation into the potential of cross-pollinating <a href="">MSYS2</a>'s multi-verse of build envinronments and toolchains, with the source code package registry access and management of <a href="">Microsoft's vcpkg</a>, thanks to the power and flexibility of <a href="">CMake</a>.

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

<br>
<i><b>*</b> Microsoft Visual C++ Runtime (<b>MSVCRT</b>)</i>

<i><b>**</b> Universal C Runtime (<b>UCRT</b>)</i>

We don't want build-system configs to be baked into our project source code (because they contain variables relevant only to the machine used to build with), so one common working method is to specify a '<b>toolchain file</b>' that configures the end-user/developer's build system appropriately, based on what is available on their specific build system, come build time. A well-designed implementation is a balance of machine-based file lookup and user-specification, coupled with very thoughtful design patterns for fall-through cases, where something important might not have been (possible to have been) specified at a certain point in the build process. Since each MSYS2 sub-system has it's own compiler toolchain, runtime libraries, and architecture, there are many environmental variants among each sub-system that require critical attention in order to be correctly utilized in custom builds and projects.

Fortunately, for this project to achieve it's targets, much of the required configurations are already available within a standard CMake (and optionally vcpkg) installation, and we have simply a process of directing the flow of file-hopping that CMake does under the hood when configuring/building/etc to pick up combinations of native CMake files that otherwise wouldn't be specified together, using the provided configs alone.

(to better understand this last paragraph, please see the files under your CMake installation directory; 'share/cmake/Modules/Platform/', 'share/cmake/Modules/Compiler/', 'share/cmake/Modules/CMakeCLanguageInformation.cmake', and 'share/cmake/Modules/CMakeSystemSpecificInformation.cmake' ...)

To use the toolchain and buildsystem, pass these vars to your CMake invocation;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

* <b>-DMSYSTEM</b>:STRING=<i>"\<MINGW64\>"</i>

or, to use a sub-system without the encasing buildsystem, just pass it in as the toolchain file directly (this omits usage as a package manager, but still provides a full configured toolchain and utilities);

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/toolchains/MINGW64.cmake"</i>


The 'chainload' toolchain files ('scripts/toolchains') are named identically to the chosen "<b>MSYSTEM</b>" and *may* provide more thorough default behaviours for invoked "<b>MSYSTEM</b>" settings. Use in tandem for best results. However, there is *some* experimental support for passing just the 'buildsystem' file without any '\<MSYSTEM\>':

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

"<b>CMAKE_TOOLCHAIN_FILE</b>" and "<b>MSYSTEM</b>" can often also be set in your IDE's CMake integration extension's settings, and/or a <i>'CMakePresets.json'</i> in the project root folder.

For best results, it is recommended to use either '<b>Ninja</b>' or '<b>Ninja Multi-Config</b>' as a generator, with the 'preferred' generator set to one of the Makefile generators - '<b>Unix</b>/<b>MinGW</b>/<b>MSYS Makefiles</b>' etc.

Some useful settings are provided in <i>'.vscode/settings.json'</i>.

# <b>Options</b>

## "<b>MSYS2_PATH_TYPE</b>"

We have a working implementation of Msys64's 'path type' switching option under the custom CMake variable "<b>MSYS2_PATH_TYPE</b>", as follows:

* "-D<b>MSYS2_PATH_TYPE</b>=<b>inherit</b>"

Inherit the Windows environment's "PATH" variable. Note that this will make all of the Windows path available in current shell, with possible interference in project builds.

* "-D<b>MSYS2_PATH_TYPE</b>=<b>minimal</b>"

Provides a minimal set of paths from the Windows environment's system folder; notably, this *excludes* all of your Windows 'Program Files' directories.

* "-D<b>MSYS2_PATH_TYPE</b>=<b>strict</b>"

Do not inherit any paths from the Windows environment, and allow for full customization of external paths. This is supposed to be used in special cases such as debugging without need to change this file, but not daily usage.

<br>
Note that in all cases above, the paths in question are *appended* to the list of paths for the selected MSYSTEM. There exists some experimental behaviour for *prepending* any inherited Windows paths, which means that they would be scanned first when CMake is searching for tools during its' run (in cases where the tool(s) in question haven't (yet) been specified in the current process).

<br>
Also very much worth noting is that several sub-systems offer "DSX-compatibility" GNU Bin Utils, located various differently-named directories here and there. It seems at least a fun idea to leverage a ```cmake_option(USE_DSX_COMPATIBLE_BINUTILS)``` or similar, which likewise would favour these directories during file lookups for the tools in question. Again, this is actually all *pretty much* made possible, in fact quite easy, in CMake's design. Currently there are so very many features, permutations, varieties across the entire project that this concept hasn't yet been explored further, but stay tuned.

## <b>OPTION_STRIP_BINARIES</b>

Appends '<b>--strip-all</b>' to "<b>CMAKE_EXE_LINKER_FLAGS</b>".

Defaults to "<b>ON</b>".

## <b>OPTION_STRIP_SHARED</b>

Appends '<b>--strip-unneeded</b>' to "<b>CMAKE_SHARED_LINKER_FLAGS</b>"

Defaults to "<b>ON</b>".

## OPTION_STRIP_STATIC

Appends '<b>--strip-debug</b>' to "<b>CMAKE_STATIC_LINKER_FLAGS</b>"

defaults to "<b>ON</b>".


</br>
</br>

# <b>Development</b>

</br>

The main files at the core of the project are:

</br>

* 'scripts/buildsystems/MSYS2.cmake'

* 'scripts/toolchains/\<MSYSTEM\>.cmake'

* 'scripts/cmake/Modules/Platform/MSYSTEM.cmake'

* 'scripts/cmake/Modules/Platform/MSYSTEM-\<COMPILER_ID\>.cmake'

</br>

It should be noted that the first file, the 'buildsystem' file, actually contains and 'include()' directive for the second file - the 'toolchain' file, where the sub-system's toolchain is specified. This inclusion happens as a result of comparing the '\<MSYSTEM\>' variable against their usual shell names.

It is well worth noting that both files are pretty much direct clones of corresponding files found in <a href="https://github.com/microsoft/vcpkg.git">microsoft's excellent vcpkg package manager</a>.

Please be aware that a prefix of just "MSYS_" is referring to vars coming from the 'buildsystem' file, if loaded. The vars with prefix of "MSYS<u>2</u>_" refer to what you would usually get from Msys64 if entering the "MSYS2" subsystem. It's a close call, but I think it's ok!?

</br>
</br>

## Todo

Lots of paths to fix, test, etc. Lots of cleanup. Potentially a re-write in store to compile more variable strings from other variable strings (<b><i>'\<MINGW_PACKAGE_PREFIX\>-\<TOOLCHAIN_TO_USE\>'</i></b>, etc...), however I don't personally prefer this approach because it requires a CMake run in order to fetch these compiled variables, compared to just having them defined at-a-glance in the toolchain file, and tells us (less than) nothing about the variables that we *haven't* selected for that run. Preferring verbosity during dev/debug, meanwhile.

Consider adding in some of the switching logic from the excellent 'fougas.msys2' VSCode extension.

Considering extending the available <b>'\<MSYSTEM>\'</b> list by adding the following:

* <b>\<CLANGCL64\></b>
* <b>\<CLANGCL32\></b>

The idea would be to call the MSVC-style 'cl' compiler frontend executables (<i>'clang-cl.exe'</i>) for Clang toolchains, to ease interoperability with MSBuild-style compile flags and command lines.

Everything besides the C/C++ compiler paths would be as per their non-CL counterparts.

Note that there is actually a git <i>'.patch'</i> file for MSYS that ships with vcpkg, which attempts to add <i>'clang-cl.exe'</i> to the compiler search path for the 'autotools-1-16' package.

To do this manually instead, using any editor, go to <b><i>'<MSYS_ROOT>/usr/share/automake-1.16/compile'</i></b> line number 256, where you should see this:

```
    cl | *[/\\]cl | cl.exe | *[/\\]cl.exe | \
    icl | *[/\\]icl | icl.exe | *[/\\]icl.exe )
        func_cl_wrapper "$@"      # Doesn't return...
```

Add in the new line below (the one with 'clang-cl' in it);

```
    cl | *[/\\]cl | cl.exe | *[/\\]cl.exe | \
    clang-cl | *[/\\]clang-cl | clang-cl.exe | *[/\\]clang-cl.exe | \
    icl | *[/\\]icl | icl.exe | *[/\\]icl.exe )
        func_cl_wrapper "$@"      # Doesn't return...
```

And save the file. Done.

## Package management

Eventual intended usage would be to supercede Msys's native Arch-Linux style "Pacman" package manager, for Microsoft's "vcpkg-tool" - or a customization of it - to enable much greater interoperability between Msys's MinGW-based sub-systems (including the Clang toolchain variants and their tools), and the native development environment (IDE integration, etc); as well as integrating a much larger package registry for third-party libraries (vcpkg's "ports"), cross-compiling support, and driven by a finely-tuned CMake configuration, tailored to tap into each subsystem's entire toolchain with ease.

Many vars will be translated (back!) over to their <b>'\<VCPKG_*\>'</b> origins in order to work as a drop-in toolchain for vcpkg. However, this is of particular interest as it opens up a lot more interoperability, which appeals to the core nature of the project itself.

Note that vcpkg also has the foundations of an MSYS installation in it's package registries, which it often uses to pull and patch <i>'*.pc'</i> files for build system variables. There are definitions of functions to pull varieties of MSYS packages (directly from Git/mirrors instead of via pacman) - there seems to be enough foundation there almost to spin vcpkg into some super-package-manager for a custom MSYS-based system, if wanted. Perhaps some of this can be leveraged later on...

## Supported Subsystems

Available <b>'\<MSYSTEM\>'</b> options...

* <b>'\<CLANGARM64\>'</b>
* <b>'\<CLANG64\>'</b>
* <b>'\<CLANG32\>'</b>
* <b>'\<MINGW64\>'</b>
* <b>'\<MINGW32\>'</b>
* <b>'\<UCRT64\>'</b>
* <b>'\<MSYS\>'</b>

## Cross compiling...?

We need solid native configs first, in any case.

# Dev latest

Full build support for all subsystems (except Clang arm64) done. Not heavily tested outside of MinGW64, Clang64, and ucrt64 for the moment, but they are certainly functioning in terms of picking up toolchain binaries correctly.

Handling of the "MSYSTEM" var, the chainload file, and the triplet files is a somewhat tricky, questionable affair. Lots of vars specified in the buildsystem file seem to get wiped multiple times per CMake run; trying to force some of these vars to stick in the cache then corrupts the intended fall-through behaviour of the other var(s), which is all the more problematic since the chosen toolchain file tends to get read several times repeatedly during each CMake run - and with all of the previous vars wiped!

The LLVM Project behind Clang have some very useful CMake modules for automatically detecting your host triplet, setting your target triplet, and changing settings related to the CRT (including populating a list of possible CRT types in the current environment!). These certainly are informative and will likely be hacked into this project in some way, where usage is reasonable.

The biggest concern about resolving all of the above moving forward, is breaking integration with the native vcpkg buildsystem file by introducing new functional dependencies to our buildsystem file. This project stays very close to it's inspiration sources because it intends to be fully compatible with them; to the extent that we'd rather be falling back on Kitware/Microsoft/LLVM-provided code as much as possible, and here only provide extensions to those which enable this enanced useability between Msys, CMake, and vcpkg. This project will most likely succeed only by filling in some small gaps, mostly redirecting existing information as required. The sheer number of possible permutations for every important var - all quite knowable vars (the majority of which are not officially documented by Kitware), but the dreaded task of accounting for each of them, under every given combination - would be insurmountable. Fortunately, by actually using that which is already provided to us in CMake's Modules folder, the actual number of critical vars to get a successful configuration run is reduced to a much more human-friendly number.

The key turnaround was realizing that the standard CMake installation files 'CMakeLanguageInformation' and 'CMakeGenericSystem' have CMake do some tricky/clever/probably-regretted file-hopping during its' configuration runs. This posed a complex little puzzle where some pieces would light up but not others, until eventually it was realized by the author that one can simply... 'cheat' (well not really) by including the *actual* file(s) that you want, in the files which are already successfully lighting up. No need to maintain our own, poorly-tested and not-fully-understood ripoffs - I mean forks - of CMake source code; we can simply *fall back to the actual CMake source code instead*, where the people know what they are doing, and managing it perfectly better than this project could!

I won't set up a dev branch, proper doc files, git flows, PR/issue templates or anything else until I mark the actual source code to be out of development, but please consider this repo very much public and the author more than happy to investigate any further findings, take questions, etc.

# Thanks for reading!
