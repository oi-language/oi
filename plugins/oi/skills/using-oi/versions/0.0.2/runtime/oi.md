# `oi` attached tasks

This shard defines `OiExpression` after complete `execution.md` parsing and typing. It adds no syntax or authority.

## Static resolution

`oi QualifiedName(arguments)` must resolve to one named ordinary `func`. Resolve exports, arguments, result, effects, and authority before launch. Result `T`, including `unit`, gives `task[T]`.

An effect target stops `OI_EFFECT_FORBIDDEN`; any other declared non-function stops `OI_REQUIRES_NAMED_FUNCTION`. Both are type failures at `oi` before generic unknown/invalid-call diagnostics. `main` remains `ENTRY_NOT_CALLABLE`. No anonymous-function or `oi`-block syntax exists.

The expression may initialize a local or be a statement, which discards only the handle. Assignment is optional.

## Launch identity and record

Arguments evaluate left-to-right. TaskID is stable: corpus root is `root`; child ID is `ParentID/SourceIndex`, with SourceIndex the canonical-decimal, zero-based dynamic encounter index for that owner activation. It is fixed before admission and independent of time, making the path unique on identical replay.

Root depth is `0`; child depth is parent plus `1`. Inclusive `MaxDepth` accepts `childDepth <= MaxDepth`. Otherwise stop `TASK_DEPTH_LIMIT` at `oi` before ID, record, context, or admission. Detail is exactly `child depth <d> exceeds maximum <m>` with canonical decimals. Thus maximum `2` rejects the third launch at depth `3`.

A successful launch atomically journals this immutable record:

`{TaskID, ParentID, SourceIndex, Target, Arguments, Authorities}`

`Target` is resolved function. `Arguments` is typed ordered serialization of explicit arguments: core values cross by immutable snapshot; only an affine endpoint permitted by another shard may also cross. `Authorities` is exactly target-reachable demand intersected with owner authority, host policy, and explicit narrowing. Missing demand fails before launch; authority never expands.

The child mapped-effect table is exactly parent mappings whose program effect is reachable from `Target` and whose authority survives that intersection: every required reachable entry, no other mapping. Missing required mapping is pre-launch `UNMAPPED_EFFECT`. Declarations, conventional names, and parent-only mappings are not inherited.

## Fresh context

Child context contains only target-reachable verified source/shards, explicit serialized arguments, narrowed authorities, filtered mappings, and fresh trace, checkpoints, and protected journal. It excludes parent conversation, locals, tool output, effect results, implicit memory, trace, checkpoints, journal, and unfiltered mappings. Values enter only by typed parameters or a specified runtime primitive.

## Deterministic admission

`MaxConcurrency` is positive. `Active` counts runnable/running admitted children; root and suspended tasks are excluded. Blocking on `await`, implicit join, a host effect, or other host wait suspends the child and releases its slot. Terminal success, failure, or cancellation also releases it.

A launch with a free slot is admitted; otherwise it enters the same queue as each ready suspended child. `oi` journals and returns without capacity rejection. Sort by TaskID UTF-8 bytes, ParentID bytes, SourceIndex, then `launch` before `resume`. Both admission and resume require `Active < MaxConcurrency`. Journal/replay every enqueue, suspend, release, admission, resume, and terminal transition. At maximum `1`, a child awaiting its queued grandchild suspends; the grandchild runs, terminates, then the parent queues and resumes. Identical source, inputs, and policy yield identical admission/completion order. Runnable admitted children execute concurrently.

## Ownership, join, and cancellation

Owner is the launching dynamic function activation. Discarding a handle preserves attachment; handles do not transfer ownership.

At normal scope exit, the owner implicitly joins unobserved attached tasks in ascending SourceIndex while they continue concurrently. The implicit Join operation Location is the owner function's closing `}` token. Success is discarded. First observed failure becomes owner failure and recursively cancels each still-running greater-index sibling. Thus lowest failing index wins even if a higher one completed first. A descendant failure belongs to its nearest attached ancestor completion.

Cancellation is recursive and idempotent. Before a stopped/cancelled owner becomes terminal it requests cancellation of all still-running children; they do likewise for descendants. Terminal completion is immutable. A cancelled task records `TASK_CANCELLED` at its launch `oi`.
