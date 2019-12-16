#!/bin/bash

if [[ $EUID != 0 ]] ; then
  echo This must be run as root!
  exit 1
fi

for xhci in /sys/bus/pci/drivers/?hci-pci ; do
  if ! cd $xhci ; then
    echo Weird error. Failed to change directory to $xhci
    exit 1
  fi

  echo Resetting devices from $xhci...

  for i in ????:??:??.? ; do
    if [ $i == "????:??:??.?" ]; then
      echo "ignoring"
      continue
    fi
    echo "Device $xhci:$i"
    echo -n "$i" > unbind
    echo -n "$i" > bind
  done
done
