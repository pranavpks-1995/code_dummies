 # pkgIndex.tcl -- tells Tcl how to load my package.
 package ifneeded "BSDebug" 1.0 \
    [list load [file join $dir libbsdebug.so]]
