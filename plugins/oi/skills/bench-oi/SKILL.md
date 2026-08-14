---
name: bench-oi
description: Use when an Agent needs to run a structured Oi 0.0.1 conformance suite against an explicitly identified harness and model.
---

# Bench Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(suite bench.Suite, identity bench.RunIdentity)`. Map `bench.InvokeTarget(target fs.Path, input text, observe text, forbid text) report.TestReport` to `agent.invoke` with a fresh target context, and map `effect Reply(value report.BenchmarkReport) unit` to `caller.reply`.

Host-invoke `main` exactly once. Capture exactly one typed `report.BenchmarkReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, parse display text, or copy benchmark or runtime algorithms into this adapter.
