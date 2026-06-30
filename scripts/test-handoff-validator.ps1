$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$validator = Join-Path $root 'harness-solo/.harness/scripts/validate-handoff.ps1'
$temp = Join-Path ([IO.Path]::GetTempPath()) ("harness-handoff-test-" + [guid]::NewGuid().ToString('N'))
$powerShellHost = if (Get-Command pwsh -ErrorAction SilentlyContinue) { 'pwsh' } else { 'powershell.exe' }

function Write-Utf8NoBom([string]$Path, [string]$Content) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent)) { $null = New-Item -ItemType Directory -Path $parent }
    [IO.File]::WriteAllText($Path, $Content, [Text.UTF8Encoding]::new($false))
}

try {
    $artifactPath = Join-Path $temp 'artifacts/sample.txt'
    Write-Utf8NoBom $artifactPath "portable artifact`n"
    $contract = @'
---
schema_version: "1.0"
handoff_id: "PM-SOLO-20260629-001"
producer: "harness-pm"
consumer: "harness-solo"
created_at: "2026-06-29T00:00:00Z"
source_revision: "test-revision"
supersedes: null
status: ready
ac_ids: []
artifacts:
  - artifacts/sample.txt
---
# Test Contract

No acceptance criteria in this fixture.
'@
    $contractPath = Join-Path $temp 'contract.md'
    Write-Utf8NoBom $contractPath $contract

    function Entry([string]$Relative, [string]$Full) {
        [ordered]@{
            path = $Relative
            sha256 = (Get-FileHash -Algorithm SHA256 -LiteralPath $Full).Hash.ToLowerInvariant()
            bytes = (Get-Item -LiteralPath $Full).Length
        }
    }
    $manifest = [ordered]@{
        schema_version = '1.0'
        handoff_id = 'PM-SOLO-20260629-001'
        producer = 'harness-pm'
        consumer = 'harness-solo'
        status = 'ready'
        source_revision = 'test-revision'
        contract = Entry 'contract.md' $contractPath
        artifacts = @((Entry 'artifacts/sample.txt' $artifactPath))
    }
    Write-Utf8NoBom (Join-Path $temp 'manifest.json') ($manifest | ConvertTo-Json -Depth 6)

    & $powerShellHost -NoProfile -File $validator -Package $temp -ExpectedConsumer harness-solo
    if ($LASTEXITCODE -ne 0) { throw 'valid handoff package was rejected' }

    Write-Utf8NoBom $artifactPath "tampered artifact`n"
    & $powerShellHost -NoProfile -File $validator -Package $temp -ExpectedConsumer harness-solo *> $null
    if ($LASTEXITCODE -eq 0) { throw 'tampered handoff package was accepted' }

    Write-Host 'Handoff validator tests passed: valid accepted, tampered rejected.' -ForegroundColor Green
} finally {
    if (Test-Path -LiteralPath $temp) {
        $candidate = [IO.Path]::GetFullPath($temp)
        $tempRoot = [IO.Path]::GetFullPath([IO.Path]::GetTempPath()).TrimEnd('\', '/')
        $expectedPrefix = $tempRoot + [IO.Path]::DirectorySeparatorChar + 'harness-handoff-test-'
        if (-not $candidate.StartsWith($expectedPrefix, [StringComparison]::OrdinalIgnoreCase)) {
            throw "Unsafe test cleanup target: $candidate"
        }
        Remove-Item -LiteralPath $candidate -Recurse -Force
    }
}

exit 0
