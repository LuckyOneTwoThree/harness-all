---
name: growth-loop-design
description: Growth Loops identification and design, building self-reinforcing growth flywheels
---
# Growth Loop Design — Growth Loop Design

## When to use
- When a sustainable growth engine needs to be designed
- Growth strategy formulation Workflow
- User asks to "design a growth loop

## Inputs
- docs/operations/GROWTH_STRATEGY.md
- memory/knowledge-base.md

## Outputs
- docs/operations/GROWTH_STRATEGY.md
- memory/knowledge-base.md

## Iron Rules
- The Loop's output must **feed back into the input**, forming compounding
- Must quantify the Loop's **conversion efficiency** and **capacity**
- A product can have multiple Loops, but the **dominant Loop** must be identified

## Process

1. **Identify existing Loops**
   Analyze the growth loops already present in the product:
   - User uses product → produces content → content attracts new users? (UGC Loop)
   - User uses product → invites others → new users join? (Viral Loop)
   - Revenue → ad budget → new users → more revenue? (Paid Loop)
   - Produce SEO content → search traffic → users → data feeds back into content? (SEO Loop)

2. **Loop three-element analysis**
   For each Loop, analyze:
   ```
   Input: [new users / content / revenue]
   Action: [what users do that creates value]
   Output: [what's produced that feeds back to input]
   Conversion efficiency: [Output/Input ratio]
   Compounding coefficient: [amplification factor per cycle]
   ```

3. **Loop health assessment**
   | Dimension | Healthy | Unhealthy |
   |-----------|---------|-----------|
   | Conversion efficiency | Output > Input | Output < Input |
   | Capacity | Has growth room | Saturated |
   | Latency | Short (days/weeks) | Long (months/years) |
   | Controllability | Conversion rate can be optimized | Depends on external factors |

4. **Design new Loops** (if existing Loops are insufficient)
   ```
   New Loop design:
   - Trigger: what user action triggers the Loop?
   - Action: what do users do that creates value?
   - Reward: why would users participate?
   - Feedback: how does the output become the next round's input?
   - Quantification: how to measure Loop efficiency?
   ```

5. **Loop priority**
   | Loop type | Suited scenario | Time to effect |
   |-----------|-----------------|----------------|
   | UGC content Loop | Content products | Medium (monthly) |
   | Viral Loop | Social / collaboration products | Fast (weekly) |
   | Paid Loop | Products with monetization | Fast (immediate, controllable) |
   | SEO content Loop | Products with search demand | Slow (3-6 months) |

6. **Write to growth strategy document**
   Update the "Growth Loops" section of `docs/operations/GROWTH_STRATEGY.md`

## Prohibitions
- Don't design Loops that can't be quantified (can't measure = can't optimize)
- Don't design Loops that depend on a single channel (channel risk)
- Don't ignore Loop latency (SEO Loops take effect slowly; can't just wait)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **strategic-level** design.

## Relationship to Workflow
This skill is step 4 of **growth-strategy-workflow**.
