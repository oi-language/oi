---
name: registry-analysis
description: Analyze caller-supplied typed import facts with Oi 0.0.2.
---

# Registry analysis

Use the colocated `oi.mod` and `main.oi` through `using-oi`. Bind the caller's typed imports exactly as `func main(imports []ImportFact)`.

Map `effect Reply(value RegistryReply) unit` to `caller.reply`. Host-invoke `main` exactly once and expose its one `RegistryReply` unchanged. Map no workspace or other authority.
