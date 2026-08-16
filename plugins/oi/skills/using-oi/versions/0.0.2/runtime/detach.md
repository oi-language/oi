# Detached tasks and task inspection

This shard defines `DetachExpr` plus the `std/task` intrinsics after complete core typing. It uses `runtime/oi.md` launch identity, records, contexts, admission, and cancellation, but changes ownership only as stated here.

## Form and preflight

`detach oi QualifiedName(arguments)` is a statement and returns no handle. The target must be a statically resolved named ordinary function; `oi` target, argument, effect, authority, depth, and mapping checks apply. Its result is retained only for the host notification.

Every argument must have canonical durable serialization under `runtime/persistence.md`. A channel, sender, receiver, task, or parent-local runtime handle anywhere in an argument stops `ENDPOINT_SCOPE_ESCAPE` at its first handle expression. Any other non-durable value fails at its first argument. All preflight and `MaxDetachedTasks` policy checks finish before TaskID allocation, launch, effect, registry mutation, or child execution. The nonnegative quota counts nonterminal host-owned tasks; exceeding it stops `DETACH_QUOTA_EXCEEDED` at `detach`.

## Transfer and execution

After successful preflight, create the immutable `oi` launch record and an adjacent transfer record from the launching activation to `host/task-registry` in one commit. There is no observable parent-owned interval: failure before the commit launches nothing; success returns only after both records exist. The registry is keyed by TaskID and records target, serialized arguments, narrowed authorities, state, terminal record, and notification state.

The detached task uses the normal fresh sealed context and deterministic admission queue. It is absent from the parent's attached set, is never implicitly joined, and does not delay parent completion. Parent completion, failure, cancellation, handoff, or loss of its local context neither cancels nor changes the transferred task. Conversely, detached success, failure, or cancellation never changes an already completed parent.

Registry state is `Pending` before admission, `Running` while admitted/running/suspended, then exactly one immutable `Done`, `Failed`, or `Cancelled` terminal record. On terminal commit the host emits exactly one notification:

`{TaskID, Target, State, Result?, Failure?}`

`Done` contains the durable result; `Failed` preserves exact category, phase, location, detail, and trace; `Cancelled` contains its one `TASK_CANCELLED` record. Notification follows terminal commit and may follow parent completion. Replay reads the same transfer, terminal, and notification records and never relaunches or renotifies. Persistence and recovery are defined only by `runtime/persistence.md`.

An admitted child blocked in a host effect remains `Running` after that effect's `Started` record. The host controls its one terminal `Completed`, `Failed`, `Indeterminate`, or `Cancelled` record; the child terminal record and registry notification must follow it. Corpus schedules name these records explicitly, so parent-before-notification assertions never infer progress from admission or wall-clock timing.

The host registry may inspect any registered TaskID and recursively request cancellation. A request is idempotent; it wakes waits, cancels attached descendants, produces at most one terminal cancellation record, and never changes a prior terminal record. Program code receives no detached handle, so it cannot call task intrinsics on a detached task.

## `std/task` intrinsics

Importing `std/task` exposes data declarations from `std/task/task.oi`. The runtime supplies these built-in signatures; `[T]` is intrinsic notation, not user generic syntax:

`task.Status(task[T]) task.Info`

`task.Cancel(task[T]) unit`

Both require a live handle owned by the calling activation; otherwise stop `INVALID_TASK_OWNER` at the qualified call. Neither moves or consumes the handle. `Status` reads the latest journaled snapshot and returns exact ID, resolved target, `Detached: false`, and state: queued is `Pending`; admitted, running, or suspended, including a host effect with `Started` but no terminal record, is `Running`; terminal success/failure/cancellation is `Done`/`Failed`/`Cancelled`.

`Cancel` idempotently requests recursive cancellation. Every in-flight effect with `Started` must first receive exactly one host-controlled terminal record; cancellation acknowledgement records `Cancelled`, never a fabricated result. The task's immutable `TASK_CANCELLED` record follows those effect terminals. `Cancel` suspends until that task record exists, marks it observed by this owner, and returns unit; a later implicit join therefore does not fail the owner for the acknowledged record. After return, `Status` is `Cancelled`. If already terminal, `Cancel` changes nothing and returns. Repeated calls create no second request, effect terminal, or cancellation record.
