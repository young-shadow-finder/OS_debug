#wget -P toolchain https://armkeil.blob.core.windows.net/developer/Files/downloads/gnu-a/10.3-2021.07/binrel/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf.tar.xz
tar -C toolchain -xf toolchain/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf.tar.xz
git clone https://gitee.com/rtthread/rt-thread.git