---
name: actual-invocation-proof
description: Demonstrate sealed Oi 0.0.2 invocation and Reply evidence.
---

# Actual invocation proof

Use the colocated `oi.mod` and `main.oi` through `using-oi`. Bind the caller's challenge exactly as `func main(challenge text)`; do not bind any held expected answer.

Map `effect Reply(value InvocationReply) unit` to `caller.reply`. Host-invoke `main` exactly once and expose its one `InvocationReply` unchanged. Map no workspace or other authority.
