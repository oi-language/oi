---
name: upgrade-oi
description: Use when an Agent needs to check whether an Oi module can use one explicitly requested installed language version without changing files or executing the target.
---

# Upgrade Oi

Use the colocated exact Oi 0.0.2 module through local `using-oi`; load its `execution.md` once and close only its reachable manifest.

Bind caller inputs exactly to `func main(source fs.Path, targetVersion text, installed []text, available []text)`. `installed` and `targetVersion` name exact language snapshots, never packaging versions. Map `fs.Scan`/`fs.Read` to `workspace.read` and Reply to `caller.reply`.

Map each `upgrade.CompileSource(module upgrade.VirtualModule, available []text)` call in isolation to the committed compile-oi entry. Mount one private in-memory read-only directory named exact `upgrade-virtual`; place only `module.ManifestSource` at `upgrade-virtual/oi.mod` and each ordered source at `upgrade-virtual/<Path>`. Invoke compile-oi once with target exact `upgrade-virtual` when `module.Target` is none, otherwise exact `upgrade-virtual/<module.Target>`, and with `available`; validate `module.Entry` as an exact present source identity. Require the exact language version, module, target, entry, manifest, source closure, and complete typed result; never preflight or fall back to target files. Host-invoke upgrade main once and expose its one typed report unchanged. Never execute, format, or write the target. Supports 0.0.1/0.0.2.
