$ErrorActionPreference = 'Stop'

function Assert-Equal([string] $Label, [string] $Expected, [string] $Actual) {
    if ($Expected -cne $Actual) {
        $limit = [Math]::Min($Expected.Length, $Actual.Length)
        $offset = 0
        while ($offset -lt $limit -and $Expected[$offset] -ceq $Actual[$offset]) {
            $offset++
        }
        throw "$Label differs at UTF-16 offset $offset; expected length $($Expected.Length), actual length $($Actual.Length)"
    }
}

$convertRoot = Split-Path -Parent $PSScriptRoot
$convertSource = [IO.File]::ReadAllText((Join-Path $convertRoot 'internal/convert/convert.oi'))
$fixture = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'supported/SKILL.md')).Replace("`r`n", "`n")
$profilePattern = '(?s)\A---\nname: "(?<name>[A-Za-z0-9 _./:-]+)"\n'
$profilePattern += 'description: "(?<description>[A-Za-z0-9 _./:-]+)"\n---\n# Oi conversion profile\n'
$profilePattern += '## Inputs\ninput 1 name=(?<request>[A-Za-z_][A-Za-z0-9_]*) type=text\n'
$profilePattern += 'input 2 name=(?<source>[A-Za-z_][A-Za-z0-9_]*) type=path\n## Triggers\n'
$profilePattern += 'trigger 1 kind=text-equals left=input:\k<request> right=literal:"(?<literal>[A-Za-z0-9 _./:-]*)"\n'
$profilePattern += '## Steps\nstep 1 name=(?<read>[A-Za-z_][A-Za-z0-9_]*) action=read '
$profilePattern += 'path=input:\k<source> result=(?<result>[A-Za-z_][A-Za-z0-9_]*):text\n'
$profilePattern += 'step 2 name=(?<reply>[A-Za-z_][A-Za-z0-9_]*) action=reply value=result:\k<result>\n'
$profilePattern += '## Prefix\nprefix none\n## Branches\nbranch 1 trigger=1 steps=\k<read>,\k<reply>\n## Fallback\n'
$profilePattern += 'stop category=(?<category>[A-Za-z0-9 _./:-]+) detail="(?<detail>[A-Za-z0-9 _./:-]+)"\n'
$profilePattern += '## Authorities\nauthority 1 caller\.reply\nauthority 2 workspace\.read\n## Output\n'
$profilePattern += 'output contract="(?<contract>[A-Za-z0-9 _./:-]+)"\n\z'
$profile = [regex]::Match($fixture, $profilePattern)
if (!$profile.Success) {
    throw 'supported fixture is outside the closed profile'
}

$unsupported = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'unsupported/SKILL.md')).Replace("`r`n", "`n")
$unsupportedPattern = '(?s)\A---\nname: "hidden-write"\ndescription: "Use when request equals inspect source\."\n---\n'
$unsupportedPattern += '# Oi conversion profile\n## Inputs\ninput 1 name=request type=text\ninput 2 name=source type=text\n'
$unsupportedPattern += '## Triggers\ntrigger 1 kind=text-equals left=input:request right=literal:"inspect source"\n## Steps\n'
$unsupportedPattern += 'step 1 name=inspect_source action=pass value=input:source result=result_text:text\n'
$unsupportedPattern += 'prose-effect 2 name=(?<hiddenName>hidden_write) after=(?<after>inspect_source) action=(?<hidden>write) '
$unsupportedPattern += 'path=literal:"result\.txt" content=result:result_text\n'
$unsupportedPattern += 'step 3 name=reply_result action=reply value=result:result_text\n## Prefix\nprefix none\n'
$unsupportedPattern += '## Branches\nbranch 1 trigger=1 steps=(?<first>inspect_source),(?<last>reply_result)\n## Fallback\n'
$unsupportedPattern += 'stop category=NO_TRIGGER detail="no trigger matched"\n## Authorities\nauthority 1 caller\.reply\n'
$unsupportedPattern += '## Output\noutput contract="the value is the exact source text"\n\z'
$unsupportedProfile = [regex]::Match($unsupported, $unsupportedPattern)
if (!$unsupportedProfile.Success -or $unsupportedProfile.Groups['hidden'].Value -cne 'write') {
    throw 'unsupported fixture does not uniquely extract the hidden write'
}
$loweredBranch = [Collections.Generic.List[string]]::new()
$loweredBranch.Add($unsupportedProfile.Groups['first'].Value)
if ($unsupportedProfile.Groups['after'].Value -ceq $unsupportedProfile.Groups['first'].Value) {
    $loweredBranch.Add($unsupportedProfile.Groups['hiddenName'].Value)
}
$loweredBranch.Add($unsupportedProfile.Groups['last'].Value)
Assert-Equal 'unsupported lowered branch' 'inspect_source,hidden_write,reply_result' ($loweredBranch -join ',')
$declaredAuthorities = @('caller.reply')
$requiredAuthorities = @('caller.reply')
if ($loweredBranch.Contains('hidden_write')) {
    $requiredAuthorities += 'workspace.write'
}
$missingAuthorities = $requiredAuthorities | Where-Object { $_ -cnotin $declaredAuthorities }
$unsupportedFirstCategory = if ($missingAuthorities.Count -ne 0) { 'UNDECLARED_SOURCE_EFFECT' } else { '' }
Assert-Equal 'unsupported first diagnostic' 'UNDECLARED_SOURCE_EFFECT' $unsupportedFirstCategory

