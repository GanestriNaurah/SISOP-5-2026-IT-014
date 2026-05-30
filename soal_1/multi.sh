#!bin/bash

set -e

ROOTFS=rootfs_multi
BUSYBOX_VERSION=1.36.1
BUSYBOX_TAR=busybox-${BUSYBOX_VERSION}.tar.bz2
BUSYBOX_TAR=busybox-${BUSYBOX_VERSION}

rm -rf ${ROOFTS}
mkdir -p ${ROOFTS}

mkdir -p ${ROOFTS}/{bin,sbin,etc,proc,sys,dev,tmp,root,usr/bin,usr/sbin,home}

mkdir -p ${ROOTFS}/home/{henn,hann,viii,kids}

chmod 1777 ${ROOFTS}/tmp

if [ ! -f ${BUSYBOX_TAR} ]; then
   wget https://busybox.net/downloads/${BUSYBOX_TAR}
fi

if [ ! -d ${BUSYBOX_DIR} ]; then
   tar -xf ${BUSYBOX_TAR}
fi

cd ${BUSYBOX_DIR}
make defconfig
sed -i 's/# CONFIG_STATIC is not set/CONFIG_STATIC=y/' .conf
make -j$(nproc)
make CONFIG_PREFIX=../${ROOTFS} install
cd ..

cat > ${ROOTFS}/etc/passwd << EOF
root:x:0:0:root:/root:/bin/sh
henn:x:1000:1000:henn:/home/henn:/bin/sh
hann:x:1001:1001:hann:/home/hann:/bin/sh
viii:x:1002:1002:viii:/home/viii:/bin/sh
kids:x:1003:1003:kids:/home/kids:/bin/sh
EOF

cat > ${ROOTFS}/init << 'EOF'
#!/bin/sh

mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t devtmpfs devstmpfs /dev

echo ""
echo "=========================="
echo "      Farewell Party"
echo "=========================="
echo "Welcome, multi-user"
echo ""

exec /bin/sh
EOF

chmod +x ${ROOTFS}/init

chmod 700 ${ROOTFS}/root
chmod 755 ${ROOTFS}/home/henn
chmod 750 ${ROOTFS}/home/hann
chmod 750 ${ROOTFS}/home/vii
chmod 700 ${ROOTFS}/home/kids

cd ${ROOTFS}
find . ! cpio -o -H newc | gzip > ../osboot/multi.gz
cd ..

rm -rf ${ROOTFS}

echo "Multi filesystem berhasil dibuat"
