# MSYS2 toolchain

For CMake/vcpkg integration.

*CURRENTLY ONLY SUPPORTING MINGW64 FOR DEVELOPMENT PURPOSES!*

## Example usage:

```
$ cmake -S "<path/to/project>" -B "<path/to/project>/build" -DCMAKE_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/buildsystems/MSYS2.cmake -DMSYS_CHAINLOAD_TOOLCHAIN_FILE:FILEPATH=<path/to/this/repo>/scripts/toolchains/MINGW64.cmake -DMSYSTEM:STRING=MINGW64 -G Ninja
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

MSYS2-toolchain uses a direct translation of the MSYS-provided Makefile config variables and Microsoft's vcpkg toolchain system, to configure your MSYS2-based CMake runs ensuring all meaningful native build system variables are translated from GNU-based Make projects, to the more universal CMake platform. The inspiration from vcpkg (though obvious) is especially useful in context of the over-arching "buildsystem/toolchain";

* The 'MSYS2.cmake' buildsystem file (which is actually passed in as a toolchain file) is akin to loading an Msys64 shell using the default, cygwin-based MSYSTEM called "MSYS". This file aims to provide CMake with access to the entire set of Msys sub-systems (simultaneously, if possible) and configure your CMake project to use the native "MSYS" build tools in your build run, if you wish.

* The 'buildsystem' file therefore acts as a kind of (optional) 'master' file - it provides a wide range of optional extras such as download agents for ftp, http(s), scp and more; compression and archiving utilities with GPG signature capabilites; direct access to <b>pacman</b> commands and entire package group downloads in simple CMake function form... and more!

* This 'buildsystem' file can act as a base that can be easily extended, simply by loading the usual Msys sub-systems as 'chainload' files, which fetch the entire build tool chain for the given sub-system, *alongisde* the "MSYS" buildsystem. This will also populate your toolchain with additional goodies found in each sub-system, such as linting tools like '.clang-format' and friends (for the Clang-based systems).

* In the case of 'chainloading' a subsystem, *both* the default "MSYS" *and* the chosen sub-system (MINGW32, CLANGARM64, etc) are "live" in your CMake runs, with options to specify whether your builds should favour the native "MSYS" tools, or those of the given sub-system (experimental!).

* In reality, the toolchain for the default "MSYS" environment is actually defined in a 'chainload' file, just like all the other sub-systems - it is simply loaded (in the same way as a 'chainload' file) when using the 'buildsystem' file for the master file of the toolchain. So, when active, the 'buildsystem' always contains the "MSYS" sub-system's 'chainload' file, as well as any other you might pass into the chainload file slot.

* Just like the other sub-systems, "MSYS" aims to be usable without the 'buildsystem' encapsulating it, if you wish.

* Lastly, it's important to note that the 'buildsystem' file - that is, "MSYS2.cmake", *also* over-writes the standard CMake 'add_library()' and 'add_executable()' functions in order to append important flag variables, copy and move your project dependency binaries to where they are needed (great when packing for distribution), and provide deeper integration into the build process for an Msys64 'chainloaded' sub-system. These extended functions are what gives the file the definition of being a 'buildsystem'. That being said, there is in fact support for loading the sub-system files as the primary toolchains themselves; they *should* still populate your build configuration with their build tools and settings appropriately without any further adjusting. One of the main restrictions of doing this is having potentially some quite useful tools (and those CMake function re-definitions) from the native "MSYS" environment unavailable, but this may not prevent a successful build.

To use the toolchain, pass either;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

or to use in tandem with a (supported!) sub-system;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<VCPKG_ROOT\>/scripts/buildsystems/MSYS2.cmake"</i>

* <b>-DMSYS_CHAINLOAD_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/toolchains/CLANG64.cmake"</i>

*(NOT YET SUPPORTED! STAY TUNED!)* And also pass an <b>'\<MSYSTEM\>'</b>, just like when invoking msys64 (example);

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

## Development

In practice, I'm trying to define multiple 'sets' of CMake variables, each 'set' given the prefix of "${MSYSTEM}_". This allows, for example, that we might have access to, and control over, multiple different sub-systems at the same time, without naming clashes.

For example, if looking for a C++ compiler, we'd usually find that CMake has set the following variable in the Cache file:

* CMAKE_CXX_COMPILER=clang++.exe

Which is great, but when we have up to 6 (woe!) toolchains - and that's only the ones in an Msys64 installation, you might have more on your system of course - the string 'clang++.exe' doesn't actually give us much indication as to what compiler is running, under the hood. CMake does provide some verbiage to this effect while running, but it might be much better if we could utilize everything that the amazing team behind Msys64 already did in their configuration scripts, something more like (and here's some more vcpkg inspiration...):

* ${MSYSTEM}_CXX_COMPILER="${MSYSTEM_ROOT_DIR}/${MSYSTEM_PACKAGE_PREFIX}-c++.exe"

Which, for an "MSYSTEM" == "MINGW64", would resolve to:

```
MINGW64_CXX_COMPILER="C:/msys64/mingw64/mingw-w64-x86_64-c++.exe"
```

Or, for an "MSYSTEM" == "CLANGARM64", would resolve to:

```
CLANGARM64_CXX_COMPILER="C:/msys64/clangarm64/mingw-w64-clang-aarch64-c++.exe"
```

It would then be easy (!) to wrap some logic like so:

```
set(MSYS_ROOT_DIR "$ENV{HomeDrive}/msys64")
set(CLANGARM64_INC_DIR "${MSYS_ROOT_DIR}/include")
set(CLANGARM64_BIN_DIR "${MSYS_ROOT_DIR}/bin")

