# MSYS2 toolchain

For CMake/vcpkg integration.

Eventual intended usage would be to supercede Msys's native Arch-Linux style "Pacman" package manager, for Microsoft's "vcpkg-tool" - or a customization of it - to enable much greater interoperability between Msys's MinGW-based sub-systems (including the Clang toolchain variants and their tools), and the native development environment (IDE integration, etc); as well as integrating a much larger package registry for third-party libraries (vcpkg's "ports"), cross-compiling support, and driven by a finely-tuned CMake configuration, tailored to tap into each subsystem's entire toolchain with ease.

The project shall eventually attempt to resort to as minimal a fileset as possible, for maximal portability, by hooking back into processes already implemented in typical CMake installations on any system. During development however, it is necessary to deeply examine these native CMake processes and probably overwrite them (intended as temporary measures) until the most efficient solution presents itself. When CMake runs its' configuration stage, there is a great deal of "file-hopping" going on under the hood where all of the system- and compiler- critical vars get set. In order to better understand this process, it is sometimes necessary to write out the intended "story" all in one big long file, leaving ourselves breadcrumbs here and there to find the way back to the "file-hopping" take on the cprovided configuration. The scale of the final project can be greatly reduced once our base implementation is fully realized and optimized. Until then, apologies for the masoleum of source code :)

*CURRENTLY ONLY SUPPORTING MSYSTEM=MINGW64 FOR DEVELOPMENT PURPOSES!*

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

MSYS2-toolchain uses a direct translation of the MSYS-provided Makefile config variables and Microsoft's vcpkg toolchain system, to configure your MSYS2-based CMake runs ensuring all meaningful native build system variables are translated from GNU-based Make projects, to the more universal CMake platform. The inspiration from vcpkg (though obvious) is especially useful in context of the over-arching "buildsystem/toolchain";

* The 'MSYS2.cmake' buildsystem file (which is actually passed in as a toolchain file) is akin to loading an Msys64 shell using the default, cygwin-based MSYSTEM called "MSYS". This file aims to provide CMake with access to the entire set of Msys sub-systems (simultaneously, if possible) and configure your CMake project to use the native "MSYS" build tools in your build run, if you wish.

* The 'buildsystem' file therefore acts as a kind of (optional) 'master' file - it provides a wide range of optional extras such as download agents for ftp, http(s), scp and more; compression and archiving utilities with GPG signature capabilites; direct access to <b>pacman</b> commands and entire package group downloads in simple CMake function form... and more (most of this is currently half-implemented and quite low on the priority list for now).

* This 'buildsystem' file can act as a base that can be easily extended, simply by loading the usual Msys sub-systems as 'chainload' files, which fetch the entire build tool chain for the given sub-system, *alongisde* the "MSYS" buildsystem. This will also populate your toolchain with additional goodies found in each sub-system, such as linting tools like '.clang-format' and friends (for the Clang-based systems).

* In the case of 'chainloading' a subsystem, *both* the default "MSYS" *and* the chosen sub-system (MINGW32, CLANGARM64, etc) are "live" in your CMake runs, with options to specify whether your builds should favour the native "MSYS" tools, or those of the given sub-system (experimental!).

* In reality, the toolchain for the default "MSYS" environment is actually defined in a 'chainload' file, just like all the other sub-systems - it is simply loaded (in the same way as a 'chainload' file) when using the 'buildsystem' file for the master file of the toolchain. So, when active, the 'buildsystem' always contains the "MSYS" sub-system's 'chainload' file, as well as any other you might pass into the chainload file slot.

* Just like the other sub-systems, "MSYS" aims to be usable without the 'buildsystem' encapsulating it, if you wish.

