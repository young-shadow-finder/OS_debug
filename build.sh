TOOL_CHAIN_PATH=$PWD/gcc-arm-10.3-2021.07-x86_64-aarch64-none-elf/bin/
# echo $TOOL_CHAIN_PATH
cd rt-thread/bsp/qemu-virt64-aarch64
scons --exec-path=$TOOL_CHAIN_PATH $@