<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 2: Analyze（洞察生成）示例

## 2.1 数据收集与分析示例

自动收集和分析数据：

```yaml
analyze:
  status: "automated"
  execution_mode: "continuous"

  data_sources:
    - type: "metrics"
      name: "daily_metrics"
      frequency: "hourly"

    - type: "experiments"
      name: "ab_test_results"
      frequency: "on_completion"

    - type: "events"
      name: "product_events"
      frequency: "realtime"

  analyses_performed:
    - type: "anomaly_detection"
      findings:
        - metric: "dau_conversion"
          status: "warning"
          change: -3.2%
          reason: "注册流程改动影响"

    - type: "experiment_summary"
      findings:
        - experiment: "简化注册实验"
          result: "positive"
          lift: +8.2%

    - type: "funnel_analysis"
      findings:
        - funnel: "购买转化"
          conversion: 7.2%
          critical_drop: "step_1_to_2"
```

## 2.2 从数字到故事

```
数据分析 → 业务叙事
```

**转化原则**：

| 数据语言 | 业务语言 |
|---------|---------|
| 转化率下降3.2% | "每100个访客中，减少3个完成注册" |
| p值=0.001 | "这个结论有99.9%的可信度" |
| 置信区间[2%,5%] | "我们确信提升在2%到5%之间" |
| D7留存28.5% | "一周后，约3成用户仍在使用" |

**叙事模板**：

```yaml
narrative_template: |
  ## 洞察标题

  ### 背景
  [产品/功能]在[时间范围]的表现如何？

  ### 发现
  我们发现[核心数据变化]，这意味着[业务影响]。

  ### 影响
  如果不干预，预计[时间后][影响程度]。
  如果干预成功，预计[收益]。

  ### 建议
  基于数据，我们建议[具体行动]。
```

## 2.3 决策建议生成示例

生成多个可执行的决策选项：

```yaml
action_options:
  - option_id: "opt_001"
    option_name: "全量发布新功能"
    description: "将实验组的新注册流程全量发布"

    expected_effect:
      primary_metric: "+8.2% 注册转化率"
      secondary_metrics:
        - "注册用户数 +12%"
        - "整体DAU +2%"

    risk:
      level: "low"
      factors:
        - "护栏指标全部安全"
        - "效应稳定无新奇效应"
        - "可快速回滚"

    confidence:
      level: "high"
      basis:
        - "统计显著（p=0.001）"
        - "实验周期完整（14天）"
        - "样本量充足（24830）"

    resource_requirements:
      engineering: "2人日（发布部署）"
      qa: "1人日（回归测试）"

    timeline:
      ready_for_release: "2天后"

    prerequisites:
      - "技术评审通过"
      - "监控告警配置完成"

  - option_id: "opt_002"
    option_name: "分批发布"
    description: "先发布iOS，稳定后再发布Android"

    expected_effect:
      primary_metric: "+5.2% iOS注册转化率"
      secondary_metrics:
        - "Android效果待验证"

    risk:
      level: "medium"
      factors:
        - "Android效果不确定"
        - "维护两套逻辑"

    confidence:
      level: "medium"
      basis:
        - "iOS统计显著"
        - "Android效果不显著"
```

## 2.4 决策边界标注示例

区分不同类型的决策：

```yaml
decision_boundary:
  type: "data_decision"
  criteria:
    - "统计显著（p < 0.01）"
    - "实际意义显著（超过阈值）"
    - "护栏指标安全"
    - "无重大风险"
  auto_execute_eligible: true

  automation_level: "full"

  human_oversight:
    required: false
    notification_only: true

decision_boundary:
  type: "data_reference"
  criteria:
    - "数据支持某一选项"
    - "但存在不确定性"
    - "或涉及战略考量"
  auto_execute_eligible: false

  human_oversight:
    required: true
    decision_maker: "product_manager"
    deadline: "3 business days"
```

## 2.5 洞察汇总示例

```yaml
insights_gathered:
  - insight: "简化注册流程可提升新用户转化"
    confidence: "high"
    source: "ab_test"

  - insight: "加购环节流失率偏高"
    confidence: "medium"
    source: "funnel_analysis"

  - insight: "iOS留存表现优于Android"
    confidence: "high"
    source: "retention_analysis"
```
