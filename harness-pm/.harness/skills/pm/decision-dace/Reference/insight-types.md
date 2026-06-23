<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 洞察类型处理

## 异常洞察

```yaml
anomaly_insight:
  type: "anomaly"

  narrative: |
    ## 异常检测洞察

    今日发现：注册转化率从35%下降到32%。
    异常开始时间：今日9:00。
    影响用户数：约1.5万。

    最可能原因：v2.5.0版本中注册流程改动。
    置信度：85%。

    建议：立即检查新版本实现，准备回滚方案。

  action_options:
    - "立即回滚到上一版本"
    - "紧急修复后发布热更新"
    - "继续监控24小时"

  decision_boundary:
    type: "data_decision"
    auto_execute_eligible: true
    condition: "转化率继续下降超过5%"
```

## 漏斗洞察

```yaml
funnel_insight:
  type: "funnel_analysis"

  narrative: |
    ## 购买转化漏斗洞察

    漏斗整体转化率7.2%，较上周下降0.5个百分点。

    最大流失点：从浏览到加购，流失84%用户。
    流失主要集中在：价格敏感用户、Android端用户。

    建议优化方向：价格展示策略、加购引导话术。

  action_options:
    - "优化价格展示（显示折扣、对比）"
    - "增强加购引导（浮层、提示）"
    - "针对流失用户做调研"
```
