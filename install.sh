#!/bin/sh

TOOLCHAIN=$(which msp430-elf-gcc | sed 's/\/bin\/msp430-elf-gcc//')
LIB=${TOOLCHAIN}/msp430-elf/lib
INC=${TOOLCHAIN}/msp430-elf/include
find headers -name "*.h" | xargs -t -I "{}" cp "{}" ${INC}
find headers -name "*.ld" | xargs -t -I "{}" cp "{}" ${LIB}
