-- $Id: unit_transport_ai.lua 4460 2009-04-20 20:36:16Z licho $
include("keysym.h.lua")

function widget:GetInfo()
  return {
    name      = "Transport AI",
    desc      = "Automatically transports units going to factory waypoint.\n" ..
                "Adds embark=call for transport and disembark=unload from transport command",
    author    = "Licho",
    date      = "1.11.2007, 9.7.2014",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true
  }
end


local CONST_HEIGHT_MULTIPLIER = 3 -- how many times to multiply height difference when evaluating distance
local CONST_TRANSPORT_PICKUPTIME = 9 -- how long (in seconds) does transport land and takeoff with unit
local CONST_PRIORITY_BENEFIT = 10000 -- how much more important are priority transfers
local CONST_BENEFIT_LIMIT = 5  -- what is the lowest benefit treshold to use transport (in sec difference with transport against without it)
local CONST_TRANSPORT_STOPDISTANCE = 150 -- how close by has transport be to stop the unit
local CONST_UNLOAD_RADIUS = 200 -- how big is the radious for unload command for factory transports

local idleTransports = {} -- list of idle transports key = id, value = {defid}
local waitingUnits = {} -- list of units waiting for traqnsport - key = unitID, {unit state, unitDef, factory}
local priorityUnits = {} -- lists of priority units waiting for key= unitId, value = state
local toPick = {} -- list of units waiting to be picked - key = transportID, value = {id, stoppedState}
local toPickRev = {} -- list of units waiting to be picked - key = unitID, value=transportID
local storedQueue = {} -- unit keyed stored queues
local hackIdle ={} -- temp field to overcome unitIdle problem
local floatDefs = VFS.Include("LuaRules/Configs/float_defs.lua") --list of unit able to float for pickup at sea


local ST_ROUTE = 1 -- unit is enroute from factory
local ST_PRIORITY = 2 -- unit is in need of priority transport
local ST_STOPPED = 3 -- unit is enroute from factory but stopped


local timer = 0
local myTeamID 

local GetUnitPosition = Spring.GetUnitPosition
local GetUnitDefID = Spring.GetUnitDefID
local Echo = Spring.Echo
local GetPlayerInfo = Spring.GetPlayerInfo
local GetCommandQueue = Spring.GetCommandQueue
local GetUnitSeparation = Spring.GetUnitSeparation
local GiveOrderToUnit = Spring.GiveOrderToUnit
local GetUnitDefDimensions = Spring.GetUnitDefDimensions
local GetTeamUnits = Spring.GetTeamUnits
local GetSelectedUnits = Spring.GetSelectedUnits
local GetUnitIsTransporting = Spring.GetUnitIsTransporting
local GetGroundHeight = Spring.GetGroundHeight

options_path = 'Game/Transport AI'
options = {
	transportFromFactory = {
		name = "Transport From Factory",
		type = "bool",
		value = false,
		desc = "When enabled newly completed units will be transported to the waypoint of their parent factory.",
	},
	ignoreBuilders = {
		name = "Ignore Constructors From Factory",
		type = "bool",
		value = false,
		desc = "Enable to not transport newly completed constructors.",
	},
}

