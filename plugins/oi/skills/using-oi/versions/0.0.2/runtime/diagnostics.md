# Deterministic diagnostics

Defines deterministic failure construction and observation; no catch, retry, or control syntax.

## Record, phase, and category

Every immutable `failure` has exactly Category, Phase, Location, Detail, and ordered `Trace []text`; producers omit none, include no ambient host data, and propagation never rewrites it.

Phase order: `parse`, `module`, `type`, `effect mapping`, `input binding`, `execution admission`, `runtime`; failure bars later phases. Parse includes `IMPERATIVE_SEMANTIC_BLOCK`, `NESTED_SEMANTIC_EXPRESSION`. Module includes spec/runtime snapshot failures, version/package/import, source manifest/path/order/package/import, logical read, and source/graph/line budgets. Type includes missing semantic/derive target, named conversion, unsupported/unstable types, entry/call/handle, `UNBOUNDED_SEMANTIC_RESULT`, channel capacity/payload/escape, and duplicate receiver use.

Required `UNMAPPED_EFFECT` is effect mapping at the first call/launch needing absent authority or mapping. Only a direct captured effect is optional; absence fails runtime there. Caller argument failure is input binding. `CONTEXT_ISOLATION_UNAVAILABLE` is execution admission.

Pre-entry isolation=`CONTEXT_ISOLATION_UNAVAILABLE|execution admission|main token location|sealed context unavailable|[]`; after static, binding count=`INPUT_BINDING_MISMATCH|input binding|entry function-name location|expected E bindings; found A|[]`, E/A nats. Both yield that Failure in a Failed receipt, policy/reply absent, operations empty, target main/effects=0; TaskID/entry ActivationID=`root`/`root/a0`; other fields loaded; probes none.

Runtime includes contract/semantic ambiguity, `NONDETERMINISTIC_DERIVATION`, `DUPLICATE_KEY`, `MISSING_KEY`, task depth/owner/cancellation, deadlock, indeterminate effect, operation/effect failures, and nonempty `stop` category. Other categories retain their producing rule's phase.

## Location and choice

Source location is first offending token as normalized module-relative `path:line:column`, one-based UTF-8 scalars. Missing shard uses trigger; run-mode/global module uses target `1:1`; entry-global/admission uses entry. Propagation preserves origin.

Choose earlier phase; within a static phase choose UTF-8 path bytes, line, column. Runtime chooses committed journal sequence, operation source position, then TaskID bytes. Attached implicit join observes ascending launch SourceIndex, so lowest failing index wins independent of completion time. Replay consumes recorded choice.

Task depth/policy uses rejected `oi`; invalid owner uses `await` or qualified task call; cancellation uses cancelled task launch; effect failure uses call; contract failure uses boundary; duplicate collection uses later element; missing map key uses index `[`; derivation failure uses `derive`.

## Stop, capture, and outcome

`stop(category,detail)` evaluates texts left-to-right. Nonempty category creates runtime failure at `stop` and terminates; empty is `INVALID_STOP_CATEGORY`. It is not an effect.

`capture(expression)` evaluates once. Success is `outcome[T]{Ok:true, Value:value, Failure:none}`; failure is `outcome[T]{Ok:false, Value:none, Failure:exact}` and does not stop the capturing task/cancel siblings. Completed effects stay completed. Capture never edits, retries, weakens, or fabricates. Only `if o.Ok` narrows.

Only resolved std/user `Ask` journals Started, suspends an admitted child, releases its slot, and occupies no subagent; root excluded. Typed Answer journals Completed once and queues one resume; replay repeats neither. Mapped Respond/fs/process and immediate completions are synchronous.

## Trace and propagation

Trace starts empty at sealed entry/fresh child. Frames are `call@<location>`, `await@<location>`, `implicit-join@<location>`, `cancel@<location>`, `effect-mapping@<location>`, `input-binding@<location>`, or `execution-admission@<location>`. Append inner-to-outer only at the observing boundary. Frames never contain conversation, locals, tools, memory, authorities, mappings, journal data, expected values, or secrets.

Propagation preserves category, phase, origin, detail; only boundary frame appends. Terminal completion/failure journals once; repeated await/outcome reads it. Cancellation is recursive/idempotent and never replaces committed failure. Every recognized 0.0.2 terminal path projects the same exact failure into its receipt without exposing protected values.
