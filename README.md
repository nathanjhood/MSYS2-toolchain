# MSYS2 toolchain

For CMake/vcpkg integration.

NOTE: Until further notice, you should treat this repo 'not fiished, but interesting to study' and consider helping out/contributing if you can :) I may become too busy to finish this beyond a basic implementation for my own needs, for the time being, without a little help.

As of writing, I've hard-coded <b>'\<MSYSTEM\>'</b> to be set to the <b>'\<MINGW64\>'</b> environment/toolchain, to narrow down a single working environment before copying the successful design pattern over to enable the remaining environments. It's a pretty simple fix away if you know CMake and would like to poke around with it's current state. Make sure you 'pacman -S mingw-w64-x86_64-toolchain' as well as get the CMake/Ninja/etc packages for the default MSYS shell, for the best experience.

## Example usage:

```
$ cmake -S "<path/to/project>" -B "<path/to/project>/build" -DCMAKE_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/buildsystems/MSYS2.cmake -DMSYS_CHAINLOAD_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/toolchains/MINGW64.cmake -DMSYSTEM:STRING=MINGW64 -G Ninja
```

## Description

This is a CMake port of the contents of <i>'/etc/makepkg.conf'</i> (for <b>'\<MSYS\>'</b>), and <i>'/etc/makepkg_mingw.conf'</i> (for <b>'\<MINGW32/64\>'</b>, <b>'\<CLANG32/64/ARM64\>'</b>, and <b>'\<URCRT64\>'</b>) as found in Windows MSYS2 installations. These configuration files provide a full set of environment variables, binary/library paths, and compiler flags for each of the available invoking MSYS sub-systems, targeting the configuration system-based Make program. This port replicates the same configuration behaviour, but relevant to CMake instead of GNU Make.

We don't want build-system configs to be baked into our projects, so the typical procedure is to specify a 'toolchain' that configures our build system for us, based on what is available to the specific build system, come build time. Since each MSYS2 sub-system has it's own compiler toolchain, there are many environmental variants among each sub-system that require critical attention in order to be correctly utilized in custom builds and projects.

MSYS2-toolchain uses a direct translation of the OME-provided Make config variables, to configure your MSYS2-based CMake runs ensuring all meaningful native build system variables are translated from GNU-based Make projects, to the more universal CMake platform


To use the toolchain, pass either;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

or to use in tandem with an MSYSTEM;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<VCPKG_ROOT\>/scripts/buildsystems/MSYS2.cmake"</i>

* <b>-DMSYS_CHAINLOAD_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/toolchains/CLANG64.cmake"</i>

And also pass an <b>'\<MSYSTEM\>'</b>, just like when invoking msys64 (example);

* <b>-DMSYSTEM</b>:STRING=<i>"CLANG64"</i>

Available <b>'\<MSYSTEM\>'</b> options...

* <b>'\<CLANGARM64\>'</b>
* <b>'\<CLANG64\>'</b>
* <b>'\<CLANG32\>'</b>
* <b>'\<MINGW64\>'</b>
* <b>'\<MINGW32\>'</b>
* <b>'\<UCRT64\>'</b>
* <b>'\<MSYS\>'</b>

The 'chainload' toolchain files are named identically to the chosen <b>'\<MSYSTEM\>'</b> and provide more thorough default behaviours for invoked <b>'\<MSYSTEM\>'</b> settings. Use in tandem for best results. However, there is *some* experimental support for passing a 'chainload' file directly, outside of the Msys build system:

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<VCPKG_ROOT\>/scripts/toolchains/UCRT64.cmake"</i>

Results may vary in these cases, in some parts due to differing levels of interoperability between the subsystems and the Windows environment itself. It *should* therefore be quite suitable to use a 'chainload' file as the primary toolchain file, if the project is invoked directly from inside the <b>'\<MSYSTEM\>'</b> bash shell itself (i.e., the relevant command line app in your Msys installation). This needs much more thorough testing, but initial results have been quite positive thus far.

<b>\'<CMAKE_TOOLCHAIN_FILE\>'</b> and <b>\'<MSYS_CHAINLOAD_TOOLCHAIN_FILE\>'</b> can often also be set in your IDE's CMake integration extension's settings, and/or a <i>'CMakePresets.json'</i> in the project root folder.

