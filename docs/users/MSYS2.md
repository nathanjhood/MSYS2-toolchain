
#########################################################################
# TOOLCHAIN ACQUISITION
#########################################################################

MSYSTEM = MSYS
MSYSTEM_PREFIX = /usr
MSYSTEM_CARCH = x86_64
MSYSTEM_CHOST = x86_64-pc-msys

CARCH = x86_64
CHOST = x86_64-pc-msys

#-- Debugging flags
DEBUG_CFLAGS= -ggdb -Og
DEBUG_CXXFLAGS= -ggdb -Og

CHECKOUT,v = +$(if $(wildcard $@),,$(CO) $(COFLAGS) $< $@)
COMPILE.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.C = $(COMPILE.cc)
COMPILE.cpp = $(COMPILE.cc)
COMPILE.def = $(M2C) $(M2FLAGS) $(DEFFLAGS) $(TARGET_ARCH)
COMPILE.f = $(FC) $(FFLAGS) $(TARGET_ARCH) -c
COMPILE.F = $(FC) $(FFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.m = $(OBJC) $(OBJCFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.mod = $(M2C) $(M2FLAGS) $(MODFLAGS) $(TARGET_ARCH)
COMPILE.p = $(PC) $(PFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c
COMPILE.r = $(FC) $(FFLAGS) $(RFLAGS) $(TARGET_ARCH) -c
COMPILE.s = $(AS) $(ASFLAGS) $(TARGET_MACH)
COMPILE.S = $(CC) $(ASFLAGS) $(CPPFLAGS) $(TARGET_MACH) -c
LINK.c = $(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.cc = $(CXX) $(CXXFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.cpp = $(LINK.cc)
LINK.r = $(FC) $(FFLAGS) $(RFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINT.c = $(LINT) $(LINTFLAGS) $(CPPFLAGS) $(TARGET_ARCH)

LINK.C = $(LINK.cc)
LINK.f = $(FC) $(FFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.F = $(FC) $(FFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.m = $(OBJC) $(OBJCFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.o = $(CC) $(LDFLAGS) $(TARGET_ARCH)
LINK.p = $(PC) $(PFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH)
LINK.s = $(CC) $(ASFLAGS) $(LDFLAGS) $(TARGET_MACH)
LINK.S = $(CC) $(ASFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_MACH)


.DEFAULT =
.DEFAULT_GOAL := cmake_force
.DELETE_ON_ERROR =
.FEATURES := target-specific order-only second-expansion else-if shortest-stem undefine oneshell nocomment grouped-target extra-prereqs notintermediate shell-export archives jobserver output-sync check-symlink load dospaths
.INCLUDE_DIRS := /usr/include
.LIBPATTERNS = lib%.dll.a %.dll.a lib%.a %.lib lib%.dll %.dll
.LOADED :=
.RECIPEPREFIX :=
.SHELLFLAGS := -c
.SILENT =
.SUFFIXES =
.PHONY = cmake_force configuration CMakeFiles/configuration.dir/build CMakeFiles/configuration.dir/clean CMakeFiles/configuration.dir/depend
.VARIABLES :=

MAKE_HOST := x86_64-pc-msys
MAKEINFO = makeinfo
GNUMAKEFLAGS :=

MAKE_COMMAND := make
CMAKE_COMMAND = /usr/bin/cmake.exe
OUTPUT_OPTION = -o $@

# environment
CONFIG_SITE = /etc/config.site
CONICON = msys2.ico
CONTITLE = MSYS2 MSYS
MANPATH = /usr/share/man:/usr/man:/usr/local/man:/usr/share/man:/usr/man:/share/man
PKG_CONFIG_PATH = /usr/lib/pkgconfig:/usr/share/pkgconfig:/lib/pkgconfig
TMP = /tmp

SUFFIXES := .out .a .ln .o .c .cc .C .cpp .p .f .F .m .r .y .l .ym .yl .s .S .mod .sym .def .h .info .dvi .tex .texinfo .texi .txinfo .w .ch .web .sh .elc .el

+D = $(patsubst %/,%,$(dir $+))
*D = $(patsubst %/,%,$(dir $*))
@D = $(patsubst %/,%,$(dir $@))
%D = $(patsubst %/,%,$(dir $%))
^D = $(patsubst %/,%,$(dir $^))
<D = $(patsubst %/,%,$(dir $<))
?D = $(patsubst %/,%,$(dir $?))

+F = $(notdir $+)
*F = $(notdir $*)
@F = $(notdir $@)
%F = $(notdir $%)
^F = $(notdir $^)
<F = $(notdir $<)
?F = $(notdir $?)

# RCS: could not be stat'd.
# SCCS: could not be stat'd.
# %: %,v
# %: RCS/%
# %: RCS/%,v
# %: SCCS/s.%
# %: s.%

(%) = % && $(AR) $(ARFLAGS) $@ $<
%.c = %.w %.ch && $(CTANGLE) $^ $@
%.hpux_make_needs_suffix_list =
%.out = % && @rm -f $@ \ cp $< $@
%.tex = %.w %.ch && $(CWEAVE) $^ $@

# Link...
.a =
.c = $(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@
.C = $(LINK.C) $^ $(LOADLIBES) $(LDLIBS) -o $@
.cc = $(LINK.cc) $^ $(LOADLIBES) $(LDLIBS) -o $@
.cpp = $(LINK.cpp) $^ $(LOADLIBES) $(LDLIBS) -o $@
.f = $(LINK.f) $^ $(LOADLIBES) $(LDLIBS) -o $@
.F = $(LINK.F) $^ $(LOADLIBES) $(LDLIBS) -o $@
.h =
.l =
.m = $(LINK.m) $^ $(LOADLIBES) $(LDLIBS) -o $@
.o = $(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@
.p = $(LINK.p) $^ $(LOADLIBES) $(LDLIBS) -o $@
.r = $(LINK.r) $^ $(LOADLIBES) $(LDLIBS) -o $@
.s = $(LINK.s) $^ $(LOADLIBES) $(LDLIBS) -o $@
.S = $(LINK.S) $^ $(LOADLIBES) $(LDLIBS) -o $@
.w =
.y =


# Compile...
.c.o = $(COMPILE.c) $(OUTPUT_OPTION) $<
.C.o = $(COMPILE.C) $(OUTPUT_OPTION) $<
.cc.o = $(COMPILE.cc) $(OUTPUT_OPTION) $<
.cpp.o = $(COMPILE.cpp) $(OUTPUT_OPTION) $<
.f.o = $(COMPILE.f) $(OUTPUT_OPTION) $<
.F.o = $(COMPILE.F) $(OUTPUT_OPTION) $<
.m.o = $(COMPILE.m) $(OUTPUT_OPTION) $<
.mod = $(COMPILE.mod) -o $@ -e $@ $^
.mod.o = $(COMPILE.mod) -o $@ $<
.p.o = $(COMPILE.p) $(OUTPUT_OPTION) $<
.r.o = $(COMPILE.r) $(OUTPUT_OPTION) $<
.s.o = $(COMPILE.s) -o $@ $<
.S.o = $(COMPILE.S) -o $@ $<

.ch =
.el =
.ln =
.sh = cat $< >$@ \ chmod a+x $@
.yl =
.ym =

.def =
.def.sym = $(COMPILE.def) -o $@ $<
.dvi =
.elc =
.sym =
.out =
.web =

.info =

MFLAGS = -ps
MAKEFLAGS = ps
MAKELEVEL := 2
MAKESILENT = -s


# <AR>
AR = ar
ARFLAGS = -rv

# <AS>
AS = as

# <CC>
CC = gcc
CFLAGS = -march=nocona -msahf -mtune=generic -O2 -pipe

# <CO>
CO = co
COFLAGS =

# <CPP>
CPP = $(CC) -E

# <CXX>
CXXFLAGS= -march=nocona -msahf -mtune=generic -O2 -pipe

# <CTANGLE>
CTANGLE = ctangle
.w.c = $(CTANGLE) $< - $@

# <CWEAVE>
CWEAVE = cweave
.w.tex = $(CWEAVE) $< - $@

# <CXX>
CXX = g++

# <EQUALS>
EQUALS = =

# <FC>
FC = f77

# <F77>
F77 = $(FC)
F77FLAGS = $(FFLAGS)

# <GET>
GET = get

# <HG>
HG = /usr/bin/hg

# <LD>
LD = ld
LDFLAGS= -pipe

# <LEX>
LEX = lex
LEX.l = $(LEX) $(LFLAGS) -t
LEX.m = $(LEX) $(LFLAGS) -t
.l.c = @$(RM) $@ \ $(LEX.l) $< > $@
.lm.m = @$(RM) $@ \ $(LEX.m) $< > $@
.l.r = $(LEX.l) $< > $@ \ mv -f lex.yy.r $@

# <LINT>
LINT = lint
.c.ln = $(LINT.c) -C$* $<
.l.ln = @$(RM) $*.c \ $(LEX.l) $< > $*.c $(LINT.c) -i $*.c -o $@ \ $(RM) $*.c
.y.ln = $(YACC.y) $< \ $(LINT.c) -C$* y.tab.c \ $(RM) y.tab.c

# <M2C>
M2C = m2c

# <MAKE>
MAKE = $(MAKE_COMMAND)

# <OBJC>
OBJC = cc

# <PC>
PC = pc

# <PREPROCESS>
PREPROCESS.r = $(FC) $(FFLAGS) $(RFLAGS) $(TARGET_ARCH) -F
PREPROCESS.F = $(FC) $(FFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -F
PREPROCESS.S = $(CPP) $(CPPFLAGS)
.S.s = $(PREPROCESS.S) $< > $@
.F.f = $(PREPROCESS.F) $(OUTPUT_OPTION) $<
.r.f = $(PREPROCESS.r) $(OUTPUT_OPTION) $<

# <RM>
RM = /usr/bin/cmake.exe -E rm -f

# <TANGLE>
TANGLE = tangle
.web.p = $(TANGLE) $<

# <TEX>
TEX = tex
.tex =
.tex.dvi = $(TEX) $<

# <TEXI>
.texi =
.texi.dvi = $(TEXI2DVI) $(TEXI2DVI_FLAGS) $<
.texi.info = $(MAKEINFO) $(MAKEINFO_FLAGS) $< -o $@

# <TEXI2DVI>
TEXI2DVI = texi2dvi

# <TEXINFO>
.texinfo =
.texinfo.dvi = $(TEXI2DVI) $(TEXI2DVI_FLAGS) $<
.texinfo.info = $(MAKEINFO) $(MAKEINFO_FLAGS) $< \ -o $@

# <TXINFO>
.txinfo =
.txinfo.dvi = $(TEXI2DVI) $(TEXI2DVI_FLAGS) $<
.txinfo.info = $(MAKEINFO) $(MAKEINFO_FLAGS) $< -o $@

# <WEAVE>
WEAVE = weave
.web.tex = $(WEAVE) $<

# <YACC>
YACC = yacc
YACC.m = $(YACC) $(YFLAGS)
YACC.y = $(YACC) $(YFLAGS)
.y.c = $(YACC.y) $< \ mv -f y.tab.c $@
.ym.m = $(YACC.m) $< \ mv -f y.tab.c $@
