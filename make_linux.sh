#make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE menuconfig
#make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE 【 “Image”、“dtb”和“ modules” 】-j$(cpus)

kernel_path=linux

if [ -d "$kernel_path" ]; then
  echo "File has exit..."
#  exit
else
  echo "File not exit, clone code will start..."
  git clone https://github.com/torvalds/linux.git
  echo "clone code over..."
  sleep 2
  cp tools/dbg_aarch64_defconfig linux/arch/arm64/configs/yf_defconfig
  sleep 2
  cd $kernel_path
  sleep 2
  make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE yf_defconfig
  exit
fi

cd $kernel_path

sleep 1
make $OS_DEBUG_ARCH $OS_DEBUG_CROSS_COMPILE -j4

