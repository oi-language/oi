---
name: bench-oi
description: Use when an Agent needs to run a structured Oi conformance suite against an explicitly identified harness and model.
---

# Bench Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. Load exact Oi 0.0.2 `execution.md` once, close the manifested graph, and never reread the base specification.

Bind inputs to `func main(suite bench.Suite, identity bench.RunIdentity)`. Map `CompileTarget(target,input,observe,forbid)` to `tool.compile`: sealed compile, target code zero, evidence absent. Map unchanged `InvokeTarget(target,input,observe,forbid)` to `agent.invoke`: sealed fresh run, actual receipt/digest. Both set LanguageVersion from target's nearest exact `oi.mod`; CompileTarget cross-binds target/version/source only. Before InvokeTarget returns, reject the first mismatch in `Target→LanguageVersion→Artifacts(manifest/source order)→Inputs→Mappings→Authorities→AuthoritiesIdentity→Policy→Entry→Terminal→ReplyOperationID→Reply.Digest` as `BENCH_EVIDENCE_MISMATCH|runtime|target:1:1|sealed invocation mismatch: <FieldPath>|[]`. Map `Reply` to `caller.reply`.

Host-invoke `main` once and expose its one typed `BenchmarkReport` Reply unchanged. Do not Oi-call `main`, infer a result, encode mode in text or fixture names, reuse one host effect then discard evidence, accept expected prose as evidence, or copy benchmark/runtime algorithms. Supports 0.0.1/0.0.2.
