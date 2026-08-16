# Oi 0.0.1 design rationale

This document explains the stable design choices behind Oi 0.0.1. Normative behavior belongs to the versioned [`execution.md`](../../plugins/oi/skills/using-oi/versions/0.0.1/execution.md) and its manifest-selected runtime shards; this rationale cannot override them.

## Design principles

Oi is an independent language for Agent Skills. Its purpose is to make behavior auditable at the boundaries where Agent workflows otherwise become ambiguous:

- types describe values and semantic contracts;
- ordinary syntax owns order, branching, iteration, effects, dispatch, suspension, stop, and handoff;
- every external effect names its authority and typed boundary;
- task arguments, channel payloads, and caller inputs are explicit;
- failures have a stable phase, source location, detail, and propagation trace;
- one exact language snapshot gives one deterministic interpretation.

The repository is 0% scripts and 100% Skill. `.oi` owns executable product behavior; `SKILL.md` loads and routes it. Markdown specifications define semantics but do not hide tool algorithms.

## Why Oi has typed values

Agent tools need more than a line-oriented text envelope. A formatter needs token ranges; a compiler needs declarations and source positions; a debugger needs task, channel, effect, and completion identities; durable execution needs structured journal records. Encoding these as private text protocols would make every consumer parse the same data differently.

Oi therefore has exact primitive values, slices, optionals, structs, enums, named types, tasks, outcomes, channels, endpoints, and failures. Named types are distinct even when their underlying shape matches. A named type may also carry one semantic contract, checked whenever a value crosses the typed boundary.

Natural-language judgment remains deliberately narrow. A semantic expression produces or judges one contextually typed value. It cannot conceal sequencing, a branch, a loop, retry, an effect, dispatch, handoff, or stop. This preserves the Agent's useful judgment without turning prose into an invisible control plane.

Aggregate construction is a distinct derivation. `derive` requires an explicit handle-free target and uses only interpolated typed snapshots for a unique structural transformation; ambient context, policy choice, effects, control, and runtime handles are rejected rather than hidden in prose.

## Why `oi` modifies a call

Subagent work is still a call to a named, typed ordinary function. Prefixing that call with `oi` changes only its execution mode: `oi Review(change)` launches an attached task, while `await oi Review(change)` launches and waits. Optional assignment exposes the resulting `task[T]` handle.

This shape keeps the callee signature, argument evaluation, result type, authority demand, and source location intact. It also makes asynchronous intent visible at the call site without a registry API or ambient dispatch object.

