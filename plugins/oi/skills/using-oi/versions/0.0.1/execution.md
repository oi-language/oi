# Oi 0.0.1

Identity is exactly `Oi 0.0.1`. This is the sole base-language authority and manifest, read completely exactly once. The compact prefix precedes the core-language heading and continuous body in this same file.

## deterministic load

1. Resolve nearest `oi.mod` and exact version.
2. Load and validate this `execution.md` exactly once.
3. Stop only if the request is exactly `snapshot-metadata`, `version-discovery`, or `manifest-inspection` and interprets no `.oi`; the complete file may already be read.
4. Otherwise parse the reachable project and standard-library source graph using this same loaded file.
5. From parsed nodes, imports, and run mode, union manifest triggers, close declared dependencies transitively, and verify every required file.
6. Load runtime shards in manifest-row order and standard packages in exact UTF-8 path-byte order; validate effects/input binding, then execute. Every file loads at most once.

No shard discovers dependencies from prose; unknown syntax never eagerly loads shards. Missing `execution.md` is `MISSING_SPEC_SHARD`; missing triggered runtime file is `MISSING_RUNTIME_SHARD`. Wrong identity, dependency cycle, duplicate manifest path, undeclared file, or contradiction between a runtime shard and `execution.md` is `INVALID_SPEC_SNAPSHOT`.

## manifest

Trigger sets union; declared dependencies close transitively.

| Path | Trigger | Requires |
| --- | --- | --- |
| `runtime/oi.md` | parsed `OiExpression` | `execution.md` |
| `runtime/await.md` | parsed `AwaitExpression` or await arm in `SelectStmt` | `execution.md` |
| `runtime/detach.md` | parsed `DetachExpr` or resolved std/task `Status`/`Cancel` call | `execution.md`, `runtime/oi.md` |
| `runtime/handoff.md` | parsed `HandoffStmt` | `execution.md` |
| `runtime/channel.md` | parsed channel/sender/receiver type, send, receive, or `SelectStmt` | `execution.md` |
| `runtime/persistence.md` | run mode `durable`/`resume`, parsed `DetachExpr`/`HandoffStmt`, or resolved std/task `Status`/`Cancel` call | `execution.md` |
| `runtime/diagnostics.md` | run mode `debug`/`replay`, parsed `capture`/`outcome`/`stop`, resolved std/task `Status`/`Cancel` call, or resolved std/user `Ask` or `Respond` call | `execution.md` |
| `std/<name>/<name>.oi` | reachable import path `std/<name>` | `execution.md` |

## budgets

Decoded UTF-8 characters: spec ≤14,000; prefix ≤2,500; prefix+adapter ≤4,000; adapter ≤1,500.

## core language

`=` defines; `|` chooses; `[]` optional; `{}` repeats; `()` groups; quotes literal; adjacency orders. Camel-case syntax, lower-case lexical.

UTF-8; outside literals ASCII space/tab/CR/LF separates, indentation inert, `//` ends CR/LF, no block comment.

```ebnf
letter="A"…"Z"|"a"…"z"; digit="0"…"9";
identifier=(letter|"_"),{letter|digit|"_"}; int_lit=digit,{digit};
text_char=any UTF-8 scalar except quote, backslash, CR, LF;
text_lit='"',{text_char|'\"'|'\\'|'\n'|'\t'},'"';
SemanticContent=SemanticItem,{SemanticItem};
SemanticItem=semantic_char|semantic_escape|Interpolation;
semantic_char=any UTF-8 scalar except bracket, brace, backslash;
semantic_escape='\['|'\]'|'\{'|'\}'|'\\';
Interpolation="{",identifier,{".",identifier|"[",(identifier|int_lit),"]"},"}";
terminator=";"|inserted_line_terminator; separator=","|terminator;
```

