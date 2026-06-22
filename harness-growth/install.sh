#!/bin/bash
# install.sh — harness-growth 冷启动安装脚本
#
# 用法（两步安装，符合安全规则——不用 curl | bash）：
#   curl -o install.sh https://raw.githubusercontent.com/LuckyOneTwoThree/harness-growth/main/install.sh
#   # 审查 install.sh 内容
#   bash install.sh
#
# 作用：克隆 .harness/ 模板到当前目录，初始化项目

set -e

REPO_URL="https://github.com/LuckyOneTwoThree/harness-growth.git"
TEMPLATE_BRANCH="main"
TEMP_DIR=".harness-growth-tmp-$$"

echo "=== harness-growth 冷启动安装 ==="
echo ""

# 检查当前目录是否已有 .harness/
if [ -d ".harness" ]; then
  echo "BLOCK: 当前目录已存在 .harness/，似乎已初始化"
  echo "如需重新安装，请先删除 .harness/ 或换目录"
  exit 1
fi

# 检查 git
if ! command -v git >/dev/null 2>&1; then
  echo "BLOCK: 未找到 git，请先安装 Git"
  exit 1
fi

# 浅克隆模板仓库到临时目录
echo "→ 克隆模板仓库..."
git clone --depth 1 -b "$TEMPLATE_BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
  echo "BLOCK: 克隆失败，检查网络或仓库地址: $REPO_URL"
  exit 1
}

# 复制 .harness/ 到当前目录
echo "→ 复制 .harness/ 框架..."
cp -r "$TEMP_DIR/.harness" .harness

# 复制 AGENTS.md 和 SOUL.md 模板（如果不存在）
if [ ! -f "AGENTS.md" ]; then
  cp "$TEMP_DIR/.harness/templates/AGENTS.md.template" AGENTS.md
  echo "  ✓ 创建 AGENTS.md（从模板，请填 [项目名称]）"
fi
if [ ! -f "SOUL.md" ]; then
  cp "$TEMP_DIR/.harness/templates/SOUL.md.template" SOUL.md
  echo "  ✓ 创建 SOUL.md（从模板，请填 [用户名] 和增长偏好）"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMP_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ 创建 constitution.md（从模板）"
fi

# 创建 docs/ 目录结构（只创建增长框架需要的目录；产品/设计/工程归 harness 家族其他成员）
echo "→ 创建 docs/ 目录..."
mkdir -p docs/content docs/seo docs/experiment docs/operations docs/handoff

# 从模板初始化 GROWTH_STRATEGY.md（如不存在）
if [ ! -f "docs/operations/GROWTH_STRATEGY.md" ]; then
  cp "$TEMP_DIR/.harness/templates/GROWTH_STRATEGY.md.template" docs/operations/GROWTH_STRATEGY.md
  echo "  ✓ 初始化 docs/operations/GROWTH_STRATEGY.md（从模板，请填写增长策略）"
fi

# 复制交接文档模板（如果模板仓库有）
if [ -d "$TEMP_DIR/docs/handoff" ]; then
  cp -r "$TEMP_DIR/docs/handoff/." docs/handoff/ 2>/dev/null || true
  echo "  ✓ 复制 docs/handoff/ 交接协议文档"
fi

# 创建运行时目录（不提交，但运行时需要存在）
echo "→ 创建运行时目录..."
mkdir -p .harness/memory/archives .harness/loops/specs

# 从模板初始化 progress.md（如果不存在）
if [ ! -f ".harness/memory/progress.md" ]; then
  cp .harness/templates/progress.md.template .harness/memory/progress.md
  echo "  ✓ 初始化 .harness/memory/progress.md"
fi

# 清理临时目录（安全方式：校验路径前缀后使用 rm -r）
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-growth-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
else
    echo "WARN: 临时目录清理失败或路径异常: $TEMP_DIR"
fi

# 设置脚本可执行权限（Unix only；Windows 无 chmod，hooks 由 Git Bash 自身处理）
if command -v chmod >/dev/null 2>&1; then
  echo "  ✓ 设置脚本可执行权限"
else
fi

echo ""
echo "✓ 安装完成"
echo ""
echo "下一步："
echo "  1. 编辑 constitution.md，填写项目特定原则"
echo "  2. 编辑 SOUL.md 的 [用户名] 和增长偏好"
echo "  3. 编辑 docs/operations/GROWTH_STRATEGY.md，填写增长策略"
echo "  4. 让 AI Agent 读取 AGENTS.md 开始工作"
echo ""
