#!/bin/bash
# pre-push.sh — 推送前检查
# git hook 调用：在 .git/hooks/pre-push 软链或拷贝本文件
#
# 职责：推送前运行测试（如果有），防止破坏性推送

# CRLF 防御：Windows 下 core.autocrlf 可能导致脚本含 \r，Git Bash 无法执行
if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0")
fi

set -e

# 1. 防止 force push 到 main/master
# pre-push hook 通过 stdin 接收：<local ref> <local sha> <remote ref> <remote sha>
protected_branches="main master"
zero="0000000000000000000000000000000000000000"

while read -r local_ref local_sha remote_ref remote_sha; do
  # 跳过分支删除（local_sha 全 0）
  [ "$local_sha" = "$zero" ] && continue
  # 跳过新建分支（remote_sha 全 0，无历史可比）
  [ "$remote_sha" = "$zero" ] && continue

  for branch in $protected_branches; do
    if [ "$remote_ref" = "refs/heads/$branch" ]; then
      # 非快进 = force push：remote_sha 不是 local_sha 的祖先
      if ! git merge-base --is-ancestor "$remote_sha" "$local_sha" 2>/dev/null; then
        echo "BLOCK: 禁止 force push 到 $branch（非快进更新）"
        echo "  remote: $remote_sha"
        echo "  local:  $local_sha"
        exit 1
      fi
    fi
  done
done

# 2. 运行测试（如果项目有测试命令）
if [ -f "package.json" ]; then
  if grep -q '"test"' package.json 2>/dev/null; then
    echo "→ 运行测试..."
    npm test --silent 2>&1 | tail -20
    if [ ${PIPESTATUS[0]} -ne 0 ]; then
      echo "BLOCK: 测试未通过，禁止推送"
      exit 1
    fi
  fi
elif [ -f "pyproject.toml" ] || [ -f "pytest.ini" ]; then
  echo "→ 运行测试..."
  python -m pytest --tb=short 2>&1 | tail -20
  if [ ${PIPESTATUS[0]} -ne 0 ]; then
    echo "BLOCK: 测试未通过，禁止推送"
    exit 1
  fi
fi

# 3. 运行 verify-harness 健康检查（跨平台兜底）
# Windows 无 bash 时跳过，由 verify skill 在 IDE 内兜底
if [ -f ".harness/scripts/verify-harness.sh" ] && command -v bash >/dev/null 2>&1; then
  echo "→ verify-harness.sh 健康检查..."
  bash .harness/scripts/verify-harness.sh || {
    echo "WARN: harness 健康检查未通过（允许推送，但建议修复）"
  }
else
  echo "· 跳过 verify-harness.sh（无 bash 环境，由 verify skill 兜底）"
fi

echo "✓ pre-push 检查通过"
exit 0
