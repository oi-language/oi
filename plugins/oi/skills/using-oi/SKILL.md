---
name: using-oi
description: Use when an Agent needs to load, validate, interpret, or directly execute a versioned .oi program or Oi Skill.
---

# Using Oi

This bootstrap adapter contains no Oi behavior, grammar, algorithm, or inferred shard dependency.

1. Find the nearest `oi.mod`, resolve its exact `oi` version, and load that version's complete `execution.md` exactly once.
2. For exactly `snapshot-metadata`, `version-discovery`, or `manifest-inspection` with no `.oi` interpretation, stop without source parsing.
3. Otherwise load the reachable project/standard-library `.oi` graph using that same read.
4. From parsed nodes, resolved standard calls, imports, and run mode, compute manifest-trigger union and declared transitive closure. Load runtime files in manifest order and standard packages in UTF-8 path-byte order; report the manifest's missing-file categories.
5. Statically validate the lowercase entry, bind typed caller inputs in declaration order, map reachable effects/authorities, and host-invoke `main`.
6. Expose only concrete payloads from explicitly mapped reply effects.

An absent exact version reports `UNSUPPORTED_VERSION`, exact snapshot names under this skill's `versions/`, and explicit upgrader, then stops. Never read the base spec twice, invoke `main` as an Oi function, invent an entry return, treat reply names as built-ins, copy algorithms, infer shard dependencies from prose, or treat plugin packaging version as a language snapshot. Runtime-token execution remains the runtime plan's work.
