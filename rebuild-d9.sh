#!/bin/bash

# cherrypicked modify1cimage.sh functions

BASE_DIR="."
FLAG_DIR="."
IMG_DIR="./squashfs-root"
FEATURES_DIR="./features"
FRIENDLYDEVICETYPE="dreame.vacuum.p2009"
DEVICETYPE=${FRIENDLYDEVICETYPE}


echo "j63d8514185bb0" > jobid
touch sn
echo "P20091A20US02706ZM" > sn
touch p2009
touch devicetype
echo "dreame.vacuum.p2009" > devicetype
touch devicetypealias
echo "dreame_p2009" > devicetypealias
touch authorized_keys_id
echo ",,,,," > authorized_keys_id
touch anonymous
echo "63d8514185bb3" > anonymous
touch diff
touch tools
touch valetudo
touch patch_dns
touch patch_dns
touch installer


rebuild_extract_rootfs(){
  mkdir -p $BASE_DIR/output
  
  [ ! -e rootfs.img ] && unzip $BASE_DIR/update.zip

  [ -e $BASE_DIR/boot.img ] || return 0
  [ -e $BASE_DIR/rootfs.img ] || return 0

  [ -e rootfs.img.template ] || cp rootfs.img rootfs.img.template
  unsquashfs -d $IMG_DIR $BASE_DIR/rootfs.img

}

rebuild_add_custom_files(){
  if [ -d "$BASE_DIR/custom" ]; then
    echo "installing custom files"
    cp -vr $BASE_DIR/custom/* $IMG_DIR/
  fi
}

rebuild_create_build_info(){
  echo "built with dustbuilder (https://builder.dontvacuum.me)" > $IMG_DIR/build.txt
  echo "rebuilt with (https://github.com/codekow/notes-that-suck)" >> $IMG_DIR/build.txt

  if [ -f $FLAG_DIR/version ]; then
    cat $FLAG_DIR/version >> $IMG_DIR/build.txt
  fi

  echo "" >> $IMG_DIR/build.txt
  sed -i '$ d' $IMG_DIR/etc/banner
  sed -i '$ d' $IMG_DIR/etc/banner
  cat $IMG_DIR/build.txt >> $IMG_DIR/etc/banner

}

rebuild_squash_rootfs(){
  echo "creating rootfs"
  mksquashfs $IMG_DIR/ rootfs_tmp.img -noappend -root-owned -comp xz -b 256k -p '/dev d 755 0 0' -p '/dev/console c 600 0 0 5 1'

  dd if=$BASE_DIR/rootfs_tmp.img of=$BASE_DIR/rootfs.img bs=128k conv=sync

  rm $BASE_DIR/rootfs_tmp.img
  rm -rf $IMG_DIR

  md5sum $BASE_DIR/rootfs.img > $BASE_DIR/rootfs_md5sum
  md5sum ./*.img > $BASE_DIR/firmware.md5sum

  echo "check image file size"
  maximumsize=30000000
  minimumsize=20000000

  actualsize=$(wc -c < $BASE_DIR/rootfs.img)
  if [ "$actualsize" -gt "$maximumsize" ]; then
    echo "(!!!) rootfs.img looks to big. The size might exceed the available space on the flash. $actualsize > $maximumsize"
    echo "(!!!) rootfs.img looks to big. The size might exceed the available space on the flash. $actualsize > $maximumsize" > $BASE_DIR/output/error.txt
    echo ${FRIENDLYDEVICETYPE} >> $BASE_DIR/output/error.txt
    echo $actualsize >> $BASE_DIR/output/error.txt
    echo $maximumsize >> $BASE_DIR/output/error.txt
    exit 1
  fi

  if [ "$actualsize" -le "$minimumsize" ]; then
    echo "(!!!) rootfs.img looks to small. Maybe something went wrong with the image generation."
    echo "(!!!) rootfs.img looks to small. Maybe something went wrong with the image generation." > $BASE_DIR/output/error.txt
    echo ${FRIENDLYDEVICETYPE} >> $BASE_DIR/output/error.txt
    echo $actualsize >> $BASE_DIR/output/error.txt
    echo $maximumsize >> $BASE_DIR/output/error.txt
    exit 1
  fi
}

rebuild_create_installer(){
	echo "create installer package"
	install -m 0755 $FEATURES_DIR/fwinstaller_1c/install-mcufw.sh $BASE_DIR/install-mcufw.sh
	
  sed "s/DEVICEMODEL=.*/DEVICEMODEL=\"${DEVICETYPE}\"/g" $FEATURES_DIR/fwinstaller_1c/install.sh > $BASE_DIR/install.sh
  sed -i "s/# maxsizeplaceholder/maximumsize=${maximumsize}/g" $BASE_DIR/install.sh
  sed -i "s/# minsizeplaceholder/minimumsize=${minimumsize}/g" $BASE_DIR/install.sh
  chmod +x install.sh
  sed "s/DEVICEMODEL=.*/DEVICEMODEL=\"${DEVICETYPE}\"/g" $FEATURES_DIR/fwinstaller_1c/install-manual.sh > $BASE_DIR/install-manual.sh
  sed -i "s/# maxsizeplaceholder/maximumsize=${maximumsize}/g" $BASE_DIR/install-manual.sh
  sed -i "s/# minsizeplaceholder/minimumsize=${minimumsize}/g" $BASE_DIR/install-manual.sh
  chmod +x install-manual.sh

  tar -czf $BASE_DIR/output/${DEVICETYPE}_fw.tar.gz $BASE_DIR/*.img $BASE_DIR/mcu_md5sum mcu.bin $BASE_DIR/firmware.md5sum $BASE_DIR/install.sh $BASE_DIR/install-manual.sh $BASE_DIR/install-mcufw.sh

  md5sum $BASE_DIR/output/${DEVICETYPE}_fw.tar.gz > $BASE_DIR/output/md5.txt
	echo "${DEVICETYPE}_fw.tar.gz" > $BASE_DIR/filename.txt
}

rebuild_compare(){
	echo "unpack original"
	unsquashfs -d $BASE_DIR/original $BASE_DIR/rootfs.img.template
	rm -rf $BASE_DIR/original/dev

	echo "unpack modified"
	unsquashfs -d $BASE_DIR/modified $BASE_DIR/rootfs.img
	rm -rf $BASE_DIR/modified/dev

	diff -ur $BASE_DIR/original/ $BASE_DIR/modified/ > $BASE_DIR/output/diff.txt
	rm -rf $BASE_DIR/original
	rm -rf $BASE_DIR/modified
}

rebuild_extract_rootfs
rebuild_add_custom_files
rebuild_create_build_info
rebuild_squash_rootfs
rebuild_create_installer
rebuild_compare
