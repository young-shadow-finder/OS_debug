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

echo "Now will config compile busybox"
cd $busybox_path
pwd
echo "Now will start compile busybox"
make defconfig
sleep 1
# set CROSS_COMPILE
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu-
sleep 1
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- install

