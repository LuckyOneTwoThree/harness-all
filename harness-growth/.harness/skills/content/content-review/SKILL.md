---
name: content-review
description: 内容评审与事实核查，独立于创作的Reviewer模式，检查合规/事实/品牌/SEO
triggers:
  - content-creation产出草稿后
  - 内容发布前的质量门
  - 用户要求"审查这篇内容"
reads:
  - docs/content/drafts/
  - rules/security.md
  - SOUL.md
  - constitution.md
writes:
  - docs/content/drafts/<content-id>.review.md
  - loops/specs/<content>/state.yaml
  - loops/specs/<content>/iterations.log
quality_gates: []
max_iterations: 2
---

# Content Review — 内容评审

## 铁律
- 本 skill 是**独立审查者**，不修改内容，只产出审查意见
- 审查必须覆盖四个维度：合规 / 事实 / 品牌 / SEO
- 审查不通过的内容**不可发布**，必须退回 content-creation 修改
- 审查意见必须具体可执行（指出问题 + 给出修改建议）

## 流程

1. **读取草稿**
   从 `docs/content/drafts/` 读取待审查内容

2. **合规审查**
   - 广告法违规词（最/第一/国家级/极致等绝对化用语）
   - 行业合规（医疗/金融/教育等特殊行业限制词）
   - 平台规则（如公众号/小红书的内容规范）
   - 隐私合规（不含用户 PII，数据脱敏）
   - 版权合规（引用来源标注，图片授权）

3. **事实核查**
   - 数据/统计是否标注来源？
   - 引用是否准确（非断章取义）？
   - 案例是否真实（非虚构）？
   - 技术信息是否准确（非误导）？
   - 标注"需核实"的不确定信息

4. **品牌一致性**
   - 语气是否符合品牌 voice（SOUL.md 定义）？
   - 价值观是否与 constitution.md 一致？
   - 术语是否统一（产品名/功能名/行业术语）？
   - CTA 是否与当前产品状态匹配？

5. **SEO 质量检查**
   - 目标关键词密度（1-2% 为宜，>3% 算堆砌）
   - Heading 层级是否正确（H1 唯一，H2/H3 层次）
   - Meta Description 是否含关键词 + CTA
   - 内链数量（3-5 个为宜）
   - 图片 Alt 文本是否完整
   - URL 是否含关键词
   - 可读性（Flesch 分数 > 60）

6. **产出审查报告**
   写入 `docs/content/drafts/<content-id>.review.md`：
   ```markdown
   # 内容审查: <content-id>

   ## 审查结论: [通过/需修改/需重写]

   ## 合规审查
   | 检查项 | 结果 | 问题 | 建议 |
   |--------|------|------|------|
   | 广告法 | ✅/❌ | [问题] | [建议] |
   | 行业合规 | ✅/❌ | | |
   | 隐私 | ✅/❌ | | |
   | 版权 | ✅/❌ | | |

   ## 事实核查
   | 声明 | 来源 | 可信度 | 建议 |
   |------|------|--------|------|
   | [数据/声明] | [来源/无] | 高/中/低 | [建议] |

   ## 品牌一致性
   - 语气: ✅/❌ [说明]
   - 价值观: ✅/❌
   - 术语: ✅/❌

   ## SEO 质量
   - 关键词密度: X% [✅/⚠️ 偏高/偏低]
   - Heading: [✅/❌]
   - Meta: [✅/❌]
   - 内链: X 个 [✅/⚠️]
   - 可读性: Flesch XX [✅/❌]

   ## 修改建议（如需修改）
   1. [具体问题 + 修改建议]
   2. [具体问题 + 修改建议]
   ```

7. **更新 state.yaml**
   - 审查通过：substage=review-passed
   - 审查不通过：status=retrying, last_error=审查未通过，退回修改
   - 追加 iterations.log

## 审查决策标准

| 情况 | 决策 |
|------|------|
| 四维度全通过 | **通过**，可进入 content-distribution |
| 合规有违规 | **需修改**，必须修复合规问题 |
| 事实有错误 | **需修改**，必须修正或标注来源 |
| 品牌不一致 | **需修改**，调整语气/术语 |
| SEO 不达标 | **需优化**，调整关键词/结构 |
| 多维度严重问题 | **需重写**，退回 content-creation |

## 禁止事项
- 不直接修改内容（只产出审查意见）
- 不跳过合规检查（合规是底线）
- 不放宽标准（"差不多就行"不是通过理由）
- 不在审查报告中含糊（"有点问题"不算建议）

## 与 LOOP 的关系
本 skill 在 LOOP(content) 的 **MEASURE 阶段**执行（作为质量门）。
PLAN → EXPERIMENT(content-creation) → MEASURE(content-review) → 通过? content-distribution : 回到 content-creation

## 与 Workflow 的关系
本 skill 是 **content-marketing-workflow** 的第 3 步（质量门）。
content-creation → **content-review** → content-distribution
