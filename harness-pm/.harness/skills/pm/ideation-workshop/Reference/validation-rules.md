<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输出校验规则

| 字段路径 | 类型 | 必填 | 说明 |
|----------|------|------|------|
| hmw_ideas | object | 是 | HMW产出 |
| hmw_ideas.hmw_statements | array | 是 | HMW陈述列表 |
| hmw_ideas.hmw_statements[].id | string | 是 | HMW唯一标识 |
| hmw_ideas.hmw_statements[].statement | string | 是 | HMW陈述文本 |
| hmw_ideas.hmw_statements[].dimension | string | 是 | 所属维度（remove/reduce/accelerate/amplify/expand/rethink） |
| hmw_ideas.hmw_statements[].source_problem | string | 是 | 关联的核心问题 |
| hmw_ideas.hmw_statements[].source_data | object | 是 | 来源的用户研究数据 |
| hmw_ideas.hmw_statements[].divergence_potential | integer | 是 | 发散潜力评分（1-5） |
| hmw_ideas.hmw_statements[].quality_check | string | 是 | 质量检查结果（passed/failed） |
| hmw_ideas.hmw_statements[].quality_issues | array | 是 | 质量问题列表 |
| hmw_ideas.hmw_statements[].related_dimensions | array | 是 | 关联的其他维度 |
| hmw_ideas.summary | object | 是 | HMW统计摘要 |
| scamper_ideas | object | 是 | SCAMPER产出 |
| scamper_ideas.solutions | array | 是 | 方案列表，至少10个 |
| scamper_ideas.solutions[].id | string | 是 | 方案唯一标识 |
| scamper_ideas.solutions[].source_hmw | object | 是 | 来源HMW陈述 |
| scamper_ideas.solutions[].scamper_dimension | string | 是 | SCAMPER维度 |
| scamper_ideas.solutions[].solution | string | 是 | 方案标题 |
| scamper_ideas.solutions[].description | string | 是 | 方案详细描述 |
| scamper_ideas.solutions[].innovation_score | integer | 是 | 创新度评分（1-5） |
| scamper_ideas.solutions[].feasibility_score | integer | 是 | 可行性评分（1-5） |
| scamper_ideas.solutions[].impact_score | integer | 是 | 影响力评分（1-5） |
| scamper_ideas.solutions[].risk_score | integer | 是 | 风险度评分（1-5） |
| scamper_ideas.solutions[].key_assumption | string | 是 | 关键假设 |
| scamper_ideas.solutions[].cluster | string | 是 | 所属聚类ID |
| scamper_ideas.clusters | array | 是 | 聚类列表 |
| scamper_ideas.clusters[].cluster_id | string | 是 | 聚类ID |
| scamper_ideas.clusters[].cluster_name | string | 是 | 聚类名称 |
| scamper_ideas.clusters[].solution_ids | array | 是 | 聚类内方案ID列表 |
| scamper_ideas.summary | object | 是 | SCAMPER统计摘要 |
| inversion_ideas | object | 是 | 反转思维产出 |
| inversion_ideas.inversion_analysis | array | 是 | 逆转分析列表，至少10条 |
| inversion_ideas.inversion_analysis[].id | string | 是 | 唯一标识符 |
| inversion_ideas.inversion_analysis[].failure_mode | string | 是 | 失败模式描述 |
| inversion_ideas.inversion_analysis[].severity | integer | 是 | 严重程度（1-5） |
| inversion_ideas.inversion_analysis[].likelihood | integer | 是 | 发生可能性（1-5） |
| inversion_ideas.inversion_analysis[].risk_score | integer | 是 | 风险评分（severity × likelihood） |
| inversion_ideas.inversion_analysis[].priority | string | 是 | 优先级（critical/high/medium/low） |
| inversion_ideas.inversion_analysis[].success_condition | string | 是 | 成功条件 |
| inversion_ideas.inversion_analysis[].design_constraints | array | 是 | 设计约束数组 |
| inversion_ideas.inversion_analysis[].design_constraints[].constraint | string | 是 | 约束描述 |
| inversion_ideas.inversion_analysis[].design_constraints[].category | string | 是 | 约束类别 |
| inversion_ideas.inversion_analysis[].design_constraints[].verifiable | boolean | 是 | 是否可验证 |
| inversion_ideas.inversion_analysis[].design_constraints[].verification_method | string | 是 | 验证方法 |
| inversion_ideas.summary | object | 是 | 反转思维统计摘要 |
| converged_ideas | object | 是 | 收敛产出 |
| converged_ideas.converged_solutions | array | 是 | 收敛后的方案列表，至少5个 |
| converged_ideas.converged_solutions[].id | string | 是 | 方案唯一标识 |
| converged_ideas.converged_solutions[].title | string | 是 | 方案标题 |
| converged_ideas.converged_solutions[].detailed_description | object | 是 | 详细方案描述 |
| converged_ideas.converged_solutions[].interaction_flow | object | 是 | 交互流程设计 |
| converged_ideas.converged_solutions[].assumptions | object | 是 | 关键假设 |
| converged_ideas.converged_solutions[].risks | object | 是 | 风险识别 |
| converged_ideas.converged_solutions[].mvp_scope | object | 是 | MVP范围定义 |
| converged_ideas.converged_solutions[].success_metrics | object | 是 | 成功指标 |
| converged_ideas.comparison_matrix | object | 是 | 对比矩阵 |
| converged_ideas.comparison_matrix.dimensions | array | 是 | 对比维度定义，6个维度 |
| converged_ideas.comparison_matrix.solutions | array | 是 | 各方案对比数据 |
| converged_ideas.comparison_matrix.recommendations | object | 是 | AI推荐结果 |
| converged_ideas.human_decision_package | object | 是 | 人类决策包 |
| converged_ideas.human_decision_package.approval_required | boolean | 是 | 是否需要人类审批 |
