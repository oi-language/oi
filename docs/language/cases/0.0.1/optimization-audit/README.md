# Optimization audit case

## Source links

- [vercel-labs/agent-skills vercel-optimize](https://github.com/vercel-labs/agent-skills/blob/main/skills/vercel-optimize/SKILL.md)

This is an observability-first behavioral adaptation with attribution. It does not copy the source pipeline or platform-specific prose.

## Adapted observable contract

The Oi program observes a typed nonempty baseline before choosing one metric-backed candidate, applies exactly one candidate change, and performs
one independent verification measurement. It pairs stable metric names and targets, compares integer before/after/target values, and reports
typed diagnostics instead of claiming unmeasured improvement.

The adapted boundary is platform-neutral. An `Observation` carries a metric name, measured integer value, and target. The host supplies an ordered
baseline and a later ordered verification set; the program refuses count, name, or target drift before comparing values. This keeps the
recommendation candidate-bound and makes the evidence used for the decision available in the returned `Metric` records.

`ApplyCandidate` is deliberately not captured and occurs once. A host failure stops the audit rather than silently selecting another
optimization. The only loop pairs already completed observations and cannot invoke measurement or mutation effects, so it cannot become a
hidden retry.

## Required observations

- `Measure(target, Baseline)` occurs before `ApplyCandidate`.
- Exactly one candidate is selected from typed baseline evidence.
- `Measure(target, Verify)` is a distinct second observation with stable metric identity.
- Every returned `Metric` contains before, after, and target; `Passed` follows explicit integer comparisons.
- A non-improving value and a value still above target produce separate typed diagnostics, preserving both facts.
- Baseline emptiness and measurement identity drift stop with stable categories before a success report can exist.

## Forbidden observations

- Source-wide optimization or a recommendation before baseline signals.
- Declaring improvement from one measurement, mismatched metric sets, or changed targets.
- Hidden retry, repeated candidate application, or silently regenerated evidence.
- Pairing values by arrival order when names or targets changed, discarding a failed threshold, or converting an effect failure into a recommendation.
- Reading unrelated source before a metric-backed candidate is selected; concrete source inspection remains inside the candidate effect mapping.

## Execution path

`AuditTarget` measures baseline once, stops if it is empty, applies one candidate for the first gated metric, measures verification once, rejects
count/name/target drift, then builds typed metrics and diagnostics. The comparison loop never invokes an effect, so it is not a retry path.

The exact effect trace is `Measure(Baseline) → ApplyCandidate(Candidate) → Measure(Verify)`. `Complete` is reached only after every pair is
structurally matched and compared. `Passed` begins true and can only move to false; later metrics cannot erase earlier diagnostics. The returned
slice preserves the baseline metric order for deterministic reporting.

The forbidden benchmark represents a target that announces improvement after the baseline without the verification call. Its observation query
detects the missing second measurement and records a forbidden hit even if the target supplies persuasive prose.

## Benchmark result

Status: `SOURCE_SPEC_AND_BENCH_EXPECTATION_ONLY_NOT_LIVE`; `OiHostAvailable=false`.

```text
PassingExpected={Status:"PASS", Observations:["baseline","one-candidate","verification","threshold-comparison"], ForbiddenHits:[], FailureCategory:none}
ForbiddenVariant={BenchmarkPassed:false, Difference:"forbidden-hit", ForbiddenHit:"improvement-without-second-measurement"}
```

These are structured `bench-oi` expectations, not claimed live results.

## Oi/source character count

`Get-Content -Raw main.oi` = `2823` decoded characters.

## Comparison Markdown character count

`Get-Content -Raw README.md` = `4782` decoded characters.

## Semantic limitations

The host defines measurement sources and the concrete candidate change; this case does not model Vercel APIs, frameworks, billing, or deployment.
It proves evidence order, exact effect counts, typed comparisons, and no hidden retry. No Oi executable was available for live execution.

All metrics use the convention that lower is better and integers are sufficient. A real platform adapter must normalize units, time windows,
account scope, and metric direction before returning observations. The case selects the first gated metric rather than ranking many candidates,
and it does not claim causal attribution beyond the two host measurements.