$prefixUnsupported = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'unsupported-prefix/SKILL.md')).Replace("`r`n", "`n")
$prefixPattern = '(?s)\A---\nname: "hidden-prefix-write"\ndescription: "Use when request equals inspect prefix\."\n---\n'
$prefixPattern += '# Oi conversion profile\n## Inputs\ninput 1 name=request type=text\ninput 2 name=source type=text\n'
$prefixPattern += '## Triggers\ntrigger 1 kind=text-equals left=input:request right=literal:"inspect prefix"\n## Steps\n'
$prefixPattern += 'step 1 name=(?<anchor>prepare_source) action=pass value=input:source result=result_text:text\n'
$prefixPattern += 'prose-effect 2 name=(?<hiddenName>hidden_write) after=(?<after>prepare_source) action=write '
$prefixPattern += 'path=literal:"result\.txt" content=result:result_text\n'
$prefixPattern += 'step 3 name=reply_result action=reply value=result:result_text\n## Prefix\n'
$prefixPattern += 'prefix steps=(?<prefix>prepare_source)\n## Branches\nbranch 1 trigger=1 steps=reply_result\n'
$prefixPattern += '## Fallback\nstop category=NO_TRIGGER detail="no trigger matched"\n'
$prefixPattern += '## Authorities\nauthority 1 caller\.reply\n## Output\n'
$prefixPattern += 'output contract="the value is the exact source text"\n\z'
$prefixProfile = [regex]::Match($prefixUnsupported, $prefixPattern)
if (!$prefixProfile.Success -or $prefixProfile.Groups['after'].Value -cne $prefixProfile.Groups['prefix'].Value) {
    throw 'prefix-anchor fixture is outside the strict profile'
}
$loweredPrefix = [Collections.Generic.List[string]]::new()
$loweredPrefix.Add($prefixProfile.Groups['prefix'].Value)
$loweredPrefix.Add($prefixProfile.Groups['hiddenName'].Value)
Assert-Equal 'prefix-anchor lowered prefix' 'prepare_source,hidden_write' ($loweredPrefix -join ',')
$prefixRequiredAuthorities = @('caller.reply')
if ($loweredPrefix.Contains('hidden_write')) {
    $prefixRequiredAuthorities += 'workspace.write'
}
$prefixMissing = $prefixRequiredAuthorities | Where-Object { $_ -cnotin @('caller.reply') }
$prefixFirstCategory = if ($prefixMissing.Count -ne 0) { 'UNDECLARED_SOURCE_EFFECT' } else { '' }
Assert-Equal 'prefix-anchor first diagnostic' 'UNDECLARED_SOURCE_EFFECT' $prefixFirstCategory
$extractBlock = [regex]::Match($convertSource, '(?s)func Extract\(.+?\r?\n}\r?\n\r?\nfunc HasAuthority').Value
if (!$extractBlock.Contains('explicit Prefix list cannot name a prose-effect step') -or
    !$extractBlock.Contains('insert each prose-effect step immediately after its named earlier anchor in Unconditional')) {
    throw 'Extract does not close prefix prose-effect insertion'
}

$chainSource = [IO.File]::ReadAllText((Join-Path $PSScriptRoot 'unsupported-chain/SKILL.md')).Replace("`r`n", "`n")
$chainPattern = '(?s)\A---\nname: "chained-hidden-write"\ndescription: "Use when request equals inspect chain\."\n---\n'
$chainPattern += '# Oi conversion profile\n## Inputs\ninput 1 name=request type=text\ninput 2 name=source type=text\n'
$chainPattern += '## Triggers\ntrigger 1 kind=text-equals left=input:request right=literal:"inspect chain"\n## Steps\n'
$chainPattern += 'step 1 name=prepare_source action=pass value=input:source result=result_text:text\n'
$chainPattern += 'prose-effect 2 name=(?<first>hidden_write) after=prepare_source action=write '
$chainPattern += 'path=literal:"first\.txt" content=result:result_text\n'
$chainPattern += 'prose-effect 3 name=chained_write after=(?<chainAfter>hidden_write) action=write '
$chainPattern += 'path=literal:"second\.txt" content=result:result_text\n'
$chainPattern += 'step 4 name=reply_result action=reply value=result:result_text\n## Prefix\nprefix steps=prepare_source\n'
$chainPattern += '## Branches\nbranch 1 trigger=1 steps=reply_result\n## Fallback\n'
$chainPattern += 'stop category=NO_TRIGGER detail="no trigger matched"\n## Authorities\nauthority 1 caller\.reply\n'
$chainPattern += '## Output\noutput contract="the value is the exact source text"\n\z'
$chainProfile = [regex]::Match($chainSource, $chainPattern)
if (!$chainProfile.Success) {
    throw 'chained fixture shape differs'
}
$chainRejected = $chainProfile.Groups['chainAfter'].Value -ceq $chainProfile.Groups['first'].Value
$chainCategory = if ($chainRejected) { 'CONVERSION_UNSUPPORTED' } else { '' }
$chainPreviewGenerated = if ($chainRejected) { 'false' } else { 'true' }
Assert-Equal 'chained prose-effect diagnostic' 'CONVERSION_UNSUPPORTED' $chainCategory
Assert-Equal 'chained prose-effect preview' 'false' $chainPreviewGenerated
if (!$extractBlock.Contains('prose-effect after must name one earlier ordinary step and cannot name any prose-effect')) {
    throw 'Extract still permits chained prose-effects'
}

