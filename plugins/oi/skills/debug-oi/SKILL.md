---
name: debug-oi
description: Use when an Agent needs a deterministic read-only structured trace of an Oi 0.0.1 module without executing its entry or effects.
---

# Debug Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph and debug mode, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(target fs.Path, bindings []debug.Binding, journal []text, transcript []debug.EffectResult)`. Map `debug.CompileTarget(target fs.Path, bindings []debug.Binding) debug.LoadPlan` to `tool.compile`, and map `effect Reply(value report.DebugTrace) unit` to `caller.reply`. Map no target effect or workspace effect.

Host-invoke `main` exactly once. Capture exactly one typed `report.DebugTrace` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute the target, or copy debugger algorithms into this adapter.
