local base = piece 'base' 
local body = piece 'body' 
local jet = piece 'jet' 
local wingtipl = piece 'wingtipl' 
local wingtipr = piece 'wingtipr' 

local smokePiece = {body, jet}

include "constants.lua"
include "bombers.lua"

local function Lights()
	while select(5, Spring.GetUnitHealth(unitID)) < 1 do
		Sleep(400)
	end
	while true do
		EmitSfx(wingtipl, 1025)
		EmitSfx(wingtipr, 1026)
		Sleep(2000)
	end
end

function script.AimWeapon(num, heading, pitch)
	return true
end

function script.Create()
	StartThread(SmokeUnit, smokePiece)
	--StartThread(Lights)
end

function script.QueryWeapon(num)
	return base
end

function script.FireWeapon(num)
end

function script.Killed(recentDamage, maxHealth)
	local severity = recentDamage/maxHealth
	if severity <= .25 then
		Explode(body, sfxNone)
		Explode(jet, sfxNone)
		return 1
	elseif severity <= .50 then
		Explode(body, sfxNone)
		Explode(jet, sfxShatter)
		return 1
	elseif severity <= 99 then
		Explode(body, sfxShatter)
		Explode(jet, sfxFall + sfxSmoke + sfxFire + sfxExplode)
		return 2
	else
		Explode(body, sfxShatter)
		Explode(jet, sfxFall + sfxSmoke + sfxFire + sfxExplode)
		return 2
	end
end
