---
name: onpage-optimization
description: On-page optimization recommendations, including IA / URL / internal links / content optimization / Schema markup
---
# Onpage Optimization — On-Page Optimization

## When to use
- After SERP analysis, when pages need optimization
- EXPERIMENT phase of the SEO optimization Loop
- User asks to "optimize this page's SEO

## Inputs
- docs/seo/keyword-research.md
- docs/seo/serp-analysis.md
- rules/security.md

## Outputs
- docs/seo/onpage-optimization.md
- loops/specs/<seo>/state.yaml

## Iron Rules
- Optimization must be based on SERP analysis data, not "I think it should be this way"
- No black-hat SEO (keyword stuffing / hidden text / doorway pages / link farms)
- Optimization recommendations must be specific and actionable (point out what to change + change to what)

## Process

1. **Read analysis data**
   - Read target keywords from `docs/seo/keyword-research.md`
   - Read content gaps and optimization recommendations from `docs/seo/serp-analysis.md`

2. **Information Architecture (IA) optimization**
   - Is the site structure flat (important pages reachable in ≤ 3 clicks)?
   - Does the URL structure include keywords, use hyphens, and stay short?
   - Is breadcrumb navigation complete?
   - Are categories / tags reasonable?

3. **Page-level optimization**
   For each target page:

   ### Title optimization
   - Include the target keyword (preferably near the front)
   - < 60 chars (avoid truncation)
   - Click-worthy (include numbers / questions / emotional words)

   ### Meta Description
   - Include keyword + related words
   - < 160 chars
   - Include a CTA (learn more / try now / free download)

   ### Heading structure
   - H1 unique, includes target keyword
   - H2/H3 clear hierarchy, includes related keywords (LSI)
   - Don't skip levels (H1 → H3 is wrong)

   ### Content optimization
   - Keyword density 1-2% (natural occurrence, no stuffing)
   - Cover related keywords / LSI words
   - Fully cover search intent (informational = comprehensive / transactional = comparison)
   - Content length ≥ SERP Top 10 average (refer to serp-analysis)
   - Multimedia (images / videos / charts) to improve experience

   ### Internal link optimization
   - 3-5 relevant internal links per page
   - Anchor text includes keywords (natural, not stuffed)
   - Important pages get more internal links

   ### Image optimization
   - Filename includes keyword (e.g., how-to-do-x.png)
   - Alt text descriptive + keyword
   - Compress image size (WebP format)
   - Lazy loading

4. **Schema markup**
   Add Schema by content type:
   | Content type | Schema type |
   |--------------|-------------|
   | Blog article | Article |
   | Tutorial | HowTo |
   | FAQ | FAQPage |
   | Product | Product |
   | Review | Review |
   | Breadcrumb | BreadcrumbList |

5. **Technical optimization check**
   - Canonical tag (avoid duplicate content)
   - Robots.txt / Meta Robots
   - Open Graph / Twitter Card
   - Mobile responsiveness
   - Page load speed (Core Web Vitals)

6. **Produce optimization plan**
   Write to `docs/seo/onpage-optimization.md`:
   ```markdown
   # On-Page Optimization Plan: [page / keyword]

   ## Current state
   [Page URL, current ranking, current issues]

   ## Optimization recommendations
   | Item | Current | Recommendation | Priority |
   |------|---------|-----------------|----------|
   | Title | [current title] | [recommended title] | High |
   | Meta | [current] | [recommended] | High |
   | Word count | 1200 | 2500 | High |
   | Schema | None | Article+FAQ | Medium |

   ## Specific changes
   [Detailed description of each change]
   ```

7. **Update state.yaml**
   stage=experiment, substage=onpage-optimization

## Prohibitions
- Don't stuff keywords (density > 3% counts as stuffing)
- Don't use hidden text (same-color text / tiny font)
- Don't build doorway pages (creating identical-content pages for different keywords)
- Don't buy backlinks (violates search engine rules)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(seo).
PLAN(research → serp) → EXPERIMENT(onpage → technical) → MEASURE(ranking)

## Relationship to Workflow
This skill is step 3 of **seo-optimization-workflow**.
