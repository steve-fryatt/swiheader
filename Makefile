# Copyright 2020, Stephen Fryatt (info@stevefryatt.org.uk)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#
# See the License for the specific language governing permissions and
# limitations under the License.

# This file really needs to be run by GNUMake.
# It is intended for native compilation on Linux (for use in a GCCSDK
# environment) or cross-compilation under the GCCSDK.

.PHONY: all program clean documentation release install


# The build date.

BUILD_DATE := $(shell date "+%d %b %Y")
HELP_DATE := $(shell date "+%-d %B %Y")

# Construct version or revision information.

ifeq ($(VERSION),)
  RELEASE := $(shell git describe --always)
  VERSION := $(RELEASE)
  HELP_VERSION := ----
else
  RELEASE := $(subst .,,$(VERSION))
  HELP_VERSION := $(VERSION)
endif

$(info Building with version $(VERSION) ($(RELEASE)) on date $(BUILD_DATE))

# The archive to assemble the release files in.  If $(RELEASE) is set, then the file can be given
# a standard version number suffix.

ZIPFILE := swiheaders$(RELEASE).zip
SRCZIPFILE := swiheaders$(RELEASE)src.zip
BUZIPFILE := swiheaders$(shell date "+%Y%m%d").zip


# Set up the various build directories.

SRCDIR := src
MANUAL := manual
OUTDIR := build

# Set up the named target files.

README := ReadMe,fff
LICENCE := Licence,fff
SRCS := MakeHeader.bbt
RUNIMAGE := MakeHeader,ffb

# Set up the source files.

MANSRC := Source
MANSPR := ManSprite
LICSRC := Licence
SWINAMES := AsmSWINames

# Includes and libraries.

SWIDEFS := -swis $(GCCSDK_INSTALL_CROSSBIN)/../arm-unknown-riscos/include/swis.h -swis $(GCCSDK_INSTALL_ENV)/include/TokenizeSWIs.h
LIBPATHS := BASIC:$(SFTOOLS_BASIC)/

# Build Tools

MKDIR := mkdir -p
RM := rm -rf
CP := cp

ZIP := $(GCCSDK_INSTALL_ENV)/bin/zip
INSTALL := $(GCCSDK_INSTALL_ENV)/ro-install

MANTOOLS := $(SFTOOLS_BIN)/mantools
BINDHELP := $(SFTOOLS_BIN)/bindhelp
TEXTMERGE := $(SFTOOLS_BIN)/textmerge
MENUGEN := $(SFTOOLS_BIN)/menugen
TOKENIZE := $(SFTOOLS_BIN)/tokenize

# Build Flags

ZIPFLAGS := -x "*/.svn/*" -r -, -9
SRCZIPFLAGS := -x "*/.svn/*" -r -9
BUZIPFLAGS := -x "*/.svn/*" -r -9
BINDHELPFLAGS := -f -r -v
MENUGENFLAGS := -d
TOKFLAGS := -verbose -warn pV -crunch IT

# Build everything, but don't package it for release.

all: program documentation

# Build the libraries

program: $(OUTDIR)/$(RUNIMAGE)

SRCS := $(addprefix $(SRCDIR)/, $(SRCS))

$(OUTDIR)/$(RUNIMAGE): $(OUTDIR) $(SRCS)
	$(TOKENIZE) $(TOKFLAGS) $(firstword $(SRCS)) -link -out $(OUTDIR)/$(RUNIMAGE) \
		$(SWIDEFS) -path $(LIBPATHS) -define 'OutputFilename$$=$(SWINAMES)'

# Create a folder to take the output.

$(OUTDIR):
	$(MKDIR) $(OUTDIR)

# Build the documentation

#documentation: $(OUTDIR)/$(README) $(OUTDIR)/$(LICENCE)

documentation: $(OUTDIR)/$(LICENCE)

#$(OUTDIR)/$(README): $(MANUAL)/$(MANSRC) $(OUTDIR)
#	$(MANTOOLS) -MTEXT -I$(MANUAL)/$(MANSRC) -O$(OUTDIR)/$(README) -D'version=$(HELP_VERSION)' -D'date=$(HELP_DATE)'

$(OUTDIR)/$(LICENCE): $(LICSRC) $(OUTDIR)
	$(CP) $(LICSRC) $(OUTDIR)/$(LICENCE)


# Build the release Zip file.

release: clean all
	$(RM) ../$(ZIPFILE)
	(cd $(OUTDIR) ; $(ZIP) $(ZIPFLAGS) ../../$(ZIPFILE) $(README) $(LICENCE) $(RUNIMAGE))
	$(RM) ../$(SRCZIPFILE)
	$(ZIP) $(SRCZIPFLAGS) ../$(SRCZIPFILE) $(SRCDIR) $(OUTDIR) $(MANUAL) Makefile


# Build a backup Zip file

backup:
	$(RM) ../$(BUZIPFILE)
	$(ZIP) $(BUZIPFLAGS) ../$(BUZIPFILE) *


# Install the finished version in the GCCSDK environment, ready for use.

install: clean all
	$(INSTALL) $(OUTDIR)/$(SWINAMES) $(GCCSDK_INSTALL_ENV)/include/$(SWINAMES)


# Clean targets

clean:
	$(RM) $(OUTDIR)/$(README)
	$(RM) $(OUTDIR)/$(LICENCE)
	$(RM) $(OUTDIR)/$(RUNIMAGE)
