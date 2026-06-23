#!/bin/bash
# install.sh — harness-pm 冷启动安装脚本
#
# 用法（两步安装，符合安全规则——不用 curl | bash）：
#   curl -o install.sh https://raw.githubusercontent.com/<user>/harness-pm/main/install.sh
#   # 审查 install.sh 内容
#   bash install.sh
#
# 作用：初始化 .harness/ 框架到当前项目，配置 PM 工作环境

set -e

echo "=== harness-pm 冷启动安装 ==="
echo ""

# 检查当前目录是否已有 .harness/
if [ -d ".harness" ]; then
  echo "BLOCK: 当前目录已存在 .harness/，似乎已初始化"
  echo "如需重新安装，请先删除 .harness/ 或换目录"
  exit 1
fi

# 检查是否在 harness-pm 仓库自身内（通过判断 .harness/skills/pm/ 是否存在）
if [ -d ".harness/skills/pm" ] && [ -f "AGENTS.md" ]; then
  echo "检测到当前在 harness-pm 仓库内，跳过克隆，直接初始化"
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  TEMPLATE_DIR="$SCRIPT_DIR"
else
  # 检查 git
  if ! command -v git >/dev/null 2>&1; then
    echo "BLOCK: 未找到 git，请先安装 Git"
    exit 1
  fi

  REPO_URL="https://github.com/LuckyOneTwoThree/harness-pm.git"
  TEMPLATE_BRANCH="main"
  TEMP_DIR=".harness-pm-tmp-$$"

  # 浅克隆模板仓库到临时目录
  echo "→ 克隆模板仓库..."
  git clone --depth 1 -b "$TEMPLATE_BRANCH" "$REPO_URL" "$TEMP_DIR" 2>/dev/null || {
    echo "BLOCK: 克隆失败，检查网络或仓库地址: $REPO_URL"
    exit 1
  }
  TEMPLATE_DIR="$TEMP_DIR"
fi

# 复制 .harness/ 到当前目录（含 pm skill）
echo "→ 复制 .harness/ 框架..."
cp -r "$TEMPLATE_DIR/.harness" .harness
echo "  ✓ 复制 .harness/skills/pm/（82 个 PM skill）"

# 复制 AGENTS.md 和 SOUL.md 模板（如果不存在）
if [ ! -f "AGENTS.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/AGENTS.md.template" AGENTS.md
  echo "  ✓ 创建 AGENTS.md（从模板，请填 [项目名称]）"
fi
if [ ! -f "SOUL.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/SOUL.md.template" SOUL.md
  echo "  ✓ 创建 SOUL.md（从模板，请填 [用户名] 和产品偏好）"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ 创建 constitution.md（从模板）"
fi

# 创建 docs/ 目录结构（PM 框架需要的目录）
echo "→ 创建 docs/ 目录..."
mkdir -p docs/discovery docs/strategy docs/product docs/metrics docs/growth docs/monitoring docs/project docs/handoff

# 从模板初始化 PRODUCT_STRATEGY.md（如不存在）
if [ ! -f "docs/strategy/PRODUCT_STRATEGY.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/PRODUCT_STRATEGY.md.template" docs/strategy/PRODUCT_STRATEGY.md
  echo "  ✓ 初始化 docs/strategy/PRODUCT_STRATEGY.md（从模板，请填写产品策略）"
fi

# 从模板初始化 PRD.md 骨架（如不存在）
if [ ! -f "docs/product/PRD.md" ]; then
  cp "$TEMPLATE_DIR/.harness/templates/PRD.md.template" docs/product/PRD.md
  echo "  ✓ 初始化 docs/product/PRD.md（骨架，待 design-prd skill 填充）"
fi

# 复制交接文档模板
if [ -d "$TEMPLATE_DIR/docs/handoff" ]; then
  cp -r "$TEMPLATE_DIR/docs/handoff/." docs/handoff/ 2>/dev/null || true
  echo "  ✓ 复制 docs/handoff/ 交接协议文档"
fi

# 创建运行时目录（不提交，但运行时需要存在）
echo "→ 创建运行时目录..."
mkdir -p .harness/memory/archives .harness/loops/specs .harness/gates
mkdir -p output/approvals output/phase-reports output/metrics

# 从模板初始化 progress.md（如果不存在）
if [ ! -f ".harness/memory/progress.md" ]; then
  cp .harness/templates/progress.md.template .harness/memory/progress.md
  echo "  ✓ 初始化 .harness/memory/progress.md"
fi

# 清理临时目录（安全方式：校验路径前缀后使用 rm -r）
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-pm-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
fi

echo ""
echo "✓ 安装完成"
echo ""
echo "下一步："
echo "  1. 编辑 constitution.md，填写项目特定原则"
echo "  2. 编辑 SOUL.md 的 [用户名] 和产品偏好"
echo "  3. 让 AI Agent 读取 AGENTS.md 开始工作"
echo "  4. 运行 setup 工作流引导填写 PRODUCT_STRATEGY.md"
echo ""
echo "提示："
echo "  - .harness/skills/pm/ 目录包含 82 个 PM skill"
echo "  - 对 Agent 说'我要做一个新产品'进入 new-product 工作流"
echo "  - 对 Agent 说'已有产品需要迭代'进入 iteration 工作流"
echo ""
echo "⚠️ Windows CRLF 指引："
echo "  Windows 环境下 core.autocrlf=true 会导致 .sh 脚本变成 CRLF，"
echo "  Git Bash 执行 CRLF 脚本会报错 /bin/bash^M: bad interpreter"
echo "  解决方案："
echo "    1. git config core.autocrlf false（关闭自动转换）"
echo "    2. 或在项目根目录添加 .gitattributes 强制 *.sh 使用 LF（推荐）"
echo ""
