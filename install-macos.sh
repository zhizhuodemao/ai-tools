#!/usr/bin/env bash
set -euo pipefail

PLUGIN_NAME="boss-resume-agent-plugin"
MARKETPLACE_NAME="personal"
MARKETPLACE_DISPLAY_NAME="Personal"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_PLUGIN_DIR="$SCRIPT_DIR/plugins/$PLUGIN_NAME"
TARGET_PLUGIN_PARENT="$HOME/plugins"
TARGET_PLUGIN_DIR="$TARGET_PLUGIN_PARENT/$PLUGIN_NAME"
MARKETPLACE_DIR="$HOME/.agents/plugins"
MARKETPLACE_FILE="$MARKETPLACE_DIR/marketplace.json"

if [ ! -d "$SOURCE_PLUGIN_DIR" ]; then
  echo "找不到插件目录：$SOURCE_PLUGIN_DIR"
  echo "请确认你是在解压后的 boss-resume-agent-codex-1.0.1 目录内运行本脚本。"
  exit 1
fi

mkdir -p "$TARGET_PLUGIN_PARENT"
mkdir -p "$MARKETPLACE_DIR"

rm -rf "$TARGET_PLUGIN_DIR"
cp -R "$SOURCE_PLUGIN_DIR" "$TARGET_PLUGIN_DIR"

MARKETPLACE_FILE="$MARKETPLACE_FILE" \
MARKETPLACE_NAME="$MARKETPLACE_NAME" \
MARKETPLACE_DISPLAY_NAME="$MARKETPLACE_DISPLAY_NAME" \
PLUGIN_NAME="$PLUGIN_NAME" \
python3 - <<'PY'
import json
import os
from pathlib import Path

marketplace_file = Path(os.environ["MARKETPLACE_FILE"])
marketplace_name = os.environ["MARKETPLACE_NAME"]
marketplace_display_name = os.environ["MARKETPLACE_DISPLAY_NAME"]
plugin_name = os.environ["PLUGIN_NAME"]

entry = {
    "name": plugin_name,
    "source": {
        "source": "local",
        "path": f"./plugins/{plugin_name}",
    },
    "policy": {
        "installation": "AVAILABLE",
        "authentication": "ON_INSTALL",
    },
    "category": "Productivity",
}

if marketplace_file.exists():
    with marketplace_file.open("r", encoding="utf-8") as handle:
        payload = json.load(handle)
else:
    payload = {
        "name": marketplace_name,
        "interface": {
            "displayName": marketplace_display_name,
        },
        "plugins": [],
    }

if not isinstance(payload, dict):
    raise SystemExit(f"{marketplace_file} 不是有效的 JSON object。")

payload.setdefault("name", marketplace_name)
interface = payload.setdefault("interface", {})
if isinstance(interface, dict):
    interface.setdefault("displayName", marketplace_display_name)
else:
    payload["interface"] = {"displayName": marketplace_display_name}

plugins = payload.setdefault("plugins", [])
if not isinstance(plugins, list):
    raise SystemExit(f"{marketplace_file} 的 plugins 字段不是数组。")

for index, item in enumerate(plugins):
    if isinstance(item, dict) and item.get("name") == plugin_name:
        plugins[index] = entry
        break
else:
    plugins.append(entry)

marketplace_file.parent.mkdir(parents=True, exist_ok=True)
with marketplace_file.open("w", encoding="utf-8") as handle:
    json.dump(payload, handle, ensure_ascii=False, indent=2)
    handle.write("\n")
PY

echo "安装完成：$TARGET_PLUGIN_DIR"
echo "Marketplace 已更新：$MARKETPLACE_FILE"
echo ""
echo "下一步："
echo "1. 重启 Codex App"
echo "2. 打开 Plugins"
echo "3. 找到「BOSS 简历投递助手」并点击 Add to Codex"
echo "4. 新开线程使用：使用 BOSS 简历投递助手，先建立画像，不要直接投递。"
