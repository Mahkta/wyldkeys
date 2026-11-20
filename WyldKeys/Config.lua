-- WyldKeys - keybind layout for WoW Forever
-- Copyright (C) 2026 Thomas Larsson
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.


-- Abilities per character. /kb apply puts them on the bars; keys left out
-- keep what is on them. A character without a section gets the keys only.
--
-- Format, one section per character:
--   ["Name"] = { ... }            or ["Name-Realm"] = { ... }; "Name-Realm" wins
--                                  (realm written without spaces, e.g. "Name-SomeRealm").
--   keys = { [key] = ability }     the ability on the button that key presses.
--   stealth / battle / defensive = { [key] = ability }
--                                  the bar that replaces the main bar in stealth
--                                  or in that stance; main bar keys only.
--                                  = "keys" means the same main bar abilities as keys.
--
-- Keys (see Layout.lua):
--   Main bar:      §  1  2  3  4  5  Q  E  R  F  T  G      (E is the interrupt)
--   Action Bar 2:  Shift+1 … Shift+5  Shift+Q (healing potion)  Shift+E  Shift+R
--                  Shift+F  Shift+§  Z  X
--   Action Bar 3:  Ctrl+1 (food, by hand)  Ctrl+2 (bandage, by hand)  Ctrl+3
--
-- Abilities:
--   "Spell Name"                   a spell, by its name in the spellbook
--   BEST_BOMB                      the best bomb in the bags at /kb apply
--   BEST_POTION                    the best healing potion in the bags at /kb apply
--   Item(id, "Name")               one item, by item ID
--   Macro("Name", "label")         a macro by name; the label is for the overview only
--
-- Macros, optional:
--   macros = { ["Name"] = [[ macro text ]] }
--                                  made or updated for this character on /kb apply.
--                                  Name at most 16 letters, text at most 255 characters.
--
-- After a change: /reload, then /kb preview.

local addonName, ns = ...
local BEST_BOMB, BEST_POTION, Item, Macro = ns.BEST_BOMB, ns.BEST_POTION, ns.Item, ns.Macro

ns.Config = {

  ["Galdorin"] = {
    keys = {
      ["§"] = "Charge",
      ["1"] = "Shield Block",
      ["2"] = "Revenge",
      ["3"] = "Heroic Strike",
      ["4"] = "Sunder Armor",
      ["5"] = "Thunder Clap",
      ["Q"] = "Demoralizing Shout",
      ["E"] = "Shield Bash",
      ["R"] = "Cleave",
      ["F"] = "Taunt",
      ["T"] = "Throw",
      ["G"] = "Disarm",
      ["Shift+1"] = Macro("WK Arms", "Arms: Battle Stance and Arms set"),
      ["Shift+2"] = Macro("WK Tank", "Tank: Defensive Stance and Tanking set"),
      ["Shift+Q"] = BEST_POTION,
      ["Shift+E"] = "Bloodrage",
      ["Z"] = "Battle Shout",
    },
    -- Arms in Battle Stance: two-hander, no shield, so no interrupt on E.
    battle = {
      ["§"] = "Charge",
      ["1"] = "Overpower",
      ["2"] = "Rend",
      ["3"] = "Heroic Strike",
      ["4"] = "Slam",
      ["5"] = "Victory Rush",
      ["Q"] = "Demoralizing Shout",
      ["R"] = "Cleave",
      ["F"] = "Hamstring",
      ["T"] = "Throw",
      ["G"] = "Retaliation",
    },
    defensive = "keys",
    -- Stance and gear switch. Out of combat the whole equipment set (made in the
    -- game's Equipment Manager); in combat only the weapons, since armour can't
    -- be changed in combat.
    macros = {
      ["WK Arms"] = [[
#showtooltip Battle Stance
/cast Battle Stance
/equipset [nocombat] Arms
/equip [combat] Ironforge Greathammer
]],
      ["WK Tank"] = [[
#showtooltip Defensive Stance
/cast Defensive Stance
/equipset [nocombat] Tanking
/equip [combat] Bronze Axe
/equip [combat] Furen's Favor
]],
    },
  },

  ["Meagor"] = {
    keys = {
      ["§"] = "Stealth",
      ["1"] = "Sinister Strike",
      ["2"] = "Backstab",
      ["3"] = "Eviscerate",
      ["4"] = "Slice and Dice",
      ["5"] = "Gouge",
      ["Q"] = "Evasion",
      ["E"] = "Kick",
      ["R"] = BEST_BOMB,
      ["T"] = "Throw",
      ["Shift+Q"] = BEST_POTION,
      ["Shift+§"] = "Sprint",
      ["Z"] = Item(1178, "Explosive Rocket"),
      ["Ctrl+3"] = "Pick Lock",
    },
    stealth = {
      ["§"] = "Stealth",
      ["1"] = "Backstab",
      ["4"] = "Pick Pocket",
      ["Q"] = "Evasion",
      ["E"] = "Kick",
      ["R"] = BEST_BOMB,
      ["F"] = "Sap",
      ["T"] = "Throw",
    },
  },

  ["Thorim"] = {
    -- Damage first while levelling, up to level 20. Reworked at 20, when the
    -- totem spells (Call of the Elements and others) arrive.
    keys = {
      ["1"] = "Lightning Bolt",
      ["2"] = "Flame Shock",
      ["3"] = "Healing Wave",
      ["4"] = "Searing Totem",
      ["5"] = "Strength of Earth Totem",
      ["Q"] = "Stoneclaw Totem",
      ["E"] = "Earth Shock",
      ["R"] = "Fire Nova",
      ["F"] = "Purge",
      ["T"] = "Lightning Bolt",
      ["Shift+1"] = "Stoneskin Totem",
      ["Shift+2"] = "Earthbind Totem",
      ["Shift+Q"] = BEST_POTION,
      ["Shift+E"] = "Lightning Shield",
      ["Shift+F"] = "Cure Poison",     -- level 16; run /kb apply again when learned
      ["Shift+§"] = "Tremor Totem",    -- level 18; run /kb apply again when learned
      ["Z"] = "Rockbiter Weapon",
      ["X"] = "Flametongue Weapon",
      ["Ctrl+3"] = "Ancestral Spirit",
    },
  },

  ["Leorn"] = {
    -- Arcane mage, planned to level 40. 1-4 are kept for arcane spells; free
    -- keys are kept for what comes later (see the keybinds overview).
    keys = {
      ["1"] = "Arcane Missiles",
      ["5"] = "Frostbolt",
      ["Q"] = "Fire Blast",
      ["F"] = "Polymorph",
      ["T"] = "Shoot",
      ["G"] = "Frost Nova",
      ["Shift+§"] = "Walk on Air",
      ["Shift+2"] = "Fireball",
      ["Shift+Q"] = BEST_POTION,
      ["Z"] = "Arcane Intellect",
      ["X"] = "Frost Armor",
      ["Ctrl+3"] = Macro("WK Conjure", "Conjure water, then food"),
      ["Ctrl+4"] = "Read Leyline",
    },
    macros = {
      -- Press once for water, again for food; starts over after a minute.
      ["WK Conjure"] = [[
#showtooltip
/castsequence reset=60 Conjure Water, Conjure Food
]],
    },
  },

}
