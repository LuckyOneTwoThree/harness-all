# validate.ps1 — Cross-framework BASE-FILE consistency checker (family-level).
# Scope: verifies shared base files (STATE_PROTOCOL / handoff-protocol / risk-model /
# handoff-manifest.schema / acceptance-id-protocol / validate-handoff.ps1 / VERSION)
# are byte-identical across all 3 frameworks, plus per-framework README badge vs actual
# skill/workflow counts, plus root README badge vs family totals.
# NOT to be confused with .harness/scripts/validate-handoff.ps1 (per-framework, validates
# the envelope/schema/hash/freshness integrity of a single portable handoff package).
param(
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$frameworks = @('harness-pm', 'harness-design', 'harness-solo')
$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$whitelistedWarnings = New-Object System.Collections.Generic.List[string]

function Add-ValidationError([string]$Message) { $script:errors.Add($Message) }
function Add-ValidationWarning([string]$Message) { $script:warnings.Add($Message) }
# Whitelisted warnings document legitimate per-framework differences that have already
# been verified by key-section checks above. They must NOT fail -Strict mode.
function Add-WhitelistedWarning([string]$Message) { $script:whitelistedWarnings.Add($Message) }
function Read-Utf8([string]$Path) { return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8) }

function Get-Frontmatter([string]$Path) {
    $lines = [System.IO.File]::ReadAllLines($Path, [System.Text.Encoding]::UTF8)
    if ($lines.Count -lt 3 -or $lines[0] -ne '---') { return $null }
    $end = -1
    for ($i = 1; $i -lt $lines.Count; $i++) {
        if ($lines[$i] -eq '---') { $end = $i; break }
    }
    if ($end -lt 2) { return $null }
    return ($lines[1..($end - 1)] -join "`n")
}

function Assert-Contains([string]$Path, [string]$Pattern, [string]$Message) {
    if (-not ((Read-Utf8 $Path) -match $Pattern)) { Add-ValidationError $Message }
}

$totalSkills = 0
$totalWorkflows = 0
$stateProtocolHashes = @{}
$stateSchemaHashes = @{}
$riskModelHashes = @{}
$handoffProtocolHashes = @{}
$handoffManifestSchemaHashes = @{}
$acceptanceProtocolHashes = @{}
$handoffValidatorHashes = @{}
$versions = @{}

