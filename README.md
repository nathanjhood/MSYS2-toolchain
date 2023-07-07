# MSYS2 toolchain

For CMake integration and vcpkg support.

Eventual intended usage would be to supercede Msys's native Arch-Linux style "Pacman" package manager, for Microsoft's "vcpkg-tool" - or a customization of it - to enable much greater interoperability between Msys's MinGW-based sub-systems (including the Clang toolchain variants and their tools), and the native development environment (IDE integration, etc); as well as integrating a much larger package registry for third-party libraries (vcpkg's "ports"), cross-compiling support, and driven by a finely-tuned CMake configuration, tailored to tap into each subsystem's entire toolchain with ease.


## Example usage:

```
$ cmake -S "<path/to/project>" -B "<path/to/project>/build" -DCMAKE_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/buildsystems/MSYS2.cmake -DMSYSTEM:STRING=MINGW64 -G "Ninja Multi-Config"
```

## Description

This is a CMake port of the contents of several CMake modules and functions as found in Windows MSYS2 installations:

* <i>'/etc/makepkg.conf'</i> (for <b>'\<MSYS\>'</b>)
* <i>'/etc/makepkg_mingw.conf'</i> (for <b>'\<MINGW32/64\>'</b>, <b>'\<CLANG32/64/ARM64\>'</b>, and <b>'\<URCRT64\>'</b>)

...in tandem with the design of Microsoft's 'vcpkg' package manager and it's paradigm.

There are several components that comprise this vcpkg paradigm:

* Build system
* Toolchain
* Configuration of 'target' and 'host' (known as a 'triplet')

In a CMake-driven build, these are all essentially controlled by configuration files ('toolchain' files) which provide a full set of environment variables, binary/library paths, and compiler flags for each of the available invoking MSYS sub-systems, targeting each of the underlying Make program behaviours.

We don't want build-system configs to be baked into our projects (because they contain variables relevant only to the machine used to build with), so the typical procedure is to specify a 'toolchain' that configures the end-users build system appropriately, based on what is available to the specific build system, come build time. Since each MSYS2 sub-system has it's own compiler toolchain, there are many environmental variants among each sub-system that require critical attention in order to be correctly utilized in custom builds and projects.

To use the toolchain, pass these vars to your CMake invocation;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

* <b>-DMSYSTEM</b>:STRING=<i>"\<MINGW64\>"</i>

or to use a sub-system without the encasing buildsystem;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/toolchains/MINGW64.cmake"</i>


The 'chainload' toolchain files ('scripts/toolchains') are named identically to the chosen <b>'\<MSYSTEM\>'</b> and provide more thorough default behaviours for invoked <b>'\<MSYSTEM\>'</b> settings. Use in tandem for best results. However, there is *some* experimental support for passing just the 'buildsystem' file without any '\<MSYSTEM\>':

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

<b>\'<CMAKE_TOOLCHAIN_FILE\>'</b> and <b>\'<MSYSTEM\>'</b> can often also be set in your IDE's CMake integration extension's settings, and/or a <i>'CMakePresets.json'</i> in the project root folder.

For best results, it is recommended to use either <i>'Ninja'</i> or <i>'Ninja Multi-Config'</i> as a generator, with the 'preferred' generator set to one of the Makefile generators - <i>'Unix/MinGW/MSYS Makefiles'</i> etc.

Some useful settings are provided in <i>'.vscode/settings.json'</i>.

## Options

We have a working implementation of Msys64's 'path type' switching option, as follows:

* if MSYS2_PATH_TYPE == "inherit"

    Inherit previous path. Note that this will make all of the
    Windows path available in current shell, with possible
    interference in project builds.

* if MSYS2_PATH_TYPE == "minimal"

* if MSYS2_PATH_TYPE == "strict"

    Do not inherit any path configuration, and allow for full
    customization of external path. This is supposed to be used
    in special cases such as debugging without need to change
    this file, but not daily usage.

## How does it work?

MSYS2-toolchain uses a direct translation of the MSYS-provided Makefile config variables and Microsoft's vcpkg toolchain system, to configure your MSYS2-based CMake runs ensuring all meaningful native build system variables are translated from GNU-based Make projects, to the more universal CMake platform. The inspiration from vcpkg (though obvious) is especially useful in context of the over-arching "buildsystem/toolchain";

