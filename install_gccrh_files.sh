#!/bin/bash

INSTALL_TARGET_PREFIX=`realpath "${1}"`
PATH_TO_ZIP=`realpath "$2"`

cd $INSTALL_TARGET_PREFIX/msp430-elf
unzip -u $PATH_TO_ZIP
# Header files should be inside include/, but also a boatload of directories containing the linker scripts; they need
# to be combined and stored into lib/<part#>.ld.

cd include
echo "Generating ldscripts-"
for i in $(find . -maxdepth 1 -name 'msp430*' -type d | sed -e 's/^\.\///') $(find . -maxdepth 1 -name 'cc430*' -type d | sed -e 's/^\.\///') ; do
        echo "Processing $i..."
        cat ${i}/memory.ld ${i}/peripherals.ld > ../lib/ldscripts/${i}.ld
        rm -f ${i}/*.ld
        rmdir ${i}
done
