busybox_path=busybox

if [ -d "$busybox_path" ]; then
  echo "File has exit..."
#  exit
else
  echo "File not exit, clone code will start..."
  git clone https://github.com/mirror/busybox.git
  echo "clone code over..."
  echo "Compile busybox link static, else copy gcc compile toolchain lib"
  sleep 10
fi

sudo echo "Now will config compile busybox"
cd $busybox_path
pwd
echo "Now will start compile busybox"
make defconfig
sleep 1
# set CROSS_COMPILE
make CROSS_COMPILE=aarch64-none-linux-gnu-
sleep 1
make install
cd _install/
<<'COMMENTS'
#_install/
mkdir etc
mkdir dev
mkdir mnt
mkdir -p etc/init.d/
sleep 1
touch etc/init.d/rcS
echo "mkdir -p /proc" >> etc/init.d/rcS
echo "mkdir -p /tmp" >> etc/init.d/rcS
echo "mkdir -p /sys" >> etc/init.d/rcS
echo "mkdir -p /mnt" >> etc/init.d/rcS
echo "/bin/mount -a" >> etc/init.d/rcS
echo "mkdir -p /dev/pts" >> etc/init.d/rcS
echo "mount -t devpts devpts /dev/pts" >> etc/init.d/rcS
echo "echo /sbin/mdev > /proc/sys/kernel/hotplug" >> etc/init.d/rcS
echo "mdev -s" >> etc/init.d/rcS
chmod +x etc/init.d/rcS
sleep 1
touch etc/fstab
echo "proc /proc proc defaults 0 0" >> etc/fstab
echo "tmpfs /tmp tmpfs defaults 0 0" >> etc/fstab
echo "sysfs /sys sysfs defaults 0 0" >> etc/fstab
echo "tmpfs /dev tmpfs defaults 0 0" >> etc/fstab
echo "debugfs /sys/kernel/debug debugfs defaults 0 0" >> etc/fstab
sleep 1
touch etc/inittab
echo "::sysinit:/etc/init.d/rcS" >> etc/inittab
echo "::respawn:-/bin/sh" >> etc/inittab
echo "::askfirst:-/bin/sh" >> etc/inittab
echo "::ctrlaltdel:/bin/umount -a-r" >> etc/inittab
sleep 1
cd dev
# _install/dev
sudo mknod console c 5 1
sudo mknod null c 1 3
COMMENTS