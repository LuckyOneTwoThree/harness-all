#!/bin/bash
# archive-progress.sh — 记忆自动归档（可选兜底脚本）
# 用法：bash archive-progress.sh
#
# ⚠️ 跨平台说明：本脚本是可选兜底，仅在 bash 可用环境（macOS/Linux/Git Bash）下执行。
# Windows 或无 bash 环境下，Agent 必须按 session-end SKILL.md 的步骤 4.1-4.2 用工具操作
# （Read progress.md → 检测行数 → 切档 → Write 回写）。
#
# 机制：wc -l 检测行数，超过阈值自动切割归档到 archives/

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

HARNESS_DIR=".harness"
PROGRESS="$HARNESS_DIR/memory/progress.md"
ARCHIVES_DIR="$HARNESS_DIR/memory/archives"
THRESHOLD=200  # 行数阈值

if [ ! -f "$PROGRESS" ]; then
  echo "OK: $PROGRESS 不存在，无需归档"
  exit 0
fi

mkdir -p "$ARCHIVES_DIR"

lines=$(wc -l < "$PROGRESS" | tr -d ' ')

if [ "$lines" -le "$THRESHOLD" ]; then
  echo "OK: progress.md $lines 行（阈值 $THRESHOLD），无需归档"
  exit 0
fi

# 生成归档文件名
timestamp=$(date -u +"%Y-%m-%dT%H-%M-%SZ")
archive_file="$ARCHIVES_DIR/progress-$timestamp.md"

# 备份当前 progress.md
cp "$PROGRESS" "$archive_file"

# 保留最后一个完整会话块（以 "## 会话:" 标记开头）
# 避免固定 tail -N 切断会话上下文
last_session_line=$(grep -n '^## 会话:' "$PROGRESS" | tail -1 | cut -d: -f1)
if [ -n "$last_session_line" ]; then
  tail -n +"$last_session_line" "$PROGRESS" > "$PROGRESS.tmp"
else
  # 没有会话标记，回退到 tail -30
  tail -30 "$PROGRESS" > "$PROGRESS.tmp"
fi
mv "$PROGRESS.tmp" "$PROGRESS"

# 在归档文件头部加来源信息
{
  echo "<!-- 归档时间: $timestamp -->"
  echo "<!-- 原行数: $lines -->"
  echo "<!-- 归档原因: 超过阈值 $THRESHOLD 行 -->"
  echo ""
  cat "$archive_file"
} > "$archive_file.tmp"
mv "$archive_file.tmp" "$archive_file"

# 更新 archives/INDEX.md
INDEX_FILE="$ARCHIVES_DIR/INDEX.md"
if [ ! -f "$INDEX_FILE" ]; then
  cat > "$INDEX_FILE" <<'EOF'
# 归档索引

| 文件 | 归档时间 | 原行数 | 说明 |
|------|---------|--------|------|
EOF
fi

echo "| progress-$timestamp.md | $timestamp | $lines | 自动归档 |" >> "$INDEX_FILE"

echo "✓ 已归档: $archive_file（$lines 行）"
echo "✓ progress.md 保留最后一个完整会话块"
exit 0
