# WyldKeys

A small World of Warcraft: Forever addon that applies a fixed keybind layout and places abilities on the action bars when asked. Nothing changes until you type a command.

## Install

Copy the `WyldKeys` folder into `World of Warcraft/_forever_/Interface/AddOns/` and `/reload`.

## Commands

| Command | What it does |
| --- | --- |
| `/kb setup` | Learns what the game calls the § key (left of 1). Once per account. |
| `/kb preview` | Lists every key and ability `/kb apply` would set. Changes nothing. |
| `/kb apply` | Sets the bindings and, on characters in `Config.lua` (Galdorin, Meagor and Thorim), places abilities, the best bomb and the best healing potion from the bags. |
| `/kb restore` | Puts back the keys and bars saved before the first `/kb apply` on this character. |
| `/kb forget` | Drops that saved copy, so the next `/kb apply` saves a fresh one. |
| `/kb keys` | Shows the learned § key. |

## Layout

- Main bar: § 1–5 Q E R F T G (swaps with stance and stealth bars). E is the interrupt on every character.
- Action Bar 2: Shift + 1–5, Shift + Q (healing potion), Shift + E/R/F, Shift + §, Z, X.
- Action Bar 3: Ctrl + 1 (food), Ctrl + 2 (bandage), Ctrl + 3 (out-of-combat tool).
- Ctrl + R reply, Ctrl + Z sheathe, Ctrl + X sit / swim down, middle mouse button autorun.

## Files

- `WyldKeys/Layout.lua`: the key scheme shared by every character (which key presses which bar button).
- `WyldKeys/Config.lua`: the abilities per character, keyed by the key you press.
- `WyldKeys/Core.lua`: the engine (commands, bindings, placing abilities, backup and restore).

## Adding a character

1. Open `WyldKeys/Config.lua` and copy one character's section, e.g. `["Meagor"] = { ... },`.
2. Rename it to the new character, or `"Name-Realm"` (realm without spaces) if the name exists on more than one realm.
3. Put the abilities under the keys you want, e.g. `["E"] = "Kick"`. Valid keys and ability forms are listed at the top of the file. Leave a key out to keep what is on it.
4. `/reload` in the game, then `/kb preview` and `/kb apply` on that character.

A character without a section gets the keys only.

Keyboard view and full layout: the "WoW Forever keybinds" artifact and the "Keybind layout – draft (Claude)" doc in Craft.

## License

Copyright (C) 2026 Thomas Larsson. WyldKeys is free software under the GNU General Public License, version 3 or (at your option) any later version. See [LICENSE](LICENSE).
