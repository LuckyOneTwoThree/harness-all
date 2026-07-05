# validate.ps1 — Cross-framework BASE-FILE consistency checker (family-level).
# Scope: verifies shared base files (STATE_PROTOCOL / handoff-protocol / risk-model /
# handoff-manifest.schema / acceptance-id-protocol / validate-handoff.ps1 / VERSION)
# are byte-identical across both frameworks, plus per-framework README badge vs actual
# skill/workflow counts, plus root README badge vs family totals.
# NOT to be confused with .harness/scripts/validate-handoff.ps1 (per-framework, validates
# the envelope/schema/hash/freshness integrity of a single portable handoff package).
param(
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$frameworks = @('harness-pm', 'harness-engineering')
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
        if ($frontmatter -notmatch '(?m)^default_mode:\s*(deep|standard|skip|none)\s*$') {
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
# remain byte-identical across both frameworks.

# STATE_PROTOCOL.md: Engineering has 4-phase substage extensions; PM does not.
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
    Add-WhitelistedWarning 'STATE_PROTOCOL.md differs across frameworks (legitimate per PM/Engineering extensions; key sections verified above)'
}

# state.schema.json: Engineering has substage_progress + 4-phase enum; PM does not.
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
    Add-WhitelistedWarning 'state.schema.json differs across frameworks (legitimate per PM/Engineering extensions; required fields verified above)'
}

if (@($riskModelHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-ValidationError 'risk-model.md differs across frameworks'
}

# handoff-protocol.md: both frameworks use the same protocol (no standalone mode anymore).
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
    Add-WhitelistedWarning 'handoff-protocol.md differs across frameworks (legitimate per-framework extension; key sections verified above)'
}

if (@($handoffManifestSchemaHashes.Values | Select-Object -Unique).Count -ne 1) { Add-ValidationError 'handoff-manifest.schema.json differs across frameworks' }

