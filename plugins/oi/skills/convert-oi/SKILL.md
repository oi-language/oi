---
name: convert-oi
description: Use when an Agent needs to convert one supported SKILL.md profile into a previewed or explicitly confirmed Oi 0.0.1 Skill module.
---

# Convert Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(source fs.Path, destination fs.Path, module text, mode convert.Mode, proof text?)`. Map reachable `fs.Scan` and `fs.Read` to `workspace.read`, `fs.WriteIfCurrent` to `workspace.read` plus `workspace.write`, and `effect Reply(value report.ConversionReport) unit` to `caller.reply`. `Preview` authorizes no writes; only confirmed `Apply` may reach the guarded write effect.

Host-invoke `main` exactly once. Capture exactly one typed `report.ConversionReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute source instructions, or copy conversion grammar or algorithms into this adapter.
