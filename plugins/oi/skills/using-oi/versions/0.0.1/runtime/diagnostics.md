# Deterministic diagnostics

Deterministic failure construction/observation; no catch, retry, or control syntax.

## Record, category, and phase

Every immutable `failure` has exactly `Category`, `Phase`, `Location`, `Detail`, and ordered `Trace []text`; producers omit none, include no ambient host data, and propagation never rewrites it.

Phase order is `parse`, `module`, `type`, `effect mapping`, `input binding`, `runtime`; failure bars later phases.
`MISSING_SPEC_SHARD`, `MISSING_RUNTIME_SHARD`, `INVALID_SPEC_SNAPSHOT`, version, package, and import categories are module.
`IMPERATIVE_SEMANTIC_BLOCK` and `NESTED_SEMANTIC_EXPRESSION` are parse.

`MISSING_SEMANTIC_TYPE`, `IMPLICIT_NAMED_CONVERSION`, `UNSUPPORTED_TYPE`, `MISSING_ENTRY`, `ENTRY_RESULT_FORBIDDEN`,
`ENTRY_RETURN_VALUE`, `ENTRY_NOT_CALLABLE`, `OI_REQUIRES_NAMED_FUNCTION`, `OI_EFFECT_FORBIDDEN`, and other call/handle
diagnostics are type.

Channel `INVALID_CHANNEL_CAPACITY`, `RUNTIME_HANDLE_PAYLOAD`, `RECEIVER_ALREADY_MOVED`, and `ENDPOINT_SCOPE_ESCAPE` are type;
`DEADLOCK` is runtime. Required `UNMAPPED_EFFECT` is effect mapping at the first call or launch needing absent authority or mapping.
Only a direct captured effect call is optional: absence fails at runtime there and capture observes it.
Hiding that effect in a helper remains required and static. Caller argument binding is input binding.

Runtime includes `TYPE_CONTRACT_MISMATCH`, `AMBIGUOUS_SEMANTIC_VALUE`, `AMBIGUOUS_SEMANTIC_MATCH`, `TASK_DEPTH_LIMIT`,
`INVALID_TASK_OWNER`, `TASK_CANCELLED`, operation failures, and every nonempty `stop` category such as `DETACHED_FAILURE`.
Any other category retains its producing rule's phase.

## Location and choice

A source diagnostic uses its first offending token as `module-relative-path:line:column`, one-based by UTF-8 scalar.
A missing triggered shard uses its trigger; run-mode-only shard and global module failures use target `1:1`;
entry-global failures use the entry declaration. Propagation preserves origin location.

Choose earlier phase first. Within one static phase choose normalized UTF-8 path bytes, line, then column.
Runtime operations choose committed journal sequence, then operation source position.
Attached implicit join observes ascending launch `SourceIndex`, so its lowest failing index wins even if a higher index committed earlier.
Remaining ties use TaskID UTF-8 bytes. Replay consumes the recorded choice without racing.

`TASK_DEPTH_LIMIT` and launch-policy failures use rejected `oi`; `INVALID_TASK_OWNER` uses `await` or the resolved
`task.Status`/`task.Cancel` qualified call.
`TASK_CANCELLED` uses the cancelled task's original launch `oi` and Detail exactly `cancelled by <TaskID>` naming the requester.
Effect failures use the effect call. Contract failures use the checking boundary.

## Stop, capture, and outcome

`stop(category, detail)` evaluates both text arguments left-to-right.
A nonempty category creates a runtime failure at `stop` with exact detail and current trace, then terminates that task.
Empty category stops `INVALID_STOP_CATEGORY` there. `stop` is not an effect.

`capture(expression)` evaluates once. Success is `outcome[T]{Ok:true, Value:value, Failure:none}`.
Failure is `outcome[T]{Ok:false, Value:none, Failure:the exact failure}` and does not stop the capturing task or cancel siblings.
Completed effects stay completed. Capture never edits, retries, weakens, or fabricates a result.
Only `if o.Ok` performs implicit outcome narrowing.

Only resolved `std/user.Ask` journals `Started`, suspends an admitted child once, releases its slot, and occupies no subagent; root is excluded. Its typed `Answer` journals `Completed` once and queues one resume; replay repeats neither Ask nor question. Mapped `user.Respond`, `fs.*`, `process.*`, and any immediate completion are synchronous: no suspend, release, queue, or resume.

## Trace and propagation

Trace starts empty at entry or fresh child. Frames are exactly `call@<location>`, `await@<location>`, `implicit-join@<location>`,
`cancel@<location>`, `effect-mapping@<location>`, or `input-binding@<location>`.
`call` uses the callee QualifiedName's first token; `await` its `await` token; implicit join the owning function block's closing `}` token.
`cancel` uses the requesting `await`, `stop`, `task.Cancel` call, or closing-brace token; effect mapping uses the effect callee token;
input binding uses the entry declaration token. Locations use the module-relative one-based line and UTF-8 scalar column form above.
Append inner-to-outer; keep child trace and append only the observing boundary.
Frames never contain conversation, locals, tool output, memory, authorities, mappings, journal data, or host secrets.

Propagation preserves category, phase, origin location, and detail; only the boundary frame is appended.
Terminal completion journals once. Repeated await or outcome inspection reads that record.
Cancellation is recursive and idempotent and never replaces a committed failure.
