#!/bin/bash

PREFIX=AcornCmosBasic
TITLE="Cmos Basic"
MAKE=MakeBAS

# This script depends on the following:
#     mac2unix     (from package dos2unix)
#     AcornFsUtils (https://github.com/SteveFosdick/AcornFsUtils)

## Below this point should be common for all the distributions

for SUFFIX in dat adl
do

    rm -rf tmp
    mkdir -p tmp

    # Start with blank/template disk image
    IMAGE=${PREFIX}.${SUFFIX}

    cp BlankDisk.${SUFFIX} ${IMAGE}

    # Create a !boot file
    echo "*LIB LIBRARY"  >  tmp/\!BOOT
    echo "*EXEC ${MAKE}" >> tmp/\!BOOT

    # Copy sources
    cp ../src/* tmp
    cp ${MAKE} tmp

    # Convert line endings
    unix2mac -q tmp/*

    # Add everyting so far to disk image
    afscp tmp/* ${IMAGE}:

    # Copy Tools
    for name in TurMasm Masm IoMasm Edit
    do
        cp ../tools/${name}     tmp
        cp ../tools/${name}.inf tmp
        afscp tmp/${name} ${IMAGE}:Library
    done

    # Set a title
    afstitle ${IMAGE} "${TITLE}"

    # Show the resultant directory
    echo
    echo ${IMAGE}
    echo
    afstree ${IMAGE}

done
