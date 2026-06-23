<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 6: PRD 埋点方案一致性校验

> 来源：SKILL.md「Step 6: PRD埋点方案一致性校验」中 6.1~6.4 全部内容

## 6.1 双向校验机制 [条件]

**正向校验**：PRD功能 → 埋点覆盖

```
FOR each functional_requirement in PRD:
  1. 识别该功能对应的埋点
  2. IF 埋点缺失 THEN 标记为未覆盖
  3. 计算正向覆盖率
```

**逆向校验**：埋点 → PRD功能

```
FOR each tracking_event:
  1. 识别该埋点支持的功能分析
  2. IF 功能不在PRD中 THEN 标记为额外埋点
  3. 计算逆向覆盖率
```

---

## 6.2 PRD特征提取 [条件]

**特征类型**：

| 特征类型 | 识别关键词 | 埋点需求 |
|---------|-----------|---------|
| 页面 | 页面、模块、Tab | page_view + 页面属性 |
| 按钮 | 点击、按下、触发 | button_click + 按钮属性 |
| 表单 | 填写、输入、提交 | input + form_submit |
| 列表 | 列表、浏览、翻页 | list_view + item_click |
| 详情 | 详情、查看、内容 | detail_view + 详情属性 |
| 流程 | 流程、步骤、完成 | flow_start + flow_complete |
| 异常 | 失败、错误、超时 | error + 错误详情 |

---

## 6.3 一致性评分 [条件]

**评分规则**：

```python
def calculate_prd_consistency_score():
    forward_coverage = calculate_forward_coverage()  # PRD→埋点
    backward_coverage = calculate_backward_coverage()  # 埋点→PRD

    consistency_score = (
        0.6 * forward_coverage +  # 正向权重60%
        0.4 * backward_coverage   # 逆向权重40%
    )

    return {
        "forward_coverage": forward_coverage,
        "backward_coverage": backward_coverage,
        "consistency_score": consistency_score,
        "status": "pass" if consistency_score >= 0.9 else "fail"
    }
```

---

## 6.4 持续校验机制 [深度]

**触发时机**：

| 触发类型 | 触发条件 | 校验内容 |
|---------|---------|---------|
| PRD变更触发 | PRD文档更新 | 新增功能是否已埋点 |
| 埋点变更触发 | 埋点方案更新 | 变更是否影响PRD覆盖 |
| 定期校验 | 每周/每月 | 全量一致性检查 |
| 上线前校验 | 发布前 | 变更部分专项校验 |

**校验输出**：

```json
{
  "prd_consistency": {
    "forward_coverage": 0.92,
    "backward_coverage": 0.88,
    "consistency_score": 0.90,
    "status": "pass",
    "discrepancies": [
      {
        "type": "uncovered_function",
        "description": "商品分享功能未配置埋点",
        "prd_reference": "PRD章节3.2",
        "severity": "high",
        "suggested_event": "product_share"
      }
    ]
  }
}
```
