----------------------------------------------------------------------------
-- NIS helper functions
--

function __DoNothing()

end

NIS_OPENING	= 0
NIS_MID		= 1
NIS_CLOSING	= 2
NIS_OPENING_BLACK = 3
NIS_OPENING_FULLSCREEN = 4
NIS_OPENING_BLEND = 5

--? @shortdesc Play an NIS. See confluence link below for more info.
--? @result Void
--? @args String/Integer/LuaFunction NIS[, LuaFunction onComplete, egroup/sgroup/Player/Table hide, LuaFunction preNIS, LuaFunction postNIS, Boolean framedump, Boolean preserveFOW]
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/Scripting+NIS+Transitions
function Util_StartNIS( nisName, OnComplete, hide, preNIS, postNIS, framedump, preserveFOW )
	
	Game_StartMuted(true)
	UI_HideTacticalMap()
	-- Sound_SetVolumeInv("NIS", 0, 0.0)

	if Rule_Exists(__CheckNISFinished) == false then 
		-- cache current save allow flag, then disallow saving for the NIS
		g_NIS_Enable_Save = UI_GetAllowLoadAndSave()
		UI_SetAllowLoadAndSave(false)

		Rule_Add(__CheckNISFinished)
	else
		print("Warning: Starting NIS when one is already in progress")	
	end
	
	-- backwards compatibility
	if type(nisName) == "function" then
		Event_Start(nisName, 0)
		g_CurrentNISFunc = nisName
		return
	end
	
	g_CurrentNISFunc = __Event_PlayNIS
	
	local nisType = NIS_OPENING
	
	if type(OnComplete) ~= "function" then
		OnComplete = __DoNothing
	end
	if type(preNIS) ~= "function" then
		preNIS = __DoNothing
	end
	if type(postNIS) ~= "function" then
		postNIS = __DoNothing
	end
	
	g_NIS_Name = nisName
	g_NIS_Type = nisType
	g_NIS_Hide = hide
	g_NIS_Pre = preNIS
	g_NIS_Post = postNIS
	g_NIS_bFramedump = framedump
	g_NIS_preserveFOW = preserveFOW
	
	Event_StartEx(__Event_PlayNIS, 0, OnComplete)
	
	-- must start letterbox here to hide the taskbar in time
	if nisType == NIS_OPENING 
	or nisType == NIS_OPENING_BLACK then
		Game_Letterbox(true, 0)
	end
	
	-- must hide the UI for fullscreen before starting the NIS
	if nisType == NIS_OPENING_FULLSCREEN then
		Game_SetMode(UI_Fullscreen)
		Game_Letterbox(true, 0)
	end
	
	if framedump == true then
		Game_FadeToBlack(FADE_IN, 0)
	end
	
end

function __Event_PlayNIS()
	
	if g_NIS_Type == NIS_OPENING
	or g_NIS_Type == NIS_OPENING_BLACK
	or g_NIS_Type == NIS_OPENING_FULLSCREEN
	or g_NIS_Type == NIS_OPENING_BLEND then
		Game_FadeToBlack(FADE_IN, 5.5)
	elseif g_NIS_Type == NIS_CLOSING then
		CTRL.Game_FadeToBlack(FADE_OUT, 1)
		CTRL.Game_Letterbox(true, 1)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_IN, 5.5)
	else
		CTRL.Game_Letterbox(true, 1)
		CTRL.WAIT()
	end
		
	-- custom behavior before NIS
	g_NIS_Pre()
	
	if scartype(g_NIS_Hide) ~= ST_TABLE then
		g_NIS_Hide = {g_NIS_Hide}
	end
	
	local eg_hide = EGroup_Create("_eg_hide")
	local sg_hide = SGroup_Create("_sg_hide")
	local players = {}
	
	-- accumulate egroups, sgroups and players that we want to hide during the NIS
	for i = 1, table.getn(g_NIS_Hide) do
		
		local var = g_NIS_Hide[i]
		local type = scartype(var)
		
		if type == ST_ENTITY then
			EGroup_Add(eg_hide, var)
		elseif type == ST_EGROUP then
			EGroup_AddEGroup(eg_hide, var)
		elseif type == ST_SQUAD then
			SGroup_Add(sg_hide, var)
		elseif type == ST_SGROUP then
			SGroup_AddGroup(sg_hide, var)
		elseif type == ST_PLAYER then
			table.insert(players, var)
		else
			fatal("Util_StartNIS: cannot hide " .. scartype_tostring(var))
		end
		
	end
	
	-- hide stuff
	EGroup_Hide(eg_hide, true)
	SGroup_Hide(sg_hide, true)
	Util_HidePlayerForNIS(players, true)
	
	if g_NIS_preserveFOW ~= true then
		g_NIS_preserveFOW = false
	end
	
	if g_NIS_preserveFOW == false then
		FOW_Enable(false)
		FOW_EnableTint(false)
	end
	
	if g_NIS_bFramedump == true then 
		Scar_DebugConsoleExecute("DebugRenderShow(false)")
--		Scar_DebugConsoleExecute("app_fixedframerate(30)")	-- moving this to the NIS render code to allow switch from 30 to 60 fps
		Scar_DebugConsoleExecute("capturemoviesavedeferredbuffers(true)")
		Scar_DebugConsoleExecute("capturemoviestart(0)")
		Scar_DebugConsoleExecute("nis_synchelp")
	--  don't add a delay here as it means there will one two extra frames dumped before the nis starts playing
	end
	
	-- play the actual NIS
	
	CTRL.Scar_PlayNISEx(g_NIS_Name, g_NIS_Type ~= NIS_OPENING_BLACK)
	CTRL.WAIT()

	
	if g_NIS_bFramedump == true then
		Scar_DebugConsoleExecute("capturemoviestop")
		Scar_DebugConsoleExecute("app_fixedframerate(0)")
	end
	
	-- custom behavior after NIS
	g_NIS_Post()
	
	-- back to normal gameplay
	if g_NIS_preserveFOW == false then
		FOW_Enable(true)
		FOW_EnableTint(true)
	end
	
	-- unhide stuff
	EGroup_Hide(eg_hide, false)
	SGroup_Hide(sg_hide, false)
	Util_HidePlayerForNIS(players, false)
	
	if g_NIS_Type == NIS_OPENING then
		Game_FadeToBlack(FADE_IN, 2)
		Game_Letterbox(false, 1)
	elseif g_NIS_Type == NIS_MID 
	or g_NIS_Type == NIS_OPENING_FULLSCREEN 
	or g_NIS_Type == NIS_OPENING_BLEND then
		Game_Letterbox(false, 1)
	elseif g_NIS_Type == NIS_CLOSING then
		Game_ScreenFade(0, 0, 0, 1, 0)
	end
	
	g_NISFinished = true
	
	EGroup_Destroy(eg_hide)
	SGroup_Destroy(sg_hide)
	
end

function __CheckNISFinished()

	if Event_IsRunning(g_CurrentNISFunc) == false then
		
		-- stay muted if a sitrep follows the NIS
		if g_NIS_Type ~= NIS_OPENING_BLACK then
			Util_MuteAmbientSound(false, 2)
		end
		
		if g_NIS_Type == NIS_OPENING_FULLSCREEN then
			Rule_AddOneShot(__Event_ShowTaskbar, 10)
		end
		
		-- restore save allow flag
		UI_SetAllowLoadAndSave(g_NIS_Enable_Save)
		g_NIS_Enable_Save = nil

		g_CurrentNISFunc = nil
		Rule_RemoveMe()
	end

end

function __Event_ShowTaskbar()
	Game_SetMode(UI_Normal)
end
