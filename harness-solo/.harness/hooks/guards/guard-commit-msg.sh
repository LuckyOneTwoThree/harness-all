#!/bin/bash
# guard-commit-msg.sh — 提交格式校验
# 用法：bash guard-commit-msg.sh "$1"（git hook 调用，$1 是 commit-msg 文件路径）
#   或 bash guard-commit-msg.sh -m "commit message"

set -e

# 获取 commit message
if [ "$1" = "-m" ]; then
  msg="$2"
else
  # git commit-msg hook 模式
  msg_file="$1"
  if [ -z "$msg_file" ]; then
    echo "用法: bash guard-commit-msg.sh <commit-msg-file> | -m \"message\""
    exit 1
  fi
  msg=$(cat "$msg_file")
fi

# Conventional Commits 格式
# <type>(<scope>): <subject>
# type: feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert
PATTERN='^(feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert)(\([a-z0-9-]+\))?: .{1,72}'

if ! echo "$msg" | head -1 | grep -qE "$PATTERN"; then
  echo "BLOCK: 提交信息不符合 Conventional Commits 格式"
  echo ""
  echo "格式: <type>(<scope>): <subject>"
  echo "type: feat|fix|docs|style|refactor|perf|test|chore|build|ci|revert"
  echo "scope: 可选，小写中划线"
  echo "subject: 1-72 字符"
  echo ""
  echo "你的提交:"
  echo "  $(echo "$msg" | head -1)"
  echo ""
  echo "示例:"
  echo "  feat(auth): add login with password"
  echo "  fix: handle empty username in profile"
  echo "  docs: update AGENTS.md loading chain"
  exit 1
fi

# 检查 subject 长度
subject=$(echo "$msg" | head -1 | sed 's/^[^:]*: //')
if [ ${#subject} -gt 72 ]; then
  echo "WARN: subject 超过 72 字符（当前 ${#subject}）"
fi

# 检查是否以句号结尾（不推荐）
if echo "$subject" | grep -qE '\.$'; then
  echo "WARN: subject 不建议以句号结尾"
fi

echo "OK: 提交信息格式正确"
exit 0
