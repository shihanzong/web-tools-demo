#!/bin/sh
# ============================================================
# 容器启动脚本
# 1) 把环境变量写进 Xray 配置（UUID / 端口 / WS 路径）
# 2) 前台启动 Xray（两个入站：主用 + 备用）
# ============================================================
set -eu

: "${UUID:?启动失败：没有设置环境变量 UUID，请在平台的环境变量里添加 UUID=<一个 UUID>}"

PORT_A="${PORT_A:-8443}"                 # 主用节点端口
PORT_B="${PORT_B:-8081}"                 # 备用节点端口
WS_PATH="${WS_PATH:-/vless}"             # 主用节点 WebSocket 路径
WS_PATH_BAK="${WS_PATH_BAK:-/vless-bak}" # 备用节点 WebSocket 路径

mkdir -p /etc/xray

sed \
  -e "s|__UUID__|${UUID}|g" \
  -e "s|__PORT_A__|${PORT_A}|g" \
  -e "s|__PORT_B__|${PORT_B}|g" \
  -e "s|__WS_PATH__|${WS_PATH}|g" \
  -e "s|__WS_PATH_BAK__|${WS_PATH_BAK}|g" \
  /etc/xray/config.template.json > /etc/xray/config.json

echo "[entrypoint] 主用端口=${PORT_A} 备用端口=${PORT_B} WS路径=${WS_PATH}/${WS_PATH_BAK}"
exec /usr/local/bin/xray run -c /etc/xray/config.json
