# Oi 0.0.2

Identity is exactly `Oi 0.0.2`. This file is the sole base-language authority and manifest.

## deterministic load

1. From target directory/file parent, logical-read nearest `oi.mod` once; retain content/identity and parse only canonical `module`/exact `oi`. This is pre-recognition bootstrap.
2. Logical-read selected `execution.md` once; recognize snapshot only after exact identity validates, then fully validate held module bytes. Never reread. Earlier version/spec failure is bootstrap-only.
3. Logical read is contiguous nonoverlapping bytes zero→true EOF, closed with byte size, decoded characters, SHA-256. Invalid UTF-8, truncation, gap/overlap/rewind/repetition, missing EOF, or drift stops.
4. `snapshot-metadata`, `version-discovery`, and `manifest-inspection` may stop. Otherwise load run-mode rows, validate module/load manifested sources, parse/type, union further node/call/import triggers, close dependencies, then remaining rows and std by UTF-8 path bytes, each once. Physical and receipt orders are distinct.

Missing base/runtime: `MISSING_SPEC_SHARD`/`MISSING_RUNTIME_SHARD`; bad identity/cycle/row/contradiction: `INVALID_SPEC_SNAPSHOT`; unsupported: `UNSUPPORTED_VERSION`. Never default/combine/reinterpret.

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
| `runtime/execution.md` | recognized terminal receipt, entry invocation, or derive | `execution.md`, `runtime/persistence.md` |
| `runtime/diagnostics.md` | debug/replay, any diagnostic, or capture/outcome/stop/task/user | `execution.md` |
| `std/<name>/<name>.oi` | reachable import `std/<name>` | `execution.md` |

## budgets

Decoded limits: spec 14,000; prefix 2,500; prefix+adapter 4,000; adapter 1,500; shard 5,000; source 16,000; graph 128,000; `.oi` line 240. Runtime/std excluded from graph.

## core language

