# Document coauthoring case

## Source links

- [anthropics/skills doc-coauthoring](https://github.com/anthropics/skills/blob/main/skills/doc-coauthoring/SKILL.md)

This is a compact behavioral adaptation with attribution, not a copy of the source workflow text.

## Adapted observable contract

The case gathers audience and purpose through typed `user.Ask` calls in an attached child, checkpoints typed document state between stages, and
reader-tests the draft in a fresh `oi` context. Reader feedback transfers clarification ownership through typed terminal `handoff`; the new
activation completes through the same concrete `Reply(DocumentState)` boundary.

Only explicit `DocumentState` crosses a checkpoint, child boundary, or handoff. Requirements, draft, feedback, and stage are therefore inspectable
without granting the reader child access to authoring history. The clarification activation owns the fixed feedback path and is solely responsible
for its final reply.

## Required observations

- Requirements contain an explicit audience and intended reader outcome before drafting.
- Context, draft, and reader-test states cross the declared `Checkpoint` effect.
- `ReaderTest` is launched with only typed `DocumentState`, not the authoring conversation.
- Nonempty reader feedback leads to `handoff Clarify(state)` and one final typed reply.

## Forbidden observations

- Drafting before audience and purpose are present.
- Treating the author's ambient conversation as reader-test input.
- Declaring `Done` without a fresh reader test, or resuming the pre-handoff activation.

## Execution path

`Coauthor` awaits a fresh context-gathering child, checkpoints context and draft, awaits a fresh reader-test child, then hands the durable state to
`Clarify`. `Clarify` awaits one typed clarification child, checkpoints `Done`, and replies. The original activation terminates at handoff and never
returns a state to `main`.

The reader test receives the exact post-draft checkpoint. Its one-element feedback result deliberately forces the attributed clarification path in the nominal fixture, making terminal handoff observable rather than merely declared.

## Benchmark result

Status: `SOURCE_SPEC_AND_BENCH_EXPECTATION_ONLY_NOT_LIVE`; `OiHostAvailable=false`.

```text
PassingExpected={Status:"PASS", Observations:["audience-purpose","checkpointed-stages","fresh-reader-test","typed-handoff"], ForbiddenHits:[], FailureCategory:none}
ForbiddenVariant={BenchmarkPassed:false, Difference:"forbidden-hit", ForbiddenHit:"done-without-reader-test"}
```

These are structured `bench-oi` expectations, not claimed live results.

## Oi/source character count

`Get-Content -Raw main.oi` = `2322` decoded characters.

## Comparison Markdown character count

`Get-Content -Raw README.md` = `3368` decoded characters.

## Semantic limitations

The checkpoint and user effect mappings are supplied by the host. Reader quality and clarification content remain semantic judgments; the case
proves typed context isolation, stage order, suspension points, handoff terminality, and completion shape. No Oi executable was available for live
execution.

This compact case does not model section-by-section editing, templates, document storage formats, or arbitrary feedback loops. It uses one audience answer, one purpose answer, one reader observation, and one clarification.
