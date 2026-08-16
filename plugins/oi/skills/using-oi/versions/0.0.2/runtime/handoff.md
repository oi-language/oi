# Terminal `handoff`

This shard defines `HandoffStmt` after complete core typing. It transfers one task into a fresh activation; it does not create an attached child or expose a result.

## Static target and arguments

`handoff QualifiedName(arguments)` resolves exactly one named ordinary `func` with result `unit`. Effects, arguments, mappings, and required authority are checked before lifecycle mutation. `main`, effects, anonymous functions, dynamic targets, and overload-by-runtime-value are not targets.

Each argument evaluates left-to-right and must have canonical durable serialization under `runtime/persistence.md`. A channel, sender, receiver, task, or any nested runtime handle stops `ENDPOINT_SCOPE_ESCAPE` at its first handle expression before join or target creation. Any other non-durable argument fails at that argument. The target authority set is exactly target-reachable demand intersected with the current activation's authority, host policy, and explicit narrowing; it never expands. Its effect table contains every and only reachable surviving mapping, or preflight stops `UNMAPPED_EFFECT`.

## Join boundary

After preflight, the current activation joins every normal attached task in ascending SourceIndex. Success is discarded; the lowest failing SourceIndex wins and recursively cancels each still-running greater-index sibling. Already transferred detached tasks remain owned by `host/task-registry` and are not joined, cancelled, copied, or returned to the activation. If an attached task fails, handoff does not start.

Only after all attached joins succeed does the runtime serialize arguments and atomically journal:

`{TaskID, OldActivationID, TargetActivationID, Target, Arguments, Authorities, EffectMappings}`

The same TaskID is retained. A task journals its entry/task target as activation zero, then every ordinary-call or handoff-target activation in statement/operand dynamic encounter order. Exact rendering is `<TaskID>/a<N>` with zero-based canonical-decimal `N`; replay reuses the journaled ID and counter. `TargetActivationID` is the next such ID. The old activation becomes terminal in the same commit and can never resume. `handoff` has type `unit` only for statement checking, produces no value, and no later statement in the old activation executes.

## Fresh target context

The target starts from its named function entry in a fresh context containing only target-reachable verified source and shards, typed serialized arguments, intersected authorities, filtered mappings, and fresh trace, checkpoints, protected journal view, and channel/select counters. It excludes old conversation, locals, attached-task results not passed as arguments, tool output, effect results, implicit memory, trace, checkpoints, journal, and unfiltered mappings.

Target execution is the continued root of the same task: its terminal success, failure, or cancellation becomes that TaskID's final state and host observation. Replay consumes the handoff record and recreates the same target activation and arguments without rerunning the old activation or its joined children. Persistence/recovery of the record is defined only by `runtime/persistence.md`.
