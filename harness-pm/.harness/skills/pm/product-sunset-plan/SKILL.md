---
name: product-sunset-plan
description: Used when formulating a product or feature sunset plan. Auto-generates product sunset plans including sunset decision assessment, user migration plan, data disposal strategy, timeline, and communication plan. Keywords: product sunset, feature sunset, product retirement, Sunset, sunset plan, user migration, data disposal, feature sunset, service discontinuation.
---
# Product Sunset Plan Generation

## When to use
- How to sunset this feature
- How to arrange product service discontinuation
- What to do when retiring an old feature

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- docs/monitoring/product-sunset-plan.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principle

**Sunset is the last respect for users**

The core value of a product sunset plan lies in ensuring the product retirement process minimizes impact on users. A good sunset is not a sudden disappearance, but an orderly transition. The time and data users invested deserve to be taken seriously.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Health diagnosis | markdown | No | diagnosis-health | Product health score, trends |
| Retention data | markdown | No | retention-management | User retention, churn trends |
| Sunset target | text | Yes | User input | Product/feature name and scope to be sunset |
| Sunset reason | text | Yes | User input | Business decision reason |

### Degradation Strategy

| Missing Input | Degradation Plan |
|----------|----------|
| No health diagnosis | Assess sunset impact based on user-provided information, label "pending health diagnosis" |
| No retention data | Estimate affected user count based on user-provided information, label "pending retention data validation" |
| No sunset target/reason | Cannot generate, require user to provide basic information |

## Execution Steps

### Step 1: Sunset Decision Assessment [Core]

Assess the rationality and impact of the sunset decision:

1. **Sunset reason validation**:
   - Business metrics continuously declining (Revenue/Users/Activity)
   - Strategic direction adjustment (no longer fits product positioning)
   - Excessive technical cost (maintenance cost > output value)
   - Compliance requirements (regulatory changes)
2. **Alternative solution assessment**: Are there alternative solutions without sunsetting
3. **Impact scope assessment**:
   - Affected user count and proportion
   - Affected revenue and proportion
   - Affected partners
   - Brand impact assessment

### Step 2: User Migration Plan [Core]

Develop a migration strategy for users from the sunset product to alternative solutions:

1. **Alternative solution identification**:
   - Own alternative products/features
   - Third-party alternative solutions
   - No alternative (must clearly communicate)
2. **Migration path design**:
   - Data export → import process
   - Feature mapping table (old feature → new feature)
   - Migration tools/scripts
3. **Migration incentives**:
   - Migration discounts/offers
   - Dedicated migration support
   - Data migration guarantee commitment
4. **Special user handling**:
   - Enterprise customers: 1-on-1 migration support
   - High-value users: Dedicated migration plan
   - Long-term users: Gratitude rewards

### Step 3: Data Disposal Strategy [Core]

Develop a disposal plan for user data:

1. **Data classification**:
   - User-generated content (UGC)
   - User configurations/settings
   - Usage history/behavioral data
   - Payment/transaction records
2. **Disposal methods**:
   - Exportable: Provide standard format export tools
   - Migratable: Automatically migrate to alternative product
   - Must retain: Legal retention period and access method
   - Must delete: Deletion timeline and confirmation mechanism
3. **Data retention period**:
   - Legal retention (transaction records ≥ 5 years)
   - User-selected retention period
   - Final deletion timeline

### Step 4: Sunset Timeline [Core]

Develop a phased sunset timeline:

1. **Announcement period** (T-90 days):
   - Publish sunset announcement
   - Enable data export
   - Stop new user registration
2. **Transition period** (T-60 days):
   - Stop paid renewals
   - Push migration guidance
   - Provide migration support
3. **Read-only period** (T-30 days):
   - Features read-only, no new creation/modification
   - Final data export window
   - Dedicated customer service support
4. **Sunset day** (T-0):
   - Service stops
   - Data enters retention period
   - Sunset page goes live
5. **Cleanup period** (T+30 days):
   - Data deleted/archived per strategy
   - Final confirmation report

### Step 5: Communication Plan [Core]

Develop a communication plan for each stakeholder:

1. **User communication**:
   - Announcement copy (versions for each channel)
   - FAQ document
   - Migration tutorials
   - Customer service scripts
2. **Internal communication**:
   - Team notification
   - Customer service training
   - Sales script updates
3. **External communication**:
   - Partner notification
   - Media messaging
   - Community announcement

### Step 6: Report Assembly [Core]

Assemble the above content into a complete sunset plan.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Sunset plan and risk list | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full sunset plan + user migration plan + data archival strategy + impact assessment report | Full artifact + extended analysis + deep reasoning |

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Impact assessment complete (users/revenue/brand 3 dimensions all assessed)
- [ ] Migration plan feasible (each user type has clear migration path)

### P1 Checks (must pass for standard/deep)

- [ ] Data disposal compliant (legally retained data has retention plan)
- [ ] Timeline executable (5 phases have clear dates and deliverables)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Decision Rules

- When affected users > 10%, sunset timeline must include ≥ 60-day transition period
- When product involves paid users, must include refund or migration compensation plan
- When data involves personal privacy, data disposal strategy must include compliant deletion plan
- Decision points requiring human confirmation: sunset decision confirmation, migration plan selection, data retention period, communication messaging approval

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact |
|----------|----------|----------|
| No health diagnosis | User describes product status, AI assesses sunset necessity based on description | Sunset decision lacks health data support |
| No retention data | Skip user impact quantification, label "retention data pending supplementation" | User impact assessment is qualitative description |
| No health + no retention | User describes product status and user scale, AI generates sunset plan based on description | Sunset plan based on qualitative description, key data labeled "pending confirmation" |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| sunset_object | string | Yes | Sunset target name, cannot be empty |
| impact_assessment | object | Yes | Impact assessment, must contain users/revenue/brand 3 dimensions |
| migration_plan | object | Yes | Migration plan, must contain migration path for each user type |
| data_disposal | object | Yes | Data disposal strategy, must contain retention_policy/compliance |
| timeline | object | Yes | Timeline, must contain 5 phases with dates and deliverables |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| diagnosis-health | Health score change | Sunset decision assessment | Re-evaluate sunset necessity |
| retention-management | Retention data update | User impact assessment | Update affected user scale and migration plan |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| diagnosis-orchestrator | Sunset plan generation completed | Output file updated | Plan completion status and key conclusions |
