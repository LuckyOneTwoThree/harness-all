<#
.SYNOPSIS
    Tests validate-artifacts.ps1 with synthetic fixtures to ensure state.schema.json
    constraints are actually enforced at runtime.

.DESCRIPTION
    The framework repo contains only templates, not real runtime artifacts (state.yaml,
    contract.json, etc.). validate-artifacts.ps1 is designed to validate those artifacts
    in user projects, but without synthetic tests there is no way to verify that the
    schema constraints (iteration maximum:10, status enum, allOf hard_limit_reached
    coupling, additionalProperties:false) are actually enforced.

    This script creates synthetic valid and invalid state.yaml fixtures, runs
    validate-artifacts.ps1 against each, and checks that:
      - Valid fixtures PASS (exit 0)
      - Invalid fixtures FAIL (exit 1)

    This is the artifacts-side equivalent of test-handoff-validator.ps1.

    Critical constraints tested:
      1. iteration maximum:10      (the hard circuit breaker)
      2. status enum                (no bogus status values)
      3. allOf/if-then              (hard_limit_reached=true => status=failed,
                                     iteration>=10, last_error required)
      4. additionalProperties:false (no unexpected fields)
      5. required fields            (current_task, iteration, stage, status, started_at)

    Requires: powershell-yaml module (for YAML parsing) and Test-Json with -Schema
    (for allOf/if-then enforcement, available in PowerShell 7+).
#>
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$engRoot = Join-Path $root 'harness-engineering'
$validator = Join-Path $engRoot '.harness/scripts/validate-artifacts.ps1'

# --- Prerequisite: a YAML parser must be available -------------------------
# validate-artifacts.ps1 supports: powershell-yaml module, yq, or python+PyYAML
$yamlAvailable = $false
if (Get-Module -ListAvailable powershell-yaml -ErrorAction SilentlyContinue) {
    $yamlAvailable = $true
} elseif (Get-Command yq -ErrorAction SilentlyContinue) {
    $yamlAvailable = $true
} elseif (Get-Command python -ErrorAction SilentlyContinue) {
    try { $null = & python -c "import yaml" 2>&1; if ($LASTEXITCODE -eq 0) { $yamlAvailable = $true } } catch { }
}
if (-not $yamlAvailable) {
    Write-Host "ERROR: No YAML parser available." -ForegroundColor Red
    Write-Host "  Install one of: powershell-yaml module, yq, or python+PyYAML" -ForegroundColor Red
    Write-Host "  Without it, validate-artifacts.ps1 skips state.yaml validation entirely." -ForegroundColor Red
    exit 1
}

# --- Prerequisite: Test-Json with -Schema (for allOf/if-then) --------------
$useTestJson = $false
$testJsonCmd = Get-Command Test-Json -ErrorAction SilentlyContinue
if ($testJsonCmd) {
    try { if ($testJsonCmd.Parameters.Keys -contains 'Schema') { $useTestJson = $true } } catch { }
}
if (-not $useTestJson) {
    Write-Host "NOTE: Test-Json -Schema not available (need PowerShell 7+)." -ForegroundColor DarkGray
    Write-Host "  allOf/if-then enforced via manual fallback in validate-artifacts.ps1." -ForegroundColor DarkGray
}

# --- Schema source files ---------------------------------------------------
$stateSchemaSrc    = Join-Path $engRoot '.harness/loops/state.schema.json'
$contractSchemaSrc = Join-Path $engRoot '.harness/rules/component-contract.schema.json'
$bindingsSchemaSrc = Join-Path $engRoot '.harness/rules/component-bindings.schema.json'

