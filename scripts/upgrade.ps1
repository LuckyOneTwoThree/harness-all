param(
    [Parameter(Mandatory = $true)]
    [ValidateSet('harness-pm', 'harness-engineering')]
    [string]$Framework,
    [Parameter(Mandatory = $true)]
    [string]$TargetProject,
    [ValidateSet('Check', 'DryRun', 'Apply')]
    [string]$Mode = 'Check'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$sourceRoot = Join-Path $repoRoot $Framework
$targetRoot = [System.IO.Path]::GetFullPath($TargetProject)

if (-not (Test-Path -LiteralPath $sourceRoot -PathType Container)) { throw "Framework source not found: $sourceRoot" }
if (-not (Test-Path -LiteralPath $targetRoot -PathType Container)) { throw "Target project not found: $targetRoot" }
if (-not (Test-Path -LiteralPath (Join-Path $targetRoot '.harness') -PathType Container)) { throw "Target is not initialized: .harness/ is missing" }

function Get-Sha256([string]$Path) { return (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant() }
function Get-Relative([string]$Base, [string]$Path) { return $Path.Substring($Base.Length).TrimStart('\', '/') -replace '\\', '/' }
function Is-UserOwned([string]$Relative) {
    return $Relative -eq '.harness/FEATURES.md' -or
        $Relative -eq '.harness/harness.lock.json' -or
        $Relative -match '^\.harness/(memory|gates|upgrade-backups)(/|$)' -or
        $Relative -match '^\.harness/loops/specs(/|$)'
}

$managed = New-Object System.Collections.Generic.List[object]
$managed.Add([pscustomobject]@{ Relative = 'AGENTS.md'; Source = (Join-Path $sourceRoot 'AGENTS.md') })
Get-ChildItem (Join-Path $sourceRoot '.harness') -Recurse -Force -File | ForEach-Object {
    $relative = '.harness/' + (Get-Relative (Join-Path $sourceRoot '.harness') $_.FullName)
    if (-not (Is-UserOwned $relative)) { $managed.Add([pscustomobject]@{ Relative = $relative; Source = $_.FullName }) }
}

$lockPath = Join-Path $targetRoot '.harness/harness.lock.json'
$baseline = @{}
if (Test-Path -LiteralPath $lockPath) {
    $lock = [System.IO.File]::ReadAllText($lockPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
    if ($lock.framework -ne $Framework) { throw "Lock belongs to $($lock.framework), not $Framework" }
    if ($lock.files) { foreach ($property in $lock.files.PSObject.Properties) { $baseline[$property.Name] = [string]$property.Value } }
}

$changes = New-Object System.Collections.Generic.List[object]
foreach ($item in $managed) {
    if ($item.Relative -match '(^|/)\.\.(/|$)') { throw "Unsafe managed path: $($item.Relative)" }
    $target = Join-Path $targetRoot ($item.Relative -replace '/', [System.IO.Path]::DirectorySeparatorChar)
    $sourceHash = Get-Sha256 $item.Source
    if (-not (Test-Path -LiteralPath $target)) {
        $action = 'ADD'; $targetHash = $null
    } else {
        $targetHash = Get-Sha256 $target
        if ($targetHash -eq $sourceHash) { $action = 'UNCHANGED' }
        elseif ($baseline.ContainsKey($item.Relative) -and $targetHash -eq $baseline[$item.Relative]) { $action = 'UPDATE' }
        else { $action = 'CONFLICT' }
    }
    $changes.Add([pscustomobject]@{ Action = $action; Relative = $item.Relative; Source = $item.Source; Target = $target; SourceHash = $sourceHash })
}

$visible = @($changes | Where-Object { $_.Action -ne 'UNCHANGED' })
if ($visible.Count -eq 0) { Write-Host "$Framework is up to date at $targetRoot" -ForegroundColor Green }
else { $visible | Select-Object Action, Relative | Format-Table -AutoSize }

$conflicts = @($changes | Where-Object { $_.Action -eq 'CONFLICT' })
if ($Mode -eq 'Check') { if ($visible.Count -gt 0) { exit 1 }; exit 0 }
if ($conflicts.Count -gt 0) {
    Write-Host 'Upgrade blocked: managed files were modified locally or no trusted baseline exists. This tool never overwrites conflicts.' -ForegroundColor Red
    exit 2
}
if ($Mode -eq 'DryRun') { Write-Host 'Dry run complete; no files were changed.' -ForegroundColor Cyan; exit 0 }

$timestamp = Get-Date -Format 'yyyyMMdd-HHmmss'
$backupRoot = Join-Path $targetRoot ".harness/upgrade-backups/$timestamp"
$toWrite = @($changes | Where-Object { $_.Action -eq 'ADD' -or $_.Action -eq 'UPDATE' })
foreach ($item in $toWrite) {
    if ($item.Action -eq 'UPDATE') {
        $backup = Join-Path $backupRoot ($item.Relative -replace '/', [System.IO.Path]::DirectorySeparatorChar)
        $null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $backup)
        Copy-Item -LiteralPath $item.Target -Destination $backup -Force
    }
    $null = New-Item -ItemType Directory -Force -Path (Split-Path -Parent $item.Target)
    Copy-Item -LiteralPath $item.Source -Destination $item.Target -Force
}

$fileHashes = [ordered]@{}
foreach ($item in $managed | Sort-Object Relative) { $fileHashes[$item.Relative] = $item.SourceHash }
$version = ([System.IO.File]::ReadAllText((Join-Path $sourceRoot '.harness/VERSION'))).Trim()
$newLock = [ordered]@{
    framework = $Framework; version = $version; generated_at = (Get-Date).ToUniversalTime().ToString('o'); files = $fileHashes
    user_owned = @('SOUL.md', 'constitution.md', 'docs/**', 'output/**', '.harness/memory/**', '.harness/FEATURES.md', '.harness/loops/specs/**')
}
[System.IO.File]::WriteAllText($lockPath, (($newLock | ConvertTo-Json -Depth 6) + [Environment]::NewLine), [System.Text.UTF8Encoding]::new($false))
Write-Host "Upgrade applied: $($toWrite.Count) file(s); backup root: $backupRoot" -ForegroundColor Green
Write-Host 'User-owned files and conflicting managed files were not overwritten.' -ForegroundColor Green
