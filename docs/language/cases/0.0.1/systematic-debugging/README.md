# Systematic debugging case

## Source links

- [obra/superpowers systematic-debugging](https://github.com/obra/superpowers/blob/main/skills/systematic-debugging/SKILL.md)

This is a behavioral adaptation with attribution. It does not reproduce the source prose.

## Adapted observable contract

The Oi program makes reproduction, evidence collection, one hypothesis at a time, one candidate fix, and post-fix verification explicit typed
boundaries. Evidence gathering is bounded to three attempts. Missing reproduction or exhausted evidence terminates with a structured runtime
failure instead of guessing.

The observable unit is a `Session`, not a prose recommendation. Its final phase, complete transition sequence, ordered hypotheses, copied evidence,
attempt count, verification bit, and optional failure shape are typed. External work is divided into five concrete effects: reproduce the problem,
collect one observation, test one claim, apply one confirmed candidate, and verify that candidate against the original reproduction. This preserves
the source workflow's evidence-first discipline without importing its wording or tool-specific instructions.

An effect failure while reproducing is captured and converted into `REPRODUCTION_REQUIRED`; an unavailable observation consumes only its bounded
attempt and cannot fabricate evidence. A failed hypothesis returns control to evidence collection. A confirmed hypothesis permits exactly one
candidate application, and only a successful verification produces `Complete`.

## Required observations

- `Transitions` starts with `Reproduce`, reaches `Evidence` before `Hypothesis`, and reaches `Verify` before `Complete`.
- `ApplyFix` occurs only after `TestHypothesis` returns true with nonempty reproduction evidence.
- Every optional observation is evaluated once through `capture`; total observation attempts are at most three.
- Successful completion emits one typed `Reply(Session)`.
- A hypothesis copies the evidence available at its own test boundary, so later observations cannot rewrite its justification.
- `Attempts` is canonical one-based evidence-attempt count, while effect input remains zero-based bounded loop index.

## Forbidden observations

- A fix before reproduction or root-cause evidence.
- More than one speculative fix in a single hypothesis attempt.
- An unbounded retry, silent evidence failure, or success without the second verification run.
- Reusing a failed candidate as evidence for another fix, mutating a completed hypothesis, or reporting `Complete` after `VerifyFix=false`.
- Treating a captured effect failure as a successful observation or exposing ambient host state in the typed reply.

## Execution path

`main` calls `Debug`; `Debug` captures one reproduction, advances through ordinary typed phases, captures at most three observations, tests one
claim per observation, applies one confirmed candidate, verifies it once, and replies only with `Phase.Complete`. Insufficient evidence stops
before a fix is reported.

The success event order is `Reproduce → Evidence → Hypothesis → Verify → Complete`. On an unconfirmed claim or failed verification, control returns
to `Evidence` and increments the one loop counter. No loop contains `ApplyFix` unless the immediately preceding `TestHypothesis` returned true.
The returned transition list therefore gives the benchmark a direct, schedule-independent ordering witness.

The forbidden benchmark mutates that contract conceptually by observing a fix effect before the reproduction observation. `bench-oi` is expected
to report a nonempty forbidden hit even if the mutated target later returns a superficially successful session.

## Benchmark result

Status: `SOURCE_SPEC_AND_BENCH_EXPECTATION_ONLY_NOT_LIVE`; `OiHostAvailable=false`.

```text
PassingExpected={Status:"PASS", Observations:["evidence-before-fix","bounded-attempts","verified-complete"], ForbiddenHits:[], FailureCategory:none}
ForbiddenVariant={BenchmarkPassed:false, Difference:"forbidden-hit", ForbiddenHit:"speculative-fix-before-reproduction"}
```

These are structured `bench-oi` expectations, not claimed live results.

## Oi/source character count

`Get-Content -Raw main.oi` = `3728` decoded characters.

## Comparison Markdown character count

`Get-Content -Raw README.md` = `5115` decoded characters.

## Semantic limitations

The effect host decides how reproduction, observation, changes, and verification map to a real system. The case proves ordering, bounds, capture
behavior, and typed completion; it does not prove that an external hypothesis is scientifically correct. No Oi executable was available for live
execution.

The three-attempt limit is a case policy, not a universal debugging constant. The program models one problem and one candidate at a time;
architecture escalation, human discussion, repository edits, and regression-suite breadth remain host responsibilities. Effect contracts must be
mapped consistently for a meaningful run, and a host-side effect may still return misleading evidence. The case intentionally validates control
discipline rather than domain truth.
