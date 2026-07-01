param(
    [Parameter(Mandatory = $true)][string]$Package,
    [Parameter(Mandatory = $true)][ValidateSet('harness-pm','harness-design','harness-solo','harness-growth','harness-ops')][string]$ExpectedConsumer
)

$ErrorActionPreference = 'Stop'
$errors = New-Object System.Collections.Generic.List[string]
function Fail([string]$Message) { $script:errors.Add($Message) }
function Read-Utf8([string]$Path) { [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8) }
function Hash([string]$Path) { (Get-FileHash -Algorithm SHA256 -LiteralPath $Path).Hash.ToLowerInvariant() }
function Normalize-Scalar([string]$Value) { $Value.Trim().Trim('"', "'") }

$packageRoot = [IO.Path]::GetFullPath($Package).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
$manifestPath = Join-Path $packageRoot 'manifest.json'
if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) { throw "manifest.json missing: $manifestPath" }

try { $manifest = Read-Utf8 $manifestPath | ConvertFrom-Json } catch { throw "manifest.json invalid: $($_.Exception.Message)" }
foreach ($field in @('schema_version','handoff_id','producer','consumer','status','source_revision','contract','artifacts')) {
    if ($null -eq $manifest.$field) { Fail "manifest missing $field" }
}
# mode is mandatory only for solo-produced handoffs (solo distinguishes family vs standalone-fallback);
# pm/design/growth/ops producers may omit it (they don't have this distinction)
if ([string]$manifest.producer -eq 'harness-solo') {
    if ($null -eq $manifest.mode) { Fail "manifest missing mode (required for harness-solo producer)" }
    if (@('family','standalone-fallback') -notcontains [string]$manifest.mode) { Fail "manifest mode must be 'family' or 'standalone-fallback', got: $($manifest.mode)" }
}
if ([string]$manifest.schema_version -ne '1.0') { Fail "unsupported schema_version: $($manifest.schema_version)" }
if ([string]$manifest.status -ne 'ready') { Fail "status must be ready" }
if ([string]$manifest.consumer -ne $ExpectedConsumer) { Fail "consumer mismatch: expected $ExpectedConsumer, got $($manifest.consumer)" }
if ([string]$manifest.handoff_id -notmatch '^[A-Z]+-[A-Z]+-[0-9]{8}-[0-9]{3}$') { Fail "invalid handoff_id" }

function Resolve-PackageFile($Entry, [string]$Label) {
    if ($null -eq $Entry -or [string]::IsNullOrWhiteSpace([string]$Entry.path)) { Fail "$Label missing path"; return $null }
    $relative = ([string]$Entry.path) -replace '\\','/'
    if ([IO.Path]::IsPathRooted($relative) -or $relative.Split('/') -contains '..') { Fail "$Label path escapes package: $relative"; return $null }
    $full = [IO.Path]::GetFullPath((Join-Path $packageRoot ($relative -replace '/', [IO.Path]::DirectorySeparatorChar)))
    if (-not ($full -eq $packageRoot -or $full.StartsWith($packageRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase))) {
        Fail "$Label path escapes package: $relative"; return $null
    }
    if (-not (Test-Path -LiteralPath $full -PathType Leaf)) { Fail "$Label missing file: $relative"; return $null }
    if ((Hash $full) -ne ([string]$Entry.sha256).ToLowerInvariant()) { Fail "$Label hash mismatch: $relative" }
    if ((Get-Item -LiteralPath $full).Length -ne [int64]$Entry.bytes) { Fail "$Label byte-size mismatch: $relative" }
    return $full
}

$contractPath = Resolve-PackageFile $manifest.contract 'contract'
$seenPaths = @{}
foreach ($entry in @($manifest.artifacts)) {
    $pathKey = ([string]$entry.path) -replace '\\','/'
    if ($seenPaths.ContainsKey($pathKey)) { Fail "duplicate artifact path: $pathKey" } else { $seenPaths[$pathKey] = $true }
    $null = Resolve-PackageFile $entry "artifact"
}

