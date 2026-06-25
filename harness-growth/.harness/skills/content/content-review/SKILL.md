---
name: content-review
description: Content review and fact-checking, an independent Reviewer mode from creation, checking compliance / facts / brand / SEO
---
# Content Review — Content Review

## When to use
- After content-creation produces a draft
- Quality gate before content publishing
- User asks to "review this content

## Inputs
- docs/content/drafts/
- rules/security.md
- SOUL.md
- constitution.md

## Outputs
- docs/content/drafts/<content-id>.review.md
- loops/specs/<content>/state.yaml
- loops/specs/<content>/iterations.log

## Iron Rules
- This skill is an **independent reviewer**; it does not modify content, only produces review opinions
- Review must cover four dimensions: compliance / facts / brand / SEO
- Content that fails review **cannot be published**; must be returned to content-creation for revision
- Review opinions must be specific and actionable (point out the problem + give revision suggestions)

## Process

1. **Read draft**
   Read content to be reviewed from `docs/content/drafts/`

2. **Compliance review**
   - Advertising law violations (absolute terms like "most" / "first" / "national-level" / "ultimate")
   - Industry compliance (restricted terms in special industries such as medical / financial / education)
   - Platform rules (e.g., content guidelines for WeChat Official Account / Xiaohongshu)
   - Privacy compliance (no user PII, data anonymized)
   - Copyright compliance (cite sources, image licensing)

3. **Fact-checking**
   - Are data/statistics sourced?
   - Are quotes accurate (not out of context)?
   - Are case studies real (not fabricated)?
   - Is technical information accurate (not misleading)?
   - Flag uncertain information as "needs verification"

4. **Brand consistency**
   - Does the tone match brand voice (defined in SOUL.md)?
   - Are values consistent with constitution.md?
   - Is terminology unified (product names / feature names / industry terms)?
   - Does the CTA match the current product state?

5. **SEO quality check**
   - Target keyword density (1-2% is ideal, >3% counts as stuffing)
   - Heading hierarchy correct (H1 unique, H2/H3 hierarchy)
   - Meta Description includes keyword + CTA
   - Internal link count (3-5 is ideal)
   - Image Alt text complete
   - URL includes keyword
   - Readability (Flesch score > 60)

6. **Produce review report**
   Write to `docs/content/drafts/<content-id>.review.md`:
   ```markdown
   # Content Review: <content-id>

   ## Review conclusion: [Pass / Needs revision / Needs rewrite]

   ## Compliance review
   | Check item | Result | Issue | Suggestion |
   |------------|--------|-------|------------|
   | Advertising law | ✅/❌ | [issue] | [suggestion] |
   | Industry compliance | ✅/❌ | | |
   | Privacy | ✅/❌ | | |
   | Copyright | ✅/❌ | | |

   ## Fact-checking
   | Claim | Source | Credibility | Suggestion |
   |-------|--------|-------------|------------|
   | [data/claim] | [source/none] | High/Medium/Low | [suggestion] |

   ## Brand consistency
   - Tone: ✅/❌ [notes]
   - Values: ✅/❌
   - Terminology: ✅/❌

   ## SEO quality
   - Keyword density: X% [✅/⚠️ too high/low]
   - Heading: [✅/❌]
   - Meta: [✅/❌]
   - Internal links: X [✅/⚠️]
   - Readability: Flesch XX [✅/❌]

   ## Revision suggestions (if needed)
   1. [Specific issue + revision suggestion]
   2. [Specific issue + revision suggestion]
   ```

7. **Update state.yaml**
   - Review passed: substage=review-passed
   - Review failed: status=retrying, last_error=review failed, return for revision
   - Append to iterations.log

## Review decision criteria

| Situation | Decision |
|-----------|----------|
| All four dimensions pass | **Pass**, can enter content-distribution |
| Compliance violation | **Needs revision**, must fix compliance issues |
| Factual error | **Needs revision**, must correct or cite source |
| Brand inconsistency | **Needs revision**, adjust tone/terminology |
| SEO below bar | **Needs optimization**, adjust keywords/structure |
| Severe issues across multiple dimensions | **Needs rewrite**, return to content-creation |

## Prohibitions
- Don't directly modify content (only produce review opinions)
- Don't skip compliance checks (compliance is the baseline)
- Don't lower the bar ("close enough" is not a pass reason)
- Don't be vague in the review report ("somewhat problematic" is not a suggestion)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP(content) (as a quality gate).
PLAN → EXPERIMENT(content-creation) → MEASURE(content-review) → pass? content-distribution : back to content-creation

## Relationship to Workflow
This skill is step 3 (quality gate) of **content-marketing-workflow**.
content-creation → **content-review** → content-distribution
