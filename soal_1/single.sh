#!/bin/bash

set -e

ROOTFS=rootfs_single
BUSYBOX_VERSION=1.36.1
BUSYBOX_TAR=busybox-${BUSYBOX_VERSION}.tar.bz2
BUSYBOX_DIR=busybox-${BUSYBOX_VERSION}

rm -rf ${ROOTFS}
mkdir -p ${ROOTFS}

mkdir -p ${ROOTFS}/{bin,sbin,etc,proc,sys,dev,tmp,root,usr/bin,usr/sbin}

chmod 1777 ${ROOTFS}/tmp

if [ ! -f ${BUSYBOX_TAR} ]; then
   wget https://busybox.net/downloads/${BUSYBOX_TAR}
fi

if [ ! -d ${BUSYBOX_DIR} ]; then
   tar -xf ${BUSYBOX_TAR}
fi

cd ${BUSYBOX_DIR}
make defconfig
yes "" | make oldconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .config
make -j$(nproc)
make CONFIG_PREFIX=../${ROOTFS} install
cd ..

cat > ${ROOTFS}/init << 'EOF'
#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devtmpfs /dev

echo ""
echo "======================="
echo "     Farewell Party    "
echo "======================="
echo "Welcome, root"
echo ""

exec /bin/sh
EOF

chmod +x ${ROOTFS}/init

cd ${ROOTFS}
find . | cpio -o -H newc | gzip > ../osboot/single.gz
cd ..

rm -rf ${ROOTFS}

echo "Single filesystem berhasil dibuat"
