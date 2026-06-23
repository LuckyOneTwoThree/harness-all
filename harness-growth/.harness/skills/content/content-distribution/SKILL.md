---
name: content-distribution
description: Adapt reviewed content into multi-channel distribution versions (blog/WeChat Official Account/social/email), repurposing one piece across channels
triggers:
  - After content-review passes
  - EXPERIMENT phase of the content marketing Loop (distribution)
  - User asks to "distribute this content"
reads:
  - docs/content/drafts/
  - docs/handoff/solo-to-growth.md
writes:
  - docs/content/published/
  - loops/specs/<content>/state.yaml
quality_gates: []
max_iterations: 2
---

# Content Distribution — Multi-Channel Distribution

## Iron Rules
- Each channel version must be **independently adapted**, not a simple copy-paste
- Must preserve the core value of the original, but the form must match channel characteristics
- After distribution, must record publish info (channel / URL / date) for content-performance tracking

## Process

1. **Read reviewed content**
   Read content that has passed content-review from `docs/content/drafts/`

2. **Determine distribution channel matrix**
   Based on the topic and target audience, select distribution channels:

   | Channel | Adaptation direction | Goal |
   |---------|----------------------|------|
   | Blog/Official site | Full long-form + SEO optimization | Search traffic |
   | WeChat Official Account | Adapted reading experience + follow prompt | Private domain traffic |
   | Zhihu | Q&A style + professional depth | Search + social |
   | Xiaohongshu | Image + text + click-worthy title + topic tags | Social distribution |
   | TikTok/Video accounts | Video script + conversational tone | Video traffic |
   | Email Newsletter | Summary + link + CTA | User reach |
   | Social (Twitter/LinkedIn) | Short summary + topic + link | Social spread |

3. **Generate channel-adapted versions**
   For each channel, generate an independent version:

   ### Blog version (already exists; use the reviewed draft directly)
   - Full long-form + SEO metadata + Schema

   ### WeChat Official Account version
   - Title adaptation (more click-worthy, but not clickbait)
   - Shorter paragraphs (mobile reading)
   - Add follow-prompt CTA
   - Remove external links (Official Account doesn't support external links; convert to end-of-article references)

   ### Social version (Twitter/LinkedIn)
   - 3-5 tweet thread
   - Each < 280 chars (Twitter) / longer (LinkedIn)
   - First tweet must have a hook
   - Last tweet contains link + CTA

   ### Email version
   - Subject line (< 50 chars, opens-worthy)
   - Summary (3-5 lines, core value)
   - Read-full-article link
   - Unsubscribe entry (compliance requirement)

4. **Publish record**
   After publishing on each channel, record:
   ```
   | Channel | Publish URL | Publish date | Version path |
   |---------|-------------|--------------|--------------|
   | Blog | https://... | 2026-06-21 | docs/content/published/C-001-blog.md |
   | WeChat Official Account | https://... | 2026-06-21 | docs/content/published/C-001-wechat.md |
   ```

5. **Write to publish directory**
   Write each channel version to `docs/content/published/<content-id>-<channel>.md`
   Update state.yaml: substage=distributed

## Channel adaptation principles

| Principle | Description |
|-----------|-------------|
| Core value unchanged | Each channel version preserves the original's core insight and value |
| Form adaptation | Paragraph length / tone / CTA match channel characteristics |
| Compliance first | Each channel version must also follow that channel's rules |
| Trackable | Each channel version includes UTM parameters (where feasible) |

## Prohibitions
- Don't simply copy-paste to all channels (ignores channel characteristics)
- Don't publish unreviewed versions to any channel
- Don't include user PII in social versions
- Don't forget to record publish info (content-performance needs to track)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(content) (distribution step).
PLAN → EXPERIMENT(creation → review → distribution) → MEASURE(performance)

## Relationship to Workflow
This skill is step 4 of **content-marketing-workflow**.
content-review passes → **content-distribution** → [publish] → content-performance