$tempBase = Join-Path ([IO.Path]::GetTempPath()) ("harness-artifacts-test-" + [guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $tempBase -Force

$passed = 0
$failed = 0

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { $null = New-Item -ItemType Directory -Path $parent }
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Copy-SchemaFiles([string]$DestRoot) {
    $null = New-Item -ItemType Directory -Path (Join-Path $DestRoot '.harness/loops') -Force
    $null = New-Item -ItemType Directory -Path (Join-Path $DestRoot '.harness/rules') -Force
    Copy-Item -LiteralPath $stateSchemaSrc    -Destination (Join-Path $DestRoot '.harness/loops/state.schema.json')
    Copy-Item -LiteralPath $contractSchemaSrc -Destination (Join-Path $DestRoot '.harness/rules/component-contract.schema.json')
    Copy-Item -LiteralPath $bindingsSchemaSrc -Destination (Join-Path $DestRoot '.harness/rules/component-bindings.schema.json')
}

function Run-StateScenario {
    param(
        [string]$Name,
        [string]$StateYaml,
        [bool]$ExpectPass
    )
    $scenarioDir = Join-Path $script:tempBase $Name
    $null = New-Item -ItemType Directory -Path $scenarioDir -Force
    Copy-SchemaFiles $scenarioDir

    $stateDir = Join-Path $scenarioDir 'loops/specs/test-task'
    $null = New-Item -ItemType Directory -Path $stateDir -Force
    Write-Utf8NoBom (Join-Path $stateDir 'state.yaml') $StateYaml

    $output = & $validator -FrameworkRoot $scenarioDir 2>&1
    $exitCode = $LASTEXITCODE

    $expectation = if ($ExpectPass) { 'PASS' } else { 'FAIL' }
    $actual      = if ($exitCode -eq 0) { 'PASS' } else { 'FAIL' }

    if ($actual -eq $expectation) {
        Write-Host "[OK] $Name (expected $expectation, got $actual)" -ForegroundColor Green
        $script:passed++
    } else {
        Write-Host "[FAIL] $Name (expected $expectation, got $actual)" -ForegroundColor Red
        $output | ForEach-Object { Write-Host "  $_" -ForegroundColor DarkGray }
        $script:failed++
    }
}

# ===========================================================================
# Valid state.yaml scenarios (expect PASS)
# ===========================================================================

$validMinimal = @"
current_task: "001-test-task"
iteration: 0
stage: "PLAN"
status: "new"
started_at: "2026-07-11T00:00:00Z"
"@

$validIteration10 = @"
current_task: "001-test-task"
iteration: 10
stage: "ACT"
status: "retrying"
started_at: "2026-07-11T00:00:00Z"
last_error: "previous attempt failed"
"@

$validHardLimit = @"
current_task: "001-test-task"
iteration: 10
stage: "VERIFY"
status: "failed"
started_at: "2026-07-11T00:00:00Z"
last_error: "hard limit reached after 10 attempts"
last_error_at: "2026-07-11T10:00:00Z"
hard_limit_reached: true
"@

# ===========================================================================
# Invalid state.yaml scenarios (expect FAIL)
# ===========================================================================

$invalidIteration11 = @"
current_task: "001-test-task"
iteration: 11
stage: "ACT"
status: "running"
started_at: "2026-07-11T00:00:00Z"
"@

$invalidStatusEnum = @"
current_task: "001-test-task"
iteration: 1
stage: "ACT"
status: "bogus"
started_at: "2026-07-11T00:00:00Z"
"@

$invalidHardLimitStatus = @"
current_task: "001-test-task"
iteration: 10
stage: "ACT"
status: "running"
started_at: "2026-07-11T00:00:00Z"
hard_limit_reached: true
last_error: "should not be running with hard_limit_reached"
"@

$invalidHardLimitNoError = @"
current_task: "001-test-task"
iteration: 10
stage: "VERIFY"
status: "failed"
started_at: "2026-07-11T00:00:00Z"
hard_limit_reached: true
"@

$invalidExtraProperty = @"
current_task: "001-test-task"
iteration: 1
stage: "ACT"
status: "running"
started_at: "2026-07-11T00:00:00Z"
bogus_field: "should not be here"
"@

$invalidMissingRequired = @"
iteration: 1
stage: "ACT"
status: "running"
started_at: "2026-07-11T00:00:00Z"
"@

# ===========================================================================
# Run scenarios
# ===========================================================================

Write-Host "=== Testing validate-artifacts.ps1 with synthetic state.yaml fixtures ===" -ForegroundColor Cyan
Write-Host ""

# Valid scenarios
Run-StateScenario -Name 'valid-minimal'              -StateYaml $validMinimal              -ExpectPass $true
Run-StateScenario -Name 'valid-iteration-10'         -StateYaml $validIteration10          -ExpectPass $true
Run-StateScenario -Name 'valid-hard-limit'           -StateYaml $validHardLimit            -ExpectPass $true

# Invalid scenarios
Run-StateScenario -Name 'invalid-iteration-11'        -StateYaml $invalidIteration11        -ExpectPass $false
Run-StateScenario -Name 'invalid-status-enum'         -StateYaml $invalidStatusEnum         -ExpectPass $false
Run-StateScenario -Name 'invalid-hard-limit-status'   -StateYaml $invalidHardLimitStatus    -ExpectPass $false
Run-StateScenario -Name 'invalid-hard-limit-no-error' -StateYaml $invalidHardLimitNoError   -ExpectPass $false
Run-StateScenario -Name 'invalid-extra-property'      -StateYaml $invalidExtraProperty      -ExpectPass $false
Run-StateScenario -Name 'invalid-missing-required'    -StateYaml $invalidMissingRequired    -ExpectPass $false

# --- Cleanup ---
Remove-Item -LiteralPath $tempBase -Recurse -Force -ErrorAction SilentlyContinue

# --- Summary ---
Write-Host ""
$color = if ($failed -eq 0) { 'Green' } else { 'Red' }
Write-Host "Summary: $passed passed, $failed failed" -ForegroundColor $color
exit $(if ($failed -gt 0) { 1 } else { 0 })
