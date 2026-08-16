---
name: hello-world
description: Use when a user asks the Oi hello-world example to greet one supplied name.
---

# Hello World

Use the local `using-oi` bootstrap adapter with this directory's `oi.mod` and `main.oi`. Bind exactly one caller input,
`Name("Oi")`, map `Reply` through `caller.reply`, and host-invoke lowercase `main`.

The result is unit completion and exactly one `Greeting("Hello, Oi!")` payload. The `Name` contract is checked during
caller binding and creates no entry operation. Constructing `Greeting` performs one contract Judgment. The immutable,
already-validated exact same named value then crosses the Reply boundary by reusing that validation evidence, without a
second Judgment. Judgment and Reply each have their required Allocation, Started, and Completed records; root completion
appears only as the Completed receipt terminal. Use the frozen runtime and suite catalog for canonical identity and
digest validation; this router defines no algorithm. `main` has no return value.
