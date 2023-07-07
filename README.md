# MSYS2 toolchain

For CMake integration and vcpkg support.

Full build support for all Msys64 sub-systems!

Eventual intended usage would be to supercede Msys's native Arch-Linux style "Pacman" package manager, for Microsoft's "vcpkg-tool" - or a customization of it - to enable much greater interoperability between Msys's MinGW-based sub-systems (including the Clang toolchain variants and their tools), and the native development environment (IDE integration, etc); as well as integrating a much larger package registry for third-party libraries (vcpkg's "ports"), cross-compiling support, and driven by a finely-tuned CMake configuration, tailored to tap into each subsystem's entire toolchain with ease.


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

# <b>Description</b>

This independent project is an ongoing investigation into the potential of cross-pollinating <a href="">MSYS2</a>'s multi-verse of build envinronments and toolchains, with the source code package registry access and management of <a href="">Microsoft's vcpkg</a>, thanks to the power and flexibility of <a href="">CMake</a>.


This involves is porting the contents of several configuration as found in Windows MSYS2 installations:

* <a href="">etc/makepkg.conf</a>*
* <a href="">etc/makepkg_mingw.conf</a>**

(*for "<b>MSYS2</b>")

(**for "<b>MINGW32</b>/<b>64</b>", "<b>CLANG32</b>/<b>64</b>/<b>ARM64</b>", and "<b>URCRT64</b>")

These files are typically used to drive configurations for "<b>PKGBUILD</b>", which is the integrated package-building/bundling mechanism used by '<b>pacman</b>' in typical development scenarios when using MSYS2.

This project aims to port as much of the above as possible to a natively-CMake-driven process, including the integration of a port Microsoft's 'vcpkg' package manager and its' useful "triplet/toolchain/buildsystem" paradigm:

* Known configuration of '<b>host</b>'<b>*</b> system to build on.
* Desired configuration of '<b>target</b>'<b>*</b> system to run on.
* Chain of tools to build with, i.e., a '<b>toolchain</b>'.
* A building process to invoking all of the above, i.e., a '<b>build system</b>'.

<i><b>*</b> these configurations are referred to as '<b>triplets</b>'</i>

