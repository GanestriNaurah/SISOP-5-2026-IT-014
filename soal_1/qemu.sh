#!/bin/bash

case "$1" in
    --single)
	qemu-system-x86_64 \
	-kernel osboot/bzImage \
	-initrd osboot/single.gz \
	-nographic
	;;

   --multi)
	qemu-system-x86_64 \
	-kernel osboot/bzImage \
	-initrd osboot/multi.gz \
	--nographic
	;;

   --all)
	qemu-system-x86_64 \
	-cdrom osboot/farewell.iso
	;;

   *)
	echo "Usage:"
	echo "./qemu.sh --single"
	echo "./qemu.sh --multi"
	echo "./qemu.sh --all"
esac
