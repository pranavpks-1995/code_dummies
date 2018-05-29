# Copyright Bluespec Inc. 2009-2010

# pkgIndex.tcl -- tells Tcl how to load my package.
# This file must be in the directory with the library
# The directory must be in auto_path e.g. lappend auto_path <path>
package ifneeded "BSDebug" 1.0 \
    [list load [file join $dir libbsdebug.so]]
