<div align="center">
  <img src="assets/brand/oi-wordmark.svg" alt="带定稿吉祥物的 Oi 字标" width="420">
  <h1>一门用于编写和运行 Agent Skill 的 Agent Language。</h1>
  <p>让目标明确，让边界可见，也给 Agent 留出思考空间。</p>
  <p><code>Oi oi oi.</code></p>
  <p><a href="README.md">English</a></p>
</div>

<p align="center">
  <img src="assets/brand/oi-readme-hero.png" alt="原创 Oi 执行胶囊在 Agent 工作台中执行任务" width="76%">
</p>

## Oi 是什么？

Oi 是一门面向 Agent、用于编写和运行 Agent Skills 的语言。它把目标、约束、分支、失败处理和停止条件组织成清晰结构，同时保留 Agent 在边界内理解上下文、选择方法和适应环境的自由度。

Oi 以 Skill 为主要交付与执行单元，但不排斥必要的工具或脚本。安装后的 Agent 加载 `oi.mod` 选定的精确语言快照并直接执行 `.oi`；语言没有二进制编译器、独立 VM 或生成产物。包括随附工具链在内的产品行为都由 Oi 承载。

## 设计影响

Oi 借鉴了 Go 的一些结构性经验：显式语言版本、module/package/import 组织、直接执行模型，以及熟悉的控制流形式。但 Oi 的语义和工具链面向 Agent Skills，而不是通用系统编程。Oi 是独立项目，与 Google 或 Go 项目没有隶属关系。

## 为什么是 Oi？

| 原则             | 含义                                                           |
| ---------------- | -------------------------------------------------------------- |
| 意图明确         | Skill 声明目标、输入、输出、约束和完成条件。                   |
| 边界内开放       | Agent 在声明的范围内选择方法，而不是猜测任务边界。             |
| 模块可检查       | `.oi` 文件可以拆成 package，并通过显式 import 和语言版本组织。 |
| 适配多种 harness | Codex、Claude、Cursor 及其他 harness 可以理解同一份模块图。    |

## 一眼看懂

一个可执行 Oi 模块通过最近的 `oi.mod` 选择一个精确语言快照；Oi 不会使用默认版本、组合版本，也不会以 plugin packaging version 代替语言版本。Oi 0.0.2 还会显式列出每个项目 source：

```text
module hello
oi 0.0.2
source main.oi
```

行为位于 `main.oi`：

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

名称小写且没有结果的 `main` 由宿主使用有类型 caller 输入调用。声明的 `Reply` effect 明确外部边界，方括号表达式只执行一次有边界的语义判断。当前完整模块位于 [`examples/hello-world`](plugins/oi/skills/using-oi/versions/0.0.2/examples/hello-world/)。

## 项目状态

- ✅ Oi 0.0.2 是当前语言快照。它使用严格的 source manifest、带固定预算的 logical read、确定性的 map/set 值与迭代、有边界的普通语义判断和有类型的确定性 `derive`，并使用 sealed execution、受保护 receipt 与 replay。
- ✅ Oi 0.0.1 仍随包安装并保持不可变，继续使用其已发布的加载与 runtime 行为。Plugin package 0.0.3 同时交付这两个精确快照；package version 与语言版本彼此独立。
- ✅ 随附的 compiler、formatter、debugger、benchmark、converter 和只读 upgrader 均以 Oi 实现；它们的 `SKILL.md` adapter 只负责加载、映射和路由。从 0.0.1 到 0.0.2 的 upgrade analysis 必须显式请求，且不会改写或执行目标。
- ✅ 三个提炼后的有类型案例分别覆盖 import alias 分析、多根 bootstrap 决策和真实 sealed invocation 证明。Receipt 只能证明结果与可信 sealed host 的完成记录一致；它既不能让恶意 host 变得可信，也不是编译产物。

## 文档

- [语言设计](docs/language/design.md)：已发布快照共享的稳定设计选择与边界模型。
- [Oi 0.0.2 执行规范](plugins/oi/skills/using-oi/versions/0.0.2/execution.md)：当前规范性的 grammar、静态语义、加载规则和浅层执行语义。
- [Oi 0.0.1 执行规范](plugins/oi/skills/using-oi/versions/0.0.1/execution.md)：不可变的早期快照。
- [核心语言语料库](docs/language/corpus.md)：正例、无效输入、runtime 和 durable 行为案例。
- [工具链 contract](docs/language/toolchain.md)：有类型入口、effect、变更边界和跨工具场景。
- [品牌指南](docs/brand.md)：logo、定稿吉祥物、配色、尺寸和原创性规则。

## 路线图

1. 用真实 Skill 模块和带出处的 Agent 案例扩充语料。
2. 围绕反复出现的模块模式改进示例和公开文档。
3. 通过显式兼容性检查准备未来精确快照，同时保持已发布快照不可变。

路线图坚持证据优先：Oi 0.0.2 是当前快照，Oi 0.0.1 保持不可变，后续变化必须显式且可测试。

## 参与贡献

请先阅读 [CONTRIBUTING.md](CONTRIBUTING.md)。文档、语料案例、source/spec 评审，以及聚焦的语言或工具改进，都是对已发布 0.0.2 基线有价值的贡献。

提交变更时，请说明它解决的问题、保留的约束，以及一个能让行为易于评审的最小示例。请在独立的开发 worktree 中完成实现，并让仓库门面始终聚焦准确的公开沟通。

使用 issue 模板提交聚焦问题或提案，使用 pull request 模板说明范围和验证方式。

## 加入 Oi 用户群

扫描下方二维码加入 Oi 飞书用户群。

<p align="center">
  <img src="assets/community/oi-feishu-group-qr.jpg" alt="加入 Oi 飞书用户群的二维码" width="280">
</p>

## License

除非文件或目录另有说明，Oi 的源代码、文档和仓库资产均采用 [MIT License](LICENSE)。

`Oi` 名称、logo 和吉祥物属于项目品牌资产；MIT License 不授予商标权，也不表示与 Google 或 Go 项目存在关联。

<div align="center">
  <sub>向边界打个招呼。<code>Oi oi oi.</code></sub>
</div>