`=` define; `|` choose; `[]` optional; `{}` repeat; `()` group; quotes literal; adjacency order. Syntax Camel-case, lexical lower-case. UTF-8; outside literals ASCII whitespace separates, indentation inert, `//` ends line; no block comments.

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
binary_op="*"|"/"|"%"|"+"|"-"|"=="|"!="|"<"|"<="|">"|">="|"~="|"&&"|"||";
```

Identifiers are case-sensitive; `_` discards; uppercase exports. Unescaped semantic `[` is `NESTED_SEMANTIC_EXPRESSION`. Complete-token line end/EOF inserts terminator except in delimiters or after comma/operator; `;` is equivalent.

Keywords=`package import const type struct enum func effect uses contract var if else switch case default for in select return break continue stop handoff oi await detach derive text bool int unit task outcome channel sender receiver map set failure true false none`; builtins=`len append has put add remove capture send receive`.

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

0.0.2 `oi.mod`: canonical `module <path>`, exact `oi 0.0.2`, one+ `source <path>`; ignore blank/comments. Module segment nonempty ASCII alnum/`_`/`-`/`.`, no edge/repeated dot. Sources unique, strict byte order, normalized relative UTF-8; forbid backslash, `.`, `..`, empty/edge, absolute/escape. Missing/invalid/unordered: `MISSING_SOURCE_MANIFEST`/`SOURCE_MANIFEST_PATH`/`SOURCE_MANIFEST_ORDER` at `oi.mod:1:1`; missing Detail `source manifest required`.

`main.oi` package=`main`; elsewhere directory-final=basename=package; one source/directory (`SOURCE_PACKAGE_MISMATCH`/`SOURCE_PACKAGE_DUPLICATE`). Imports resolve uniquely or `SOURCE_IMPORT_UNDECLARED`; unlisted files absent. Graph acyclic/version-uniform. File/graph/line overflow: `SOURCE_FILE_BUDGET`/`SOURCE_GRAPH_BUDGET`/`SOURCE_LINE_BUDGET`; bad close/drift: `SOURCE_TRUNCATED`/`SOURCE_CHANGED_DURING_LOAD`.

`text` exact UTF-8; `bool=true|false`; `int` unbounded; `unit` singleton; `[]T` finite ordered; `map[K]V`/`set[T]` finite; `T?=none|T`. Struct fields exact; enums use `Type.Member`. Declared types distinct; explicit construction converts equal underlying shape+contract. `[]` binds before `?`.

Nonhandles—primitive, enum, named, optional, struct, slice, map, set, failure, outcome—copy recursive alias-free snapshots on assignment, parameter/result/effect crossing, composite insertion, collection operation; handles retain identity/affinity.

Stable map key/set element types: bool (`false<true`), mathematical int, text by unsigned UTF-8 bytes, enum by declaration, named-over-one retaining identity/order; others unstable. Maps/sets: finite, empty-zero, immutable, noncomparable, recursively durable, no shared mutable state. Other zeroes: `""`/`false`/`0`/`unit`, empty slice, `none`, first enum, fieldwise struct; handles none.

`append`: new same-type slice; `len`: element count/text bytes; `has`: membership. Value-returning `put` inserts/replaces, `add` includes, `remove` excludes/unchanged. Slice/map indexing is typed; bounds fails runtime; absent key `MISSING_KEY`. Int division is toward zero. Recursively comparable: bool/int/text/unit, enum, named/optional/struct; not collection/handle/failure. Operators need identical types; bool ops short-circuit.

`UNSTABLE_MAP_KEY`/`UNSTABLE_SET_ELEMENT`: phase `type`; Location key-type/element-type first token respectively; Detail exact key-type/element-type source spelling respectively. Collection-builtin arity/argument/result uses `ARGUMENT_ARITY_MISMATCH`/`ARGUMENT_TYPE_MISMATCH`/`RESULT_TYPE_MISMATCH` respectively; phase `type`, call site, builtin-name Detail.

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

Postfix precedes unary; left-associative binary precedence: `* / %`, `+ -`, comparisons/`~=`, `&&`, `||`. Composite positions are slice/set values, map key:value, or named struct fields once. A later equal map/set item fails `DUPLICATE_KEY` there. `none` needs optional target.

One semantic expression is one typed judgment/contract/`~=` predicate. Generation permits primitive, enum, bounded named/optional/fixed struct; nested slice/map/set is static `UNBOUNDED_SEMANTIC_RESULT` at `[`. Inputs: interpolations only; no ambient context or hidden control/retry/effect/dispatch/handoff/stop. Uncertainty: `AMBIGUOUS_SEMANTIC_VALUE`/`AMBIGUOUS_SEMANTIC_MATCH`.

`derive [...]` requires explicit target, never `:=`, and uniquely transforms interpolated typed inputs under the snapshot into any handle-free value. It permits parse/decode/normalize/group/sort/canonical render, not policy choice or effect/control/retry/dispatch/handoff/stop. Non-unique is runtime `NONDETERMINISTIC_DERIVATION`; contracts/`~=` stay bounded.

```ebnf
Statement=Declaration|Assignment|IfStmt|SwitchStmt|ForStmt|SelectStmt|ReturnStmt|BreakStmt|ContinueStmt|StopStmt|HandoffStmt|ExpressionStmt;
Declaration=ShortDecl|VarDecl|ConstDecl; ShortDecl=identifier,":=",Expression; VarDecl="var",identifier,Type,["=",Expression];
Assignment=Assignable,"=",Expression; Assignable=identifier,{".",identifier|"[",Expression,"]"}; IfStmt="if",Expression,Block,[[terminator],"else",(IfStmt|Block)];
SwitchStmt="switch",[Expression],"{",{CaseClause},[DefaultClause],"}"; CaseClause="case",Expression,{",",Expression},":",{Statement,terminator}; DefaultClause="default",":",{Statement,terminator};
ForStmt="for",ForBinding,"in",Expression,Block|"for",[Expression],Block; ForBinding=identifier|identifier,",",identifier;
SelectStmt="select","{",{SelectCase},[DefaultClause],"}"; SelectCase="case",([identifier,":="],(ReceiveOp|AwaitExpression)|SendOp),":",{Statement,terminator};
ReceiveOp="receive","(",Expression,")"; SendOp="send","(",Expression,",",Expression,")";
ReturnStmt="return",[Expression]; BreakStmt="break"; ContinueStmt="continue"; StopStmt="stop","(",Expression,",",Expression,")";
HandoffStmt="handoff",CallExpression; ExpressionStmt=CallExpression|OiExpression|AwaitExpression|DetachExpr;
```

`:=`/`var` locals mutable; const/parameters immutable. Assignment roots are live mutable locals; struct/slice selectors rebuild them. Local/assignable-field map/set: whole-value rebind only (`m = put(m,k,v)`); map index/set member/text index/handles cannot assign or mutate in place. Collections update only from returned `append`/`put`/`add`/`remove`. Assignment/argument types identical; literals uniquely targeted; named conversion explicit. `if` requires bool. Switch evaluates once: first equal, else final default; no fallthrough. Loop-entry snapshot: slice value or ascending index/value; map canonical key/value; set canonical value; later source rebind cannot alter it. `break` targets loop/switch/select; `continue` loop.

Bad iteration-binding count: `ITERATION_BINDING_ARITY_MISMATCH`, phase `type`. Detail exactly `slice requires 1 or 2 bindings; found N`, `map requires 2 bindings; found N`, or `set requires 1 binding; found N`, canonical-decimal `N`. Too many locates first extra binding; too few `in`.

Function arguments evaluate left-to-right; ≤1 result; all result paths required; unit falls through. Effects: atomic, one nonempty `uses`, one semantic contract; signature+authorities+contract identify mapping. Only `capture` observes failure; no retry.

`main` EntryDecl: exactly one lowercase resultless, only in executable package `main`, never ordinary FuncDecl. Ordered typed inputs host-only; entry cannot be imported/selected/addressed/called. Complex input: program struct. Validate mappings/authorities, bind in order, admit sealed execution. Completion: mapped program-declared typed effect; Reply-like names conventional.

`oi` ordinary function→`task[T]`; `await task[T]`→T; other targets fail. `detach oi Call` is valueless; handoff terminal to unit function. Durable values recursively handle-free. Channels: positive-bounded typed locals; receiver affine; endpoints never enter data/effect/semantic/detach/handoff. Task/channel authority=reachable demand∩current. Select permits send/receive/await, one final default.

Evaluation: source/left-to-right. Named contracts run at construction/conversion/argument/assignment/return/effect boundaries. Context only: verified artifacts, typed arguments, mappings/authorities/policy, trace/checkpoints/journal. Semantic/derive/effect/task/await/channel/detach/handoff use stable IDs. External effect completes only with full typed result; untrusted completion is indeterminate, never guessed/retried. Reply unchanged; receipt separate/unreadable.

Phases `parse → module → type → effect mapping → input binding → execution admission → runtime`; failure bars later. Static choice: phase, normalized-path bytes, line, column; runtime: journal order, source position, TaskID. Location: one-based UTF-8-scalar `path:line:column`; failure: Category/Phase/Location/Detail/Trace. Post-recognition failure yields terminal receipt; pre-recognition bootstrap failure stays bootstrap diagnostic.
