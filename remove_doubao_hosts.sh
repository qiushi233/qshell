#!/bin/bash
# 每5分钟从 /etc/hosts 中移除含「doubao」字样的行
# 需要 sudo 权限运行（通过 crontab 以 root 身份执行）

HOSTS_FILE="/etc/hosts"
PATTERN="doubao"

# 检查是否有匹配行
if grep -qi "$PATTERN" "$HOSTS_FILE"; then
    # 创建临时文件
    TMP_FILE=$(mktemp)
    # 过滤掉含 doubao 的行（大小写不敏感）
    grep -vi "$PATTERN" "$HOSTS_FILE" > "$TMP_FILE"
    # 替换原文件
    cp "$TMP_FILE" "$HOSTS_FILE"
    rm -f "$TMP_FILE"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Removed doubao entries from $HOSTS_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] No doubao entries found, nothing to do."
fi
