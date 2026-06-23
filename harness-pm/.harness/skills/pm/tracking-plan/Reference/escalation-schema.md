<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 升级输出 Schema

> 来源：SKILL.md「升级路径 → 升级输出」中的升级输出 schema

## 升级输出

```json
{
  "escalation": {
    "trigger": "string",
    "reason": "string",
    "affected_events": ["string"],
    "ai_recommendation": {},
    "requires_human_action": true,
    "human_decision_needed": [
      "业务逻辑确认",
      "隐私合规确认",
      "埋点优先级调整"
    ]
  }
}
```
