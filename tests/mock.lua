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

-- Test harness: runs WyldKeys outside the game against a fake WoW API.
--
-- Usage, from the repository root:
--   lua5.1 tests/mock.lua <Character>        (Galdorin, Meagor, Thorim, or any other name)
--   sh tests/run.sh                          (all characters, compared with tests/expected/)
--
-- What it fakes: key bindings (a few defaults), action slots, the spells each
-- test character knows, bag contents (bombs, rockets, potions) and the cursor.
-- It then runs: /kb apply before setup (refused), /kb setup and the § key,
-- /kb keys, /kb preview, /kb apply, /kb restore, and prints the bindings and
-- action slots after apply and after restore.
--
-- Test cases built in: Galdorin has every spell but no healing potion, and his
-- two stance macros are created on apply (and unchanged on a second preview); Thorim
-- has not learned Fire Nova or Ancestral Spirit and has something on § and a
-- macro on G; a character with no Config.lua section gets keys only. Stored
-- side-button keys (F8/F9) from an earlier version are set before apply, to
-- check that they are forgotten.

local binds = { F8="MOVEBACKWARD", F9="MULTIACTIONBAR2BUTTON12", ["1"]="ACTIONBUTTON1",["2"]="ACTIONBUTTON2",["6"]="ACTIONBUTTON6",["0"]="ACTIONBUTTON10",R="REPLY",Z="TOGGLESHEATH",X="SITORSTAND",BUTTON4="TOGGLEAUTORUN",S="MOVEBACKWARD",Q="TURNLEFT" }
local CMDS = {}
for i=1,12 do CMDS[#CMDS+1]="ACTIONBUTTON"..i; CMDS[#CMDS+1]="MULTIACTIONBAR1BUTTON"..i; CMDS[#CMDS+1]="MULTIACTIONBAR2BUTTON"..i end
for _,c in ipairs{"REPLY","TOGGLESHEATH","SITORSTAND","TOGGLEAUTORUN","MOVEBACKWARD","TURNLEFT"} do CMDS[#CMDS+1]=c end
function GetNumBindings() return #CMDS end
function GetBindingKey(cmd) local t={} for k,v in pairs(binds) do if v==cmd then t[#t+1]=k end end table.sort(t) return unpack(t) end
function GetBinding(i) local c=CMDS[i]; return c,"cat",GetBindingKey(c) end
function SetBinding(k,c) binds[k]=c return true end
function GetBindingAction(k) return binds[k] or "" end
function GetCurrentBindingSet() return 1 end
saved=0 function SaveBindings() saved=saved+1 end
function InCombatLockdown() return false end
local CHAR = arg[1] or "Meagor"
local KNOWN = {
 Meagor={["Eureka!"]=900003,Stealth=1784,["Sinister Strike"]=1752,Backstab=53,Eviscerate=2098,["Slice and Dice"]=5171,Gouge=1776,Evasion=5277,Throw=2764,["Pick Pocket"]=921,Sap=6770,Sprint=2983,["Pick Lock"]=1804,Kick=1766},
 -- every Galdorin spell is known
 Galdorin={Charge=100,["Sunder Armor"]=7386,Revenge=6572,["Heroic Strike"]=78,["Shield Block"]=2565,["Thunder Clap"]=6343,["Demoralizing Shout"]=1160,["Shield Bash"]=72,Cleave=845,Taunt=355,Throw=2764,Disarm=676,["Battle Stance"]=2457,["Defensive Stance"]=71,Bloodrage=2687,["Battle Shout"]=6673,Overpower=7384,Rend=772,Slam=1464,["Victory Rush"]=34428,Hamstring=1715,Retaliation=20230,["Intimidating Shout"]=5246,["Find Treasure"]=2481,["First Aid"]=3273},
 -- Fire Nova and Ancestral Spirit not learned yet
 -- Dampen Magic not learned yet
 Leorn={["Arcane Missiles"]=5143,Frostbolt=116,["Fire Blast"]=2136,Polymorph=118,Shoot=5019,["Frost Nova"]=122,["Walk on Air"]=900001,Fireball=133,["Arcane Intellect"]=1459,["Frost Armor"]=168,["Read Leyline"]=900002,["Conjure Water"]=5504,["Conjure Food"]=587},
 -- level 6: forms and everything feral still to come
 Drealltar={Wrath=5176,Moonfire=8921,["Healing Touch"]=5185,Rejuvenation=774,["Mark of the Wild"]=1126,Thorns=467,Shadowmeld=20580,["Elune's Light"]=900004},
 Thorim={["Lightning Bolt"]=403,["Flame Shock"]=8050,["Healing Wave"]=331,["Searing Totem"]=3599,["Strength of Earth Totem"]=8075,["Stoneclaw Totem"]=5730,["Earth Shock"]=8042,Purge=370,["Stoneskin Totem"]=8071,["Earthbind Totem"]=2484,["Lightning Shield"]=324,["Rockbiter Weapon"]=8017,["Flametongue Weapon"]=8024},
}
local known=KNOWN[CHAR] or {}
local cursor, bars = nil, {[5]={"spell",1752},[70]={"item",117}}
if CHAR=="Thorim" then bars[1]={"spell",403}; bars[12]={"macro",3} end -- § and G are not in Thorim's profile
C_Spell={GetSpellInfo=function(n) return known[n] and {spellID=known[n]} end, PickupSpell=function(id) for n,v in pairs(known) do if v==id then cursor={"spell",id} end end end, GetSpellName=function(id) for n,v in pairs(known) do if v==id then return n end end return "spell"..id end}
C_Item={PickupItem=function(id) cursor={"item",id} end, GetItemNameByID=function(id) local n={[4360]="Rough Copper Bomb",[4370]="Large Copper Bomb",[1178]="Explosive Rocket",[118]="Minor Healing Potion",[858]="Lesser Healing Potion",[2455]="Minor Mana Potion",[5350]="Conjured Water",[2288]="Conjured Fresh Water",[5349]="Conjured Muffin",[1113]="Conjured Bread",[2593]="Flask of Stormwind Tawny",[1251]="Linen Bandage",[2581]="Heavy Linen Bandage",[2862]="Rough Sharpening Stone",[2863]="Coarse Sharpening Stone",[6947]="Instant Poison",[2680]="Spiced Wolf Meat",[5997]="Elixir of Minor Defense",[3241]="Rough Weightstone"} return n[id] or ("Item"..id) end,
 GetItemInfoInstant=function(id) if id==4360 or id==4370 then return id,"Trade Goods","Explosives","",0,7,2 end if id==1251 or id==2581 then return id,"Consumable","Bandages","",0,0,7 end return id,"Consumable","Other","",0,0,8 end,
 GetItemInfo=function(id) local l={[4360]=14,[4370]=20,[1178]=8,[118]=5,[858]=13,[2455]=5,[5350]=5,[2288]=15,[5349]=5,[1113]=15,[2593]=10,[1251]=5,[2581]=15,[2862]=5,[2863]=15,[6947]=20,[2680]=10,[5997]=2,[3241]=5} return "x","l",1,l[id] or 1 end}
C_Item.GetItemSpell=function(id) return C_Item_GetItemSpell and C_Item_GetItemSpell(id) end
-- Galdorin: professions in the profession book (as in the game), where the
-- spell looked up by name would be another spell. Book slots 40-44.
if CHAR=="Galdorin" then
  Enum={SpellBookSpellBank={Player=0}}
  local book={[40]="Blacksmithing",[41]="Mining",[42]="Smelting",[43]="Cooking",[44]="Fishing"}
  function GetProfessions() return 1,2,nil,4,5 end
  function GetProfessionInfo(i) local t={[1]={"Blacksmithing",1,0},[2]={"Mining",2,1},[4]={"Fishing",1,4},[5]={"Cooking",1,3}} local e=t[i] return e[1],"icon",1,75,e[2],39+e[3] end
  C_SpellBook={GetSpellBookItemName=function(slot,bank) return bank==0 and book[slot] end, PickupSpellBookItem=function(slot,bank) if book[slot] then cursor={"book",slot} end end}
end
local bag={[0]={1178,4360,118,2455},[1]={4370,858}}
if CHAR=="Galdorin" then bag={[0]={2455,4360,3241}} end -- no healing potion; a mana potion he should not get
-- Meagor: two sharpening stones (the coarse one should win) and Instant Poison, no Crippling Poison.
if CHAR=="Meagor" then bag={[0]={1178,4360,118,2455,2862},[1]={4370,858,2863,6947}} end
-- Leorn: two waters and two foods; the higher item level should win, ale is neither.
-- Leorn also has buff food (Well Fed): it goes on Action Bar 5, not on Shift+X.
if CHAR=="Leorn" then bag={[0]={5350,2288,118,2680,5997},[1]={5349,1113,2593,1251,2581}} end
local USE={[5350]="Drink",[2288]="Drink",[5349]="Food",[1113]="Food",[2593]=nil,[2680]="Food"}
C_TooltipInfo={GetBagItem=function(b,s) local id=bag[b] and bag[b][s]; if id==2680 then return {lines={{leftText="Spiced Wolf Meat"},{leftText="Use: Restores 61 health over 15 sec. If you spend at least 10 seconds eating you will become well fed and gain 2 Stamina and Spirit for 15 min."}}} end return {lines={{leftText="x"}}} end}
C_Item_GetItemSpell=function(id) return USE[id] end
C_Container={GetContainerNumSlots=function(b) return bag[b] and #bag[b] or 0 end, GetContainerItemID=function(b,s) return bag[b] and bag[b][s] end}
-- Macros: index -> { name, body }. Index 3 is a macro the player made (on Thorim's G).
local macros = { [3] = { "My macro", "/say hi" } }
function GetMacroIndexByName(n) for i, m in pairs(macros) do if m[1] == n then return i end end return 0 end
function GetMacroBody(i) return macros[i] and macros[i][2] end
function GetMacroInfo(i) return macros[i] and macros[i][1] end
function CreateMacro(n, icon, body, per) local i = 121; while macros[i] do i = i + 1 end; macros[i] = { n, body }; print("[mock] CreateMacro " .. n .. " per=" .. tostring(per)); for l in body:gmatch("/use [^\n]+") do print("[mock]   " .. l) end return i end
function EditMacro(i, n, icon, body) macros[i] = { n, body }; return i end
function PickupMacro(i) if macros[i] then cursor = { "macro", i } end end
function GetCursorInfo() return cursor and cursor[1] end
function ClearCursor() cursor=nil end
function PlaceAction(s) local old=bars[s]; bars[s]=cursor; cursor=old end
function PickupAction(s) cursor=bars[s]; bars[s]=nil end
function GetActionInfo(s) local a=bars[s]; if a then return a[1],a[2] end end
function UnitName() return CHAR end
function time() return 1 end
DEFAULT_CHAT_FRAME={AddMessage=function(_,m) print(m) end}
SlashCmdList={}
GetTime=function() return os.clock()*1000 end; strupper=string.upper; strlower=string.lower; strtrim=function(s) return (s:gsub("^%s+",""):gsub("%s+$","")) end
local frames={}
function CreateFrame() local f={scripts={}}; function f:RegisterEvent() end; function f:RegisterForClicks() end; function f:SetScript(n,fn) self.scripts[n]=fn end
 function f:SetAllPoints() end function f:SetFrameStrata() end function f:EnableKeyboard() end function f:EnableMouse() end function f:Show() end function f:Hide() end
 function f:CreateTexture() return {SetAllPoints=function() end,SetColorTexture=function() end} end
 function f:CreateFontString() return {SetPoint=function() end,SetJustifyH=function() end,SetText=function(_,t) print("[overlay] "..t:gsub("\n"," ")) end} end
 frames[#frames+1]=f return f end
UIParent={}
-- Load every file listed in the .toc, in order, with one shared ns table, as WoW does.
local here = (arg[0]:match("^(.*)/[^/]*$") or ".")
local dir = os.getenv("WK_DIR") or (here .. "/../WyldKeys/")
local ns = {}
for line in io.lines(dir .. "WyldKeys.toc") do
  line = line:gsub("\r$", "")
  if line:match("%S") and not line:match("^#") then
    assert(loadfile(dir .. line:gsub("\\", "/")))("WyldKeys", ns)
  end
end
frames[1].scripts.OnEvent(nil,"ADDON_LOADED","WyldKeys")
local kb=SlashCmdList.WYLDKEYS
kb("apply")
kb("setup")
local cap=frames[2]
cap.scripts.OnKeyDown(nil,"§")
kb("keys")
WyldKeys_Account.keys.back="F8"; WyldKeys_Account.keys.interrupt="F9"
kb("preview")
kb("prof")
print("---- apply")
kb("apply")
print("---- preview again")
kb("preview")
local function dump() local t={} for k,v in pairs(binds) do t[#t+1]=k.."="..v end table.sort(t) print(table.concat(t," ")) local b={} for s,a in pairs(bars) do b[#b+1]=s..":"..a[1]..a[2] end table.sort(b) print(table.concat(b," ")) end
dump()
print("---- restore")
kb("restore")
dump()
