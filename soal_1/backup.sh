#!/bin/bash

TIMESTAMP=$(date +"%d%m%Y-%H%M%S")
BACKUP_NAME="farewell_backup_${TIMESTAMP}.zip"

zip ${BACKUP_NAME} \
    osboot/bzImage \
    osboot/single.gz \
    osboot/multi.gz \
    osboot/farewell.iso

mv ${BACKUP_NAME} osboot/

rm -f osboot/bzImage
rm -f osboot/single.gz
rm -f osboot/multi.gz
rm -f osboot/farewell.iso

   echo "Backup selesai"

