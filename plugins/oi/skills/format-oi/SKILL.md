---
name: format-oi
description: Use when an Agent needs to canonically format exactly one Oi 0.0.1 source file without executing the target module.
---

# Format Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(target fs.Path, available []text)`. Map reachable `fs.Scan` and `fs.Read` to `workspace.read`, `fs.Write` to `workspace.write`, and `effect Reply(value report.FormatReport) unit` to `caller.reply`.

Host-invoke `main` exactly once. Capture exactly one typed `report.FormatReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute the target, encode a fixed-line report, or copy grammar or formatting algorithms into this adapter.
