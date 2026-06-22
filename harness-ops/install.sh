#!/bin/bash
# install.sh — harness-ops 冷启动安装脚本
#
# 用法（两步安装，符合安全规则——不用 curl | bash）：
#   curl -o install.sh https://raw.githubusercontent.com/LuckyOneTwoThree/harness-ops/main/install.sh
#   # 审查 install.sh 内容
#   bash install.sh
#
# 作用：克隆 .harness/ 模板到当前目录，初始化运维项目

set -e

REPO_URL="https://github.com/LuckyOneTwoThree/harness-ops.git"
TEMPLATE_BRANCH="main"
TEMP_DIR=".harness-ops-tmp-$$"

echo "=== harness-ops 冷启动安装 ==="
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

# 运维工具链检查（WARN 不阻塞安装，按实际栈选用）
if ! command -v terraform >/dev/null 2>&1; then
  echo "WARN: 未找到 terraform。IaC 相关 skill 强依赖 Terraform（建议 v1.5+）。"
  echo "      如使用其他 IaC 工具（Pulumi/Ansible），可忽略此提示。"
fi
if ! command -v kubectl >/dev/null 2>&1; then
  echo "WARN: 未找到 kubectl。Kubernetes 部署相关 skill 需要 kubectl。"
fi
if ! command -v docker >/dev/null 2>&1; then
  echo "WARN: 未找到 docker。容器化部署/镜像构建相关 skill 需要 Docker。"
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
  echo "  ✓ 创建 SOUL.md（从模板，请填 [运维负责人] 和技术偏好）"
fi
if [ ! -f "constitution.md" ]; then
  cp "$TEMP_DIR/.harness/templates/constitution.md.template" constitution.md
  echo "  ✓ 创建 constitution.md（从模板，填写项目级运维原则）"
fi

# 创建 docs/ 目录结构（运维四域 + 交接协议）
echo "→ 创建 docs/ 目录..."
mkdir -p docs/infrastructure docs/monitoring docs/incident docs/deployment docs/handoff

# 从模板初始化 OPS_STRATEGY.md（运维战略总纲，如不存在）
if [ ! -f "docs/infrastructure/OPS_STRATEGY.md" ]; then
  cp "$TEMP_DIR/.harness/templates/OPS_STRATEGY.md.template" docs/infrastructure/OPS_STRATEGY.md
  echo "  ✓ 初始化 docs/infrastructure/OPS_STRATEGY.md（从模板，请填写架构拓扑/部署规范/监控矩阵/容灾预案）"
fi

# 复制交接文档模板（如果模板仓库有）
if [ -d "$TEMP_DIR/docs/handoff" ]; then
  cp -r "$TEMP_DIR/docs/handoff/." docs/handoff/ 2>/dev/null || true
  echo "  ✓ 复制 docs/handoff/ 交接协议文档（solo-to-ops / ops-to-pm）"
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
if [ -n "$TEMP_DIR" ] && [ -d "$TEMP_DIR" ] && [[ "$TEMP_DIR" == .harness-ops-tmp-* ]]; then
    rm -r -- "$TEMP_DIR"
else
    echo "WARN: 临时目录清理失败或路径异常: $TEMP_DIR"
fi

# 设置脚本可执行权限（Unix only；Windows 无 chmod，由 Git Bash 自身处理）
if command -v chmod >/dev/null 2>&1; then
  echo "  ✓ 设置脚本可执行权限"
else
fi

echo ""
echo "✓ 安装完成"
echo ""
echo "下一步："
echo "  1. 编辑 constitution.md，填写项目级运维原则（破坏性变更保护/监控先行等）"
echo "  2. 编辑 SOUL.md 的 [运维负责人] 和技术偏好"
echo "  3. 编辑 docs/infrastructure/OPS_STRATEGY.md，填写架构拓扑/部署规范/监控矩阵/容灾预案"
echo "  4. 让 AI Agent 读取 AGENTS.md 开始工作"
echo ""
