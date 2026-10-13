<!--
  Wizards Towers - style and documentation guideline.

  Target engine: Godot 4.7.2 (stable).
-->

# Wizards Towers — style guideline

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

⬜ **OPEN** — a linter, we have none yet.
Candidates:
`gdlint`/`gdformat` from [godot-gdscript-toolkit](https://github.com/Scony/godot-gdscript-toolkit) (pip-installable, has a formatter, usable in CI).

### Upstream rules worth stating explicitly

These are the ones people break most often, so they are repeated here rather than left to a link:

- **Tabs** for indentation.
  Never spaces.
- **LF** line endings, **UTF-8 without BOM**, one trailing newline per file.
- **Two indent levels** for continuation lines, to distinguish them from a nested block.
  - Exception: arrays, dictionaries and enums use a single level.
- **Trailing comma** on the last element of a multi-line array, dictionary or enum.
  None on single-line ones.
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
`class_name YamlParser` lives in `yaml_parser.gd`.

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

The official guide says 100, and suggests 80 where you can.
For code we will use the upstream limitation.
For documentation we will do:
- One phrase per line.
  For lists the line should be preceeded by the appropriate number of white spaces.
  Tables are exception to keep it aestetic, thus, we should do best effort to keep it easy to read.
- A list is always surrounded by blank lines.
- A code block is surrounded by blank lines, even within a list

```codeblock
code
```

- Do not break `code line`, [urls](https://url/), **formatting**
- Semicolon always end a line and start a new one:
  like this new line.
  Except in comments (only document comments)
- Line of more than 200 characters should be considered in to phrases and so two lines, thus, this is not a strict requirement

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
  `Score.compute_score(level_stats: Dictionary)` deserves a comment; `Score.add_score(delta: int)` does not.
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
# Virtual property; the value is only exposed through the getter and setter.
```

---

## Typed collections instead of commented ones

Godot 4 does use the type system first; fall back to comments only for shapes the type system cannot express.

```gdscript
# Good — the type is checked by the engine.
var prefixes_by_mood: Dictionary[Creatures.Mood, Array]
var chat_links: Array[String]

# Only when a typed collection genuinely cannot express the shape:
## key: (String) component id
## value: (Dictionary) raw component definition as loaded from JSON
var _component_defs := {}
```

Typed arrays exist since Godot 4.0, typed dictionaries since 4.4.
We target 4.7, so both are available — there is no excuse for an untyped collection in a new file.

---

## Getting a custom class name at runtime

Use **the `is` keyword.**
Almost every real use of `is_class()` was a type check in disguise, and `is` is checked at compile time:

```gdscript
if node is Tower:
```

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
# Godot #40357 (https://github.com/godotengine/godot/issues/40357)
# to force the label to shrink to its minimum size. Without it the particles
# are mispositioned when the text shrinks.
```

Format:
`Godot #12345 (https://github.com/godotengine/godot/issues/12345)`.

---

## Multiplayer code

⬜ **OPEN — do not write networked code until ASK chapter 14 is answered.**
Server authority, hosting model and anti-cheat posture all change what the conventions must be.

Two rules can be committed to now, because they are cheap and expensive to retrofit:

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
 * Paints the opaque parts of the texture with a flat color.
 */
```

---

## Shell scripts (.sh)

Shell scripts start with a documentation comment.
If the script takes parameters, the comment includes example usage:

```bash
#!/usr/bin/env bash
###############################################################################
# Analyzes code and assets for stylistic errors, correcting them or printing
# them to the console.
#
# Usage:
#   delint.sh
#     Analyze code for stylistic errors, printing them to the console
#   delint.sh -c, delint.sh --clean
#     Correct simple errors which can be automatically corrected
###############################################################################
set -euo pipefail
```

`set -euo pipefail` on every script.
A script that silently continues past a failed command is worse than no script.

---

# Glossary

The `GLOSSARY.md` lives in its own file at the repository `docs` folder.
It is not decoration — it is the contract between the design documents and the identifiers in the code, and the `Code` column in it overrides anything you would have named by instinct.
