#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
bash install-macos.sh
echo
read -n 1 -s -r -p "安装完成。按任意键关闭窗口。"
echo
