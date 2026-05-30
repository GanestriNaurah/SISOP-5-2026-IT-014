#!/bin/bash

set -e

KERNEL_VERSION=6.1.1
KERNEL_TAR=linux-${KERNEL_VERSION}.tar.xz
KERNEL_DIR=linux-${KERNEL_VERSION}

mkdir -p osboot

if [ ! -f "KERNEL_TAR" ]; then
   wget https://cdn.kernel.org/pub/linux/kernel/v6.x/${KERNEL_TAR}
fi

if [ ! -d "KERNEL_DIR" ]; then
   tar -xf ${KERNEL_TAR}
fi

cd ${KERNEL_DIR}

cp ../.config .config || true

make defconfig

make -j$(nproc)

cp arch/x86/boot/bzImage ../osboot/bzImage

cd ..

echo "Kernel berhasil di-build"
