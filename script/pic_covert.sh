#!/bin/bash

# 指定要搜索的目录
directory="learn_doc"

# 查找所有 PNG 文件
for file in "$directory"/*.png; do
    # 获取文件名（不含路径和扩展名）
    filename=$(basename "$file" .png)

    # 生成新文件名
    new_filename=$(printf "output-$filename.png")

    # 新文件路径
    new_file="$directory/$new_filename"

    echo $file
    echo $new_file

    convert $file -negate $new_file

done

echo "重命名完成！"