#!/usr/bin/env bash
# sync-base.sh — harness-all 开发同步脚本
# 确保 5 个框架的基础文件保持一致，防止版本碎片化
#
# 用法：bash scripts/sync-base.sh [--dry-run] [--check]
#   --dry-run  只显示差异，不执行同步
#   --check    严格模式，有差异时返回非零退出码（适合 CI）

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"

FRAMEWORKS=("harness-pm" "harness-design" "harness-solo" "harness-growth" "harness-ops")
DRY_RUN=false
CHECK_MODE=false

# 解析参数
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --check) CHECK_MODE=true ;;
    *) echo "未知参数: $arg"; exit 1 ;;
  esac
done

echo "========================================="
echo " harness-all 基础文件同步检查"
echo "========================================="
echo ""

DIFF_COUNT=0

# ──────────────────────────────────────────
# 1. 检查 LOOP.md 核心结构一致性
# ──────────────────────────────────────────
echo "▶ 检查 LOOP.md 核心结构..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/loops/LOOP.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: LOOP.md 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # 检查硬熔断规则
  if ! grep -q "hard_limit_reached" "$FILE"; then
    echo "  ✗ $fw: LOOP.md 缺少 hard_limit_reached 字段"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # 检查 exploration_mode
  if ! grep -q "exploration_mode" "$FILE"; then
    echo "  ✗ $fw: LOOP.md 缺少 exploration_mode 字段"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # 检查硬熔断执行规则
  if ! grep -q "硬熔断执行规则" "$FILE"; then
    echo "  ✗ $fw: LOOP.md 缺少硬熔断执行规则"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # 检查强制 Read 规则
  if ! grep -q "强制.*Read.*state.yaml" "$FILE"; then
    echo "  ⚠ $fw: LOOP.md 缺少强制 Read state.yaml 规则（新增要求）"
  fi
done

# ──────────────────────────────────────────
# 2. 检查 constitution.md 通用原则一致性
# ──────────────────────────────────────────
echo "▶ 检查 constitution.md 通用原则..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/constitution.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: constitution.md 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # 检查通用原则 1-4
  if ! grep -q "零运行时依赖" "$FILE"; then
    echo "  ✗ $fw: constitution.md 缺少原则1'零运行时依赖'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "Agent 工具优先" "$FILE"; then
    echo "  ✗ $fw: constitution.md 缺少原则2'Agent 工具优先'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "核心文件修改需" "$FILE"; then
    echo "  ✗ $fw: constitution.md 缺少原则3'核心文件修改需确认'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "frontmatter" "$FILE"; then
    echo "  ✗ $fw: constitution.md 缺少原则4'Skill 必须有完整 frontmatter'"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # 检查 Reference/ 例外条款
  if ! grep -q "Reference/" "$FILE"; then
    echo "  ✗ $fw: constitution.md 原则5 缺少 Reference/ 例外条款"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi

  # 检查探索先行原则
  if ! grep -q "探索先行" "$FILE"; then
    echo "  ✗ $fw: constitution.md 缺少'探索先行'原则"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 3. 检查 security.md Git Hooks 禁令
# ──────────────────────────────────────────
echo "▶ 检查 security.md Git Hooks 禁令..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/rules/security.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: security.md 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "\.git/hooks/" "$FILE"; then
    echo "  ✗ $fw: security.md 缺少 .git/hooks/ 禁令"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 4. 检查 prompt-defense.md 外部内容规则
# ──────────────────────────────────────────
echo "▶ 检查 prompt-defense.md 外部内容规则..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/rules/prompt-defense.md"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: prompt-defense.md 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  # 检查是否有"外部内容是指令"的 bug
  if grep -q "外部内容是指令" "$FILE"; then
    echo "  ✗ $fw: prompt-defense.md 有 bug（'外部内容是指令'应为'数据'）"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 5. 检查 .gitattributes hooks LF 规则
