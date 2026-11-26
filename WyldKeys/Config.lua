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
--   stealth / battle / defensive / cat / prowl / bear = { [key] = ability }
--                                  the bar that replaces the main bar in stealth
--                                  or in that stance; main bar keys only.
--                                  = "keys" means the same main bar abilities as keys.
--
-- Keys (see Layout.lua):
--   Main bar:      §  1  2  3  4  5  Q  E  R  F  T  G      (E is the interrupt)
--   Action Bar 2:  Shift+1 … Shift+5  Shift+Q (healing potion)  Shift+E  Shift+R
--                  Shift+F  Shift+§  Z  X
--   Action Bar 3:  Ctrl+1 … Ctrl+5  Shift+Z  Shift+X  Ctrl+Q
--                  Click 1-3 (buttons 10-12, no key)
--   Action Bar 4 and 5, no keys:  "Bar 4 1" … "Bar 4 12", "Bar 5 1" … "Bar 5 12".
--                  The shared slots are in Layout.lua (ns.UTILITY); a character
--                  sets the rest, and false leaves a shared slot alone.
--
-- Abilities:
--   "Spell Name"                   a spell, by its name in the spellbook
--   BEST_BOMB                      the best bomb in the bags at /kb apply
--   BEST_POTION                    the best healing potion in the bags at /kb apply
--   BEST_DRINK, BEST_FOOD          the best drink or food in the bags at /kb apply
--   BEST_BANDAGE                   the best bandage in the bags at /kb apply
--
-- The same on every character:
--   Ctrl+1-5   stances, forms or auras (warrior stances, druid forms, paladin
--              auras); classes without them use these keys for long buffs and
--              out-of-combat spells
--   Shift+Z/X  casters with mana: drink / food; others: food on Shift+Z
--   Ctrl+Q     bandages
--   Shift+Space  the damage mitigation used most often
--   Item(id, "Name")               one item, by item ID
--   First("A", "B")                the first of these spells the character knows
--   Best("kind")                   the best item of a kind in the bags at /kb apply
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
local BEST_DRINK, BEST_FOOD, BEST_BANDAGE = ns.BEST_DRINK, ns.BEST_FOOD, ns.BEST_BANDAGE
local First, Best = ns.First, ns.Best

-- T fires the ranged weapon equipped, for every character that can use one.
-- Each of them lists PULL_MACRO under macros (the game keeps macros per character).
local PULL = Macro("WK Pull", "Ranged pull: fires the ranged weapon equipped")
local PULL_MACRO = [[
#showtooltip
/cast [equipped:Wands] Shoot; [equipped:Thrown] Throw; [equipped:Guns] Shoot Gun; [equipped:Crossbows] Shoot Crossbow; [equipped:Bows] Shoot Bow
]]

-- Click 1 (Action Bar 3, button 10): the coating for the weapon held.
-- Click: main hand, Shift+click: off hand.
local COAT = Macro("WK Coat", "Weapon coating for the weapon held: click main hand, Shift+click off hand")
local COAT_MACRO = [[
#showtooltip
/use [equipped:One-Handed Maces/Two-Handed Maces/Staves] {best:weightstone}; {best:stone}
/use [mod:shift] 17; 16
]]
local OIL = Macro("WK Oil", "Wizard oil on the weapon")
local OIL_MACRO = [[
#showtooltip
/use {best:oil}
/use 16
]]

