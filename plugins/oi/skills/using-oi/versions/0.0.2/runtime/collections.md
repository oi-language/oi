# Deterministic collections

This shard defines the detailed dynamics of core-declared map/set operations and collection iteration after complete `execution.md` typing. It adds no syntax, authority, effect, or shared mutable state.

## Values and order

A map or set is a finite immutable value. Construction and every builtin result snapshot all typed members; assignment/copy/rebinding cannot expose shared mutable state. Zero is empty. Equality is unavailable.

Canonical total order is: bool `false,true`; int mathematical ascending; text unsigned UTF-8 byte order; enum declaration order. A named stable type uses its underlying order while retaining distinct type identity. No other type is a key/element. Map values obey ordinary value, durability, and handle-scope rules.

Canonical serialization writes type identity, count, then map key/value or set element snapshots in canonical order. It never preserves literal insertion order or internal host representation.

## Construction, indexing, and builtins

Literal expressions evaluate left-to-right. After evaluating a candidate key/element, compare it with already accepted members. Equality with one already present stops runtime `DUPLICATE_KEY` at the later element expression before the literal becomes visible; no last-write-wins or deduplication applies.

`mapping[key]` evaluates mapping then key once. An existing key returns its immutable `V` snapshot. Absence stops runtime `MISSING_KEY` at the index `[`; it never returns zero, optional, host exception, or inserts a member.

`has` evaluates collection then key/element and returns membership. `put` returns a new map with one insertion or replacement. `add` returns a new set containing the member and is unchanged if present. `remove` returns a new map/set without the target and is unchanged if absent. `len` returns the exact member count. Arguments evaluate once, left-to-right; failure exposes no partial result.

## Iteration snapshots

On every dynamic `for ... in collection` encounter, evaluate once, allocate its `oN` at the `for` token, append `Iteration Started`, then `Iteration Completed` with that collection's existing typed value as the full protected immutable sequence before the first body execution. Incomplete setup is safe deterministic internal work under that ID. Slice sequence is ascending zero-based index/value; map sequence is key/value in canonical key order; set sequence is value in canonical element order. A one-binding slice omits indexes.

The body consumes only that completed snapshot. Its length, order, keys, and values are fixed for the encounter; source rebinding cannot alter it. Each later encounter takes a new snapshot. `continue` advances within it; `break` discards its remainder. Replay restores a completed snapshot and never re-enumerates it from host state.
