#!/bin/sh

curl https://raw.githubusercontent.com/tinalinux/repo/stable/repo > repo
chmod +x repo
export PATH=$(pwd):$PATH

mkdir tina
cd tina

repo init -u https://github.com/tinalinux/manifest -b r16-v2.1.y -m r16/v2.1.y.xml
repo sync
