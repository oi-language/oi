# Deterministic collections

This shard defines the detailed dynamics of core-declared map/set operations and collection iteration after complete `execution.md` typing. It adds no syntax, authority, effect, or shared mutable state.

## Values and order

A map or set is a finite immutable value. Construction and every builtin result snapshot all typed members; assignment/copy/rebinding cannot expose shared mutable state. Zero is empty. Equality is unavailable.

Canonical total order is: bool `false,true`; int mathematical ascending; text unsigned UTF-8 byte order; enum declaration order. A named stable type uses its underlying order while retaining distinct type identity. No other type is a key/element. Map values obey ordinary value, durability, and handle-scope rules.

Canonical serialization writes type identity, count, then map key/value or set element snapshots in canonical order. It never preserves literal insertion order or internal host representation.

## Static collection diagnostics

An unstable map key is `UNSTABLE_MAP_KEY` in phase `type` at the key type's first token, with Detail equal to its exact source spelling. An unstable set element is `UNSTABLE_SET_ELEMENT` at the element type's first token with the same phase and Detail rule.

Iteration arity failure is `ITERATION_BINDING_ARITY_MISMATCH` in phase `type`. Detail is exactly `slice requires 1 or 2 bindings; found N`, `map requires 2 bindings; found N`, or `set requires 1 binding; found N`, where `N` is canonical decimal. Too many bindings locate the first extra binding token; too few locate `in`.

Invalid collection builtin calls use `ARGUMENT_ARITY_MISMATCH`, `ARGUMENT_TYPE_MISMATCH`, or `RESULT_TYPE_MISMATCH` in phase `type`, at the call site, with the builtin name as Detail.

## Construction, indexing, and builtins

Literal expressions evaluate left-to-right. After evaluating a candidate key/element, compare it with already accepted members. Equality with one already present stops runtime `DUPLICATE_KEY` at the later element expression before the literal becomes visible; no last-write-wins or deduplication applies.

`mapping[key]` evaluates mapping then key once. An existing key returns its immutable `V` snapshot. Absence stops runtime `MISSING_KEY` at the index `[`; it never returns zero, optional, host exception, or inserts a member.

`has` evaluates collection then key/element and returns membership. `put` returns a new map with one insertion or replacement. `add` returns a new set containing the member and is unchanged if present. `remove` returns a new map/set without the target and is unchanged if absent. `len` returns the exact member count. Arguments evaluate once, left-to-right; failure exposes no partial result.

## Iteration snapshots

On every dynamic `for ... in collection` encounter, evaluate the collection once and snapshot the complete typed sequence before the first body execution. Slice sequence is ascending zero-based index/value; map sequence is key/value in canonical key order; set sequence is value in canonical element order. A one-binding slice omits indexes.

The sequence length, order, keys, and values are fixed for that encounter. Body assignment or rebinding of the source variable does not affect it. Each later loop encounter takes a new snapshot. `continue` advances within the existing snapshot; `break` discards the remaining sequence. Journal/replay identify an encounter by the operation identity allocated under `runtime/execution.md` and never re-enumerate a completed boundary from host state.
