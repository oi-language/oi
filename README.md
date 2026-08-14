<div align="center">
  <img src="assets/brand/oi-wordmark.svg" alt="Oi wordmark with the finalized mascot" width="420">
  <h1>An agent-native language for writing and running Agent Skills.</h1>
  <p>Make goals explicit. Keep boundaries visible. Leave room for the Agent to think.</p>
  <p><code>Oi oi oi.</code></p>
  <p><a href="README.zh-CN.md">简体中文</a></p>
</div>

<p align="center">
  <img src="assets/brand/oi-readme-hero.png" alt="An original Oi execution capsule working in an Agent workspace" width="76%">
</p>

## What is Oi?

Oi is an agent-native language for writing and running Agent Skills. It gives goals, constraints, branching, failure handling, and stop conditions an explicit structure while leaving the Agent freedom to understand context, choose methods, and adapt inside those boundaries.

Oi uses Skills as its primary delivery and execution unit without ruling out necessary tooling or scripts. An installed Agent loads the exact language snapshot selected by `oi.mod` and directly executes `.oi`; there is no binary compiler, separate VM, or generated artifact. Product behavior, including the bundled toolchain, lives in Oi.

## Influences

Oi borrows several structural ideas from Go: explicit language versions, module/package/import organization, direct execution, and familiar control-flow forms. Its semantics and tooling are designed for Agent Skills rather than general-purpose systems programming. Oi is an independent project and is not affiliated with Google or the Go project.

## Why Oi?

| Principle | What it means |
| --- | --- |
| Explicit intent | A Skill states its target, inputs, outputs, constraints, and completion conditions. |
| Bounded freedom | The Agent chooses methods inside the declared boundary instead of guessing the boundary itself. |
| Inspectable modules | `.oi` files can be split into packages with explicit imports and a declared language version. |
| Harness-friendly | Codex, Claude, Cursor, and other harnesses should be able to reason about the same module graph. |

## At a glance

An executable Oi module selects one exact language snapshot in `oi.mod`:

```text
module hello
oi 0.0.1
```

Its behavior lives in `main.oi`:

```oi
package main

type Name text [the {value} is one non-empty name]
type Greeting text [the {value} is a friendly greeting addressed to the supplied name]

effect Reply(value Greeting) unit {
    uses caller.reply
    contract [deliver {value} exactly once to the caller]
}

func main(name Name) {
    var greeting Greeting = [greet {name}]
    Reply(greeting)
}
```

The lowercase, resultless `main` is invoked by the host with typed caller input. The declared `Reply` effect makes the external boundary explicit, while the bracketed expression performs one bounded semantic judgment. The complete module is available under [`examples/hello-world`](plugins/oi/skills/using-oi/versions/0.0.1/examples/hello-world/).

## Project status

- ✅ Oi 0.0.1 defines one exact language snapshot, manifest-loaded runtime shards, a versioned standard library, examples, and a conformance corpus.
- ✅ The bundled compiler, formatter, debugger, benchmark, converter, and upgrader are implemented in Oi; their `SKILL.md` adapters only load, map, and route.
- ✅ Public specifications, execution-spec manifests, adapters, corpus expectations, and cross-tool contracts describe and validate the same 0.0.1 language snapshot.

## Documentation

- [Language design](docs/language/design.md) — the stable design choices and boundary model behind Oi 0.0.1.
- [Versioned execution specification](plugins/oi/skills/using-oi/versions/0.0.1/execution.md) — the normative grammar, static semantics, loading rules, and shallow execution semantics.
- [Core language corpus](docs/language/corpus.md) — positive, invalid, runtime, and durable behavior cases.
- [Toolchain contracts](docs/language/toolchain.md) — typed entry points, effects, mutation boundaries, and the cross-tool scenario.
- [Brand guide](docs/brand.md) — logo assets, palette, sizing, and originality rules.

## Roadmap

1. Grow the corpus with real Skill modules and attributed Agent cases.
2. Improve examples and public documentation around recurring module patterns.
3. Prepare later exact snapshots through explicit compatibility checks while keeping 0.0.1 immutable.

The roadmap stays evidence-first: Oi 0.0.1 behavior remains immutable, and later changes must be explicit and testable.

## Contributing

Start with [CONTRIBUTING.md](CONTRIBUTING.md). Documentation, corpus cases, source/spec review, and focused language or tool improvements are valuable contributions to the implemented 0.0.1 baseline.

When proposing a change, include the problem it solves, the constraint it preserves, and the smallest example that makes the behavior reviewable. Keep implementation work in its own development worktree and keep the repository facade focused on accurate public communication.

Use the issue templates for focused bug reports and proposals, and the pull request template for scope and verification notes.

## Join the Oi community

Scan the QR code below to join the Oi Feishu user group.

<p align="center">
  <img src="assets/community/oi-feishu-group-qr.jpg" alt="QR code to join the Oi Feishu user group" width="280">
</p>

## License

Unless a file or directory states otherwise, Oi source code, documentation, and repository assets are released under the [MIT License](LICENSE).

The `Oi` name, logo, and mascot are project brand assets. The MIT License does not grant trademark rights or imply affiliation with Google or the Go project.

<div align="center">
  <sub>Say hello to the boundary. <code>Oi oi oi.</code></sub>
</div>
