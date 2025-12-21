#!/bin/bash

# 修复缺少 front-matter 开头分隔符的 Hexo 文章

echo "开始修复文章 front-matter 格式..."

for file in source/_posts/*.md; do
    # 检查文件是否以 --- 开头
    if ! head -1 "$file" | grep -q "^---$"; then
        echo "修复文件: $file"

        # 读取文件内容
        content=$(cat "$file")

        # 找到第一个 --- 的行号
        first_separator=$(grep -n "^---$" "$file" | head -1 | cut -d: -f1)

        if [ -n "$first_separator" ]; then
            # 提取 front-matter 内容（第1行到第一个 --- 前）
            front_matter_lines=$((first_separator - 1))
            front_matter=$(head -n $front_matter_lines "$file")

            # 提取文章内容（从第一个 --- 之后开始）
            article_content=$(tail -n +$((first_separator + 1)) "$file")

            # 重新写入文件
            {
                echo "---"
                echo "$front_matter"
                echo "---"
                echo "$article_content"
            } > "$file.tmp"

            mv "$file.tmp" "$file"
            echo "  ✓ 已修复"
        else
            echo "  ⚠ 未找到分隔符，跳过"
        fi
    else
        echo "文件 $file 已经正确格式化"
    fi
done

echo "修复完成！"
