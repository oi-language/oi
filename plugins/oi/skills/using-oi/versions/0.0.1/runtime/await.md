# `await` task completion

This shard defines `AwaitExpression` after `execution.md` typing. It depends only on the core snapshot; `await oi Call(arguments)` also uses the independently triggered `runtime/oi.md` semantics.

## Forms and result

`await handle` requires `handle: task[T]` and has type `T`. It suspends the current task until the owned task's completion journal contains one immutable terminal record; an attached child releases its `Active` slot under `runtime/oi.md`, while root is excluded. Success commits exactly one `T`; await returns that value. In statement position the returned value is discarded.

`await oi Call(arguments)` first performs the complete attached launch, then waits on that new handle. It may be a statement or an expression. It is not a different launch mode and does not make execution synchronous before the launch record exists.

Completion is journaled, not consumed. Repeating `await` on the same owned handle reads the same terminal record and returns the same committed result without relaunching, repeating effects, or extracting a second result. Concurrent observation never mutates that record.

## Ownership and failures

Only the dynamic function activation recorded as the task owner may await its handle. Awaiting another owner's task, an invalid or zero handle, or a detached task whose completion notification was lost stops with `INVALID_TASK_OWNER`. A later handoff or durable-notification shard may establish a new valid owner; absent that explicit record, no ownership is inferred.

If the child completion is failure, explicit await propagates the exact category, phase, detail, and child source location, appends canonical `await@<location>` at its `await` token, and stops the awaiting task. Before that task becomes terminal it recursively cancels all of its still-running attached siblings and descendants. Cancellation does not replace an already journaled failure.

The source location for `INVALID_TASK_OWNER`, an invalid await target, or another failure caused by the wait operation is the `await` token. A propagated child failure preserves the child's original location; an implicit join preserves the selected attached failure's original location. These rules make diagnostics independent of wall-clock scheduling.
