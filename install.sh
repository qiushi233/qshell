#!/bin/bash
# install.sh - 一键安装 remove_doubao_hosts 定时清理脚本
# 用法: curl -fsSL https://raw.githubusercontent.com/qiushi233/qshell/master/install.sh | bash

set -e

REPO_RAW_BASE="https://raw.githubusercontent.com/qiushi233/qshell/master"
SCRIPT_NAME="remove_doubao_hosts.sh"
INSTALL_DIR="$HOME/.local/bin"
INSTALL_PATH="$INSTALL_DIR/$SCRIPT_NAME"
LOG_FILE="/tmp/remove_doubao_hosts.log"

# 颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()    { echo -e "${GREEN}[✓]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
error()   { echo -e "${RED}[✗]${NC} $1"; exit 1; }

echo ""
echo "=== remove_doubao_hosts 安装程序 ==="
echo ""

# 1. 检查系统
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "当前仅支持 macOS，检测到系统为: $OSTYPE"
fi

# 2. 创建安装目录
mkdir -p "$INSTALL_DIR"
info "安装目录: $INSTALL_PATH"

# 3. 下载主脚本
info "正在下载脚本..."
if command -v curl &>/dev/null; then
    curl -fsSL "$REPO_RAW_BASE/$SCRIPT_NAME" -o "$INSTALL_PATH"
elif command -v wget &>/dev/null; then
    wget -q "$REPO_RAW_BASE/$SCRIPT_NAME" -O "$INSTALL_PATH"
else
    error "未找到 curl 或 wget，请先安装其中一个"
fi

chmod +x "$INSTALL_PATH"
info "脚本下载完成"

# 4. 注册 root crontab（每5分钟执行一次）
CRON_JOB="*/5 * * * * $INSTALL_PATH >> $LOG_FILE 2>&1"

# 检查是否已存在相同任务，避免重复添加
EXISTING=$(sudo crontab -l 2>/dev/null || true)
if echo "$EXISTING" | grep -qF "$INSTALL_PATH"; then
    warn "crontab 中已存在该任务，跳过添加"
else
    # 追加到 root crontab
    (echo "$EXISTING"; echo "$CRON_JOB") | sudo crontab -
    info "已注册定时任务（每5分钟执行一次）"
fi

# 5. 立即执行一次，验证效果
info "立即执行一次清理..."
sudo "$INSTALL_PATH"

echo ""
echo "=== 安装完成 ==="
echo ""
echo "  脚本路径:   $INSTALL_PATH"
echo "  执行日志:   $LOG_FILE"
echo "  定时规则:   每5分钟自动清理 /etc/hosts 中的 doubao 条目"
echo ""
echo "  查看日志:   tail -f $LOG_FILE"
echo "  查看任务:   sudo crontab -l"
echo "  卸载:       sudo crontab -l | grep -v '$INSTALL_PATH' | sudo crontab -"
echo ""
