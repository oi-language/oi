# Oi language corpus

Oi 0.0.2 is the current language snapshot. Its versioned corpus is rooted at [`plugins/oi/skills/using-oi/versions/0.0.2/corpus`](../../plugins/oi/skills/using-oi/versions/0.0.2/corpus/); the manifested suite sources own the exact case list and typed expectations. The explanatory inventory below cannot override those `.oi` sources or the normative [0.0.2 execution specification](../../plugins/oi/skills/using-oi/versions/0.0.2/execution.md).

The current catalog has exactly 60 unique cases: 28 Compile and 32 Runtime. Direct compilation matches all 60 targets (41 Pass and 19 Fail), suite compilation adds one Pass, and runtime matches all 32 cases (21 Pass and 11 RuntimeFail) plus two durable resume observations. The 32 runtime receipts contain 607 expected operation records and validate against the sealed source, inputs, mappings, authorities, policy, Reply, and terminal state.

Coverage includes exact nearest-`oi.mod` resolution, strict source-manifest ordering and closure, logical-read drift and budget failures, deterministic map/set construction and iteration, bounded ordinary judgments, typed deterministic `derive`, sealed input/effect admission, tasks/channels/lifecycle behavior, and protected receipt/replay limits. A receipt is evidence that an observation is consistent with a trusted sealed host completion; it is not a compiled artifact and cannot make a malicious host trustworthy.

Three repository-level cases distill the release boundaries:

- [`registry-analysis`](cases/0.0.2/registry-analysis/) applies one bounded typed alias judgment per caller-supplied import and one deterministic typed derivation for ordering;
- [`multi-root-bootstrap`](cases/0.0.2/multi-root-bootstrap/) derives deterministic membership and missing sets from explicit roots and registry state, without repository discovery;
- [`actual-invocation-proof`](cases/0.0.2/actual-invocation-proof/) demonstrates that a matching answer without sealed admission, an actual Reply, and a completed receipt is insufficient.

Oi 0.0.1 remains installed and byte-immutable with its released loading/runtime behavior. Its corpus is rooted at [`plugins/oi/skills/using-oi/versions/0.0.1/corpus`](../../plugins/oi/skills/using-oi/versions/0.0.1/corpus/): compilation remains 47/47 (30 Pass and 17 StaticFail), typed runtime remains 21/21 (16 Pass and 5 RuntimeFail), and three durable cases remain genuine STOP boundaries because the released concrete harness values do not exist. Plugin package 0.0.3 delivers both exact language snapshots without changing either corpus.

## Released 0.0.1 ordinary suite

The table preserves the original 42-case ordinary-suite index for the immutable earlier snapshot.

