# Oi 0.0.2

Identity is exactly `Oi 0.0.2`. This file is the sole base-language authority and manifest.

## deterministic load

1. Resolve nearest `oi.mod`; exact version selects an installed snapshot. Logically read this file once, then module metadata once.
2. A logical read starts at byte zero, advances through contiguous nonoverlapping chunks to true EOF, and closes with byte size, decoded-character count, and SHA-256. Invalid UTF-8, truncation, gap/overlap/rewind/repetition, missing EOF, or identity change stops before interpretation; only verified concatenation is visible.
3. Stop only for exact `snapshot-metadata`/`version-discovery`/`manifest-inspection` without `.oi` interpretation. Otherwise load manifested sources in directive order; imports resolve only there or to versioned `std/`.
4. Parse/type; union triggers from parsed nodes, resolved calls/imports, and run mode; close declared dependencies. Load runtime shards in row order, then std packages by UTF-8 path bytes, each once.

Missing base/runtime is `MISSING_SPEC_SHARD`/`MISSING_RUNTIME_SHARD`; wrong identity, dependency cycle, duplicate/undeclared row, or contradiction is `INVALID_SPEC_SNAPSHOT`. Unsupported exact version is `UNSUPPORTED_VERSION`; never default/combine/reinterpret.

## manifest

| Path | Trigger | Requires |
| --- | --- | --- |
| `runtime/oi.md` | parsed `OiExpression` | `execution.md` |
| `runtime/await.md` | await expression/select arm | `execution.md` |
| `runtime/collections.md` | map/set, collection builtin/index, or indexed/map/set iteration | `execution.md` |
| `runtime/derivation.md` | parsed `DeriveExpression` | `execution.md`, `runtime/execution.md` |
| `runtime/detach.md` | detach or std/task `Status`/`Cancel` | `execution.md`, `runtime/oi.md` |
| `runtime/handoff.md` | handoff | `execution.md` |
| `runtime/channel.md` | channel/endpoint, send/receive/select | `execution.md` |
| `runtime/persistence.md` | durable/resume/debug/replay, invocation, or journaled operation | `execution.md` |
| `runtime/execution.md` | 0.0.2 entry invocation or derive | `execution.md`, `runtime/persistence.md` |
| `runtime/diagnostics.md` | debug/replay or diagnostic/capture/outcome/stop/task/user | `execution.md` |
| `std/<name>/<name>.oi` | reachable import `std/<name>` | `execution.md` |

## budgets

Decoded limits: spec 14,000; prefix 2,500; prefix+adapter 4,000; adapter 1,500; shard 5,000; source 16,000; graph 128,000; `.oi` line 240. Runtime/std excluded from graph.

## core language

`=` defines; `|` chooses; `[]` optional; `{}` repeats; `()` groups; quotes literal; adjacency orders. Camel-case syntax, lower-case lexical. UTF-8; outside literals ASCII whitespace separates, indentation inert, `//` ends line, no block comment.

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

Identifiers are case-sensitive; `_` discards; initial uppercase exports. Unescaped semantic `[` is `NESTED_SEMANTIC_EXPRESSION`. Line end/EOF after a complete token inserts a terminator except inside unclosed delimiters or after comma/operator; `;` is equivalent.

Keywords: `package import const type struct enum func effect uses contract var if else switch case default for in select return break continue stop handoff oi await detach derive text bool int unit task outcome channel sender receiver map set failure true false none`; builtins: `len append has put add remove capture send receive`.

