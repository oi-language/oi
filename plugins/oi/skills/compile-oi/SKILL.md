---
name: compile-oi
description: Use when an Agent needs to statically validate an Oi module without compiling, rewriting, or executing it.
---

# Compile Oi

Use the colocated `oi.mod` and `main.oi` through the local `using-oi` bootstrap. For each request, load the resolved exact Oi 0.0.1 `execution.md` exactly once, close its prefix manifest from the parsed reachable graph, and never read the base specification again.

Bind typed caller inputs to the host-only lowercase resultless entry exactly as `func main(target fs.Path, available []text)`. Map reachable `fs.Scan` and `fs.Read` to `workspace.read`, and map `effect Reply(value report.CompileReport) unit` to `caller.reply`.

Host-invoke `main` exactly once. Capture exactly one typed `report.CompileReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute or rewrite the target, or copy grammar or compiler algorithms into this adapter.
