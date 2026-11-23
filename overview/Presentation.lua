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
    ["Ranged pull: Throw or Shoot, by weapon"] = "Pull",
    ["Execute, or Shield Wall in Defensive Stance"] = "Execute / Wall",
    ["Tank: Defensive Stance and Tanking set"] = "Tank",
    ["Victory Rush"] = "Victory Rush",
    ["Retaliation"] = "Retal\194\173iation",
    ["Intimidating Shout"] = "Intim. Shout",
    ["Reply to whisper"] = "Reply",
    ["Arcane Missiles"] = "Arc. Missiles",
    ["Arcane Explosion"] = "Arc. Explosion",
    ["Mark of the Wild"] = "Mark of the Wild",
    ["Entangling Roots"] = "Entangling Roots",
    ["Frenzied Regeneration"] = "Frenzied Regen.",
    ["Demoralizing Roar"] = "Demo. Roar",
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
    galdorin = {
      ["Ctrl+3"] = { "Berserker Stance (level 30)", "Berserker" },
      ["Shift+F"] = { "Challenging Shout (level 26)", "Chall. Shout" },
    },
    ["galdorin-battle"] = {
      ["E"] = { "Pummel (level 38, Berserker Stance); Shield Bash needs a shield", "Pummel" },
    },
    meagor = {
      ["F"] = { "Ghostly Strike (talent, level 25)", "Ghostly Strike" },
      ["G"] = "Vanish (level 22)",
      ["Shift+2"] = { "Death Mark (talent, about level 40)", "Death Mark" },
      ["Shift+3"] = { "Kidney Shot (level 30)", "Kidney Shot" },
      ["Shift+5"] = "Blind (level 34)",
      ["Shift+E"] = "Shank (level 24)",
      ["X"] = { "Preparation (talent, level 30)", "Preparation" },
    },
    ["meagor-stealth"] = {
      ["3"] = "Cheap Shot (level 26)",
      ["5"] = { "Premeditation (talent, level 20)", "Premeditation" },
      ["G"] = "Distract (level 22)",
    },
    leorn = {
      ["§"] = "Blink (level 20)",
      ["2"] = { "Arcane Blast (Arcane talent, level 20)", "Arc. Blast" },
      ["3"] = { "Arcane Wrath (Arcane talent, level 25)", "Arc. Wrath" },
      ["4"] = { "an arcane spell (none planned yet)", "Arcane" },
      ["E"] = { "Counterspell (level 24)", "Counter\194\173spell" },
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

  -- Colour category for a key, per view, where the usual one for that key
  -- doesn't fit (for example stances on Ctrl keys).
  categories = {
    galdorin = { ["Ctrl+1"] = "alt", ["Ctrl+2"] = "alt", ["Ctrl+3"] = "alt" },
    drealltar = { ["Ctrl+1"] = "alt", ["Ctrl+2"] = "alt", ["Ctrl+3"] = "alt", ["Ctrl+4"] = "alt" },
  },

  -- An extra line in the key's details, per view.
  hints = {
    drealltar = {
      ["§"] = "Shadowmeld: hide while standing still, also to drop threat. Night elf racial.",
      ["T"] = "Faerie Fire pulls from range without leaving a form; the same key in every form.",
      ["Shift+R"] = "Elune's Light: +10% crit for 15 seconds. Night elf racial, like Meagor's Eureka! on the same key.",
      ["Shift+F"] = "Abolish Poison (26) replaces Cure Poison.",
      ["Ctrl+1"] = "Dire Bear Form (40) replaces Bear Form.",
      ["Ctrl+4"] = "Travel Form gathers herbs without leaving the form.",
    },
    ["drealltar-cat"] = {
      ["3"] = "Damage finisher, like Eviscerate on Meagor's 3. Sources disagree on 24 or 32.",
      ["4"] = "Bleed finisher at 4-5 combo points.",
    },
    ["drealltar-prowl"] = {
      ["1"] = "Opener; until Ravage, open with Shred on 2.",
      ["3"] = "Stun opener, like Cheap Shot on Meagor's stealth 3.",
    },
    ["drealltar-bear"] = {
      ["§"] = "Like Galdorin's Charge on §. Talent.",
      ["F"] = "Taunt, like Galdorin's Taunt on F.",
      ["E"] = "Stun and interrupt on the interrupt key.",
    },
    galdorin = { ["Shift+4"] = "Execute in Battle and Berserker Stance; Shield Wall (level 28) in Defensive Stance." },
    meagor = {
      ["Z"] = "Poisons take Z at level 20.",
      ["1"] = "Hemorrhage (talent, level 30) replaces Sinister Strike here as the combo point builder.",
      ["Shift+E"] = "Shank gives energy and an extra combo point; use it on cooldown.",
      ["Shift+1"] = "Escape Artist: gnome racial, frees you from roots and snares. Next to Sprint on Shift + §.",
      ["Shift+Space"] = "Shift + Space is for the mitigation you use most, quick to reach.",
    },
    ["meagor-stealth"] = { ["1"] = "Opener for now; Ambush takes this key at level 18." },
    leorn = {
      ["Shift+2"] = "Frostfire Bolt (level 40) can take this key if it beats Fireball.",
      ["Shift+§"] = "Skyborne racial: free, steerable slow fall.",
      ["Ctrl+4"] = "Skyborne racial: +50% health and mana regeneration for 15 sec, between fights.",
      ["Ctrl+2"] = "Ice Armor (30) or Mage Armor (34) replaces it.",
      ["Ctrl+3"] = "Press once for water, again for food.",
    },
  },

  -- A note under each view.
  notes = {
    drealltar = "Feral druid focused on gathering (Herbalism and Skinning), planned to level 40 from Warcraft Tavern's druid leveling guide. Dashed keys are abilities not reached yet; /kb apply places them once learned. Forms sit on Ctrl + 1–4 in the game's own form order. Travel Form (30) and Aquatic Form (16) keep this caster bar, so roots, Shadowmeld and heals work while gathering; Dash (Shift + §) and Prowl get you to nodes past mobs. Buffs on Z and X; drink and food on Shift + Z and Shift + X.",
    ["drealltar-cat"] = "Cat Form (20): build with Claw, or Shred from behind; Rake and Rip bleed, Ferocious Bite finishes. Prowl on § switches to the prowl bar.",
    ["drealltar-prowl"] = "While prowling, this bar replaces the cat bar. Shift and Ctrl keys stay as on the normal bar.",
    ["drealltar-bear"] = "Bear Form (10), laid out like Galdorin's tanking keys: Demoralizing Roar on Q, Bash on the interrupt key E, Swipe on R, Growl on F.",
    galdorin = "Tank layout, used in Defensive Stance. Ctrl + 1 (Arms) and Ctrl + 2 (Tank) switch stance and equipment set, and Ctrl + 3 is kept for Berserker Stance; see the Battle Stance view for the arms bar. Not placed yet at level 24: Mocking Blow.",
    ["galdorin-battle"] = "Arms in Battle Stance with the two-hander. Only the main bar keys § 1–5 Q E R F T G change with the stance; Shift, Z, X and Ctrl keys stay as on the tank layout.",
    meagor = "Planned for the Subtlety Ambush build (Warcraft Tavern's rogue leveling guide): open with Ambush from stealth, build with Hemorrhage from 30, Ghostly Strike on cooldown for extra Ambushes. Dashed keys are kept free for what comes later. Finishers sit on 3 and 4 with their Shift partners (Kidney Shot, Expose Armor). Rupture (20) stays in the spellbook, since this build doesn't use it. Death Mark, the last Subtlety talent (about level 40), goes on Shift + 2 for burst in combat with Slice and Dice; Preparation, used before a fight, goes on X. Racials: Escape Artist on Shift + 1, Eureka! on Shift + R. Stealth switches to the stealth bar automatically; see the stealth view.",
    ["meagor-stealth"] = "In stealth, the stealth bar replaces the main bar keys § 1–5 Q E R F T G. Shift and Ctrl keys stay as on the normal bar.",
    leorn = "Arcane mage, planned to level 40, with 1–4 kept for arcane spells. Dashed keys are kept free for what comes later. Drink and food on Shift + Z and Shift + X and bandages on Ctrl + Q are the best in the bags at /kb apply; run it again after conjuring a better rank. Amplify and Dampen Magic (group buffs, used situationally) sit on Z and X; Arcane Intellect and the armor on Ctrl + 1 and Ctrl + 2. Flamestrike, teleports and portals stay in the spellbook.",
    thorim = "Damage first while levelling, up to level 20. The layout is reworked at 20, when Call of the Elements and the other totem spells arrive. Stoneform (dwarf racial) gets a key then too. Cure Poison (16) and Tremor Totem (18) are placed by /kb apply once learned.",
  },

  -- View titles for stance and stealth bars.
  barTitles = { stealth = "in stealth", battle = "in Battle Stance", defensive = "in Defensive Stance",
                cat = "in Cat Form", prowl = "in Cat Form, prowling", bear = "in Bear Form" },

  -- Each character's level, and the level (or a note) at which an ability in
  -- Config.lua arrives. Keys for abilities above the level are drawn dashed.
  level = { drealltar = 6 },
  learnedAt = {
    drealltar = {
      ["Entangling Roots"] = 8, ["Nature's Grasp"] = 10, Regrowth = 12, Revive = 12,
      ["Cure Poison"] = 14, ["Faerie Fire"] = 18, Hibernate = 18, Rebirth = 20,
      ["Remove Curse"] = 24, Dash = 26, Innervate = 40, Barkskin = 44,
      ["Bear Form"] = 10, ["Aquatic Form"] = 16, ["Cat Form"] = 20, ["Travel Form"] = 30,
      Maul = 10, ["Demoralizing Roar"] = 10, Growl = 10, Enrage = 12, Bash = 14, Swipe = 16,
      ["Feral Charge"] = 20, Lacerate = 25, ["Primal Bite"] = 40, ["Frenzied Regeneration"] = 36,
      Prowl = 20, Claw = 20, Shred = 20, Rip = 20, Rake = 24, ["Ferocious Bite"] = 24,
      Cower = 28, ["Shifting Power"] = 40, Ravage = 32, Pounce = 36,
    },
  },

  -- Placed by hand on every character with a section (shown, not set by the addon).
  -- Empty now: food, drink and bandages are set by the addon from Config.lua.
  manual = {},
}
