<!--
  Wizards Towers - style and documentation guideline.

  Target engine: Godot 4.7.x (stable).
-->

# Wizards Towers — style guideline

- [Wizards Towers — style guideline](#wizards-towers--style-guideline)
  - [How to read this document](#how-to-read-this-document)
- [Wiki style](#wiki-style)
- [Code style](#code-style)
  - [GDScript (.gd)](#gdscript-gd)
    - [Upstream rules worth stating explicitly](#upstream-rules-worth-stating-explicitly)
    - [Naming (upstream)](#naming-upstream)
    - [Code order (upstream, Godot 4.7)](#code-order-upstream-godot-47)
    - [Line length (project)](#line-length-project)
    - [Signals (project)](#signals-project)
    - [Setters, initializers and exported scenes (project)](#setters-initializers-and-exported-scenes-project)
    - [Node groups and animations (project)](#node-groups-and-animations-project)
    - [Inner classes (project)](#inner-classes-project)
  - [Documentation comments](#documentation-comments)
    - [Virtual properties](#virtual-properties)
  - [Typed collections instead of commented ones](#typed-collections-instead-of-commented-ones)
  - [Getting a custom class name at runtime](#getting-a-custom-class-name-at-runtime)
  - [JSON and save data](#json-and-save-data)
  - [Node access](#node-access)
  - [Referencing engine bugs](#referencing-engine-bugs)
  - [Multiplayer code](#multiplayer-code)
  - [Tests](#tests)
  - [Scene files (.tscn)](#scene-files-tscn)
  - [Shaders (.gdshader)](#shaders-gdshader)
  - [Shell scripts (.sh)](#shell-scripts-sh)
  - [Third-party code and licence notices](#third-party-code-and-licence-notices)
- [Markdown documentation style](#markdown-documentation-style)
  - [Line breaks](#line-breaks)
  - [Blocks](#blocks)
  - [Tables and tables of contents](#tables-and-tables-of-contents)
  - [Prose versus code](#prose-versus-code)
  - [What does not belong in public documentation](#what-does-not-belong-in-public-documentation)
- [Glossary](#glossary)
- [Appendix: Godot 3 traps](#appendix-godot-3-traps)

## How to read this document

Three kinds of rules live here, and the distinction matters:

- **Upstream** — comes from the official Godot style guide.
  Not negotiable, because deviating makes our code clash with the engine's own conventions.
- **Project** — our own decision.
  Negotiable, but once decided it is decided.
- **Open** — not decided yet.
  Marked `⬜ OPEN`. Do not write code that depends on it.

---

# Wiki style

Titles and section headings use `Sentence case`.
Capitalize a heading the way you would capitalize a sentence.
Do not capitalize each word, do not add ending punctuation.

Wiki URLs use `kebab-case`:
all lower case, hyphens instead of spaces.

Every new wiki page is linked from `Home`, or from a child of `Home`.
If `Home` grows past 20 links, reorganize it into a hierarchy instead of letting it sprawl.

---

# Code style

## GDScript (.gd)

Code follows the [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html) and, where it does not conflict, the [GDQuest best practices](https://www.gdquest.com/docs/guidelines/best-practices/godot-gdscript/).

**Formatter and linter (project): [GDScript Formatter](https://github.com/GDQuest/GDScript-formatter) by GDQuest.**
One static binary, MIT, no Python runtime.
It formats to the official style guide and ships a linter in the same tool.
The version is pinned in CI and bumped deliberately.

| Command                              | Where           | Effect                                     |
| ------------------------------------ | --------------- | ------------------------------------------ |
| `gdscript-formatter <files>`         | editor, on save | Rewrites the file to the project style.    |
| `gdscript-formatter --check <files>` | CI, pre-commit  | Fails if a file is not formatted.          |
| `gdscript-formatter lint <files>`    | CI, pre-commit  | Fails on a naming or convention violation. |

**On layout, the formatter has the last word.**
Where this document and `gdscript-formatter` disagree on whitespace, wrapping or indentation, the formatter's output is right and this document is the one to fix.
Every GDScript example in this document is kept as the formatter writes it, so copying one never produces a file the check rejects.

**Static typing is enforced by the engine, not by the linter.**
A linter reads text and cannot know a type.
`project.godot` raises these GDScript warnings to **error**, so an untyped declaration does not run:

- `debug/gdscript/warnings/untyped_declaration`
- `debug/gdscript/warnings/unsafe_property_access`
- `debug/gdscript/warnings/unsafe_method_access`
- `debug/gdscript/warnings/unsafe_cast`
- `debug/gdscript/warnings/unsafe_call_argument`

`gdlint`/`gdformat` from godot-gdscript-toolkit is not used.
It has had no release since October 2025, and its open issues show the parser lagging behind recent syntax such as `@abstract`.

### Upstream rules worth stating explicitly

These are the ones people break most often, so they are repeated here rather than left to a link:

- **Tabs** for indentation.
  Never spaces.
- **LF** line endings, **UTF-8 without BOM**, one trailing newline per file.
- **Long lines wrap inside their brackets**, the way `gdscript-formatter` lays them out:
  one indent level, one element per line, the closing bracket alone on its line.
  This replaces the upstream two-level continuation rule, which the formatter never produces.
- **Trailing comma** on the last element of a multi-line array, dictionary, enum, argument list or parameter list.
  None on single-line ones.
- **A space inside dictionary braces**, so `{ "gold": 10 }` and `{ }`.
- **Two blank lines** between functions and between class definitions.
- `and` / `or` / `not`, never `&&` / `||` / `!`.
- One statement per line.
  The ternary operator is the only exception.
- Wrap long conditionals in **parentheses**, not backslashes, and put `and`/`or` at the *start* of the continuation line.
- Comments start with a space: `# like this`.
  Commented-out code does not: `#print("x")`.
  That one-space difference is how you tell prose from disabled code at a glance.
- Don't omit leading/trailing zeros: `0.234`, `13.0`.
  Lowercase hex: `0xfb8c0b`.
- Underscores in large literals: `1_234_567_890`.

### Naming (upstream)

|                      Thing | Convention               | Example                       |
| -------------------------: | ------------------------ | ----------------------------- |
|                 File names | `snake_case`             | `spell_component.gd`          |
| Class names (`class_name`) | `PascalCase`             | `class_name SpellComponent`   |
|       Node names in scenes | `PascalCase`             | `ManaBar`, `TowerRoot`        |
|                  Functions | `snake_case`             | `func cast_spell():`          |
|                  Variables | `snake_case`             | `var mana_pool`               |
|                    Signals | `snake_case`, past tense | `signal floor_claimed`        |
|                  Constants | `CONSTANT_CASE`          | `const MAX_FLOORS = 100`      |
|                 Enum names | `PascalCase`, singular   | `enum Element`                |
|               Enum members | `CONSTANT_CASE`          | `{ EARTH, WATER, AIR, FIRE }` |

A file holding a named class takes the snake_case form of that class name:
`class_name YAMLParser` lives in `yaml_parser.gd`.
Acronyms stay fully capitalised in the class name — that is the official guide's own example.

Private members and virtual methods meant to be overridden get a single leading underscore:
`var _counter`, `func _recalculate_path()`.

Constants and `@export` variables are **public** — never prefixed with an underscore.

### Code order (upstream, Godot 4.7)

```
01. @tool, @icon, @static_unload
02. class_name          (@abstract goes before class_name)
03. extends
04. ## doc comment

05. signals
06. enums
07. constants
08. static variables
09. @export variables
10. remaining regular variables
11. @onready variables

12. _static_init()
13. remaining static methods
14. overridden built-in virtual methods, in this order:
      _init()
      _enter_tree()
      _ready()
      _process()
      _physics_process()
      remaining virtual methods
15. overridden custom methods
16. remaining methods
17. inner classes
```

Within each group: **public before private**.

### Line length (project)

**Keep lines under 100 characters**, code and comments alike.
Prefer 80 where you can.

The official guide says 100 and suggests 80, and we take the upstream number as-is.

This limit covers **code**, which includes a comment written *inside* a fenced code block:
a comment in a code block is code, so it obeys the code limit.
Prose in a `.md` file is governed by a different rule — see [Markdown documentation style](#markdown-documentation-style).

### Signals (project)

Signals carry a **past-tense verb**:
`ended`, `changed`, `claimed`.
When a noun is needed to disambiguate, it comes **first**:
`game_ended`, `score_changed`, `floor_claimed` — never `ended_game` or `changed_score`.

Connect with the Godot 4 object syntax:

```gdscript
floor_claimed.connect(_on_floor_claimed)
floor_claimed.emit(floor_index, wizard_id)
```

### Setters, initializers and exported scenes (project)

```gdscript
# Setter
func set_mana(new_mana: int) -> void:


# Initializer
func _init(init_mana: int) -> void:


# Exported PackedScene — snake_case, typed, no UpperCamelCase
@export var spell_effect_scene: PackedScene
```

### Node groups and animations (project)

Node group names are **plural snake_case**:
`spell_components`, `tower_floors`.

`AnimationPlayer` animation names are **kebab-case**:
`cast-begin`, `tower-collapse-large`.

### Inner classes (project)

A script with two or more inner classes separates them with a rule of hyphens, so the boundary is visible when scrolling:

```gdscript
class SomeClass:
	pass

# -----------------------------------------------------------------------------


class SomeOtherClass:
	pass
```

---

## Documentation comments

Rules:

- Document every **public** class, field and function whose purpose is **not** obvious from its name.
  `Spell.compute_mana_cost(components: Array[SpellComponent])` deserves a comment; `Wizard.add_gold(delta: int)` does not.
- If a method has non-trivial parameters or a non-trivial return value, document **all** of them, not just the confusing one.
- Write class and method descriptions in **third person present tense**:
  `Removes the last character from a String` — not `Remove the last character` and not `Will remove the last character`.
- First line is a one-sentence summary.
  Blank `##` line.
  Then detail.
- Use Godot's inline markup so the editor renders links:
  `[param mana]`, `[method cast]`, `[Tower]`, `[code]true[/code]`, `[br]` for a line break.

```gdscript
class_name SpellCaster
extends Node
## Casts spells built from components.
##
## Resolves a component list into an effect, charges the caster's mana and
## spawns the visual. Casting is refused when mana is insufficient;
## see [method can_cast].


## Casts [param spell] on behalf of [param caster].
##
## Returns [code]false[/code] and changes nothing when the caster cannot pay
## the mana cost, so the caller does not need to check beforehand.
func cast(spell: Spell, caster: Wizard) -> bool:
```

### Virtual properties

Some properties are decorated with getters/setters but deliberately hold no value.
Say so, or the next reader will go looking for the storage:

```gdscript
# Virtual property: nothing is stored here, the value exists only through the getter and setter.
```

---

## Typed collections instead of commented ones

Use the type system first.
Fall back to comments only for shapes the type system cannot express.

```gdscript
# Good — the type is checked by the engine.
var towers_by_village: Dictionary[StringName, Tower]
var unlocked_component_ids: Array[StringName]

# Only when a typed collection genuinely cannot express the shape:
## key: (StringName) component id
## value: (Dictionary) raw component definition as loaded from JSON
var _component_defs := { }
```

Typed arrays exist since Godot 4.0, typed dictionaries since 4.4.
We target 4.7, so both are available — there is no excuse for an untyped collection in a new file.

---

## Getting a custom class name at runtime

**First choice: the `is` keyword.**
Almost every real use of `is_class()` was a type check in disguise, and `is` is checked at compile time:

```gdscript
if node is Tower:
```

**When you need the name as a string** — a save file, a log line, a debug overlay — use `Script.get_global_name()` (Godot 4.3+):

```gdscript
var type_name := get_script().get_global_name()
```

⚠️ It returns an empty `StringName` for a script that has no `class_name`, and it does not work on inner classes.
Guard accordingly rather than assuming a value.

Do **not** try to override `get_class()` or `is_class()` to return the `class_name`.
Since Godot 4.1 those two methods can no longer be overridden at all, so code that does it fails outright.
Godot returns the *native* class from both, by design — see [godot#21789](https://github.com/godotengine/godot/issues/21789), still open.

---

## JSON and save data

Read dictionary values with a **default**, never with bare indexing.
A save file written by an older build must not crash the game:

```gdscript
# Good
var mana: int = json.get("mana", 0)

# Bad — both blow up or return null on an older save
var mana = json["mana"]
var mana = json.get("mana")
```

Objects that serialize themselves use these exact function names, so the pattern is greppable across the codebase:

```gdscript
func from_json_string_array(array: Array) -> void:


func from_json_dict(json: Dictionary) -> void:


func to_json_dict() -> Dictionary:
```

JSON keys and values use `snake_case`.

**Every save format gets a version field.**
`{"version": 3, ...}` from the very first commit.
Retrofitting a version field onto saves already in the wild is a migration you do not want to write.

---

## Node access

Avoid calling `get_node()` or using `$Some/Long/Path` repeatedly for the same node.
Store it once:

```gdscript
@onready var _mana_label: Label = $ManaBar/Label
```

Prefer **scene-unique names** (`%Name`, right-click a node → *Access as Unique Name*) over long `$` paths.
A unique name survives you moving the node around in the scene tree; a path does not:

```gdscript
@onready var _mana_label: Label = %ManaLabel
```

When a setter needs to touch an `@onready` field, it will run before `_ready()` the first time and the field will still be `null`.
Route both through a `_refresh_*` method that guards on `is_inside_tree()`:

```gdscript
var _wizard_name: String
@onready var _label: Label = %NameLabel


func _ready() -> void:
	_refresh_wizard_name()


func set_wizard_name(new_wizard_name: String) -> void:
	_wizard_name = new_wizard_name
	_refresh_wizard_name()


func _refresh_wizard_name() -> void:
	if not is_inside_tree():
		return
	_label.text = _wizard_name
```

---

## Referencing engine bugs

When code exists only to work around an engine bug, say which bug, with a link, so the workaround can be found and deleted later:

```gdscript
# Workaround for
# Godot #21789 (https://github.com/godotengine/godot/issues/21789):
# get_class() returns the native class rather than our class_name, so the type
# label is read from the script instead.
```

Format:
`Godot #12345 (https://github.com/godotengine/godot/issues/12345)`.

---

## Multiplayer code

**The server is authoritative; the client sends only its own input.**
The full authority model lives in `TECH_STACK.md`, section *Authority model*, and binds every networked line of code.

Two rules follow from it, because they are cheap now and expensive to retrofit:

- **Name the direction in the symbol.**
  A client asking the server for something is a `_request`; the server telling clients what happened is a `_sync` or a past-tense signal.
  `request_cast_spell()` / `floor_claimed`.
  Never a verb whose direction you have to guess.
- **Annotate every RPC explicitly.**
  Spell out all three arguments; never rely on defaults:

```gdscript
@rpc("any_peer", "call_remote", "reliable")
func request_cast_spell(spell_id: int) -> void:
```

`any_peer` means *any client can call this* — treat every parameter as hostile input and validate it server-side.
Mark it in the doc comment when a call is trusted.

---

## Tests

**Every rule of the game comes with a test that proves it.**
A rule without a test is a claim, and the author of this project reviews code without writing it, so the tests are what he can trust.

The project has its own small test runner, with no plugin.

| Path                           | Holds                                                                   |
| ------------------------------ | ----------------------------------------------------------------------- |
| `tests/run-tests.sh`           | The one command to run, from the `project/` folder.                     |
| `tests/run.gd`                 | The runner itself.                                                      |
| `tests/framework/`             | `TestCase`, the base of every test file, and its helpers. Never run.    |
| `tests/<area>/test_<topic>.gd` | The tests, one folder per area of the code: `core/`, `net/`, and so on. |

Running them:

```bash
tests/run-tests.sh                 # every test
tests/run-tests.sh res://tests/net # one folder
```

The run fails, and exits non-zero, when any of these happens:

- an assertion fails;
- the engine or a script raises an error while a test runs, since GDScript has no exceptions and a crashed test would otherwise look green;
- a test file does not load;
- no test is found at all;
- objects are still alive when the engine exits, which is a leak.

**Writing one.**
A test file extends `TestCase`, and every method whose name starts with `test_` is a test.
Each test gets a fresh instance, so nothing leaks from one test to the next.
Name a test after the rule it proves, as a sentence: `test_an_outdated_client_is_refused_and_told_why`.

```gdscript
extends TestCase


func test_a_hello_carries_its_version() -> void:
	assert_eq(Protocol.decode_hello(Protocol.encode_hello(42)), 42)
```

| Helper                                 | Use                                                                  |
| -------------------------------------- | -------------------------------------------------------------------- |
| `assert_eq`, `assert_ne`               | Values, type included: an `int` 1 is not a `float` 1.0.              |
| `assert_true`, `assert_false`          | Conditions; pass the value as the message so a failure shows it.     |
| `fail`                                 | A branch that must never run.                                        |
| `before_each`, `after_each`            | Set up and clean up around every test; both may `await`.             |
| `await wait_until(condition, timeout)` | Wait frame by frame for something to happen, two seconds by default. |
| `SignalWatcher.watch(some_signal)`     | Record a signal's emissions to inspect them afterwards.              |

**Prefer named methods to inline lambdas** in tests and elsewhere.
The formatter spreads every inline lambda over several lines, and a named method bound with `bind()` stays on one:
`wait_until(_server_has.bind(server, 1))`.

---

## Scene files (.tscn)

Node names are `PascalCase`.

One scene, one responsibility.
If a scene's root script is over ~300 lines, that is a signal to split the scene, not to keep scrolling.

---

## Shaders (.gdshader)

Every shader starts with a documentation comment:

```glsl
shader_type canvas_item;
/**
 * Tints the sprite toward the colour of the element currently charged in the
 * wizard's active spell slot.
 */
```

---

## Shell scripts (.sh)

Shell scripts start with a documentation comment.
If the script takes parameters, the comment includes example usage:

```bash
#!/usr/bin/env bash
###############################################################################
# Checks every identifier in the project against the Code column of
# docs/GLOSSARY.md and reports the ones that have no entry.
#
# Usage:
#   check-glossary.sh
#     Report mismatches on stdout, exit non-zero if any were found
#   check-glossary.sh --banned-only
#     Report only words listed under "Banned synonyms"
###############################################################################
set -euo pipefail
```

`set -euo pipefail` on every script.
A script that silently continues past a failed command is worse than no script.

---

## Third-party code and licence notices

Our own code is licensed as a whole, see `LICENSE.md`.
Two things in the repository are not ours and have to stay visibly separate.

**Addons.**
Anything installed from the Godot Asset Library, or copied from another project, lives under `addons/<name>/` and keeps its own licence file in place.

- Never reformat, relint or restyle third-party code to match this guideline.
  The diff noise makes the next upgrade painful, and under some licences the act of modifying carries its own obligations.
- Add the addon's licence to `license/` and a row to `CREDITS.md` in the **same commit** that adds the addon.
  Doing it later means doing it never.

**The engine.**
Godot is MIT, and an exported build embeds the engine, so the build has to carry Godot's copyright notice.
This is an obligation on the **distributed build, not on our source files** — no file of ours needs to be MIT because of Godot.

Satisfy it on a credits screen, sourcing the text from the engine itself so it can never drift out of date:

```gdscript
var license_text := Engine.get_license_text()
var components := Engine.get_copyright_info()
```

The Godot developers also accept a link to `godotengine.org/license` in the game's credits or documentation as sufficient.
Components bundled inside the engine that require their own attribution — FreeType, ENet, mbedTLS — are listed in the engine's `COPYRIGHT.txt`.
Ship that file with the build, renamed `GODOT_COPYRIGHT.txt`, so nobody mistakes it for ours.

---

# Markdown documentation style

Applies to every `.md` file in the repository, this one included.

The governing idea is **one sentence per line**, a technique known as *semantic line breaks*.
A one-word correction then produces a one-line diff, instead of reflowing a whole paragraph and burying the real change in noise.

## Line breaks

- **One sentence per line.**
  There is no column limit:
  the line ends where the sentence ends.
  If you cannot see where a line ends, it almost certainly holds two sentences — split it.
- **A colon that introduces something ends its line.**
  Whatever it introduces starts on the next line.
- **A colon used as a label stays inline.**
  `- **Engine:** Godot 4.7` and `SPDX identifier: CC-BY-NC-SA-4.0` are label-value pairs, not introductions, and breaking them would be absurd.
  The test:
  read the colon aloud as "namely" or "as follows", and if that works, break the line; if it reads as "is", keep it inline.
- **Never split inline code, a URL, a link or an emphasis span across two lines.**
  `like_this`, [a link](https://example.org/) and **bold** stay whole however long the line gets.
  A `**bold**` span split over two lines does not merely read badly — it stops rendering as bold at all.
- **One sentence per line applies inside list items too.**
  Never pack two or three sentences into a single bullet.
  Continuation lines are indented by two spaces so they line up with the item's text, exactly like this one.

## Blocks

- A list is always surrounded by blank lines.
- A code block is always surrounded by blank lines, **including inside a list item**.
- A fenced code block names its language, so GitHub and the editor highlight it.
  Use `text` when the content has no language.

```gdscript
var mana := 0
```

## Tables and tables of contents

Tables are the exception to every rule above.
Keep them readable rather than consistent.

- **Pad the pipes** so the columns line up in the raw source, the way `GLOSSARY.md` does.
  An unaligned table renders fine and edits terribly, and editing is where the time goes.
- Let a cell run long when splitting it would hurt.

A document long enough to need a table of contents puts it directly under the opening paragraph.
It includes the `#` title, with the `##` sections nested beneath it:

```markdown
- [Document title](#document-title)
  - [Contents](#contents)
  - [First section](#first-section)
  - [Second section](#second-section)
```

## Prose versus code

The limit in [Line length](#line-length-project) applies to **code**.
A comment written *inside* a fenced code block is code, so it stays under 100 characters and preferably under 80.

Prose outside a code block has **no column limit at all**, because one sentence per line already bounds it.

⚠️ This is the rule broken most often, including by the people who wrote it.
The failure looks like this:
prose wrapped at roughly 100 characters, mid-sentence, because the author carried the code limit over to the text.
A 200-character line holding exactly one sentence is correct.
A 95-character line holding half a sentence is not.

## What does not belong in public documentation

`README.md` is a shop window, not a design document.

🔴 **Hidden mechanics live in `docs/PAQUES.md`, and nowhere else.**
Everything stays available, but a player reading the documentation must be able to avoid spoilers.
Any other document that touches a hidden mechanic points to `PAQUES.md` instead of describing it, and `README.md` never mentions one.

When in doubt whether a mechanic is meant to be discovered, ask before writing it anywhere else.

The private design document holds everything else, and `.gitignore` keeps it out of this repository deliberately.

---

# Glossary

The `GLOSSARY.md` lives in its own file at the repository `docs` folder.
It is not decoration — it is the contract between the design documents and the identifiers in the code, and the `Code` column in it overrides anything you would have named by instinct.

---

# Appendix: Godot 3 traps

Most Godot material you will find — tutorials, Stack Overflow answers, Reddit threads, YouTube videos — still targets **Godot 3**.
This appendix exists so that a snippet copied from a 3.x source is recognised as one *before* it costs an evening.

⚠️ The documentation site has a version selector in the bottom-left corner.
A search engine will routinely land you on a 3.x page.
Check that it says `4.7` or `stable` before trusting anything on it.

| Godot 3                                               | Godot 4.7                                  |
| ----------------------------------------------------- | ------------------------------------------ |
| `tool`                                                | `@tool`                                    |
| `onready var`                                         | `@onready var`                             |
| `export var x`                                        | `@export var x`                            |
| `export (PackedScene) var FooScene`                   | `@export var foo_scene: PackedScene`       |
| `connect("sig", self, "method")`                      | `sig.connect(method)`                      |
| `emit_signal("sig", arg)`                             | `sig.emit(arg)`                            |
| `yield(obj, "signal")`                                | `await obj.signal`                         |
| `.method()` to call the parent                        | `super.method()`                           |
| `.shader` files                                       | `.gdshader` files                          |
| `PackedScene.instance()`                              | `PackedScene.instantiate()`                |
| `OS.get_ticks_msec()`                                 | `Time.get_ticks_msec()`                    |
| `Spatial`                                             | `Node3D`                                   |
| `KinematicBody2D`                                     | `CharacterBody2D`                          |
| untyped `Array` / `Dictionary` documented in comments | `Array[String]`, `Dictionary[String, int]` |

One trap is not a rename, so it deserves its own line:

**`get_class()` and `is_class()` cannot be overridden since Godot 4.1.**
A Godot 3 project would override them to make them return the `class_name`; that pattern no longer compiles.
Use `is`, or `Script.get_global_name()` — see [Getting a custom class name at runtime](#getting-a-custom-class-name-at-runtime).