Identifiers case-sensitive; `_` discards, never declared/read; initial `A`–`Z` exports. Unescaped `[` outside interpolation: `NESTED_SEMANTIC_EXPRESSION`; `[]` slice punctuation. After comment, line end/EOF inserts terminator after identifier/literal/`true`/`false`/`none`/`break`/`continue`/`return`/type keyword/`?`/`)`/`]`/`}`; not unclosed `()`/`[]` or after comma/operator. `;` equivalent.

Keywords: `package import const type struct enum func effect uses contract var if else switch case default for in select return break continue stop handoff oi await detach text bool int unit task outcome channel sender receiver failure true false none`; calls: `len append capture send receive`.

```ebnf
SourceFile=PackageClause,terminator,{(ImportDecl|TopDecl|EntryDecl),terminator};
PackageClause="package",identifier;
ImportDecl="import",(text_lit|"(",[text_lit,{separator,text_lit},[separator]],")");
TopDecl=ConstDecl|TypeDecl|FuncDecl|EffectDecl;
ConstDecl="const",identifier,[Type],"=",Expression;
TypeDecl="type",identifier,Type,[Contract];
Type=TypeCore,["?"];
TypeCore="[]",TypeCore|TypeAtom|"(",Type,")";
TypeAtom=TypeName|"text"|"bool"|"int"|"unit"|StructType|EnumType
        |"task","[",Type,"]"|"outcome","[",Type,"]"|"channel","[",Type,"]"
        |"sender","[",Type,"]"|"receiver","[",Type,"]"|"failure";
TypeName=[identifier,"."],identifier;
StructType="struct","{",{FieldDecl,terminator},"}"; FieldDecl=identifier,Type;
EnumType="enum","{",identifier,{terminator,identifier},[terminator],"}";
Signature="(",[ParamList],")",[Type]; ParamList=Parameter,{",",Parameter},[","];
Parameter=identifier,Type; FuncDecl="func",identifier,Signature,Block;
EntryDecl="func","main","(",[ParamList],")",Block;
EffectDecl="effect",identifier,Signature,"{",UsesClause,terminator,ContractClause,terminator,"}";
UsesClause="uses",Authority,{",",Authority}; Authority=identifier,{".",identifier};
ContractClause="contract",SemanticExpr; Contract=SemanticExpr;
Block="{",{Statement,terminator},"}";
```

Nearest `oi.mod`, ignoring blanks/comments: `module <path>` then exact `oi 0.0.1`. Path segment: nonempty ASCII letter/digit/`_`/`-`, `/`-joined; never `.`/`..`/backslash/edge slash; ranges/omissions/suffixes/other versions fail. One package/source, name/directory. Imports module root or versioned `std/`; only imports reachable; graph acyclic/version-uniform; cross-package exports; no duplicate/overload/top-level variable.

`text` exact UTF-8; `bool=true|false`; `int` unbounded; `unit` one value; `[]T` finite ordered; `T?=none|T`. Structs exactly declared fields; enum members `Type.Member`/`pkg.Type.Member`. Declared types distinct; construction `TypeName(expression)`, composites, target-typed semantic; conversion equal underlying shape+contract. `[]` before `?`: `[]T?`=`([]T)?`; slice optional=`[](T?)`.

Zeroes: `""`, `false`, `0`, `unit`, empty slice, `none`, first enum, fieldwise struct; named zero contract-check. `task/channel/sender/receiver` opaque/zero-less; values copy; `append` new same-type slice; `len` elements/UTF-8 bytes. `s[i]` on `[]T` with int gives `T`, zero-based/range-checked; `.f` field. Integer ops mathematical, `/` toward zero, zero divisor fails; comparisons `int`/byte-ordered `text`. Comparable: `bool/int/text/unit`, enum, named/optional/struct iff underlying/element/every field; slices/handles/failure not. `== !=` identical comparable types; `! && ||` bool short-circuit.