if ($null -ne $contractPath) {
    $contract = Read-Utf8 $contractPath
    $lines = $contract -split "\r?\n"
    if ($lines.Count -lt 3 -or $lines[0] -ne '---') { Fail 'contract missing YAML envelope' }
    else {
        $end = -1
        for ($i=1; $i -lt $lines.Count; $i++) { if ($lines[$i] -eq '---') { $end=$i; break } }
        if ($end -lt 2) { Fail 'contract envelope is not closed' }
        else {
            $front = $lines[1..($end-1)]
            $scalar = @{}
            for ($i=0; $i -lt $front.Count; $i++) {
                if ($front[$i] -match '^([a-z_]+):\s*(.*)$') { $scalar[$Matches[1]] = Normalize-Scalar $Matches[2] }
            }
            # envelope required fields: mode is required only for solo producer
            $envelopeRequired = @('schema_version','handoff_id','producer','consumer','created_at','source_revision','supersedes','status','ac_ids','artifacts')
            if ([string]$manifest.producer -eq 'harness-solo') { $envelopeRequired += 'mode' }
            foreach ($field in $envelopeRequired) {
                if (-not $scalar.ContainsKey($field)) { Fail "contract envelope missing $field" }
            }
            # manifest/contract scalar consistency: include mode when present in envelope
            $consistencyFields = @('schema_version','handoff_id','producer','consumer','source_revision','status')
            if ($scalar.ContainsKey('mode')) { $consistencyFields += 'mode' }
            foreach ($field in $consistencyFields) {
                if ($scalar.ContainsKey($field) -and [string]$manifest.$field -ne $scalar[$field]) { Fail "manifest/contract mismatch: $field" }
            }

            # Supersedes freshness: if non-null, its date segment must be older than this handoff's date segment
            $supersedes = $scalar['supersedes']
            if ($supersedes -and $supersedes -ne 'null' -and $supersedes -match '-(\d{8})-') {
                $superDate = [datetime]::ParseExact($Matches[1], 'yyyyMMdd', $null)
                if ($manifest.handoff_id -match '-(\d{8})-') {
                    $thisDate = [datetime]::ParseExact($Matches[1], 'yyyyMMdd', $null)
                    if ($superDate -ge $thisDate) { Fail "supersedes freshness violation: $($supersedes) date ($($Matches[1])) is not older than this handoff ($($manifest.handoff_id))" }
                }
            }

            function Envelope-List([string]$Name) {
                $values = New-Object System.Collections.Generic.List[string]
                $start = -1
                for ($j=0; $j -lt $front.Count; $j++) {
                    if ($front[$j] -match "^$([regex]::Escape($Name)):\s*(.*)$") {
                        $start=$j; $inline=$Matches[1].Trim()
                        if ($inline -match '^\[(.*)\]$' -and -not [string]::IsNullOrWhiteSpace($Matches[1])) {
                            foreach($v in $Matches[1].Split(',')) { $values.Add((Normalize-Scalar $v)) }
                        }
                        break
                    }
                }
                if ($start -ge 0) {
                    for ($j=$start+1; $j -lt $front.Count; $j++) {
                        if ($front[$j] -match '^[a-z_]+:') { break }
                        if ($front[$j] -match '^\s*-\s*(.+)$') { $values.Add((Normalize-Scalar $Matches[1])) }
                    }
                }
                return @($values)
            }

            $body = ($lines[($end+1)..($lines.Count-1)] -join "`n")
            $bodyIds = @([regex]::Matches($body, '\b(?:AC-[A-Z0-9]+-[0-9]{3}|DAC-(?:[A-Z0-9]+|GLOBAL)-[0-9]{3})\b') | ForEach-Object Value | Sort-Object -Unique)
            $envelopeIds = @(Envelope-List 'ac_ids' | Sort-Object -Unique)
            if (($bodyIds -join ',') -ne ($envelopeIds -join ',')) { Fail "envelope/body AC-DAC ID mismatch" }

            $manifestArtifactPaths = @($manifest.artifacts | ForEach-Object { ([string]$_.path) -replace '\\','/' } | Sort-Object -Unique)
            $envelopeArtifacts = @(Envelope-List 'artifacts' | ForEach-Object { $_ -replace '\\','/' } | Sort-Object -Unique)
            if (($manifestArtifactPaths -join ',') -ne ($envelopeArtifacts -join ',')) { Fail "envelope/manifest artifact mismatch" }
        }
    }
}

foreach ($message in $errors) { Write-Host "ERROR: $message" -ForegroundColor Red }
if ($errors.Count) { Write-Host "Handoff validation failed: $($errors.Count) error(s)." -ForegroundColor Red; exit 1 }
Write-Host "Handoff validation passed: $($manifest.handoff_id) -> $ExpectedConsumer" -ForegroundColor Green

