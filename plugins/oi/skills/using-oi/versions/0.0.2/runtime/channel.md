# Bounded typed channels and `select`

This shard defines channel operations and `SelectStmt` after `execution.md` typing; it adds no effect, authority, shared memory, or implicit context.

## Construction and ownership

`channel[T](capacity)` requires durable `T` and compile-time positive integer capacity within policy. Otherwise `INVALID_CHANNEL_CAPACITY` uses the capacity expression. 0.0.2 has no zero-capacity/unbuffered channel.

The evaluating activation owns the channel through terminal transition after attached join/cancellation. Creation journals ChannelID, owner, `T`, capacity. `.Send: sender[T]` and `.Receive: receiver[T]`; all are opaque.

Each channel is bounded MPSC: sender copies share one queue and one receiver. A sender is clonable and may be a direct ordinary/attached-`oi` argument. A receiver is affine: assignment/argument moves it, invalidates its source, and journals its holder. A second move/use stops `RECEIVER_ALREADY_MOVED`; it cannot copy.

Channel, sender, receiver, and task are forbidden recursively in `T`; `RUNTIME_HANDLE_PAYLOAD` uses the first handle token. Handles are owner locals or direct ordinary/attached-`oi` parameters only, never data, semantic/effect values, returns, detach/handoff arguments, or longer-lived state; escape stops `ENDPOINT_SCOPE_ESCAPE`.

0.0.2 has no `close`. Owner end journals channel end after attached join/cancellation; no endpoint survives. Stop/cancellation wakes blocked operations before terminal completion and propagates existing failure without inventing messages.

## Canonical identities

Each task journals activations in statement/operand order. Its entry/task target is `<TaskID>/a0`; each later ordinary-call activation gets next zero-based canonical-decimal `N` as `<TaskID>/a<N>`. This is ActivationID. Each activation independently numbers successful channel creations and dynamic select encounters from zero as `<ActivationID>/c<N>` and `<ActivationID>/select<N>`; loop encounters increment. Replay reuses journaled IDs/counters.

The initial sender and sole receiver are `<ChannelID>/s0` and `<ChannelID>/r0`. Each committed sender copy in dynamic encounter order gets `<ChannelID>/s<N>`, starting at 1; direct original-sender use stays `s0`, and receiver moves retain `r0`.

Each channel numbers only successful send commits from zero as `<ChannelID>/m<N>`. A full blocked, cancelled, or nonchosen send has empty MessageID and does not consume a message commit index. Allocation is atomic with commit. Replay reuses the journaled MessageID and counter without allocating or advancing either.

## Messages, blocking, and cancellation

A committed `send(s, value)` snapshots one durable typed value, allocates MessageID, and appends atomically. A full queue suspends without commit, releases its active slot, and never reevaluates. Receive readies blocked sends in journaled block order; source position then TaskID break ties.

`receive(r)` removes the oldest ready message. Empty live queue suspends and releases an active slot. Cancellation removes a blocked send/receive, wakes once, and cannot enqueue, consume, duplicate, or lose a message. Completed records are immutable; replay never repeats them.

One SenderID is FIFO by commit. Journaled cross-sender readiness/commit sequence orders concurrent senders. Payload snapshots remain durable until consumed/owner termination and never expose endpoint identity as data.

## `select`

A select has only send, receive, or await cases and at most one final default. Receive/await may bind; send/default do not. Other, misplaced, duplicate-default, or incompatible arms fail type checking there. Case indexes are zero-based including default.

Each encounter gets SelectID and evaluates handles once in source order. Receive is ready for buffered data, send for live free capacity, await for terminal owned task. Default wins only if no other case is ready; without it the task suspends without polling until readiness, cancellation/end, or completion.

Choose the ready non-default case with earliest committed readiness sequence; a true tie uses lowest source position. Commit the chosen operation and atomically persist `{SelectID, ChosenCase, MessageID|TaskID}` before its branch: successful send allocates that MessageID only at commit, receive names its committed message, await names TaskID, default names neither. Replay consumes this record without racing, repeating, or allocating IDs.

## Deadlock

After suspension, no runnable task, queued admission/resume, or possible wake stops `DEADLOCK`. Origin is earliest journaled block, then source position and TaskID; detail lists the cycle. A full-buffer/await cycle renders `no runnable task or external wake; <sender> waits to send on full <channel> while <owner> awaits <sender>`. `await` propagation/cancellation applies; remaining waits wake once.
