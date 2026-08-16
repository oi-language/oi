# Sealed entry execution and receipt

Defines 0.0.2 admission, identity, journal, Reply, and receipt; adds no target value.

## Admission and root identity

Host invokes `main` only in a sealed context of verified artifacts, ordered typed inputs, exact mappings/narrowed authorities/policy, and current trace/checkpoints/journal/counters. Parent conversation/replies, verification/report/design/expected values, memory, unmapped output/capabilities, unpassed facts, and credentials as values are excluded.

Unavailable isolation fails `CONTEXT_ISOLATION_UNAVAILABLE` at entry before target operation; invocation count is zero. Direct execution is a fresh sealed Agent interpreting validated `.oi`, not an interface/artifact/inspection substitute.

Root TaskID is `root`; entry ActivationID is `root/a0`. Entry identity/location is the parsed lowercase `main` identifier token. Child/operation identities follow loaded deterministic task/activation/`oN` rules.

## Attempts and operations

Required signatures/authorities/mappings are exact; direct captured effect stays optional. Host probes/failed mappings use a separate identity/outcome log, not target effects/OperationIDs/contracts.

Judgment/derive/effect/task/await/channel/detach/handoff/Reply get stable OperationID in encounter order. Journal records kind/source/input digest/transitions. Each starts once at most and ends `Completed`, `Failed`, `Indeterminate`, or `Cancelled`. Completed needs full typed result; known failure is Failed; untrusted external completion is Indeterminate, never invented/retried. Records/values are protected and immutable.

## Canonical typed bytes

For bytes `p`, `frame(p)` is canonical-decimal UTF-8 byte length, `:`, then `p`; decimal is `0` or unsigned digits without leading zero. `record(tag,fields)` is `frame(tag)+frame(field-count)+` each `frame(name)+frame(value)` in defined field order. `sequence(tag,items)` is `frame(tag)+frame(item-count)+` each `frame(item)` in order. Tags/names are UTF-8; no other separators.

Manifest bytes are record `manifest`, fields in order: `language`, `module`, `source-count`, `sources`; `sources` is sequence `source-paths` of normalized-path UTF-8 in directive order. Artifact identity is record `artifact`, fields `role`, `path`, `bytes`, `characters`, `sha256`; role is exactly `execution|module|project|runtime|standard`. Artifact sequence `artifacts` order is execution.md, oi.mod, manifested project sources, triggered runtime shards in manifest order, reachable std by UTF-8 path bytes. `ManifestDigest`/`SourceDigest` are lowercase SHA-256 of manifest record/artifact sequence; receipt retains the records, not only digests.

Type identity recursively uses records/sequences. Primitive tags: `bool,int,text,unit,failure`; containers/handles contain component identity; anonymous `struct` has declaration-ordered field-name/type pairs; `enum` has module/package/name/member names; `named` has module/package/name/underlying identity.

Value body recursively uses records/sequences: bool `0|1`; int canonical decimal; text UTF-8; unit empty; enum ordinal; named underlying; optional `none|some`; struct declaration order; slice count/elements; map count then canonical key/value pairs; set count/canonical elements; handle kind/stable ID; failure fields.

Typed bytes are `frame(type identity)+frame(value body)`; digest is lowercase SHA-256. Inputs/mappings/authorities/policy each have named tagged sequences/records, including empty values. Mapping record fields are `effect`, `signature`, `authorities`, `host-mapping`; policy fields are explicit nonsecret runtime policy in declaration order. Secret items contain protected typed-value digest, not raw bytes. Only digests leave protection.

## Reply and receipt

A mapped Reply snapshots declared payload, validates contract/mapping/type, records Completed, and lands it unchanged once. Probe/inspection/handwriting/entry return/name/Started is not landing. Receipt is a separate unreadable sidecar.

Every recognized invocation creates a receipt, including artifact `SOURCE_*` failure; failure to construct required receipt fields is host nonconformance, not a target category. Bootstrap before snapshot recognition has no receipt. Receipt contains snapshot/module/entry; manifest/artifact records; input/mapping/authority/policy records/digests; operations/results; Reply or none; terminal Completed/exact Failure; budgets. Empty `main` has empty operations/Reply none; terminal fields allocate no operation/location.

Receipt exposes no raw protected bytes. Replay invokes neither entry nor effects and verifies identities/closure/phases/mappings/operations/digests/Reply/terminal; mismatch fails closed. It is audit evidence, not proof against a forged host record.
