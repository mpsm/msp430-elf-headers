#!/bin/bash -x

# check arguments
if [ ! -d "${1}" -o ! -f "${2}" ]; then
	echo "Usage: $0 <install target prefix> <path to gccrh zip file>"
	echo "Example: $0 /opt/toolchains/msp430-elf GCC_RH_20140508.zip"
	exit 1
fi

INSTALL_TARGET_PREFIX=`realpath "${1}"`
PATH_TO_ZIP=`realpath "$2"`
UNPACK_TMPDIR=`mktemp -d`

# generate directory structure if needed
if [ ! -d "${INSTALL_TARGET_PREFIX}/msp430-elf" ]; then
	echo "Creating directory structure"
	mkdir -p ${INSTALL_TARGET_PREFIX}/msp430-elf/{include,lib/ldscripts}
fi

unzip -q "${PATH_TO_ZIP}" -d ${UNPACK_TMPDIR}

# Header files should be inside include/, but also a boatload of directories containing the linker scripts; they need
# to be combined and stored into lib/<part#>.ld.

cd ${UNPACK_TMPDIR}/include
echo "Generating ldscripts-"
for i in $(find . -maxdepth 1 \( -name 'msp430*' -o -name 'cc430*' \) -type d | sed -e 's/^\.\///') ; do
        echo "Processing $i..."
        cat ${i}/memory.ld ${i}/peripherals.ld > ${INSTALL_TARGET_PREFIX}/msp430-elf/lib/${i}.ld
done

# install headers
cp *.h ${INSTALL_TARGET_PREFIX}/msp430-elf/include
find . -name "*.ld" | xargs -I "{}" cp "{}" ${INSTALL_TARGET_PREFIX}/msp430-elf/lib/

rm -rf ${UNPACK_TMPDIR}
