---
name: using-oi
description: Use when an Agent needs to load, validate, interpret, or directly execute a versioned .oi program or Oi Skill.
---

# Using Oi

No Oi grammar, receipt construction, or dependency lives here.

1. Target may be file or directory: search starts at the directory itself or file's parent. From nearest `oi.mod`, load exact installed `execution.md` once. Unsupported reports `UNSUPPORTED_VERSION`, installed snapshots, and upgrader; never default/combine/reinterpret/use packaging version.
2. Only exact `snapshot-metadata`/`version-discovery`/`manifest-inspection` may stop without `.oi` interpretation. Keep 0.0.1 discovery. For every manifest-only 0.0.2 read, acquire content+byte/character/SHA in its first monotonic pass and close true EOF; never reread.
3. Close triggers from parsed nodes, calls/imports, and run mode. Load shards by row and std by UTF-8 path bytes; report exact failures.
4. Validate lowercase entry, bind typed inputs in declaration order, and map reachable effects/authorities.
5. Fresh Agent directly invokes validated `main`, never an interface/inspection substitute. 0.0.2 seals admission first; 0.0.1 stays unchanged.
6. Typed payloads use mapped reply effects. A recognized 0.0.2 invocation completes only when every shard-required receipt field is delivered separately; otherwise report missing fields.

Never read base twice, call `main` as Oi, invent return/Reply, copy behavior here, infer from prose, or expose ambient context.