ns.Config = {

  ["Galdorin"] = {
    keys = {
      ["§"] = "Charge",
      ["1"] = "Shield Block",
      ["2"] = "Revenge",
      ["3"] = "Heroic Strike",
      ["4"] = "Sunder Armor",
      ["5"] = "Victory Rush",
      ["Q"] = "Demoralizing Shout",
      ["E"] = "Shield Bash",
      ["R"] = "Cleave",
      ["F"] = "Taunt",
      ["T"] = PULL,
      ["G"] = "Disarm",
      ["Shift+1"] = "Last Stand",  -- emergency cooldown, next to Stoneform
      ["Shift+2"] = "Stoneform",   -- dwarf racial
      ["Shift+3"] = "Rend",
      -- Execute in Battle and Berserker Stance, Shield Wall (28) in Defensive.
      ["Shift+4"] = Macro("WK Execute", "Execute, or Shield Wall in Defensive Stance"),
      ["Shift+5"] = "Intimidating Shout",
      ["Shift+Q"] = BEST_POTION,
      ["Shift+E"] = "Bloodrage",
      ["Shift+R"] = "Thunder Clap",
      ["Shift+F"] = "Challenging Shout", -- level 26; area taunt, next to Taunt on F
      ["Z"] = "Battle Shout",
      -- Stances on Ctrl+1-3 (Berserker Stance at 30 gets Ctrl+3).
      ["Ctrl+1"] = Macro("WK Arms", "Arms: Battle Stance and Arms set"),
      ["Ctrl+2"] = Macro("WK Tank", "Tank: Defensive Stance and Tanking set"),
      ["Shift+Z"] = BEST_FOOD,
      ["Ctrl+Q"] = BEST_BANDAGE,
      -- Bars without keys (shared slots in Layout.lua)
      ["Click 1"] = COAT,
      ["Bar 4 1"] = "Blacksmithing",
      ["Bar 4 2"] = First("Smelting", "Mining"),
      ["Bar 4 4"] = First("Find Minerals", "Find Treasure"),
      ["Bar 5 1"] = Best("strelixir"),
      ["Bar 5 3"] = false,              -- no mana
      ["Bar 5 4"] = Best("strscroll"),
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
      ["T"] = PULL,
      ["G"] = "Retaliation",
    },
    defensive = "keys",
    -- Stance and gear switch with the equipment sets made in the game's
    -- Equipment Manager. In combat the set still swaps the weapons (tested
    -- 21 Nov 2026). Armour can't change in combat, so if the sets differ in
    -- armour, press the key again after the fight.
    macros = {
      ["WK Arms"] = [[
#showtooltip Battle Stance
/cast Battle Stance
/equipset Arms
]],
      -- Stance 2 is Defensive Stance.
      ["WK Execute"] = [[
#showtooltip
/cast [stance:2] Shield Wall; Execute
]],
      ["WK Coat"] = COAT_MACRO,
      ["WK Pull"] = PULL_MACRO,
      ["WK Tank"] = [[
#showtooltip Defensive Stance
/cast Defensive Stance
/equipset Tanking
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
      ["T"] = PULL,
      ["Shift+1"] = "Escape Artist",  -- gnome racial: breaks roots and snares, beside Sprint
      ["Shift+3"] = "Rupture",        -- bleed finisher, beside Eviscerate
      ["Shift+4"] = "Expose Armor",   -- level 14; finisher, beside Slice and Dice
      ["Shift+Q"] = BEST_POTION,
      ["Shift+R"] = "Eureka!",       -- gnome racial, 2 min burst cooldown
      ["Shift+Space"] = "Feint",      -- level 16; the most used mitigation goes on Shift+Space
      -- Weapon coatings, clicked out of combat. Click: main hand, Shift+click: off hand.
      ["Click 1"] = Macro("WK Stone", "Sharpening stone: click main hand, Shift+click off hand"),
      ["Click 2"] = Macro("WK Instant", "Instant Poison: click main hand, Shift+click off hand"),
      ["Click 3"] = Macro("WK Crippling", "Crippling Poison: click main hand, Shift+click off hand"),
      ["Shift+§"] = "Sprint",
      ["Z"] = Item(1178, "Explosive Rocket"),
      ["Shift+Z"] = BEST_FOOD,
      ["Ctrl+Q"] = BEST_BANDAGE,
      -- Bars without keys (shared slots in Layout.lua)
      ["Bar 4 1"] = "Engineering",
      ["Bar 4 2"] = "Alchemy",
      ["Bar 5 1"] = Best("agielixir"),
      ["Bar 5 3"] = false,              -- no mana
      ["Bar 5 4"] = Best("agiscroll"),
      ["Ctrl+1"] = "Pick Lock",
    },
    stealth = {
      ["§"] = "Stealth",
      ["1"] = "Ambush",               -- level 18; the opener, needs a dagger in the main hand
      ["2"] = "Garrote",              -- level 14
      ["4"] = "Pick Pocket",
      ["Q"] = "Evasion",
      ["E"] = "Kick",
      ["R"] = BEST_BOMB,
      ["F"] = "Sap",
      ["T"] = PULL,
    },
    macros = {
      ["WK Pull"] = PULL_MACRO,
      -- {best:...} is the best such item in the bags at /kb apply; run it again after buying better ones.
      ["WK Stone"] = [[
#showtooltip
/use {best:stone}
/use [mod:shift] 17; 16
]],
      ["WK Instant"] = [[
#showtooltip
/use {best:instant}
/use [mod:shift] 17; 16
]],
      ["WK Crippling"] = [[
#showtooltip
/use {best:crippling}
/use [mod:shift] 17; 16
]],
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
      ["Shift+Z"] = BEST_DRINK,
      ["Shift+X"] = BEST_FOOD,
      ["Ctrl+Q"] = BEST_BANDAGE,
      -- Bars without keys (shared slots in Layout.lua)
      ["Click 1"] = COAT,
      ["Bar 4 1"] = "Leatherworking",
      ["Bar 4 2"] = "Skinning",
      ["Bar 4 4"] = "Find Treasure",
      ["Bar 5 1"] = Best("intelixir"),
      ["Bar 5 4"] = Best("intscroll"),
      ["Ctrl+1"] = "Ancestral Spirit",
    },
    macros = {
      ["WK Coat"] = COAT_MACRO,
    },
  },

  ["Leorn"] = {
    -- Arcane mage, planned to level 40 (20 Nov 2026). 1-4 are kept for arcane spells; free
    -- keys are kept for what comes later (see the keybinds overview).
    keys = {
      ["1"] = "Arcane Missiles",
      ["5"] = "Frostbolt",
      ["Q"] = "Fire Blast",
      ["R"] = "Arcane Explosion",      -- level 14
      ["F"] = "Polymorph",
      ["T"] = PULL,
      ["G"] = "Frost Nova",
      ["Shift+§"] = "Walk on Air",
      ["Shift+2"] = "Fireball",
      ["Shift+Q"] = BEST_POTION,
      ["X"] = "Dampen Magic",          -- level 12; group buff, Amplify Magic (18) goes on Z
      ["Ctrl+1"] = "Arcane Intellect",
      ["Ctrl+2"] = "Frost Armor",
      ["Ctrl+3"] = Macro("WK Conjure", "Conjure water, then food"),
      ["Shift+Z"] = BEST_DRINK,
      ["Shift+X"] = BEST_FOOD,
      ["Ctrl+Q"] = BEST_BANDAGE,
      -- Bars without keys (shared slots in Layout.lua)
      ["Click 1"] = OIL,
      ["Bar 4 1"] = "Tailoring",
      ["Bar 4 2"] = "Enchanting",
      ["Bar 4 3"] = "Disenchant",
      ["Bar 5 1"] = Best("intelixir"),
      ["Bar 5 4"] = Best("intscroll"),
      ["Ctrl+4"] = "Read Leyline",
      ["Ctrl+5"] = "Slow Fall",        -- level 12; mainly for the group, Walk on Air covers her
    },
    macros = {
      ["WK Oil"] = OIL_MACRO,
      ["WK Pull"] = PULL_MACRO,
      -- Press once for water, again for food; starts over after a minute.
      ["WK Conjure"] = [[
#showtooltip
/castsequence reset=60 Conjure Water, Conjure Food
]],
    },
  },

  -- Feral druid with Herbalism and Skinning; planned to level 40 on 23 Nov 2026
  -- (Warcraft Tavern's druid leveling guide). Abilities he hasn't learned yet are
  -- listed as "not learned" at /kb apply and placed once he has them.
  -- Forms on Ctrl+1-4 in the game's own form order. Travel and Aquatic Form use
  -- the main (caster) bar, so the gathering keys work in them.
  ["Drealltar"] = {
    keys = {
      ["§"] = "Shadowmeld",           -- night elf racial: hide, drop threat
      ["1"] = "Wrath",
      ["2"] = "Moonfire",
      ["3"] = "Healing Touch",
      ["4"] = "Rejuvenation",
      ["5"] = "Regrowth",             -- 12
      ["E"] = "Entangling Roots",     -- 8
      ["R"] = "Innervate",            -- 40
      ["F"] = "Hibernate",            -- 18
      ["T"] = "Faerie Fire",          -- 18; pulls from range in every form
      ["G"] = "Nature's Grasp",       -- 10
      ["Shift+2"] = "Remove Curse",   -- 24
      ["Shift+Q"] = BEST_POTION,
      ["Shift+E"] = "Rebirth",        -- 20
      ["Shift+R"] = "Elune's Light",  -- night elf racial: burst
      ["Shift+F"] = "Cure Poison",    -- 14 (quest)
      ["Shift+§"] = "Dash",           -- 26, Cat Form
      ["Z"] = "Mark of the Wild",
      ["X"] = "Thorns",
      ["Ctrl+1"] = "Bear Form",       -- 10 (quest)
      ["Ctrl+2"] = "Aquatic Form",    -- 16 (quest)
      ["Ctrl+3"] = "Cat Form",        -- 20 (quest)
      ["Ctrl+4"] = "Travel Form",     -- 30; gathers herbs without leaving form
      ["Ctrl+5"] = "Revive",          -- 12
      ["Shift+Z"] = BEST_DRINK,
      ["Shift+X"] = BEST_FOOD,
      ["Ctrl+Q"] = BEST_BANDAGE,
      -- Bars without keys (shared slots in Layout.lua)
      ["Bar 4 1"] = "Alchemy",
      ["Bar 4 2"] = "Herbalism",
      ["Bar 4 4"] = "Find Herbs",
      ["Bar 5 1"] = Best("agielixir"),
      ["Bar 5 4"] = Best("agiscroll"),
      ["Shift+Space"] = "Barkskin",   -- 44; the most used mitigation, same key in every form
    },
    bear = {
      ["§"] = "Feral Charge",         -- talent, 20
      ["1"] = "Maul",
      ["2"] = "Lacerate",             -- talent, 25
      ["3"] = "Primal Bite",          -- talent, 40
      ["4"] = "Enrage",               -- 12
      ["Q"] = "Demoralizing Roar",
      ["E"] = "Bash",                 -- 14
      ["R"] = "Swipe",                -- 16
      ["F"] = "Growl",
      ["T"] = "Faerie Fire",
      ["G"] = "Frenzied Regeneration", -- 36
    },
    cat = {
      ["§"] = "Prowl",
      ["1"] = "Claw",
      ["2"] = "Shred",
      ["3"] = "Ferocious Bite",       -- 24 or 32, sources differ
      ["4"] = "Rip",
      ["5"] = "Rake",                 -- 24
      ["Q"] = "Cower",                -- 28
      ["R"] = "Shifting Power",       -- talent, 40
      ["T"] = "Faerie Fire",
    },
    prowl = {
      ["§"] = "Prowl",
      ["1"] = "Ravage",               -- 32
      ["2"] = "Shred",
      ["3"] = "Pounce",               -- 36
      ["5"] = "Rake",
    },
  },
}