```ebnf
Expression=UnaryExpr,{binary_op,UnaryExpr}; UnaryExpr=("!"|"-"),UnaryExpr|PrefixExpr;
PrefixExpr=OiExpression|AwaitExpression|PrimaryExpr;
PrimaryExpr=Operand,{".",identifier|"[",Expression,"]"|Arguments};
Operand=identifier|text_lit|int_lit|"true"|"false"|"none"|"unit"|SemanticExpr|CompositeLit|ChannelExpr|"(",Expression,")";
Arguments="(",[Expression,{",",Expression},[","]],")";
CallExpression=QualifiedName,Arguments; QualifiedName=identifier,{".",identifier};
OiExpression="oi",CallExpression; AwaitExpression="await",(OiExpression|PrimaryExpr); DetachExpr="detach",OiExpression;
ChannelExpr="channel","[",Type,"]","(",Expression,")"; CompositeLit=Type,"{",[Element,{",",Element},[","]],"}";
Element=[identifier,":"],Expression; ConversionExpr=TypeName,"(",Expression,")"; OptionalValue=Expression|"none";
SemanticExpr="[",SemanticContent,"]";
```

`ConversionExpr` resolves type; `OptionalValue` optional context. Precedence: `* / %`; `+ -`; `== != < <= > >= ~=`; `&&`; `||`; left-associate; postfix before unary; bare `await` primary; `~=` right `SemanticExpr`. Slice positional; struct names fields once; `none` optional target. Semantic target explicit `var`/assignment/parameter/return/composite element/conversion/contract, never `:=`; content one generation or contract/`~=` predicate. `value` is contract candidate/result or `~=` left operand, one judgment. No nested/sequence/branch/loop/retry/effect/dispatch/handoff/stop semantic; uncertainty fails.

```ebnf
Statement=Declaration|Assignment|IfStmt|SwitchStmt|ForStmt|SelectStmt|ReturnStmt|BreakStmt|ContinueStmt|StopStmt|HandoffStmt|ExpressionStmt;
Declaration=ShortDecl|VarDecl|ConstDecl; ShortDecl=identifier,":=",Expression; VarDecl="var",identifier,Type,["=",Expression];
Assignment=PrimaryExpr,"=",Expression; IfStmt="if",Expression,Block,[[terminator],"else",(IfStmt|Block)];
SwitchStmt="switch",[Expression],"{",{CaseClause},[DefaultClause],"}"; CaseClause="case",Expression,{",",Expression},":",{Statement,terminator}; DefaultClause="default",":",{Statement,terminator};
ForStmt="for",(identifier,"in",Expression|[Expression]),Block; SelectStmt="select","{",{SelectCase},[DefaultClause],"}";
SelectCase="case",([identifier,":="],(ReceiveOp|AwaitExpression)|SendOp),":",{Statement,terminator};
ReceiveOp="receive","(",Expression,")"; SendOp="send","(",Expression,",",Expression,")";
ReturnStmt="return",[Expression]; BreakStmt="break"; ContinueStmt="continue"; StopStmt="stop","(",Expression,",",Expression,")";
HandoffStmt="handoff",CallExpression; ExpressionStmt=CallExpression|OiExpression|AwaitExpression|DetachExpr;
```

`:=` local from non-semantic expression. Initializer-less `var` zeroable; else type/value. `const` literal/enum/composite/constant operation only. `=` assignable local/field/index, identical type. `if` bool; `switch` once (omitted `true`), first equal, one final `default`, no fallthrough. `for x in s`: `[]T`, binds `x:T`; condition bool, omission `true`. `break` nearest loop/switch/select; `continue` loop. Result function every normal path; `unit` bare-return/fallthrough; `return` exits; handoff terminal.

`func` checks arguments left-to-right, at most one result; omission `unit`. `effect` atomic: one nonempty `uses`, one semantic `contract`, no statements; signature/authorities/contract identify mapping.

