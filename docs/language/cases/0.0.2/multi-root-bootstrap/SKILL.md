---
name: multi-root-bootstrap
description: Decide a bootstrap from caller-supplied typed roots and registry state with Oi 0.0.2.
---

# Multi-root bootstrap

Use the colocated `oi.mod` and `main.oi` through `using-oi`. Bind caller inputs in declaration order exactly as `func main(roots []RootFact, registry RegistryState)`.

Map `effect Reply(value BootstrapReply) unit` to `caller.reply`. Host-invoke `main` exactly once and expose its one `BootstrapReply` unchanged. Map no workspace or other authority.