```ebnf
SourceFile=PackageClause,terminator,{(ImportDecl|TopDecl|EntryDecl),terminator};
PackageClause="package",identifier;
ImportDecl="import",(text_lit|"(",[text_lit,{separator,text_lit},[separator]],")");
TopDecl=ConstDecl|TypeDecl|FuncDecl|EffectDecl;
ConstDecl="const",identifier,[Type],"=",Expression;
TypeDecl="type",identifier,Type,[Contract];
Type=TypeCore,["?"];
TypeCore="[]",TypeCore|"map","[",Type,"]",TypeCore|"set","[",Type,"]"|TypeAtom|"(",Type,")";
TypeAtom=TypeName|"text"|"bool"|"int"|"unit"|StructType|EnumType|"task","[",Type,"]"|"outcome","[",Type,"]"|"channel","[",Type,"]"|"sender","[",Type,"]"|"receiver","[",Type,"]"|"failure";
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

Nearest 0.0.2 `oi.mod` has canonical `module <path>`, `oi 0.0.2`, then one+ `source <path>` (blanks/comments ignored). Module segments are nonempty ASCII alnum/`_`/`-`. Source paths are normalized relative UTF-8: no backslash, `.`, `..`, empty/edge segment, absolute/escape; unique and strictly UTF-8-byte ascending. Missing list: `MISSING_SOURCE_MANIFEST`; invalid path: `SOURCE_MANIFEST_PATH`; unordered/duplicate: `SOURCE_MANIFEST_ORDER`.

Manifested `main.oi` is package `main`. Else directory-final segment=basename=package; one source per package directory (`SOURCE_PACKAGE_MISMATCH`/`SOURCE_PACKAGE_DUPLICATE`). Imports resolve uniquely to manifested sources or fail `SOURCE_IMPORT_UNDECLARED`; unlisted files are absent. Graph is reachable, acyclic, version-uniform. File/graph/line overflow is `SOURCE_FILE_BUDGET`/`SOURCE_GRAPH_BUDGET`/`SOURCE_LINE_BUDGET`; invalid logical close is `SOURCE_TRUNCATED`, drift `SOURCE_CHANGED_DURING_LOAD`.

`text` is exact UTF-8; `bool=true|false`; `int` unbounded; `unit` singleton; `[]T` finite ordered; `map[K]V` and `set[T]` finite; `T?=none|T`. Structs have exact fields; enums use `Type.Member`. Declared types are distinct; explicit construction converts equal underlying shape plus contract. `[]` binds before `?`.

Stable keys/elements: bool (`false<true`), mathematical int, unsigned-UTF-8-byte text, enum declaration order, or a named type over one. Other types are unstable. Maps/sets are empty-zero immutable noncomparable values; copies share no mutable state; durability is recursive. Other zeroes: `""`, `false`, `0`, `unit`, empty slice, `none`, first enum, fieldwise struct. Handles are zero-less.

`append` returns a new same-type slice. `len` counts slice/map/set elements or text UTF-8 bytes. `has(map,key)`/`has(set,value)` is bool; `put` returns inserted/replaced map; `add` returns a set containing value; `remove` returns map/set without target and is unchanged if absent. Slice/map indexing is typed; bounds failure is runtime, absent map key is `MISSING_KEY`. Integer operations are mathematical; division truncates toward zero. Comparable: bool/int/text/unit, enum, named/optional/struct recursively; collections, handles, failure are not. Operators require identical types; boolean operators short-circuit.

```ebnf
Expression=UnaryExpr,{binary_op,UnaryExpr}; UnaryExpr=("!"|"-"),UnaryExpr|PrefixExpr;
PrefixExpr=OiExpression|AwaitExpression|DeriveExpression|PrimaryExpr;
PrimaryExpr=Operand,{".",identifier|"[",Expression,"]"|Arguments};
Operand=identifier|text_lit|int_lit|"true"|"false"|"none"|"unit"|SemanticExpr|CompositeLit|ChannelExpr|"(",Expression,")";
Arguments="(",[Expression,{",",Expression},[","]],")";
CallExpression=QualifiedName,Arguments; QualifiedName=identifier,{".",identifier};
OiExpression="oi",CallExpression; AwaitExpression="await",(OiExpression|PrimaryExpr);
DetachExpr="detach",OiExpression; DeriveExpression="derive",SemanticExpr;
ChannelExpr="channel","[",Type,"]","(",Expression,")";
CompositeLit=Type,"{",[Element,{",",Element},[","]],"}";
Element=[Expression,":"],Expression; SemanticExpr="[",SemanticContent,"]";
```

Postfix precedes unary; binary precedence is `* / %`, `+ -`, comparisons/`~=`, `&&`, `||`, left-associative. Composite positions are slice/set values, map key:value pairs, or named struct fields once. Later equal map/set literal item fails `DUPLICATE_KEY` at that item. `none` needs optional target.

A plain semantic expression is one typed Agent judgment/contract/`~=` predicate. Generation is bounded to primitive, enum, named/optional bounded value, or recursively bounded fixed struct; contained slice/map/set is static `UNBOUNDED_SEMANTIC_RESULT` at `[`. Dynamic inputs are only interpolations, never ambient context. It cannot hide control/retry/effect/dispatch/handoff/stop. Uncertainty is `AMBIGUOUS_SEMANTIC_VALUE`/`AMBIGUOUS_SEMANTIC_MATCH`.

`derive [...]` requires explicit target, never `:=`; it uniquely transforms interpolated typed inputs under the loaded snapshot into any handle-free value. Parse/decode/normalize/group/sort/canonical render are allowed; policy choice and effect/control/retry/dispatch/handoff/stop are not. Non-unique result is runtime `NONDETERMINISTIC_DERIVATION`. Contracts/`~=` stay bounded.

```ebnf
Statement=Declaration|Assignment|IfStmt|SwitchStmt|ForStmt|SelectStmt|ReturnStmt|BreakStmt|ContinueStmt|StopStmt|HandoffStmt|ExpressionStmt;
Declaration=ShortDecl|VarDecl|ConstDecl; ShortDecl=identifier,":=",Expression; VarDecl="var",identifier,Type,["=",Expression];
Assignment=PrimaryExpr,"=",Expression; IfStmt="if",Expression,Block,[[terminator],"else",(IfStmt|Block)];
SwitchStmt="switch",[Expression],"{",{CaseClause},[DefaultClause],"}"; CaseClause="case",Expression,{",",Expression},":",{Statement,terminator}; DefaultClause="default",":",{Statement,terminator};
ForStmt="for",ForBinding,"in",Expression,Block|"for",[Expression],Block; ForBinding=identifier|identifier,",",identifier;
SelectStmt="select","{",{SelectCase},[DefaultClause],"}"; SelectCase="case",([identifier,":="],(ReceiveOp|AwaitExpression)|SendOp),":",{Statement,terminator};
ReceiveOp="receive","(",Expression,")"; SendOp="send","(",Expression,",",Expression,")";
ReturnStmt="return",[Expression]; BreakStmt="break"; ContinueStmt="continue"; StopStmt="stop","(",Expression,",",Expression,")";
HandoffStmt="handoff",CallExpression; ExpressionStmt=CallExpression|OiExpression|AwaitExpression|DetachExpr;
```

`:=` is local and rejects semantic/derive. Assignment/arguments require identical type; literals need unique target; named conversion is explicit. `if` is bool; switch evaluates once, first equal, final default, no fallthrough. At loop entry the collection value is snapshotted: slice one-binding yields values, two-binding yields ascending int index/value; map requires key/value and canonical key order; set requires one value and canonical element order. Rebinding the source cannot change that encounter. `break` targets loop/switch/select; `continue` loop.

Functions evaluate arguments left-to-right, have at most one result, and require all result paths; unit falls through. Effects are atomic declarations with one nonempty `uses` and one semantic contract; signature, authorities, and contract identify the mapping. `capture` is the only failure observation and performs no retry.

Exactly one lowercase resultless `main` EntryDecl exists only in executable package `main`; it is not an ordinary FuncDecl. Its ordered typed caller inputs are host-only; it cannot be imported/selected/addressed/called, and complex input is a program struct. Validate mappings/authorities, bind inputs in order, then admit sealed execution. Bad bindings fail. Completion is only a mapped program-declared concrete typed effect; `Reply`-like names are conventional, not built-ins/return channels.

`oi` launches an ordinary function as `task[T]`; `await task[T]` returns T; other targets fail. Detach is valueless `detach oi Call`; handoff is terminal to unit function. Durable values are recursively handle-free. Channels are bounded positive-capacity typed locals; receiver affine; endpoints never enter data/effect/semantic/detach/handoff. Task/channel authority is reachable demand∩current. Select permits send/receive/await and one final default.

Evaluation is source/left-to-right. Named contracts run at construction/conversion/argument/assignment/return/effect boundaries. Root entry and children receive only verified loaded artifacts, explicit typed arguments, exact mappings/authorities/policy, and current trace/checkpoints/journal. Semantic, derive, effect, task, await, channel commit, detach, and handoff have stable operation identity. An external effect is complete only after its full typed boundary result; started without trusted completion is indeterminate, never guessed or retried. Reply payload lands unchanged; an `ExecutionReceipt` sidecar is separate and unreadable by the program.

Phases: `parse → module → type → effect mapping → input binding → execution admission → runtime`; failure bars later phases. Static diagnostics choose phase, normalized path bytes, line, column. Runtime chooses journal order, source position, TaskID. Location is one-based UTF-8-scalar `path:line:column`; failure is Category/Phase/Location/Detail/Trace. Failure after recognized 0.0.2 identity produces a terminal receipt; bootstrap failure before snapshot recognition remains a bootstrap diagnostic.
