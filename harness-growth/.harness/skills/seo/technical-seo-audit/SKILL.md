---
name: technical-seo-audit
description: Technical SEO audit, including crawlability / Core Web Vitals / index status / mobile / security
---
# Technical SEO Audit — Technical SEO Audit

## When to use
- When SEO optimization needs a technical foundation check
- EXPERIMENT phase of the SEO optimization Loop
- User asks to "check technical SEO
- When rankings drop abnormally

## Inputs
- rules/security.md

## Outputs
- docs/seo/technical-audit.md
- loops/specs/<seo>/state.yaml

## Iron Rules
- Audit must be based on **actual detection**, not "I guess it should be fine"
- Issues found must be sorted by **impact scope × severity**
- Critical issues (e.g., indexing blocked) must be fixed first

## Process

1. **Crawlability check**
   - Is Robots.txt correct (no important pages blocked)
   - Is Meta Robots correct (noindex/nofollow used reasonably)
   - Is the Canonical tag correct (avoid duplicate content)
   - Crawl log analysis (are search engines crawling)
   - Is Sitemap.xml complete and submitted

2. **Index status check**
   - Are important pages indexed (site: query)
   - Are there low-quality pages indexed (should be noindex)
   - Are there orphan pages (no internal links pointing to them; search engines can't find them)
   - Duplicate content check (same content, different URLs)

3. **Core Web Vitals check**
   | Metric | Pass | Needs optimization | Fail |
   |--------|------|--------------------|------|
   | LCP (Largest Contentful Paint) | < 2.5s | 2.5-4s | > 4s |
   | INP (Interaction latency) | < 200ms | 200-500ms | > 500ms |
   | CLS (Layout shift) | < 0.1 | 0.1-0.25 | > 0.25 |

   - Check the LCP element (usually the above-the-fold large image / large heading)
   - Check INP bottlenecks (long tasks / third-party scripts)
   - Check CLS sources (images without dimensions / dynamically injected content)

4. **Mobile responsiveness**
   - Is responsive design correct
   - Mobile font size (≥ 16px)
   - Tap target size (≥ 48px)
   - No horizontal scrolling
   - Mobile load speed

5. **Security check**
   - Is HTTPS enabled
   - Mixed content (HTTPS pages loading HTTP resources)
   - Is the HSTS header set

6. **Structured data validation**
   - Is the Schema markup correct (Google Rich Results Test)
   - Are there Schema errors / warnings

7. **Internal link structure analysis**
   - Orphan page list
   - Internal link depth distribution (are important pages ≤ 3 clicks away)
   - Anchor text diversity

8. **Produce audit report**
   Write to `docs/seo/technical-audit.md`:
   ```markdown
   # Technical SEO Audit Report

   ## Audit overview
   - Audit date: YYYY-MM-DD
   - Pages checked: N
   - Issues found: N (Critical X / Medium Y / Low Z)

   ## Issue list (sorted by priority)
   | Priority | Issue | Impact scope | Severity | Fix recommendation |
   |----------|-------|--------------|----------|---------------------|
   | P0 | robots.txt blocks /blog | Whole blog | Critical | Modify robots.txt |
   | P1 | LCP 4.5s | Homepage | Medium | Compress hero image |
   | P2 | Missing Schema | Blog | Low | Add Article Schema |

   ## Core Web Vitals
   | Page | LCP | INP | CLS | Rating |
   |------|-----|-----|-----|--------|

   ## Index status
   | Check item | Result | Notes |
   |------------|--------|-------|
   | Important pages indexed | N/M | |
   | Orphan pages | N | |
   | Duplicate content | N | |

   ## Fix roadmap
   1. [P0 fix steps]
   2. [P1 fix steps]
   ```

## Issue priority criteria

| Priority | Definition | Fix timeframe |
|----------|------------|---------------|
| P0 | Severely affects indexing / ranking (e.g., blocked by noindex/robots) | Immediately |
| P1 | Affects ranking / user experience (e.g., CWV below bar / mobile issues) | Within 1 week |
| P2 | Optimization room (e.g., missing Schema / insufficient internal links) | Within 1 month |

## Prohibitions
- Don't skip the crawlability check (without solving the technical foundation, other optimization is wasted)
- Don't ignore Core Web Vitals (Google ranking signal)
- Don't report problems without fix recommendations
- Don't downgrade P0 issues to "later"

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(seo).
PLAN → EXPERIMENT(onpage → technical-seo-audit) → MEASURE(ranking)

## Relationship to Workflow
This skill is step 4 of **seo-optimization-workflow**.
P0 issues must be fixed before entering ranking-tracking.
