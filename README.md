# The Intruder

A Project Zomboid **Build 42** multiplayer mod. On a public server running the mod,
strangers can slip into your game as hostile **intruders** whose goal is to make your
survival harder, a Watch Dogs style invasion.

---

## How it works

- A new **The Intruder** entry appears in the main menu, next to *Multiplayer*.
- It opens a window listing the **public servers running this mod**, plus a direct
  connect by IP for local or private servers.
- **Joining a server through this window makes you the intruder.** Joining a server
  normally makes you a regular survivor.
- When an intruder arrives, they spawn near a random survivor with a loadout, everyone
  else gets an anonymous alert, and (optionally) PvP is turned on for everyone.

Intruders are identified by a forced `_TI` suffix on their profile name, so the server
knows who is an intruder without any manual setup.

## Features

- **Server browser** filtered to servers running the mod, with a direct connect by IP.
- **Reusable profile** (name, password, Steam relay) saved locally. The password
  defaults to your Steam ID if left empty.
- **Server-side kit**: intruders receive a configurable loadout on spawn (authoritative,
  synced properly).
- **Spawn near a survivor**: the server places the intruder close to a random normal
  player.
- **Map tracking**: on the world map, the intruder sees every survivor as a live marker.
- **Arrival alert**: survivors get a banner and an alarm sound (with a smooth fade),
  without knowing who or where the intruder is.
- **Force PvP** (optional): when an intruder arrives, everyone's safety is turned off so
  they can fight.
- **Host controls** (admin only, `Home` key): toggle the invasion on/off, kick or ban an
  intruder.
- **Max intruders** limit and **respawn cooldown** on death, both enforced server-side.
- Available in **12 languages**.

## Requirements

- Project Zomboid **Build 42**.
- For intruders to actually deal damage, the server must have **`PVP = true`**. The host
  control panel warns you if PvP is off. For a full free-for-all, also set
  `SafetySystem = false`.

## Installation

**Steam Workshop**: subscribe to the mod, then enable it in the server's and clients' mod
list.

**Manual**: copy the `TheIntruder` folder into `%UserProfile%\Zomboid\mods\`, then enable
it in the Mods menu. On a dedicated server, add `TheIntruder` to `Mods=` in the server
config.

## Sandbox settings

A dedicated **The Intruder** page is added to the sandbox options:

| Option | Range / values | Default |
|---|---|---|
| Max intruders | 1 – 32 | 2 |
| Spawn distance (tiles) | 5 – 100 | 30 |
| Respawn cooldown (seconds) | 0 – 3600 | 120 |
| Force PvP on intruder arrival | on / off | on |
| Melee weapon | None / Random / Baseball bat / Hunting knife / Crowbar | Random |
| Bag | None / Schoolbag / Duffel bag / Big hiking bag | Schoolbag |
| Canned food amount | 0 – 10 | 2 |
| First aid kit | on / off | on |
| Extra items | item ids separated by `;` (e.g. `Base.Pistol;Base.Bullets9mm`) | empty |

## Host controls

While in game as an **admin**, press **`Home`** to open the host panel:

- Toggle the invasion **open / closed** (closing it also kicks the current intruders).
- **Kick** or **ban** a connected intruder.

## Languages

English, French, German, Spanish, Italian, Portuguese (Brazil), Russian, Polish,
Simplified Chinese, Japanese, Korean, Turkish.

## License

Released under the [MIT License](LICENSE) © 2026 Maxime66410.

Project Zomboid, its engine and assets belong to The Indie Stone. This mod is not
affiliated with The Indie Stone.
