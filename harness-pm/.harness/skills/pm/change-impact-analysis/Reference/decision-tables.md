# Change Impact Analysis - 决策表

本文档收录 Change Impact Analysis Skill 的上下游变更响应、决策规则与降级策略表。

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| PRD requirement change | Functional impact analysis, version linkage | Update functional impact matrix, re-evaluate change level and re-review necessity |
| IA solution change | IA impact analysis | Update IA impact matrix, re-evaluate IA structure change scope |
| User flow change | User flow impact analysis | Update user flow impact matrix, re-evaluate dead-end risks |
| Prototype change | Prototype impact analysis | Update prototype impact matrix, re-evaluate design specification consistency |
| Interaction specification change | Interaction specification impact analysis | Update interaction specification impact matrix, re-evaluate state machine coverage |
| Engineering feedback (engineering-to-pm) | PRD assumption validation, AC feasibility, tech-stack alignment | Update functional impact matrix with engineering-identified AC changes; re-evaluate PRD NFR constraints against reported TECH_STACK.md changes; mark architecture-decision-impacted ACs for re-review; surface design-impact items to the user (design assets are user-owned) |

When the change impact analysis results themselves change, the downstream notification mechanism:

| Change Impact Analysis Change Type | Notification Scope | Notification Method |
|---------------------|----------|----------|
| Change level upgrade | iteration-retrospective | Mark change level change, trigger retrospective assessment |
| Impact scope expansion | design-prd | Mark impact scope change, trigger PRD update assessment |
| Re-review necessity change | quality-acceptance | Mark review need change, trigger acceptance criteria update |
| Version planning adjustment | iteration-orchestrator | Mark version planning change, trigger iteration plan adjustment |

## Decision Rules

### Mandatory Re-review Rules

| Condition | Decision |
|------|------|
| L3 level change | **Must trigger re-review** |
| L4 level change | **Must trigger strategic-level review** |
| Involves hypothesis change | Must re-review |
| Impact scope > 3 feature modules | Suggest upgrading review level |

### Special Handling Rules

| Condition | Handling Method |
|------|----------|
| Change involves IA structure restructuring | Must include IA rollback plan |
| Change involves design system/token changes | Must include design specification degradation plan |
| Change affects P0 features | Must have product owner sign-off |

## Degradation Strategy - Upstream File Missing

| Missing Scope | Degradation Plan | Output Impact | Data Acquisition Notes |
|----------|----------|----------|------------|
| Change request missing | Cannot execute, need user to describe change content | - | Require user to provide change content description (what changed, which feature modules involved) |
| Current PRD missing | User describes change content → directly analyze impact, no PRD baseline comparison | Cannot precisely locate affected sections, impact scope based on inference | Require user to provide current PRD document or feature requirement description |
| Current IA missing | Skip IA impact analysis | IA impact analysis incomplete | Require user to provide IA solution or information architecture description |
| Current user flow missing | Skip user flow impact analysis | User flow impact analysis incomplete | Require user to provide user flow diagrams or flow descriptions |
| Current prototype missing | Skip prototype impact analysis | Prototype impact analysis incomplete | Require user to provide prototype design or page descriptions |
| Current interaction specification missing | Skip interaction specification impact analysis | Interaction specification impact analysis incomplete | Require user to provide interaction specifications or interaction descriptions |
| Change request + current PRD + current IA all missing | User describes change content → directly analyze impact | Output simplified impact analysis, each dimension labeled "pending supplementation" | Require user to provide change description, current PRD and IA solution |

## Data Acquisition Notes

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Change content description**: What changed, which feature modules are involved
- **Change reason** (optional): Why the change is needed
- **Expected impact scope** (optional): Modules or systems that may be affected by the change
