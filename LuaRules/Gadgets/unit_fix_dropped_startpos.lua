--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function gadget:GetInfo()
  return {
    name      = "DroppedStartPos",
    desc      = "fixes start postion for dropped players",
    author    = "SirMaverick",
    date      = "August 3, 2009",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end

local modOptions = Spring.GetModOptions()
local fudgeFactor = 128 -- added to max to solve edge-of-startpos problem

function gadget:GameFrame(n)

  if (n == 1) and (Game.startPosType == 2) then
    if modOptions and (modOptions.shuffle == "off" or modOptions.shuffle == 'box') then
      -- ok
    else
      -- don't undo shuffle
      gadgetHandler:RemoveGadget()
      return
    end
    -- check if all units are within their start boxes
    local units = Spring.GetAllUnits()
    for i=1,#units do

      repeat -- emulating "continue"

        local unitid = units[i]
        local allyid = Spring.GetUnitAllyTeam(unitid)
        if not allyid then break end
        local xmin, zmin, xmax, zmax = Spring.GetAllyTeamStartBox(allyid)
        if not xmin then break end
        xmin = xmin - fudgeFactor
        zmin = zmin - fudgeFactor
		xmax = xmax + fudgeFactor
		zmax = zmax + fudgeFactor
        local x, y, z = Spring.GetUnitPosition(unitid)

        if not x then break end
        if (GG.PlanetWars and (GG.PlanetWars.unitsByID[unitid] or GG.PlanetWars.hqs)) or (xmin <= x and x <= xmax and zmin <= z and z <= zmax) then
          -- all ok
        else
          -- move into middle of team start box
          Spring.SetUnitPosition(unitid, (xmin+xmax)/2, (zmin+zmax)/2)
          Spring.GiveOrderToUnit(unitid, CMD.STOP, {}, {});
        end
      until true
    end

    gadgetHandler:RemoveGadget()
    return

  end
end