local function TableInsert(tab, toInsert)
  tab[#tab+1] = toInsert
end

local function ExtractModifiedOptions(options) --FIXME: pls check again if I'm really needed. This is a respond to https://code.google.com/p/zero-k/issues/detail?id=1824 (options in online game coded different than in local game)
	local alt,ctrl,shift,internal,right
	for i,value in pairs(options) do 
		if value == "alt" then
			alt = true
		elseif value== "ctrl" then
			ctrl = true
		elseif value == "shift" then
			shift =true
		elseif value == "internal" then
			internal = true
		elseif value == "right" then
			right = true
		end
	end
	return alt,ctrl,shift,internal,right
end

function IsTransport(unitDefID) 
  ud = UnitDefs[unitDefID]
  return (ud ~= nil and (ud.transportCapacity >= 1) and ud.canFly)
end

function IsTransportable(unitDefID, unitID)  
  ud = UnitDefs[unitDefID]
  if (ud == nil) then return false end
  udc = ud.springCategories
  local _,_,_,_,y =Spring.GetUnitPosition(unitID,true)
  y = y + Spring.GetUnitRadius(unitID)
  return (udc~= nil and ud.speed > 0 and not ud.canFly and (y>-20 or floatDefs[unitDefID]))
end


function IsEmbarkCommand(unitID)
 local queue = GetCommandQueue(unitID, 1);        
 if (queue ~= nil and #queue>=1 and IsEmbark(queue[1])) then 
   return true
 end
 return false
end

function IsEmbark(cmd)
  local alt,ctrl = ExtractModifiedOptions(cmd.options)
  if (cmd.id == CMD.WAIT and (cmd.options.alt or alt) and not (cmd.options.ctrl or ctrl)) then 
    return true
  end
  return false
end

function IsDisembark(cmd)
  local alt,ctrl = ExtractModifiedOptions(cmd.options)
  if (cmd.id == CMD.WAIT and (cmd.options.alt or alt) and (cmd.options.ctrl or ctrl)) then
    return true
  end
  return false
end
  
function IsWaitCommand(unitID)
	local queue = GetCommandQueue(unitID, 1);
	local alt
	if queue then
		alt = ExtractModifiedOptions(queue[1].options)
	end
	if (queue ~= nil and queue[1].id == CMD.WAIT and not (queue[1].options.alt or alt)) then 
		return true
	end
	return false
end

function IsIdle(unitID) 
  local queue = GetCommandQueue(unitID, 1)
  if (queue == nil or #queue==0) then 
    return true
  else
    return false
  end
end

function GetToPickTransport(unitID)
  local x = toPickRev[unitID]
  if x~= nil then
    return x
  else 
    return 0
  end
end

function GetToPickUnit(transportID) 
  local x = toPick[transportID]
  if (x~=nil) then
    if x[1] ~= nil then
      return x[1]
    else
      return 0
    end
  end
  return 0
end

function DeleteToPickTran(transportID)
  local tr = toPick[transportID]
  if (tr ~= nil) then
    local uid = tr[1]
    if (uid ~= nil) then
      toPickRev[uid]=nil
    end
  end
  toPick[transportID] = nil
end

function DeleteToPickUnit(unitID) 
  local tr = toPickRev[unitID]
  if (tr~=nil) then
    toPick[tr] = nil
  end
  toPickRev[unitID] = nil
end

function AddToPick(transportID, unitID, stopped, fact) 
  toPick[transportID] = {unitID, stopped, fact}
  toPickRev[unitID] = transportID
end



function widget:Initialize()
  local _, _, spec, teamID = GetPlayerInfo(Spring.GetMyPlayerID())
   if spec then
    widgetHandler:RemoveWidget()
    return false
  end
  myTeamID = teamID
  widgetHandler:RegisterGlobal('taiEmbark', taiEmbark)

  local units = GetTeamUnits(teamID)
  for i=1,#units do  -- init existing transports
    local unitID = units[i]
    if AddTransport(unitID, GetUnitDefID(unitID)) then
      AssignTransports(unitID, 0)
    end
  end
end

function widget:Shutdown()
  widgetHandler:DeregisterGlobal('taiEmbark')
end


function widget:UnitTaken(unitID, unitDefID, oldTeamID, teamID)
  if teamID == myTeamID then 
    if AddTransport(unitID, unitDefID) then
       AssignTransports(unitID, 0)
    end
  end
end

--[[function widget:UnitCreated(unitID, unitDefID, teamID)
  if teamID == myTeamID then 
    if AddTransport(unitID, unitDefID) then
       AssignTransports(unitID, 0)
    end
  end
end]]--

function widget:UnitDestroyed(unitID, unitDefID, teamID)
  if teamID == myTeamID then 
--     Echo("unit destroyed " ..unitID)
     idleTransports[unitID] = nil
     priorityUnits[unitID] = nil
	 waitingUnits[unitID] = nil
     local tuid = GetToPickUnit(unitID)
     if (tuid ~= 0) then -- transport which was about to pick something was destroyed
        local state = toPick[unitID][2]
        local fact = toPick[unitID][3]
        if (state == ST_PRIORITY) then
          waitingUnits[tuid] = {ST_PRIORITY, GetUnitDefID(tuid)}
        else 
          waitingUnits[tuid] = {ST_ROUTE, GetUnitDefID(tuid), fact}
          if (state == ST_STOPPED) then 
            GiveOrderToUnit(tuid, CMD.WAIT, {}, {})
          end
        end
        DeleteToPickTran(unitID)
        AssignTransports(0, tuid)
     else  -- unit which was about to be picked was destroyed
        pom = GetToPickTransport(unitID)
        if (pom~=0) then 
          DeleteToPickUnit(unitID)
          GiveOrderToUnit(pom, CMD.STOP, {}, {})
        end  -- delete form toPick list
     end
  end
end

function widget:UnitGiven(unitID, unitDefID, newTeamID, teamID)
  widget:UnitDestroyed(unitID, unitDefID, teamID)
end


function AddTransport(unitID, unitDefID) 
  if (IsTransport(unitDefID)) then -- and IsIdle(unitID)
    idleTransports[unitID] = unitDefID
    --Echo ("transport added " .. unitID)
    return true
  end
  return false
end 


function widget:UnitIdle(unitID, unitDefID, teamID) 
  if teamID ~= myTeamID then return end
  if WG.FerryUnits and WG.FerryUnits[unitID] then return end
  if (hackIdle[unitID] ~= nil) then
    hackIdle[unitID] = nil
    return
  end
  if (AddTransport(unitID, unitDefID)) then
    AssignTransports(unitID, 0)
  else
    if (IsTransportable(unitDefID, unitID)) then
      priorityUnits[unitID] = nil

      local marked = GetToPickTransport(unitID)
      if (waitingUnits[unitID] ~= nil) then  -- unit was waiting for transport and now its suddenly idle (stopped) - delete it
--        Echo("waiting unit idle "..unitID)
        waitingUnits[unitID] = nil
      end
  
      if (marked ~= 0) then  
--        Echo("to pick unit idle "..unitID)
        DeleteToPickTran(marked)
        GiveOrderToUnit(marked, CMD.STOP, {}, {})  -- and stop it (when it becomes idle it will be assigned)
      end
    end
  end
end




function widget:UnitFromFactory(unitID, unitDefID, unitTeam, factID, factDefID, userOrders) 
  if unitTeam == myTeamID and options.transportFromFactory.value then 
    local ud = UnitDefs[unitDefID]
    if (options.ignoreBuilders.value and ud.isBuilder and ud.canAssist) then 
		return 
	end
    if (IsTransportable(unitDefID, unitID) and not userOrders) then 
--      Echo ("new unit from factory "..unitID)

      local commands = GetCommandQueue(unitID, -1)
      for i=1, #commands do
        if (IsEmbark(commands[i])) then 
          priorityUnits[unitID] = unitDefID
          return
        end
      end

      waitingUnits[unitID] = {ST_ROUTE, unitDefID, factID}
      AssignTransports(0, unitID) 
    end
  end 
end


function widget:CommandNotify(id, params, options) 
  local sel = nil
  local alt,ctrl,shift = ExtractModifiedOptions(options)
  if not (options.shift or shift) then
    sel = GetSelectedUnits()
    for i=1,#sel do
      local uid = sel[i]
      widget:UnitDestroyed(uid, GetUnitDefID(uid), myTeamID)
    end
  end

  if (id == CMD.WAIT and (options.alt or alt)) then
    if (sel == nil) then sel = GetSelectedUnits() end
    for i=1,#sel do
      local uid = sel[i]
      priorityUnits[uid] = GetUnitDefID(uid)
    end
  end

  return false
end


function widget:Update(deltaTime)
	timer = timer + deltaTime
	if (timer < 1) then return end
  StopCloseUnits()

  local todel = {}
  for i, d in pairs(priorityUnits) do
--    Echo ("checking prio " ..i)
    if (IsEmbarkCommand(i)) then --Check for CMD_WAIT
--      Echo ("prio called " ..i)
      waitingUnits[i] = {ST_PRIORITY, d}
      AssignTransports(0, i)
      TableInsert(todel, i)
    end
  end
  for i=1, #todel do
    priorityUnits[todel[i] ] = nil
  end

  timer = 0
end


function StopCloseUnits() -- stops dune units which are close to transport
  for transportID, val in pairs(toPick) do 
    local unitID = val[1]
    local state = val[2]
    if (state == ST_ROUTE) then 
      local dist = GetUnitSeparation(transportID, unitID, true)
      if (dist ~= nil and dist < CONST_TRANSPORT_STOPDISTANCE) then
        local canStop = true
        if (val[3] ~= nil) then
          local fd = GetUnitDefID(val[3])
          local ud = GetUnitDefID(unitID)
          if (fd ~= nil and ud ~= nil) then
            local fd = GetUnitDefDimensions(fd)
            local ud = GetUnitDefDimensions(ud)
            if (fd ~= nil and ud ~= nil) then
              if (GetUnitSeparation(unitID, val[3], true) < fd.radius + ud.radius) then
--                Echo ("Cant stop - too close to factory")
                canStop = false
              end
            end
          end
        end
        if canStop then 
          if not IsWaitCommand(unitID) then GiveOrderToUnit(unitID, CMD.WAIT, {},{}) end 
          toPick[transportID][2] = ST_STOPPED
        end
      end
    end 
  end
end


function widget:UnitLoaded(unitID, unitDefID, teamID, transportID) 
  if (teamID ~= myTeamID or toPick[transportID]==nil) then return end

  local queue = GetCommandQueue(unitID, -1);
  if (queue == nil) then return end

--  Echo("unit loaded " .. transportID .. " " ..unitID)
  local torev = {}
  local vl = nil

  local ender = false
 
  storedQueue[unitID] = {}
  DeleteToPickTran(transportID)
  hackIdle[transportID] = true
  local cnt = 0
  for k=1, #queue do
    local v = queue[k]
	local alt,ctrl,shift,internal,right = ExtractModifiedOptions(v.options)
    if not (v.options.internal or internal) then  --not other widget's command
      if ((v.id == CMD.MOVE or (v.id==CMD.WAIT) or v.id == CMD.SET_WANTED_MAX_SPEED) and not ender) then
        cnt = cnt +1
        if (v.id == CMD.MOVE) then 
          GiveOrderToUnit(transportID, CMD.MOVE, v.params, {"shift"})      
          TableInsert(torev, {v.params[1], v.params[2], v.params[3]+20})
          vl = v.params 
        end
		if (IsDisembark(v)) then 
			ender = true
		end
      else
        if (not ender) then 
          ender = true
        end
        if (v.ID ~= CMD.WAIT) then
          local opts = {}
          TableInsert(opts, "shift") -- appending
          if (v.options.alt or alt)   then TableInsert(opts, "alt")   end
          if (v.options.ctrl or ctrl)  then TableInsert(opts, "ctrl")  end
          if (v.options.right or right) then TableInsert(opts, "right") end
          TableInsert(storedQueue[unitID], {v.id, v.params, opts})
        end
      end
    end
  end

  GiveOrderToUnit(unitID, CMD.STOP, {}, {})
  
  if (vl ~= nil) then 
    GiveOrderToUnit(transportID, CMD.UNLOAD_UNITS, {vl[1], vl[2], vl[3], CONST_UNLOAD_RADIUS}, {"shift"}) --unload unit at its destination
    
    local i = #torev
    while (i > 0) do 
      GiveOrderToUnit(transportID, CMD.MOVE, torev[i], {"shift"}) -- move in zig zaq (if queued)
      i = i -1
    end

    local x,y,z = GetUnitPosition(transportID)
    GiveOrderToUnit(transportID, CMD.MOVE, {x,y,z}, {"shift"})
	GiveOrderToUnit(transportID, CMD.UNLOAD_UNITS, {x,y,z, CONST_UNLOAD_RADIUS}, {"shift"}) --unload 2nd time at loading point incase transport refuse to drop unit at the intended destination (ie: in water)
  end

end


function widget:UnitUnloaded(unitID, unitDefID, teamID, transportID) 
  if (teamID ~= myTeamID or storedQueue[unitID] == nil) then return end
  GiveOrderToUnit(unitID, CMD.STOP, {}, {})
  for i=1, #storedQueue[unitID] do
    local x = storedQueue[unitID][i]
    GiveOrderToUnit(unitID, x[1], x[2], x[3])
  end
  storedQueue[unitID] = nil
  local queue = GetCommandQueue(unitID, 1)
  if (queue and queue[1] and queue[1].id == CMD.WAIT) then GiveOrderToUnit(unitID, CMD.WAIT, {}, {}) end -- workaround: clears wait order if STOP fails to do so
end


function CanTransport(transportID, unitID) 
  local udef = GetUnitDefID(unitID)  
  local tdef = GetUnitDefID(transportID)

  if (not udef or not tdef) then return false end
  if (UnitDefs[udef].xsize > UnitDefs[tdef].transportSize * 2) then  -- unit size check
--    Echo ("size failed")
    return false
  end

  local trans = GetUnitIsTransporting(transportID) -- capacity check
  if (UnitDefs[tdef].transportCapacity <= #trans) then  
--    Echo ("count failed")
    return false
  end
  

  local mass = UnitDefs[udef].mass -- mass check
  for i=1, #trans do
    mass = mass + UnitDefs[GetUnitDefID(trans[i])].mass
  end
  if (mass > UnitDefs[tdef].transportMass) then
--    Echo ("mass failed")
    return false
  end
  return true
end


function AssignTransports(transportID, unitID) 
  local best = {}
--  Echo ("assigning " .. transportID .. " " ..unitID)
  if (transportID~=0) then
     local unitDefID = GetUnitDefID(transportID)
     local transpeed = UnitDefs[unitDefID].speed
     local transMass = UnitDefs[unitDefID].mass 
     local speedMod = 1
     for id, val in pairs(waitingUnits) do 
	   local waitDefID = val[2]
       if CanTransport(transportID, id) and IsTransportable(waitDefID, id)  then
         local unitspeed = UnitDefs[waitDefID].speed
         local unitmass = UnitDefs[waitDefID].mass
         speedMod =  math.min(1, 3 * unitmass/(transMass +unitmass )) --see unit_transport_speed.lua gadget

         local ud = GetPathLength(id)
         local td = GetUnitSeparation(id, transportID, true)

         local ttime = (td + ud) / (transpeed*speedMod) + CONST_TRANSPORT_PICKUPTIME
         local utime = (ud) / unitspeed
         local benefit = utime-ttime
         if (val[1]==ST_PRIORITY) then 
           benefit = benefit + CONST_PRIORITY_BENEFIT
         end
         --Echo ("   "..transportID .. " " .. id .. "  " .. benefit)

         if (benefit > CONST_BENEFIT_LIMIT) then TableInsert(best, {benefit, transportID, id}) end
       end 
     end
  elseif (unitID ~=0) then
    local unitDefID = GetUnitDefID(unitID)
    local unitspeed = UnitDefs[unitDefID].speed
    local unitmass = UnitDefs[unitDefID].mass
    local speedMod = 1
    local state = waitingUnits[unitID][1]
    local ud = GetPathLength(unitID)
    for id, def in pairs(idleTransports) do 
      if CanTransport(id, unitID) and IsTransportable(unitDefID, unitID) then
        local transpeed = UnitDefs[def].speed
        local transMass = UnitDefs[def].mass
        speedMod =  math.min(1, 3 * unitmass/(transMass +unitmass )) --see unit_transport_speed.lua gadget

        local td = GetUnitSeparation(unitID, id, true)

        local ttime = (td + ud) / (transpeed*speedMod) + CONST_TRANSPORT_PICKUPTIME
        local utime = (ud) / unitspeed
        local benefit = utime-ttime
        if (state==ST_PRIORITY) then 
          benefit = benefit + CONST_PRIORITY_BENEFIT
        end

         --Echo ("   "..id.. " " .. unitID .. "  " .. benefit)

        if (benefit > CONST_BENEFIT_LIMIT) then TableInsert(best, {benefit, id, unitID}) end
      end
    end
  end 

  table.sort(best, function(a,b) return a[1]>b[1] end)
  local i = 1
  local it = #best
  local used = {}
  while i <= it do
    local tid = best[i][2]
    local uid = best[i][3]
    i = i +1
    if (used[tid]==nil and used[uid]==nil) then --check if already given transport order in same loop
      used[tid] = 1
      used[uid] = 1
--      Echo ("ordering " .. tid .. " " .. uid )

      if (waitingUnits[uid][1] == ST_PRIORITY) then 
        AddToPick(tid, uid, ST_PRIORITY)
      else
        AddToPick(tid, uid, ST_ROUTE, waitingUnits[uid][3])
      end
      waitingUnits[uid] = nil
      idleTransports[tid] = nil
      GiveOrderToUnit(tid, CMD.LOAD_UNITS, {uid}, {})
    end
  end 
end



function Dist(x,y,z, x2, y2, z2) 
  local xd = x2-x
  local yd = y2-y
  local zd = z2-z
  return math.sqrt(xd*xd + yd*yd + zd*zd)
end


function GetPathLength(unitID) 
  local mini = math.huge
  local maxi = -math.huge
  local px,py,pz= GetUnitPosition(unitID)

  local h = GetGroundHeight(px,pz)
  if (h < mini) then mini = h end
  if (h > maxi) then maxi = h end

  local d = 0
  local queue = GetCommandQueue(unitID, -1);
  local udid = Spring.GetUnitDefID(unitID)
  local moveID = UnitDefs[udid].moveDef.id
  if (queue == nil) then return 0 end
  for k=1, #queue do
    local v = queue[k]
    if (v.id == CMD.MOVE or v.id==CMD.WAIT) then
      if (v.id == CMD.MOVE) then 
		local reachable = true --always assume target reachable
		local waypoints
		if moveID then --unit has compatible moveID?
			local result, lastwaypoint
			result, lastwaypoint, waypoints = IsTargetReachable(moveID,px,py,pz,v.params[1],v.params[2],v.params[3],128)
			if result == "outofreach" then --abit out of reach?
				reachable=false --target is unreachable!
			end
		end
		if reachable then 
			if waypoints then --we have waypoint to destination?
				local way1,way2,way3 = px,py,pz
				for i=1, #waypoints do --sum all distance in waypoints
					d = d + Dist(way1,way2,way3, waypoints[i][1],waypoints[i][2],waypoints[i][3])
					way1,way2,way3 = waypoints[i][1],waypoints[i][2],waypoints[i][3]
				end
			else --so we don't have waypoint?
				d = d + Dist(px,py, pz, v.params[1], v.params[2], v.params[3]) --we don't have waypoint then measure straight line
			end
		else --pathing says target unreachable?!
			d = d + Dist(px,py, pz, v.params[1], v.params[2], v.params[3]) + 9999 --target unreachable!
		end
        px = v.params[1]
        py = v.params[2]
        pz = v.params[3]
        local h = GetGroundHeight(px,pz)
        if (h < mini) then mini = h end
        if (h > maxi) then maxi = h end
      end
    else
      break
    end
  end

  d = d + (maxi - mini) * CONST_HEIGHT_MULTIPLIER 
  return d
end

--This function process result of Spring.PathRequest() to say whether target is reachable or not
function IsTargetReachable (moveID, ox,oy,oz,tx,ty,tz,radius)
	local result,lastcoordinate, waypoints
	local path = Spring.RequestPath( moveID,ox,oy,oz,tx,ty,tz, radius)
	if path then
		local waypoint = path:GetPathWayPoints() --get crude waypoint (low chance to hit a 10x10 box). NOTE; if waypoint don't hit the 'dot' is make reachable build queue look like really far away to the GetWorkFor() function.
		local finalCoord = waypoint[#waypoint]
		if finalCoord then --unknown why sometimes NIL
			local dx, dz = finalCoord[1]-tx, finalCoord[3]-tz
			local dist = math.sqrt(dx*dx + dz*dz)
			if dist <= radius+20 then --is within radius?
				result = "reach"
				lastcoordinate = finalCoord
				waypoints = waypoint
			else
				result = "outofreach"
				lastcoordinate = finalCoord
				waypoints = waypoint
			end
		end
	else
		result = "noreturn"
		lastcoordinate = nil
		waypoints = nil
	end
	return result, lastcoordinate, waypoints
end


--[[
function widget:KeyPress(key, modifier, isRepeat)
  if (key == KEYSYMS.Q and not modifier.ctrl) then
    if (not modifier.alt) then
      local opts = {"alt"}
      if (modifier.shift) then TableInsert(opts, "shift") end 

      for _, id in ipairs(GetSelectedUnits()) do -- embark
        local def = GetUnitDefID(id)
        if (IsTransportable(def) or UnitDefs[def].isFactory) then 
          GiveOrderToUnit(id, CMD.WAIT, {}, opts) 
          if (not UnitDefs[def].isFactory) then priorityUnits[id] = def end
        end
      end
    else 
      local opts = {"alt", "ctrl"}
      if (modifier.shift) then TableInsert(opts, "shift") end  
      for _, id in ipairs(GetSelectedUnits()) do --disembark
        local def = GetUnitDefID(id)
        if (IsTransportable(def)  or UnitDefs[def].isFactory) then GiveOrderToUnit(id, CMD.WAIT, {}, opts) end
      end

    end
  end
end ]]--



function taiEmbark(unitID, teamID, embark, shift) -- called by gadget
	if (teamID ~= myTeamID) then return end
	
	if (not shift) then
		widget:UnitDestroyed(unitID, GetUnitDefID(unitID), myTeamID) --remove existing command ASAP
	end
	
	local queue = GetCommandQueue(unitID, -1)
	if (queue == nil) and (not shift) then  --unit has no command at all?! and not queueing embark/disembark command?!
		Spring.Echo("Transport: Select destination")
		Spring.SetActiveCommand("transportto") --Force user to add move command. See unit_transport_ai_buttons.lua for more info.
		return false --wait until user select destination
	else
		local hasMoveCommand
		for k=1, #queue do
			local v = queue[k]
			if (v.id == CMD.MOVE) or (v.id == 31200) or (v.id == 31201) or (v.id == 31202) then
				hasMoveCommand = true
				break
			end
		end
		if (not hasMoveCommand) and (not shift) then --unit has no move command?! and not queueing embark/disembark command?!
			Spring.Echo("Transport: Select destination")
			Spring.SetActiveCommand("transportto") --Force user to add move command.
			return false --wait until user select destination
		end
	end
  
	if (embark) then
		local def = GetUnitDefID(unitID)
		local ud = UnitDefs[def]
		if (ud ~= nil and not ud.isFactory) and not waitingUnits[unitID] then
			priorityUnits[unitID] = def --add to priority list (will be read in Widget:Update())
		end
	end
end


