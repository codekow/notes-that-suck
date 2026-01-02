#!/bin/sh

NAND_FILE=${1:-nand0}

which dd || exit 0
[ -e "${NAND_FILE}" ] || exit 0

<<NOTES
Device      Start    End Sectors   Size Type
nand0p1    147456 463837  316382 154.5M Microsoft basic data
nand0p2      1024   2047    1024   512K Microsoft basic data
nand0p3      2048  10239    8192     4M Microsoft basic data
nand0p4     10240  71679   61440    30M Microsoft basic data
nand0p5     71680  79871    8192     4M Microsoft basic data
nand0p6     79872 141311   61440    30M Microsoft basic data
nand0p7    141312 142335    1024   512K Microsoft basic data
nand0p8    142336 146431    4096     2M Microsoft basic data
nand0p9    146432 147455    1024   512K Microsoft basic data
NOTES

((i++))

SKIP=147456
COUNT=316382
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=1024
COUNT=1024
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=2048
COUNT=8192
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=10240
COUNT=61440
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=71680
COUNT=8192
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=79872
COUNT=61440
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=141312
COUNT=1024
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=142336
COUNT=4096
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

SKIP=146432
COUNT=1024
dd bs=512 if="${NAND_FILE}" of=nand0p$((i++)) skip="${SKIP}" count="${COUNT}"

md5sum nand0* > nand.md5sum
