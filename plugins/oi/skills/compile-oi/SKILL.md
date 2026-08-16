---
name: compile-oi
description: Use when an Agent needs to statically validate an Oi module without compiling, rewriting, or executing it.
---

# Compile Oi

Use the compiler's colocated `oi.mod` and `main.oi` through local `using-oi`. The compiler remains exact Oi 0.0.1. Load that `execution.md` once, close its reachable prefix manifest, and never reread it. The target's nearest held `oi.mod` independently selects exact 0.0.1 or 0.0.2; never substitute the compiler version.

Bind typed caller inputs to the host-only resultless `func main(target fs.Path, available []text)`. Map reachable `fs.Scan`, `fs.Read`, and `load.ReadVerifiedSource` to `workspace.read`, and `Reply` to `caller.reply`. For `ReadVerifiedSource`, resolve its explicit root plus normalized relative path; read contiguous nonoverlapping bytes zero-to-true-EOF once; close with byte count, decoded characters, and SHA-256; return the concrete typed probe unchanged. A supplied read-observation transcript controls drift tests.

Host-invoke `main` exactly once. Capture exactly one typed `report.CompileReport` payload from `Reply` and expose it unchanged. Do not Oi-call `main`, infer an entry return, execute or rewrite the target, or copy grammar or compiler algorithms into this adapter.
