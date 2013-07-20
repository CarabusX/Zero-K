include "constants.lua"

--pieces
local base, middle, heading,
	mbase, mfbeam, mrbeam, mhull, mwing, mwingtip, mjet, mrack, mmissile, mmissleflare,
	rbase, rfbeam, rrbeam, rhull, rwing, rwingtip, rjet, rrack, rmissile, rmissleflare,
	lbase, lfbeam, lrbeam, lhull, lwing, lwingtip, ljet, lrack, lmissile, lmissleflare = piece(
	"base", "middle", "heading",
	"mbase", "mfbeam", "mrbeam", "mhull", "mwing", "mwingtip", "mjet", "mrack", "mmissile", "mmissleflare", 
	"rbase", "rfbeam", "rrbeam", "rhull", "rwing", "rwingtip", "rjet", "rrack", "rmissile", "rmissleflare", 
	"lbase", "lfbeam", "lrbeam", "lhull", "lwing", "lwingtip", "ljet", "lrack", "lmissile", "lmissleflare")

local spGetUnitVelocity = Spring.GetUnitVelocity
	
smokePiece = { base}

local root3 = math.sqrt(3)

local isActive = false

local shot = 0
local gun = {
	[0] = {query = mmissleflare},
	[1] = {query = rmissleflare},
	[2] = {query = lmissleflare},
}

local function restoreWings()
	Turn(mhull, y_axis, math.rad(0),math.rad(15))
	Turn(lhull, y_axis, math.rad(0),math.rad(15))
	Turn(rhull, y_axis, math.rad(0),math.rad(15))
	
	Turn(mhull, x_axis, math.rad(0),math.rad(12))
	Turn(lhull, x_axis, math.rad(0),math.rad(12))
	Turn(rhull, x_axis, math.rad(0),math.rad(12))
	
	Turn(middle, x_axis, math.rad(0), math.rad(30))
	Turn(middle, y_axis, math.rad(0), math.rad(30))
end

local function TiltBody()
	
	while true do
		if isActive then
			local vx,_,vz = spGetUnitVelocity(unitID)
			local speed = vx*vx + vz*vz
			
			if speed > 5 then
				local velHeading = Spring.GetHeadingFromVector(vx, vz)/32768*math.pi
				-- south is 0, increases anticlockwise
				
				local px,_,pz = Spring.GetUnitPiecePosition(unitID, heading)
				
				local curHeading = -Spring.GetHeadingFromVector(-px, -pz)/32768*math.pi
				
				local diffHeading = velHeading - curHeading
				if diffHeading > pi then
					diffHeading = diffHeading - tau
				elseif diffHeading < -pi then
					diffHeading = diffHeading + tau
				end
				local newHeading 
				
				if diffHeading < -pi/3 then
					Turn(lhull, x_axis, math.rad(speed*0.8),math.rad(24))
					Turn(rhull, y_axis, -math.rad(speed),math.rad(30))
					Turn(mhull, y_axis, math.rad(speed),math.rad(30))
					newHeading = velHeading + 2*pi/3
					
					Turn(middle, x_axis, -math.rad(1.2*speed*0.5), math.rad(30*0.5))
					Turn(middle, y_axis, -math.rad(1.2*speed*root3/2), math.rad(30*root3/2))
					
					Turn(lhull, y_axis, math.rad(0),math.rad(30))
					Turn(mhull, x_axis, math.rad(0),math.rad(24))
					Turn(rhull, x_axis, math.rad(0),math.rad(24))
				elseif diffHeading < pi/3 then
					Turn(mhull, x_axis, math.rad(speed*0.8),math.rad(24))
					Turn(lhull, y_axis, -math.rad(speed),math.rad(30))
					Turn(rhull, y_axis, math.rad(speed),math.rad(30))
					newHeading = velHeading
					
					Turn(middle, x_axis, math.rad(1.2*speed), math.rad(30))
					Turn(middle, y_axis, math.rad(0), math.rad(30))
					
					Turn(mhull, y_axis, math.rad(0),math.rad(30))
					Turn(lhull, x_axis, math.rad(0),math.rad(24))
					Turn(rhull, x_axis, math.rad(0),math.rad(24))
				else
					Turn(rhull, x_axis, math.rad(speed*0.8),math.rad(24))
					Turn(mhull, y_axis, -math.rad(speed),math.rad(30))
					Turn(lhull, y_axis, math.rad(speed),math.rad(30))
					newHeading = velHeading - 2*pi/3
					
					Turn(middle, x_axis, -math.rad(1.2*speed*0.5), math.rad(30*0.5))
					Turn(middle, y_axis, math.rad(1.2*speed*root3/2), math.rad(30*root3/2))
					
					Turn(rhull, y_axis, math.rad(0),math.rad(30))
					Turn(mhull, x_axis, math.rad(0),math.rad(24))
					Turn(lhull, x_axis, math.rad(0),math.rad(24))
				end
				
				Turn(base, z_axis, newHeading, math.rad(100))
				Sleep(200)
			else
				restoreWings()
				Sleep(10)
			end
			Sleep(10)
		else
			Sleep(10)
		end
	end
end


local function activate()
	isActive = true
	Move(mhull, y_axis, -1, 2)
	Move(rhull, y_axis, -1, 2)
	Move(lhull, y_axis, -1, 2)
	
	Move(mhull, z_axis, -2, 1)
	Move(rhull, z_axis, -2, 1)
	Move(lhull, z_axis, -2, 1)
end

local function deactivate()
	isActive = false
	Move(mhull, y_axis, -5, 2)
	Move(rhull, y_axis, -5, 2)
	Move(lhull, y_axis, -5, 2)
	
	Move(mhull, z_axis, 0, 1)
	Move(rhull, z_axis, 0, 1)
	Move(lhull, z_axis, 0, 1)
end

function script.Activate()
	activate()
end

function script.StopMoving()
	deactivate()
end
 
 function script.Create()
	
	Move(mhull, y_axis, -5)
	Move(rhull, y_axis, -5)
	Move(lhull, y_axis, -5)
	
	Turn(rbase, z_axis, math.rad(120))
	Turn(lbase, z_axis, math.rad(-120))
	
	Turn(base, x_axis, math.rad(-90))
	Move(base, y_axis, 22)
	
	Move(mbase, z_axis, 2.9)
	Move(rbase, z_axis, 2.9)
	Move(lbase, z_axis, 2.9)
	
	Move(mhull, y_axis, -5)
	Move(rhull, y_axis, -5)
	Move(lhull, y_axis, -5)
	
	Move(mrack, y_axis, 5)
	Move(rrack, y_axis, 5)
	Move(lrack, y_axis, 5)
	
	Move(mrack, z_axis, -4)
	Move(rrack, z_axis, -4)
	Move(lrack, z_axis, -4)
	
	Turn(lmissile, x_axis, math.rad(90))
	
	StartThread(SmokeUnit)
	StartThread(TiltBody)
end

function script.QueryWeapon(num) 
	return mmissleflare -- gun[shot].query
end

function script.AimFromWeapon(num) 
	return base 
end

function script.AimWeapon( num, heading, pitch )
	return true
end

function script.FireWeapon(num)
-- FX goes here
end

function script.Killed(recentDamage, maxHealth)
	local severity = (recentDamage/maxHealth) * 100
	if severity < 100 then
		return 1
	else
		return 2
	end
end