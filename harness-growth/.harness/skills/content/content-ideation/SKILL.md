---
name: content-ideation
description: Produce a topic backlog based on the three-dimensional evaluation of keyword × search intent × business value, supporting content repurposing
---
# Content Ideation — Topic Opportunity Identification

## When to use
- When content needs to be produced but there's no topic
- PLAN phase of the content marketing Loop
- User asks to "help me brainstorm topics

## Inputs
- memory/knowledge-base.md
- docs/handoff/pm-to-growth.md
- docs/handoff/solo-to-growth.md

## Outputs
- docs/content/ideation-backlog.md
- memory/knowledge-base.md

## Iron Rules
- Topics must be based on the three-dimensional evaluation of **search intent × business value × creation difficulty**, not gut feeling
- Must check the "content performance library" in the knowledge base; reuse high-performing topics and avoid repeating low-efficiency ones
- Each topic must be tagged with the target keyword and target audience

## Process

1. **Collect inputs**
   - Read the "content performance library" in `memory/knowledge-base.md` to understand historical content performance
   - Read `docs/handoff/pm-to-growth.md` (if available) to get Persona and business goals
   - Read `docs/handoff/solo-to-growth.md` (if available) to get implemented features (potential content)
   - If there's an SEO asset library, read existing keyword ranking data

2. **Keyword opportunity identification**
   - Expand long-tail keywords from business word roots
   - Classify by search intent: informational (how/what/why) / navigational (brand terms) / transactional (best/compare/buy)
   - Evaluate each keyword's search volume, difficulty, and business relevance

3. **Three-dimensional topic evaluation**
   Score each candidate topic (1-5):

   | Dimension | Scoring basis |
   |-----------|---------------|
   | Search intent match | 5 = precisely matches user search intent, 1 = vague intent |
   | Business value | 5 = directly tied to product conversion path, 1 = unrelated |
   | Creation difficulty | 5 = existing materials allow quick production, 1 = requires extensive research |

   Topic priority = search intent match × business value × creation difficulty

4. **Generate topic backlog**
   ```
   | Topic ID | Title | Target keyword | Search intent | Search volume | Difficulty | Business value | Priority | Target audience | Content form |
   |----------|-------|-----------------|---------------|---------------|------------|----------------|----------|-----------------|---------------|
   | T-001 | How to improve Y with X | how to improve y | Informational | 1200 | Medium | High | 60 | Growth PM | Blog |
   ```

5. **Repurposing plan**
   For each high-priority topic, plan multi-channel reuse:
   - Blog long-form → WeChat Official Account article → social summary → email Newsletter → video/image script

6. **Write to topic backlog**
   Write the topic list to `docs/content/ideation-backlog.md`
   Sync high-priority topics to the "content performance library" in `memory/knowledge-base.md` (status marked "to be created")

## Prohibitions
- Don't generate topics without search intent (no searches = no traffic)
- Don't generate topics unrelated to the business (traffic without conversion)
- Don't repeat already-created topics (check the content performance library)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(content).
PLAN(content-ideation → content-creation) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 1 of **content-marketing-workflow**.
