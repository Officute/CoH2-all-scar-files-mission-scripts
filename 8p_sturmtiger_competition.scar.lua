
RELATIVE_LIB_PATH = "lib/"
ABSOLUTE_MOD_PATH = "CoH2/Data/Scenarios/mp/8p_sturmtiger_competition/"
RELATIVE_MOD_PATH = ""

import(RELATIVE_LIB_PATH .. "Library.scar")
Library_Load(RELATIVE_LIB_PATH)

DEV_MODE = DEV_MODE or false -- From Library.scar

function Map_PreInit()

	local imporFiles = {
		"sturmtiger_competition_objectives.scar",
		"sturmtiger_competition_encounters.scar",
	}
	
	if DEV_MODE then
		for key, file in ipairs(imporFiles) do
			LocalImport(ABSOLUTE_MOD_PATH .. file)()
		end
		
		LocalImport(ABSOLUTE_MOD_PATH .. "sturmtiger_competition.scar")()
	else
		for key, file in ipairs(imporFiles) do
			import(RELATIVE_MOD_PATH .. file)
		end
		
		import(RELATIVE_MOD_PATH .. "sturmtiger_competition.scar")
	end
	
	Map_Init()
end

Scar_AddInit(Map_PreInit)