One `EntryDecl`, only executable package `main`; neither `TopDecl` nor `FuncDecl` in any order; ordinary declarations never bind `main`. Zero+ typed caller inputs in order, no result, `unit`, only bare `return`/fallthrough. Complex input program-declared struct; no built-in `Input`, implicit arg/global. Host alone invokes. Oi cannot export/import/select/address/call `main` (incl. `oi`/handoff); absent from ordinary symbols; call `ENTRY_NOT_CALLABLE`. Absent `MISSING_ENTRY`; result `ENTRY_RESULT_FORBIDDEN`; value return `ENTRY_RETURN_VALUE`. Ordinary result functions unchanged.

Entry graph ordinary/`oi`/detach/handoff calls; authority=reachable-effect union. Direct `capture(EffectCall(...))` optional, helper effects not. Before invocation host maps/grants effects/authorities and binds count/structural input. Missing/extra/ambiguous/ill-typed binding fails there; named input contracts before entry. Completion only mapped program-declared concrete typed effect. `Reply`, `Respond`, `caller.reply` conventional, not keyword/built-in: no universal untyped reply, inferred return channel, or unobservable completion value. Required unmapped: static `UNMAPPED_EFFECT`; optional: captured runtime `UNMAPPED_EFFECT`.

Assignment/arguments identical; untyped literal unique target; `none` `T?`. No implicit named conversion (`IMPLICIT_NAMED_CONVERSION`); type form outside `Type` (incl. `map[K]V`) `UNSUPPORTED_TYPE`. Untargeted semantic `MISSING_SEMANTIC_TYPE`; sequencing/control `IMPERATIVE_SEMANTIC_BLOCK`; inner unescaped `[` `NESTED_SEMANTIC_EXPRESSION`; no execution. `oi QualifiedName(...)` requires ordinary `func`: effect is `OI_EFFECT_FORBIDDEN`, other declared non-function is `OI_REQUIRES_NAMED_FUNCTION`; result `task[T]`. `await task[T]`: `T`. `DetachExpr` only valueless `ExpressionStmt` `oi Call`; task cannot escape return/data/channel/effect.

`durable`: recursively handle-free basic/named/enum/struct/slice/optional, `failure`, `outcome[durable]`. `channel[T](capacity)` durable `T`, compile-time positive int; policy cap; `.Send:sender[T]` copies. `.Receive:receiver[T]` affine: assignment/argument moves, later invalid. `send`/`receive` typed; channel local. Endpoint local/direct ordinary or attached-`oi` parameter, never return/embed/semantic-or-effect-use/detach/handoff. `select` send/receive/await, one final default; receive/await bind. Handoff named `func`, durable typed args, no value. `oi`/detach/handoff authority demand∩current, no expansion. Required outside `UNMAPPED_EFFECT`; direct capture capturable.

Statements/operands source/left-to-right. Runtime input contracts before entry; named contracts construction/conversion/argument/assignment-insertion/return/effect boundary. False/uncertain `TYPE_CONTRACT_MISMATCH`; non-unique generation `AMBIGUOUS_SEMANTIC_VALUE`; uncertain `~=` `AMBIGUOUS_SEMANTIC_MATCH`. `failure` read-only `Category text`, `Phase text`, `Location text`, `Detail text`, `Trace []text`, runtime-only. `stop(category,detail)` text terminates task. `outcome[T]` read-only `Ok bool`, `Value T?`, `Failure failure?`, `capture`-only. `capture(expression)`: success `Ok=true`, result `Value`, `Failure=none`; failure `Ok=false`, `Value=none`, `Failure` set. `if o.Ok` narrows true `Value`/false `Failure`; no retry.

Phases: `parse → module → type → effect mapping → input binding → runtime`; failure bars later. Source failure: first offending token, earliest module-relative UTF-8 path/line/column. Global module: target `1:1`; other global declaration/entry; runtime journal/shard ties. Static pre-runtime. Corpus static includes `OI_REQUIRES_NAMED_FUNCTION`, `OI_EFFECT_FORBIDDEN`; runtime includes `TYPE_CONTRACT_MISMATCH`. Other violation phase category; `stop` preserves nonempty category. Failure: category/phase/location/detail/trace.
