---
name: content-distribution
description: 将审查通过的内容适配多渠道分发版本（博客/公众号/社媒/邮件），一鱼多吃
triggers:
  - content-review通过后
  - 内容营销Loop的EXPERIMENT阶段（分发）
  - 用户要求"分发这篇内容"
reads:
  - docs/content/drafts/
  - docs/handoff/solo-to-growth.md
writes:
  - docs/content/published/
  - loops/specs/<content>/state.yaml
quality_gates: []
max_iterations: 2
---

# Content Distribution — 多渠道分发

## 铁律
- 每个渠道的版本必须**独立适配**，不是简单复制粘贴
- 必须保留原文的核心价值，但形式要匹配渠道特性
- 分发后必须记录发布信息（渠道/URL/日期），供 content-performance 追踪

## 流程

1. **读取审查通过的内容**
   从 `docs/content/drafts/` 读取已通过 content-review 的内容

2. **确定分发渠道矩阵**
   根据选题和目标受众，选择分发渠道：

   | 渠道 | 适配方向 | 目标 |
   |------|---------|------|
   | 博客/官网 | 完整长文 + SEO 优化 | 搜索流量 |
   | 公众号 | 适配阅读体验 + 引导关注 | 私域流量 |
   | 知乎 | 问答式 + 专业深度 | 搜索 + 社交 |
   | 小红书 | 图文 + 标题党 + 话题标签 | 社交分发 |
   | 抖音/视频号 | 视频脚本 + 口语化 | 视频流量 |
   | 邮件 Newsletter | 摘要 + 链接 + CTA | 用户触达 |
   | 社媒（Twitter/LinkedIn） | 短摘要 + 话题 + 链接 | 社交传播 |

3. **生成渠道适配版本**
   对每个渠道生成独立版本：

   ### 博客版（已有，直接使用审查通过的草稿）
   - 完整长文 + SEO 元数据 + Schema

   ### 公众号版
   - 标题适配（更吸引点击，但不标题党）
   - 段落更短（移动端阅读）
   - 加入引导关注的 CTA
   - 去除外链（公众号不支持外链，改为文末引用）

   ### 社媒版（Twitter/LinkedIn）
   - 3-5 条推文串（Thread）
   - 每条 < 280 字符（Twitter）/ 更长（LinkedIn）
   - 首条必须有 hook
   - 末条含链接 + CTA

   ### 邮件版
   - 主题行（< 50 字符，吸引打开）
   - 摘要（3-5 行，核心价值）
   - 阅读全文链接
   - 退订入口（合规要求）

4. **发布记录**
   每个渠道发布后记录：
   ```
   | 渠道 | 发布URL | 发布日期 | 版本路径 |
   |------|---------|---------|---------|
   | 博客 | https://... | 2026-06-21 | docs/content/published/C-001-blog.md |
   | 公众号 | https://... | 2026-06-21 | docs/content/published/C-001-wechat.md |
   ```

5. **写入发布目录**
   将各渠道版本写入 `docs/content/published/<content-id>-<channel>.md`
   更新 state.yaml：substage=distributed

## 渠道适配原则

| 原则 | 说明 |
|------|------|
| 核心价值不变 | 各渠道版本保留原文的核心洞察和价值 |
| 形式适配 | 段落长度/语气/CTA 匹配渠道特性 |
| 合规优先 | 每个渠道的版本也需符合该渠道的规则 |
| 可追踪 | 每个渠道版本含 UTM 参数（如可行） |

## 禁止事项
- 不简单复制粘贴到所有渠道（忽视渠道特性）
- 不发未审查的版本到任何渠道
- 不在社媒版本中含用户 PII
- 不忘记记录发布信息（content-performance 需要追踪）

## 与 LOOP 的关系
本 skill 在 LOOP(content) 的 **EXPERIMENT 阶段**执行（分发环节）。
PLAN → EXPERIMENT(creation → review → distribution) → MEASURE(performance)

## 与 Workflow 的关系
本 skill 是 **content-marketing-workflow** 的第 4 步。
content-review 通过 → **content-distribution** → [发布] → content-performance
