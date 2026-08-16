# Aggregate derivation

This shard defines `DeriveExpression` after complete core typing. It adds no effect, authority, hidden control, or source-loading behavior.

## Admission and inputs

Evaluation begins only after core admission has fixed one explicit handle-free target type.

The derivation input is exactly the immutable typed snapshots named by interpolation plus the already verified Oi snapshot. Every dynamic datum must be interpolated. Parent conversation, history, memory, expected values, local tool output, unmapped effects, project facts not passed as values, clock, randomness, and host enumeration order are unavailable.

## Unique transformation

One derivation denotes the unique target-typed result completely determined by those inputs. Parse, decode, normalize, group, sort, canonical render, and equivalent structural transformations are permitted. Context-sensitive policy choice, Agent judgment, effect, retry, dispatch, loop control, handoff, stop, or question is not derivation and cannot be hidden in its text.

Allocate one stable Derive operation before evaluation and record its target type and canonical input digest. If exactly one value satisfies the content and target, contract-check it, commit its type identity and canonical value digest, then return its immutable typed value. Replay consumes that committed result from the protected journal without regenerating it.

Zero or multiple possible results, dependence on unavailable context, or otherwise non-unique transformation fails runtime `NONDETERMINISTIC_DERIVATION` at `derive`. The operation becomes `Failed`; it never guesses, asks, retries, or chooses by host preference. A failure commits no result value. Receipt exposure is only type identity, digest, status, and source location; full inputs/result remain protected journal values.
