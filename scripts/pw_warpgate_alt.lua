include "constants.lua"

local base = piece "base"
local gen1 = piece "gen1"
local gen2 = piece "gen2"

local smokePiece = {gen1, gen2}

function script.Activate ()
	Spin(gen1, y_axis, 1, 0.01)
	Spin(gen2, y_axis, -1, 0.01)
end

function script.Deactivate ()
	StopSpin(gen1, y_axis, 0.1)
	StopSpin(gen2, y_axis, 0.1)
end
