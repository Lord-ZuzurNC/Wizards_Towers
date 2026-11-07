# Pre-POC — ZITADEL

- [Pre-POC — ZITADEL](#pre-poc--zitadel)
  - [Question](#question)
  - [Setup](#setup)
  - [Results](#results)
  - [Conclusions](#conclusions)
  - [Run it](#run-it)

## Question

Can a Godot 4.7.2 client log a player in through a self-hosted ZITADEL, using the system browser, with no client secret shipped in the game?

## Setup

| Part     | Version                                                |
| -------- | ------------------------------------------------------ |
| Engine   | Godot 4.7.2 stable                                     |
| Identity | ZITADEL v4.16.0, API and Login UI v2 as two containers |
| Database | `postgres:17.10-alpine`                                |
| Proxy    | `traefik:v3.7.7`, published on `127.0.0.1:8080` only   |

The flow is OAuth 2.0 authorization code with PKCE and a loopback redirect, as RFC 8252 prescribes for native apps.
The game is registered as a **native** application with no client secret, since anything shipped in a game binary is public.
`login.gd` generates the PKCE verifier and a `state`, listens on `127.0.0.1:47123`, sends the player to ZITADEL, receives the code on the loopback, exchanges it, then reads the player's identity.

The upstream `docker-compose.yml` and `.env.example` are fetched by `run.sh` and not redistributed here.
`docker-compose.poc.yml` only adds an admin machine user, so the script can register the client and a test player.

## Results

Measured on 2026-11-07, from an empty Docker state, with the browser step driven by a headless Chromium on the real Login UI pages.

| Check                                 | Result                                                 |
| ------------------------------------- | ------------------------------------------------------ |
| Login UI pages                        | Login name, then password, then back to the loopback.  |
| `state` returned by the callback      | Matches the one Godot generated.                       |
| Token exchange with the PKCE verifier | HTTP 200, Bearer token valid 12 h, `id_token` present. |
| Same code exchanged a second time     | HTTP 400: a code is single use.                        |
| `userinfo` with the token             | HTTP 200, the player's `sub`, username and email.      |

Checked the same day on a first instance, by sending only the authorization request:

| Redirect URI                | Result                                       |
| --------------------------- | -------------------------------------------- |
| Another port on `127.0.0.1` | Accepted, with `devMode` on and with it off. |
| Another host                | HTTP 400, with `devMode` on and with it off. |

## Conclusions

ZITADEL is retained, as recorded in `docs/TECH_STACK.md`.
Any loopback port is accepted, so the shipped client should listen on a port the system picks, not a fixed one.
The token proves who the player is to the client; the game server must still verify it itself, by its signature or by introspection, before trusting it.
Social sign-in through Google, GitHub and GitLab is not covered: each needs a developer account on that provider.

## Run it

```bash
GODOT=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./run.sh             # opens the system browser
HEADLESS=1 GODOT=/path/to/Godot_v4.7.2-stable_linux.x86_64 ./run.sh  # prints the URL instead
./run.sh down                                                       # removes containers and data
```

It needs Docker and Python 3, generates fresh secrets into `.env` on first run, and listens on `127.0.0.1:8080` only.
The test player is `merlin`, password `Wiz4rd-Towers!poc`.