if("${MSYSTEM}" EQUAL "MINGW64")

    # Get MINGW64 paths...
    set(MINGW64_ROOT_DIR "${MSYS_ROOT}/mingw64")
    set(MINGW64_INC_DIR "${MINGW64_ROOT_DIR}/include")
    set(MINGW64_BIN_DIR "${MINGW64_ROOT_DIR}/bin")

    set(CMAKE_CXX_COMPILER="${MINGW64_BIN_DIR}/mingw-w64-x86_64-c++.exe")

    set(MINGW64_ENABLED ON)

elseif("${MSYSTEM}" EQUAL "CLANGARM64")

    # Get CLANGARM64 paths...
    set(CLANGARM64_ROOT_DIR "${MSYS_ROOT_DIR}/clangarm64")
    set(CLANGARM64_INC_DIR "${CLANGARM64_ROOT_DIR}/include")
    set(CLANGARM64_BIN_DIR "${CLANGARM64_ROOT_DIR}/bin")

    set(CMAKE_CXX_COMPILER="${CLANGARM64_BIN_DIR}/mingw-w64-clang-aarch64-c++.exe")

    set(CLANGARM64_ENABLED ON)

else()

    # Get MSYS2 paths...
    set(MSYS2_ROOT_DIR "${MSYS_ROOT_DIR}")
    set(MSYS2_INC_DIR "${MSYS2_ROOT_DIR}/include")
    set(MSYS2_BIN_DIR "${MSYS2_ROOT_DIR}/bin")

    set(CMAKE_CXX_COMPILER="${MSYS2_BIN_DIR}/c++.exe")

    set(MSYS2_ENABLED ON)

endif()
```

...and so forth. Naturally, the above is a condensed representation of the overall idea. There is a lot of testing and head-scratching to get one sub-system (and the 'buildsystem/chainload' paradigm) running nicely, for which I'm currently using MINGW64. Once that chainload file is complete (...?) it should be easy work for the IDE to 'change all occurances' of certain vars, and I'm sure everything will all just work out fine. :D

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

As of writing, I've hard-coded <b>'\<MSYSTEM\>'</b> to be set to the <b>'\<MINGW64\>'</b> environment/toolchain, to narrow down a single working environment before copying the successful design pattern over to enable the remaining environments. It's a pretty simple fix away if you know CMake and would like to poke around with the differing <b>'\<MSYSTEM\>'</b>'s in it's current state. Make sure you 'pacman -S mingw-w64-x86_64-toolchain' as well as get the CMake/Ninja/etc packages for the default MSYS shell, for the best experience.
