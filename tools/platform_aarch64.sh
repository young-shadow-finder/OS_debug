export OS_DEBUG_ARCH="ARCH=arm64"
export OS_DEBUG_CROSS_COMPILE="CROSS_COMPILE=aarch64-none-linux-gnu-"

echo "qemu-system-aarch64 -M virt -m 1024 -nographic -cpu cortex-a53 -kernel linux/arch/arm64/boot/Image -append \"noinitrd nokaslr loglevel=8 root=/dev/vda rootfstype=ext4 rw\" -drive if=none,file=rootfs.img,id=hd0 -device virtio-blk-device,drive=hd0 \$@" > debug.sh