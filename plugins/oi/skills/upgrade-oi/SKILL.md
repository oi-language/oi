---
name: upgrade-oi
description: Use when an Agent needs to check whether an Oi module can use one explicitly requested installed language version without changing files or executing the target.
---

# Upgrade Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(source fs.Path, targetVersion text, installed []text, available []text)`. `installed` and `targetVersion` are exact language snapshot names under `using-oi/versions/`, never the host plugin packaging version. Map reachable `fs.Scan` and `fs.Read` to `workspace.read`. Route `upgrade.CompileSource(source fs.Path, available []text) upgrade.CompileResult` to `compile-oi`, mapping named status values and the typed module, authorities, and diagnostics fields without reinterpretation. Map `effect Reply(value report.UpgradeReport) unit` to `caller.reply`.

Host-invoke `main` exactly once. Capture exactly one typed `report.UpgradeReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute or write the target, or copy version or compiler algorithms into this adapter.
