---
name: hello-world
description: Use when a user asks the Oi hello-world example to greet one supplied name.
---

# Hello World

Use the local `using-oi` bootstrap adapter with this directory's `oi.mod` and `main.oi`. Bind one `Name("Oi")` caller input, map `Reply` through `caller.reply`, and host-invoke lowercase `main`.

The result is unit completion and exactly one concrete `Greeting` payload. `main` has no return value, and this source triggers no runtime shard.
