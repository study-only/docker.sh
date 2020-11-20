#!/bin/bash

hostname $CONTAINER

mkdir -p /sys/fs/cgroup/memory/$CONTAINER
echo $$ > /sys/fs/cgroup/memory/$CONTAINER/cgroup.procs
echo $MEMORY > /sys/fs/cgroup/memory/$CONTAINER/memory.limit_in_bytes

mkdir -p $CONTAINER/rwlayer
mount -t aufs -o dirs=$CONTAINER/rwlayer:./images/$IMAGE none $CONTAINER

mkdir -p $CONTAINER/old_root
cd $CONTAINER
pivot_root . ./old_root

mount -t proc proc /proc
umount -l /old_root

exec $PROGRAM