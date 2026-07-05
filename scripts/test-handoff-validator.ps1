$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $root 'harness-solo/.harness/scripts/validate-handoff.ps1'
$powerShellHost = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell.exe' }
$tempBase = Join-Path ([IO.Path]::GetTempPath()) ("harness-handoff-test-" + [guid]::NewGuid().ToString('N'))
$null = New-Item -ItemType Directory -Path $tempBase -Force

$scenarios = New-Object System.Collections.Generic.List[hashtable]
$passed = 0
$failed = 0

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { $null = New-Item -ItemType Directory -Path $parent }
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

function Build-HandoffPackage {
    param(
        [string]$ScenarioName,
        [string]$CreatedAt = '2026-06-29T00:00:00Z',
        [string]$Supersedes = 'null',
        [string]$Mode = $null,
        [int]$BatchId = -1,
        [string]$BatchType = $null,
        [string[]]$AddedAcs = @(),
        [string[]]$ModifiedAcs = @(),
        [string[]]$SupersededAcs = @(),
        [string[]]$UnchangedAcs = @(),
        [string[]]$EnvelopeAcIds = @(),
        [string]$BodyContent = $null,
        [switch]$TamperArtifact,
        [string]$Producer = 'harness-pm',
        [string]$Consumer = 'harness-solo',
        [string]$HandoffId = 'PM-SOLO-20260629-001'
    )

    $pkg = Join-Path $script:tempBase $ScenarioName
    $null = New-Item -ItemType Directory -Path $pkg -Force
    $artifactPath = Join-Path $pkg 'artifacts/sample.txt'
    Write-Utf8NoBom $artifactPath "portable artifact`n"

    # Build envelope
    $env = [System.Collections.Generic.List[string]]::new()
    $env.Add('---')
    $env.Add("schema_version: `"1.0`"")
    $env.Add("handoff_id: `"$HandoffId`"")
    $env.Add("producer: `"$Producer`"")
    $env.Add("consumer: `"$Consumer`"")
    $env.Add("created_at: `"$CreatedAt`"")
    $env.Add("source_revision: `"test-revision`"")
    $env.Add("supersedes: $Supersedes")
    $env.Add("status: ready")
    if ($Mode) { $env.Add("mode: $Mode") }
    if ($EnvelopeAcIds.Count -eq 0) {
        $env.Add("ac_ids: []")
    } else {
        $env.Add("ac_ids:")
        foreach ($id in $EnvelopeAcIds) { $env.Add("  - $id") }
    }
    $env.Add("artifacts:")
    $env.Add("  - artifacts/sample.txt")
    if ($Mode -eq 'family') {
        $env.Add("batch:")
        $env.Add("  id: $BatchId")
        $env.Add("  type: $BatchType")
        foreach ($f in @('added_acs','modified_acs','superseded_acs','unchanged_acs')) {
            $vals = switch ($f) { 'added_acs' { $AddedAcs } 'modified_acs' { $ModifiedAcs } 'superseded_acs' { $SupersededAcs } 'unchanged_acs' { $UnchangedAcs } }
            if ($vals.Count -eq 0) {
                $env.Add("  ${f}: []")
            } else {
                $env.Add("  ${f}:")
                foreach ($v in $vals) { $env.Add("    - $v") }
            }
        }
    }
    $env.Add('---')
    $env.Add('')
    $env.Add('# Test Contract')
    $env.Add('')
    if ($BodyContent) {
        $env.Add($BodyContent)
    } elseif ($EnvelopeAcIds.Count -gt 0) {
        $env.Add('Acceptance criteria for: ' + ($EnvelopeAcIds -join ', '))
        foreach ($id in $EnvelopeAcIds) { $env.Add("- ${id}: must pass") }
    } else {
        $env.Add('No acceptance criteria in this fixture.')
    }
    $contractPath = Join-Path $pkg 'contract.md'
    Write-Utf8NoBom $contractPath ($env -join "`n")

    function Entry([string]$Relative, [string]$Full) {
        [ordered]@{
            path = $Relative
            sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $Full).Hash.ToLowerInvariant()
            bytes = (Get-Item -LiteralPath $Full).Length
        }
    }
    $manifest = [ordered]@{
        schema_version = '1.0'
        handoff_id = $HandoffId
        producer = $Producer
        consumer = $Consumer
        status = 'ready'
        source_revision = 'test-revision'
        contract = Entry 'contract.md' $contractPath
        artifacts = @((Entry 'artifacts/sample.txt' $artifactPath))
    }
    if ($Mode) { $manifest.mode = $Mode }
    Write-Utf8NoBom (Join-Path $pkg 'manifest.json') ($manifest | ConvertTo-Json -Depth 6)
    # Tamper AFTER manifest is written so sha256 in manifest no longer matches the artifact
    if ($TamperArtifact) { Write-Utf8NoBom $artifactPath "tampered artifact`n" }
    return $pkg
}

function Run-Scenario {
    param(
        [string]$Name,
        [string]$ExpectedResult,  # 'pass' or 'fail'
        [string]$ExpectedConsumer = 'harness-solo',
        [scriptblock]$Build
    )
    $pkg = & $Build
    $exit = 0
    $output = & $powerShellHost -NoProfile -File $validator -Package $pkg -ExpectedConsumer $ExpectedConsumer 3>&1
    $exit = $LASTEXITCODE
    $ok = if ($ExpectedResult -eq 'pass') { $exit -eq 0 } else { $exit -ne 0 }
    if ($ok) {
        Write-Host "[PASS] $Name (exit=$exit, expected=$ExpectedResult)" -ForegroundColor Green
        $script:passed++
    } else {
        Write-Host "[FAIL] $Name (exit=$exit, expected=$ExpectedResult)" -ForegroundColor Red
        $output | ForEach-Object { Write-Host "       $_" -ForegroundColor Yellow }
        $script:failed++
    }
}

try {
    # 1. Baseline: valid family handoff with proper AC + batch
    Run-Scenario -Name 'baseline valid family handoff' -ExpectedResult 'pass' -Build {
        Build-HandoffPackage -ScenarioName 'baseline-valid' `
            -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('AC-F01-001','AC-F01-002') `
            -EnvelopeAcIds @('AC-F01-001','AC-F01-002')
    }

    # 2. Tampered artifact must be rejected
    Run-Scenario -Name 'tampered artifact rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'tampered' -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('AC-F01-001') -EnvelopeAcIds @('AC-F01-001') -TamperArtifact
    }

    # J1: invalid created_at format must be rejected
    Run-Scenario -Name 'J1: invalid created_at ISO format rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j1-bad-created-at' -CreatedAt '2026-06-29 00:00:00' `
            -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('AC-F01-001') -EnvelopeAcIds @('AC-F01-001')
    }

    # J2: invalid supersedes pattern must be rejected
    Run-Scenario -Name 'J2: invalid supersedes pattern rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j2-bad-supersedes' -Supersedes 'INVALID-ID' `
            -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('AC-F01-001') -EnvelopeAcIds @('AC-F01-001')
    }

    # J3: batch.id = 0 must be rejected (not positive integer)
    Run-Scenario -Name 'J3: batch.id zero rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j3-zero-id' -Mode 'family' -BatchId 0 -BatchType 'full' `
            -AddedAcs @('AC-F01-001') -EnvelopeAcIds @('AC-F01-001')
    }

    # J3b: batch.id negative must be rejected
    Run-Scenario -Name 'J3b: batch.id negative rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j3-neg-id' -Mode 'family' -BatchId -1 -BatchType 'full' `
            -AddedAcs @('AC-F01-001') -EnvelopeAcIds @('AC-F01-001')
    }

    # J4: AC in both added_acs and modified_acs must be rejected (overlap)
    Run-Scenario -Name 'J4: added/modified overlap rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j4-overlap' -Mode 'family' -BatchId 1 -BatchType 'incremental' `
            -AddedAcs @('AC-F01-001') -ModifiedAcs @('AC-F01-001') -UnchangedAcs @('AC-F01-002') `
            -EnvelopeAcIds @('AC-F01-001','AC-F01-002')
    }

    # J4b: AC in both unchanged_acs and superseded_acs must be rejected
    Run-Scenario -Name 'J4b: unchanged/superseded overlap rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j4b-overlap' -Mode 'family' -BatchId 1 -BatchType 'incremental' `
            -AddedAcs @('AC-F01-002') -UnchangedAcs @('AC-F01-001') -SupersededAcs @('AC-F01-001') `
            -EnvelopeAcIds @('AC-F01-001','AC-F01-002')
    }

    # J5: invalid AC ID format in envelope must be rejected (AC-F1-001 missing a digit)
    Run-Scenario -Name 'J5: malformed AC ID rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j5-bad-acid' -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('AC-F1-001') -EnvelopeAcIds @('AC-F1-001')
    }

    # J5b: invalid DAC ID format must be rejected (DAC-P1-001 missing a digit)
    Run-Scenario -Name 'J5b: malformed DAC ID rejected' -ExpectedResult 'fail' -Build {
        Build-HandoffPackage -ScenarioName 'j5b-bad-dacid' -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('DAC-P1-001') -EnvelopeAcIds @('DAC-P1-001')
    }

    # Positive: DAC-GLOBAL-001 and DAC-P01-001 should pass
    Run-Scenario -Name 'J5c: valid DAC GLOBAL + P01 IDs accepted' -ExpectedResult 'pass' -Build {
        Build-HandoffPackage -ScenarioName 'j5c-valid-dac' -Mode 'family' -BatchId 1 -BatchType 'full' `
            -AddedAcs @('DAC-P01-001','DAC-GLOBAL-001') -EnvelopeAcIds @('DAC-P01-001','DAC-GLOBAL-001')
    }

    # Positive: standalone-fallback mode (no batch required)
    Run-Scenario -Name 'standalone-fallback mode accepted without batch' -ExpectedResult 'pass' -ExpectedConsumer 'harness-pm' -Build {
        Build-HandoffPackage -ScenarioName 'standalone' -Producer 'harness-solo' -Consumer 'harness-pm' `
            -HandoffId 'SOLO-PM-20260629-001' -Mode 'standalone-fallback' -EnvelopeAcIds @()
    }

    Write-Host ''
    Write-Host "Results: $passed passed, $failed failed" -ForegroundColor $(if ($failed -eq 0) { 'Green' } else { 'Red' })
    if ($failed -gt 0) { exit 1 }
    Write-Host 'Handoff validator tests passed: all scenarios verified.' -ForegroundColor Green
} finally {
    if (Test-Path -LiteralPath $tempBase) {
        $candidate = [IO.Path]::GetFullPath($tempBase)
        $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\', '/')
        $expectedPrefix = $tempRoot + [IO.Path]::DirectorySeparatorChar + 'harness-handoff-test-'
        if (-not $candidate.StartsWith($expectedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Unsafe test cleanup target: $candidate"
        }
        Remove-Item -LiteralPath $candidate -Recurse -Force
    }
}

exit 0