| Case ID | Target | Expected phase | Expected category | Exact location when fixed |
| --- | --- | --- | --- | --- |
| `types` | `valid/types` | pass | `none` | not fixed |
| `control` | `valid/control` | pass | `none` | not fixed |
| `semantic` | `valid/semantic` | pass | `none` | not fixed |
| `import` | `valid/import` | pass | `none` | not fixed |
| `entry-effect` | `valid/entry-effect` | pass | `none` | not fixed |
| `missing-semantic-type` | `invalid/missing-semantic-type` | static | `MISSING_SEMANTIC_TYPE` | not fixed |
| `imperative-semantic` | `invalid/imperative-semantic` | static | `IMPERATIVE_SEMANTIC_BLOCK` | not fixed |
| `nested-semantic` | `invalid/nested-semantic` | static | `NESTED_SEMANTIC_EXPRESSION` | not fixed |
| `implicit-named-conversion` | `invalid/implicit-named-conversion` | static | `IMPLICIT_NAMED_CONVERSION` | not fixed |
| `unsupported-map` | `invalid/unsupported-map` | static | `UNSUPPORTED_TYPE` | not fixed |
| `missing-entry` | `invalid/missing-entry` | static | `MISSING_ENTRY` | not fixed |
| `entry-result` | `invalid/entry-result` | static | `ENTRY_RESULT_FORBIDDEN` | not fixed |
| `entry-return-value` | `invalid/entry-return-value` | static | `ENTRY_RETURN_VALUE` | not fixed |
| `entry-call` | `invalid/entry-call` | static | `ENTRY_NOT_CALLABLE` | not fixed |
| `type-contract` | `runtime/type-contract` | runtime | `TYPE_CONTRACT_MISMATCH` | not fixed |
| `oi-continue` | `runtime/oi-continue` | pass | `none` | not fixed |
| `oi-discard` | `runtime/oi-discard` | pass | `none` | not fixed |
| `await-immediate` | `runtime/await-immediate` | pass | `none` | not fixed |
| `attached-failure-order` | `runtime/attached-failure-order` | runtime | `LOWER_SOURCE_FAILURE` | `main.oi:6:5` |
| `attached-cancellation` | `runtime/attached-cancellation` | runtime | `CANCEL_SOURCE_FAILURE` | `main.oi:4:5` |
| `context-isolation` | `runtime/context-isolation` | pass | `none` | not fixed |
| `capacity-pressure` | `runtime/capacity-pressure` | pass | `none` | not fixed |
| `task-policy` | `runtime/task-policy` | runtime | `TASK_DEPTH_LIMIT` | `main.oi:4:14` |
| `oi-anonymous` | `invalid/oi-anonymous` | static | `OI_REQUIRES_NAMED_FUNCTION` | `main.oi:6:5` |
| `oi-effect` | `invalid/oi-effect` | static | `OI_EFFECT_FORBIDDEN` | `main.oi:9:5` |
| `channel-progress` | `runtime/channel-progress` | pass | `none` | not fixed |
| `channel-command` | `runtime/channel-command` | pass | `none` | not fixed |
| `select-replay` | `runtime/select-replay` | pass | `none` | not fixed |
| `select-send-default` | `runtime/select-send-default` | pass | `none` | not fixed |
| `channel-deadlock` | `runtime/channel-deadlock` | runtime | `DEADLOCK` | `main.oi:5:5` |
| `channel-zero` | `invalid/channel-zero` | static | `INVALID_CHANNEL_CAPACITY` | `main.oi:4:27` |
| `channel-handle-payload` | `invalid/channel-handle-payload` | static | `RUNTIME_HANDLE_PAYLOAD` | `main.oi:4:21` |
| `multiple-receivers` | `invalid/multiple-receivers` | static | `RECEIVER_ALREADY_MOVED` | `main.oi:10:26` |
| `detach-notification` | `runtime/detach-notification` | pass | `none` | not fixed |
| `handoff` | `runtime/handoff` | pass | `none` | not fixed |
| `task-status-cancel` | `runtime/task-status-cancel` | pass | `none` | not fixed |
| `detach-endpoint` | `invalid/detach-endpoint` | static | `ENDPOINT_SCOPE_ESCAPE` | `main.oi:9:22` |
| `handoff-endpoint` | `invalid/handoff-endpoint` | static | `ENDPOINT_SCOPE_ESCAPE` | `main.oi:9:18` |
| `capture-fallback` | `runtime/capture-fallback` | pass | `none` | not fixed |
| `user-suspension` | `runtime/user-suspension` | pass | `none` | not fixed |
| `authority-intersection` | `runtime/authority-intersection` | pass | `none` | not fixed |
| `hidden-optional-effect` | `invalid/hidden-optional-effect` | static | `UNMAPPED_EFFECT` | `main.oi:14:12` |

Every invalid fixture contains exactly one intentional defect. The fixture `.oi` files, rather than this index, define the source behavior.

The typed runtime carrier fixes harness inputs, launch records, argument serialization, authorities, parent and child effect-mapping tables, controlled schedule events, reply/effect traces, context/trace/journal exclusions, completions, exact failure detail and canonical trace frames, selected failure, cancellations, policy, and journal-read count. Semantic results are scheduled as physical values, so replay does not depend on a new model generation.

