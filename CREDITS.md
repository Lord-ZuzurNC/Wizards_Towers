# Credits and asset provenance

Two jobs in one file.

**Credit**, because the author of this project intends to credit every contributor whether a licence demands it or not.

**Provenance**, because a licence is not a defence on its own.
No licence protects you from someone who uploaded work they never owned, then watched a third party claim it later — the "non-copyrighted" asset that turns out to be very much copyrighted.
Creative Commons licences disclaim warranties explicitly.
What *does* defend you is a record showing where every file came from, under what terms, and on what date.

🔴 **The rule: no third-party asset enters this repository without its row in this table and its licence text in [`license/`](license/), in the same commit.**

## How to fill a row

- **Asset** — what it is, and the path it lives at.
- **Author** — the name as the author writes it.
  Credit them the way they asked to be credited.
- **Source** — the exact page the file came from, not the site's home page.
- **Licence** — SPDX identifier where one exists (<https://spdx.org/licenses/>), otherwise `CUSTOM` plus a pointer to the file in `license/`.
- **Added** — the date you downloaded it.
  This is the field that proves what the terms were *at the time*, which matters when a page changes later.
- **Archived** — a snapshot of the licence page, taken on the day you downloaded the asset.
  Save it to the Wayback Machine (<https://web.archive.org/save/>) and record the resulting URL.
  A link to a page that may be edited is not evidence; a dated snapshot is.
- **In repo** — `yes` if the file is committed, `build-only` if its licence forbids redistributing the raw file so it is gitignored and shipped only inside builds.

## Engine and libraries

| Component        | Author                                                  | Source                             | Licence | Added      | In repo    |
| ---------------- | ------------------------------------------------------- | ---------------------------------- | ------- | ---------- | ---------- |
| Godot Engine 4.7 | Godot Engine contributors; Juan Linietsky; Ariel Manzur | <https://godotengine.org/license/> | `MIT`   | 2026-10-15 | build-only |

Godot's full notice, reproduced as the MIT licence requires:

```text
Copyright (c) 2014-present Godot Engine contributors.
Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.
```

The build must carry this notice, plus the engine's own `COPYRIGHT.txt` renamed `GODOT_COPYRIGHT.txt`, which lists the bundled components that require their own attribution — FreeType, ENet and mbedTLS among them.
See [`license/README.md`](license/README.md) for how the credits screen sources this text from the engine itself.

## Art

| Asset           | Author | Source | Licence | Added | Archived | In repo |
| --------------- | ------ | ------ | ------- | ----- | -------- | ------- |
| *(nothing yet)* |        |        |         |       |          |         |

## Audio and music

| Asset           | Author | Source | Licence | Added | Archived | In repo |
| --------------- | ------ | ------ | ------- | ----- | -------- | ------- |
| *(nothing yet)* |        |        |         |       |          |         |

## Fonts

| Asset           | Author | Source | Licence | Added | Archived | In repo |
| --------------- | ------ | ------ | ------- | ----- | -------- | ------- |
| *(nothing yet)* |        |        |         |       |          |         |

## Addons and third-party code

| Addon           | Author | Source | Licence | Added | In repo |
| --------------- | ------ | ------ | ------- | ----- | ------- |
| *(nothing yet)* |        |        |         |       |         |

Third-party code is never reformatted or relinted to match this project's style guide.
The diff noise makes the next upgrade painful, and under some licences the act of modifying carries its own obligations.

## Original work

Art, audio and code created for this project are the author's own.

- Code — [`LICENSE.md`](LICENSE.md), PolyForm Noncommercial 1.0.0.
- Art and audio — [`LICENSE-ASSETS.md`](LICENSE-ASSETS.md), CC BY-NC-SA 4.0.

## Thanks

People and projects whose work shaped this one without a licence being involved.

- *(to fill in)*