In a CMake-driven build environment, these settings can all be pre-defined with configuration scripts ('<b>toolchain files</b>') which configure CMake with a full set of environment variables, binary/library paths, and compiler flags for each of the available invoking MSYS sub-systems (often known as "MSYSTEM"'s), appropriately setting each of the underlying build tool behaviours for each sub-system, enabling CMake to correctly find and use them.

This project aims to do precisely the above with as minimal user requirements as possible. With the desired toolchain(s) on your pacman-driven Msys installation in place, it should be as simple as passing the 'MSYS2.cmake' buildsystem file (as the CMake toolchain) and an 'MSYSTEM' to your CMake invocation, making the entire sub-system readily available to your CMake/Msys64 projects.

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

We don't want build-system configs to be baked into our project source code (because they contain variables relevant only to the machine used to build with), so one common working method is to specify a '<b>toolchain file</b>' that configures the end-user/developer's build system appropriately, based on what is available on their specific build system, come build time. A well-designed implementation is a balance of machine-based file lookup, coupled with very careful design patterns for fall-through cases, where something important might not have been (possible to have been) specified at a certain point in the build process. Since each MSYS2 sub-system has it's own compiler toolchain, runtime libraries, and architecture, there are many environmental variants among each sub-system that require critical attention in order to be correctly utilized in custom builds and projects.

Fortunately, for this project to achieve it's targets, much of the required configurations are already available within CMake (and vcpkg), and we have simply a process of directing the flow of file-hopping that CMake does under the hood when configuring/building/etc to pick up combinations of native CMake files that otherwise aren't currently available at the time of this project's creation.

(to better understand this last paragraph, please see the files under 'scripts/cmake/Modules/Platform'...)

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

</br>
</br>

While these have currently been overwritten for project development purposes, the intention is to fall back to the files supplied by a conventional vcpkg installation, probably just supplemented with a few additional CMake Platform Modules. There is a clear attempt here at unifying much of the processes between vcpkg and CMake under the name of msys, but aside from clearly having no affiliation with any said parties, this purely a development stage artefact exposed in the hope of providing better insight into project status, providing a more successful experience for any passers-by, and hopefully providing more opportunity for understanding that which I've no time to document here in this development journal, realistically speaking. The eventual project on conclusion will more or less "just work" without so much borrowed code ;)

Please be aware that a prefix of just "MSYS_" is referring to vars coming from the 'buildsystem' file, if loaded. The vars with prefix of "MSYS<u>2</u>_" refer to what you would usually get from Msys64 if entering the "MSYS2" subsystem. It's a close call, but I think it's ok!?

## How does it work?

MSYS2-toolchain uses a direct translation of the MSYS-provided Makefile config variables and Microsoft's vcpkg toolchain system, to configure your MSYS2-based CMake runs ensuring all meaningful native build system variables are translated from GNU-based Make projects, to the more universal CMake platform. The inspiration from vcpkg (though obvious) is especially useful in context of the over-arching "buildsystem/toolchain";

* The 'MSYS2.cmake' buildsystem file (which is actually passed in as a toolchain file) is akin to loading an Msys64 shell using the default, cygwin-based MSYSTEM called "MSYS". This file aims to provide CMake with access to the entire set of Msys sub-systems (simultaneously, if possible) and configure your CMake project to use the native "MSYS" build tools in your build run, if you wish.

* The 'buildsystem' file therefore acts as a kind of (optional) 'master' file - it provides a wide range of optional extras such as download agents for ftp, http(s), scp and more; compression and archiving utilities with GPG signature capabilites; direct access to <b>pacman</b> commands and entire package group downloads in simple CMake function form... and more (most of this is currently half-implemented and quite low on the priority list for now).

* This 'buildsystem' file can act as a base that can be easily extended, simply by loading the usual Msys sub-systems as 'chainload' files, which fetch the entire build tool chain for the given sub-system, *alongisde* the "MSYS" buildsystem. This will also populate your toolchain with additional goodies found in each sub-system, such as linting tools like '.clang-format' and friends (for the Clang-based systems).

* In the case of 'chainloading' a subsystem, *both* the default "MSYS" *and* the chosen sub-system (MINGW32, CLANGARM64, etc) are "live" in your CMake runs, with options to specify whether your builds should favour the native "MSYS" tools, or those of the given sub-system (experimental!).

* In reality, the toolchain for the default "MSYS" environment is actually defined in a 'chainload' file, just like all the other sub-systems - it is simply loaded (in the same way as a 'chainload' file) when using the 'buildsystem' file for the master file of the toolchain. So, when active, the 'buildsystem' always contains the "MSYS" sub-system's 'chainload' file, as well as any other you might pass into the chainload file slot.

* Just like the other sub-systems, "MSYS" aims to be usable without the 'buildsystem' encapsulating it, if you wish.

* Lastly, it's important to note that the 'buildsystem' file - that is, "MSYS2.cmake", *also* over-writes the standard CMake 'add_library()' and 'add_executable()' functions in order to append important flag variables, copy and move your project dependency binaries to where they are needed (great when packing for distribution), and provide deeper integration into the build process for an Msys64 'chainloaded' sub-system. These extended functions are what gives the file the definition of being a 'buildsystem'. That being said, there is in fact support for loading the sub-system files as the primary toolchains themselves; they *should* still populate your build configuration with their build tools and settings appropriately without any further adjusting. One of the main restrictions of doing this is having potentially some quite useful tools (and those CMake function re-definitions) from the native "MSYS" environment unavailable, but this may not prevent a successful build.

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

Many vars will be translated (back!) over to their <b>'\<VCPKG_*\>'</b> origins in order to work as a drop-in toolchain for vcpkg. However, this is of particular interest as it opens up a lot more interoperability, which appeals to the core nature of the project itself.

Cross compiling...? We need solid native configs first, in any case.

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

Main development is happening on the MinGW x64 variant, closely followed by the Clang x64 and then MinGW x86 varieties. The '\<MSYS2\>' subsystem mostly falls back on CMake's platform defaults for Cygwin, whereas the others require more tailoring to take full advantage of the buildsystem and create rigidly-defined behaviour. If something doesn't appear to be working, please keep in mind the priority order above. The ucrt64 case I believe will require a bit further effort, then even more so for Clang arm64 cases. The MinGW-based GNU/Clang subsystems are where most of the working proof can be seen.

# Dev latest

Full build support for all subsystems (except Clang arm64) done. Not heavily tested outside of MinGW64, Clang64, and ucrt64 for the moment, but they are certainly functioning in terms of picking up toolchain binaries correctly.

Handling of the "MSYSTEM" var, the chainload file, and the triplet files is a somewhat tricky, questionable affair. Lots of vars specified in the buildsystem file seem to get wiped multiple times per CMake run; trying to force some of these vars to stick in the cache then corrupts the intended fall-through behaviour of the other var(s), which is all the more problematic since the chosen toolchain file tends to get read several times repeatedly during each CMake run - and with all of the previous vars wiped!

The LLVM Project behind Clang have some very useful CMake modules for automatically detecting your host triplet, setting your target triplet, and changing settings related to the CRT (including populating a list of possible CRT types in the current environment!). These certainly are informative and will likely be hacked into this project in some way, where usage is reasonable.

The biggest concern about resolving all of the above moving forward, is breaking integration with the native vcpkg buildsystem file by introducing new functional dependencies to our buildsystem file. This project stays very close to it's inspiration sources because it intends to be fully compatible with them; to the extent that we'd rather be falling back on Kitware/Microsoft/LLVM-provided code as much as possible, and here only provide extensions to those which enable this enanced useability between Msys, CMake, and vcpkg. This project will most likely succeed only by filling in some small gaps, mostly redirecting existing information as required. The sheer number of possible permutations for every important var - all quite knowable vars (the majority of which are not officially documented by Kitware), but the dreaded task of accounting for each of them, under every given combination - would be insurmountable. Fortunately, by actually using that which is already provided to us in CMake's Modules folder, the actual number of critical vars to get a successful configuration run is reduced to a much more human-friendly number.

The key turnaround was realizing that the standard CMake installation files 'CMakeLanguageInformation' and 'CMakeGenericSystem' have CMake do some tricky/clever/probably-regretted file-hopping during its' configuration runs. This posed a complex little puzzle where some pieces would light up but not others, until eventually it was realized by the author that one can simply... 'cheat' (well not really) by including the *actual* file(s) that you want, in the files which are already successfully lighting up. No need to maintain our own, poorly-tested and not-fully-understood ripoffs - I mean forks - of CMake source code; we can simply *fall back to the actual CMake source code instead*, where the people know what they are doing, and managing it perfectly better than this project could!

I won't set up a dev branch, proper doc files, git flows, PR/issue templates or anything else until I mark the actual source code to be out of development, but please consider this repo very much public and the author more than happy to investigate any further findings, take questions, etc.

Thanks for reading!
