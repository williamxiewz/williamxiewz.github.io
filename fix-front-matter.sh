#!/bin/bash

# 修复 Hexo 文章的 front-matter 格式
# 将缺少 --- 分隔符的 front-matter 修复为正确格式

echo "开始修复文章 front-matter 格式..."

for file in source/_posts/*.md; do
    echo "处理文件: $file"

    # 检查文件是否已经正确格式化
    if head -1 "$file" | grep -q "^---$"; then
        echo "  ✓ 已正确格式化，跳过"
        continue
    fi

    # 读取文件内容
    content=$(cat "$file")

    # 查找第一个 --- 出现的位置（通常是 front-matter 的结束标记）
    first_separator_line=$(grep -n "^---$" "$file" | head -1 | cut -d: -f1)

    if [ -n "$first_separator_line" ]; then
        # 提取 front-matter 内容（从第1行到第一个 --- 之前）
        front_matter=$(head -n $((first_separator_line - 1)) "$file")
        # 提取文章内容（从第一个 --- 之后开始）
        article_content=$(tail -n +$((first_separator_line + 1)) "$file")

        # 重新组合文件
        {
            echo "---"
            echo "$front_matter"
            echo "---"
            echo "$article_content"
        } > "$file.tmp"

        mv "$file.tmp" "$file"
        echo "  ✓ 已修复 front-matter 格式"
    else
        echo "  ⚠ 未找到 front-matter 分隔符，跳过"
    fi
done

echo "front-matter 修复完成！"
