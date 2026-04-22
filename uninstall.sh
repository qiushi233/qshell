#!/bin/bash
# uninstall.sh - 卸载 remove_doubao_hosts 定时清理脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/qiushi233/qshell/master/uninstall.sh | bash

set -e

SCRIPT_NAME="remove_doubao_hosts.sh"
INSTALL_PATH="$HOME/.local/bin/$SCRIPT_NAME"
LOG_FILE="/tmp/remove_doubao_hosts.log"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }

echo ""
echo "=== remove_doubao_hosts 卸载程序 ==="
echo ""

# 1. 移除 crontab 任务
EXISTING=$(sudo crontab -l 2>/dev/null || true)
if echo "$EXISTING" | grep -qF "$SCRIPT_NAME"; then
    echo "$EXISTING" | grep -vF "$SCRIPT_NAME" | sudo crontab -
    info "已移除定时任务"
else
    warn "crontab 中未找到相关任务，跳过"
fi

# 2. 删除脚本文件
if [ -f "$INSTALL_PATH" ]; then
    rm -f "$INSTALL_PATH"
    info "已删除脚本: $INSTALL_PATH"
else
    warn "脚本文件不存在，跳过: $INSTALL_PATH"
fi

# 3. 删除日志文件
if [ -f "$LOG_FILE" ]; then
    rm -f "$LOG_FILE"
    info "已删除日志: $LOG_FILE"
else
    warn "日志文件不存在，跳过: $LOG_FILE"
fi

echo ""
echo "=== 卸载完成 ==="
echo ""
