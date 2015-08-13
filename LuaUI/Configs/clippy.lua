local THRESHOLD_EXPENSIVE = 800
INCOME_TO_SPLURGE = 25	-- ignore expensive warning if you have this much income
METAL_PER_NANO = 8		-- suggested nanos per metal ^ -1
MIN_PULL_FOR_NANOS = -10	-- don't make more nanos if our pull is already this low	--unused
NANO_DEF_ID = UnitDefNames.armnanotc.id
ENERGY_TO_METAL_RATIO = 4	-- suggested maximum for energy
ENERGY_LOW_THRESHOLD = 200
DEFENSE_QUOTA = 0.3	-- suggested maximum proportion of total assets that is defense

RANK_LIMIT = 3

DELAY_BETWEEN_FACS = 10*60*30	-- gameframes

--seconds
TIMER_EXPENSIVE_UNITS = 60 * 10
TIMER_ADV_FACTORY = 60 * 15
TIMER_SUPERWEAPON = 60 * 30

tips = {
	nano_excess = {str = {"Don't we have enough\nCaretakers already?"}, life = 7, cooldown = 20},
	expensive_unit = {str = {"Boss, I'm not sure\nwe can afford that at\nthis stage of the game.",
				"Sir, I don't think that\nunit is in our price\nrange right now."}, life = 9, cooldown = 20, verbosity = 2},
	superweapon = {str = {"A superweapon,\nnow? Seriously?"}, life = 7, cooldown = 60},
	adv_factory = {str = {"Are you sure that's\na good starting\nfac, chief?"}, life = 7, cooldown = 60},
	
	retreat_repair = {str = {"Getting shot up!\nRequesting permission\nto pull out, sir!",
				"Get me out of here!\nI need repairs!",}, life = 7, cooldown = 20},
				
	energy_excess  = {str = {"I think we've got\nenough energy for\nnow, boss.",
				"We're not playing\nEnergy Tycoon, man...",
				"Sir, we're swimming\nin energy as it is."}, life = 7, cooldown = 20},
	energy_deficit  = {str = {"Energy deficit, sir.\nMore E structures?",
				"Commander, we'll soon\nrun out of energy\nunless we build more E."}, life = 7, cooldown = 45},
	metal_excess  = {str = {"Sir, we have a metal glut.\nPut some more buildpower\ninto making units.",
				"Boss, we have too much metal.\nGet more of us making stuff."}, life = 7, cooldown = 30},
	metal_deficit = {str = {"Running low on metal, chief.\nWe should try reclaiming\nor getting more mexes."}, life = 7, cooldown = 60, verbosity = 3},
	
	facplop = {str = {"I've got a free factory here.\nMight want to place it ASAP."}, life = 7, cooldown = 30},
	factory_duplicate = {str = {"We already have one of\nthat fac. I don't think\nwe need a second, chief."}, life = 9, cooldown = 60},
	factory_multiple = {str = {"Sir, we don't need another\nfac so soon. Assist with cons\nif you need to build faster."}, life = 10, cooldown = 60, verbosity = 2},
	
	defense_excess = {str = {"Boss, this isn't a\nTower Defense game...",
				"Chief, don't you think\nwe have enough\ndefenses already?",
				"Sir, I don't think\nwe should be building\nany more defense."}, life = 8, cooldown = 20}
}

for name,data in pairs(tips) do
	data.lastUsed = -10000
end

local superweaponDefs = {
	"armbrtha",
	"corsilo",
	"mahlazer",
	"zenith",
	"raveparty",
}
local canRetreatDefs = {
	"armbrawl",
	"blackdawn",
	"corcrw",
	
	"correap",
	"corgol",
	--"trem",
	"corcan",
	"corsumo",
	
	"dante",
	--"armraven",
	"scorpion",
	"armbanth",
	"armorco",
	
	"corbats",
	"armcarry",
	"reef",
	"corroy",
	"serpent",
}

local energyDefs = {
	"armsolar",
	"armwin",
	"armfus",
	--"geo",
	"cafus",
}

local defenseDefs = {
	"corllt",
	"corrl",
	"armdeva",
	"corgrav",
	"corhlt",
	"armpb",
	
	"corrazor",
	"missiletower",
	"corflak",
	"armcir",
	"screamer",
	
	"cordoom",
	"armanni",
	
	"turrettorp",
	
	"armjamt",
	"corjamt"
}

factoryDefs = {
	"factoryship",
	"striderhub",
}
for name in pairs(UnitDefNames) do
	if string.find(name, "factory") then factoryDefs[#factoryDefs+1] = name end
end

--unitDefID-indexed tables
expensive_units = {}
superweapons = {}
commanders = {}
factories = {}
adv_factories = {}
energy = {}
defenses = {}
canRetreat = {}

for i=1,#UnitDefs do
	if UnitDefs[i].customParams.commtype then commanders[i]=true
	--elseif (not UnitDefs[i].canMove) and UnitDefs[i].canAttack then defenses[i]=true	-- bad idea: includes superweapons
	elseif UnitDefs[i].metalCost > THRESHOLD_EXPENSIVE then expensive_units[i] = true end
end

local function CreateArray(source, target)
	for i=1, #source do
		local def = UnitDefNames[source[i]]
		if def then target[def.id] = true end
	end
end

CreateArray(superweaponDefs, superweapons)
CreateArray(canRetreatDefs, canRetreat)
CreateArray(energyDefs, energy)
CreateArray(defenseDefs, defenses)
CreateArray(factoryDefs, factories)
