# Tech stack — Wizards Towers

This document records what the project is built with and why.
It is a decision record, not a tutorial.
Where a decision is deferred it carries ⬜ and says what would settle it.

- [Tech stack — Wizards Towers](#tech-stack--wizards-towers)
  - [Engine and language](#engine-and-language)
  - [View and projection](#view-and-projection)
  - [Client and server](#client-and-server)
  - [Authority model](#authority-model)
  - [Persistence](#persistence)
  - [Crash recovery](#crash-recovery)
  - [Hosting](#hosting)
  - [Multiple worlds](#multiple-worlds)
  - [Accounts and identity](#accounts-and-identity)
  - [Protocol version](#protocol-version)
  - [Skins](#skins)
  - [Release](#release)
  - [What is deliberately absent](#what-is-deliberately-absent)

## Engine and language

| Choice      | Decision                       | Notes                                                            |
| ----------- | ------------------------------ | ---------------------------------------------------------------- |
| Engine      | **Godot 4.7.2 stable**         | Pinned. See `GUIDELINES.md`.                                     |
| Language    | **GDScript**, statically typed | Static typing is mandatory, not optional — see below.            |
| Linting     | `gdscript-formatter`           | GDQuest's formatter and linter, one binary. See `GUIDELINES.md`. |
| Second lang | **none**                       | No C#, no GDExtension, until a measured bottleneck demands one.  |

**Static typing is mandatory because of who reviews this code.**
The project's author reads code but does not write it, so errors must surface at parse time rather than at runtime in front of fifty players.
A typed GDScript codebase gives most of C#'s review safety with none of its build toolchain.

## View and projection

**3/4 top-down, zoomed out.**
Square tiles, cardinal movement, buildings drawn with a visible façade.
This is the Pokémon-style oblique view, and it is **not** isometric.

| Property       | This project          | True isometric would be  |
| -------------- | --------------------- | ------------------------ |
| Tile shape     | square                | diamond, 2:1             |
| Movement       | cardinal              | diagonal-aligned         |
| Ground circles | drawn as circles      | drawn as ellipses        |
| Aiming         | direct mouse-to-world | needs inverse projection |
| Depth sorting  | Godot `Y-sort`        | per-tile depth ordering  |

Three reasons this view and not another.

**Seven of the twenty-one Shape runes are `placed`**, resolving on the ground.
A circle stays a circle, a `Pool` stays round, and the `Trident`'s forty-five degrees means the same thing on screen as in the world.

**Aiming is a competitive act.**
PvP is always on outside safe zones and spells are directional, so mouse-to-world must be exact and predictable.

**The Monolith is vertical, and it is the centrepiece.**
A pure overhead view renders the tower as a circle on the ground.
The 3/4 angle gives it height, and gives village towers theirs.

## Client and server

**One project, one language, one repository.**
Godot 4 has a native dedicated-server export that strips rendering and audio, plus a `--headless` runtime flag.
Client and server branch on `OS.has_feature("dedicated_server")`.

Three export targets:

| Target                 | Output                 | Purpose         |
| ---------------------- | ---------------------- | --------------- |
| Windows client         | `.exe`                 | Players.        |
| Linux client           | x86_64 binary          | Players.        |
| Linux dedicated server | x86_64 headless binary | Runs the world. |

## Authority model

**The server is authoritative over everything that can be stolen.**
That is not a preference, it is a requirement of the design: wizards take villages, towers, floors, gold and Artifacts from each other.

Server-authoritative, with no exception:

- gold, mana, income, and every price
- ownership of villages, towers, floors and Artifacts
- all stats, all damage, all death
- rune and spell inventories, and the computed cost of a spell
- loot rolls, drops, and every roll involving `luck`
- season transitions and the run clock

The client is authoritative over one thing only: **its own input**.
It may predict its own movement for responsiveness; the server corrects it.

A client that could set a number could set its own gold, and one cheater ends a world in an hour.

## Persistence

**PostgreSQL, from the first commit.**
One database server holds everything that persists.

| Data     | Holds                                                                                                          | Lifetime         |
| -------- | -------------------------------------------------------------------------------------------------------------- | ---------------- |
| accounts | Accounts, reincarnation points, talents, cosmetics, owned skins.                                               | Forever.         |
| worlds   | Keyed by `world_id`: the map seed, villages, towers, floors, echoes, inventories, gold, spells, the run clock. | One run, 8 days. |

Why PostgreSQL from the start.
Worlds overlap by design, so several world processes write the same accounts as soon as a second world opens.
Starting on the final store removes a migration that would otherwise land in the middle of a live run.
Schema changes are transactional in PostgreSQL, so a failed migration rolls back instead of leaving a half-changed database.

**Writes that move value are transactional.**
Buying a village, paying for the ROOF, spending a stone and resolving a raid each commit as one transaction or not at all.

**Stores considered and rejected.**

| Store       | Why not                                                                                        |
| ----------- | ---------------------------------------------------------------------------------------------- |
| SQLite      | One writer per file; overlapping worlds would contend on a shared accounts file.               |
| MariaDB     | Viable, but a schema migration cannot be rolled back as one transaction.                       |
| MongoDB     | SSPL licence, not open source, and a document model for data made of ownership transfers.      |
| ArangoDB    | Business Source Licence, not open source.                                                      |
| VoltDB      | Its public repository no longer exists.                                                        |
| TimescaleDB | A PostgreSQL extension for time series; addable later on the same server if analytics need it. |

**The game server reaches PostgreSQL through PostgREST.**
Godot ships no PostgreSQL driver, and the reference pure-GDScript client is archived, untouched since March 2023.
PostgREST (MIT) exposes the database as an HTTP API on the private network, and Godot calls it with its own `HTTPRequest`.

| Rule                                               | Why                                                                                       |
| -------------------------------------------------- | ----------------------------------------------------------------------------------------- |
| Tables live in a schema never exposed.             | PostgREST only publishes the `api` schema, so a table cannot be read or written directly. |
| One value-moving write is one SQL function.        | A call is one transaction: it commits whole or leaves nothing behind.                     |
| Rows that move value are locked with `FOR UPDATE`. | Two simultaneous purchases with gold for one cannot both succeed.                         |
| `HTTPRequest.use_threads` is on.                   | Without it a call waits on the frame loop.                                                |
| Only the game server talks to PostgREST.           | A client never does.                                                                      |

Spike of 2026-11-07, Godot 4.7.2 headless against PostgreSQL 17 and PostgREST 16.5:

- A purchase succeeds, and a purchase without enough gold is refused.
- A function that debits then fails leaves gold and ownership untouched.
- Two purchases fired in the same frame, with gold for only one, give exactly one success; the second waits for the first lock, then sees the new balance.
- Writing to a table directly returns 404.
- A call takes about 1 ms at PostgREST, 7 ms from Godot with `use_threads`, and 34 ms without it.

Rejected routes: a GDExtension over `libpq`, which is a C++ binding to maintain, and a small service in another language, which is a second codebase.

⬜ **A cache enters only on a measured need.**
Sorted sets are the right structure for the North Wall, and pub/sub is the right channel between world processes.
Neither is justified at fifty players and one world, where a SQL query is faster to write and impossible to lose.
If a cache enters, it is **Valkey** (BSD-3-Clause), not Redis, whose licence has changed twice since 2024.
A cache is in-memory first, so anything it holds must be re-derivable or cheap to lose — never gold, never ownership.

## Crash recovery

**An 8-day run must survive the process dying on day 4.**
This is load-bearing from the first commit, not polish for later.

Three requirements:

- Every value-moving write is committed before it is acknowledged to the client.
- The run clock is **stored**, never inferred from process uptime.
- Server start detects an unfinished world and resumes it mid-season rather than creating a new one.

A restart must cost players a few seconds of position, never a minute of income or an hour of ownership.

## Hosting

**Internal test: the home NAS, and nothing more.**
It never runs a public world.

| Part    | Value                                                      |
| ------- | ---------------------------------------------------------- |
| Model   | UGREEN DXP2800 GT                                          |
| CPU     | AMD Ryzen Embedded R2514, 4 cores, 8 threads               |
| Memory  | 8 GB DDR4-3200                                             |
| Storage | 2 × 1 TB M.2 SSD in RAID 0, 2 × 16 TB WD Red Pro in RAID 1 |

**The test database never relies on the RAID 0 volume alone.**
RAID 0 loses everything if either SSD fails, so the PostgreSQL data lives on the RAID 1 volume or is backed up off the array.

⬜ **Public worlds: a dedicated host, not chosen yet.**
Settled by the upload measured per player during the internal test, multiplied by fifty.

Three constraints the public host must meet:

**Upload is the bottleneck, not the CPU.**
Fifty clients receiving state updates is an upload problem.

**The host cannot reboot mid-run.**
A power cut or an automatic update at hour 100 interrupts a world eight days long, which is exactly why crash recovery is not optional.

**A game server is attack surface.**
A firewall, fail2ban, and no service on that host that does not need to be there.

## Multiple worlds

A second world opens when either the queue fills to fifty, or the first world reaches **autumn**.

The autumn trigger is deliberate:
it staggers world end times instead of letting every world finish at once.
Overlapping worlds mean concurrent writers on accounts, which is why persistence starts on PostgreSQL.

## Accounts and identity

Reincarnation points, talents and cosmetics survive death and cross worlds, so the project needs persistent identity.

**Local accounts, with optional sign-in through Google, GitHub or GitLab.**

**Identity lives in a self-hosted OpenID Connect provider, never in GDScript.**
Godot's `Crypto` class has no password-hashing function, so storing passwords in game code would mean writing one.
The provider owns password storage, resets, email verification and two-factor, and brokers the Google, GitHub and GitLab sign-ins, so the game only ever sees one kind of account.

The login flow follows OAuth 2.0 for native apps (RFC 8252, with PKCE):

- The game opens the system browser on the provider's login page.
- The player signs in there, locally or through a social account.
- The token returns to the game through a loopback redirect.
- The game server validates the token with the provider before accepting the connection.

**The provider is ZITADEL** (AGPL-3.0), on PostgreSQL alone.
It is built for customer identity, the case of strangers signing themselves up.
Since v4 its login page is a second container, routed on the same domain as the API.
It runs as its **own instance**, never the one guarding the homelab: an identity provider open to public sign-up must not also hold the keys to private services.
The AGPL binds only a modified copy offered over the network; running it unmodified imposes nothing on this project.
A loopback login from Godot is verified, see `pre-POCs/zitadel/`; any loopback port is accepted, so the client listens on one the system picks.
⬜ Still to verify: the three social sign-ins, which need a developer account on each provider.

## Protocol version

**The client checks a protocol version at connect and is refused on mismatch.**
A client one version behind, talking to a shared authoritative world, corrupts state for forty-nine other players.
The version is bumped whenever a message shape or a persisted field changes.

## Skins

A skin is a **`.zip`** loaded with `ProjectSettings.load_resource_pack()`, Godot's native resource-pack API.

`.pck` was rejected: it requires Godot's export tooling, which locks out any modder without the SDK.
A `.zip` loads through the same call and can be made with any archiver.

Each archive carries a `skin.json` manifest with name, author and version for the in-game selector.
Scope is the wizard's body and robes only — never weapons, because a wizard visibly wears what they carry and that sight is information a rival is entitled to.

## Release

| Channel         | Role                                                 |
| --------------- | ---------------------------------------------------- |
| GitHub Releases | Primary. Matches the source-available posture.       |
| itch.io         | Player-facing home for a noncommercial build.        |
| Steam           | Rejected. Its model expects commercial distribution. |

Before 1.0, Linux is distributed as a binary in an archive.
With the PCK embedded, a Godot export is already a single executable.
⬜ From 1.0, Linux ships as an AppImage or a Flatpak, whichever proves better at that point.

## What is deliberately absent

No engine plugins, no GDExtension, no second language, no ECS framework, no network library beyond Godot's own ENet multiplayer.
Every one of those is a dependency a solo project must then maintain.
They get added when something measured demands them, and the measurement goes in this document.
