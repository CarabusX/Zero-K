-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

function widget:GetInfo()
  return {
    name      = "State Icons",
    desc      = "Shows movestate, firestate and priority icons",
    author    = "CarRepairer and GoogleFrog",
	version   = "0.02",
    date      = "2012-01-28",
    license   = "GNU GPL, v2 or later",
    layer     = 5,
    enabled   = true,
  }
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local spGetUnitArmored       = Spring.GetUnitArmored
local spGetUnitRulesParam    = Spring.GetUnitRulesParam
local spGetUnitHealth        = Spring.GetUnitHealth
local spGetUnitStates        = Spring.GetUnitStates
local spGetUnitDefID         = Spring.GetUnitDefID
local spGetAllUnits          = Spring.GetAllUnits
local spIsUnitAllied         = Spring.IsUnitAllied
local spGetSpectatingState   = Spring.GetSpectatingState

local min   = math.min
local floor = math.floor

----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

options_path = 'Settings/Interface/Hovering Icons'
options = {
	
	showstateonshift = {
		name = "Show move/fire states on shift",
		desc = "When holding shift, icons appear over units indicating move state and fire state.",
		type = 'bool',
		value = false,
	},
	showarmorstateonshift = {
		name = "Show armor state on shift",
		desc = "When holding shift, an icon appears over armored units.",
		type = 'bool',
		value = true,
	},
	showpriorityonshift = {
		name = "Show priority on shift",
		desc = "When holding shift, an icon appears over unit with low or high priority.",
		type = 'bool',
		value = true,
	},
	showmiscpriorityonshift = {
		name = "Show misc priorty on shift",
		desc = "When holding shift, an icon appears over unit with low or high misc priority (morph or stockpile).",
		type = 'bool',
		value = true,
	},
}


include("keysym.h.lua")

local myAllyTeamID = 666


local imageDir = 'LuaUI/Images/commands/'
local fireStateIcons = {
  [0] = imageDir .. 'states/fire_hold.png',
  [1] = imageDir .. 'states/fire_return.png',
  [2] = imageDir .. 'states/fire_atwill.png',
}
local moveStateIcons = {
  [0] = imageDir .. 'states/move_hold.png',
  [1] = imageDir .. 'states/move_engage.png',
  [2] = imageDir .. 'states/move_roam.png',
}
local priorityIcons = {
  [0] = imageDir .. 'states/wrench_low.png',
  [1] = imageDir .. 'states/wrench_med.png',
  [2] = imageDir .. 'states/wrench_high.png',
}
local miscPriorityIcons = {
  [0] = imageDir .. 'states/wrench_low_other.png',
  [1] = imageDir .. 'states/wrench_med_other.png',
  [2] = imageDir .. 'states/wrench_high_other.png',
}

local armoredTexture = 'Luaui/Images/commands/guard.png'

local hide = true

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------

local prevFirestate = {}
local prevMovestate = {}
local prevPriority = {}
local prevMiscPriority = {}
local lastArmored = {}
local lastArmored = {}

