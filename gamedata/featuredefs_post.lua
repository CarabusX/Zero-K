-- $Id: featuredefs_post.lua 3171 2008-11-06 09:06:29Z det $
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  file:    featuredefs_post.lua
--  brief:   featureDef post processing
--  author:  Dave Rodgers
--  author:  lurker & jK
--
--  Copyright (C) 2008,2009.
--  Licensed under the terms of the GNU GPL, v2 or later.
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function isbool(x)   return (type(x) == 'boolean') end
local function istable(x)  return (type(x) == 'table')   end
local function isnumber(x) return (type(x) == 'number')  end
local function isstring(x) return (type(x) == 'string')  end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local mapEnergyMult   = .1  --Used to normalize map features to a mod-specific scale
local mapMetalMult    = 1
local mapReclaimMult  = 1


-- scale energy/reclaimtime of map's features
for name, fd in pairs(FeatureDefs) do
	if (type(fd.customparams)~="table") or not(fd.customparams.mod) then
		if tonumber(fd.energy) then 
			fd.energy = fd.energy * mapEnergyMult 
		end
		if tonumber(fd.metal) then 
			fd.metal = fd.metal * mapMetalMult 
		end
		fd.reclaimtime = math.max(fd.energy or 0, fd.metal or 0)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  Per-unitDef featureDefs
--

local function ProcessUnitDef(udName, ud)

  local fds = ud.featuredefs
  if (not istable(fds)) then
    return
  end

  -- add this unitDef's featureDefs
  for fdName, fd in pairs(fds) do
    if (isstring(fdName) and istable(fd)) then
      local fullName = udName .. '_' .. fdName
      FeatureDefs[fullName] = fd
	  fd.customparams = fd.customparams or {}
	  fd.customparams.fromunit = "1"
      fd.filename = ud.filename
    end
  end

  -- FeatureDead name changes
  for fdName, fd in pairs(fds) do
    if (isstring(fdName) and istable(fd)) then
      if (isstring(fd.featuredead)) then
        local fullName = udName .. '_' .. fd.featuredead:lower()
        if (FeatureDefs[fullName]) then
          fd.featuredead = fullName
        end
      end
    end
  end

  -- convert the unit corpse name
  if (isstring(ud.corpse)) then
    local fullName = udName .. '_' .. ud.corpse:lower()
    local fd = FeatureDefs[fullName]
    if (fd) then
      fd.resurrectable = 1
      ud.corpse = fullName
	  --if fd.metal ~= ud.buildcostmetal*0.4 or fd.damage ~= ud.maxdamage then
	  --  Spring.Echo(ud.name)
	  --end
    end
  end

end


--------------------------------------------------------------------------------

-- Process the unitDefs

local UnitDefs = DEFS.unitDefs

for udName, ud in pairs(UnitDefs) do
  if (isstring(udName) and istable(ud)) then
    ProcessUnitDef(udName, ud)
  end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- resurrectable = -1 seems to be broken, set it to 0 for all values which are not 1

for name, def in pairs(FeatureDefs) do
	if def.resurrectable ~= 1 then
		def.resurrectable = 0
	end
end
 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
