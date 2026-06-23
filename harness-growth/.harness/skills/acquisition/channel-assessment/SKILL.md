---
name: channel-assessment
description: Channel assessment, prioritizing channels based on Product-Channel Fit
triggers:
  - When acquisition channels need to be selected
  - Acquisition campaign Workflow
  - User asks to "assess channels"
reads:
  - docs/handoff/pm-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/channel-assessment.md
quality_gates: []
max_iterations: 1
---

# Channel Assessment — Channel Assessment

## Iron Rules
- Channel selection is based on **Product-Channel Fit** — whether the product form matches channel user behavior
- Must assess **CAC vs LTV** — channels with CAC > LTV/3 are unsustainable
- Don't look only at traffic volume; focus on **conversion quality**

## Process

1. **Channel inventory**
   | Channel type | Specific channels | Suited products |
   |--------------|-------------------|-----------------|
   | SEO/Content | Blog/Official site | Informational products with long-tail demand |
   | Paid search | Google Ads/Baidu | Products with clear search intent |
   | Social ads | Facebook/TikTok/Xiaohongshu | Visual/consumer products |
   | Social media ops | WeChat Official Account/Zhihu/Twitter | Content/professional products |
   | Viral | Invite/share | Social/collaboration products |
   | Partnerships/BD | Resource exchange | B2B/platform products |
   | Community | WeChat groups/Discord | High-engagement products |

2. **Product-Channel Fit assessment**
   For each channel, assess:
   | Dimension | Score (1-5) | Notes |
   |-----------|-------------|-------|
   | User match | ? | Are channel users the target audience |
   | Behavior match | ? | Does channel user behavior fit the product |
   | Content match | ? | Is the product's content form suited to the channel |
   | Conversion path | ? | Is the path from channel to conversion short |

3. **CAC vs LTV assessment**
   | Channel | Estimated CAC | LTV | LTV/CAC | Assessment |
   |---------|---------------|-----|---------|------------|
   | SEO | ¥50 | ¥450 | 9.0 | ✅ Excellent |
   | Paid search | ¥150 | ¥450 | 3.0 | ✅ Acceptable |
   | Social ads | ¥300 | ¥450 | 1.5 | ❌ Below threshold |

   > LTV/CAC ≥ 3 is healthy, < 3 needs optimization, < 1 is loss-making

4. **Channel priority matrix**
   ```
   | Channel | PCF score | CAC | LTV/CAC | Priority | Reason |
   |---------|-----------|-----|---------|----------|--------|
   | SEO | 4.5 | ¥50 | 9.0 | P0 | High fit + low cost |
   | Paid search | 3.5 | ¥150 | 3.0 | P1 | Medium fit + acceptable |
   | Social ads | 2.5 | ¥300 | 1.5 | P2 | Low fit + high cost |
   ```

5. **Produce channel assessment report**
   Write to `docs/operations/channel-assessment.md`

## Prohibitions
- Don't select channels with poor PCF (traffic without conversion)
- Don't select channels with CAC > LTV/3 (loss-making acquisition)
- Don't rely on a single channel (diversify risk)
- Don't ignore CAC inflation after channel scaling

## Relationship to LOOP
This skill does not run inside LOOP; it is a **strategic-level** assessment.

## Relationship to Workflow
This skill is step 1 of acquisition campaign workflows.
