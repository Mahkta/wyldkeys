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


-- Builds the keybinds overview (overview/keybinds.html) from the addon's own
-- Layout.lua and Config.lua, plus overview/Presentation.lua for labels and notes.
--
-- Usage, from the repository root (Lua 5.1):
--   lua5.1 overview/build.lua           write overview/keybinds.html
--   lua5.1 overview/build.lua --check   exit 1 if keybinds.html is out of date

local here = (arg[0]:match("^(.*)/[^/]*$") or ".")
local addonDir = here .. "/../WyldKeys/"

-- Load the addon's data files the way the game does: same private table.
local ns = {}
for _, f in ipairs({ "Layout.lua", "Config.lua" }) do
  assert(loadfile(addonDir .. f))("WyldKeys", ns)
end
local P = dofile(here .. "/Presentation.lua")

-- Key label in Config.lua -> keyboard layer and key id in the page.
local function keyOf(label)
  local layer, key = "base", label
  local mod, rest = label:match("^(%a+)%+(.+)$")
  if mod == "Shift" then layer, key = "shift", rest
  elseif mod == "Ctrl" then layer, key = "ctrl", rest end
  if key == "§" then key = "sec" end
  return layer, key
end

-- Colour category by position in the key scheme.
local CATEGORY = {
  base = { sec = "open", ["1"] = "core", ["2"] = "core", ["3"] = "core", ["4"] = "core", ["5"] = "core",
           Q = "cd", E = "intr", R = "aoe", F = "util", T = "rng", G = "def", Z = "rare", X = "rare" },
  shift = { sec = "open", ["1"] = "alt", ["2"] = "alt", ["3"] = "alt", ["4"] = "alt", ["5"] = "alt",
            Q = "def", E = "big", R = "big", F = "big" },
  ctrl = { ["1"] = "ooc", ["2"] = "ooc", ["3"] = "ooc", ["4"] = "ooc", ["5"] = "ooc" },
}
local function category(layer, key) return (CATEGORY[layer] and CATEGORY[layer][key]) or "rare" end

-- Ability name as the overview shows it.
local function abilityName(entry)
  if type(entry) == "string" then return entry end
  if type(entry) == "table" and entry.best == "bomb" then return "Engineering bomb (best in bags)" end
  if type(entry) == "table" and entry.best == "potion" then return "Healing potion (best in bags)" end
  if type(entry) == "table" and entry.best == "drink" then return "Drink (best in bags)" end
  if type(entry) == "table" and entry.best == "food" then return "Food (best in bags)" end
  if type(entry) == "table" and entry.best == "bandage" then return "Bandage (best in bags)" end
  if type(entry) == "table" and entry.item then return entry.name or ("Item " .. entry.item) end
  if type(entry) == "table" and entry.macro then return entry.label or ("Macro " .. entry.macro) end
  error("unknown ability entry: " .. tostring(entry))
end

local currentView
local function categoryFor(layer, key, label)
  local o = P.categories and P.categories[currentView]
  return (o and label and o[label]) or category(layer, key)
end

local function entryFor(name, layer, key, label)
  return { a = name, s = P.short[name], c = categoryFor(layer, key, label) }
end

local function freeFor(view, label, layer, key)
  local e = { free = 1, c = categoryFor(layer, key, label) }
  local later = P.later[view] and P.later[view][label]
  if type(later) == "table" then e.later, e.ls = later[1], later[2]
  elseif later then e.later, e.ls = later, later:gsub("%s*%b()$", "") end
  return e
end

local MAIN_LABELS = ns.MAIN.keys

local function buildView(view, title, keys, isBonus, parent)
  currentView = view
  local out = { n = title, base = {}, shift = {}, ctrl = {}, note = P.notes[view], parent = parent }
  for label, entry in pairs(keys) do
    if not ns.KEYS[label] then error(view .. ": unknown key " .. label) end
    local layer, key = keyOf(label)
    out[layer][key] = entryFor(abilityName(entry), layer, key, label)
  end
  -- Main bar keys with nothing on them are shown as free.
  for _, label in ipairs(MAIN_LABELS) do
    local layer, key = keyOf(label)
    if not out[layer][key] then out[layer][key] = freeFor(view, label, layer, key) end
  end
  -- Other free keys only when a later use is noted.
  for label in pairs(P.later[view] or {}) do
    local layer, key = keyOf(label)
    if not out[layer][key] then out[layer][key] = freeFor(view, label, layer, key) end
  end
  if not isBonus then
    for label, what in pairs(P.manual) do
      local layer, key = keyOf(label)
      if not out[layer][key] then out[layer][key] = { a = what, c = category(layer, key) } end
    end
  end
  for label, text in pairs(P.hints[view] or {}) do
    local layer, key = keyOf(label)
    if out[layer][key] then out[layer][key].n = text end
  end
  return out
end

local profiles = {}
for name, section in pairs(ns.Config) do
  local view = name:lower()
  profiles[view] = buildView(view, name, section.keys or {}, false)
  for bar in pairs(ns.BONUS_BARS) do
    local keys = section[bar]
    if type(keys) == "table" then
      local child = view .. "-" .. bar
      profiles[child] = buildView(child, name .. " " .. (P.barTitles[bar] or bar), keys, true, view)
    end
  end
end

-- Game functions the layout moves (Ctrl+R, Ctrl+Z, Ctrl+X), for every view.
local global = { base = {}, shift = {}, ctrl = {} }
for _, b in ipairs(ns.SYSTEM) do
  local key = b[1]:match("^CTRL%-(.+)$")
  if key then
    local text = b[3]:match("=%s*(.+)$") or b[2]
    global.ctrl[key] = { a = text, s = P.short[text], c = "sys" }
  end
end

-- Small JSON writer with sorted keys, so the output only changes when the data does.
local function json(v)
  local t = type(v)
  if t == "string" then
    return '"' .. v:gsub('[%c"\\]', function(c)
      if c == '"' then return '\\"' elseif c == "\\" then return "\\\\" elseif c == "\n" then return "\\n" end
      return string.format("\\u%04x", c:byte())
    end):gsub("</", "<\\/") .. '"'
  elseif t == "number" then return tostring(v)
  elseif t == "boolean" then return tostring(v)
  elseif t == "table" then
    local keys = {}
    for k in pairs(v) do keys[#keys + 1] = k end
    table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)
    local parts = {}
    for _, k in ipairs(keys) do parts[#parts + 1] = json(tostring(k)) .. ":" .. json(v[k]) end
    return "{" .. table.concat(parts, ",") .. "}"
  end
  error("cannot write " .. t)
end

local f = assert(io.open(here .. "/template.html", "rb"))
local template = f:read("*a"); f:close()
local data = json({ global = global, profiles = profiles })
local s, e = template:find("/*@GEN@*/null", 1, true)
assert(s, "placeholder /*@GEN@*/null not found in template.html")
local html = template:sub(1, s - 1) .. data .. template:sub(e + 1)

local outPath = here .. "/keybinds.html"
if arg[1] == "--check" then
  local g = io.open(outPath, "rb")
  local current = g and g:read("*a"); if g then g:close() end
  if current ~= html then
    io.stderr:write("overview/keybinds.html is out of date: run lua5.1 overview/build.lua\n")
    os.exit(1)
  end
  print("overview up to date")
else
  local w = assert(io.open(outPath, "wb"))
  w:write(html); w:close()
  print("wrote " .. outPath)
end
