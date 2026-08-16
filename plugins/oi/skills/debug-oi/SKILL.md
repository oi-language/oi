---
name: debug-oi
description: Use when an Agent needs deterministic typed receipt replay without invoking the target entry or effects.
---

# Debug Oi

Use the colocated manifest and entry through local `using-oi`. Load exact Oi 0.0.2 once and close debug/replay triggers without rereading it.

Bind the exact entry `main(target fs.Path, bindings []debug.Binding, journal execution.ExecutionJournal, receipt execution.ExecutionReceipt, transcript []debug.EffectResult)`. Map `replay.CompileTarget(target, bindings, receipt.Mappings, receipt.Authorities)` to `tool.compile` and `Reply(report.DebugTrace)` to `caller.reply`. Each compatibility probe is a separate mapping attempt. Map no target or workspace effect.

Host-invoke once and expose the one typed `DebugTrace` unchanged. Replay is read-only: never call target main/effects, complete or retry an operation, infer source/expected payloads, or let the target read its current receipt.
