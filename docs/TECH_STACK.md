# Tech stack — Wizards Towers

This document records what the project is built with and why.
It is a decision record, not a tutorial.
Where a decision is deferred it carries ⬜ and says what would settle it.

## Engine and language

| Choice      | Decision                        | Notes                                                                           |
| ----------- | ------------------------------- | ------------------------------------------------------------------------------- |
| Engine      | **Godot 4.7.2 stable**          | Pinned. See `GUIDELINES.md`.                                                     |
| Language    | **GDScript**, statically typed  | Static typing is mandatory, not optional — see below.                            |
| Linting     | `gdlint` / `gdformat`           | From `godot-gdscript-toolkit`, pip-installable, runs in CI.                        |
| Second lang | **none**                        | No C#, no GDExtension, until a measured bottleneck demands one.                   |

**Static typing is mandatory because of who reviews this code.**
The project's author reads code but does not write it, so errors must surface at parse time rather than at runtime in front of fifty players.
A typed GDScript codebase gives most of C#'s review safety with none of its build toolchain.

## View and projection

**3/4 top-down, zoomed out.**
Square tiles, cardinal movement, buildings drawn with a visible façade.
This is the Pokémon-style oblique view, and it is **not** isometric.

| Property        | This project                      | True isometric would be              |
| --------------- | --------------------------------- | ------------------------------------ |
| Tile shape      | square                            | diamond, 2:1                          |
| Movement        | cardinal                          | diagonal-aligned                      |
| Ground circles  | drawn as circles                  | drawn as ellipses                     |
| Aiming          | direct mouse-to-world              | needs inverse projection              |
| Depth sorting   | Godot `Y-sort`                     | per-tile depth ordering               |

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

| Target                | Output                | Purpose                       |
| --------------------- | --------------------- | ----------------------------- |
| Windows client        | `.exe`                | Players.                       |
| Linux client          | x86_64 binary          | Players.                       |
| Linux dedicated server| x86_64 headless binary | Runs the world.                |

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

**SQLite only at launch.**

| Store             | Holds                                                                            | Lifetime        |
| ----------------- | -------------------------------------------------------------------------------- | --------------- |
| `accounts.db`     | Accounts, reincarnation points, talents, cosmetics, owned skins.                  | Forever.         |
| `world_<id>.db`   | One file per world: the map seed, villages, towers, floors, echoes, inventories, gold, spells, the run clock. | One run, 8 days. |

Why this and not more.
A single authoritative server process serialises every write, which is the workload SQLite is best at.
One file per world means a world cannot corrupt another, and a backup is a file copy.
Nothing to install, nothing to administer, no daemon to keep alive on a NAS.

**Writes that move value are transactional.**
Buying a village, paying for the ROOF, spending a stone and resolving a raid each commit as one transaction or not at all.

⬜ **PostgreSQL enters when a second world does.**
Two world processes writing one `accounts.db` contend on locks.
At that point accounts move to PostgreSQL and `world_<id>.db` stays SQLite per world.

⬜ **Redis enters only on a measured need.**
Its sorted sets are the right structure for the North Wall, and its pub/sub is the right channel between world processes.
Neither is justified at fifty players and one world, where a SQL query is faster to write and impossible to lose.
Redis is in-memory first, so anything it holds must be re-derivable or cheap to lose — never gold, never ownership.

## Crash recovery

**An 8-day run must survive the process dying on day 4.**
This is load-bearing from the first commit, not polish for later.

Three requirements:

- Every value-moving write is committed before it is acknowledged to the client.
- The run clock is **stored**, never inferred from process uptime.
- Server start detects an unfinished world and resumes it mid-season rather than creating a new one.

A restart must cost players a few seconds of position, never a minute of income or an hour of ownership.

## Hosting

**Phase one: a home NAS.**
Enough for development, playtesting and the first real world.

Four things that will bite, in order of likelihood:

**Residential upload is the bottleneck, not the CPU.**
Fifty clients receiving state updates is an upload problem, and home connections are asymmetric.

**The NAS cannot reboot mid-run.**
A power cut or an automatic update at hour 100 interrupts a world eight days long, which is exactly why crash recovery is not optional.

**A game server exposed from home is attack surface.**
Port forwarding, a firewall, fail2ban, and no service on that host that does not need to be there.

⬜ **The NAS model is unrecorded.**
A low-power ARM NAS will struggle with fifty players plus echo AI plus enemy simulation. Record the CPU and the upload rate, then measure before trusting it.

**Phase two: a real server**, when the first world fills or the upload saturates.

## Multiple worlds

A second world opens when either the queue fills to fifty, or the first world reaches **autumn**.

The autumn trigger is deliberate: it staggers world end times instead of letting every world finish at once.
Its consequence is the PostgreSQL migration above, because overlapping worlds mean concurrent writers on accounts.

## Accounts and identity

Reincarnation points, talents and cosmetics survive death and cross worlds, so the project needs persistent identity.

⬜ The authentication method is undecided.
The options are a self-hosted account with email and password, or delegating to an external identity provider.
Self-hosting means owning password storage and reset flows; delegating means a dependency the project does not control.

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

| Channel           | Role                                           |
| ----------------- | ---------------------------------------------- |
| GitHub Releases   | Primary. Matches the source-available posture.  |
| itch.io           | Player-facing home for a noncommercial build.   |
| Steam             | Rejected. Its model expects commercial distribution. |

Linux is distributed as a binary in an archive first.
⬜ Whether to add an AppImage, and later a Flatpak, is a convenience decision to revisit once there are players.

## What is deliberately absent

No engine plugins, no GDExtension, no second language, no ECS framework, no network library beyond Godot's own ENet multiplayer.
Every one of those is a dependency a solo project must then maintain.
They get added when something measured demands them, and the measurement goes in this document.
