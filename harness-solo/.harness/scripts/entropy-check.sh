#!/bin/bash
# entropy-check.sh — 项目复杂度监控（可选兜底脚本）
# 用法：bash entropy-check.sh
#
# ⚠️ 跨平台说明：本脚本是可选兜底，仅在 bash 可用环境下执行。
# Windows 或无 bash 环境下，Agent 必须按 verify SKILL.md 的"方式 A"用 Glob+Read 工具
# 统计 files/loc/deps/todos 并对比 baseline.json。
#
# 机制：对比 memory/baseline.json 计算增长率
# baseline.json 由 session-end skill 在归档时写入
#
# 来源：ArtemisAI/Harness_Engineering 的 entropy-check

set -e

HARNESS_DIR=".harness"
BASELINE="$HARNESS_DIR/memory/baseline.json"

# 阈值配置
MAX_FILES_GROWTH_RATE=20   # 单次 Loop 文件增长不超过 20%
MAX_LOC_GROWTH_RATE=30     # 单次 Loop 代码行数增长不超过 30%
MAX_TODOS=20               # TODO 标记上限
MAX_NEW_DEPS=3             # 单次 Loop 新增依赖上限

# 计算当前指标
count_files() {
  find . -type f \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    -not -path '*/.harness/memory/archives/*' \
    -not -path '*/.harness/loops/specs/*' \
    2>/dev/null | wc -l | tr -d ' '
}

count_loc() {
  # 用 wc -l 直接统计行数，避免 cat 整个文件内容到管道（大项目性能问题）
  find . -type f \( -name '*.ts' -o -name '*.tsx' -o -name '*.js' -o -name '*.jsx' \
    -o -name '*.py' -o -name '*.go' -o -name '*.rs' -o -name '*.java' \) \
    -not -path '*/.git/*' \
    -not -path '*/node_modules/*' \
    2>/dev/null -print0 | xargs -0 wc -l 2>/dev/null | awk '$NF != "total" {sum+=$1} END {print sum+0}'
}

count_deps() {
  if [ -f "package.json" ]; then
    node -e "console.log(Object.keys(require('./package.json').dependencies || {}).length)" 2>/dev/null || echo 0
  elif [ -f "requirements.txt" ]; then
    grep -c '^[^#]' requirements.txt 2>/dev/null || echo 0
  else
    echo 0
  fi
}

count_todos() {
  grep -rE '(TODO|FIXME|HACK)' . \
    --include='*.ts' --include='*.tsx' --include='*.js' --include='*.jsx' \
    --include='*.py' --include='*.go' \
    --exclude-dir=.git --exclude-dir=node_modules \
    2>/dev/null | wc -l | tr -d ' '
}

current_files=$(count_files)
current_loc=$(count_loc)
current_deps=$(count_deps)
current_todos=$(count_todos)

echo "=== Entropy Check 报告 ==="
echo "当前指标："
echo "  文件数: $current_files"
echo "  代码行数: $current_loc"
echo "  依赖数: $current_deps"
echo "  TODO/FIXME: $current_todos"
echo ""

# 绝对值检查（无需 baseline）
warnings=0
if [ "$current_todos" -gt "$MAX_TODOS" ]; then
  echo "WARN: TODO/FIXME 数量 $current_todos 超过上限 $MAX_TODOS"
  warnings=$((warnings + 1))
fi

# 增长率检查（需要 baseline）
if [ ! -f "$BASELINE" ]; then
  echo "INFO: 无 baseline.json，跳过增长率检查（首次运行）"
  echo "  session-end 时会写入 baseline.json"
else
  # 解析 baseline.json（简单 grep，避免依赖 jq）
  base_files=$(grep -oE '"files"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)
  base_loc=$(grep -oE '"loc"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)
  base_deps=$(grep -oE '"deps"[[:space:]]*:[[:space:]]*[0-9]+' "$BASELINE" | grep -oE '[0-9]+$' || echo 0)

  if [ "$base_files" -gt 0 ]; then
    files_growth=$(( (current_files - base_files) * 100 / base_files ))
    echo "文件增长率: ${files_growth}%（阈值 ${MAX_FILES_GROWTH_RATE}%）"
    if [ "$files_growth" -gt "$MAX_FILES_GROWTH_RATE" ]; then
      echo "WARN: 文件增长率 ${files_growth}% 超过阈值 ${MAX_FILES_GROWTH_RATE}%"
      warnings=$((warnings + 1))
    fi
  fi

  if [ "$base_loc" -gt 0 ]; then
    loc_growth=$(( (current_loc - base_loc) * 100 / base_loc ))
    echo "代码行数增长率: ${loc_growth}%（阈值 ${MAX_LOC_GROWTH_RATE}%）"
    if [ "$loc_growth" -gt "$MAX_LOC_GROWTH_RATE" ]; then
      echo "WARN: 代码行数增长率 ${loc_growth}% 超过阈值 ${MAX_LOC_GROWTH_RATE}%"
      warnings=$((warnings + 1))
    fi
  fi

  if [ "$base_deps" -gt 0 ]; then
    new_deps=$(( current_deps - base_deps ))
    echo "新增依赖: $new_deps（上限 $MAX_NEW_DEPS）"
    if [ "$new_deps" -gt "$MAX_NEW_DEPS" ]; then
      echo "WARN: 新增依赖 $new_deps 超过上限 $MAX_NEW_DEPS"
      warnings=$((warnings + 1))
    fi
  fi
fi

echo ""
if [ "$warnings" -gt 0 ]; then
  echo "⚠ 发现 $warnings 个警告——复杂度膨胀，建议停下来重构"
  exit 1
else
  echo "✓ 复杂度在可控范围内"
  exit 0
fi
