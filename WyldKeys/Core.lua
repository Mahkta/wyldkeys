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

-- WyldKeys: applies Thomas's keybind layout on request.
-- This file is the engine. The key scheme is in Layout.lua, the abilities
-- per character in Config.lua.
-- Nothing happens until a /kb command is typed. Commands:
--   /kb setup    learn the § key
--   /kb preview  show what /kb apply would change, change nothing
--   /kb apply    set the bindings (and abilities on characters in Config.lua)
--   /kb restore  put back what was there before the first /kb apply
--   /kb forget   drop that saved copy, so the next /kb apply saves a fresh one

local addonName, ns = ...
local PREFIX = "|cff66ccffWyldKeys:|r "

local function say(msg) DEFAULT_CHAT_FRAME:AddMessage(PREFIX .. msg) end

-- Message labels per button, from Layout.lua.
local function labelsOf(bar)
  local t = {}
  for i, key in ipairs(bar.keys) do t[i] = (bar.labels and bar.labels[i]) or key end
  return t
end
local MAIN_KEYS = labelsOf(ns.MAIN)
local SHIFT_KEYS = labelsOf(ns.SHIFT)
local CTRL_KEYS = labelsOf(ns.CTRL)
local BAR4_KEYS = labelsOf(ns.BAR4)
local BAR5_KEYS = labelsOf(ns.BAR5)

-- Profiles ------------------------------------------------------------------------

-- Turns a Config.lua section into button numbers 1-12 per bar:
-- { main, bonus = { [bar number] = ... }, shift, ctrl, bar4, bar5 }, plus std:
-- the slots filled from ns.UTILITY, the standard entries shared by everyone.
-- Returns nil and a message if the section has a mistake.
local function buildProfile(c)
  local p = { main = {}, bonus = {}, shift = {}, ctrl = {}, bar4 = {}, bar5 = {}, std = {} }
  local own = c.keys or {}
  for key, entry in pairs(ns.UTILITY or {}) do
    local k = ns.KEYS[key]
    if own[key] == nil then
      p[k.section][k.button] = entry
      p.std[k.section .. k.button] = true
    end
  end
  for key, entry in pairs(own) do
    local k = ns.KEYS[key]
    if not k then return nil, "unknown key \"" .. tostring(key) .. "\"" end
    if entry == false then entry = nil end
    p[k.section][k.button] = entry
  end
  p.macros = {}
  if c.macros ~= nil then
    if type(c.macros) ~= "table" then return nil, "macros must be a list of name = text" end
    for mname, body in pairs(c.macros) do
      if type(mname) ~= "string" or type(body) ~= "string" then return nil, "macros must be a list of name = text" end
      if #mname > 16 then return nil, "macro name longer than 16 letters: \"" .. mname .. "\"" end
      body = body:gsub("^%s+", ""):gsub("%s+$", "")
      if #body > 255 then return nil, "macro \"" .. mname .. "\" is longer than 255 characters" end
      p.macros[mname] = body
    end
  end
  for name, list in pairs(c) do
    if name ~= "keys" and name ~= "macros" then
      local n = ns.BONUS_BARS[name]
      if not n then return nil, "unknown section \"" .. tostring(name) .. "\"" end
      if p.bonus[n] then return nil, "two sections for the same bar (" .. tostring(name) .. ")" end
      if list == "keys" then
        p.bonus[n] = p.main
      elseif type(list) ~= "table" then
        return nil, tostring(name) .. " must be \"keys\" or a list of main bar keys"
      else
        p.bonus[n] = {}
        for key, entry in pairs(list) do
          local k = ns.KEYS[key]
          if not (k and k.section == "main") then return nil, tostring(name) .. ": not a main bar key: \"" .. tostring(key) .. "\"" end
          p.bonus[n][k.button] = entry
        end
      end
    end
  end
  return p
end

-- The profile for the logged-in character: "Name-Realm" first, then "Name".
-- Returns nil when there is none, or nil and a message if its section has a mistake.
local function currentProfile()
  local name = UnitName("player")
  local realm = (GetNormalizedRealmName and GetNormalizedRealmName())
    or (GetRealmName and (GetRealmName():gsub("[%s%-]", "")))
  local config = ns.Config or {}
  local who = (realm and config[name .. "-" .. realm] and (name .. "-" .. realm)) or name
  if not config[who] then return nil end
  local p, err = buildProfile(config[who])
  if not p then return nil, "|cffff6666Config.lua, " .. who .. ":|r " .. err .. ". Nothing was changed." end
  return p
