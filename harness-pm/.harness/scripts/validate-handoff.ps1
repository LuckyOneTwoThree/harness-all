param(
    [Parameter(Mandatory = $true)][string]$Package,
    [Parameter(Mandatory = $true)][ValidateSet('harness-pm','harness-design','harness-solo')][string]$ExpectedConsumer
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
# pm/design producers may omit it (they don't have this distinction)
if ([string]$manifest.producer -eq 'harness-solo') {
    if ($null -eq $manifest.mode) { Fail "manifest missing mode (required for harness-solo producer)" }
    if (@('family','standalone-fallback') -notcontains [string]$manifest.mode) { Fail "manifest mode must be 'family' or 'standalone-fallback', got: $($manifest.mode)" }
}
if ([string]$manifest.schema_version -ne '1.0') { Fail "unsupported schema_version: $($manifest.schema_version)" }
if ([string]$manifest.status -ne 'ready') { Fail "status must be ready" }
if ([string]$manifest.consumer -ne $ExpectedConsumer) { Fail "consumer mismatch: expected $ExpectedConsumer, got $($manifest.consumer)" }
if ([string]$manifest.producer -notmatch '^harness-(pm|design|solo)$') { Fail "invalid producer: $($manifest.producer) (must be harness-pm|design|solo)" }
if ([string]$manifest.producer -eq [string]$manifest.consumer) { Fail "producer and consumer must differ: both are $($manifest.producer)" }
if ([string]$manifest.handoff_id -notmatch '^[A-Z]+-[A-Z]+-[0-9]{8}-[0-9]{3}$') { Fail "invalid handoff_id" }

function Resolve-PackageFile($Entry, [string]$Label) {
    if ($null -eq $Entry -or [string]::IsNullOrWhiteSpace([string]$Entry.path)) { Fail "$Label missing path"; return $null }
    $relative = ([string]$Entry.path) -replace '\\','/'
    if ([IO.Path]::IsPathRooted($relative) -or $relative.Split('/') -contains '..') { Fail "$Label path escapes package: $relative"; return $null }
    # path pattern: contract must be 'contract.md', artifact must be 'artifacts/...'
    if ($Label -eq 'contract' -and $relative -notmatch '^contract\.md$') { Fail "contract path must be 'contract.md', got: $relative"; return $null }
    if ($Label -eq 'artifact' -and $relative -notmatch '^artifacts/.+$') { Fail "artifact path must start with 'artifacts/', got: $relative"; return $null }
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
            # created_at must be ISO-8601 format (e.g., 2026-07-05T10:30:00Z or with timezone offset)
            $createdAt = $scalar['created_at']
            if ($createdAt -and $createdAt -ne 'null' -and $createdAt -notmatch '^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:?\d{2})$') {
                Fail "created_at must be ISO-8601 format (e.g., 2026-07-05T10:30:00Z), got: $createdAt"
            }
            # manifest/contract scalar consistency: include mode when present in envelope
            $consistencyFields = @('schema_version','handoff_id','producer','consumer','source_revision','status')
            if ($scalar.ContainsKey('mode')) { $consistencyFields += 'mode' }
            foreach ($field in $consistencyFields) {
                if ($scalar.ContainsKey($field) -and [string]$manifest.$field -ne $scalar[$field]) { Fail "manifest/contract mismatch: $field" }
            }

            # Supersedes freshness: if non-null, its date segment must be strictly older than this handoff's date segment
            # (uses -gt to allow same-day incremental iterations, e.g. PM-SOLO-20260704-002 supersedes PM-SOLO-20260704-001)
            $supersedes = $scalar['supersedes']
            # supersedes must match handoff_id pattern (e.g., PM-SOLO-20260705-001) or be 'null'
            if ($supersedes -and $supersedes -ne 'null' -and $supersedes -notmatch '^[A-Z]+-[A-Z]+-[0-9]{8}-[0-9]{3}$') {
                Fail "supersedes must match handoff_id pattern (e.g., PM-SOLO-20260705-001) or be null, got: $supersedes"
            }
            if ($supersedes -and $supersedes -ne 'null' -and $supersedes -match '-(\d{8})-') {
                $superDateStr = $Matches[1]
                $superDate = [datetime]::ParseExact($superDateStr, 'yyyyMMdd', $null)
                if ($manifest.handoff_id -match '-(\d{8})-') {
                    $thisDateStr = $Matches[1]
                    $thisDate = [datetime]::ParseExact($thisDateStr, 'yyyyMMdd', $null)
                    if ($superDate -gt $thisDate) { Fail "supersedes freshness violation: $($supersedes) date ($($superDateStr)) is newer than this handoff ($($manifest.handoff_id) date $($thisDateStr))" }
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

            # Envelope-Batch: parses the nested `batch:` block (id, type, added_acs, modified_acs, superseded_acs, unchanged_acs)
            # Returns a hashtable with 'present' flag and parsed sub-fields.
            function Envelope-Batch {
                $result = @{ present = $false; id = $null; type = $null; added_acs = @(); modified_acs = @(); superseded_acs = @(); unchanged_acs = @() }
                $batchStart = -1
                for ($i=0; $i -lt $front.Count; $i++) {
                    if ($front[$i] -match '^batch:\s*(.*)$') {
                        $result.present = $true
                        $batchStart = $i
                        $inline = $Matches[1].Trim()
                        if ($inline -and $inline -ne 'null') { Fail "batch must be a nested block, got inline value: $inline" }
                        break
                    }
                }
                if (-not $result.present) { return $result }
                # Collect nested lines (deeper indentation) under batch:
                $batchLines = New-Object System.Collections.Generic.List[string]
                for ($j=$batchStart+1; $j -lt $front.Count; $j++) {
                    if ($front[$j] -match '^\S') { break }
                    $batchLines.Add($front[$j])
                }
                # Parse scalar sub-fields (id, type)
                foreach ($line in $batchLines) {
                    if ($line -match '^\s+id:\s*(.*)$') { $result.id = Normalize-Scalar $Matches[1] }
                    elseif ($line -match '^\s+type:\s*(.*)$') { $result.type = Normalize-Scalar $Matches[1] }
                }
                # Parse list sub-fields (added_acs, modified_acs, superseded_acs, unchanged_acs)
                foreach ($field in @('added_acs','modified_acs','superseded_acs','unchanged_acs')) {
                    $values = New-Object System.Collections.Generic.List[string]
                    $start = -1
                    for ($k=0; $k -lt $batchLines.Count; $k++) {
                        if ($batchLines[$k] -match "^\s+$([regex]::Escape($field)):\s*(.*)$") {
                            $start=$k; $inline=$Matches[1].Trim()
                            if ($inline -match '^\[(.*)\]$' -and -not [string]::IsNullOrWhiteSpace($Matches[1])) {
                                foreach($v in $Matches[1].Split(',')) { $values.Add((Normalize-Scalar $v)) }
                            }
                            break
                        }
                    }
                    if ($start -ge 0) {
                        for ($k=$start+1; $k -lt $batchLines.Count; $k++) {
                            if ($batchLines[$k] -match '^\s+[a-z_]+:') { break }
                            if ($batchLines[$k] -match '^\s+-\s*(.+)$') { $values.Add((Normalize-Scalar $Matches[1])) }
                        }
                    }
                    $result[$field] = @($values)
                }
                return $result
            }

            $body = ($lines[($end+1)..($lines.Count-1)] -join "`n")
            $bodyIds = @([regex]::Matches($body, '\b(?:AC-[A-Z0-9]+-[0-9]{3}|DAC-(?:[A-Z0-9]+|GLOBAL)-[0-9]{3})\b') | ForEach-Object Value | Sort-Object -Unique)
            $envelopeIds = @(Envelope-List 'ac_ids' | Sort-Object -Unique)
            if (($bodyIds -join ',') -ne ($envelopeIds -join ',')) { Fail "envelope/body AC-DAC ID mismatch" }

            # batch field validation (required when mode: family)
            $batch = Envelope-Batch
            $isFamily = ($scalar.ContainsKey('mode') -and [string]$scalar['mode'] -eq 'family')
            if ($isFamily) {
                if (-not $batch.present) { Fail "contract envelope missing batch (required when mode: family)" }
                else {
                    if (-not $batch.id) { Fail "batch missing id" }
                    elseif ($batch.id -notmatch '^[1-9][0-9]*$') { Fail "batch.id must be a positive integer, got: $($batch.id)" }
                    if (@('full','incremental') -notcontains $batch.type) { Fail "batch type must be 'full' or 'incremental', got: $($batch.type)" }
                    # ac_ids equality: ac_ids must equal added_acs + modified_acs + unchanged_acs (superseded_acs excluded)
                    $batchActiveIds = @($batch.added_acs + $batch.modified_acs + $batch.unchanged_acs | Sort-Object -Unique)
                    if (($batchActiveIds -join ',') -ne ($envelopeIds -join ',')) {
                        Fail "ac_ids/batch mismatch: ac_ids must equal added_acs + modified_acs + unchanged_acs (superseded_acs excluded)"
                    }
                    # superseded_acs must NOT appear in ac_ids (they are replaced)
                    $supersededInIds = @($batch.superseded_acs | Where-Object { $envelopeIds -contains $_ })
                    if ($supersededInIds.Count -gt 0) { Fail "superseded_acs must not appear in ac_ids: $($supersededInIds -join ', ')" }
                    # batch lists must not overlap (an AC must appear in only one of added/modified/unchanged/superseded)
                    $addedSet = [System.Collections.Generic.HashSet[string]]::new([string[]]@($batch.added_acs))
                    $modifiedSet = [System.Collections.Generic.HashSet[string]]::new([string[]]@($batch.modified_acs))
                    $unchangedSet = [System.Collections.Generic.HashSet[string]]::new([string[]]@($batch.unchanged_acs))
                    $supersededSet = [System.Collections.Generic.HashSet[string]]::new([string[]]@($batch.superseded_acs))
                    foreach ($id in $modifiedSet) { if ($addedSet.Contains($id)) { Fail "AC $id appears in both added_acs and modified_acs" } }
                    foreach ($id in $unchangedSet) {
                        if ($addedSet.Contains($id)) { Fail "AC $id appears in both added_acs and unchanged_acs" }
                        if ($modifiedSet.Contains($id)) { Fail "AC $id appears in both modified_acs and unchanged_acs" }
                    }
                    foreach ($id in $supersededSet) {
                        if ($addedSet.Contains($id)) { Fail "AC $id appears in both added_acs and superseded_acs" }
                        if ($modifiedSet.Contains($id)) { Fail "AC $id appears in both modified_acs and superseded_acs" }
                        if ($unchangedSet.Contains($id)) { Fail "AC $id appears in both unchanged_acs and superseded_acs" }
                    }
                }
            } elseif ($batch.present) {
                Fail "batch field present but mode is not 'family' (batch requires mode: family)"
            }

            # J5: AC/DAC ID strict pattern validation (AC-F01-001 / DAC-P01-001 / DAC-GLOBAL-001)
            # Runs regardless of mode; checks all envelope + batch AC IDs.
            $acIdPattern = '^(AC-[A-Z][0-9]{2}-[0-9]{3}|DAC-(?:[A-Z][0-9]{2}|GLOBAL)-[0-9]{3})$'
            $allAcIdsToCheck = New-Object System.Collections.Generic.List[string]
            foreach ($id in $envelopeIds) { $allAcIdsToCheck.Add($id) }
            if ($batch.present) {
                foreach ($id in $batch.added_acs) { $allAcIdsToCheck.Add($id) }
                foreach ($id in $batch.modified_acs) { $allAcIdsToCheck.Add($id) }
                foreach ($id in $batch.superseded_acs) { $allAcIdsToCheck.Add($id) }
                foreach ($id in $batch.unchanged_acs) { $allAcIdsToCheck.Add($id) }
            }
            foreach ($id in ($allAcIdsToCheck | Sort-Object -Unique)) {
                if ($id -and $id -ne 'null' -and $id -notmatch $acIdPattern) {
                    Fail "invalid AC/DAC ID format (expected AC-F01-001 or DAC-P01-001/DAC-GLOBAL-001): $id"
                }
            }

            $manifestArtifactPaths = @($manifest.artifacts | ForEach-Object { ([string]$_.path) -replace '\\','/' } | Sort-Object -Unique)
            $envelopeArtifacts = @(Envelope-List 'artifacts' | ForEach-Object { $_ -replace '\\','/' } | Sort-Object -Unique)
            if (($manifestArtifactPaths -join ',') -ne ($envelopeArtifacts -join ',')) { Fail "envelope/manifest artifact mismatch" }
        }
    }
}

foreach ($message in $errors) { Write-Host "ERROR: $message" -ForegroundColor Red }
if ($errors.Count) { Write-Host "Handoff validation failed: $($errors.Count) error(s)." -ForegroundColor Red; exit 1 }
Write-Host "Handoff validation passed: $($manifest.handoff_id) -> $ExpectedConsumer" -ForegroundColor Green

