# Oi toolchain contracts

The six bundled tools run as exact Oi 0.0.2 modules. The local `using-oi` bootstrap resolves each tool's colocated `oi.mod`, logical-reads the exact [Oi 0.0.2 `execution.md`](../../plugins/oi/skills/using-oi/versions/0.0.2/execution.md) once, parses the manifested reachable graph with that snapshot, closes the prefix manifest, and loads each required shard or standard package at most once. A tool adapter never rereads the base specification or copies its grammar, runtime, or tool algorithm.

Targets independently select exact installed language snapshot 0.0.1 or 0.0.2 through their nearest `oi.mod`; tool version, target version, and plugin packaging version are never substituted for one another. Plugin package 0.0.3 delivers both snapshots, and released 0.0.1 retains its immutable loading/runtime behavior.

Each `main` below is lowercase, resultless, host-only, and invoked once. The adapter binds typed inputs in declaration order, maps the listed reachable effects, captures one concrete `Reply` payload, and exposes that typed value unchanged. Oi code cannot call an entry or observe an entry return.

## Entry and effect map

| Tool and trigger | Exact entry | Concrete reply | Other mapped effects and authorities | Mutation boundary |
| --- | --- | --- | --- | --- |
| `compile-oi`: statically validate a module | `func main(target fs.Path, available []text)` | `effect Reply(value report.CompileReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read`, `load.ReadVerifiedSource(root fs.Path, path fs.Path) load.LogicalReadProbe` → `workspace.read` | Read-only; closes exact manifests and logical reads, never executes or rewrites the target. |
| `format-oi`: canonically format one source | `func main(target fs.Path, available []text)` | `effect Reply(value report.FormatReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; `fs.Write` → `workspace.write` | At most one source write when the typed result is changed. |
| `debug-oi`: replay a deterministic typed receipt | `func main(target fs.Path, bindings []debug.Binding, journal execution.ExecutionJournal, receipt execution.ExecutionReceipt, transcript []debug.EffectResult)` | `effect Reply(value report.DebugTrace) unit` → `caller.reply` | `replay.CompileTarget(target, bindings, receipt.Mappings, receipt.Authorities, transcript)` → `tool.compile` | Read-only; validates 0.0.2 receipts or typed legacy 0.0.1 replay, without invoking target entry or effects. |
| `bench-oi`: run a structured conformance suite | `func main(suite bench.Suite, identity bench.RunIdentity)` | `effect Reply(value report.BenchmarkReport) unit` → `caller.reply` | `bench.CompileTarget(target fs.Path, input text, observe text, forbid text) report.TestReport` → `tool.compile`; `bench.InvokeTarget(target fs.Path, input text, observe text, forbid text) report.TestReport` → `agent.invoke` | Compile evidence executes no target. Invocation uses a sealed fresh context and rejects the first receipt identity mismatch; the bench module writes no files. |
| `convert-oi`: preview or confirm a supported Skill conversion | `func main(source fs.Path, destination fs.Path, module text, targetVersion text, mode convert.Mode, proof text?)` | `effect Reply(value report.ConversionReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; `fs.WriteIfCurrent` → `workspace.read`, `workspace.write` | `targetVersion` is exact 0.0.1 or 0.0.2. Preview writes zero files; confirmed Apply may perform three ordered guarded artifact writes and is not a three-file atomic publish. |
| `upgrade-oi`: analyze one explicit installed language snapshot | `func main(source fs.Path, targetVersion text, installed []text, available []text)` | `effect Reply(value report.UpgradeReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; isolated `upgrade.CompileSource(module upgrade.VirtualModule, available []text) upgrade.CompileResult` → committed `compile-oi` | Read-only 0.0.1→0.0.2 analysis never executes, formats, writes, or implicitly reinterprets the target. `installed` and `targetVersion` are exact snapshot names, never package 0.0.3. |

## Structured payloads

| Payload | Typed fields |
| --- | --- |
| `report.CompileReport` | `Status`, `LanguageVersion`, `Module`, `SourceCount`, `SourceCharacters`, `Sources`, `Authorities`, `Shards`, `Diagnostics` |
| `report.FormatReport` | `Status`, `Path`, `Written`, `Source`, `Diagnostics` |
| `report.DebugTrace` | `Status`, `Events`, `Diagnostics`, `RequiredTranscriptEntries`, `ReceiptValid`, `ReceiptDiagnostics` |
| `report.BenchmarkReport` | `Passed`, `Failed`, `Results`, `Diagnostics` |
| `report.ConversionReport` | `Status`, `Model`, `Bundle`, `Proof`, `Writes`, `Verified`, `Remaining`, `RecoveryRequired`, `PublishAtomic`, `ResidualRace`, `Diagnostics` |
| `report.UpgradeReport` | `SourceVersion`, `TargetVersion`, `Compatibility`, `Changes`, `Diagnostics` |

## Protected cross-tool scenario

Use `plugins/oi/skills/convert-oi/testdata/supported/SKILL.md`, module `example/read-source`, and an isolated destination. Values move between steps as typed reports or exact generated files; no step parses another tool's display text.

1. Invoke `convert-oi` with exact target version `0.0.2` and `convert.Mode.Preview`; require `ConversionReport.Status.Pass`, `Writes == 0`, and present typed `Bundle` and `Proof`.
2. Invoke it again with `convert.Mode.Apply` and that exact proof; require the three snapshots under `plugins/oi/skills/convert-oi/testdata/expected`, with `Writes == 3`.
3. Pass the generated module path and `[]text{"workspace.read", "caller.reply"}` to `compile-oi`; require `CompileReport.Status.Pass` and the structured authority list.
4. Pass the generated `main.oi` and the same authority inventory to `format-oi` twice; require both reports `Unchanged` and `Written == false`.
5. Execute the generated module only through a trusted sealed host, then pass its explicit typed `debug.Binding` values, protected `execution.ExecutionJournal`, `execution.ExecutionReceipt`, and typed effect transcript to `debug-oi`; require a complete receipt-valid `DebugTrace`. Replay must not invoke the target entry or effects.
6. Pass a typed `bench.Suite` that separates compilation from sealed invocation. Require expected ordered `CaseResult` values, actual receipt/digest evidence for execution cases, and rejection of handwritten receipt-shaped reports.
7. Separately pass an exact 0.0.1 module to `upgrade-oi` with target `0.0.2`, installed `[]text{"0.0.1", "0.0.2"}`, and available `[]text{"workspace.read", "caller.reply"}`. Require the typed compatibility report and ordered change analysis while target entry/effect/write counts remain zero.

Receipt validation establishes consistency with the trusted sealed host completion; it does not make a malicious host trustworthy and is not a compiled artifact. If no Oi host is available, record this scenario as dynamically pending. Source/spec inspection alone must not be described as binary compilation, filesystem execution, target invocation, or live payload delivery.