function SetUnitStateIcons(unitID)
	if not (spIsUnitAllied(unitID)or(spGetSpectatingState())) then
		return
	end
	
	local states = spGetUnitStates(unitID)
	
	if not states then 
		return 
	end
	
	local ud = spGetUnitDefID(unitID)
	if ud then
		ud = UnitDefs[ud]
	end
	
	if options.showstateonshift.value then
		if ud then
			if ud.canAttack or ud.isFactory then
				if not prevFirestate[unitID] or prevFirestate[unitID] ~= states.firestate then
					prevFirestate[unitID] = states.firestate
					local fireStateIcon = fireStateIcons[states.firestate]
					WG.icons.SetUnitIcon( unitID, {name='firestate', texture=fireStateIcon} )
				end
			end
			if (ud.canMove or ud.canPatrol) and ((not ud.isBuilding) or ud.isFactory) then
				if not prevMovestate[unitID] or prevMovestate[unitID] ~= states.movestate then
					prevMovestate[unitID] = states.movestate
					local moveStateIcon = moveStateIcons[states.movestate]
					WG.icons.SetUnitIcon( unitID, {name='movestate', texture=moveStateIcon} )
				end
			end
		end
	end
	
	if options.showarmorstateonshift.value then
		local armored, amount = spGetUnitArmored(unitID)
		armored = armored and amount and amount ~= 1
		if not lastArmored[unitID] and armored then
			lastArmored[unitID] = true
			WG.icons.SetUnitIcon( unitID, {name='armored', texture=armoredTexture} )
		elseif lastArmored[unitID] and not armored then
			lastArmored[unitID] = nil
			WG.icons.SetUnitIcon( unitID, {name='armored', texture=nil} )
		end
	end
	
	if options.showpriorityonshift.value then
		local state = spGetUnitRulesParam(unitID, "buildpriority")
		if (not ud) or not (ud.canAssist and ud.buildSpeed ~= 0) then
			local _,_,_,_,buildProgress = spGetUnitHealth(unitID)
			if buildProgress == 1 then
				state = 1
			end
		end
		
		if not prevPriority[unitID] or prevPriority[unitID] ~= state then
			if state == 1 then
				prevPriority[unitID] = state
				WG.icons.SetUnitIcon( unitID, {name='priority', texture=nil} )
			else
				prevPriority[unitID] = state
				local priorityIcons = priorityIcons[state]
				WG.icons.SetUnitIcon( unitID, {name='priority', texture=priorityIcons} )
			end
		end
	end
	
	if options.showmiscpriorityonshift.value then
		local state = spGetUnitRulesParam(unitID, "miscpriority")
		
		if not prevMiscPriority[unitID] or prevMiscPriority[unitID] ~= state then
			if state == 1 then
				prevMiscPriority[unitID] = state
				WG.icons.SetUnitIcon( unitID, {name='miscpriority', texture=nil} )
			else
				prevMiscPriority[unitID] = state
				local miscPriorityIcons = miscPriorityIcons[state]
				WG.icons.SetUnitIcon( unitID, {name='miscpriority', texture=miscPriorityIcons} )
			end
		end
	end
	
end

local function UpdateAllUnits()
	if hide then 
		return 
	end
	local unitID
	local units = spGetAllUnits()
	for i = 1, #units do
		unitID = units[i]
		SetUnitStateIcons(unitID)
	end
end

-------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------


function widget:UnitCreated(unitID, unitDefID, unitTeam)
	SetUnitStateIcons(unitID)
end


function widget:UnitDestroyed(unitID, unitDefID, unitTeam)
	-- There should be a better way to do this, lazy fix.
	WG.icons.SetUnitIcon( unitID, {name='firestate', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='movestate', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='armored', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='priority', texture=nil} )
	WG.icons.SetUnitIcon( unitID, {name='miscpriority', texture=nil} )
end

function widget:KeyPress(key, modifier, isRepeat)
	if isRepeat or not (options.showstateonshift.value or options.showarmorstateonshift.value) then
		return
	end

	if key == KEYSYMS.LSHIFT
		or key == KEYSYMS.RSHIFT
		then
		
		hide = false
		
		if options.showstateonshift.value then
			WG.icons.SetDisplay('firestate', true)
			WG.icons.SetDisplay('movestate', true)
		end
		if options.showarmorstateonshift.value then
			WG.icons.SetDisplay('armored', true)
		end
		if options.showpriorityonshift.value then
			WG.icons.SetDisplay('priority', true)
		end
		if options.showmiscpriorityonshift.value then
			WG.icons.SetDisplay('miscpriority', true)
		end
		
		UpdateAllUnits()
	end
end
function widget:KeyRelease(key, modifier )
	
	if key == KEYSYMS.LSHIFT
		or key == KEYSYMS.RSHIFT
		then
		
		hide = true
		
		WG.icons.SetDisplay('firestate', false)
		WG.icons.SetDisplay('movestate', false)
		WG.icons.SetDisplay('armored', false)
		WG.icons.SetDisplay('priority', false)
		WG.icons.SetDisplay('miscpriority', false)
	end
end


--needed if icon widget gets disabled/enabled after this one. find a better way?
function widget:GameFrame(f)

	if f%(30) == 0 then --1 second
		UpdateAllUnits()
	end
end


--this needs work
function widget:UnitCommand(unitID, unitDefID, unitTeam, cmdID, cmdOptions, cmdParams)
	if hide then return end
	if (cmdID == CMD.MOVE_STATE) or (cmdID == CMD.FIRE_STATE)  then
		SetUnitStateIcons(unitID)
	end
end

function widget:Initialize()
	
	WG.icons.SetOrder( 'firestate', 5 )
	WG.icons.SetOrder( 'movestate', 6 )
	WG.icons.SetDisplay('firestate', false)
	WG.icons.SetDisplay('movestate', false)
	
	UpdateAllUnits()
	
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
