# Oi 0.0.1 toolchain contracts

The six tools share one request boundary. The local `using-oi` bootstrap resolves the tool's colocated `oi.mod`, loads the exact Oi 0.0.1 `execution.md` once, parses the reachable graph with that same snapshot, closes the prefix manifest, and loads each required shard or standard package at most once. A tool adapter never reads the base specification again or copies its grammar, runtime, or tool algorithm.

Each `main` below is lowercase, resultless, host-only, and invoked once. The adapter binds typed inputs in declaration order, maps the listed reachable effects, captures one concrete `Reply` payload, and exposes that typed value unchanged. Oi code cannot call an entry or observe an entry return.

## Entry and effect map

| Tool and trigger | Exact entry | Concrete reply | Other mapped effects and authorities | Mutation boundary |
| --- | --- | --- | --- | --- |
| `compile-oi`: statically validate a module | `func main(target fs.Path, available []text)` | `effect Reply(value report.CompileReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read` | Read-only; never executes or rewrites the target. |
| `format-oi`: canonically format one source | `func main(target fs.Path, available []text)` | `effect Reply(value report.FormatReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; `fs.Write` → `workspace.write` | At most one source write when the typed result is changed. |
| `debug-oi`: produce a deterministic dry trace | `func main(target fs.Path, bindings []debug.Binding, journal []text, transcript []debug.EffectResult)` | `effect Reply(value report.DebugTrace) unit` → `caller.reply` | `debug.CompileTarget(target fs.Path, bindings []debug.Binding) debug.LoadPlan` → `tool.compile` | Read-only; target effects are transcript inputs and never invoked. |
| `bench-oi`: run a structured conformance suite | `func main(suite bench.Suite, identity bench.RunIdentity)` | `effect Reply(value report.BenchmarkReport) unit` → `caller.reply` | `bench.InvokeTarget(target fs.Path, input text, observe text, forbid text) report.TestReport` → `agent.invoke` | Invokes each target in a fresh context; the bench module writes no files. |
| `convert-oi`: preview or confirm a supported Skill conversion | `func main(source fs.Path, destination fs.Path, module text, mode convert.Mode, proof text?)` | `effect Reply(value report.ConversionReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; `fs.WriteIfCurrent` → `workspace.read`, `workspace.write` | Preview writes zero files; confirmed Apply may perform three ordered guarded artifact writes and is not a three-file atomic publish. |
| `upgrade-oi`: check one explicit installed version | `func main(source fs.Path, targetVersion text, installed []text, available []text)` | `effect Reply(value report.UpgradeReport) unit` → `caller.reply` | `fs.Scan`, `fs.Read` → `workspace.read`; `upgrade.CompileSource(source fs.Path, available []text) upgrade.CompileResult` → `tool.compile` | Read-only; never executes, rewrites, or implicitly reinterprets the target. |

## Structured payloads

| Payload | Typed fields |
| --- | --- |
| `report.CompileReport` | `Status`, `Module`, `SourceCount`, `Authorities`, `Shards`, `Diagnostics` |
| `report.FormatReport` | `Status`, `Path`, `Written`, `Source`, `Diagnostics` |
| `report.DebugTrace` | `Status`, `Events`, `Diagnostics`, `RequiredTranscriptEntries` |
| `report.BenchmarkReport` | `Passed`, `Failed`, `Results`, `Diagnostics` |
| `report.ConversionReport` | `Status`, `Model`, `Bundle`, `Proof`, `Writes`, `PublishAtomic`, `ResidualRace`, `Diagnostics` |
| `report.UpgradeReport` | `SourceVersion`, `TargetVersion`, `Compatibility`, `Changes`, `Diagnostics` |

## Atomic cross-tool scenario

Use `plugins/oi/skills/convert-oi/testdata/supported/SKILL.md`, module `example/read-source`, and an isolated destination. Values move between steps as typed reports or exact generated files; no step parses another tool's display text.

1. Invoke `convert-oi` with `convert.Mode.Preview`; require `ConversionReport.Status.Pass`, `Writes == 0`, and present typed `Bundle` and `Proof`.
2. Invoke it again with `convert.Mode.Apply` and that exact proof; require the three snapshots under `plugins/oi/skills/convert-oi/testdata/expected`, with `Writes == 3`.
3. Pass the generated module path and `[]text{"workspace.read", "caller.reply"}` to `compile-oi`; require `CompileReport.Status.Pass` and the structured authority list.
4. Pass the generated `main.oi` and the same authority inventory to `format-oi` twice; require the second `FormatReport.Status.Unchanged` and `Written == false`.
5. Pass the generated module, explicit typed `debug.Binding` values, journal records, and typed `debug.EffectResult` transcript to `debug-oi`; require a complete `DebugTrace`.
6. Pass a typed two-case `bench.Suite` whose cases both target the generated module: one expects its read result and one forbids that same observation. Require `Passed == 1`, `Failed == 1`, and ordered `CaseResult` values with the forbidden hit failing its case.
7. Pass the generated module to `upgrade-oi` with target `0.0.1`, installed `[]text{"0.0.1"}`, and available `[]text{"workspace.read", "caller.reply"}`; require `Compatibility.Compatible`, zero `Changes`, and zero diagnostics.

If no Oi host is available, record this scenario as dynamically pending. Source/spec inspection alone must not be described as binary compilation, filesystem execution, target invocation, or live payload delivery.
