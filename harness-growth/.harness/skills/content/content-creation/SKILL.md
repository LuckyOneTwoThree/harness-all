---
name: content-creation
description: Produce SEO-optimized long-form content based on selected topics, with internal outline/draft/optimization steps
triggers:
  - When topics are decided and content needs to be created
  - EXPERIMENT phase of the content marketing Loop
reads:
  - docs/content/ideation-backlog.md
  - memory/knowledge-base.md
  - rules/security.md
writes:
  - docs/content/drafts/
  - loops/specs/<content>/state.yaml
quality_gates:
  - content-review
max_iterations: 3
---

# Content Creation — Content Creation

## Iron Rules
- Content must deliver **real value** to users, not keyword stuffing for SEO
- Must meet the "10x content" standard — 10x better than the top 10 competitor results (deeper / more comprehensive / more practical)
- After creation, must pass the content-review quality gate; cannot be published directly
- No black-hat SEO (keyword stuffing, hidden text, plagiarism)

## Process

### Step 1: Outline generation
1. Read the topic backlog, confirm target keywords, search intent, and target audience
2. Analyze the content structure of SERP Top 10 competitors (read serp-analysis data if available)
3. Generate content outline:
   ```
   # [Topic title]

   ## Introduction (hook + value promise)
   ## 1. [Core concept / problem definition]
   ## 2. [Method / steps / solution]
   ## 3. [Case studies / data / tools]
   ## 4. [FAQ / comparison]
   ## Summary + CTA
   ```
4. Confirm the outline covers search intent (informational = comprehensive / navigational = precise / transactional = comparison)

### Step 2: Draft creation
1. Write each section following the outline
2. Follow brand voice (as defined in SOUL.md / constitution.md)
3. Embed target keywords (natural occurrence, no stuffing, density 1-2%)
4. Add internal links (to existing content) and external authoritative links
5. Add data / case studies / charts to each section (boost credibility)

### Step 3: SEO optimization
1. **Title optimization**: include target keyword, <60 chars, click-worthy
2. **Meta Description**: include keyword, <160 chars, with CTA
3. **URL structure**: short, includes keyword, uses hyphens
4. **Heading hierarchy**: H1 unique, H2/H3 clear hierarchy, includes related keywords
5. **Image Alt text**: descriptive + keyword
6. **Schema markup**: Article/HowTo/FAQ (by content type)
7. **Internal links**: 3-5 relevant internal links
8. **Readability**: paragraphs <5 lines, Flesch score > 60

### Step 4: Write draft
Write the full content to `docs/content/drafts/<content-id>.md`
Update state.yaml: stage=experiment, substage=content-draft

## Content quality self-check list

- [ ] Is it deeper / more comprehensive / more practical than SERP Top 10?
- [ ] Does the target keyword appear naturally (not stuffed)?
- [ ] Is there data / case study support (not empty talk)?
- [ ] Is there a clear CTA (guides the next step)?
- [ ] Does readability meet the bar (short paragraphs, clear hierarchy)?
- [ ] Are there 3+ internal links?
- [ ] Does the Meta Description include keyword + CTA?

## Prohibitions
- Don't stuff keywords (density > 3% counts as stuffing)
- Don't plagiarize competitor content (reference structure, don't copy text)
- Don't produce homogeneous content (check the knowledge base to ensure a unique angle)
- Don't publish directly during creation (must pass content-review)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(content).
PLAN(content-ideation) → EXPERIMENT(content-creation) → MEASURE(content-review → content-performance)

## Relationship to Workflow
This skill is step 2 of **content-marketing-workflow**.
Output must pass the content-review quality gate before entering content-distribution.
