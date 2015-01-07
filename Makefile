#-
# ==========================================================================
# Copyright (c) 2011 Autodesk, Inc.
# All rights reserved.
# 
# These coded instructions, statements, and computer programs contain
# unpublished proprietary information written by Autodesk, Inc., and are
# protected by Federal copyright law. They may not be disclosed to third
# parties or copied or duplicated in any form, in whole or in part, without
# the prior written consent of Autodesk, Inc.
# ==========================================================================
#+

ifndef INCL_BUILDRULES

#
# Include platform specific build settings
#
#TOP := .
include buildrules


#
# Always build the local plug-in when make is invoked from the
# directory.
#
all : plugins

endif

#
# Variable definitions
#

SRCDIR := .
DSTDIR := .

stretchmesh_SOURCES  := curveColliderLocator.cpp stretchMeshCmd.cpp pluginMain.cpp stretchMeshDeformer.cpp
stretchmesh_OBJECTS  := curveColliderLocator.o stretchMeshCmd.o pluginMain.o stretchMeshDeformer.o
stretchmesh_PLUGIN   := $(DSTDIR)/stretchmesh.$(EXT)
stretchmesh_MAKEFILE := $(DSTDIR)/Makefile

#
# Include the optional per-plugin Makefile.inc
#
#    The file can contain macro definitions such as:
#       {pluginName}_EXTRA_CFLAGS
#       {pluginName}_EXTRA_C++FLAGS
#       {pluginName}_EXTRA_INCLUDES
#       {pluginName}_EXTRA_LIBS

-include $(SRCDIR)/Makefile.inc


#
# Set target specific flags.
#

$(stretchmesh_OBJECTS): CFLAGS   := $(CFLAGS)   $(stretchmesh_EXTRA_CFLAGS)
$(stretchmesh_OBJECTS): C++FLAGS := $(C++FLAGS) $(stretchmesh_EXTRA_C++FLAGS)  -DNDEBUG -msse3
$(stretchmesh_OBJECTS): INCLUDES := $(INCLUDES) $(stretchmesh_EXTRA_INCLUDES) -I../nlib

depend_stretchmesh:     INCLUDES := $(INCLUDES) $(stretchmesh_EXTRA_INCLUDES)

$(stretchmesh_PLUGIN):  LFLAGS   := $(LFLAGS) $(stretchmesh_EXTRA_LFLAGS)
$(stretchmesh_PLUGIN):  LIBS     := $(LIBS) -lOpenMaya -lOpenMayaAnim -lOpenMayaUI -lFoundation -lOpenMayaRender -L/usr/lib64  -LGL -LGLU

#
# Rules definitions
#

.PHONY: depend_stretchmesh clean_stretchmesh Clean_stretchmesh


$(stretchmesh_PLUGIN): $(stretchmesh_OBJECTS)
	-rm -f $@
	$(LD) -o $@ $(LFLAGS) $^ $(LIBS)

depend_stretchmesh :
	makedepend $(INCLUDES) $(MDFLAGS) -f$(DSTDIR)/Makefile $(stretchmesh_SOURCES)

clean_stretchmesh:
	-rm -f $(stretchmesh_OBJECTS)

Clean_stretchmesh:
	-rm -f $(stretchmesh_MAKEFILE).bak $(stretchmesh_OBJECTS) $(stretchmesh_PLUGIN)

plugins: $(stretchmesh_PLUGIN)
depend:	 depend_stretchmesh
clean:	 clean_stretchmesh
Clean:	 Clean_stretchmesh