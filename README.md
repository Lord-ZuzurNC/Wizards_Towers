# Wizards Towers

A competitive online game where wizards buy villages, raise towers, craft their own spells from runes, and climb a tower at the centre of the world that remembers everyone who climbed it before them.

> **Status: design phase.**
> There is no playable build yet, and no code in this repository.
> What is here is documentation, and it is published as it is written rather than when it is finished.
> Everything below describes intent, not a shipped feature.

## Contents

- [Wizards Towers](#wizards-towers)
  - [Contents](#contents)
  - [What it is](#what-it-is)
  - [The Monolith](#the-monolith)
  - [The run](#the-run)
  - [Spellcrafting](#spellcrafting)
  - [Documentation](#documentation)
  - [Technology](#technology)
  - [Building and running](#building-and-running)
  - [Contributing](#contributing)
  - [Licence](#licence)
  - [Credits](#credits)
  - [Contact](#contact)

## What it is

A **2D top-down, real-time, online multiplayer** game for around **50 wizards per world**.

Each world is **procedurally generated** and belongs to one server instance.
You wander it on foot, fight monsters and other wizards, and take villages — by paying for them or by completing a quest for the locals.
A village you own produces gold.
A **tower** built in a village produces mana, defends itself according to the upgrades you bought for it, and makes you a target.

PvP is always on in the open world.
The only shelters are instanced dungeons and the Monolith's Ground Floor.

## The Monolith

A single enormous tower at the centre of the world, and the reason the game ends.

- **Ground Floor** — a neutral safe lobby with merchants and a priest.
- **Floors 1 to 48** — each defended by a boss, each harder than the one below it, raidable in any order.
- **Floor 49** — a final boss, reachable only once every other floor has been raided by *somebody*, and then paid for in gold and mana.

Take a floor and you get an **Artifact**, one of a hundred world-unique runes.
You also get your name carved on a vast inscription hanging in the sky at the north edge of the world, listing every wizard who holds a floor and which one.
Being on that wall is not only glory:
it tells every rival you exist.

And the floor you took is now defended by **your echo** — a snapshot of you at the moment you won it, fighting with your stats, your weapon and your spells.
Echoes decay over time, so no floor stays sealed forever.
Someone will come for yours.

**Conquering Floor 49 ends the world.**

## The run

A world lives for **eight days**, divided into **four seasons of two days**.
Seasons change the world: crops, dungeon entrances, world boss strength.

If a wizard takes Floor 49 before winter ends, they win the run.
If nobody does, the world ends anyway when winter does.

Death is permanent, and almost everything is lost with it — villages, towers, floors, gold, runes, spells.
What survives is **Reincarnation Points**, earned from kills, dungeons, world bosses and floors, and spent between runs on **Talents**:
small permanent stat bonuses, other kinds of wizard, other weapons, and the chance for a rune you have unlocked to appear somewhere in your next world.

Unlocking a rune does not hand it to you.
It only makes it findable.

## Spellcrafting

Spells are not picked from a list; they are **built**, and their effects are **computed from their parts** rather than written by hand.

A spell is assembled from runes, each belonging to one attribute:

- **Shape**
- **Range**
- **Element**
- **Duration / cast speed**
- **Effect**

Runes come in **common**, **rare** and **legendary** grades, which change how strongly a rune acts rather than what it does.
**Artifacts** from the Monolith are rarer than any of them, and they corrupt the wizard who carries them.

Finished spells live in your **Grimoire**, whose level sets how many you may hold at once.
Replacing a spell already in place costs a mana-stone, so a build is a commitment.

Nobody is given a list of valid recipes.
Discovering combinations is the game.

## Documentation

- [`docs/GUIDELINES.md`](docs/GUIDELINES.md) — code, documentation and asset style guide, targeting Godot 4.7.
- [`docs/GLOSSARY.md`](docs/GLOSSARY.md) — the project's vocabulary, and the contract between the design documents and the identifiers in the code.

The design question-and-answer document that drives all of this is kept private deliberately, and is not part of this repository.

## Technology

- **Engine:** Godot 4.7 (GDScript).
- **Platforms:** Windows, Linux, macOS.
- **Server:** authoritative.
  Both public servers run by the author and privately hosted instances are planned.
- **Backend:** ⬜ **not decided.**
  Accounts, persistence, chat and the recovery log are still under discussion, as is whether the world simulation runs in a headless Godot process.
  Nothing here is committed to yet.
- **Modding:** skins only, through an in-game selector with packaged skin files.
  Skins are local to the player who installs them; the server never ships them to anyone else.

## Building and running

⬜ **TODO** — there is nothing to build yet.

This section will cover the Godot version required, how to open the project, and how to run a local server, once there is code to run.

## Contributing

⬜ **TODO** — contributions are not open yet.

Two things will be settled before the first pull request is accepted, not after:

- a **DCO or CLA**, so that contributions can be accepted without the author losing the ability to license the game differently later;
- a **linter** (`gdlint` / `gdformat`) wired into CI, so that [`docs/GUIDELINES.md`](docs/GUIDELINES.md) is enforced by a machine rather than by argument.

Bug reports and design discussion are welcome in the meantime.

## Licence

This project is **source-available, not open source**.
The wording is deliberate:
the Open Source Definition requires that commercial use be permitted, and these terms do not permit it.

| What                                   | Licence                                                                     |
| -------------------------------------- | --------------------------------------------------------------------------- |
| Source code                            | [PolyForm Noncommercial 1.0.0](LICENSE.md)                                  |
| Art and audio created for this project | [CC BY-NC-SA 4.0](LICENSE-ASSETS.md)                                        |
| Third-party code, art, audio, fonts    | their own terms — see [`license/`](license/) and [`CREDITS.md`](CREDITS.md) |
| Godot Engine                           | MIT, held by its own authors                                                |

In plain words:
download it, play it, read it, change it, fork it, share it — for any **noncommercial** purpose.
Not to make money.

**Name and branding.**
The names **"Wizards Towers"** and **"The Monolith"**, and the project's logos and visual identity, are **not covered by any licence above**.
All rights reserved.
A fork is free to exist; it is not free to call itself this game.

## Credits

[`CREDITS.md`](CREDITS.md) lists every third party whose work is used here, with its source, its licence and the date it was taken.
Credit is given whether a licence requires it or not.

## Contact

LordZNC — <lordznc@proton.me> — <https://github.com/Lord-ZuzurNC>