* The 'MSYS2.cmake' buildsystem file (which is actually passed in as a toolchain file) is akin to loading an Msys64 shell using the default, cygwin-based MSYSTEM called "MSYS". This file aims to provide CMake with access to the entire set of Msys sub-systems (simultaneously, if possible) and configure your CMake project to use the native "MSYS" build tools in your build run, if you wish.

* The 'buildsystem' file therefore acts as a kind of (optional) 'master' file - it provides a wide range of optional extras such as download agents for ftp, http(s), scp and more; compression and archiving utilities with GPG signature capabilites; direct access to <b>pacman</b> commands and entire package group downloads in simple CMake function form... and more (most of this is currently half-implemented and quite low on the priority list for now).

* This 'buildsystem' file can act as a base that can be easily extended, simply by loading the usual Msys sub-systems as 'chainload' files, which fetch the entire build tool chain for the given sub-system, *alongisde* the "MSYS" buildsystem. This will also populate your toolchain with additional goodies found in each sub-system, such as linting tools like '.clang-format' and friends (for the Clang-based systems).

* In the case of 'chainloading' a subsystem, *both* the default "MSYS" *and* the chosen sub-system (MINGW32, CLANGARM64, etc) are "live" in your CMake runs, with options to specify whether your builds should favour the native "MSYS" tools, or those of the given sub-system (experimental!).

* In reality, the toolchain for the default "MSYS" environment is actually defined in a 'chainload' file, just like all the other sub-systems - it is simply loaded (in the same way as a 'chainload' file) when using the 'buildsystem' file for the master file of the toolchain. So, when active, the 'buildsystem' always contains the "MSYS" sub-system's 'chainload' file, as well as any other you might pass into the chainload file slot.

* Just like the other sub-systems, "MSYS" aims to be usable without the 'buildsystem' encapsulating it, if you wish.

* Lastly, it's important to note that the 'buildsystem' file - that is, "MSYS2.cmake", *also* over-writes the standard CMake 'add_library()' and 'add_executable()' functions in order to append important flag variables, copy and move your project dependency binaries to where they are needed (great when packing for distribution), and provide deeper integration into the build process for an Msys64 'chainloaded' sub-system. These extended functions are what gives the file the definition of being a 'buildsystem'. That being said, there is in fact support for loading the sub-system files as the primary toolchains themselves; they *should* still populate your build configuration with their build tools and settings appropriately without any further adjusting. One of the main restrictions of doing this is having potentially some quite useful tools (and those CMake function re-definitions) from the native "MSYS" environment unavailable, but this may not prevent a successful build.

## Development

The main files at the core of the project are:

* 'scripts/buildsystems/MSYS2.cmake'

* 'scripts/toolchains/\<MSYSTEM\>.cmake'

* 'scripts/cmake/Modules/Platform/MSYSTEM.cmake'

* 'scripts/cmake/Modules/Platform/MSYSTEM-\<COMPILER_ID\>.cmake'

It should be noted that the first file, the 'buildsystem' file, actually contains and 'include()' directive for the second file - the 'toolchain' file, where the sub-system's toolchain is specified. This inclusion happens as a result of comparing the '\<MSYSTEM\>' variable against their usual shell names.

It is well worth noting that both files are pretty much direct clones of corresponding files found in <a href="https://github.com/microsoft/vcpkg.git">microsoft's excellent vcpkg package manager</a>.

While these have currently been overwritten for project development purposes, the intention is to fall back to the files supplied by a conventional vcpkg installation, probably just supplemented with a few additional CMake Platform Modules. There is a clear attempt here at unifying much of the processes between vcpkg and CMake under the name of msys, but aside from clearly having no affiliation with any said parties, this purely a development stage artefact exposed in the hope of providing better insight into project status, providing a more successful experience for any passers-by, and hopefully providing more opportunity for understanding that which I've no time to document here in this development journal, realistically speaking. The eventual project on conclusion will more or less "just work" without so much borrowed code ;)

Please be aware that a prefix of just "MSYS_" is referring to vars coming from the 'buildsystem' file, if loaded. The vars with prefix of "MSYS<u>2</u>_" refer to what you would usually get from Msys64 if entering the "MSYS2" subsystem. It's a close call, but I think it's ok!?

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

## Dev latest

I won't set up a dev branch, proper doc files, git flows, PR/issue templates or anything else until I mark the actual source code to be out of development, but please consider this repo very much public and the author more than happy to investigate any further findings, take questions, etc.

Thanks for reading!