* Lastly, it's important to note that the 'buildsystem' file - that is, "MSYS2.cmake", *also* over-writes the standard CMake 'add_library()' and 'add_executable()' functions in order to append important flag variables, copy and move your project dependency binaries to where they are needed (great when packing for distribution), and provide deeper integration into the build process for an Msys64 'chainloaded' sub-system. These extended functions are what gives the file the definition of being a 'buildsystem'. That being said, there is in fact support for loading the sub-system files as the primary toolchains themselves; they *should* still populate your build configuration with their build tools and settings appropriately without any further adjusting. One of the main restrictions of doing this is having potentially some quite useful tools (and those CMake function re-definitions) from the native "MSYS" environment unavailable, but this may not prevent a successful build.

To use the toolchain, pass these vars to your CMake invocation;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

* <b>-DMSYSTEM</b>:STRING=<i>"\<MINGW64\>"</i>

or to use a sub-system without the encasing buildsystem;

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/toolchains/MINGW64.cmake"</i>


The 'chainload' toolchain files ('scripts/toolchains') are named identically to the chosen <b>'\<MSYSTEM\>'</b> and provide more thorough default behaviours for invoked <b>'\<MSYSTEM\>'</b> settings. Use in tandem for best results. However, there is *some* experimental support for passing just the 'buildsystem' file without any '\<MSYSTEM\>':

* <b>-DCMAKE_TOOLCHAIN_FILE</b>:FILEPATH=<i>"\<path/to/this/repo\>/scripts/buildsystem/MSYS2.cmake"</i>

I should probably provide something like an '\<MSYSTEM_DEFAULT_SUSBSYSTEM\>' for fallback cases... but meanwhile, only MINGW64 has even minimal support, so this is not implemented yet.

<b>\'<CMAKE_TOOLCHAIN_FILE\>'</b> and <b>\'<MSYSTEM\>'</b> can often also be set in your IDE's CMake integration extension's settings, and/or a <i>'CMakePresets.json'</i> in the project root folder.

For best results, it is recommended to use either <i>'Ninja'</i> or <i>'Ninja Multi-Config'</i> as a generator, with the 'preferred' generator set to one of the Makefile generators - <i>'Unix/MinGW/MSYS Makefiles'</i> etc.

Some useful settings are provided in <i>'.vscode/settings.json'</i>.

## Current Status

While support will depend on the day you check the repo until this comes out of development, I can report that I've had the MinGW x64 subsystem compiling C, C++, ASM, Fortran, and Objective C/C++ using the GNU Buildtools and GCC native to that environment. There is also a little trick to getting the correct RC compiler (i.e., 'windres' for GCC). It seems to run happily being invoked from anywhere (Powershell command line as Windows user, Msys command line under any shell, IDE integrated tools...) just as long as the CMAKE_TOOLCHAIN_FILE and MSYSTEM are set per the examples given. The underlying CMake is always the one installed under the MinGW x64 subsystem - thus, CMake is basically running "natively" under MinGW x64, no matter where I invoke it from. I consider this to be a huge marker that the concept is a working one, and full credit seems to fall toward the vcpkg team's buildsystem mechanism. It is quite encouraging to find that all the groundwork exists within these excellent tools to fully realize the concept of this project; there exists a lot of repeatability within CMake in how each language is activated and configured, and also each platform (i.e., Msys sub-system). However, anything approaching 'full support' for *all* languages on *all* sub-systems, is a *lot* of work to do no matter which way I slice it. Throw in the additional layer of support for Msys installations being *either* 32-bit or 64-bit, this would seem to double our entire workload again, as if the project didn't already seem unattainable without further hands on deck. However, the "repeatability" factor is something to heaviliy lean into. With this in mind, once the C/C++ toolset is well-defined and optimized for MinGW x64, this should -  yes, in theory! - be fairly easy to 'port' over to the remaining language toolsets for MinGW 64, and then a very simple and small set of changes gives us MinGW x32... As for Clang, it is very plug-and-play with CMake, we can fortify some additional tools such as clang-format and clang-tidy to our heart's content, but these are still for all practical purposes 'MinGW xXX' environments, meaning that there will again be far less unique code generation required by that point. Setting some extra paths, flags, maybe wrapping some commands... he says :)

