# Durable execution and resume

Defines `durable`/`resume` persistence; adds no syntax or authority.

## Identity

A durable run commits one immutable record before entry:

`RunIdentity {OiVersion, SourceDigest, InputsDigest, PolicyDigest, Authorities}`

`OiVersion` is the loaded identity. Digests are lowercase SHA-256 over length-prefixed canonical bytes: `SourceDigest` covers reachable project/std/spec files in load order; `InputsDigest` typed inputs; `PolicyDigest` policy/mapping identities, never credentials. `Authorities` is the narrowed UTF-8-byte-ordered set. Fields are immutable and byte-equal.

Resume recomputes fields before work. First mismatch in order above stops runtime `RESUME_VERSION_MISMATCH` at target `1:1`, Detail `run identity mismatch: <Field>`, before entry/effects or journal consumption.

## Journal and OperationID

Journal is an immutable append-only sequence of:

`Event {Sequence, Kind, SourceLocation, OperationID, InputDigest, State, Result}`

State is exactly `Started | Completed | Indeterminate | Cancelled`; Sequence is contiguous from `0`. Kind is `OperationAllocation`, `Semantic`, `Effect`, `TaskLaunch`, `TaskCompletion`, `Await`, `Join`, `Detach`, `TaskStatus`, `TaskCancel`, `Notification`, `ChannelCreate`, `MessageCommit`, `Send`, `Receive`, `SelectRecord`, `Select`, `UserSuspend`, `Handoff`, or `Terminal`. SourceLocation is canonical token location; InputDigest covers typed inputs; Result is `none` until its durable replay value, failure, ID, or outcome is known.

Each ActivationID has an operation counter from `0`. On deterministic statement/operand-order encounter of a boundary lacking canonical ID, choose `<ActivationID>/o<N>`. Before `Started`, append durable `OperationAllocation`/`Completed` with its location/digest and the ID as OperationID and Result, then advance the counter. Loops allocate per encounter; only these allocations count.

`TaskLaunch`, `ChannelCreate`, `MessageCommit`, and `SelectRecord` are identity-creation boundaries. Their first event atomically persists its TaskID, ChannelID, MessageID, or SelectID allocation and uses it as OperationID, with no prior `OperationAllocation`, `Started`, or `oN`; later events reuse it. Other boundaries direct-use an ID only if previously persisted, consuming no `oN`; otherwise allocate `oN`. A blocked send/receive lacking MessageID keeps its `oN`; a later MessageCommit creates MessageID directly while the blocked operation keeps `oN`. `Semantic`, `Effect`, `Await`, `Join`, `UserSuspend`, `Handoff`, `Detach`, and `Terminal` always use `oN`.

One boundary's states share its OperationID. Block/wake/cancel/re-observe allocate nothing. Replay reuses journaled IDs, restores each counter after its greatest `N`, and neither reallocates encounters nor advances for direct IDs.

Handles serialize only TaskID, ChannelID, SenderID, or ReceiverID, never objects, context, conversation, locals, trace, tool output, memory, buffers, authority tokens, or host bindings. Resume rebuilds only from IDs/completed events.

## Checkpoints

Checkpoint every semantic; effect start/completion; task launch/completion/await/join; detach transfer/notification/status/cancel; channel create/send/receive/select; user suspension; handoff; and terminal state. After any `oN` allocation and before nondeterministic/visible work append `Started`; the four atomic creation events above need no preceding event. Before other outcomes are visible append `Completed` with same ID/Result. Cancellation appends `Cancelled`; records never change.

Last checkpoint is the longest durable contiguous prefix; unrecorded completion was never exposed. Child admission follows completed TaskLaunch, message commit/delivery completed Send/Receive, and handoff completed transfer. Recovery continues safe uncommitted internals under their ID, never fabricating results.

## Resume

After identity equality, validate event/order/input IDs, then rebuild handles, queues, ownership, mappings, counters, and continuations from the checkpoint. Never consult conversation, process memory, or old host objects. Authority equals `RunIdentity.Authorities` and cannot expand.

Match Kind, location, OperationID, and input digest. `Completed` supplies Result: never regenerate semantic, reinvoke effect, relaunch child, repeat await/join, retransfer/renotify detach, reissue status/cancel, redeliver message, reselect, repeat handoff, or reinvoke entry. `Cancelled` restores cancellation; safe internals continue with recorded ID under their shard.

Effect `Started` without `Completed` is unknowable. Append `Indeterminate` with its same canonical OperationID; stop runtime `INDETERMINATE_EFFECT` at the original callee, Detail exactly `effect <OperationID> started without completion`. Never retry/invent/continue; re-resume returns it without another call.

Journal order replaces clocks; completed effect, child, semantic, and delivery counts stay one across resumes.