end

-- Bars and their action slots ------------------------------------------------

local function pages() return NUM_ACTIONBAR_PAGES or 6 end
local function slotMain(i) return i end
local function slotBonus(n, i) return (pages() + n - 1) * 12 + i end
local function slotShift(i) return ((BOTTOMLEFT_ACTIONBAR_PAGE or 6) - 1) * 12 + i end
local function slotCtrl(i) return ((BOTTOMRIGHT_ACTIONBAR_PAGE or 5) - 1) * 12 + i end
local function slotBar4(i) return ((RIGHT_ACTIONBAR_PAGE or 3) - 1) * 12 + i end
local function slotBar5(i) return ((LEFT_ACTIONBAR_PAGE or 4) - 1) * 12 + i end

-- Bindings ---------------------------------------------------------------------

local function layoutBindings(k)
  local B = {}
  for _, bar in ipairs({ ns.MAIN, ns.SHIFT, ns.CTRL }) do
    local labels = labelsOf(bar)
    for i, bind in ipairs(bar.binds) do
      local key = bind:gsub("§", function() return k.sec end)
      B[#B + 1] = { key, bar.command .. i, labels[i] .. " = " .. bar.bindText .. " " .. i }
    end
  end
  for _, b in ipairs(ns.SYSTEM) do B[#B + 1] = { b[1], b[2], b[3] } end
  return B
end

local function keysOf(cmd) return { GetBindingKey(cmd) } end

local function snapshotBindings()
  local t = {}
  for i = 1, GetNumBindings() do
    local info = { GetBinding(i) }
    local cmd = info[1]
    if cmd and #info > 2 then
      local keys = {}
      for j = 3, #info do keys[#keys + 1] = info[j] end
      t[cmd] = keys
    end
  end
  return t
end

local function bindingSetName(set)
  if set == 2 then return "this character only" end
  return "every character that uses account-wide bindings"
end

-- Abilities ----------------------------------------------------------------------

local function pickupSpell(name)
  ClearCursor()
  local id
  if C_Spell and C_Spell.GetSpellInfo then
    local info = C_Spell.GetSpellInfo(name)
    id = info and info.spellID
  end
  if C_Spell and C_Spell.PickupSpell then
    C_Spell.PickupSpell(id or name)
  elseif PickupSpell then
    PickupSpell(id or name)
  end
  return GetCursorInfo() ~= nil
end

local function itemInfoInstant(id)
  if C_Item and C_Item.GetItemInfoInstant then return C_Item.GetItemInfoInstant(id) end
  return GetItemInfoInstant(id)
end

local function itemLevel(id)
  if C_Item and C_Item.GetItemInfo then return select(4, C_Item.GetItemInfo(id)) or 0 end
  return select(4, GetItemInfo(id)) or 0
end

local function itemName(id)
  if C_Item and C_Item.GetItemNameByID then return C_Item.GetItemNameByID(id) end
  return (GetItemInfo(id))
end

-- What an item does when used, from its use spell: "Drink", "Food" or
-- "Refreshment" (both). nil for anything else.
function ns.ItemUse(id)
  local get = (C_Item and C_Item.GetItemSpell) or GetItemSpell
  if not get then return nil end
  return (get(id))
end

-- Does the item in this bag slot make you Well Fed? Read from its tooltip.
local scanner
local function wellFed(bag, slot)
  if not bag then return false end
  local lines = {}
  if C_TooltipInfo and C_TooltipInfo.GetBagItem then
    local data = C_TooltipInfo.GetBagItem(bag, slot)
    for _, l in ipairs(data and data.lines or {}) do lines[#lines + 1] = l.leftText end
  elseif CreateFrame and GameTooltip then
    scanner = scanner or CreateFrame("GameTooltip", "WyldKeysScanTip", nil, "GameTooltipTemplate")
    scanner:SetOwner(WorldFrame or UIParent, "ANCHOR_NONE")
    scanner:SetBagItem(bag, slot)
    for i = 1, scanner:NumLines() do
      local fs = _G["WyldKeysScanTipTextLeft" .. i]
      lines[#lines + 1] = fs and fs:GetText()
    end
  end
  for _, text in ipairs(lines) do
    if text and text:lower():find("well fed", 1, true) then return true end
  end
  return false
end

local function named(...)
  local patterns = { ... }
  return function(id, name)
    if not name then return false end
    for _, pat in ipairs(patterns) do if name:find(pat) then return true end end
    return false
  end
end

local MATCH = {
  bomb = function(id, name, sub, classID, subID) return sub == "Explosives" or (classID == 7 and subID == 2) end,
  potion = function(id, name) return name and name:find("Healing Potion", 1, true) ~= nil end,
  drink = function(id) local u = ns.ItemUse(id); return u == "Drink" or u == "Refreshment" end,
  food = function(id) local u = ns.ItemUse(id); return u == "Food" or u == "Refreshment" end,
  bandage = function(id, name, sub) return sub == "Bandages" or sub == "Bandage" end,
  stone = function(id, name) return name and name:find("Sharpening Stone", 1, true) ~= nil end,
  instant = function(id, name) return name and name:find("^Instant Poison") ~= nil end,
  crippling = function(id, name) return name and name:find("^Crippling Poison") ~= nil end,
  deadly = function(id, name) return name and name:find("^Deadly Poison") ~= nil end,
  mindnumbing = function(id, name) return name and name:find("^Mind%-numbing Poison") ~= nil end,
  weightstone = named("Weightstone"),
  oil = named("Wizard Oil$"),
  mana = named("Mana Potion"),
  agielixir = named("^Elixir of .*Agility", "^Elixir of the Mongoose"),
  strelixir = named("^Elixir of .*Strength", "^Elixir of Giants"),
  intelixir = named("^Elixir of Wisdom", "^Elixir of .*Intellect", "^Elixir of the Sages"),
  guardian = named("^Elixir of .*Defense", "^Elixir of .*Fortitude"),
  agiscroll = named("^Scroll of Agility"),
  strscroll = named("^Scroll of Strength"),
  intscroll = named("^Scroll of Intellect"),
  antivenom = named("Anti%-Venom$"),
  wellfed = function(id, name, sub, classID, subID, bag, slot)
    local u = ns.ItemUse(id)
    return (u == "Food" or u == "Refreshment") and wellFed(bag, slot)
  end,
}
local LABEL = { bomb = "bomb", potion = "healing potion", drink = "drink", food = "food", bandage = "bandage",
  stone = "sharpening stone", instant = "Instant Poison", crippling = "Crippling Poison",
  deadly = "Deadly Poison", mindnumbing = "Mind-numbing Poison",
  weightstone = "weightstone", oil = "wizard oil", mana = "mana potion",
  agielixir = "Agility elixir", strelixir = "Strength elixir", intelixir = "Intellect elixir",
  guardian = "guardian elixir", agiscroll = "Scroll of Agility", strscroll = "Scroll of Strength",
  intscroll = "Scroll of Intellect", antivenom = "Anti-Venom", wellfed = "buff food" }
-- Used in a macro when nothing of the kind is in the bags.
local FALLBACK = { stone = "Rough Sharpening Stone", instant = "Instant Poison", crippling = "Crippling Poison",
  deadly = "Deadly Poison", mindnumbing = "Mind-numbing Poison", weightstone = "Rough Weightstone",
  oil = "Minor Wizard Oil" }

-- The matching item with the highest item level in the bags, or nil.
-- Plain food prefers food that is not buff food, so Shift+X does not eat it.
local function bestItem(kind)
  local numSlots = (C_Container and C_Container.GetContainerNumSlots) or GetContainerNumSlots
  local itemID = (C_Container and C_Container.GetContainerItemID) or GetContainerItemID
  local best, bestLvl
  for bag = 0, 4 do
    for slot = 1, (numSlots(bag) or 0) do
      local id = itemID(bag, slot)
      if id then
        local _, _, sub, _, _, classID, subID = itemInfoInstant(id)
        if MATCH[kind](id, itemName(id), sub, classID, subID, bag, slot) then
          local lvl = itemLevel(id)
          if kind == "food" and not wellFed(bag, slot) then lvl = lvl + 1000 end
          if not best or lvl > bestLvl then best, bestLvl = id, lvl end
        end
      end
    end
  end
  return best
end

-- A macro's text with {best:kind} replaced by the best such item in the bags.
local function macroBody(body)
  return (body:gsub("{best:(%a+)}", function(kind)
    if not MATCH[kind] then return nil end
    local id = bestItem(kind)
    return (id and itemName(id)) or FALLBACK[kind] or LABEL[kind]
  end))
end

-- The first spell in a First(...) entry that the character knows.
local function firstKnown(entry)
  for _, n in ipairs(entry.any) do
    if C_Spell and C_Spell.GetSpellInfo and C_Spell.GetSpellInfo(n) then return n end
  end
end

-- Name of a layout entry for messages.
local function entryName(entry)
  if type(entry) == "table" and entry.any then return firstKnown(entry) or table.concat(entry.any, " or ") end
  if type(entry) == "table" and entry.macro then return "macro " .. entry.macro end
  if type(entry) == "table" and entry.item then return entry.name or itemName(entry.item) or ("item " .. entry.item) end
  if type(entry) == "table" and entry.best then
    local id = bestItem(entry.best)
    return "best " .. LABEL[entry.best] .. " in your bags (" .. (id and (itemName(id) or ("item " .. id)) or "none found") .. ")"
  end
  return entry
end

-- Puts a layout entry on the cursor: a spell by name, or the best bomb.
local function pickupEntry(entry)
  if type(entry) == "table" and entry.any then
    local n = firstKnown(entry)
    return n and pickupSpell(n) or false
  end
  if type(entry) == "table" and entry.macro then
    ClearCursor()
    local idx = GetMacroIndexByName(entry.macro)
    if idx and idx > 0 then PickupMacro(idx) end
    return GetCursorInfo() ~= nil
  end
  if type(entry) == "table" and entry.item then
    ClearCursor()
    if C_Item and C_Item.PickupItem then C_Item.PickupItem(entry.item) else PickupItem(entry.item) end
    return GetCursorInfo() ~= nil
  end
  if type(entry) == "table" and entry.best then
    ClearCursor()
    local id = bestItem(entry.best)
    if not id then return false end
    if C_Item and C_Item.PickupItem then C_Item.PickupItem(id) else PickupItem(id) end
    return GetCursorInfo() ~= nil
  end
  return pickupSpell(entry)
end

local function actionRecord(slot)
  local t, id, sub = GetActionInfo(slot)
  if not t then return { empty = true } end
  return { type = t, id = id, sub = sub }
end

local function actionName(rec)
  if not rec or rec.empty then return nil end
  if rec.type == "spell" and C_Spell and C_Spell.GetSpellName then return C_Spell.GetSpellName(rec.id) end
  if rec.type == "item" and C_Item and C_Item.GetItemNameByID then return C_Item.GetItemNameByID(rec.id) end
  if rec.type == "macro" and GetMacroInfo then return (GetMacroInfo(rec.id)) end
  return rec.type
end

local function placeRecord(slot, rec)
  ClearCursor()
  if rec.empty then
    PickupAction(slot)
    ClearCursor()
    return true
  end
  if rec.type == "spell" then
    if C_Spell and C_Spell.PickupSpell then C_Spell.PickupSpell(rec.id) else PickupSpell(rec.id) end
  elseif rec.type == "item" then
    if C_Item and C_Item.PickupItem then C_Item.PickupItem(rec.id) else PickupItem(rec.id) end
  elseif rec.type == "macro" then
    PickupMacro(rec.id)
  else
    return false
  end
  if GetCursorInfo() then
    PlaceAction(slot)
    ClearCursor()
    return true
  end
  return false
end

-- Builds the list of { slot, spell, where } for this character.
local function placements(layout)
  local P = {}
  local function add(list, slotFn, labels, barName, section)
    for i = 1, 12 do
      local spell = list and list[i]
      if spell then
        P[#P + 1] = { slot = slotFn(i), spell = spell, where = barName .. ", " .. (labels[i] or ("button " .. i)),
                      std = section and layout.std and layout.std[section .. i] }
      end
    end
  end
  add(layout.main, slotMain, MAIN_KEYS, ns.MAIN.barText)
  local bonusBars = {}
  for n in pairs(layout.bonus or {}) do bonusBars[#bonusBars + 1] = n end
  table.sort(bonusBars)
  for _, n in ipairs(bonusBars) do
    add(layout.bonus[n], function(i) return slotBonus(n, i) end, MAIN_KEYS, "Stance/stealth bar " .. n)
  end
  add(layout.shift, slotShift, SHIFT_KEYS, ns.SHIFT.barText)
  add(layout.ctrl, slotCtrl, CTRL_KEYS, ns.CTRL.barText)
  add(layout.bar4, slotBar4, BAR4_KEYS, ns.BAR4.barText, "bar4")
  add(layout.bar5, slotBar5, BAR5_KEYS, ns.BAR5.barText, "bar5")
  return P
end

-- Checks ----------------------------------------------------------------------------

local function ready()
  if InCombatLockdown() then say("Not in combat. Try again when combat is over."); return false end
  local k = WyldKeys_Account and WyldKeys_Account.keys
  if not (k and k.sec) then
    say("First run /kb setup so I know what the game calls your § key.")
    return false
  end
  return true
end

local function barWarnings()
  if MultiBarBottomLeft and not MultiBarBottomLeft:IsShown() then
    say("|cffffcc00Action Bar 2 is hidden.|r Turn it on in Edit Mode, or Shift+keys, Z and X may do nothing.")
  end
  if MultiBarBottomRight and not MultiBarBottomRight:IsShown() then
    say("|cffffcc00Action Bar 3 is hidden.|r Turn it on in Edit Mode, or Ctrl+1-3 may do nothing.")
  end
  if MultiBarRight and not MultiBarRight:IsShown() then
    say("|cffffcc00Action Bar 4 is hidden.|r Turn it on to see professions and travel.")
  end
  if MultiBarLeft and not MultiBarLeft:IsShown() then
    say("|cffffcc00Action Bar 5 is hidden.|r Turn it on to see buffs and consumables.")
  end
end

-- Macros ------------------------------------------------------------------------------

local function sortedNames(t)
  local names = {}
  for n in pairs(t or {}) do names[#names + 1] = n end
  table.sort(names)
  return names
end

-- What /kb apply would do with a macro: "create", "update" or "unchanged".
local function macroState(name, body)
  local idx = GetMacroIndexByName(name)
  if not idx or idx == 0 then return "create" end
  if GetMacroBody and GetMacroBody(idx) == body then return "unchanged" end
  return "update"
end

-- Creates or updates the character's macros from Config.lua (per character).
local function ensureMacros(macros)
  for _, name in ipairs(sortedNames(macros)) do
    local body = macroBody(macros[name])
    local state = macroState(name, body)
    if state ~= "unchanged" then
      local ok
      if state == "create" then
        ok = pcall(CreateMacro, name, "INV_MISC_QUESTIONMARK", body, true)
      else
        ok = pcall(EditMacro, GetMacroIndexByName(name), name, "INV_MISC_QUESTIONMARK", body)
      end
      if ok and (GetMacroIndexByName(name) or 0) > 0 then
        say("Macro " .. name .. (state == "create" and " created." or " updated."))
      else
        say("|cffff6666Could not " .. state .. " macro|r " .. name .. ". The character's macro list may be full.")
      end
    end
  end
end

-- Preview / apply / restore ---------------------------------------------------------

local function preview()
  if not ready() then return end
  local k = WyldKeys_Account.keys
  local layout, err = currentProfile()
  if err then say(err); return end
  say("Preview. Nothing is changed.")
  for _, b in ipairs(layoutBindings(k)) do
    local old = GetBindingAction(b[1])
    local note = (old and old ~= "" and old ~= b[2]) and ("  (was " .. old .. ")") or ""
    say("  " .. b[3] .. note)
  end
  say("Old keys on the main bar, Action Bar 2 and Ctrl+1-3 are cleared first, so 6-0 stop working.")
  if layout then
    for _, name in ipairs(sortedNames(layout.macros)) do
      local state = macroState(name, macroBody(layout.macros[name]))
      say("  Macro " .. name .. ": " .. (state == "create" and "will be created" or state == "update" and "will be updated" or "unchanged"))
    end
    for _, p in ipairs(placements(layout)) do
      local cur = actionName(actionRecord(p.slot))
      local name = entryName(p.spell)
      say("  " .. p.where .. ": " .. name .. (cur and cur ~= p.spell and not name:find(cur, 1, true) and ("  (replaces " .. cur .. ")") or ""))
    end
  else
    say("No abilities are placed for this character, only keys.")
  end
  say("Bindings will be saved for " .. bindingSetName(GetCurrentBindingSet()) .. ".")
  barWarnings()
end

local function apply()
  if not ready() then return end
  local k = WyldKeys_Account.keys
  local layout, err = currentProfile()
  if err then say(err); return end
  local plan = layout and placements(layout) or {}

  -- Keep a copy of what is there now, the first time only.
  if not WyldKeys_Char.backup then
    local actions = {}
    for _, p in ipairs(plan) do actions[p.slot] = actionRecord(p.slot) end
    WyldKeys_Char.backup = { at = time(), set = GetCurrentBindingSet(), bindings = snapshotBindings(), actions = actions }
    say("Saved a copy of your current keys" .. (#plan > 0 and " and bars" or "") .. ". /kb restore puts them back.")
  end
  -- Slots the layout fills for the first time (new in a later version) are
  -- added to the copy before they change, so /kb restore covers them too.
  local added = 0
  for _, p in ipairs(plan) do
    if WyldKeys_Char.backup.actions[p.slot] == nil then
      WyldKeys_Char.backup.actions[p.slot] = actionRecord(p.slot)
      added = added + 1
    end
  end
  if added > 0 then
    say("Added " .. added .. " more buttons to the saved copy. /kb restore puts them back too.")
  end

  -- Bindings. Mouse side buttons are not part of the layout; forget any
  -- that an earlier version stored.
  k.back, k.interrupt = nil, nil
  for _, cmd in ipairs(ns.MANAGED) do
    for _, key in ipairs(keysOf(cmd)) do SetBinding(key, nil) end
  end
  local failed = {}
  for _, b in ipairs(layoutBindings(k)) do
    if not SetBinding(b[1], b[2]) then failed[#failed + 1] = b[3] end
  end
  local set = GetCurrentBindingSet()
  SaveBindings(set)
  say("Keys set and saved for " .. bindingSetName(set) .. ".")
  for _, f in ipairs(failed) do say("|cffff6666Could not set:|r " .. f) end

  -- Abilities
  if layout then
    ensureMacros(layout.macros)
    local missing, empty = {}, {}
    for _, p in ipairs(plan) do
      if pickupEntry(p.spell) then
        PlaceAction(p.slot)
        ClearCursor()
      elseif p.std or (type(p.spell) == "table" and p.spell.best and p.where:find("^Action Bar [45]")) then
        local e = p.spell
        empty[#empty + 1] = (type(e) == "table" and e.best and LABEL[e.best]) or entryName(e)
      else
        missing[#missing + 1] = entryName(p.spell) .. " (" .. p.where .. ")"
      end
    end
    ClearCursor()
    say("Abilities placed: " .. (#plan - #missing - #empty) .. " of " .. #plan .. ".")
    for _, m in ipairs(missing) do say("|cffffcc00Not learned or not found:|r " .. m) end
    if #empty > 0 then say("Not learned or none in the bags, so those buttons are left as they were: " .. table.concat(empty, ", ") .. ".") end
    for i = 1, 12 do
      if not layout.main[i] then
        local cur = actionName(actionRecord(slotMain(i)))
        if cur then say("Left as it was: main bar " .. MAIN_KEYS[i] .. " has " .. cur .. ".") end
      end
    end
    local has = {}
    for _, p in ipairs(plan) do
      if type(p.spell) == "table" and p.spell.best then has[p.spell.best] = true end
    end
    local byHand = {}
    if not has.food then byHand[#byHand + 1] = "food" end
    if not has.bandage then byHand[#byHand + 1] = "bandages" end
    if #byHand > 0 then say("This layout has no key for " .. table.concat(byHand, " or ") .. "; place them yourself if you want one.") end
  else
    say("No abilities placed on this character, only keys.")
  end
  barWarnings()
end

local function restore()
  if InCombatLockdown() then say("Not in combat. Try again when combat is over."); return end
  local b = WyldKeys_Char.backup
  if not b then say("There is no saved copy for this character."); return end

  -- Bindings: clear every command that differs from the copy, then bind the copy.
  local now = snapshotBindings()
  local touched = {}
  for cmd in pairs(now) do touched[cmd] = true end
  for cmd in pairs(b.bindings) do touched[cmd] = true end
  local function same(a, c)
    a, c = a or {}, c or {}
    if #a ~= #c then return false end
    for i = 1, #a do if a[i] ~= c[i] then return false end end
    return true
  end
  local changed = {}
  for cmd in pairs(touched) do
    if not same(now[cmd], b.bindings[cmd]) then changed[#changed + 1] = cmd end
  end
  for _, cmd in ipairs(changed) do
    for _, key in ipairs(now[cmd] or {}) do SetBinding(key, nil) end
  end
  for _, cmd in ipairs(changed) do
    for _, key in ipairs(b.bindings[cmd] or {}) do SetBinding(key, cmd) end
  end
  SaveBindings(GetCurrentBindingSet())

  -- Bars
  local notBack = {}
  for slot, rec in pairs(b.actions or {}) do
    if not placeRecord(slot, rec) then notBack[#notBack + 1] = slot end
  end
  ClearCursor()
  say("Keys and bars put back as they were before /kb apply.")
  if #notBack > 0 then say("|cffffcc00Could not put back action slots:|r " .. table.concat(notBack, ", ") .. " (mounts, pets or similar). Drag those back by hand.") end
  WyldKeys_Char.backup = nil
end

-- Setup: learn what the game calls the § key (keyboard only) ---------------------

local cap, capText
local MODIFIERS = { LSHIFT = true, RSHIFT = true, LCTRL = true, RCTRL = true, LALT = true, RALT = true, LMETA = true, RMETA = true }

local function onKey(_, key)
  if key == "ESCAPE" then
    cap:Hide()
    say("Setup cancelled. Nothing was saved.")
    return
  end
  if MODIFIERS[key] then return end
  WyldKeys_Account.keys = WyldKeys_Account.keys or {}
  WyldKeys_Account.keys.sec = key
  cap:Hide()
  say("Learned: § key = " .. key .. ". Next: /kb preview, then /kb apply.")
end

local function setup()
  if InCombatLockdown() then say("Not in combat. Try again when combat is over."); return end
  if not cap then
    cap = CreateFrame("Frame", "WyldKeysCapture", UIParent)
    cap:SetAllPoints(UIParent)
    cap:SetFrameStrata("FULLSCREEN_DIALOG")
    local bg = cap:CreateTexture(nil, "BACKGROUND")
    bg:SetAllPoints()
    bg:SetColorTexture(0, 0, 0, 0.6)
    capText = cap:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
    capText:SetPoint("CENTER")
    capText:SetJustifyH("CENTER")
    capText:SetText("Press the key left of 1 (the \194\167 key).\nEsc cancels.")
    cap:EnableKeyboard(true)
    cap:SetScript("OnKeyDown", onKey)
  end
  cap:Show()
end

-- Slash command ---------------------------------------------------------------------

SLASH_WYLDKEYS1 = "/kb"
SLASH_WYLDKEYS2 = "/wyldkeys"
SlashCmdList.WYLDKEYS = function(msg)
  local cmd = strlower(strtrim(msg or ""))
  if cmd == "setup" then setup()
  elseif cmd == "preview" then preview()
  elseif cmd == "apply" then apply()
  elseif cmd == "restore" then restore()
  elseif cmd == "forget" then
    WyldKeys_Char.backup = nil
    say("Forgot the saved copy for this character. The next /kb apply saves a fresh one.")
  elseif cmd == "keys" then
    local k = WyldKeys_Account.keys or {}
    say("§ key = " .. tostring(k.sec))
  else
    say("/kb setup, /kb preview, /kb apply, /kb restore, /kb forget, /kb keys")
  end
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(_, _, name)
  if name ~= addonName then return end
  WyldKeys_Account = WyldKeys_Account or {}
  WyldKeys_Char = WyldKeys_Char or {}
end)
