---
name: keyword-research
description: Keyword research, including seed word expansion / intent classification / difficulty assessment / priority ranking
triggers:
  - When SEO is needed but there's no keyword list
  - PLAN phase of the SEO optimization Loop
  - User asks to "research keywords"
reads:
  - memory/knowledge-base.md
  - docs/handoff/pm-to-growth.md
writes:
  - docs/seo/keyword-research.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Keyword Research — Keyword Research

## Iron Rules
- Keywords must be classified by **search intent** (informational / navigational / transactional); different intents map to different content forms
- Must check the "SEO asset library" in the knowledge base to avoid repeating already-optimized keywords
- Difficulty assessment must be based on data (search volume / competitor count / SERP authority), not gut feeling

## Process

1. **Collect seed words**
   - Expand from business core word roots (product names / feature names / industry terms / user pain-point words)
   - Read `docs/handoff/pm-to-growth.md` (if available) to get product positioning and target audience
   - Read the "SEO asset library" in the knowledge base to exclude already-optimized keywords
   - Mine long-tail words from user feedback / customer service records

2. **Keyword expansion**
   - Use keyword expansion methods:
     - Synonym / near-synonym expansion
     - Long-tail expansion (how to / what is / best / vs / alternatives)
     - Question-type expansion (why / how / what is)
     - Modifier expansion (2026 / free / tool / tutorial)
   - Goal: expand 10-20 related words per seed word

3. **Search intent classification**
   | Intent type | Characteristic words | Corresponding content form |
   |-------------|----------------------|----------------------------|
   | Informational | how/what/why/tutorial/guide | Blog long-form / FAQ |
   | Navigational | brand name / product name | Official site / landing page |
   | Transactional | best/compare/buy/price | Comparison article / buying guide |
   | Local | near me / city name | Local landing page |

4. **Difficulty assessment**
   For each keyword, assess:
   - **Search volume**: monthly search volume (high / medium / low)
   - **Competition**: domain authority of SERP Top 10
   - **CPC**: commercial value reference (high CPC = high commercial intent)
   - **Trend**: search trend (rising / stable / declining)

5. **Priority ranking**
   Keyword priority = search volume × business value × (1 / difficulty)

   ```
   | Keyword | Intent | Monthly volume | Difficulty | CPC | Priority | Target page | Content form |
   |---------|--------|----------------|------------|-----|----------|-------------|--------------|
   | how to do X | Informational | 1200 | Medium | $2.5 | High | /blog/how-to-x | Long-form |
   | X vs Y | Transactional | 800 | Low | $5.0 | High | /blog/x-vs-y | Comparison |
   ```

6. **Write the keyword research report**
   Produce `docs/seo/keyword-research.md`, including:
   - Seed word list
   - Full expanded keyword table
   - Intent classification stats
   - Top 20 priority ranking
   - Content planning recommendations (what content each high-priority keyword maps to)

7. **Update knowledge base**
   Write high-priority keywords to the "SEO asset library" in `memory/knowledge-base.md` (status marked "to be optimized")

## Prohibitions
- Don't pick high-volume keywords unrelated to the business (traffic without conversion)
- Don't ignore long-tail words (long-tail words have low difficulty, clear intent, high conversion rate)
- Don't repeat already-optimized keywords (check the SEO asset library)
- Don't look only at search volume and ignore difficulty (high volume + high difficulty = can't rank in the short term)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(seo).
PLAN(keyword-research → serp-analysis → onpage-optimization) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 1 of **seo-optimization-workflow**.
