---
name: format-oi
description: Use when an Agent needs to canonically format exactly one Oi 0.0.1 or 0.0.2 source or its explicitly targeted manifest without executing the target module.
---

# Format Oi

Use the formatter's colocated `oi.mod` and `main.oi` through local `using-oi`. The formatter itself is exact Oi 0.0.2. Load that `execution.md` once, close its reachable prefix manifest, and never reread it. The target's nearest exact `oi.mod` independently selects Oi 0.0.1 or 0.0.2; never default, combine, reinterpret, or substitute the formatter version.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(target fs.Path, available []text)`. Map reachable `fs.Scan` and `fs.Read` to `workspace.read`, `fs.Write` to `workspace.write`, and `effect Reply(value report.FormatReport) unit` to `caller.reply`.

Host-invoke `main` exactly once. Capture exactly one typed `report.FormatReport` payload from `Reply` and expose it unchanged. Format only the explicit target; an `oi.mod` is special only when it is that target. Do not Oi-call `main`, infer an entry return, execute the target, rewrite siblings, encode a report as text, or copy grammar or formatting algorithms into this adapter.
