# qemu-system-aarch64 -m 1024 -cpu max,sve=on,sve256=on -M virt,gic-version=3,its=on,iommu=smmuv3 -nographic -kernel linux/arch/arm64/boot/Image -append "noinitrd nokaslr loglevel=8 root=/dev/vda rootfstype=ext4 rw" -drive if=none,file=rootfs.img,id=hd0 -device virtio-blk-device,drive=hd0

# qemu-system-aarch64 -M virt -m 1024 -nographic -cpu cortex-a53 -dtb test.dtb \
# -kernel linux/arch/arm64/boot/Image \
# -append "noinitrd nokaslr loglevel=8 root=/dev/vda rootfstype=ext4 rw" \
# -drive if=none,file=rootfs.img,id=hd0 -device virtio-blk-device,drive=hd0 \
# -drive if=none,id=usbstick,format=raw,file=usb_disk.img -usb -device usb-ehci,id=ehci \
# -device usb-storage,bus=ehci.0,drive=usbstick -s -S

qemu-system-aarch64 -M virt -m 1024 -nographic -cpu cortex-a53 -kernel linux/arch/arm64/boot/Image -append "noinitrd nokaslr loglevel=8 root=/dev/vda rootfstype=ext4 rw" -drive if=none,file=rootfs.img,id=hd0 -device virtio-blk-device,drive=hd0 -s -S