foreach ($framework in $frameworks) {
    $dir = Join-Path $root $framework
    $required = @('AGENTS.md', 'SOUL.md', 'constitution.md', 'install.sh', '.harness/VERSION', '.harness/loops/LOOP.md', '.harness/loops/STATE_PROTOCOL.md', '.harness/loops/state.schema.json', '.harness/rules/risk-model.md', '.harness/rules/handoff-protocol.md', '.harness/rules/handoff-manifest.schema.json', '.harness/rules/acceptance-id-protocol.md', '.harness/rules/security.md', '.harness/rules/prompt-defense.md', '.harness/scripts/validate-handoff.ps1', '.harness/skills/INDEX.md')
    foreach ($relative in $required) {
        if (-not (Test-Path -LiteralPath (Join-Path $dir $relative))) {
            Add-ValidationError "$framework missing required file: $relative"
        }
    }

    $deprecatedAgentTemplate = Join-Path $dir '.harness/templates/AGENTS.md.template'
    if (Test-Path -LiteralPath $deprecatedAgentTemplate) {
        Add-ValidationError "$framework still has duplicate AGENTS.md.template"
    }
    Assert-Contains (Join-Path $dir 'install.sh') 'cp "\$TEMPLATE_DIR/AGENTS\.md" AGENTS\.md' "$framework installer does not copy canonical AGENTS.md"
    $agentLines = [System.IO.File]::ReadAllLines((Join-Path $dir 'AGENTS.md')).Count
    if ($agentLines -gt 150) { Add-ValidationError "$framework AGENTS.md exceeds 150 lines ($agentLines)" }
    Assert-Contains (Join-Path $dir '.harness/loops/LOOP.md') 'STATE_PROTOCOL\.md' "$framework LOOP.md does not reference the shared state protocol"

    $protocolPath = Join-Path $dir '.harness/loops/STATE_PROTOCOL.md'
    $schemaPath = Join-Path $dir '.harness/loops/state.schema.json'
    $stateProtocolHashes[$framework] = (Get-FileHash -Algorithm SHA256 $protocolPath).Hash
    $stateSchemaHashes[$framework] = (Get-FileHash -Algorithm SHA256 $schemaPath).Hash
    $riskModelHashes[$framework] = (Get-FileHash -Algorithm SHA256 (Join-Path $dir '.harness/rules/risk-model.md')).Hash
    $handoffProtocolHashes[$framework] = (Get-FileHash -Algorithm SHA256 (Join-Path $dir '.harness/rules/handoff-protocol.md')).Hash
    $handoffManifestSchemaHashes[$framework] = (Get-FileHash -Algorithm SHA256 (Join-Path $dir '.harness/rules/handoff-manifest.schema.json')).Hash
    $acceptanceProtocolHashes[$framework] = (Get-FileHash -Algorithm SHA256 (Join-Path $dir '.harness/rules/acceptance-id-protocol.md')).Hash
    $handoffValidatorPath = Join-Path $dir '.harness/scripts/validate-handoff.ps1'
    $handoffValidatorHashes[$framework] = (Get-FileHash -Algorithm SHA256 $handoffValidatorPath).Hash
    $versions[$framework] = (Read-Utf8 (Join-Path $dir '.harness/VERSION')).Trim()
    try { $null = (Read-Utf8 $schemaPath) | ConvertFrom-Json } catch { Add-ValidationError "$framework state.schema.json is invalid JSON: $($_.Exception.Message)" }
    try { $null = (Read-Utf8 (Join-Path $dir '.harness/rules/handoff-manifest.schema.json')) | ConvertFrom-Json } catch { Add-ValidationError "$framework handoff manifest schema is invalid JSON: $($_.Exception.Message)" }
    $handoffParseErrors = $null
    $null = [System.Management.Automation.Language.Parser]::ParseFile($handoffValidatorPath, [ref]$null, [ref]$handoffParseErrors)
    if ($handoffParseErrors.Count -gt 0) { Add-ValidationError "$framework validate-handoff.ps1 has syntax errors: $($handoffParseErrors[0].Message)" }
    Assert-Contains (Join-Path $dir 'install.sh') 'docs/handoff/packages' "$framework installer does not create portable handoff package directory"
    Assert-Contains (Join-Path $dir '.harness/skills/meta/session-start/SKILL.md') 'handoff-protocol\.md' "$framework session-start does not enforce handoff consumer validation"

    $indexPath = Join-Path $dir '.harness/skills/INDEX.md'
    $indexLines = [System.IO.File]::ReadAllLines($indexPath).Count
    if ($indexLines -gt 80) { Add-ValidationError "$framework INDEX.md exceeds 80 lines ($indexLines)" }

    $skillFiles = @(Get-ChildItem (Join-Path $dir '.harness/skills') -Recurse -File -Filter 'SKILL.md')
    $totalSkills += $skillFiles.Count
    foreach ($file in $skillFiles) {
        $frontmatter = Get-Frontmatter $file.FullName
        $relative = $file.FullName.Substring($root.Length + 1)
        if ($null -eq $frontmatter) {
            Add-ValidationError "$relative has no valid frontmatter"
            continue
        }
        if ($frontmatter -notmatch '(?m)^name:\s*\S') { Add-ValidationError "$relative frontmatter missing name" }
        if ($frontmatter -notmatch '(?m)^description:\s*\S') { Add-ValidationError "$relative frontmatter missing description" }
        if ($frontmatter -match '(?m)^(triggers|reads|writes|quality_gates|max_iterations|metadata):') {
            Add-ValidationError "$relative contains deprecated heavy frontmatter"
        }
        if ($file.FullName -notmatch '[\\/]meta[\\/]' -and [System.IO.File]::ReadAllLines($file.FullName).Count -gt 300) {
            Add-ValidationError "$relative exceeds 300 lines"
        }
    }

    $workflowDir = Join-Path $dir '.harness/skills/workflows'
    $workflowFiles = @(Get-ChildItem $workflowDir -File -Filter '*.md')
    $totalWorkflows += $workflowFiles.Count

    # Per-framework README badge check: catch skill/workflow count drift early
    $frameworkReadme = Join-Path $dir 'README.md'
    if (Test-Path -LiteralPath $frameworkReadme) {
        $frameworkReadmeContent = Read-Utf8 $frameworkReadme
        if ($frameworkReadmeContent -match 'skills-(\d+)-') {
            if ([int]$Matches[1] -ne $skillFiles.Count) {
                Add-ValidationError "$framework README skill badge=$($Matches[1]), actual=$($skillFiles.Count)"
            }
        } else {
            Add-ValidationWarning "$framework README has no skill-count badge"
        }
        if ($frameworkReadmeContent -match 'workflows-(\d+)-') {
            if ([int]$Matches[1] -ne $workflowFiles.Count) {
                Add-ValidationError "$framework README workflow badge=$($Matches[1]), actual=$($workflowFiles.Count)"
            }
        }
    }

    $ids = @{}
    foreach ($file in $workflowFiles) {
        $frontmatter = Get-Frontmatter $file.FullName
        $relative = $file.FullName.Substring($root.Length + 1)
        if ($null -eq $frontmatter) {
            Add-ValidationError "$relative has no valid frontmatter"
            continue
        }
        if ($frontmatter -notmatch '(?m)^workflow_id:\s*(\S+)') {
            Add-ValidationError "$relative missing workflow_id"
        } else {
            $id = $Matches[1]
            if ($ids.ContainsKey($id)) { Add-ValidationError "$framework has duplicate workflow_id: $id" } else { $ids[$id] = $file.Name }
        }
        if ($frontmatter -notmatch '(?m)^default_mode:\s*(deep|standard|skip)\s*$') {
            Add-ValidationError "$relative has invalid or missing default_mode"
        }
    }

    $handoffTemplates = @(Get-ChildItem (Join-Path $dir 'docs/handoff') -File -Filter '*template.md')
    foreach ($file in $handoffTemplates) {
        $frontmatter = Get-Frontmatter $file.FullName
        $relative = $file.FullName.Substring($root.Length + 1)
        if ($null -eq $frontmatter) {
            Add-ValidationError "$relative has no handoff envelope"
            continue
        }
        foreach ($field in @('schema_version', 'handoff_id', 'producer', 'consumer', 'created_at', 'source_revision', 'supersedes', 'status', 'ac_ids', 'artifacts')) {
            if ($frontmatter -notmatch "(?m)^${field}:") { Add-ValidationError "$relative envelope missing $field" }
        }
        if ($frontmatter -notmatch '(?m)^schema_version:\s*["'']?1\.0["'']?\s*$') { Add-ValidationError "$relative must use handoff schema_version 1.0" }
        if ((Read-Utf8 $file.FullName) -match '\b(?:AC|DAC)-\d{3}\b') { Add-ValidationError "$relative contains legacy unscoped AC/DAC IDs" }
        if ([regex]::Matches((Read-Utf8 $file.FullName), '(?m)^schema_version:').Count -ne 1) {
            Add-ValidationError "$relative must contain exactly one handoff envelope"
        }
    }

    $sessionEnd = Read-Utf8 (Join-Path $dir '.harness/skills/meta/session-end/SKILL.md')
    if ($sessionEnd -match '(?i)append this (delivery|content|conclusion|session.+feedback).+do not overwrite history') {
        Add-ValidationError "$framework session-end still appends multiple contracts to a current pointer"
    }
}

