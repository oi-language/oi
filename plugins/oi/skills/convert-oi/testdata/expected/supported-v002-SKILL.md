---
name: "read-source"
description: "Use when request equals read source."
---

# Converted Oi Skill

Triggers:
- `request == "read source"`

Load the local `using-oi` adapter with this directory's `oi.mod` and `main.oi`.
Bind typed caller inputs in order: `request text` `source fs.Path`.
Map reachable effects: concrete `Reply(Result)`, `workspace.read`.
Host-invoke lowercase `main` and expose its single captured `Result` payload unchanged.
