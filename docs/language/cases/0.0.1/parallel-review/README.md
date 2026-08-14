# Parallel review case

## Source links

- [obra/superpowers dispatching-parallel-agents](https://github.com/obra/superpowers/blob/main/skills/dispatching-parallel-agents/SKILL.md)
- [obra/superpowers subagent-driven-development](https://github.com/obra/superpowers/blob/main/skills/subagent-driven-development/SKILL.md)

This case adapts isolated, focused parallel work and reviewed integration as observable Oi behavior; it does not reproduce either source document.

## Adapted observable contract

The parent launches exactly one named child for each independent source area, passes only `change`, `area`, and a copied typed sender, and retains
the sole receiver. A capacity-three MPSC channel bounds completion traffic. The parent can prepare its summary while children run and always
emits findings in declared area order rather than arrival order.

Isolation is expressed by the child signature: no child receives another area's evidence, the parent's summary, a receiver, or ambient session
state. Integration is expressed by three parent-owned slots plus presence bits. Completion order can change the sequence of receives, but the
final constructor reads the slots in the declared `Area` order. This adapts focused parallel dispatch and central review/integration without
copying either upstream workflow.

## Required observations

- Three child launches occur without task-handle assignment and with isolated typed inputs.
- Each child sends exactly one `Finding` for its assigned area through the same channel.
- The parent receives exactly three values and rejects duplicate or missing areas.
- Output order is `Correctness`, `Security`, `Maintainability` for every completion schedule.
- The parent is the only consumer and the only component that can reject duplicate or missing area results.
- Summary preparation occurs after all launches and before the first receive, demonstrating useful coordinator work while children are runnable.

## Forbidden observations

- Ambient parent conversation, mutable shared findings, or one child reviewing multiple areas.
- More than three channel messages or an unbounded collector.
- Returning findings in receive/arrival order.

## Execution path

`Review` creates one bounded channel, dispatches three independent `ReviewPart` children, prepares typed summary context, then performs exactly
three receives. A switch stores each finding by area; final construction uses source-area order. Duplicate or missing areas stop with structured
categories before reply.

The channel's capacity equals the exact producer count, so no producer needs an unbounded queue. Sender values are copied to children while the
affine receiver remains local. The three attached children are joined by their messages and later scope completion; their handles are
intentionally discarded because result transport is solely typed MPSC.

## Benchmark result

Status: `SOURCE_SPEC_AND_BENCH_EXPECTATION_ONLY_NOT_LIVE`; `OiHostAvailable=false`.

```text
PassingExpected={Status:"PASS", Observations:["three-isolated-launches","bounded-mpsc","source-area-order"], ForbiddenHits:[], FailureCategory:none}
ForbiddenVariant={BenchmarkPassed:false, Difference:"forbidden-hit", ForbiddenHit:"arrival-order-output"}
```

These are structured `bench-oi` expectations, not claimed live results.

## Oi/source character count

`Get-Content -Raw main.oi` = `2601` decoded characters.

## Comparison Markdown character count

`Get-Content -Raw README.md` = `4139` decoded characters.

## Semantic limitations

The case fixes three independent areas and one finding per area; it is not a general scheduler or dynamic work queue. Child evidence quality
remains a semantic judgment. Runtime isolation and schedule independence follow the Oi task/channel shards. No Oi executable was available for
live execution.

The model assumes the areas are independent and that one finding summarizes each area. Related investigations, multiple findings per area,
cancellation policy, and reviewer disagreement require a different bounded protocol. The benchmark checks ordering and forbidden context
sharing, not wall-clock speedup.
