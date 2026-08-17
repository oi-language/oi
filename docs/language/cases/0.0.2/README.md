# Oi 0.0.2 cases

These small Skills exercise the Oi 0.0.2 snapshot with caller-supplied typed values:

- `registry-analysis` makes one fixed-result judgment per import and derives one ordered aggregate.
- `multi-root-bootstrap` computes deterministic member and missing-registry sets.
- `actual-invocation-proof` demonstrates that a matching answer is insufficient without sealed entry admission, an actual Reply, and a completed receipt.

The cases read no ambient repository state. Their adapters bind only the documented typed entry inputs and `caller.reply`.
