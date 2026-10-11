#!/bin/bash
# 应用程序初始化脚本，在应用程序首次安装时执行
set -euo pipefail

# 定义文件路径
ROOT_ENV="./.env"
DATA_ENV="./data/.env"
# 创建临时文件（避免直接修改原文件导致内容损坏）
TMP_FILE=$(mktemp)

# 检查文件是否存在
check_files() {
    if [ ! -f "$ROOT_ENV" ]; then
        echo "❌ 错误：根目录.env文件不存在 -> $ROOT_ENV"
        exit 1
    fi
    if [ ! -f "$DATA_ENV" ]; then
        echo "❌ 错误：data目录.env文件不存在 -> $DATA_ENV"
        exit 1
    fi
}

# 加载根目录.env的环境变量
load_env_vars() {
    echo "📖 正在读取环境变量文件：$ROOT_ENV"
    # 读取.env文件，过滤空行、注释行，提取键值对
    while IFS='=' read -r key value; do
        # 跳过空行和以#开头的注释行
        if [[ -z "$key" || "$key" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        # 去除键值两端的空格
        key=$(echo "$key" | xargs)
        value=$(echo "$value" | xargs)
        # 跳过格式不正确的行（无值）
        if [ -z "$value" ]; then
            echo "⚠️  警告：跳过格式错误的行 -> $key="
            continue
        fi
        # 存储变量（用临时文件记录，避免Shell变量名非法问题）
        echo "$key=$value" >> "$TMP_FILE"
    done < "$ROOT_ENV"
}

# 替换data/.env中的占位符（无备份文件版本）
replace_placeholders() {
    echo "🔄 正在替换占位符：$DATA_ENV"
    # 先复制原文件到临时文件，作为替换基础
    cp "$DATA_ENV" "${TMP_FILE}.env.tmp"
    
    # 遍历所有环境变量，逐个替换占位符（不生成备份文件）
    while IFS='=' read -r key value; do
        if [ -n "$key" ] && [ -n "$value" ]; then
            # 关键修改：使用sed -i ''（macOS）或 -i（Linux）无备份替换
            # 兼容Linux/macOS的sed语法差异
            if [[ "$OSTYPE" == "darwin"* ]]; then
                # macOS系统sed需要空参数表示无备份
                sed -i '' "s|\${$key}|$value|g" "${TMP_FILE}.env.tmp"
            else
                # Linux系统sed直接-i即可无备份
                sed -i "s|\${$key}|$value|g" "${TMP_FILE}.env.tmp"
            fi
        fi
    done < "$TMP_FILE"
    
    # 将替换后的内容覆盖原文件
    mv "${TMP_FILE}.env.tmp" "$DATA_ENV"
    echo "✅ 替换完成，文件已更新：$DATA_ENV"
}

# 清理临时文件
cleanup() {
    rm -f "$TMP_FILE" "${TMP_FILE}.env.tmp"
}

# 主执行流程
main() {
    trap cleanup EXIT  # 脚本退出时自动清理临时文件
    check_files
    load_env_vars
    replace_placeholders
    
    echo -e "\n🎉 环境变量替换全部完成！"
    echo -e "\n📋 替换的环境变量清单："
    cat "$TMP_FILE" | sort
}

# 启动主流程
main