For best results, it is recommended to use either <i>'Ninja'</i> or <i>'Ninja Multi-Config'</i> as a generator, with the 'preferred' generator set to one of the Makefile generators - <i>'Unix/MinGW/MSYS Makefiles'</i> etc.

Some useful settings are provided in <i>'.vscode/settings.json'</i>.

## Todo

Lots of paths to fix, test, etc. Lots of cleanup. Potentially a re-write in store to compile more variable strings from other variable strings (<b><i>'\<MINGW_PACKAGE_PREFIX\>-\<TOOLCHAIN_TO_USE\>'</i></b>, etc...), however I don't personally prefer this approach because it requires a CMake run in order to fetch these compiled variables, compared to just having them defined at-a-glance in the toolchain file, and tells us (less than) nothing about the variables that we *haven't* selected for that run. Preferring verbosity during dev/debug, meanwhile.

Consider adding in some of the switching logic from the excellent 'fougas.msys2' VSCode extension.

Considering extending the available <b>'\<MSYSTEM>\'</b> list by adding the following:

* <b>\<CLANGCL64\></b>
* <b>\<CLANGCL32\></b>

The idea would be to call the MSVC-style 'cl' compiler frontend executables (<i>'clang-cl.exe'</i>) for Clang toolchains, to ease interoperability with MSBuild-style compile flags and command lines.

Everything besides the C/C++ compiler paths would be as per their non-CL counterparts.

Note that there is actually a git <i>'.patch'</i> file for MSYS that ships with vcpkg, which attempts to add <i>'clang-cl.exe'</i> to the compiler search path for the 'autotools-1-16' package:

```
    diff --git a/usr/share/automake-1.16/compile b/usr/share/automake-1.16/compile
    index 2078fc833..dfc946593 100755
    --- a/usr/share/automake-1.16/compile
    +++ b/usr/share/automake-1.16/compile
    @@ -256,6 +256,7 @@ EOF
        exit $?
        ;;
    cl | *[/\\]cl | cl.exe | *[/\\]cl.exe | \
    +  clang-cl | *[/\\]clang-cl | clang-cl.exe | *[/\\]clang-cl.exe | \
    icl | *[/\\]icl | icl.exe | *[/\\]icl.exe )
        func_cl_wrapper "$@"      # Doesn't return...
        ;;
```

In other words, using any editor, go to <b><i>'<MSYS_ROOT>/usr/share/automake-1.16/compile'</i></b> line number 256, where you should see this:

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

Cross compiling...? We need solid native configs first, in any case.

Many vars will need to be translated over to <b>'\<VCPKG_*\>'</b> counterparts in order to work as a drop-in toolchain for vcpkg. However, this is of particular interest as it opens up a lot more interoperability, which appeals to the core nature of the project itself. Once the toolchain is working solidly in isolation, it's either a case of grepping/changing the relevant vars (see vcpkg's <b>'\<VCPKG_ROOT\>/scripts/toolchain/mingw.cmake'</b> files and <b><i>'\<VCPKG_ROOT\>/scripts/buildsystems/vcpkg.cmake'</i></b> toolchain file) or building an extension that naively 'converts' the variables, for example, when vcpkg is detected (or something like that).

Note that vcpkg also has the foundations of an MSYS installation in it's package registries, which it often uses to pull and patch <i>'*.pc'</i> files for build system variables. There are definitions of functions to pull varieties of MSYS packages (directly from Git/mirrors instead of via pacman) - there seems to be enough foundation there almost to spin vcpkg into some super-package-manager for a custom MSYS-based system, if wanted. Perhaps some of this can be leveraged later on...

Lastly, the LLVM project contains some interesting CMake functions that run some of the Clang tools (clang-format, etc) during config/build runs. I've thrown all the clang-format presets into a submodule with the intention of hooking these into the clang toolchains a lá the LLVM CMake functions - probably offering <b>'\<LLVM\>'</b>, <b>'\<GNU\>'</b>, and Microsoft (<b>'\<MSVC\>'</b>?) flavours, which might nicely complement the differing flavours of compiler frontends and toolchain variants. It's possible to build (maybe even bootstrap-download) clang-format for non-LLVM toolchains with some extra effort, also.

## In progress... please stay tuned :)