`oi-continue` fixes parent summary work between launch and await. `oi-discard` maps both `ChildTrace` and `ParentTrace` in the parent but records only reachable `ChildTrace` in the child table, then observes the discarded child's effect and implicit join. `await-immediate` records its two immediate launches and concrete `Reply(text)` trace. `context-isolation` supplies `PARENT-ONLY-7F3A` only as a parent input and requires it absent from child arguments, context, output, trace, and journal.

`attached-failure-order` completes source index 1 before source index 0 and still selects the latter failure. `attached-cancellation` separately keeps source index 1 running when source index 0 fails, then requires recursive cancellation and a `TASK_CANCELLED` completion at the second launch location. `capacity-pressure` fixes maximum concurrency 1 while a child queues and awaits its grandchild: suspension releases the only slot, the grandchild completes, and the child is deterministically resumed; two runs must match. `task-policy` fixes root depth 0, inclusive maximum depth 2, maximum concurrency 2, deterministic queued admission order, rejected depth 3 at the recursive `oi`, and repeat count 2 with identical results.

The channel carrier fixes owner activation, capacity, payload shape, sender copies, the single moved receiver, message IDs, blocking events, select records, observations, and deadlock state. `channel-progress` records parent summary work before receiving typed `Progress`, then selects the child completion. `channel-command` launches with only `receiver[Command]`; `Command.Stop` reaches the child only through the channel. `select-replay` makes both receives ready in reverse case order, chooses the earlier journaled message, interrupts after persisting that choice, and reuses it on replay. `select-send-default` records `default` then `sent` without polling. `channel-deadlock` fills a capacity-one buffer while the sole receiver awaits the sender and stops `DEADLOCK` instead of hanging.

`channel-zero`, `channel-handle-payload`, and `multiple-receivers` each contain one defect: non-positive capacity, a runtime handle nested in payload type, and a second use after affine receiver move. Their fixed locations name the capacity expression, first forbidden handle type, and second receiver use respectively.

The independent lifecycle carrier composes the common runtime expectation without copying the preceding thirteen scenario functions. `detach-notification` fixes launch-to-registry ownership transfer, parent completion before one terminal host notification, and no retroactive parent failure. `handoff` fixes the attached join boundary, durable argument, authority intersection, fresh target activation, and a terminal old activation that never resumes. `task-status-cancel` observes `Running`, waits for one acknowledged cancellation record, then observes `Cancelled` while the parent completes normally.

`detach-endpoint` and `handoff-endpoint` each contain one scope-escape defect. Their exact locations identify the sender or receiver argument rejected before launch, join, registry transfer, or target-context creation.

The host-effect carrier distinguishes an optional direct boundary from a required helper call. `capture-fallback` first observes a mapped direct effect, then returns an `UNMAPPED_EFFECT` outcome for a direct optional effect without changing the successful value. `hidden-optional-effect` places the same missing effect behind a helper and therefore fails statically at the helper call. `authority-intersection` gives an attached child only `workspace.read`, records zero invocation of its optional `process.run`, and proves that the parent regains no authority from the child. `user-suspension` runs `std/user.Ask` inside an admitted child: suspension releases its active slot, a queued probe child completes, one typed answer wakes the asker once, and the root itself is excluded from active-child accounting.

Three additional durable-mode fixtures are routed outside the 42-case ordinary suite because their assertions require an interruption boundary and persisted journal. `resume-no-repeat` records child/channel/semantic/effect completion and proves that resume reuses them without a second invocation. `indeterminate-effect` interrupts after an effect start but before completion and stops `INDETERMINATE_EFFECT` with the stable operation identity. `resume-version-mismatch` changes a source or snapshot identity and stops before observing or invoking prior work.

Every `stop` case closes the manifest over `runtime/diagnostics.md`. That shard fixes phase, source location, tie-breaking, capture/outcome, stop, cancellation, propagation, and canonical trace behavior, including `implicit-join@` at the owning block's closing brace; it is loaded once in manifest order after `execution.md`.
