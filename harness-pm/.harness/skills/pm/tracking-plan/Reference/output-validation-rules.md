<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输出字段校验规则表

> 来源：SKILL.md「输出校验规则」章节中的字段校验规则表

## 输出校验规则

| 字段路径 | 类型 | 必填 | 说明 |
|----------|------|------|------|
| tracking_plan | array | 是 | 埋点事件列表 |
| tracking_plan[].event_name | string | 是 | 事件名称，小写下划线格式 |
| tracking_plan[].display_name | string | 是 | 事件显示名称 |
| tracking_plan[].trigger | object | 是 | 触发条件定义 |
| tracking_plan[].trigger.description | string | 是 | 触发描述 |
| tracking_plan[].trigger.timing | string | 是 | 触发时机，枚举值：on_action/immediate/on_exit |
| tracking_plan[].properties | array | 是 | 属性列表 |
| tracking_plan[].properties[].name | string | 是 | 属性名称 |
| tracking_plan[].properties[].type | string | 是 | 属性类型 |
| tracking_plan[].properties[].required | boolean | 是 | 是否必填 |
| tracking_plan[].analysis_purpose | string | 是 | 分析目的 |
| tracking_plan[].linked_metric | string | 是 | 关联指标 |
| tracking_plan[].priority | string | 是 | 优先级，枚举值：high/medium/low |
| tracking_plan[].status | string | 是 | 状态，枚举值：pending/approved/implemented |
| quality_check | object | 是 | 质量检查结果 |
| quality_check.naming_compliance | boolean | 是 | 命名规范是否通过 |
| quality_check.property_completeness | number | 是 | 属性完整率，≥0.8 |
| quality_check.core_path_coverage | number | 是 | 核心路径覆盖率，≥0.9 |
| quality_check.prd_consistency | object | 是 | PRD一致性校验结果 |