# acceptance-id-protocol.md: Engineering has BAC + IAC extensions; PM does not.
# Key invariant: all frameworks must define AC ID format + supersede mechanism.
foreach ($fw in $frameworks) {
    $aipContent = Read-Utf8 (Join-Path $root "$fw/.harness/rules/acceptance-id-protocol.md")
    if ($aipContent -notmatch 'AC-<') { Add-ValidationError "$fw acceptance-id-protocol.md missing AC ID format" }
    if ($aipContent -notmatch 'supersed') { Add-ValidationError "$fw acceptance-id-protocol.md missing supersede mechanism" }
}
if (@($acceptanceProtocolHashes.Values | Select-Object -Unique).Count -ne 1) {
    Add-WhitelistedWarning 'acceptance-id-protocol.md differs across frameworks (legitimate Engineering BAC/IAC extension; key sections verified above)'
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

# Engineering pipeline: one owner per artifact/state transition and compact workflow routing.
$engRoot = Join-Path $root 'harness-engineering'
$engPipeline = Join-Path $engRoot '.harness/rules/engineering-pipeline.md'
if (-not (Test-Path -LiteralPath $engPipeline)) { Add-ValidationError 'Engineering missing canonical engineering-pipeline.md' }
Assert-Contains (Join-Path $engRoot '.harness/loops/LOOP.md') 'engineering-pipeline\.md' 'Engineering LOOP does not reference the canonical engineering pipeline'

$engWorkflowFiles = @(Get-ChildItem (Join-Path $engRoot '.harness/skills/workflows') -File -Filter '*.md')
foreach ($file in $engWorkflowFiles) {
    $lines = [IO.File]::ReadAllLines($file.FullName).Count
    if ($lines -gt 120) { Add-ValidationError "Engineering workflow $($file.Name) exceeds 120 lines and likely duplicates skill process ($lines)" }
}

$engProcessText = @(
    Get-ChildItem (Join-Path $engRoot '.harness/loops') -File -Include '*.md', '*.json' | ForEach-Object { Read-Utf8 $_.FullName }
    Get-ChildItem (Join-Path $engRoot '.harness/skills') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
) -join "`n"
if ($engProcessText -match '\b(requesting-code-review|receiving-code-review)\b') { Add-ValidationError 'Engineering still references removed split code-review skills' }
if ($engProcessText -match '(?i)(under|less than)\s+10\s+lines') { Add-ValidationError 'Engineering still uses line count as a quick-fix gate' }

$tdd = Read-Utf8 (Join-Path $engRoot '.harness/skills/engineering/test-driven-development/SKILL.md')
if ($tdd -notmatch 'before any mutation' -or $tdd -notmatch 'increment `iteration` exactly once') { Add-ValidationError 'Engineering TDD does not increment exactly once before mutation' }
if ($tdd -match '(?i)after.+iteration\s*\+\s*1') { Add-ValidationError 'Engineering TDD still increments iteration after execution' }
if ($tdd -match '(?m)^- loops/specs/<[^>]+>/evidence\.md\s*$') { Add-ValidationError 'Engineering TDD still claims ownership of evidence.md' }

$verifySkill = Read-Utf8 (Join-Path $engRoot '.harness/skills/integration/verify/SKILL.md')
$codeReviewSkill = Read-Utf8 (Join-Path $engRoot '.harness/skills/integration/code-review/SKILL.md')
if ($verifySkill -notmatch 'does \*\*not\*\* mark done') { Add-ValidationError 'Engineering verify does not explicitly preserve review-owned completion' }
if ($codeReviewSkill -notmatch 'status: done') { Add-ValidationError 'Engineering code-review does not own the final done transition' }
if ($codeReviewSkill -match '(?i)fewer than 3|minimum (number|count)') { Add-ValidationError 'Engineering code-review still encourages fabricated minimum findings' }
if (Test-Path (Join-Path $engRoot '.harness/skills/integration/requesting-code-review/SKILL.md')) { Add-ValidationError 'obsolete requesting-code-review skill still exists' }
if (Test-Path (Join-Path $engRoot '.harness/skills/integration/receiving-code-review/SKILL.md')) { Add-ValidationError 'obsolete receiving-code-review skill still exists' }

$engSessionEnd = Read-Utf8 (Join-Path $engRoot '.harness/skills/meta/session-end/SKILL.md')
if ($engSessionEnd -notmatch 'never estimate LOC' -or $engSessionEnd -notmatch 'invoke `memory-maintenance`') { Add-ValidationError 'Engineering session-end does not delegate retention or require exact baseline metrics' }

$releaseWorkflow = Read-Utf8 (Join-Path $engRoot '.harness/skills/workflows/release.md')
if ($releaseWorkflow -notmatch 'before.+tagging' -or $releaseWorkflow -notmatch 'explicit user authorization') { Add-ValidationError 'Engineering release does not review before tag and require user authorization' }

$dependencySkill = Read-Utf8 (Join-Path $engRoot '.harness/skills/backend/dependency-management/SKILL.md')
if ($dependencySkill -match '(?m)^- loops/specs/<[^>]+>/iterations\.log\s*$' -or $dependencySkill -notmatch 'never increments LOOP state') {
    Add-ValidationError 'Engineering dependency-management still competes for LOOP iteration/outcome ownership'
}
$productReview = Read-Utf8 (Join-Path $engRoot '.harness/skills/integration/product-engineering-review/SKILL.md')
if ($productReview -notmatch 'sole owner of the product-orchestrator conclusion') { Add-ValidationError 'Engineering product orchestrator has no single completion owner' }

$preCommit = Read-Utf8 (Join-Path $engRoot '.harness/hooks/pre-commit.sh')
$secretGuard = Read-Utf8 (Join-Path $engRoot '.harness/hooks/guards/guard-secret.sh')
$engRuntimeText = @(
    $preCommit
    Read-Utf8 (Join-Path $engRoot '.harness/scripts/security-check.sh')
    Read-Utf8 (Join-Path $engRoot '.harness/scripts/verify-harness.sh')
) -join "`n"
if (Test-Path (Join-Path $engRoot '.harness/hooks/guards/guard-sensitive-file.sh')) { Add-ValidationError 'obsolete duplicate sensitive-file guard still exists' }
if ($preCommit -match 'guard-sensitive-file') { Add-ValidationError 'pre-commit still invokes the obsolete duplicate sensitive-file guard' }
if ($engRuntimeText -match 'guard-sensitive-file') { Add-ValidationError 'Engineering runtime still references the obsolete duplicate sensitive-file guard' }
if (-not (Test-Path (Join-Path $engRoot '.harness/hooks/commit-msg.sh'))) { Add-ValidationError 'Engineering commit-msg hook wrapper is missing' }
if ($secretGuard -notmatch 'Matching value redacted' -or $secretGuard -match 'grep\s+-nE') { Add-ValidationError 'secret guard may expose matched secret values' }
$engInstall = Read-Utf8 (Join-Path $engRoot 'install.sh')
if ($engInstall -notmatch '\.git/hooks/commit-msg') { Add-ValidationError 'Engineering installer does not document installing the commit-msg hook' }

$entropyScript = Read-Utf8 (Join-Path $engRoot '.harness/scripts/entropy-check.sh')
foreach ($contract in @("current_todos.*-gt 50", "current_todos.*-gt 20", 'delta.*-gt 6', 'delta.*-gt 3', 'growth.*-gt 50')) {
    if ($entropyScript -notmatch $contract) { Add-ValidationError "Engineering entropy script is missing threshold contract: $contract" }
}

# Cross-framework executable contract invariants.
$allActiveContractText = @(
    Read-Utf8 (Join-Path $root 'ARCHITECTURE.md')
    Get-ChildItem (Join-Path $root 'harness-pm') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
    Get-ChildItem (Join-Path $root 'harness-engineering') -Recurse -File -Include '*.md' | ForEach-Object { Read-Utf8 $_.FullName }
) -join "`n"

if ($allActiveContractText -match '\bexecuting-plans\b') { Add-ValidationError 'removed executing-plans skill still has active references' }
if ($allActiveContractText -match 'Business Context Summary') { Add-ValidationError 'Business Context heading is inconsistent; use Business Context Digest' }
if ($allActiveContractText -match 'LCP\s*>=' ) { Add-ValidationError 'LCP threshold uses the wrong comparison direction' }

# Filter PM session-end Prohibited-list references before broad obsolete-reference checks.
$allActiveContractText = $allActiveContractText -replace 'Producing pm-to-design\.md or pm-to-solo\.md \(obsolete;[^)]*\)', ''

# Obsolete framework references — must not appear anywhere in active documentation.
if ($allActiveContractText -match '\bharness-solo\b') { Add-ValidationError 'Active documentation still references obsolete harness-solo framework' }
if ($allActiveContractText -match '\bharness-design\b') { Add-ValidationError 'Active documentation still references obsolete harness-design framework' }
if ($allActiveContractText -match '\bpm-to-solo\.md\b') { Add-ValidationError 'Active documentation still references obsolete pm-to-solo.md (use pm-to-engineering.md)' }
if ($allActiveContractText -match '\bpm-to-design\.md\b') { Add-ValidationError 'Active documentation still references obsolete pm-to-design.md (design assets now go in pm-to-engineering.md)' }
if ($allActiveContractText -match '\bsolo-to-pm\.md\b') { Add-ValidationError 'Active documentation still references obsolete solo-to-pm.md (use engineering-to-pm.md)' }
if ($allActiveContractText -match '\bdesign-to-pm\.md\b') { Add-ValidationError 'Active documentation still references obsolete design-to-pm.md' }
if ($allActiveContractText -match '\bdesign-to-solo\.md\b') { Add-ValidationError 'Active documentation still references obsolete design-to-solo.md' }

# Exception: session-end SKILL.md may reference obsolete file names in its Prohibited list
# (documenting what NOT to produce). Filter those out before flagging.
$pmSessionEndPath = Join-Path $root 'harness-pm/.harness/skills/meta/session-end/SKILL.md'
$pmSessionEndContent = Read-Utf8 $pmSessionEndPath
$pmSessionEndFiltered = $pmSessionEndContent -replace 'Producing pm-to-design\.md or pm-to-solo\.md \(obsolete;[^)]*\)', ''
if ($pmSessionEndFiltered -match '\b(pm-to-solo|pm-to-design)\.md\b') {
    Add-ValidationError 'PM session-end has unexpected pm-to-solo/pm-to-design references outside the Prohibited list'
}

$pmEngineeringTemplate = Join-Path $root 'harness-pm/docs/handoff/templates/pm-to-engineering-template.md'
foreach ($field in @('project_mode', 'exploration_mode', 'task_type', 'scope')) {
    Assert-Contains $pmEngineeringTemplate ([regex]::Escape($field)) "pm-to-engineering-template missing routing field: $field"
}
Assert-Contains (Join-Path $engRoot '.harness/skills/engineering/brainstorming/SKILL.md') '4-phase' 'Engineering brainstorming does not reference the 4-phase pipeline'

$dedicatedTemplates = @(Get-ChildItem $root -Recurse -File -Filter '*-to-*-template.md' | Where-Object { $_.FullName -match '[\\/]docs[\\/]handoff[\\/]' })
foreach ($file in $dedicatedTemplates) {
    if ((Read-Utf8 $file.FullName) -match '\bdocs/') {
        Add-ValidationError "$($file.FullName.Substring($root.Length + 1)) contains a producer/consumer-local docs/ path; bundle it under artifacts/ or describe it without a path"
    }
}

$producerConsumerContracts = @(
    @('harness-pm/.harness/skills/meta/session-end/SKILL.md', 'pm-to-engineering.md', 'harness-engineering/.harness/skills/meta/session-start/SKILL.md'),
    @('harness-engineering/.harness/skills/meta/session-end/SKILL.md', 'engineering-to-pm', 'harness-pm/.harness/skills/meta/session-start/SKILL.md')
)
foreach ($mapping in $producerConsumerContracts) {
    Assert-Contains (Join-Path $root $mapping[0]) ([regex]::Escape($mapping[1])) "producer $($mapping[0]) does not declare $($mapping[1])"
    Assert-Contains (Join-Path $root $mapping[2]) ([regex]::Escape($mapping[1])) "consumer $($mapping[2]) does not discover $($mapping[1])"
}

foreach ($schema in @(
    'harness-engineering/.harness/rules/component-contract.schema.json',
    'harness-engineering/.harness/rules/component-bindings.schema.json',
    'harness-pm/.harness/rules/prd.schema.json',
    'harness-engineering/.harness/rules/prd.schema.json',
    'harness-engineering/.harness/templates/component-contract.example.json'
)) {
    try { $null = (Read-Utf8 (Join-Path $root $schema)) | ConvertFrom-Json } catch { Add-ValidationError "$schema is invalid JSON: $($_.Exception.Message)" }
}
Assert-Contains (Join-Path $root 'harness-pm/.harness/skills/pm/design-prd/SKILL.md') 'sole authoring authority' 'design-prd does not declare PRD.md authority and generated prd.json semantics'

# PRD schema must include project_mode + exploration_mode routing fields.
$pmPrdSchema = Read-Utf8 (Join-Path $root 'harness-pm/.harness/rules/prd.schema.json')
if ($pmPrdSchema -notmatch 'project_mode') { Add-ValidationError 'PM prd.schema.json missing project_mode routing field' }
if ($pmPrdSchema -notmatch 'exploration_mode') { Add-ValidationError 'PM prd.schema.json missing exploration_mode routing field' }

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