$main = @"
package main

import "std/fs"

type Result text [$($profile.Groups['contract'].Value)]

effect Reply(value Result) unit {
    uses caller.reply
    contract [deliver {value} exactly once to the caller]
}

func $($profile.Groups['read'].Value)(path fs.Path) text {
    return fs.Read(path)
}

func $($profile.Groups['reply'].Value)(value text) {
    Reply(Result(value))
}

func main($($profile.Groups['request'].Value) text, $($profile.Groups['source'].Value) fs.Path) {
    if $($profile.Groups['request'].Value) == "$($profile.Groups['literal'].Value)" {
        $($profile.Groups['result'].Value) := $($profile.Groups['read'].Value)($($profile.Groups['source'].Value))
        $($profile.Groups['reply'].Value)($($profile.Groups['result'].Value))
        return
    }
    stop("$($profile.Groups['category'].Value)", "$($profile.Groups['detail'].Value)")
}
"@
$main = ($main + "`n").Replace("`r`n", "`n")

$module = "module example/read-source`noi 0.0.1`n"
$tick = [char]96
$adapter = @"
---
name: "$($profile.Groups['name'].Value)"
description: "$($profile.Groups['description'].Value)"
---

# Converted Oi Skill

Triggers:
- $tick$($profile.Groups['request'].Value) == "$($profile.Groups['literal'].Value)"$tick

Load the local ${tick}using-oi${tick} adapter with this directory's ${tick}oi.mod${tick} and ${tick}main.oi${tick}.
Bind typed caller inputs in order: $tick$($profile.Groups['request'].Value) text$tick $tick$($profile.Groups['source'].Value) fs.Path$tick.
Map reachable effects: concrete ${tick}Reply(Result)${tick}, ${tick}workspace.read${tick}.
Host-invoke lowercase ${tick}main${tick} and expose its single captured ${tick}Result${tick} payload unchanged.
"@
$adapter = ($adapter + "`n").Replace("`r`n", "`n")

Assert-Equal 'main snapshot' $main ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'expected/supported-main.oi')).Replace("`r`n", "`n"))
Assert-Equal 'module snapshot' $module ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'expected/supported-oi.mod')).Replace("`r`n", "`n"))
Assert-Equal 'adapter snapshot' $adapter ([IO.File]::ReadAllText((Join-Path $PSScriptRoot 'expected/supported-SKILL.md')).Replace("`r`n", "`n"))

$proofBody = [regex]::Match($convertSource, '(?s)func BuildProof\(.+?\r?\n}\r?\n\r?\nfunc FileSnapshot').Value
$proofFields = [regex]::Matches($proofBody, 'encoding\.Field\{Name: "([^"]+)"') | ForEach-Object { $_.Groups[1].Value }
$expectedFields = [IO.File]::ReadAllLines((Join-Path $PSScriptRoot 'expected/supported-proof-fields.txt')) | Where-Object { $_ -ne '' }
Assert-Equal 'proof field order' ($expectedFields -join "`n") ($proofFields -join "`n")

$allEffects = [regex]::Matches($convertSource, 'fs\.(Scan|Read|Write|WriteIfCurrent)\(').Count
$capturedEffects = [regex]::Matches($convertSource, 'capture\(fs\.(Scan|Read|Write|WriteIfCurrent)\(').Count
if ($allEffects -ne $capturedEffects) {
    throw "uncaptured fs effect: $capturedEffects of $allEffects captured"
}
if ([regex]::Matches($convertSource, 'capture\(fs\.WriteIfCurrent\(').Count -ne 3 -or [regex]::Matches($convertSource, 'writes = writes \+ 1').Count -ne 3) {
    throw 'publish boundary is not exactly three captured conditional writes with three success increments'
}

Write-Output 'convert-oi source audit GREEN'
