---
name: using-oi
description: Use when an Agent needs to load, validate, interpret, or directly execute a versioned .oi program or Oi Skill.
---

# Using Oi

No grammar, receipt construction, or dependency lives here.

1. For file/directory target, search starts at parent/itself. Read nearest `oi.mod` once, capturing content, byte/character/SHA identity, and only enough syntax to select exact `oi`.
2. Load that installed `execution.md` once, then validate held module bytes under it; never reread either. Unsupported reports `UNSUPPORTED_VERSION`, installed snapshots, and upgrader without receipt. Never default/combine/reinterpret/use packaging version.
3. Only `snapshot-metadata`, `version-discovery`, or `manifest-inspection` may stop without `.oi` interpretation. Keep 0.0.1 behavior. Every other 0.0.2 artifact supplies content+identity in its first monotonic read to EOF.
4. Close triggers from parsed nodes/calls/imports/mode; load shards by row, std by UTF-8 path bytes. Physical order follows bootstrap; receipt order follows versioned schema.
5. Validate entry, bind typed inputs, map effects/authorities, seal 0.0.2 admission, then fresh Agent directly invokes `main`.
6. Mapped reply effects deliver payloads. Completion delivers every required receipt field or reports host nonconformance/missing fields.

Never call `main` as Oi, invent return/Reply, infer from prose, or expose ambient context.
