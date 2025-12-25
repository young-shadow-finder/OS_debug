export OS_DEBUG_ARCH="ARCH=riscv"
export OS_DEBUG_CROSS_COMPILE="CROSS_COMPILE=/home/vm/prj/OS_debug/buildroot/output/host/bin/riscv64-linux-"

echo "qemu-system-riscv64 -machine virt -m 1024 -nographic -kernel linux/arch/riscv/boot/Image -drive file=buildroot/output/images/rootfs.ext4,format=raw,if=virtio -append \"console=ttyS0 root=/dev/vda rootfstype=ext4 rw\" $@" > debug.sh
chmod +x debug.sh

# qemu-system-riscv64 -machine virt -nographic -bios fw_jump.bin -kernel linux/arch/riscv/boot/Image -append "console=ttyS0"
# qemu-system-riscv64 -machine virt -m 1024 -nographic -bios fw_jump.bin -kernel linux/arch/riscv/boot/Image -drive file=buildroot/output/images/rootfs.ext4,format=raw,if=virtio -append "console=ttyS0 root=/dev/vda rootfstype=ext4 rw"
# qemu-system-riscv64 -machine virt -m 1024 -nographic -kernel linux/arch/riscv/boot/Image -drive file=buildroot/output/images/rootfs.ext4,format=raw,if=virtio -append "console=ttyS0 root=/dev/vda rootfstype=ext4 rw"