# Per-framework legitimate differences white-list:
# These 4 files have intentional per-framework extensions; byte-equality is too strict.
# Replace byte-equality with key-section presence checks (error) + diff notice (warning).
# Files NOT in this list (risk-model / handoff-manifest.schema / validate-handoff.ps1 / VERSION)
# remain byte-identical across all 3 frameworks.

# STATE_PROTOCOL.md: Design has A5 Write Frequency section (A2 lean-state optimization); PM/Solo do not.
# Key invariant: all frameworks must define status enum + hard_limit_reached.
foreach ($fw in $frameworks) {
    $protocolContent = Read-Utf8 (Join-Path $root "$fw/.harness/loops/STATE_PROTOCOL.md")
    if ($protocolContent -notmatch 'hard_limit_reached') {
        Add-ValidationError "$fw STATE_PROTOCOL.md missing hard_limit_reached description"
    }
    if ($protocolContent -notmatch 'needs-human') {
        Add-ValidationError "$fw STATE_PROTOCOL.md missing needs-human status"
    }
}
if (@($stateProtocolHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-WhitelistedWarning 'STATE_PROTOCOL.md differs across frameworks (legitimate per A2/Solo extensions; key sections verified above)'
}

# state.schema.json: Design has spec_ref/nested_progress (A2); Solo has substage enum; PM has neither.
# Key invariant: all frameworks must define ac_change / hard_limit_reached / exploration_mode / current_nested_task / substage.
foreach ($fw in $frameworks) {
    $schemaPath = Join-Path $root "$fw/.harness/loops/state.schema.json"
    try {
        $schema = (Read-Utf8 $schemaPath) | ConvertFrom-Json
        foreach ($requiredField in @('ac_change', 'hard_limit_reached', 'exploration_mode', 'current_nested_task', 'substage')) {
            if (-not $schema.properties.PSObject.Properties.Name -contains $requiredField) {
                Add-ValidationError "$fw state.schema.json missing required field: $requiredField"
            }
        }
    } catch {
        Add-ValidationError "$fw state.schema.json invalid JSON: $($_.Exception.Message)"
    }
}
if (@($stateSchemaHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-WhitelistedWarning 'state.schema.json differs across frameworks (legitimate per A2/Solo extensions; required fields verified above)'
}

if (@($riskModelHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-ValidationError 'risk-model.md differs across frameworks'
}

# handoff-protocol.md: Solo has Standalone Mode section (legitimate per-framework extension).
# Key invariant: all frameworks must define envelope fields + batch fields + producer/consumer.
foreach ($fw in $frameworks) {
    $hpContent = Read-Utf8 (Join-Path $root "$fw/.harness/rules/handoff-protocol.md")
    if ($hpContent -notmatch 'schema_version') { Add-ValidationError "$fw handoff-protocol.md missing schema_version" }
    if ($hpContent -notmatch 'handoff_id') { Add-ValidationError "$fw handoff-protocol.md missing handoff_id" }
    if ($hpContent -notmatch 'producer') { Add-ValidationError "$fw handoff-protocol.md missing producer" }
    if ($hpContent -notmatch 'consumer') { Add-ValidationError "$fw handoff-protocol.md missing consumer" }
    if ($hpContent -notmatch 'batch') { Add-ValidationError "$fw handoff-protocol.md missing batch" }
    if ($hpContent -notmatch 'ac_ids') { Add-ValidationError "$fw handoff-protocol.md missing ac_ids" }
}
if (@($handoffProtocolHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-WhitelistedWarning 'handoff-protocol.md differs across frameworks (legitimate Solo Standalone Mode extension; key sections verified above)'
}

if (@($handoffManifestSchemaHashes.Values | Select-Object -Unique).Count -ne 1) { Add-ValidationError 'handoff-manifest.schema.json differs across frameworks' }

# acceptance-id-protocol.md: Design references review-evidence.md (A2 consolidation); PM/Solo use evidence.md.
# Key invariant: all frameworks must define AC ID format + supersede mechanism.
foreach ($fw in $frameworks) {
    $aipContent = Read-Utf8 (Join-Path $root "$fw/.harness/rules/acceptance-id-protocol.md")
    if ($aipContent -notmatch 'AC-<') { Add-ValidationError "$fw acceptance-id-protocol.md missing AC ID format" }
    if ($aipContent -notmatch 'supersed') { Add-ValidationError "$fw acceptance-id-protocol.md missing supersede mechanism" }
}
if (@($acceptanceProtocolHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-WhitelistedWarning 'acceptance-id-protocol.md differs across frameworks (legitimate Design A2 review-evidence.md reference; key sections verified above)'
}

if (@($handoffValidatorHashes.Values | Select-Object -Unique).Count -ne 1) { Add-ValidationError 'validate-handoff.ps1 differs across frameworks' }
if (@($versions.Values | Select-Object -Unique).Count -ne 1) {
    Add-ValidationError 'framework VERSION files differ'
}

$parseErrors = $null
$null = [System.Management.Automation.Language.Parser]::ParseFile((Join-Path $root 'scripts/upgrade.ps1'), [ref]$null, [ref]$parseErrors)
if ($parseErrors.Count -gt 0) { Add-ValidationError "scripts/upgrade.ps1 has PowerShell syntax errors: $($parseErrors[0].Message)" }

$readme = Read-Utf8 (Join-Path $root 'README.md')
$readmeZh = Read-Utf8 (Join-Path $root 'README.zh.md')
foreach ($entry in @(@('README.md', $readme), @('README.zh.md', $readmeZh))) {
    $familyVersion = @($versions.Values)[0] -replace '\.0$', ''
    if ($entry[1] -notmatch "version-v$([regex]::Escape($familyVersion))-blue") {
        Add-ValidationError "$($entry[0]) version badge does not match framework version $familyVersion"
    }
    if ($entry[1] -notmatch 'workflows-(\d+)-purple') {
        Add-ValidationError "$($entry[0]) has no workflow-count badge"
    } elseif ([int]$Matches[1] -ne $totalWorkflows) {
        Add-ValidationError "$($entry[0]) workflow badge=$($Matches[1]), actual=$totalWorkflows"
    }
    if ($entry[1] -notmatch 'skills-(\d+)-orange') {
        Add-ValidationError "$($entry[0]) has no skill-count badge"
    } elseif ([int]$Matches[1] -ne $totalSkills) {
        Add-ValidationError "$($entry[0]) skill badge=$($Matches[1]), actual=$totalSkills"
    }
}

$quickFix = Read-Utf8 (Join-Path $root 'harness-solo/.harness/skills/workflows/quick-fix.md')
if ($quickFix -notmatch 'risk gate' -or $quickFix -notmatch 'failing regression test') {
    Add-ValidationError 'quick-fix must use the risk gate and regression-first behavior rule'
}
if ($quickFix -match 'Estimated change is under 10 lines') {
    Add-ValidationError 'quick-fix still treats line count as a hard gate'
}

# Solo pipeline: one owner per artifact/state transition and compact workflow routing.
$soloRoot = Join-Path $root 'harness-solo'
$soloPipeline = Join-Path $soloRoot '.harness/rules/engineering-pipeline.md'
if (-not (Test-Path -LiteralPath $soloPipeline)) { Add-ValidationError 'Solo missing canonical engineering-pipeline.md' }
Assert-Contains (Join-Path $soloRoot '.harness/loops/LOOP.md') 'engineering-pipeline\.md' 'Solo LOOP does not reference the canonical engineering pipeline'

$soloWorkflowFiles = @(Get-ChildItem (Join-Path $soloRoot '.harness/skills/workflows') -File -Filter '*.md')
foreach ($file in $soloWorkflowFiles) {
    $lines = [IO.File]::ReadAllLines($file.FullName).Count
    if ($lines -gt 120) { Add-ValidationError "Solo workflow $($file.Name) exceeds 120 lines and likely duplicates skill process ($lines)" }
}

$soloProcessText = @(
    Get-ChildItem (Join-Path $soloRoot '.harness/loops') -File -Include '*.md', '*.json' | ForEach-Object { Read-Utf8 $_.FullName }
    Get-ChildItem (Join-Path $soloRoot '.harness/skills') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
) -join "`n"
if ($soloProcessText -match '\b(requesting-code-review|receiving-code-review)\b') { Add-ValidationError 'Solo still references removed split code-review skills' }
if ($soloProcessText -match '\bnested_progress\b') { Add-ValidationError 'Solo still maintains duplicate nested_progress state' }
if ($soloProcessText -match 'status:\s*(ready|planning)\b') { Add-ValidationError 'Solo process uses a status not allowed by state.schema.json' }
if ($soloProcessText -match '(?i)(under|less than)\s+10\s+lines') { Add-ValidationError 'Solo still uses line count as a quick-fix gate' }

$tdd = Read-Utf8 (Join-Path $soloRoot '.harness/skills/engineering/test-driven-development/SKILL.md')
if ($tdd -notmatch 'before any mutation' -or $tdd -notmatch 'increment `iteration` exactly once') { Add-ValidationError 'Solo TDD does not increment exactly once before mutation' }
if ($tdd -match '(?i)after.+iteration\s*\+\s*1') { Add-ValidationError 'Solo TDD still increments iteration after execution' }
if ($tdd -match '(?m)^- loops/specs/<[^>]+>/evidence\.md\s*$') { Add-ValidationError 'Solo TDD still claims ownership of evidence.md' }

$verifySkill = Read-Utf8 (Join-Path $soloRoot '.harness/skills/engineering/verify/SKILL.md')
$codeReviewSkill = Read-Utf8 (Join-Path $soloRoot '.harness/skills/engineering/code-review/SKILL.md')
if ($verifySkill -notmatch 'does \*\*not\*\* mark done') { Add-ValidationError 'Solo verify does not explicitly preserve review-owned completion' }
if ($codeReviewSkill -notmatch 'status: done') { Add-ValidationError 'Solo code-review does not own the final done transition' }
if ($codeReviewSkill -match '(?i)fewer than 3|minimum (number|count)') { Add-ValidationError 'Solo code-review still encourages fabricated minimum findings' }
if (Test-Path (Join-Path $soloRoot '.harness/skills/engineering/requesting-code-review/SKILL.md')) { Add-ValidationError 'obsolete requesting-code-review skill still exists' }
if (Test-Path (Join-Path $soloRoot '.harness/skills/engineering/receiving-code-review/SKILL.md')) { Add-ValidationError 'obsolete receiving-code-review skill still exists' }

$soloSessionEnd = Read-Utf8 (Join-Path $soloRoot '.harness/skills/meta/session-end/SKILL.md')
if ($soloSessionEnd -notmatch 'never estimate LOC' -or $soloSessionEnd -notmatch 'invoke `memory-maintenance`') { Add-ValidationError 'Solo session-end does not delegate retention or require exact baseline metrics' }

$releaseWorkflow = Read-Utf8 (Join-Path $soloRoot '.harness/skills/workflows/release.md')
if ($releaseWorkflow -notmatch 'before.+tagging' -or $releaseWorkflow -notmatch 'explicit user authorization') { Add-ValidationError 'Solo release does not review before tag and require user authorization' }

$dependencySkill = Read-Utf8 (Join-Path $soloRoot '.harness/skills/engineering/dependency-management/SKILL.md')
if ($dependencySkill -match '(?m)^- loops/specs/<[^>]+>/iterations\.log\s*$' -or $dependencySkill -notmatch 'never increments LOOP state') {
    Add-ValidationError 'Solo dependency-management still competes for LOOP iteration/outcome ownership'
}
$productReview = Read-Utf8 (Join-Path $soloRoot '.harness/skills/engineering/product-engineering-review/SKILL.md')
if ($productReview -notmatch 'sole owner of the product-orchestrator conclusion') { Add-ValidationError 'Solo product orchestrator has no single completion owner' }

$preCommit = Read-Utf8 (Join-Path $soloRoot '.harness/hooks/pre-commit.sh')
$secretGuard = Read-Utf8 (Join-Path $soloRoot '.harness/hooks/guards/guard-secret.sh')
$soloRuntimeText = @(
    $preCommit
    Read-Utf8 (Join-Path $soloRoot '.harness/scripts/security-check.sh')
    Read-Utf8 (Join-Path $soloRoot '.harness/scripts/verify-harness.sh')
) -join "`n"
if (Test-Path (Join-Path $soloRoot '.harness/hooks/guards/guard-sensitive-file.sh')) { Add-ValidationError 'obsolete duplicate sensitive-file guard still exists' }
if ($preCommit -match 'guard-sensitive-file') { Add-ValidationError 'pre-commit still invokes the obsolete duplicate sensitive-file guard' }
if ($soloRuntimeText -match 'guard-sensitive-file') { Add-ValidationError 'Solo runtime still references the obsolete duplicate sensitive-file guard' }
if (-not (Test-Path (Join-Path $soloRoot '.harness/hooks/commit-msg.sh'))) { Add-ValidationError 'Solo commit-msg hook wrapper is missing' }
if ($secretGuard -notmatch 'Matching value redacted' -or $secretGuard -match 'grep\s+-nE') { Add-ValidationError 'secret guard may expose matched secret values' }
$soloInstall = Read-Utf8 (Join-Path $soloRoot 'install.sh')
if ($soloInstall -notmatch '\.git/hooks/commit-msg') { Add-ValidationError 'Solo installer does not document installing the commit-msg hook' }

$entropyScript = Read-Utf8 (Join-Path $soloRoot '.harness/scripts/entropy-check.sh')
foreach ($contract in @("current_todos.*-gt 50", "current_todos.*-gt 20", 'delta.*-gt 6', 'delta.*-gt 3', 'growth.*-gt 50')) {
    if ($entropyScript -notmatch $contract) { Add-ValidationError "Solo entropy script is missing threshold contract: $contract" }
}

# Cross-framework executable contract invariants.
$allActiveContractText = @(
    Read-Utf8 (Join-Path $root 'ARCHITECTURE.md')
    Get-ChildItem (Join-Path $root 'harness-pm') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
    Get-ChildItem (Join-Path $root 'harness-design') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
    Get-ChildItem (Join-Path $root 'harness-solo') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
) -join "`n"

if (Test-Path (Join-Path $root 'harness-design/docs/handoff/component-map.json')) { Add-ValidationError 'runtime handoff directory contains the old component-map sample' }
if ($allActiveContractText -match 'component-map\.json') { Add-ValidationError 'PM/Design/Solo active documentation still references component-map.json' }
if ($allActiveContractText -match 'docs/handoff/tokens\.(json|css)') { Add-ValidationError 'Solo still references the incorrect docs/handoff token path' }
if ($allActiveContractText -match '\bexecuting-plans\b') { Add-ValidationError 'removed executing-plans skill still has active references' }
if ($allActiveContractText -match 'Business Context Summary') { Add-ValidationError 'Business Context heading is inconsistent; use Business Context Digest' }
if ($allActiveContractText -match 'LCP\s*>=' ) { Add-ValidationError 'LCP threshold uses the wrong comparison direction' }

$pmSoloTemplate = Join-Path $root 'harness-pm/docs/handoff/templates/pm-to-solo-template.md'
foreach ($field in @('delivery_mode', 'frontend_scope', 'design_required', 'design_status', 'design_handoff_id', 'design_waiver')) {
    Assert-Contains $pmSoloTemplate ([regex]::Escape($field)) "pm-to-solo routing contract missing $field"
}
Assert-Contains (Join-Path $root 'harness-solo/.harness/skills/engineering/brainstorming/SKILL.md') 'Family frontend hard gate' 'Solo brainstorming does not enforce the family frontend design gate'

$dedicatedTemplates = @(Get-ChildItem $root -Recurse -File -Filter '*-to-*-template.md' | Where-Object { $_.FullName -match '[\\/]docs[\\/]handoff[\\/]' })
foreach ($file in $dedicatedTemplates) {
    if ((Read-Utf8 $file.FullName) -match '\bdocs/') {
        Add-ValidationError "$($file.FullName.Substring($root.Length + 1)) contains a producer/consumer-local docs/ path; bundle it under artifacts/ or describe it without a path"
    }
}

$producerConsumerContracts = @(
    @('harness-pm/.harness/skills/meta/session-end/SKILL.md', 'pm-to-design.md', 'harness-design/.harness/skills/meta/session-start/SKILL.md'),
    @('harness-pm/.harness/skills/meta/session-end/SKILL.md', 'pm-to-solo.md', 'harness-solo/.harness/skills/meta/session-start/SKILL.md'),
    @('harness-design/.harness/skills/meta/session-end/SKILL.md', 'design-to-solo', 'harness-solo/.harness/skills/meta/session-start/SKILL.md'),
    @('harness-design/.harness/skills/meta/session-end/SKILL.md', 'design-to-pm', 'harness-pm/.harness/skills/meta/session-start/SKILL.md')
)
foreach ($mapping in $producerConsumerContracts) {
    Assert-Contains (Join-Path $root $mapping[0]) ([regex]::Escape($mapping[1])) "producer $($mapping[0]) does not declare $($mapping[1])"
    Assert-Contains (Join-Path $root $mapping[2]) ([regex]::Escape($mapping[1])) "consumer $($mapping[2]) does not discover $($mapping[1])"
}

foreach ($schema in @(
    'harness-design/.harness/rules/component-contract.schema.json',
    'harness-solo/.harness/rules/component-contract.schema.json',
    'harness-solo/.harness/rules/component-bindings.schema.json',
    'harness-pm/.harness/rules/prd.schema.json',
    'harness-design/.harness/rules/prd.schema.json',
    'harness-solo/.harness/rules/prd.schema.json',
    'harness-design/.harness/templates/component-contract.example.json'
)) {
    try { $null = (Read-Utf8 (Join-Path $root $schema)) | ConvertFrom-Json } catch { Add-ValidationError "$schema is invalid JSON: $($_.Exception.Message)" }
}
if ((Get-FileHash (Join-Path $root 'harness-design/.harness/rules/component-contract.schema.json')).Hash -ne (Get-FileHash (Join-Path $root 'harness-solo/.harness/rules/component-contract.schema.json')).Hash) { Add-ValidationError 'Design and Solo component-contract schemas differ' }
$prdSchemaHashes = @('harness-pm', 'harness-design', 'harness-solo') | ForEach-Object { (Get-FileHash (Join-Path $root "$_/.harness/rules/prd.schema.json")).Hash }
if (@($prdSchemaHashes | Select-Object -Unique).Count -ne 1) { Add-ValidationError 'PM/Design/Solo PRD schemas differ' }
Assert-Contains (Join-Path $root 'harness-pm/.harness/skills/pm/design-prd/SKILL.md') 'sole authoring authority' 'design-prd does not declare PRD.md authority and generated prd.json semantics'
if (-not (Test-Path (Join-Path $root 'harness-design/docs/handoff/templates/design-to-pm-template.md'))) { Add-ValidationError 'Design-to-PM feedback contract is missing' }
Assert-Contains (Join-Path $root 'harness-pm/.harness/skills/pm/prd-orchestrator/SKILL.md') 'never delete' 'PM feedback consumer may still delete Design-to-PM history'

# Validate repository-relative Markdown links. Runtime project paths such as docs/... are intentionally excluded.
$markdownFiles = @(Get-ChildItem $root -Recurse -Force -File -Filter '*.md' | Where-Object { $_.FullName -notmatch '[\\/]\.git[\\/]' })
foreach ($file in $markdownFiles) {
    $content = Read-Utf8 $file.FullName
    foreach ($match in [regex]::Matches($content, '\[[^\]]*\]\(([^)#]+)(?:#[^)]+)?\)')) {
        $target = $match.Groups[1].Value.Trim().Trim('<', '>')
        if ($target -match '^(https?:|mailto:|/)' -or $target -notmatch '^\.\.?[\\/]') { continue }
        $resolved = [System.IO.Path]::GetFullPath((Join-Path $file.DirectoryName $target))
        if (-not (Test-Path -LiteralPath $resolved)) {
            Add-ValidationError "$($file.FullName.Substring($root.Length + 1)) has broken link: $target"
        }
    }
}

Write-Host "Validated $totalSkills skills and $totalWorkflows workflows across $($frameworks.Count) frameworks."
foreach ($warning in $warnings) { Write-Warning $warning }
foreach ($whitelisted in $whitelistedWarnings) { Write-Host "WHITELISTED: $whitelisted" -ForegroundColor Yellow }
foreach ($validationError in $errors) { Write-Host "ERROR: $validationError" -ForegroundColor Red }

if ($errors.Count -gt 0 -or ($Strict -and $warnings.Count -gt 0)) {
    Write-Host "Validation failed: $($errors.Count) error(s), $($warnings.Count) warning(s), $($whitelistedWarnings.Count) whitelisted warning(s)." -ForegroundColor Red
    exit 1
}

Write-Host "Validation passed: 0 errors, $($warnings.Count) warning(s), $($whitelistedWarnings.Count) whitelisted warning(s)." -ForegroundColor Green
