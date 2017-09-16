#!/bin/bash
set -e

PATH="/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin"
TODAY=`date +"%F-%s"`

#### Change these variables ###
NUMBACKUPS=3
VMS=(     "orbit"            "red-dwarf"        "elektra"                 "lisa"          )
DISK=(    "sda"              "vda"              "sda"                     "sda"           )
DISKNAME=("orbit-disk1.raw"  "red-dwarf.qcow2"  "elektra-disk1.raw"       "lisa-disk1.raw")

BACKUPDIR="/data/vm-backups"
VMDISKDIR="/vm"
XMLDIR="/etc/libvirt/qemu"


### Program start ###
SCRIPTDIR=`pwd`


if [ ! -e ${SCRIPTDIR}/rotate.txt ]; then
    echo 1 > ${SCRIPTDIR}/rotate.txt
fi

ROTATE=`cat ${SCRIPTDIR}/rotate.txt`

if [ $ROTATE -gt $NUMBACKUPS ]; then
    ROTATE=1
fi

for (( i = 0; i < ${#VMS[@]}; i++ ))
    do virsh snapshot-create-as --domain ${VMS[i]} --diskspec ${DISK[i]},file=${BACKUPDIR}/${VMS[i]}-snapshot.qcow2 --disk-only --atomic --no-metadata
    sleep 5
    rm -rf ${BACKUPDIR}/backup${ROTATE}-*-${DISKNAME[i]} 
    cp ${VMDISKDIR}/${DISKNAME[i]} ${BACKUPDIR}/backup${ROTATE}-${TODAY}-${DISKNAME[i]}
    virsh blockcommit ${VMS[i]} ${DISK[i]} --active --verbose --pivot
    sleep 5
    rm ${BACKUPDIR}/${VMS[i]}-snapshot.qcow2
    rm -rf ${BACKUPDIR}/backup${ROTATE}-*-${VMS[i]}.xml
    cp ${XMLDIR}/${VMS[i]}.xml ${BACKUPDIR}/backup${ROTATE}-${TODAY}-${VMS[i]}.xml
done

ROTATE=`echo "$ROTATE + 1" | bc`
echo $ROTATE > ${SCRIPTDIR}/rotate.txt

