#!/bin/bash

set -e

ROOTFS=rootfs_multi
BUSYBOX_VERSION=1.36.1
BUSYBOX_TAR=busybox-${BUSYBOX_VERSION}.tar.bz2
BUSYBOX_DIR=busybox-${BUSYBOX_VERSION}

rm -rf ${ROOTFS}
mkdir -p ${ROOTFS}

mkdir -p ${ROOTFS}/{bin,sbin,etc,proc,sys,dev,tmp,root,usr/bin,usr/sbin}
mkdir -p ${ROOTFS}/home/{henn,hann,viii,kids}

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

# Matikan TC karena error di Ubuntu/WSL baru
sed -i 's/CONFIG_TC=y/# CONFIG_TC is not set/' .config

make -j1

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
mount -t devtmpfs devtmpfs /dev

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
chmod 750 ${ROOTFS}/home/viii
chmod 700 ${ROOTFS}/home/kids

mkdir -p osboot

cd ${ROOTFS}

find . | cpio -o -H newc | gzip > ../osboot/multi.gz

cd ..

echo "Multi filesystem berhasil dibuat"
