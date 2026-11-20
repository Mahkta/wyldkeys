# WyldKeys

A small World of Warcraft: Forever addon that applies a fixed keybind layout and places abilities on the action bars when asked. Nothing changes until you type a command.

## Install

Copy the `WyldKeys` folder into `World of Warcraft/_forever_/Interface/AddOns/` and `/reload`.

## Commands

| Command | What it does |
| --- | --- |
| `/kb setup` | Learns what the game calls the § key (left of 1). Once per account. |
| `/kb preview` | Lists every key and ability `/kb apply` would set. Changes nothing. |
| `/kb apply` | Sets the bindings and, on Galdorin, Meagor and Thorim, places abilities, the best bomb and the best healing potion from the bags. |
| `/kb restore` | Puts back the keys and bars saved before the first `/kb apply` on this character. |
| `/kb forget` | Drops that saved copy, so the next `/kb apply` saves a fresh one. |
| `/kb keys` | Shows the learned § key. |

## Layout

- Main bar: § 1–5 Q E R F T G (swaps with stance and stealth bars). E is the interrupt on every character.
- Action Bar 2: Shift + 1–5, Shift + Q (healing potion), Shift + E/R/F, Shift + §, Z, X.
- Action Bar 3: Ctrl + 1 (food), Ctrl + 2 (bandage), Ctrl + 3 (out-of-combat tool).
- Ctrl + R reply, Ctrl + Z sheathe, Ctrl + X sit / swim down, middle mouse button autorun.

Keyboard view and full layout: the "WoW Forever keybinds" artifact and the "Keybind layout – draft (Claude)" doc in Craft.
