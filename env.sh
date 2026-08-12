#!/usr/bin/env bash

# 遇到任何命令错误立即退出脚本，避免后续错误叠加
set -e

echo "=== 1. 更新系统包并安装基础工具 ==="
sudo apt-get update
sudo apt-get install -y python3-venv python3-pip git wget ninja-build cmake
pip3 install --user west

# 定义工作根目录
WORKSPACE_DIR=$(pwd)"/zephyrproject"
echo $WORKSPACE_DIR
# exit

echo "=== 2. 初始化 Zephyr 项目工作区 ==="
# 如果目录不存在才进行初始化
if [ ! -d "$WORKSPACE_DIR" ]; then
    mkdir -p "$(dirname "$WORKSPACE_DIR")"
    west init "$WORKSPACE_DIR"
fi

cd "$WORKSPACE_DIR"

echo "=== 3. 创建并激活 Python 虚拟环境 ==="
# 创建 venv（如果不存在）
if [ ! -d "env" ]; then
    python3 -m venv env
fi

# 激活虚拟环境
source env/bin/activate

# 升级 pip，避免老旧 pip 触发虚拟环境判别问题
python3 -m pip install --upgrade pip

echo "=== 4. 同步代码仓库与 Python 依赖 ==="
west update

# 自动处理 Python 包依赖安装
west packages pip --install

# 导出 Zephyr CMake 环境变量
west zephyr-export

echo "=== 5. 配置 Toolchain 与 Blob 资源 ==="
cd "$WORKSPACE_DIR/zephyr"

# 安装 RISC-V 交叉编译工具链（ESP32-C6 基于 RISC-V 架构）
west sdk install --toolchains riscv64-zephyr-elf

# 拉取 ESP32C6 所需的二进制 HAL/BLOB 组件
west blobs fetch hal_espressif

echo "=== 6. 开始编译目标工程 (ESP32-C6 Hello World) ==="
# 编译 Hello World 示例
west build -p always -b esp32c6_devkitc/esp32c6/hpcore samples/hello_world

echo "=========================================="
echo " 编译成功！固件位于: $WORKSPACE_DIR/zephyr/build/zephyr/zephyr.bin"
echo "=========================================="