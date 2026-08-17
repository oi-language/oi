# Oi repository rules

## Architecture
- Oi is 0% scripts and 100% Skill.
- Product behavior belongs in `.oi`; `SKILL.md` only triggers, loads, routes, and names the entry.
- Markdown language/runtime specifications define semantics; they do not implement tool algorithms.

## Sources of truth
- `using-oi/versions/<version>/execution.md` is the sole base-language file: its compact prefix owns exact snapshot identity, deterministic load order, manifest closure, load failures, and budgets; its continuous body owns complete grammar, static semantics, and shallow execution semantics.
- Released snapshots 0.0.1 and 0.0.2 have no `core.md`, `syntax.md`, `types.md`, `functions.md`, or other base-language shard.
- `using-oi/versions/<version>/runtime/` owns only detailed dynamics for core-declared constructs.
- Versioned `std/` and reachable `.oi` own executable behavior; corpus fixtures own expected observations.
- README and `docs/language/` explain the product but cannot override a versioned specification.

## Language discipline
- Describe Oi as an independent language.
- An executable package has one lowercase host-only resultless `main` with ordinary typed caller inputs; complex input is a program type, not a built-in `Input`. Oi source cannot call it; adapters expose only explicitly mapped concrete typed effect payloads.
- A semantic expression performs one contextually typed judgment; write control, effects, retry, dispatch, and stop behavior as Oi structure.
- Keep effects and authorities explicit. Child context and channel endpoints cross boundaries only through typed arguments.

## Versions
- Every `.oi` resolves one exact version through its nearest `oi.mod`; never default, combine, or reinterpret.
- Oi 0.0.2 is the current language snapshot. Installed snapshots are exactly 0.0.1 and 0.0.2; released 0.0.1 remains byte-immutable and retains its released loading/runtime behavior.
- Language snapshot and plugin packaging version are independent axes. `oi.mod` and `using-oi/versions/<version>/` own language identity; marketplace.json and plugin.json own host install/update. Matching numbers are coincidental and will drift.
- Upgrade the language snapshot, stdlib, bundled tools, adapters, examples, corpus, and execution-spec manifests as one language release unit. Marketplace and plugin.json bumps are a separate packaging unit and must not mutate a released snapshot.
- After release, keep an older snapshot immutable and make upgrades explicit and compatibility-checked.
- Ship a new snapshot only with a packaging-version bump so hosts deliver it. Keep the marketplace files and plugin.json files at one packaging version. Never treat packaging version as `oi.mod`, as `upgrade-oi` `installed` snapshots, or as a language git tag.
- Plugin package 0.0.3 delivers installed language snapshots 0.0.1 and 0.0.2. It does not change either snapshot's identity or semantics.

## Implementation boundaries
- Do not add Python, JavaScript, TypeScript, Shell, PowerShell, batch, binary, executable test helpers, or a second runtime.
- Keep standard packages small and load them only when imported.
- Do not encode structs, lists, state, or diagnostics as internal line protocols; encode only at real text boundaries.

## Verification
- Add or update corpus behavior before changing semantics.
- Run the smallest relevant corpus/tool checks, then cross-tool and release gates.
- Report exact commands, structured results, character budgets, and final diff status.
- Product `.oi` lines must not exceed 240 characters. Execution spec, index prefix, prefix+adapter, adapter, and runtime-shard budgets are 14,000, 2,500, 4,000, 1,500, and 5,000 decoded characters.

## Public documentation
- Keep normative specifications and explanatory documentation separate.
- README and `docs/language/` must describe released behavior or an explicitly identified pre-publication state accurately.
- Link normative claims to the selected snapshot's `execution.md` and runtime shards. Public prose may summarize boundaries and release identity but must not redefine grammar or runtime algorithms.
- Describe receipts as consistency evidence from a trusted sealed host completion, not as compiled artifacts or proof that a malicious host is trustworthy.
- Public files must contain only information intended for repository users and contributors.
