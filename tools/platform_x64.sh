export OS_DEBUG_ARCH=""
export OS_DEBUG_CROSS_COMPILE=""

echo "qemu-system-x86_64 -kernel linux/arch/x86_64/boot/bzImage -drive file=buildroot/output/images/rootfs.ext4,format=raw,if=ide -append \"nokaslr console=ttyS0 root=/dev/sda  rootfstype=ext4 rw\" -nographic \$@" > debug.sh
chmod +x debug.sh