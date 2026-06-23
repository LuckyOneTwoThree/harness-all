<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 1: 指标反推埋点映射表与输出

> 来源：SKILL.md「Step 1: 从指标体系反推埋点需求」中的反推映射表与输出 schema

## 反推映射表

| 指标类型 | 所需行为数据 | 埋点事件示例 |
|---------|------------|-------------|
| 转化率指标 | 页面/功能曝光+点击 | page_view + button_click |
| 频次指标 | 行为发生次数 | feature_use |
| 时长指标 | 行为开始+结束时间 | session_start + session_end |
| 质量指标 | 行为结果+评价 | action_result + feedback |
| 覆盖率指标 | 功能使用+未使用对比 | feature_use vs non_use |

## 输出

```json
{
  "metrics_to_track": [
    {
      "metric_name": "string",
      "required_behavior": "string",
      "proposed_event": {
        "event_name": "string",
        "trigger": "string",
        "required_properties": ["string"]
      }
    }
  ]
}
```
