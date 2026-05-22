
import("ScarUtil.scar")

function Init_Framedump()
	Rule_AddOneShot(StartNIS, 0)
end

Scar_AddInit(Init_Framedump)

function StartNIS()

	-- look up opening or closing based on the command line parameter in this format: 1_N09_02
	local nis = Misc_GetCommandLineString("nis")
	local nisFilename = string.sub(nis, 3) -- N09_02
	
	local openingFilename = nil
	if openingFilename then
		openingFilename = string.sub(openingFilename, -string.len(nisFilename))
		if string.lower(nisFilename) == string.lower(openingFilename) then
			Util_StartNIS(NIS_OPENING, quitgame, nil, nil, nil, true)
			return
		end
	end
	
	local closingFilename = nil
	if closingFilename then
		closingFilename = string.sub(closingFilename, -string.len(nisFilename))
		if string.lower(nisFilename) == string.lower(closingFilename) then
			Util_StartNIS(NIS_CLOSING, quitgame, nil, nil, nil, true)
			return
		end
	end
	
	-- you lose
	quitgame()
	
end

function quitgame()
	Scar_DebugConsoleExecute("quit")
end
	