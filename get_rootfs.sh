work_path=${PWD}
rootfs_mount_point=mount_point_rootfs
root_fs=busybox/_install

cd $root_fs
#_install/
mkdir etc
mkdir dev
mkdir mnt
mkdir -p etc/init.d/
sleep 1
touch etc/init.d/rcS
echo "mkdir -p /proc" > etc/init.d/rcS
echo "mkdir -p /tmp" >> etc/init.d/rcS
echo "mkdir -p /sys" >> etc/init.d/rcS
echo "mkdir -p /mnt" >> etc/init.d/rcS
echo "/bin/mount -a" >> etc/init.d/rcS
chmod +x etc/init.d/rcS
sleep 1
touch etc/fstab
echo "proc /proc proc defaults 0 0" > etc/fstab
echo "tmpfs /tmp tmpfs defaults 0 0" >> etc/fstab
echo "sysfs /sys sysfs defaults 0 0" >> etc/fstab
echo "tmpfs /dev tmpfs defaults 0 0" >> etc/fstab
echo "debugfs /sys/kernel/debug debugfs defaults 0 0" >> etc/fstab
sleep 1
touch etc/inittab
echo "::sysinit:/etc/init.d/rcS" > etc/inittab
echo "::respawn:-/bin/sh" >> etc/inittab
echo "::askfirst:-/bin/sh" >> etc/inittab
echo "::ctrlaltdel:/bin/umount -a-r" >> etc/inittab
sleep 1
cd dev
# _install/dev
sudo mknod console c 5 1
sudo mknod null c 1 3

cd $work_path

echo "Create a 512 image for rootfs.."
dd if=/dev/zero of=rootfs.img bs=1M count=512
sleep 2

mkdir -p $rootfs_mount_point

mkfs.ext4 rootfs.img

sudo mount rootfs.img $rootfs_mount_point

sudo cp -r busybox/_install/ $rootfs_mount_point
sleep 2
sudo umount $rootfs_mount_point
