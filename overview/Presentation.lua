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
    ["Reply to whisper"] = "Reply",
    ["Sheathe weapon"] = "Sheathe",
    ["Sit / swim down"] = "Sit / swim",
  },

  -- What a free key is meant for later, per view. "Name (level N)" shows "Name"
  -- on the key; write { "long text", "Key text" } to choose the key text.
  later = {
    meagor = {
      ["G"] = "Vanish (level 22)",
      ["Shift+E"] = "Shank (level 24)",
    },
    ["meagor-stealth"] = {
      ["2"] = "Garrote (level 14)",
      ["3"] = "Cheap Shot (level 26)",
      ["G"] = "Distract (level 22)",
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
  },

  -- A note under each view.
  notes = {
    galdorin = "Battle Stance and Defensive Stance get the same abilities on these keys. Not placed yet at level 21: Rend, Hamstring, Overpower, Mocking Blow, Retaliation, Victory Rush, Slam.",
    meagor = "Stealth switches to the stealth bar automatically; see the stealth view.",
    ["meagor-stealth"] = "In stealth, the stealth bar replaces the main bar keys § 1–5 Q E R F T G. Shift and Ctrl keys stay as on the normal bar.",
    thorim = "At level 20, Call of the Elements drops several totems with one key and frees the single-totem keys.",
  },

  -- View titles for stance and stealth bars.
  barTitles = { stealth = "in stealth", battle = "in Battle Stance", defensive = "in Defensive Stance" },

  -- Placed by hand on every character with a section (shown, not set by the addon).
  manual = { ["Ctrl+1"] = "Food", ["Ctrl+2"] = "Bandage" },
}
