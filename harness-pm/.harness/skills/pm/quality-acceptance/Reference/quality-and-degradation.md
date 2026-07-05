# quality-acceptance Quality Checks & Degradation Strategy

> This document is split from the quality-acceptance SKILL.md and contains the detailed quality check items and degradation strategy.

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| P0 case pass rate | 100% | Block |

- [ ] All P0 case execution instructions generated
- [ ] P0 case pass rate 100%

### P1 Checks (must pass for standard/deep)

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| Automation execution rate | ≥ 90% | Block |
| Test environment configuration | All configuration recommendation items output | Block |
| Failure analysis completeness | Includes root cause and recommendations | Alert |

- [ ] Automation execution rate meets standard
- [ ] Failed case analysis rules generated
- [ ] Failed cases have fix suggestions
- [ ] Environment configuration recommendations output
- [ ] Acceptance criteria have item-by-item results
- [ ] Must requirement pass rate calculated
- [ ] Defects classified by severity
- [ ] Open issues have handling plans
- [ ] Acceptance conclusion clear (pass/conditional pass/fail)
- [ ] Sign-off confirmation table included

### P2 Checks (only deep must pass)

- [ ] Regression test matrix generated (affected modules, regression case coverage, risk level annotation)
- [ ] Performance baseline comparison completed (key metrics compared with previous version baseline, performance degradation detection)
- [ ] Security audit checklist output (security acceptance items, vulnerability scan results, compliance check)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Acceptance criteria missing | User provides Given-When-Then acceptance criteria → generate acceptance checklist | Acceptance criteria need manual writing |
| Test environment missing | Generate acceptance checklist and execution instructions, environment configuration marked as to-be-filled | Only outputs checklist and execution instructions, environment configuration marked as to-be-filled |
| Acceptance criteria + test environment both missing | User provides Given-When-Then acceptance criteria → generate acceptance checklist | Outputs acceptance checklist, environment configuration marked as "to be configured" |
| Test results missing | Generate to-be-filled report template based on acceptance criteria | Cannot auto-determine pass/fail |
| SRS missing (already covered by design-prd) | Acceptance criteria provided by user | Need to manually define acceptance criteria |
| Acceptance party missing | If user does not provide acceptance party, prompt user to provide or skip related steps | Sign-off confirmation table marked as "acceptance party to be designated" |
| Backend review report missing | Accept based only on functional acceptance criteria | May miss backend architecture quality issues |
| API coverage report missing | Accept based only on PRD acceptance criteria | May miss incomplete API coverage issues |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degradation generation:
- **Given-When-Then acceptance criteria**: Given/When/Then description for each acceptance condition
- **Test environment information** (optional): Test environment address, accounts and other configuration
- **Build version** (optional): Build version number to be accepted
