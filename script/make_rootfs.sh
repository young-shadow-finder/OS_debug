busybox_path=busybox

if [ -d "$busybox_path" ]; then
  echo "File has exit..."
#  exit
else
  echo "File not exit, clone code will start..."
  git clone https://github.com/mirror/busybox.git
  echo "clone code over..."
  echo "Compile busybox link static, else copy gcc compile toolchain lib"
  sleep 5
  make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE defconfig
  exit
fi

echo "Now will config compile busybox"
cd $busybox_path
pwd
echo "Now will start compile busybox"

sleep 1
# set CROSS_COMPILE
make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE
sleep 1
make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE install

