# Durable execution and resume

Defines 0.0.2 durable/resume persistence and protected journal; adds no syntax/authority.

## Identity

Before entry a durable run commits immutable:

`RunIdentity {OiVersion, ManifestDigest, SourceDigest, InputsDigest, PolicyDigest, Authorities}`

`OiVersion` is exact loaded identity. `ManifestDigest` covers ordered source directives/load closure; `SourceDigest` every verified project/std/spec/runtime artifact identity in load order. Other digests cover typed input/policy/mapping identities, never credentials. SHA-256 uses length-prefixed canonical bytes; authorities are the narrowed UTF-8-byte-ordered set.

Resume recomputes declared fields in order before work. First mismatch stops runtime `RESUME_VERSION_MISMATCH` at target `1:1`, Detail `run identity mismatch: <Field>`, before entry/effect/journal consumption.

## Journal and OperationID

Journal=immutable append-only:

`Event {Sequence, Kind, SourceLocation, OperationID, InputDigest, State, Result}`

Sequence is contiguous from zero. State=`Started | Completed | Failed | Indeterminate | Cancelled`; Result is none until a durable typed result, failure, ID, or outcome is known. Kinds include allocation, semantic, derive, iteration, effect, task lifecycle, await/join, detach/notification/status/cancel, channel/message/send/receive/select, user suspension, handoff, Reply. Mapping attempts use a separate admission log; receipt terminals are not operations.

Each ActivationID counter starts zero. Deterministic statement/operand encounter gives a boundary without canonical ID `<ActivationID>/o<N>`: append completed allocation with location/digest/ID before `Started`, then increment. Each dynamic collection loop allocates at `for`; Iteration completes with the full protected typed immutable sequence before its body; incomplete setup is safe deterministic work under that ID.

TaskLaunch, ChannelCreate, MessageCommit, and Select use TaskID/ChannelID/MessageID/SelectID without allocation; only own states reuse them. Allocated `oN` has one Allocation then one fixed boundary Kind. TaskCompletion and DetachNotification allocate owner/registry `oN`, record Started then one terminal, and carry TaskID in input/result. Blocked send/receive without persisted ID uses `oN`; its MessageCommit uses MessageID. Every other boundary owns a persisted ID or allocates `oN`.

States share their operation ID; block/wake/re-observe allocates nothing. Replay restores completed Iteration without re-enumeration, reuses IDs, restores counters after greatest N, and never advances direct IDs. Handles serialize only canonical IDs, never objects, context, conversation, locals, trace, tool output, memory, buffers, authority tokens, or host bindings.

## Checkpoints and terminal states

Checkpoint semantic/derive; effect start/terminal; task launch/completion/await/join; detach transfer/notification/status/cancel; channel create/send/receive/select; user suspension; handoff; Reply. After `oN` allocation append `Started` before nondeterministic/visible work; atomic identity creation is already completed. Append exactly one terminal `Completed`, `Failed`, `Indeterminate`, or `Cancelled` before its outcome is visible. Records never change. Root entry completion is only the receipt terminal and allocates no operation.

`Completed` has a full protected typed result and public type/digest projection. `Failed` has exact failure. `Indeterminate` means no trustworthy outcome can be established; `Cancelled` is explicit cancellation. Known failures never become indeterminate; none completes without a full typed boundary value.

Last checkpoint=longest durable contiguous prefix; unrecorded completion is unexposed. Child admission requires completed launch; message delivery requires completed commit/send/receive; handoff requires completed transfer; receipt requires every required terminal. Recovery continues only safe uncommitted internals under their ID.

## Resume

After identity equality, validate event order/location/ID/input digests, then rebuild handles, queues, ownership, mappings, counters, and continuations from checkpoint. Never consult conversation, process memory, old host objects, or unverified source. Authority remains exactly RunIdentity authority.

Completed supplies Result: never regenerate judgment/derive, reinvoke effect/entry, relaunch child, repeat await/join, retransfer/renotify detach, reissue status/cancel, redeliver message, reselect, repeat handoff/Reply, or reconstruct receipt from expectations. Failed/Cancelled restores its terminal. Safe internals may continue only where no outcome was exposed.

External effect `Started` without trustworthy terminal becomes `Indeterminate` on the same ID and stops runtime `INDETERMINATE_EFFECT` at its original callee, Detail `effect <OperationID> started without completion`. Never retry, invent, or continue; re-resume returns it without another call. Journal order replaces clocks; observable counts stay one.