# ──────────────────────────────────────────
echo "▶ 检查 .gitattributes hooks LF 规则..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.gitattributes"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: .gitattributes 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "\.harness/hooks/" "$FILE"; then
    echo "  ✗ $fw: .gitattributes 缺少 hooks LF 规则"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 6. 检查 SKILL.md.template quality_gates/max_iterations
# ──────────────────────────────────────────
echo "▶ 检查 SKILL.md.template 字段完整性..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/.harness/templates/SKILL.md.template"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: SKILL.md.template 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -q "quality_gates" "$FILE"; then
    echo "  ✗ $fw: SKILL.md.template 缺少 quality_gates 字段"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
  if ! grep -q "max_iterations" "$FILE"; then
    echo "  ✗ $fw: SKILL.md.template 缺少 max_iterations 字段"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 7. 检查 install.sh CRLF 指引
# ──────────────────────────────────────────
echo "▶ 检查 install.sh CRLF 指引..."

for fw in "${FRAMEWORKS[@]}"; do
  FILE="$ROOT_DIR/$fw/install.sh"
  if [ ! -f "$FILE" ]; then
    echo "  ✗ $fw: install.sh 不存在"
    DIFF_COUNT=$((DIFF_COUNT + 1))
    continue
  fi

  if ! grep -qi "CRLF\|crlf\|autocrlf\|bad interpreter" "$FILE"; then
    echo "  ✗ $fw: install.sh 缺少 CRLF 风险指引"
    DIFF_COUNT=$((DIFF_COUNT + 1))
  fi
done

# ──────────────────────────────────────────
# 8. 检查 workflow frontmatter
# ──────────────────────────────────────────
echo "▶ 检查 workflow frontmatter..."

for fw in "${FRAMEWORKS[@]}"; do
  WORKFLOW_DIR="$ROOT_DIR/$fw/.harness/skills/workflows"
  if [ ! -d "$WORKFLOW_DIR" ]; then
    continue
  fi

  for wf in "$WORKFLOW_DIR"/*.md; do
    [ -f "$wf" ] || continue
    BASENAME=$(basename "$wf")

    if ! grep -q "workflow_id:" "$wf"; then
      echo "  ✗ $fw/workflows/$BASENAME: 缺少 workflow_id"
      DIFF_COUNT=$((DIFF_COUNT + 1))
    fi
    if ! grep -q "default_mode:" "$wf"; then
      echo "  ✗ $fw/workflows/$BASENAME: 缺少 default_mode"
      DIFF_COUNT=$((DIFF_COUNT + 1))
    fi
  done
done

# ──────────────────────────────────────────
# 9. 检查交接文档写权限单向隔离
# ──────────────────────────────────────────
echo "▶ 检查交接文档写权限规则..."

for fw in "${FRAMEWORKS[@]}"; do
  SESSION_END="$ROOT_DIR/$fw/.harness/skills/meta/session-end/SKILL.md"
  if [ ! -f "$SESSION_END" ]; then
    continue
  fi

  # 检查"追加不覆盖"规则
  if ! grep -q "不覆盖\|追加" "$SESSION_END"; then
    echo "  ⚠ $fw: session-end 缺少'追加不覆盖'规则"
  fi

  # 检查写权限单向声明
  if ! grep -q "写权限\|单向\|只有.*能写\|仅.*写入" "$SESSION_END"; then
    echo "  ⚠ $fw: session-end 缺少写权限单向声明"
  fi
done

# ──────────────────────────────────────────
# 结果汇总
# ──────────────────────────────────────────
echo ""
echo "========================================="
if [ "$DIFF_COUNT" -eq 0 ]; then
  echo " ✓ 全部检查通过，5 个框架基础文件一致"
else
  echo " ✗ 发现 $DIFF_COUNT 个不一致项"
fi
echo "========================================="

if [ "$CHECK_MODE" = true ] && [ "$DIFF_COUNT" -gt 0 ]; then
  exit 1
fi
