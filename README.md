# CircuitCraft Vanilla++

A lightweight **Fabric** modpack for **Minecraft 26.2** — vanilla gameplay kept intact, with
quality-of-life, performance and worldgen additions on top. No tech, magic or recipe overhauls.

The pack is managed with [pakku](https://github.com/juraj-hrivnak/Pakku) and targets Modrinth,
and it ships together with a ready-to-run Fabric server that distributes the client mods
automatically via [AutoModpack](https://modrinth.com/project/automodpack).

| | |
|---|---|
| Pack version | `2.0.0` |
| Minecraft | `26.2` |
| Loader | Fabric `0.19.3` |
| Author | SelfRef |
| Mods | 34 (15 both sides · 9 client-only · 10 server-only) |

## Requirements

- [pakku](https://github.com/juraj-hrivnak/Pakku) CLI on `PATH` as `pakku-mc` (used to resolve and fetch mods)
- Java 21+ to run the server
- `curl` and `zip` for [export.sh](export.sh)

## Repository layout

```
pakku.json            pack manifest (name, version, author, overrides)
pakku-lock.json       resolved mod list — exact versions, hashes and download URLs
export.sh             fetches mods, builds a runnable server dir and server.zip
server/               server instance: properties, configs, AutoModpack setup, run.sh
build/                pakku export output — .mrpack and server pack (git-ignored)
```

`server/mods/`, `server/*.jar`, `build/` and `*.zip` are all git-ignored — every jar is
reproducible from [pakku-lock.json](pakku-lock.json).

## Mods

### Both sides

| Mod | Purpose |
|---|---|
| [Fabric API](https://modrinth.com/mod/fabric-api) | Core hooks required by most mods |
| [Architectury API](https://modrinth.com/mod/architectury-api), [Balm](https://modrinth.com/mod/balm), [Cloth Config API](https://modrinth.com/mod/cloth-config), [Text Placeholder API](https://modrinth.com/mod/placeholder-api) | Library dependencies |
| [Lithium](https://modrinth.com/mod/lithium) | Server-side tick optimisation |
| [FerriteCore](https://modrinth.com/mod/ferrite-core) | Lower memory usage |
| [Clumps](https://modrinth.com/mod/clumps) | Groups XP orbs to cut entity count |
| [Collective](https://modrinth.com/mod/collective) | Shared library for the QoL mods |
| [Roughly Enough Items](https://modrinth.com/mod/rei) | Recipe and item lookup |
| [Jade](https://modrinth.com/mod/jade) | Looked-at block/entity tooltip |
| [JourneyMap](https://modrinth.com/mod/journeymap) | Minimap and world map |
| [AppleSkin](https://modrinth.com/mod/appleskin) | Food saturation and hunger info |
| [No Chat Reports](https://modrinth.com/mod/no-chat-reports) | Disables chat reporting/signing |
| [AutoModpack](https://modrinth.com/mod/automodpack) | Syncs mods and configs from the server to clients |

### Client-only

| Mod | Purpose |
|---|---|
| [Sodium](https://modrinth.com/mod/sodium), [ImmediatelyFast](https://modrinth.com/mod/immediatelyfast) | Rendering performance |
| [Iris Shaders](https://modrinth.com/mod/iris) | Shader pack support |
| [Continuity](https://modrinth.com/mod/continuity) | Connected textures |
| [Visuality](https://modrinth.com/mod/visuality) | Extra ambient particles |
| [Sound Physics Remastered](https://modrinth.com/mod/sound-physics-remastered) | Reverb and sound occlusion |
| [Chat Heads](https://modrinth.com/mod/chat-heads) | Player faces next to chat messages |
| [Mod Menu](https://modrinth.com/mod/modmenu) | In-game mod list and config screens |
| [Resource Pack Overrides](https://modrinth.com/mod/resource-pack-overrides) | Forces the pack's default resource pack set |

### Server-only

| Mod | Purpose |
|---|---|
| [MVS](https://modrinth.com/mod/moogs-voyager-structures), [MES](https://modrinth.com/mod/mes-moogs-end-structures), [MNS](https://modrinth.com/mod/mns-moogs-nether-structures) + [Moog's Structure Lib](https://modrinth.com/mod/moogs-structure-lib) | Extra structures in the Overworld, End and Nether |
| [Server-Side Waystones](https://modrinth.com/mod/sswaystones) | Fast travel, no client mod needed |
| [Universal Graves](https://modrinth.com/mod/universal-graves) | Death graves with a death compass |
| [Anvil Restoration](https://modrinth.com/mod/anvil-restoration) | Removes the "Too Expensive!" anvil cap |
| [NetherPortalFix](https://modrinth.com/mod/netherportalfix) | Consistent portal linking |
| [Villager Names](https://modrinth.com/mod/villager-names-serilum) | Named villagers (custom name list) |
| [Polymer](https://modrinth.com/mod/polymer) | Server-side GUIs/content for vanilla clients |

## Building

Mods are fetched from the lock file, so builds are byte-identical for everyone:

```sh
pakku-mc fetch            # download all jars into ./mods
pakku-mc export           # write build/modrinth/*.mrpack and build/serverpack/*.zip
```

Common maintenance commands:

```sh
pakku-mc add <slug>       # add a mod
pakku-mc rm <slug>        # remove a mod
pakku-mc update --all     # bump every mod to its newest 26.2 build
pakku-mc ls               # list the pack contents
```

Bump `version` in [pakku.json](pakku.json) when publishing a new pack revision — it becomes the
`.mrpack` version and the server pack directory name.

## Server

[export.sh](export.sh) produces a complete, runnable server:

```sh
./export.sh
```

It fetches the mods, moves them into `server/mods/`, downloads the Fabric server launcher
(loader `0.19.3`, installer `1.1.2`) as `server/server-fabric.jar`, and zips everything into
`server.zip` for upload to a host.

Start it with:

```sh
cd server && ./run.sh          # java -Xmx2G -jar server-fabric.jar nogui
```

Raise `-Xmx` in [server/run.sh](server/run.sh) if you run more than a handful of players.

### Server settings

Notable values in [server/server.properties](server/server.properties):

- MOTD `§3Circuit§6Craft §aVanilla§e++`, world seed `circuitcraft`
- Difficulty **hard**, survival, `force-gamemode=true`
- **Whitelist on and enforced** — add players with `/whitelist add <name>`
- View and simulation distance `12`
- `pause-when-empty-seconds=60`, `player-idle-timeout=60`

`eula.txt` is already accepted. Structure and QoL data packs (`mes`, `mns`, `mvs`, `sswaystones`,
`universal-graves`, `collective`, `balm`) are enabled via `initial-enabled-packs`.

### Client distribution via AutoModpack

The server hosts the modpack itself — see
[server/automodpack/automodpack-server.json](server/automodpack/automodpack-server.json). It is
generated on every start and pushes these to connecting clients:

- `mods/*.jar` (server-only mods are excluded automatically)
- `config/collective.json5`, `config/resourcepackoverrides.json`,
  `config/universal-graves/config.json`, `config/villagernames/customnames.txt`

AutoModpack is **not required** to join (`requireAutoModpackOnClient: false`); vanilla clients get
a chat prompt suggesting Fabric + AutoModpack instead.

### Installing the client manually

Alternatively, import `build/modrinth/CircuitCraft Vanilla++-<version>.mrpack` into the
[Modrinth App](https://modrinth.com/app), Prism Launcher or ATLauncher — any launcher with
`.mrpack` support.

## Server configs

| File | What is customised |
|---|---|
| [server/config/villagernames/customnames.txt](server/config/villagernames/customnames.txt) | ~300 Polish given names for villagers |
| [server/config/universal-graves/config.json](server/config/universal-graves/config.json) | Graves never expire, keep 100% XP, free unlocking, death compass enabled |
| [server/config/collective.json5](server/config/collective.json5) | Update checker off, server language `en_us` |
| [server/config/resourcepackoverrides.json](server/config/resourcepackoverrides.json) | Enables Continuity and Polymer resource packs by default |
