<#
.SYNOPSIS
    Validates engineering artifacts against their JSON schemas.

.DESCRIPTION
    Fills the gap where contract.json, component-bindings.json, and state.yaml
    have schemas but no automated validation. Callable from CI and from
    session-start.

    Validates:
      - docs/handoff/contract.json               against .harness/rules/component-contract.schema.json
      - docs/engineering/component-bindings.json against .harness/rules/component-bindings.schema.json
      - loops/specs/*/state.yaml                 against .harness/loops/state.schema.json
      - loops/specs/*/phase-*-report.md          structural check (frontmatter + section titles)

    Schema validation uses Test-Json (PowerShell 7+) when available, otherwise
    falls back to a manual subset of JSON Schema draft 2020-12 (type, required,
    properties, additionalProperties, const, enum, pattern, minLength, minItems,
    uniqueItems, items, minimum, maximum, oneOf). Conditional (allOf/if/then)
    and format keywords are only enforced by Test-Json; the fallback skips them.

    Cross-validation checks (beyond schema):
      - Every component_id in component-bindings.json bindings[] exists in
        contract.json components[].
      - Every token_refs entry in component-bindings.json references a token
        that exists in tokens.json (when tokens.json is present).
      - Every entity ac_refs entry in contract.json entities[] matches
        ^AC-[A-Z][0-9]{2}-[0-9]{3}$.

    Phase report structural check (loops/specs/*/phase-*-report.md):
      - Frontmatter must contain 5 non-empty fields: phase, phase_name,
        task_id, report_path, created_at (placeholder <...> values are treated
        as empty).
      - 8 required section titles must be present: Outcome summary, Acceptance
        IDs produced, Artifacts produced, Evidence citations, Contract
        deviations, Downstream notes, Open risks / pending items, and
        Phase-specific mandatory sub-sections. Content is NOT validated.

    Missing artifact files are reported as [SKIP] (informational, not an error) -
    early-phase runs may not have produced them yet.

.PARAMETER FrameworkRoot
    Path to the harness-engineering root. Defaults to the current directory.

.PARAMETER Strict
    Treat warnings as errors (exit code 1 when any warnings are emitted).

.EXAMPLE
    powershell -NoProfile -File validate-artifacts.ps1 -FrameworkRoot e:\harness-all\harness-engineering

.EXAMPLE
    powershell -NoProfile -File validate-artifacts.ps1 -Strict
#>
param(
    [string]$FrameworkRoot = (Get-Location).Path,
    [switch]$Strict
)

$ErrorActionPreference = 'Stop'
$errors   = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]
$passed   = 0
$failed   = 0
$skipped  = 0

function Fail([string]$Message) { $script:errors.Add($Message) }
function Warn([string]$Message) { $script:warnings.Add($Message) }
function Read-Utf8([string]$Path) { [IO.File]::ReadAllText($Path, [Text.Encoding]::UTF8) }

# --- Path resolution -------------------------------------------------------
$root = [IO.Path]::GetFullPath($FrameworkRoot).TrimEnd([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
if (-not (Test-Path -LiteralPath $root -PathType Container)) { throw "FrameworkRoot not found: $root" }

$contractSchemaPath = Join-Path $root '.harness\rules\component-contract.schema.json'
$bindingsSchemaPath = Join-Path $root '.harness\rules\component-bindings.schema.json'
$stateSchemaPath    = Join-Path $root '.harness\loops\state.schema.json'

$contractArtifactPath = Join-Path $root 'docs\handoff\contract.json'
$bindingsArtifactPath = Join-Path $root 'docs\engineering\component-bindings.json'
$tokensArtifactPath   = Join-Path $root 'docs\design-system\tokens.json'
$stateSpecsDir        = Join-Path $root 'loops\specs'

# --- Capability detection --------------------------------------------------
$useTestJson = $false
$testJsonCmd = Get-Command Test-Json -ErrorAction SilentlyContinue
if ($testJsonCmd) {
    try { if ($testJsonCmd.Parameters.Keys -contains 'Schema') { $useTestJson = $true } } catch { $useTestJson = $false }
}

$yamlMode = $null
if (Get-Module -ListAvailable powershell-yaml -ErrorAction SilentlyContinue) { $yamlMode = 'module' }
elseif (Get-Command yq -ErrorAction SilentlyContinue) { $yamlMode = 'yq' }

# --- Helpers ---------------------------------------------------------------
function ConvertTo-Hashtable([object]$Obj) {
    if ($null -eq $Obj) { return $null }
    if ($Obj -is [pscustomobject]) {
        $h = @{}
        foreach ($p in $Obj.PSObject.Properties) { $h[$p.Name] = ConvertTo-Hashtable $p.Value }
        return $h
    }
    if ($Obj -is [array]) {
        $arr = New-Object System.Collections.ArrayList
        foreach ($i in $Obj) { $null = $arr.Add((ConvertTo-Hashtable $i)) }
        return ,$arr.ToArray()
    }
    return $Obj
}

function Test-JsonProperty([object]$Instance, [string]$Name) {
    if ($null -eq $Instance) { return $false }
    if ($Instance -is [pscustomobject]) { return $Instance.PSObject.Properties.Name -contains $Name }
    return $false
}

# Manual JSON schema validator (subset of draft 2020-12).
# Returns a List[string] of error messages (empty if valid).
function Test-JsonSchema([object]$Instance, [hashtable]$Schema, [string]$Path) {
    $errs = New-Object System.Collections.Generic.List[string]
    if ($null -eq $Schema) { return $errs }

    if ($Schema.ContainsKey('type') -and $null -ne $Instance) {
        $expected = @($Schema.type)
        $matched = $false
        foreach ($t in $expected) {
            switch ($t) {
                'object'  { if ($Instance -is [pscustomobject]) { $matched = $true } }
                'array'   { if ($Instance -is [array]) { $matched = $true } }
                'string'  { if ($Instance -is [string]) { $matched = $true } }
                'integer' { if ($Instance -is [int] -or $Instance -is [long]) { $matched = $true } }
                'number'  { if ($Instance -is [int] -or $Instance -is [long] -or $Instance -is [double] -or $Instance -is [decimal]) { $matched = $true } }
                'boolean' { if ($Instance -is [bool]) { $matched = $true } }
                'null'    { if ($null -eq $Instance) { $matched = $true } }
            }
        }
        if (-not $matched) { $null = $errs.Add("${Path}: type mismatch, expected [$($expected -join ',')]") }
    }

    if ($Schema.ContainsKey('const')) {
        if ([string]($Instance) -ne [string]($Schema.const)) { $null = $errs.Add("${Path}: const mismatch, expected '$($Schema.const)', got '$Instance'") }
    }

    if ($Schema.ContainsKey('enum') -and $null -ne $Instance) {
        $matched = $false
        foreach ($v in $Schema.enum) { if ([string]($v) -eq [string]($Instance)) { $matched = $true; break } }
        if (-not $matched) { $null = $errs.Add("${Path}: enum mismatch, value '$Instance' not in [$($Schema.enum -join ',')]") }
    }

    if ($Schema.ContainsKey('pattern') -and $Instance -is [string]) {
        if ($Instance -notmatch $Schema.pattern) { $null = $errs.Add("${Path}: pattern mismatch, '$Instance' does not match /$($Schema.pattern)/") }
    }

    if ($Schema.ContainsKey('minLength') -and $Instance -is [string]) {
        if ($Instance.Length -lt [int]$Schema.minLength) { $null = $errs.Add("${Path}: minLength $($Schema.minLength) violated (length=$($Instance.Length))") }
    }

    if ($Schema.ContainsKey('minimum') -and $null -ne $Instance -and ($Instance -is [int] -or $Instance -is [long] -or $Instance -is [double] -or $Instance -is [decimal])) {
        if ([double]$Instance -lt [double]$Schema.minimum) { $null = $errs.Add("${Path}: minimum $($Schema.minimum) violated (value=$Instance)") }
    }

    if ($Schema.ContainsKey('maximum') -and $null -ne $Instance -and ($Instance -is [int] -or $Instance -is [long] -or $Instance -is [double] -or $Instance -is [decimal])) {
        if ([double]$Instance -gt [double]$Schema.maximum) { $null = $errs.Add("${Path}: maximum $($Schema.maximum) violated (value=$Instance)") }
    }

    if ($Schema.ContainsKey('oneOf')) {
        $matchCount = 0
        foreach ($subSchema in $Schema.oneOf) {
            $subErrs = Test-JsonSchema $Instance $subSchema $Path
            if ($subErrs.Count -eq 0) { $matchCount++ }
        }
        if ($matchCount -ne 1) { $null = $errs.Add("${Path}: oneOf matched $matchCount schemas, expected exactly 1") }
    }

    if ($Instance -is [pscustomobject]) {
        if ($Schema.ContainsKey('required')) {
            foreach ($r in $Schema.required) {
                if (-not (Test-JsonProperty $Instance $r)) { $null = $errs.Add("${Path}: missing required property '$r'") }
            }
        }

        $propNames = @()
        if ($Schema.ContainsKey('properties') -and $Schema.properties -is [hashtable]) {
            $propNames = @($Schema.properties.Keys)
            foreach ($pn in $propNames) {
                if (Test-JsonProperty $Instance $pn) {
                    $sub = Test-JsonSchema $Instance.$pn $Schema.properties[$pn] "$Path.$pn"
                    foreach ($e in $sub) { $null = $errs.Add($e) }
                }
            }
        }

        if ($Schema.ContainsKey('additionalProperties')) {
            if ($Schema.additionalProperties -eq $false) {
                foreach ($ipn in $Instance.PSObject.Properties.Name) {
                    if ($propNames -notcontains $ipn) { $null = $errs.Add("${Path}: additional property '$ipn' not allowed") }
                }
            }
            elseif ($Schema.additionalProperties -is [hashtable]) {
                foreach ($ipn in $Instance.PSObject.Properties.Name) {
                    if ($propNames -notcontains $ipn) {
                        $sub = Test-JsonSchema $Instance.$ipn $Schema.additionalProperties "$Path.$ipn"
                        foreach ($e in $sub) { $null = $errs.Add($e) }
                    }
                }
            }
        }
    }

    if ($Instance -is [array]) {
        if ($Schema.ContainsKey('minItems')) {
            if ($Instance.Count -lt [int]$Schema.minItems) { $null = $errs.Add("${Path}: minItems $($Schema.minItems) violated (count=$($Instance.Count))") }
        }

        if ($Schema.ContainsKey('uniqueItems') -and $Schema.uniqueItems -eq $true) {
            $seen = New-Object System.Collections.Generic.HashSet[string]
            foreach ($item in $Instance) {
                $key = if ($item -is [string]) { "s:$item" } elseif ($item -is [int] -or $item -is [long] -or $item -is [double] -or $item -is [bool]) { "v:$item" } else { ($item | ConvertTo-Json -Compress -Depth 10) }
                if (-not $seen.Add($key)) { $null = $errs.Add("${Path}: uniqueItems violated (duplicate: $key)") }
            }
        }

        if ($Schema.ContainsKey('items')) {
            for ($i = 0; $i -lt $Instance.Count; $i++) {
                $sub = Test-JsonSchema $Instance[$i] $Schema.items "$Path[$i]"
                foreach ($e in $sub) { $null = $errs.Add($e) }
            }
        }
    }

    return $errs
}

# Returns a hashtable: @{ Valid = $true/$false; Errors = @(...) }
function Test-JsonAgainstSchema([string]$JsonText, [string]$SchemaText) {
    $result = @{ Valid = $true; Errors = @() }
    if ($useTestJson) {
        $errVar = @()
        try {
            $valid = Test-Json -Json $JsonText -Schema $SchemaText -ErrorVariable errVar -ErrorAction SilentlyContinue
            if ($valid) { return $result }
            $msgs = @()
            foreach ($e in $errVar) {
                if ($e.Exception) { $msgs += $e.Exception.Message } else { $msgs += [string]$e }
            }
            if ($msgs.Count -eq 0) { $msgs += 'schema validation failed' }
            $result.Valid = $false
            $result.Errors = $msgs
            return $result
        } catch {
            $result.Valid = $false
            $result.Errors = @("Test-Json threw: $($_.Exception.Message)")
            return $result
        }
    }
    try {
        $instance = $JsonText | ConvertFrom-Json
        $schemaObj = $SchemaText | ConvertFrom-Json
        $schemaHt = ConvertTo-Hashtable $schemaObj
        $errsList = Test-JsonSchema $instance $schemaHt '$'
        if ($errsList.Count -eq 0) { return $result }
        $result.Valid = $false
        $result.Errors = @($errsList)
        return $result
    } catch {
        $result.Valid = $false
        $result.Errors = @("parse error: $($_.Exception.Message)")
        return $result
    }
}

function Convert-YamlFileToJson([string]$Path) {
    if ($yamlMode -eq 'module') {
        if (-not (Get-Module powershell-yaml)) { Import-Module powershell-yaml -ErrorAction Stop }
        $obj = Read-Utf8 $Path | ConvertFrom-Yaml
        return ($obj | ConvertTo-Json -Depth 20 -Compress)
    }
    if ($yamlMode -eq 'yq') {
        return (& yq -o=json "$Path")
    }
    return $null
}

# Walks a W3C-style tokens.json object and returns dotted leaf paths
# (e.g., "color.primary", "spacing.sm"). A leaf is an object containing $value
# or any non-object scalar.
function Get-TokenLeafPaths([object]$Node, [string]$Prefix) {
    $paths = @()
    if ($null -eq $Node) { return $paths }
    if ($Node -is [pscustomobject]) {
        if ($Node.PSObject.Properties.Name -contains '$value') {
            if ($Prefix) { $paths += $Prefix }
            return $paths
        }
        foreach ($p in $Node.PSObject.Properties) {
            $next = if ($Prefix) { "$Prefix.$($p.Name)" } else { $p.Name }
            $paths += Get-TokenLeafPaths $p.Value $next
        }
    }
    elseif ($Node -is [array]) {
        for ($i = 0; $i -lt $Node.Count; $i++) {
            $next = if ($Prefix) { "$Prefix.$i" } else { "$i" }
            $paths += Get-TokenLeafPaths $Node[$i] $next
        }
    }
    else {
        if ($Prefix) { $paths += $Prefix }
    }
    return $paths
}

# --- Validation: contract.json ---------------------------------------------
$contractObj = $null
if (Test-Path -LiteralPath $contractArtifactPath -PathType Leaf) {
    if (-not (Test-Path -LiteralPath $contractSchemaPath -PathType Leaf)) {
        Warn "schema missing: $contractSchemaPath"
        Write-Host "[SKIP] $contractArtifactPath (schema missing: $contractSchemaPath)" -ForegroundColor Yellow
        $skipped++
    } else {
        $jsonText = Read-Utf8 $contractArtifactPath
        $schemaText = Read-Utf8 $contractSchemaPath
        $result = Test-JsonAgainstSchema $jsonText $schemaText
        if ($result.Valid) {
            Write-Host "[PASS] $contractArtifactPath against $contractSchemaPath" -ForegroundColor Green
            $passed++
            try { $contractObj = $jsonText | ConvertFrom-Json } catch { Warn "contract.json re-parse failed: $($_.Exception.Message)" }
        } else {
            Write-Host "[FAIL] $contractArtifactPath against $contractSchemaPath" -ForegroundColor Red
            foreach ($e in $result.Errors) { Write-Host "  - $e" -ForegroundColor Red; Fail "contract.json: $e" }
            $failed++
        }
    }
} else {
    Write-Host "[SKIP] $contractArtifactPath (file does not exist; schema: $contractSchemaPath)" -ForegroundColor DarkGray
    $skipped++
}

# --- Validation: component-bindings.json -----------------------------------
$bindingsObj = $null
if (Test-Path -LiteralPath $bindingsArtifactPath -PathType Leaf) {
    if (-not (Test-Path -LiteralPath $bindingsSchemaPath -PathType Leaf)) {
        Warn "schema missing: $bindingsSchemaPath"
        Write-Host "[SKIP] $bindingsArtifactPath (schema missing: $bindingsSchemaPath)" -ForegroundColor Yellow
        $skipped++
    } else {
        $jsonText = Read-Utf8 $bindingsArtifactPath
        $schemaText = Read-Utf8 $bindingsSchemaPath
        $result = Test-JsonAgainstSchema $jsonText $schemaText
        if ($result.Valid) {
            Write-Host "[PASS] $bindingsArtifactPath against $bindingsSchemaPath" -ForegroundColor Green
            $passed++
            try { $bindingsObj = $jsonText | ConvertFrom-Json } catch { Warn "bindings.json re-parse failed: $($_.Exception.Message)" }
        } else {
            Write-Host "[FAIL] $bindingsArtifactPath against $bindingsSchemaPath" -ForegroundColor Red
            foreach ($e in $result.Errors) { Write-Host "  - $e" -ForegroundColor Red; Fail "component-bindings.json: $e" }
            $failed++
        }
    }
} else {
    Write-Host "[SKIP] $bindingsArtifactPath (file does not exist; schema: $bindingsSchemaPath)" -ForegroundColor DarkGray
    $skipped++
}

# --- Validation: state.yaml (one or more under loops/specs/) ---------------
if (Test-Path -LiteralPath $stateSpecsDir -PathType Container) {
    $stateFiles = @(Get-ChildItem -LiteralPath $stateSpecsDir -Recurse -Filter 'state.yaml' -File -ErrorAction SilentlyContinue)
    if ($stateFiles.Count -eq 0) {
        Write-Host "[SKIP] no state.yaml files under $stateSpecsDir (schema: $stateSchemaPath)" -ForegroundColor DarkGray
        $skipped++
    } elseif (-not (Test-Path -LiteralPath $stateSchemaPath -PathType Leaf)) {
        Warn "schema missing: $stateSchemaPath"
        foreach ($f in $stateFiles) {
            Write-Host "[SKIP] $($f.FullName) (schema missing: $stateSchemaPath)" -ForegroundColor Yellow
            $skipped++
        }
    } elseif (-not $yamlMode) {
        Warn "no YAML parser available (install powershell-yaml or yq); state.yaml files skipped"
        foreach ($f in $stateFiles) {
            Write-Host "[SKIP] $($f.FullName) (no YAML parser available; schema: $stateSchemaPath)" -ForegroundColor Yellow
            $skipped++
        }
    } else {
        $schemaText = Read-Utf8 $stateSchemaPath
        foreach ($f in $stateFiles) {
            $yamlPath = $f.FullName
            try {
                $jsonText = Convert-YamlFileToJson $yamlPath
                if (-not $jsonText) {
                    Write-Host "[FAIL] $yamlPath against $stateSchemaPath" -ForegroundColor Red
                    Write-Host "  - YAML parser returned empty output" -ForegroundColor Red
                    Fail "state.yaml ($yamlPath): YAML parser returned empty output"
                    $failed++
                } else {
                    $result = Test-JsonAgainstSchema $jsonText $schemaText
                    if ($result.Valid) {
                        Write-Host "[PASS] $yamlPath against $stateSchemaPath" -ForegroundColor Green
                        $passed++
                    } else {
                        Write-Host "[FAIL] $yamlPath against $stateSchemaPath" -ForegroundColor Red
                        foreach ($e in $result.Errors) { Write-Host "  - $e" -ForegroundColor Red; Fail "state.yaml ($yamlPath): $e" }
                        $failed++
                    }
                }
            } catch {
                Write-Host "[FAIL] $yamlPath against $stateSchemaPath" -ForegroundColor Red
                Write-Host "  - YAML parse error: $($_.Exception.Message)" -ForegroundColor Red
                Fail "state.yaml ($yamlPath): $($_.Exception.Message)"
                $failed++
            }
        }
    }
} else {
    Write-Host "[SKIP] $stateSpecsDir (no loops/specs/ directory; schema: $stateSchemaPath)" -ForegroundColor DarkGray
    $skipped++
}

# --- Cross-validation: bindings[].component_id exists in contract.components[]
$cvLabel = 'cross-validation: bindings[].component_id exists in contract.json components[]'
if ($null -eq $bindingsObj -or $null -eq $contractObj) {
    Write-Host "[SKIP] $cvLabel (one or both artifacts missing or invalid)" -ForegroundColor DarkGray
    $skipped++
} else {
    $contractIds = @()
    if (Test-JsonProperty $contractObj 'components') {
        $contractIds = @($contractObj.components | ForEach-Object { [string]$_.component_id })
    }
    $cvErrors = @()
    if (Test-JsonProperty $bindingsObj 'bindings') {
        foreach ($b in @($bindingsObj.bindings)) {
            $bid = [string]$b.component_id
            if ($contractIds -notcontains $bid) {
                $cvErrors += "bindings[].component_id '$bid' not found in contract.json components[]"
            }
        }
    }
    if ($cvErrors.Count -eq 0) {
        Write-Host "[PASS] $cvLabel" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] $cvLabel" -ForegroundColor Red
        foreach ($e in $cvErrors) { Write-Host "  - $e" -ForegroundColor Red; Fail "${cvLabel}: $e" }
        $failed++
    }
}

# --- Cross-validation: bindings[].token_refs exist in tokens.json ----------
$cvLabel = 'cross-validation: bindings[].token_refs values exist in tokens.json'
if ($null -eq $bindingsObj) {
    Write-Host "[SKIP] $cvLabel (bindings.json missing or invalid)" -ForegroundColor DarkGray
    $skipped++
} elseif (-not (Test-Path -LiteralPath $tokensArtifactPath -PathType Leaf)) {
    Write-Host "[SKIP] $cvLabel (tokens.json does not exist)" -ForegroundColor DarkGray
    $skipped++
} else {
    $cvErrors = @()
    try {
        $tokensObj = Read-Utf8 $tokensArtifactPath | ConvertFrom-Json
        $tokenNames = Get-TokenLeafPaths $tokensObj ''
        $tokenSet = New-Object System.Collections.Generic.HashSet[string]
        foreach ($n in $tokenNames) { $null = $tokenSet.Add($n) }
        if (Test-JsonProperty $bindingsObj 'bindings') {
            foreach ($b in @($bindingsObj.bindings)) {
                if (Test-JsonProperty $b 'token_refs') {
                    foreach ($t in @($b.token_refs)) {
                        if (-not $tokenSet.Contains([string]$t)) {
                            $cvErrors += "token_refs '$t' (component $([string]$b.component_id)) not found in tokens.json"
                        }
                    }
                }
            }
        }
    } catch {
        Warn "tokens.json present but unreadable: $($_.Exception.Message)"
    }
    if ($cvErrors.Count -eq 0) {
        Write-Host "[PASS] $cvLabel" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] $cvLabel" -ForegroundColor Red
        foreach ($e in $cvErrors) { Write-Host "  - $e" -ForegroundColor Red; Fail "${cvLabel}: $e" }
        $failed++
    }
}

# --- Cross-validation: contract.json entities[].ac_refs match pattern ------
$cvLabel = 'cross-validation: contract.json entities[].ac_refs match ^AC-[A-Z][0-9]{2}-[0-9]{3}$'
if ($null -eq $contractObj) {
    Write-Host "[SKIP] $cvLabel (contract.json missing or invalid)" -ForegroundColor DarkGray
    $skipped++
} else {
    $acPattern = '^AC-[A-Z][0-9]{2}-[0-9]{3}$'
    $cvErrors = @()
    if (Test-JsonProperty $contractObj 'entities') {
        foreach ($ent in @($contractObj.entities)) {
            if (Test-JsonProperty $ent 'ac_refs') {
                foreach ($ac in @($ent.ac_refs)) {
                    if ([string]$ac -notmatch $acPattern) {
                        $cvErrors += "entity $([string]$ent.entity_id) ac_refs '$ac' does not match $acPattern"
                    }
                }
            }
        }
    }
    if ($cvErrors.Count -eq 0) {
        Write-Host "[PASS] $cvLabel" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] $cvLabel" -ForegroundColor Red
        foreach ($e in $cvErrors) { Write-Host "  - $e" -ForegroundColor Red; Fail "${cvLabel}: $e" }
        $failed++
    }
}

# --- Validation: phase reports (frontmatter + section titles) --------------
# Lightweight structural check: confirms frontmatter 5 fields exist and are
# non-empty (not placeholders), and that 8 required section titles are present.
# Does NOT validate section content — only structural completeness, so authors
# cannot accidentally omit a mandatory section.
$phaseReports = @()
if (Test-Path -LiteralPath $stateSpecsDir -PathType Container) {
    $phaseReports = @(Get-ChildItem -LiteralPath $stateSpecsDir -Recurse -File -Filter 'phase-*-report.md' -ErrorAction SilentlyContinue)
}

if ($phaseReports.Count -eq 0) {
    Write-Host "[SKIP] phase reports: frontmatter + section titles (no phase-*-report.md files found)" -ForegroundColor DarkGray
    $skipped++
} else {
    $requiredFrontmatter = @('phase', 'phase_name', 'task_id', 'report_path', 'created_at')
    $requiredSections = @(
        '## Outcome summary',
        '## Acceptance IDs produced',
        '## Artifacts produced',
        '## Evidence citations',
        '## Contract deviations',
        '## Downstream notes',
        '## Open risks / pending items',
        '## Phase-specific mandatory sub-sections'
    )
    foreach ($report in $phaseReports) {
        $reportErrors = @()
        $reportRel = $report.FullName.Substring($root.Length).TrimStart([IO.Path]::DirectorySeparatorChar, [IO.Path]::AltDirectorySeparatorChar)
        $content = Read-Utf8 $report.FullName
        $lines = $content -split "`r?`n"

        # Extract frontmatter between first two --- delimiters
        $fmStart = -1
        $fmEnd = -1
        for ($i = 0; $i -lt $lines.Count; $i++) {
            if ($lines[$i] -match '^\s*---\s*$') {
                if ($fmStart -eq -1) { $fmStart = $i }
                elseif ($fmEnd -eq -1) { $fmEnd = $i; break }
            }
        }

        if ($fmStart -eq -1 -or $fmEnd -eq -1 -or $fmEnd -le $fmStart + 1) {
            $reportErrors += "frontmatter block not found (missing --- delimiters)"
        } else {
            $fmFields = @{}
            for ($i = $fmStart + 1; $i -lt $fmEnd; $i++) {
                $fl = $lines[$i]
                if ($fl -match '^\s*([a-zA-Z_][a-zA-Z0-9_]*)\s*:\s*(.+)$') {
                    $key = $matches[1]
                    $rawVal = $matches[2]
                    # Strip inline YAML comment (space-hash to end), outside quotes
                    if ($rawVal -notmatch '^["'']') { $rawVal = ($rawVal -split '\s+#')[0] }
                    $val = $rawVal.Trim()
                    # Strip surrounding quotes
                    if ($val -match '^"(.*)"$') { $val = $matches[1] }
                    elseif ($val -match "^'(.*)'$") { $val = $matches[1] }
                    # Treat placeholder <...> as empty (unfilled template)
                    if ($val -match '^<[^>]*>$') { $val = '' }
                    $fmFields[$key] = $val
                }
            }
            foreach ($req in $requiredFrontmatter) {
                if (-not $fmFields.ContainsKey($req)) {
                    $reportErrors += "frontmatter missing required field '$req'"
                } elseif ([string]::IsNullOrWhiteSpace($fmFields[$req])) {
                    $reportErrors += "frontmatter field '$req' is empty or unfilled placeholder"
                }
            }
        }

        # Check required section titles (exact line match, allowing trailing whitespace)
        foreach ($sec in $requiredSections) {
            $pattern = '^\s*' + [regex]::Escape($sec) + '\s*$'
            $found = $false
            foreach ($ln in $lines) {
                if ($ln -match $pattern) { $found = $true; break }
            }
            if (-not $found) { $reportErrors += "missing required section title '$sec'" }
        }

        if ($reportErrors.Count -eq 0) {
            Write-Host "[PASS] phase report: $reportRel" -ForegroundColor Green
            $passed++
        } else {
            Write-Host "[FAIL] phase report: $reportRel" -ForegroundColor Red
            foreach ($e in $reportErrors) { Write-Host "  - $e" -ForegroundColor Red; Fail "phase report $reportRel : $e" }
            $failed++
        }
    }
}

# --- Warnings --------------------------------------------------------------
foreach ($w in $warnings) { Write-Host "[WARN] $w" -ForegroundColor Yellow }

# --- Summary ---------------------------------------------------------------
$exitCode = 0
if ($failed -gt 0) { $exitCode = 1 }
if ($Strict -and $warnings.Count -gt 0) { $exitCode = 1 }

Write-Host ''
$summaryColor = if ($exitCode -eq 0) { 'Green' } else { 'Red' }
Write-Host ("Summary: {0} passed, {1} failed, {2} skipped ({3} warnings)" -f $passed, $failed, $skipped, $warnings.Count) -ForegroundColor $summaryColor

exit $exitCode
