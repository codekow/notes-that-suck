# Root Robot Vacuums

A collection of notes for robot vacuums so I don't have to relearn everything when I care about this subject.

[Dreame D9 Notes](docs/D9.md)

## Quickstart

Setup builder scripts

```sh
mkdir scratch
cd scratch

git clone https://github.com/dgiese/dustbuilder-script-public builder
cd builder

git clone https://github.com/dgiese/dustbuilder-features features

cat <<EOF >.gitignore
custom/
features/
output/

_buildflags.sh
update.zip
EOF

chmod +x *.sh
```

Recreate update.zip

```sh
zip update.zip -9 boot.img mcu* rootfs.img*
```

Build firmware

```sh
# cp _buildflags.sh update.zip

fakeroot

curl https://github.com/codekow.keys > authorized_keys

./_buildflags.sh
./modify1cimage.sh

exit
```

## Links Dump

- https://github.com/dgiese/dustbuilder-features
- https://builder.dontvacuum.me/_dreame_p2009.html
- https://github.com/dgiese/dustbuilder-script-public
- https://dontvacuum.me/robotinfo
- https://git.sudo.is/mirrors/Valetudo/src/branch/master/docs/_pages/installation/dreame.md
- https://maxammann.org/posts/2025/06/dreame-fel-mode
- https://github.com/Hypfer/valetudo-dreameadapter
- https://jfx.ac/blog/robot-vacuum-hacking
