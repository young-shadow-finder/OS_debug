#make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- menuconfig
#make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- 【 “Image”、“dtb”和“ modules” 】-j$(cpus)

kernel_path=linux

if [ -d "$kernel_path" ]; then
  echo "File has exit..."
#  exit
else
  echo "File not exit, clone code will start..."
  git clone https://github.com/torvalds/linux.git
  echo "clone code over..."
  sleep 5
fi


cd $kernel_path

make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- defconfig
sleep 1
make ARCH=arm64 CROSS_COMPILE=aarch64-none-linux-gnu- -j4

