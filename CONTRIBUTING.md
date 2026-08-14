# Contributing to Oi

Thanks for helping shape Oi. Oi 0.0.1 is a released, versioned language snapshot: a short, well-bounded corpus example or a careful documentation review can be more valuable than a large patch when it makes the published contracts clearer or more verifiable.

## Before you start

1. Read the [language design](docs/language/design.md) and the [versioned execution specification](plugins/oi/skills/using-oi/versions/0.0.1/execution.md).
2. For visual changes, read the [brand guide](docs/brand.md) and use `oi-wordmark.svg` as the editable source for the wordmark.
3. Open an issue when the proposal changes language semantics, module boundaries, versioning, or a public compatibility promise.

## Versioning

Oi has two version axes. Do not treat a matching number as one identity.

- Language snapshot: the exact `oi <version>` in `oi.mod` and the immutable tree under `plugins/oi/skills/using-oi/versions/<version>/`.
- Plugin packaging: the `version` fields in marketplace.json and `plugins/oi/.{cursor,claude,codex}-plugin/plugin.json`, used by host marketplaces to install and update.

A packaging-only change must not mutate a released snapshot or reuse a language git tag. When adding a language snapshot, bump the packaging version so installed Agents receive it, and keep the marketplace files and plugin.json files at that same packaging version. `upgrade-oi` `installed` and `targetVersion` are snapshot names under `using-oi/versions/`, never the plugin packaging version.

## Scope and worktrees

This repository contains Oi's public language specification, versioned standard library, Skill implementations, conformance corpus, documentation, static brand assets, and GitHub collaboration files. Keep a pull request focused on the part of that public tree it changes.

If a change needs both a public explanation and implementation, land the explanation only when it is accurate for the current branch, and link the implementation work separately. Do not describe a future command as shipped until it exists and has a verification path.

## Documentation and assets

- Prefer short, concrete explanations over marketing language.
- Keep claims tied to the released specification, a corpus example, or observed behavior.
- Describe 0.0.1 syntax as released behavior; label proposals for later snapshots explicitly.
- Keep logo files in `assets/brand/`, with SVG as the editable source.
- Never draw or trace the supplied reference character. Preserve the Oi mood through an original execution-capsule/terminal abstraction.
- Use relative links and verify that every referenced file exists before opening a pull request.

## Pull requests

Every pull request should explain:

- the problem or reader need it addresses;
- the files and scope it changes;
- the design document or issue that provides context;
- the verification commands or visual checks performed;
- whether implementation code was intentionally left untouched.

Keep commits focused. This repository uses the format `[action] 中文说明。`, for example `[docs] 更新 Oi 项目状态说明。`.

## Review checklist

Before requesting review, run `git diff --check`, inspect changed images at small and README sizes, and read the rendered Markdown from a fresh clone or the GitHub preview when possible. Check that the diff contains only the intended public-tree changes.

## License

Oi is released under the [MIT License](LICENSE). The brand guide describes the separate name, logo, and mascot boundary.
