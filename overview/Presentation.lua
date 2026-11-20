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


-- Details that only the keybinds overview needs. The abilities themselves come
-- from WyldKeys/Config.lua, so the overview always shows what /kb apply sets.
-- Nothing here changes the addon.
--
-- Views are named by character in lower case ("meagor"), and a stance or stealth
-- bar of its own adds its section name ("meagor-stealth"). Keys are written as in
-- Config.lua ("§", "1", "G", "Shift+E", "Ctrl+3").

return {

  -- Shorter labels for the key caps, by ability name. Optional; without one the
  -- full name is shown. A soft hyphen (U+00AD) marks where a long word may break.
  short = {
    ["Sunder Armor"] = "Sunder",
    ["Demoralizing Shout"] = "Demo Shout",
    ["Defensive Stance"] = "Def. Stance",
    ["Bloodrage"] = "Blood\194\173rage",
    ["Sinister Strike"] = "Sin. Strike",
    ["Backstab"] = "Back\194\173stab",
    ["Eviscerate"] = "Evis\194\173cerate",
    ["Slice and Dice"] = "Slice & Dice",
    ["Lightning Bolt"] = "L. Bolt",
    ["Healing Wave"] = "Heal Wave",
    ["Strength of Earth Totem"] = "SoE Totem",
    ["Stoneclaw Totem"] = "Stone\194\173claw",
    ["Lightning Shield"] = "L. Shield",
    ["Stoneskin Totem"] = "Stone\194\173skin",
    ["Earthbind Totem"] = "Earth\194\173bind",
    ["Rockbiter Weapon"] = "Rock\194\173biter",
    ["Flametongue Weapon"] = "Flame\194\173tongue",
    ["Ancestral Spirit"] = "Ances\194\173tral",
    ["Engineering bomb (best in bags)"] = "Bomb",
    ["Healing potion (best in bags)"] = "Potion",
    ["Explosive Rocket"] = "Rocket",
    ["Arms: Battle Stance and Arms set"] = "Arms",
    ["Tank: Defensive Stance and Tanking set"] = "Tank",
    ["Victory Rush"] = "Victory Rush",
    ["Retaliation"] = "Retal\194\173iation",
    ["Reply to whisper"] = "Reply",
    ["Arcane Missiles"] = "Arc. Missiles",
    ["Arcane Intellect"] = "Arc. Intellect",
    ["Polymorph"] = "Poly\194\173morph",
    ["Conjure water, then food"] = "Conjure",
    ["Walk on Air"] = "Walk on Air",
    ["Read Leyline"] = "Leyline",
    ["Dampen Magic"] = "Dampen",
    ["Drink (best in bags)"] = "Drink",
    ["Food (best in bags)"] = "Food",
    ["Bandage (best in bags)"] = "Bandage",
    ["Sheathe weapon"] = "Sheathe",
    ["Sit / swim down"] = "Sit / swim",
  },

  -- What a free key is meant for later, per view. "Name (level N)" shows "Name"
  -- on the key; write { "long text", "Key text" } to choose the key text.
  later = {
    ["galdorin-battle"] = {
      ["E"] = { "Pummel (level 38, Berserker Stance); Shield Bash needs a shield", "Pummel" },
    },
    meagor = {
      ["G"] = "Vanish (level 22)",
      ["Shift+E"] = "Shank (level 24)",
    },
    ["meagor-stealth"] = {
      ["2"] = "Garrote (level 14)",
      ["3"] = "Cheap Shot (level 26)",
      ["G"] = "Distract (level 22)",
    },
    leorn = {
      ["§"] = "Blink (level 20)",
      ["2"] = { "Arcane Blast (Arcane talent, level 20)", "Arc. Blast" },
      ["3"] = { "Arcane Wrath (Arcane talent, level 25)", "Arc. Wrath" },
      ["4"] = { "an arcane spell (none planned yet)", "Arcane" },
      ["E"] = { "Counterspell (level 24)", "Counter\194\173spell" },
      ["R"] = { "Arcane Explosion (level 14)", "Arc. Explosion" },
      ["Shift+1"] = "Blizzard (level 20)",
      ["Shift+3"] = { "Cone of Cold (level 26)", "Cone of Cold" },
      ["Shift+4"] = { "Remove Lesser Curse (level 18)", "Decurse" },
      ["Shift+5"] = { "Mana Shield (level 20)", "Mana Shield" },
      ["Z"] = { "Amplify Magic (level 18), group buff", "Amplify" },
      ["Shift+E"] = { "Presence of Mind (Arcane talent, level 30)", "PoM" },
      ["Shift+R"] = { "Arcane Power (Arcane talent, level 40)", "Arc. Power" },
      ["Shift+F"] = { "Evocation (level 20)", "Evo\194\173cation" },
    },
    thorim = {
      ["§"] = "Ghost Wolf (level 20)",
      ["G"] = { "a defensive", "Defen\194\173sive" },
    },
  },

  -- An extra line in the key's details, per view.
  hints = {
    meagor = { ["Z"] = "Poisons take Z at level 20." },
    ["meagor-stealth"] = { ["1"] = "Opener for now; Ambush takes this key at level 18." },
    leorn = {
      ["Shift+2"] = "Frostfire Bolt (level 40) can take this key if it beats Fireball.",
      ["Shift+§"] = "Skyborne racial: free, steerable slow fall.",
      ["Ctrl+4"] = "Skyborne racial: +50% health and mana regeneration for 15 sec, between fights.",
      ["Shift+X"] = "Ice Armor (30) or Mage Armor (34) replaces it.",
      ["Ctrl+3"] = "Press once for water, again for food.",
    },
  },

  -- A note under each view.
  notes = {
    galdorin = "Tank layout, used in Defensive Stance. Shift + 1 (Arms) and Shift + 2 (Tank) switch stance and gear; see the Battle Stance view for the arms bar. Not placed yet at level 21: Mocking Blow.",
    ["galdorin-battle"] = "Arms in Battle Stance with the two-hander. Only the main bar keys § 1–5 Q E R F T G change with the stance; Shift, Z, X and Ctrl keys stay as on the tank layout.",
    meagor = "Stealth switches to the stealth bar automatically; see the stealth view.",
    ["meagor-stealth"] = "In stealth, the stealth bar replaces the main bar keys § 1–5 Q E R F T G. Shift and Ctrl keys stay as on the normal bar.",
    leorn = "Arcane mage, planned to level 40, with 1–4 kept for arcane spells. Dashed keys are kept free for what comes later. Drink, food and bandage on Ctrl + 1–3 are the best in the bags at /kb apply; run it again after conjuring a better rank. Amplify and Dampen Magic (group buffs, used situationally) sit on Z and X; Arcane Intellect and the armor on Shift + Z and Shift + X. Flamestrike, teleports and portals stay in the spellbook.",
    thorim = "Damage first while levelling, up to level 20. The layout is reworked at 20, when Call of the Elements and the other totem spells arrive. Cure Poison (16) and Tremor Totem (18) are placed by /kb apply once learned.",
  },

  -- View titles for stance and stealth bars.
  barTitles = { stealth = "in stealth", battle = "in Battle Stance", defensive = "in Defensive Stance" },

  -- Placed by hand on every character with a section (shown, not set by the addon).
  -- Empty now: food, drink and bandages are set by the addon from Config.lua.
  manual = {},
}
