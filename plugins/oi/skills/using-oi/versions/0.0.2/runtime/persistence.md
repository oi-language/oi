# Durable execution and resume

Defines 0.0.2 durable/resume persistence and protected journal representation; adds no syntax or authority.

## Identity

Before entry, a durable run commits immutable:

`RunIdentity {OiVersion, ManifestDigest, SourceDigest, InputsDigest, PolicyDigest, Authorities}`

`OiVersion` is exact loaded identity. `ManifestDigest` covers ordered source directives/load closure. `SourceDigest` covers every verified project/std/spec/runtime artifact identity in load order. Other digests cover typed input values and policy/mapping identities, never credentials. SHA-256 inputs are length-prefixed canonical bytes; authorities are the narrowed UTF-8-byte-ordered set.

Resume recomputes fields in declaration order before work. First mismatch stops runtime `RESUME_VERSION_MISMATCH` at target `1:1`, Detail `run identity mismatch: <Field>`, before entry/effect/journal consumption.

## Journal and OperationID

Journal is an immutable append-only sequence:

`Event {Sequence, Kind, SourceLocation, OperationID, InputDigest, State, Result}`

Sequence is contiguous from zero. State is `Started | Completed | Failed | Indeterminate | Cancelled`; Result is none until a durable typed result, failure, ID, or outcome is known. Kinds include allocation, semantic, derive, effect, task lifecycle, await/join, detach/notification/status/cancel, channel/message/send/receive/select, user suspension, handoff, and Reply. Mapping attempts use the separate admission attempt log; receipt terminal fields are not operations.

Each ActivationID has an operation counter from zero. In deterministic statement/operand encounter order, a boundary without a canonical ID gets `<ActivationID>/o<N>`: before `Started`, append completed allocation with its location/digest/ID, then increment. Loops allocate per encounter.

TaskLaunch, ChannelCreate, MessageCommit, and SelectRecord create their canonical TaskID/ChannelID/MessageID/SelectID atomically as OperationID, with no prior allocation. Later events reuse it. A blocked send/receive without MessageID keeps its `oN`; later message commit has MessageID. Other boundaries reuse a persisted ID or allocate `oN`. Semantic, derive, effect, await, join, detach, handoff, and Reply use `oN`.

One operation's states share its ID. Block/wake/re-observe allocates nothing. Replay reuses IDs, restores counters after greatest N, and never advances direct-ID boundaries. Handles serialize only canonical IDs, never objects, context, conversation, locals, trace, tool output, memory, buffers, authority tokens, or host bindings.

## Checkpoints and terminal states

Checkpoint every semantic/derive; effect start/terminal; task launch/completion/await/join; detach transfer/notification/status/cancel; channel create/send/receive/select; user suspension; handoff; and Reply. After `oN` allocation and before nondeterministic/visible work append `Started`; atomic identity creation is already completed. Append exactly one terminal `Completed`, `Failed`, `Indeterminate`, or `Cancelled` before its outcome is visible. Records never change. Receipt terminal fields follow checkpoints without allocating an operation.

`Completed` includes a full protected typed result and public type/digest projection. `Failed` contains exact failure. `Indeterminate` applies only when a trustworthy outcome cannot be established. `Cancelled` is explicit cancellation. Known failures never become indeterminate; none is completed without a full typed boundary value.

Last checkpoint is the longest durable contiguous prefix; unrecorded completion was never exposed. Child admission follows completed launch, message delivery follows completed commit/send/receive, handoff follows transfer, and receipt follows every required terminal record. Recovery continues only safe uncommitted internals under their existing ID.

## Resume

After identity equality, validate event order/location/ID/input digests, then rebuild handles, queues, ownership, mappings, counters, and continuations from checkpoint. Never consult conversation, process memory, old host objects, or unverified source. Authority remains exactly RunIdentity authority.

Completed supplies Result: never regenerate judgment/derive, reinvoke effect/entry, relaunch child, repeat await/join, retransfer/renotify detach, reissue status/cancel, redeliver message, reselect, repeat handoff/Reply, or reconstruct receipt from expectations. Failed/Cancelled restores its terminal. Safe internals may continue only where no outcome was exposed.

External effect `Started` without trustworthy terminal becomes `Indeterminate` on the same ID and stops runtime `INDETERMINATE_EFFECT` at its original callee, Detail `effect <OperationID> started without completion`. Never retry, invent, or continue; re-resume returns it without another call. Journal order replaces clocks; observable counts stay one.
