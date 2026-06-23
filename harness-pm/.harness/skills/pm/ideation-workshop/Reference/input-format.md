<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输入格式

```json
{
  "problem_statement": "需要解决的核心问题描述",
  "user_research_data": {
    "interviews": [
      {
        "user_id": "用户标识",
        "quotes": ["用户原话引用"],
        "pain_points": ["痛点描述"],
        "context": "使用场景"
      }
    ],
    "surveys": [
      {
        "question": "调研问题",
        "responses": ["用户回答"],
        "insights": ["关键洞察"]
      }
    ],
    "behavior_data": {
      "metrics": "行为数据指标",
      "patterns": ["用户行为模式"]
    }
  },
  "current_solution": {
    "description": "当前产品方案的详细描述",
    "features": ["功能1", "功能2"],
    "limitations": ["当前方案的局限性"]
  },
  "competitor_solutions": [
    {
      "competitor_name": "竞品名称",
      "solution_description": "竞品方案描述",
      "key_features": ["关键功能1", "关键功能2"],
      "strengths": ["优势1", "优势2"],
      "weaknesses": ["劣势1", "劣势2"]
    }
  ],
  "product_context": {
    "strategic_goals": ["战略目标1", "战略目标2"],
    "resource_constraints": ["资源约束1", "资源约束2"],
    "timeline": "时间限制",
    "risk_tolerance": "风险偏好"
  }
}
```