The design follows a lesson visible in the [LangChain multi-agent overview](https://docs.langchain.com/oss/python/langchain/multi-agent), its [subagent pattern](https://docs.langchain.com/oss/python/langchain/multi-agent/subagents), and [OpenAI Agents SDK orchestration](https://openai.github.io/openai-agents-python/multi_agent/): bounded specialist work and control-transfer handoffs are different relationships. Oi expresses them with different constructs rather than one overloaded agent call.

## Tasks, channels, detach, and handoff

Tasks own completion. Attached tasks join at their lexical owner; source order selects among concurrent failures, and remaining siblings are cancelled. Concurrency limits use a deterministic admission queue, and suspended child work releases its active slot so nested progress cannot deadlock merely because a parent is waiting.

Channels own typed communication. They carry progress, commands, or other durable values independently of task completion. Senders copy; receivers are affine; endpoint scope is statically bounded. `select` records the committed choice before its branch executes so resume cannot choose a different ready arm.

Detach and handoff have different lifecycle meanings. Detach transfers one launched task to a host registry before the parent can leave it unowned. Handoff joins ordinary attached children, validates durable arguments and authority intersection, starts a fresh target activation, then terminates the old activation permanently. This explicit split is consistent with the practical distinction between manager-owned specialists and state/control transfer described by [LangChain handoffs](https://docs.langchain.com/oss/python/langchain/multi-agent/handoffs) and [OpenAI Agents SDK handoffs](https://openai.github.io/openai-agents-python/handoffs/).

## Context isolation and authority

An Oi child receives only typed arguments, mapped effect results, and the authority intersection permitted by its parent and required by its reachable graph. It does not inherit an undeclared conversation transcript, hidden parent inputs, or mutable scratch state. Channel endpoints cross only through their typed argument positions.

This is a language boundary, not a prompt convention. It targets the same engineering pressure described by [LangChain context engineering](https://docs.langchain.com/oss/python/deepagents/context-engineering): specialist work should not require copying every intermediate tool call into the manager's context.

Effects are atomic typed declarations with a nonempty authority set and semantic contract. Required reachable effects must map before entry. Only a syntactically direct `capture(Effect(...))` is optional; placing the same effect behind a helper cannot weaken static authority checking. Child authority never expands, including across `oi`, detach, and handoff.

Guard checks belong at the boundary they protect. Oi applies input contracts before entry and named/effect contracts at crossings, analogous to the boundary distinction in [OpenAI Agents SDK guardrails](https://openai.github.io/openai-agents-python/guardrails/), while preserving Oi's own categories and phase order.

## Durable journal

Durable execution records stable activation and operation identities, boundary allocation, start, completion, channel commits, select choices, suspension, wake, cancellation, and terminal state. Resume verifies the source, module, specification, runtime-shard, standard-library, and effect-mapping identities before observing prior work.

A completed operation is never invoked again. A started effect without a durable completion is indeterminate and stops rather than guessing whether the external action occurred. Recorded semantic results replay as physical typed values, so resume does not ask the model to regenerate a potentially different judgment.

This is intentionally stricter than generic checkpoint recovery. LangGraph's [durable execution and persistence guidance](https://docs.langchain.com/oss/python/langgraph/durable-execution) demonstrates why completed work must survive a later failure; Oi additionally specifies which external boundaries require start/completion pairing and which identity makes replay exact.

## One base file, feature-gated detail

Each version has one base-language authority: `using-oi/versions/<version>/execution.md`. The file is loaded completely and exactly once. Its compact prefix defines snapshot identity, deterministic load order, the runtime/standard-library manifest, failure behavior, and character budgets. Its continuous body defines the complete grammar, static semantics, and shallow execution semantics.

Detailed dynamics live in small runtime shards selected only by parsed constructs, resolved standard calls, or run mode. Trigger sets union and declared dependencies close transitively; each required file loads at most once in manifest order. Standard packages load only through reachable imports. Metadata-only requests may stop after the one base read without parsing target source.

Oi 0.0.1 deliberately has no `core.md`, `syntax.md`, `types.md`, `functions.md`, or eager bundle of base shards. That keeps first-load cost predictable while retaining completeness in one authority. Runtime shards are not alternate specifications: contradiction with the base file invalidates the snapshot.

Host plugin packaging version is a separate axis from language snapshot identity. Marketplace and `plugin.json` versions exist so hosts can install and update the plugin; `oi.mod` still selects exactly one immutable snapshot under `using-oi/versions/`. A later plugin may bundle older snapshots. Matching numbers are coincidental.

## Deliberate exclusions

Oi 0.0.1 excludes a package manager, binary compiler, VM, implicit global input, entry return channel, ambient agent registry, hidden retry, and permissive source reinterpretation. It does not infer unavailable effects, silently widen authority, or resume across a changed snapshot.

The toolchain uses the language's structured values and effects rather than host scripts. `compile-oi` validates but emits no binary artifact; `bench-oi` measures conformance rather than speed; `convert-oi` accepts only its closed observable profile; `upgrade-oi` cannot invent an uninstalled version.

## Completeness cases

Four attributed adaptations exercise design pressures that the core corpus alone does not communicate as clearly:

- [systematic debugging](cases/0.0.1/systematic-debugging/) checks evidence-first phase order and stop boundaries;
- [document coauthoring](cases/0.0.1/document-coauthoring/) checks semantic types, iterative user effects, and explicit revision state;
- [parallel review](cases/0.0.1/parallel-review/) checks attached tasks, channels, source-order results, and context isolation;
- [optimization audit](cases/0.0.1/optimization-audit/) checks typed measurements, forbidden observations, and report aggregation.

These cases preserve attributed observable behavior without copying third-party Skill prose. The versioned [corpus](corpus.md) remains the authoritative collection of positive, static-invalid, and runtime fixtures.
