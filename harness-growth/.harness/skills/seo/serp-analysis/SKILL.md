---
name: serp-analysis
description: Analyze SERP Top 10 competitor content to find content gaps and optimization opportunities
---
# SERP Analysis — SERP Competitor Analysis

## When to use
- After keyword research, when competitor content needs to be analyzed
- PLAN phase of the SEO optimization Loop
- User asks to "analyze competitor SERP

## Inputs
- docs/seo/keyword-research.md
- memory/knowledge-base.md

## Outputs
- docs/seo/serp-analysis.md

## Iron Rules
- Analysis must be based on the **actual SERP**, not "I guess competitors will be like this"
- Must find **content gaps** (what we haven't done but competitors have)
- Must distill **actionable opportunities** (not just list data)

## Process

1. **Read target keywords**
   From `docs/seo/keyword-research.md`, read the high-priority keyword list

2. **SERP data collection**
   For each target keyword, get the SERP Top 10 results:
   - Ranking URL
   - Page title + Meta Description
   - Content type (blog / landing page / video / FAQ / tool page)
   - Content length (word count)
   - Page authority (DA/PA)
   - Backlink count
   - Schema markup types
   - SERP features (featured snippet / People Also Ask / images / videos)

   > Data source: user-provided SERP screenshots / exports, or Agent queries via WebSearch

3. **Content gap analysis**
   Compare our content with the SERP Top 10:
   ```
   | Dimension | Top 10 average | Our content | Gap | Action |
   |-----------|----------------|-------------|-----|--------|
   | Word count | 2500 | 1200 | -1300 | Expand content |
   | Image count | 8 | 3 | -5 | Add charts |
   | Backlink count | 45 | 5 | -40 | Build backlinks |
   | Schema | Article+FAQ | None | Missing | Add Schema |
   | Internal links | 12 | 4 | -8 | Add internal links |
   ```

4. **SERP feature opportunities**
   - Featured Snippet: is there an opportunity to capture it?
   - People Also Ask: is there corresponding content?
   - Images / videos: is there multimedia content?
   - Local pack: is local SEO needed?

5. **Content type matching**
   - What is the main content type in the SERP? (blog / landing page / tool / video)
   - Does our page type match?
   - If not, recommend adjusting the page type

6. **Produce SERP analysis report**
   Write to `docs/seo/serp-analysis.md`:
   ```markdown
   # SERP Analysis Report

   ## Target keyword: [keyword]

   ## SERP Top 10 overview
   | Rank | URL | Title | Type | Word count | DA | Backlinks | Schema |
   |------|-----|-------|------|------------|-----|-----------|--------|

   ## Content gaps
   [Gap analysis table]

   ## SERP feature opportunities
   - Featured snippet: [opportunity / occupied / none]
   - PAA: [has corresponding / no corresponding]

   ## Optimization recommendations
   1. [Specific recommendation]
   2. [Specific recommendation]
   ```

## Prohibitions
- Don't guess competitor content without SERP data
- Don't look only at ranking and ignore content quality (high rank ≠ good content)
- Don't ignore SERP features (featured snippets can dramatically boost traffic)
- Don't produce analysis without action recommendations (analysis is for optimization)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(seo).
PLAN(keyword-research → serp-analysis → onpage-optimization) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 2 of **seo-optimization-workflow**.