Again the most critical aspect of the concept requirements is already proven to be working, which is having CMake invocation running inside the requested subsystem, no matter where we call it from, just supplying the buildsystem file. I believe that this is greatly aided by one concept present throughout the current implementation; that is, *all* file location lookup routines are designed to work backwards from the file in question - we *never* assume a root drive such as 'C:/' (because MinGW shells prefer '/c/'), we never call for '$ENV{HOMEDRIVE}' because the portability of this is questionable. Instead, your Msys installation, and each subsystem, is located by CMake by going backwards from the current file, until it finds '\<someDriveLetter\>/msys64/\<MSYSTEM\>.ini', as per the default Msys installtion routine. Without this behaviour definition, CMake, and particularly some of the third-party IDE integration tools, have wierd and nasty habits of doing things like creating new directories with names like 'c&#9633;' in multiple places, even outside of the specified build path! Further on, some file look-ups tend to fail due to conflicting interpratations of the 'home drive path' string between Unix and Win styles. The CMake run simply failing and quitting would be one thing, but some of this encountered behaviour is potentially hazardous to the host system, and really needed the addressing.

As long as your Msys installation is in the recommended/default location, where those '.ini' files are just one directory away from any root drive directory, the various subsystems all seem to pick up their corresponding underlying CMake/Ninja/Make tools and allow for some amount of portability while simultaenously safeguarding from the above-highlighted nasties. But again, the implmentation of such is only present in the MSYS2 buildsystem file and MINGW64 toolchain file for the time being. The rest will surely come; meanwhile, the design pattern is becoming more and more clear.

Deep breath, please stay tuned!

## Development

The main files at the core of the project are:

* 'scripts/buildsystems/MSYS2.cmake'

* 'scripts/toolchains/MINGW64.cmake'

It should be noted that the first file, the 'buildsystem' file, actually contains and 'include()' directive for the second file - the 'toolchain' file, where the sub-system's toolchain is specified. This inclusion happens as a result of comparing the '\<MSYSTEM\>' variable against their usual shell names. However, as mentioned several times, this is currently hardcoded for MinGW x64 until that single example is passing with full marks. Thus, the MinGW x64 toolchain file is where the working development is happening.

It is well worth noting that both files are pretty much direct clones of corresponding files found in <a href="https://github.com/microsoft/vcpkg.git">microsoft's excellent vcpkg package manager</a>.

While these have currently been overwritten for project development purposes, the intention is to fall back to the files supplied by a conventional vcpkg installation, probably just supplemented with a few additional CMake scripts. There is a clear attempt here at unifying much of the processes between vcpkg and CMake under the name of msys, but aside from clearly having no affiliation with any said parties, this purely a development stage artefact exposed in the hope of providing better insight into project status, providing a more successful experience for any passers-by, and hopefully providing more opportunity for understanding that which I've no time to document here in this development journal, realistically speaking. The eventual project on conclusion will more or less "just work" without so much borrowed code ;)

In practice, I'm trying to define multiple 'sets' of CMake variables, each 'set' given the prefix of "${MSYSTEM}_". This allows, for example, that we might have access to, and control over, multiple different sub-systems at the same time, without naming clashes.

For example, if looking for a C++ compiler, we'd usually find that CMake has set the following variable in the Cache file:

```
CMAKE_CXX_COMPILER=c++.exe
```

