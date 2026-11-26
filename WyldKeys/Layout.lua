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

-- The key scheme shared by every character, as data. Core.lua reads it.

local addonName, ns = ...

-- The three bars the layout binds. Per bar, index = button 1-12:
--   keys    what Config.lua writes, and how messages show the key
--   binds   the game's key name; "§" is replaced by the key learned with /kb setup
--   labels  optional message text that differs from keys
--   command the binding command; the button number is appended
--   bindText / barText  bar name in the binding list and in the ability list
-- A key without a bind (Click 1-3 on Action Bar 3) is a button with no key:
-- the layout places things there to click.
ns.MAIN = {
  command = "ACTIONBUTTON", bindText = "main bar button", barText = "Main bar",
  keys  = { "§", "1", "2", "3", "4", "5", "Q", "E", "R", "F", "T", "G" },
  binds = { "§", "1", "2", "3", "4", "5", "Q", "E", "R", "F", "T", "G" },
}

ns.SHIFT = {
  command = "MULTIACTIONBAR1BUTTON", bindText = "Action Bar 2 button", barText = "Action Bar 2",
  keys  = { "Shift+1", "Shift+2", "Shift+3", "Shift+4", "Shift+5", "Shift+Q", "Shift+E", "Shift+R", "Shift+F", "Shift+§", "Z", "X" },
  binds = { "SHIFT-1", "SHIFT-2", "SHIFT-3", "SHIFT-4", "SHIFT-5", "SHIFT-Q", "SHIFT-E", "SHIFT-R", "SHIFT-F", "SHIFT-§", "Z", "X" },
  labels = { [6] = "Shift+Q (healing potion)" },
}

ns.CTRL = {
  command = "MULTIACTIONBAR2BUTTON", bindText = "Action Bar 3 button", barText = "Action Bar 3",
  keys  = { "Ctrl+1", "Ctrl+2", "Ctrl+3", "Ctrl+4", "Shift+Z", "Shift+X", "Ctrl+5", "Ctrl+Q", "Shift+Space",
            "Click 1", "Click 2", "Click 3" },
  binds = { "CTRL-1", "CTRL-2", "CTRL-3", "CTRL-4", "SHIFT-Z", "SHIFT-X", "CTRL-5", "CTRL-Q", "SHIFT-SPACE" },
}

-- Action Bar 4 and 5 have no keys: buttons to click. The layout puts the same
-- kind of thing in the same slot on every character (ns.UTILITY below and each
-- character's own "Bar 4 n" / "Bar 5 n" in Config.lua). Slots nothing is set
-- for are never touched, so they are free for whatever you put there.
local function clickKeys(bar) local t = {} for i = 1, 12 do t[i] = bar .. " " .. i end return t end
local BUTTONS = {} for i = 1, 12 do BUTTONS[i] = "button " .. i end
ns.BAR4 = { barText = "Action Bar 4", keys = clickKeys("Bar 4"), labels = BUTTONS }
ns.BAR5 = { barText = "Action Bar 5", keys = clickKeys("Bar 5"), labels = BUTTONS }

-- Other bindings, after the bars: { game key, command, message text }.
ns.SYSTEM = {
  { "CTRL-R", "REPLY", "Ctrl+R = Reply to whisper" },
  { "CTRL-Z", "TOGGLESHEATH", "Ctrl+Z = Sheathe weapon" },
  { "CTRL-X", "SITORSTAND", "Ctrl+X = Sit / swim down" },
  { "BUTTON3", "TOGGLEAUTORUN", "Middle button = Autorun" },
}

-- Commands whose old keys are cleared before the layout is bound.
ns.MANAGED = {}
for i = 1, 12 do ns.MANAGED[#ns.MANAGED + 1] = "ACTIONBUTTON" .. i end
for i = 1, 12 do ns.MANAGED[#ns.MANAGED + 1] = "MULTIACTIONBAR1BUTTON" .. i end
for _, i in ipairs({ 1, 2, 3, 4, 5, 6, 7, 8, 9, 12 }) do ns.MANAGED[#ns.MANAGED + 1] = "MULTIACTIONBAR2BUTTON" .. i end

-- Key label -> bar and button, for Config.lua. Built from the bars above.
ns.KEYS = {}
for section, bar in pairs({ main = ns.MAIN, shift = ns.SHIFT, ctrl = ns.CTRL, bar4 = ns.BAR4, bar5 = ns.BAR5 }) do
  for i, key in ipairs(bar.keys) do ns.KEYS[key] = { section = section, button = i } end
end

-- Bars that replace the main bar in a stance or in stealth (bonus bar number).
-- They use the main bar keys.
ns.BONUS_BARS = { stealth = 1, battle = 1, defensive = 2, cat = 1, prowl = 2, bear = 3 }

-- Entries Config.lua can use besides spell names.
-- Engineering bombs: the best explosive in the bags at the time of /kb apply.
ns.BEST_BOMB = { best = "bomb" }
-- Healing potions: the best one in the bags at the time of /kb apply.
ns.BEST_POTION = { best = "potion" }
-- Drink and food (conjured or bought): the best in the bags at /kb apply.
ns.BEST_DRINK = { best = "drink" }
ns.BEST_FOOD = { best = "food" }
-- Bandages: the best in the bags at /kb apply.
ns.BEST_BANDAGE = { best = "bandage" }
-- A fixed item by ID; the name is used in messages.
function ns.Item(id, name) return { item = id, name = name } end
-- A macro by name, made from the character's macros section (or one you made in the game).
-- In a macro's text, {best:stone}, {best:instant}, {best:crippling}, {best:deadly} and
-- {best:mindnumbing} become the name of the best such item in the bags at /kb apply.
-- The label is only used by the keybinds overview.
function ns.Macro(name, label) return { macro = name, label = label } end
-- The first of several spells the character knows, e.g. First("Smelting", "Mining").
function ns.First(...) return { any = { ... } } end
-- The best item of a kind in the bags at /kb apply (kinds: see MATCH in Core.lua).
function ns.Best(kind) return { best = kind } end

-- The same on every character, on the bars without keys. A character's own
-- entry for the same slot wins; false there leaves the slot alone. Nothing to
-- put there (a profession not learned, no such item in the bags) leaves the
-- slot as it is.
--   Action Bar 4:  1 crafting profession  2 second profession  3 profession action
--                  4 tracking  5 Cooking  6 First Aid  7 Fishing  8-10 free
--                  11 Hearthstone  12 mount (later)
--   Action Bar 5:  1 battle elixir  2 guardian elixir  3 mana potion  4 scroll
--                  5 buff food  6 Anti-Venom  7-12 free
--   Action Bar 3:  Click 1 weapon coating, Click 2-3 rogue poisons (else free)
ns.UTILITY = {
  ["Bar 4 5"] = "Cooking",
  ["Bar 4 6"] = "First Aid",
  ["Bar 4 7"] = "Fishing",
  ["Bar 4 11"] = ns.Item(6948, "Hearthstone"),
  ["Bar 5 2"] = ns.Best("guardian"),
  ["Bar 5 3"] = ns.Best("mana"),
  ["Bar 5 5"] = ns.Best("wellfed"),
  ["Bar 5 6"] = ns.Best("antivenom"),
}
