<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# DACE 状态追踪 / OKR 配置 / 自动触发机制

## DACE状态追踪

```yaml
dace_status:
  cycle_id: "dace_2024_Q1"
  current_phase: "Execute"

  phase_history:
    - phase: "Define"
      started: "2024-01-01"
      completed: "2024-01-05"
      output: "Q1 OKR体系"

    - phase: "Analyze"
      started: "2024-01-05"
      completed: "2024-01-15"
      output: "综合分析报告 + 故事化洞察"

    - phase: "Conclude"
      started: "2024-01-15"
      completed: "2024-01-18"
      output: "决策建议 + 审批"

    - phase: "Execute"
      started: "2024-01-18"
      status: "in_progress"
      output: "追踪结果"

  insights:
    total_insights: 12
    actionable: 8
    implemented: 3
    pending: 5

  action_taken:
    total_actions: 3
    completed: 1
    in_progress: 1
    pending: 1

  results_tracked:
    active_tracking: 2
    target_achieved: 0
    target_at_risk: 0
    target_on_track: 2
```

## 自动触发机制

| 触发条件 | DACE响应 |
|---------|---------|
| OKR更新 | 重新Define |
| 异常检测 | 优先Analyze，触发Conclude |
| 实验完成 | Analyze结果，触发Conclude |
| 决策执行 | 进入Execute追踪 |
| 周期结束 | 完成当前循环，准备下一周期 |

## OKR追踪配置

```yaml
okr_tracking:
  cycle: "quarterly"
  current_cycle: "2024_Q1"

  update_frequency:
    progress: "daily"
    review: "weekly"
    recalibration: "monthly"

  alert_rules:
    - condition: "KR进度落后 > 20%"
      severity: "high"
      action: "触发Conclude"

    - condition: "KR无法完成"
      severity: "critical"
      action: "升级 + OKR调整"
```