Which is great, but when we have up to 6 (woe!) toolchains - and that's only the ones in an Msys64 installation, you might have more on your system of course - the string 'c++.exe' doesn't actually give us much indication as to what compiler is running, under the hood. CMake does provide some verbiage to this effect while running, but it might be much better if we could utilize everything that the amazing team behind Msys64 already did in their configuration scripts, something more like (and here's some more vcpkg inspiration...):

```
${MSYSTEM}_CXX_COMPILER="${MSYSTEM_ROOT_DIR}/${MSYSTEM_PACKAGE_PREFIX}-c++.exe"
```

Which, for an ```"MSYSTEM" == "MINGW64"```, would resolve to:

```
MINGW64_CXX_COMPILER="C:/msys64/mingw64/mingw-w64-x86_64-c++.exe"
```

Or, for an ```"MSYSTEM" == "CLANGARM64"```, would resolve to:

```
CLANGARM64_CXX_COMPILER="C:/msys64/clangarm64/mingw-w64-clang-aarch64-c++.exe"
```

It would then be easy (!) to wrap some logic like so:

```
set(MSYS_ROOT_DIR "$ENV{HomeDrive}/msys64")
set(MSYS_INC_DIR "${MSYS_ROOT_DIR}/include")
set(MSYS_BIN_DIR "${MSYS_ROOT_DIR}/bin")

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

Please be aware that a prefix of just "MSYS_" is referring to vars coming from the 'buildsystem' file, if loaded. The vars with prefix of "MSYS<u>2</u>_" refer to what you would usually get from Msys64 if entering the "MSYS2" subsystem. It's a close call, but I think it's ok!?

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

## Supported Subsystems

As of writing, I've hard-coded <b>'\<MSYSTEM\>'</b> to be set to the <b>'\<MINGW64\>'</b> environment/toolchain, to narrow down a single working environment before copying the successful design pattern over to enable the remaining environments. It's a pretty simple fix away if you know CMake and would like to poke around with the differing <b>'\<MSYSTEM\>'</b>'s in it's current state. Make sure you 'pacman -S mingw-w64-x86_64-toolchain' as well as get the CMake/Ninja/etc packages for the default MSYS shell, for the best experience.

Eventually, we shall simply pass an <b>'\<MSYSTEM\>'</b> to easily pick up a config using familiar Msys64 commands, just like when invoking msys64 from a command line (example);

* <b>-DMSYSTEM</b>:STRING=<i>"CLANG64"</i>

Available <b>'\<MSYSTEM\>'</b> options...

* <b>'\<CLANGARM64\>'</b>
* <b>'\<CLANG64\>'</b>
* <b>'\<CLANG32\>'</b>
* <b>'\<MINGW64\>'</b>
* <b>'\<MINGW32\>'</b>
* <b>'\<UCRT64\>'</b>
* <b>'\<MSYS\>'</b>

## Dev latest

So it turns out that the adopted approach from vcpkg relies on falling back to settings found and defined in your actual CMake installation files (typically, the ones found in "cmake\<version\>"/share/Modules/Platform" and "cmake\<version\>"/share/Modules/Compiler"). In here, there are many default definitions covering GNU, Clang, MSYS (falling back to Cygwin, which is no good for any of the actual sub-systems), and various other buildsystem/toolchain variants. These are selected according to your project settings for vars such as "\<CMAKE_SYSTEM_NAME\>" and "\<CMAKE_\<LANG\>_COMPILER_ID\>", which get looked up in the CMake files "CMakeSystemSpecificInformation", and "CMake\<LANG\>Information", and are used to populate some strings that are used for file names for inclusion. In practice it's a pretty clever system, but unfortunately leaves it pretty clear why there is no fully-supported MSYS sub-system toolchain as such. We're faced with creating a couple of CMake modules to be imported into your project which define each new "Platform/\<CMAKE_SYSTEM\>" and "Compiler/\<CMAKE_\<LANG\>_COMPILER\>", *or* calling the expected defaults bringing all of the necessary over-rides into the sub-system toolchain files. There isn't too much in the way of either approach being successful; but it would be absolutely ideal to fallback to Kitware's files as much as possible, where design and testing will be far more thorough than that of a one-man independent project.Granted, somebody somewhere has thus far refrained from putting the pieces together to unlock all of the subsystems, and the further I get, the more I can see why. However, with this project so far running very successfully during dev, I fully intend to follow through, with a view to hooking back in to the native CMake process and curbing back on the independently-maintained over-rides, once this project is solid. Ideally even the vcpkg won't be overwritten come the end of the project; we'll just supplement the existing processes whereever/whenever needed.

I won't set up a dev branch, proper doc files, git flows, PR/issue templates or anything else until I mark the actual source code to be out of development, but please consider this repo very much public and the author more than happy to investigate any further findings, take questions, etc.

Thanks for reading!
