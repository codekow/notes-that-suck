# Note for Wyze Vac

## Build with docker / podman

Run build scripts in a container.

```sh
# start build container
wyze/builder.sh
```

```sh
. build/envsetup.sh; lunch astar_parrot-tina
make menuconfig
```

## Links

- https://itooktheredpill.irgendwo.org/2020/rooting-xiaomi-vacuum-robot
