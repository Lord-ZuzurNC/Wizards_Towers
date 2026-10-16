# Third-party licences

Every piece of code, art, audio or font in this repository that was **not created for this project** keeps its own licence, and that licence lives here as a file.

This folder is the legal shelf.
[`../CREDITS.md`](../CREDITS.md) is the index that says what each shelf entry is for.
They are maintained together, in the same commit, or not at all.

## The rule

🔴 **No third-party asset enters the repository without, in the same commit:**

1. its licence text copied into this folder;
2. its row added to [`../CREDITS.md`](../CREDITS.md).

Later means never.
A folder of assets whose origin nobody remembers is unshippable, and untangling it after two hundred commits costs more than the assets were worth.

## Naming

One file per source, named after the source, with the SPDX identifier in the name:

```text
license/kenney-nl.CC0-1.0.txt
license/some-artist-tileset.CC-BY-4.0.txt
license/example-addon.MIT.txt
```

Use the SPDX short identifier where one exists — see <https://spdx.org/licenses/>.
Where the licence is a custom EULA with no SPDX identifier, use `.CUSTOM.txt` and quote the EULA in full.

## What to copy

Copy the **licence text itself**, not a link to it.
A URL can die, change or be edited; a file in git cannot.
Where the licence requires a copyright notice, copy that notice into the same file.

For a paid asset pack, also copy the clauses that constrain **redistribution**, because this repository is public and committing an asset file *is* redistributing it.
If the EULA forbids redistributing the raw files, the asset does not belong in git at all — it is gitignored and shipped only inside builds, and `CREDITS.md` records that decision.

## Licence compatibility

The game's code is **PolyForm Noncommercial 1.0.0**, which is not an open source licence.
That constrains what can be brought in.

| Third-party licence                       | Usable here                                                                             |
| ----------------------------------------- | --------------------------------------------------------------------------------------- |
| CC0, MIT, BSD, Apache-2.0, MPL-2.0        | ✅ yes                                                                                   |
| CC BY 4.0                                 | ✅ yes, attribution required                                                             |
| CC BY-SA 4.0                              | ⚠️ yes for assets, but adaptations of the asset must stay BY-SA — segregate and document |
| Any **NC** variant (CC BY-NC, BY-NC-SA…)  | ❌ no — it would block the author from ever earning money from the game                  |
| Any **ND** variant (CC BY-ND, BY-NC-ND)   | ❌ no — forbids resizing, recolouring or editing                                         |
| GPL, AGPL, or any strong copyleft on code | ❌ no — incompatible with PolyForm Noncommercial                                         |

The filter in one sentence: **commercial use allowed, modification allowed, redistribution allowed, perpetual and irrevocable.**

## The engine

The Godot Engine is MIT and is **not vendored here** — it is a build-time dependency.
Its obligation lands on the **distributed build**, not on this repository.

The build must therefore ship Godot's copyright notice, and the engine's own `COPYRIGHT.txt` renamed `GODOT_COPYRIGHT.txt` so nobody mistakes it for ours.
Components bundled inside the engine that require their own attribution — FreeType, ENet, mbedTLS — are listed in that file.

The credits screen should source the text from the engine itself, so it cannot drift:

```gdscript
var license_text := Engine.get_license_text()
var components := Engine.get_copyright_info()
```

## Current contents

Nothing yet.
The first asset to arrive brings the first file.
