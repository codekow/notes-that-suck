#!/bin/bash
# script to set flags for buildscripts
# This file is only relevant for people that want to rebuild firmwares by themselves. Make sure that you use the correct script

echo "deadbeef" > jobid
touch sn
touch p2009
touch devicetype
echo "dreame.vacuum.p2009" > devicetype
touch devicetypealias
echo "dreame_p2009" > devicetypealias
touch authorized_keys_id
echo ",,,,," > authorized_keys_id
touch anonymous
echo "deadbeef" > anonymous
touch diff
touch tools
touch patch_dns
touch installer
