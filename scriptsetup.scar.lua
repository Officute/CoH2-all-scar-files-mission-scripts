print("\tLoading ScriptSetup...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- Initial Mission Script Setup functionality
-- (c) 2013 Relic Entertainment Inc.
--[[ 
	Order of operations:
		Mission_SetupPlayers() 		-- Called by OnGameSetup() on frame1
		Mission_SetupVariables()
		Mission_SetDifficulty()
		Mission_SetupRestrictions()
		Mission_Preset()
		Objectives are registered
		Intro NIS
		Intro NISlet
		Sitrep
		Mission_Start()
]]--
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ IMPORTS ]]
-------------------------------------------------------------------------
import("ScarUtil.scar") 								-- Scar functionality
import("Systems/AiManager/ai.scar")						-- Encounter system
import("Global_Values/CampaignGlobalConstants.scar")	-- Global values used throughout the game
import("TheatreOfWar.scar")								-- Theater of War Functions
import("Prototype/SpecialAEFunctions.scar")				-- Special functions called from the AE
import("Systems/BlizzardMulitplayer.scar")


-------------------------------------------------------------------------
-- [[ CONSTANTS ]]
-------------------------------------------------------------------------
--None so far!
-- Mission Types
MT_CHALLENGE = 0
MT_BATTLE = 1
MT_SCENARIO = 2
MT_XP1_CHALLENGE = 3
MT_XP1_BATTLE = 4
MT_XP1_MINICHALLENGE = 5

-------------------------------------------------------------------------
-- [[ VARIABLES ]]
-------------------------------------------------------------------------
--None so far!

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------
--Automatically called when game loads
function OnGameSetup()
	print("Running OnGameSetup...")
	
	if(scartype(Mission_SetupPlayers) == ST_FUNCTION) then 
		Mission_SetupPlayers()
	else
		print("#### WARNING! ScriptSetup could not find 'Mission_SetupPlayers()'. Check your mission script file.\n")
	end	
end

--Called after a session is restored from a save file
function OnGameRestore()
	print("Restoring game from a saved session...")
	-- Restoring all global mission parameters after a save/load
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function PreInit()
	--The mission init is delayed a single frame to ensure that all necessary ScarInit functions have been called.
	Rule_Add(OnInit)
end
Scar_AddInit(PreInit)

--Main initialization routine. Called 1 frame after all files have been loaded.
function OnInit()
	Rule_RemoveMe()
	print("Initializing mission...")
	__IsDebug = Misc_IsCommandLineOptionSet("debug")
	__SecondaryObjective = nil
	
	if(scartype(Override_Player_Setup) == ST_FUNCTION) then Override_Player_Setup() end
	
	if(scartype(g_missionData) == ST_NIL) then
		print("#### WARNING! ScriptSetup: g_missionData is missing. Check your mission script file.\n")
	end
	
	g_missionData = {}
	if(scartype(Mission_SetupVariables) == ST_FUNCTION) then Mission_SetupVariables() end
	
	
	--Encounter system
	if(g_missionData.useEncounterSystem == false) then
		Rule_Remove(AI_Loop)
	end

	--XP1 Prototype setup 
	if Table_Contains({MT_XP1_CHALLENGE, MT_XP1_BATTLE, MT_XP1_MINICHALLENGE}, g_missionData.missionType) then
		XP1_PrototypeSetup() 
	end
	
	--Precaching
	_InitAudio()
	_InitNIS()
	
	--Call mission startup functions. These should be defined in the mission script.
	if(scartype(Mission_SetDifficulty) == ST_FUNCTION) then Mission_SetDifficulty() end				-- Difficulty table/values
	if(scartype(Mission_SetupRestrictions) == ST_FUNCTION) then Mission_SetupRestrictions() end		-- Restrictions
	
	if g_missionData.startingUnits and scartype(g_missionData.startingUnits) == ST_TABLE and #g_missionData.startingUnits > 0 then
		_SpawnStartingUnits()
	end
	
	if(scartype(Mission_Preset) == ST_FUNCTION) then Mission_Preset() end							-- Initial unit setup
	
	_InitializeObjectives()			-- Register objectives
	
	_LoadAtmosphere()				-- Load Atmosphere
	
	if(__IsDebug) then
		_ShowDebugMenu()
	else
		Game_FadeToBlack(FADE_OUT, 0)
		Rule_Add(_PlayIntroNIS)
	end
end


-- Precache audio
function _InitAudio()
	print("\tPrecaching audio...")
	--Set the mission speech path and precache it.
	if(not g_missionData.missionSpeechPath) then
		print("#### WARNING! ScriptSetup: g_missionData.missionSpeechPath is not set.\n")
	else
		g_MissionSpeechPath = g_missionData.missionSpeechPath
		Sound_PreCacheSinglePlayerSpeech(g_MissionSpeechPath)
	end
	
	if (g_missionData.precacheSounds ~= nil) then
		--Precache any other files requested.
		for k,sound in pairs(g_missionData.precacheSounds) do
			Sound_PreCacheSound(sound)
		end
	end
end

-- Precache NIS's
function _InitNIS()
	print("\tPrecaching NIS files...")
	
	if (g_missionData.nisFiles ~= nil) then
		--Load NIS files. These need to be loaded at least 1 frame before Scar_PlayNIS() is called on them.
		for k,nis in pairs(g_missionData.nisFiles) do
			nis_load(nis)
		end
	end
	
	--Set the in/out transition time
	if(g_missionData.nisInTransitionTime ~= nil) then nis_setintransitiontime(g_missionData.nisInTransitionTime) end
	if(g_missionData.nisOutTransitionTime ~= nil) then nis_setouttransitiontime(g_missionData.nisOutTransitionTime) end
end

--Spawn the player's starting units
function _SpawnStartingUnits()
	local encData = {
		name = "PlayerStartingUnits",
		player = player1,
		units = g_missionData.startingUnits,
	}
	local enc_playerStartingUnits = Encounter:Create(encData)
	
	AI_RemoveAllEncounters()
end

-- Initialize objectives
function _InitializeObjectives()
	print("\tInitializing objectives...")
	if(g_missionData.objectives == nil or #g_missionData.objectives == 0) then
		print("#### WARNING! ScriptSetup: No Objectives found! Make sure they are added to g_missionData.objectives.")
	end
	
	if(g_missionData.objectives ~= nil) then
		for k,obj in pairs(g_missionData.objectives) do
			Objective_Register(obj)
			if(obj.subObjectives) then
				for i, subobj in pairs(obj.subObjectives) do
					Objective_Register(subobj)
				end
			end
		end
	end
end

-------------------------------------------------------------------------
-- MISSION START
-------------------------------------------------------------------------
--Displayer a debug menu on screen
function _ShowDebugMenu()
	print("DEBUG MODE IS ON - Showing debug menu...")
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select how the mission starts"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Play intro"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Don't play intro NIS"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("No mission logic"), "", true)
	UI_MessageBoxShow(DC_Default, _DebugMenuSelect)
end

--Handles debug menu option selection
function _DebugMenuSelect(button)
	if button == DB_Button1 then
		print("Play intro")
		Rule_AddOneShot(_PlayIntroNIS, 1)
	elseif button == DB_Button2 then
		print("Skip intro")
		Rule_AddOneShot(_StartMission, 1)
	elseif button == DB_Button3 then
		print("No mission!")
	end
end


-- Starts the mission intro sequence (introNIS -> NISlet -> Sitrep)
function _PlayIntroNIS()
	print("Playing intro NIS...")
	Rule_RemoveMe()
	
	local duration = g_missionData.introNISDarkDuration
	
	if duration == nil then
		duration = 1
	end	
	
	
	if(g_missionData.introNIS ~= nil and g_missionData.introNIS ~= "") then
		SitRep_PlayMovie(g_missionData.introNIS)
		Rule_AddOneShot(_PlayIntroNISlet, duration)
	else
		print("\tNo intro NIS.")
		_PlayIntroNISlet()
	end
end

function _PlayIntroNISlet()
	print("Playing intro NISlet...")
	if(g_missionData.introNISlet ~= nil) then
		Game_FadeToBlack(FADE_IN, 0.5)
		--Don't fade back in if there's a sitrep waiting to be played
		Util_StartNislet(g_missionData.introNISlet, g_missionData.introNISletSkipped, (g_missionData.introSitRep ~= nil and g_missionData.introSitRep ~= ""))
		Rule_AddDelayedInterval(_PlaySitrep, 1, 0.5)
	else
		print("\tNo intro NISlet.")
		_PlaySitrep()
	end
end

function _PlaySitrep()
	if(not Event_IsAnyRunning()) then
		print("Playing Sitrep...")
		Rule_RemoveMe()
		
		local fadeTime = g_missionData.fadeTimeIntoMission
	
		if fadeTime == nil then
			fadeTime = 1.0
		end	
		
		
		if(g_missionData.introSitRep ~= nil and g_missionData.introSitRep ~= "") then
			Util_PlayMovie(g_missionData.introSitRep, 1, 2) --, _ResetCamera, nil, true)
			Rule_AddOneShot(_StartMission, 1.0)
		else
			print("\tNo sitrep.")
			Game_FadeToBlack(FADE_IN, fadeTime)
			_StartMission()
		end
	end
end

function _StartMission()
	print("Starting mission...")
	Rule_AddDelayedInterval(_CheckObjectivesCompletion, 3, 1, 10)
	
	if(scartype(Mission_Start) == ST_FUNCTION) then
		Rule_AddOneShot(Mission_Start, 1.0)
	else
		print("#### WARNING! ScriptSetup could not find 'Mission_Start()'. Check your mission script file.\n")
	end
end

function _LoadAtmosphere()
	print("Loading Atmosphere...")
	if(g_missionData.atmosphere ~= nil) then
		local atmosphere = ("data:art/scenarios/presets/atmosphere/"..g_missionData.atmosphere)
		Game_LoadAtmosphere(atmosphere, 0)
	end
end



-------------------------------------------------------------------------
-- MISSION END
-------------------------------------------------------------------------
--? @shortdesc Plays the defined end cinematic and ends an SP scenario with a Victory. Waits for no intel events to be playing.
--? @result Void
function Mission_Complete()
	
	if(not Event_IsAnyRunning()) then
		Rule_RemoveIfExist(Mission_Complete)
		
		if(g_missionData.endNISlet ~= nil) then
			print("\tPlaying end NISlet...")
			Util_StartNislet(g_missionData.endNISlet, nil, false)
		else
			print("\tNo end NISlet.")
		end

		if Rule_Exists(_PlayEndNIS) == false then
			Rule_AddInterval(_PlayEndNIS, 0.5)
		end
	end
end

function _PlayEndNIS()
	if(not Event_IsAnyRunning()) then
		print("Playing end NIS...")
		Rule_RemoveMe()
		
		if(g_missionData.endNIS) then
			Game_FadeToBlack(FADE_OUT, 0.5)
			SitRep_PlayMovie(g_missionData.endNIS)
			Rule_AddInterval(Mission_Win, 1.0)
		else
			print("\tNo end NIS.")
			Mission_Win()
		end
	end
end

--? @shortdesc Ends an SP scenario with a Victory without playing any end cinematics.
--? @result Void
function Mission_Win()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		if(g_missionData.missionType == MT_XP1_CHALLENGE or g_missionData.missionType == MT_XP1_BATTLE or g_missionData.missionType == MT_XP1_MINICHALLENGE) then
			XP1_ShowResults(true)
		end
		Game_EndSP(true)
	end
end

--? @shortdesc Ends an SP scenario with a Failure.
--? @result Void
function Mission_Fail()
	if(not Event_IsAnyRunning()) then
		Rule_RemoveMe()
		if(g_missionData.missionType == MT_XP1_CHALLENGE or g_missionData.missionType == MT_XP1_BATTLE or g_missionData.missionType == MT_XP1_MINICHALLENGE) then
			XP1_ShowResults(false)
		end
		Game_EndSP(false)
	end
end


-------------------------------------------------------------------------
-- SLOTTABLE SECONDARY OBJECTIVES
-------------------------------------------------------------------------
--? @shortdesc Selects a possible secondary objective and starts it.
--? @extdesc 'index' can be used to override the random selection and load a specific secondary objective.
--? @refs http://relicwiki.relic.sega.us/display/REL/Slottable+Secondary+Objectives
--? @args Bool showTitle, Bool skipIntel[, Int index]
function Mission_StartSecondaryObjective(showTitle, skipIntel, index)
	if(scartype(g_missionData.secondaryObjectives) ~= ST_TABLE or #g_missionData.secondaryObjectives == 0) then
		print("Unable to start Bonus Objective. Check your g_missionData.bonusObjectives table." )
	else
		if scartype(__secObjOverride) == ST_NUMBER then
			print("Using secondaryObjective override (" .. __secObjOverride .. ")")
			index = __secObjOverride
		else
			index = index or World_GetRand(1, #g_missionData.secondaryObjectives)
		end
		
		__SecondaryObjective = g_missionData.secondaryObjectives[index].obj
		__SecondaryObjective.data = g_missionData.secondaryObjectives[index].data
		
		local onStart = g_missionData.secondaryObjectives[index].onStart
		if scartype(onStart) == ST_FUNCTION then
			onStart()
		end
		
		Objective_Register(__SecondaryObjective)
		if (scartype(__SecondaryObjective.subObjectives) == ST_TABLE) then
			for i = 1, table.getn(__SecondaryObjective.subObjectives) do
				Objective_Register(__SecondaryObjective.subObjectives[i])
			end
		end
		
		Objective_Start(__SecondaryObjective, showTitle, skipIntel)
	end
end

--? @shortdesc Return a reference to the Secondary Objective table. Nil if objective has not been started yet.
--? @result Table objective
function Mission_GetSecondaryObjective()
	return __SecondaryObjective
end


--? @shortdesc Overrides the Slottable Secondary Objective. Receives a STRING with the objective table name [SecondaryObj_CaptureIntel / SecondaryObj_DemolitionMan / SecondaryObj_DestroyTank / SecondaryObj_KillVIP / SecondaryObj_RescueSquads]
--? @args String secObjTableName
function Mission_SetSecondaryObjectiveOverride(secObjTableName)
	__secObjOverride = nil
	for k,v in pairs(g_missionData.secondaryObjectives) do
		if v.obj == _G[secObjTableName] then
			print("Overriding secondary objective. Index " .. k)
			__secObjOverride = k
		end
	end

	if(__secObjOverride == nil) then
		print("## WARNING ## - Mission does not support Slottable Secondary Objective '" .. secObjTableName .. "'")
	end
end

-------------------------------------------------------------------------
-- MISSION UTIL FUNCTIONS
-------------------------------------------------------------------------
function Mission_IsDebug()
	return __IsDebug
end

function Mission_SetDebug(debugVal)
	if(scartype(debugVal) == ST_BOOLEAN) then
		__IsDebug = debugVal
	else
		fatal("Unable to set debug mode. Value must be BOOLEAN.")
	end
end

function Mission_GetNIS(ref)
	return g_missionData.nisFiles[ref]
end

--Cheat function called from CheatMenu. Completes all objective without any onComplete logic and calls Mission_complete.
-- The parameter determine the medal received (XPT_MSL_BRONZE, XPT_MSL_SILVER, XPT_MSL_GOLD)
function Mission_CheatWin(successLevel)
	Rule_RemoveAll()
	Event_RemoveAll(true)
	
	--Only run successLevel stuff for 'Ardennes Assault' missions
	if (g_missionData and (g_missionData.missionType == MT_XP1_CHALLENGE or g_missionData.missionType == MT_XP1_BATTLE or g_missionData.missionType == MT_XP1_CHALLENGE)) then
		XP1_SetMissionSuccessLevel(successLevel)
	end
	
	if scartype(__t_Objectives) == ST_TABLE then
		for k,obj in pairs(__t_Objectives) do
			obj.OnComplete = nil
			obj.PreComplete = nil
			Objective_Complete(obj, false, true)
			
			if(scartype(obj.subObjectives) == ST_TABLE) then
				for i, sobj in pairs(obj.subObjectives) do
					sobj.OnComplete = nil
					sobj.PreComplete = nil
					Objective_Complete(sobj, false, true)
				end
			end
		end
	end
	
	Rule_AddInterval(Mission_Complete, 1)
end

--Sames as Mission_CheatWin(), except with failure.
function Mission_CheatLose()
	Rule_RemoveAll()
	Event_RemoveAll(true)
	
	if scartype(__t_Objectives) == ST_TABLE then
		for k,obj in pairs(__t_Objectives) do
			obj.OnFail = nil
			obj.PreFail = nil
			Objective_Fail(obj, false, true)
			
			if(scartype(obj.subObjectives) == ST_TABLE) then
				for i, sobj in pairs(obj.subObjectives) do
					sobj.OnFail = nil
					sobj.PreFail = nil
					Objective_Fail(sobj, false, true)
				end
			end
		end
	end
	
	Rule_AddInterval(Mission_Fail, 1)
end



--TODO: This should go in Objectives.scar
function _CheckObjectivesCompletion()
	for k,obj in pairs(__t_Objectives) do
		if(Objective_IsStarted(obj) and not Objective_IsComplete(obj) and not Objective_IsFailed(obj)) then
			if(obj.IsComplete ~= nil and obj.IsComplete(obj)) then
				Objective_Complete(obj, obj.showTitle, obj.skipIntel)
			elseif(obj.IsFailed ~= nil and obj.IsFailed(obj)) then
				Objective_Fail(obj, obj.showTitle, obj.skipIntel)
			end
			
			--Check the subObjectives if tagged to do so
			if(scartype(obj.subObjectives) == ST_TABLE) then
				for i, sobj in pairs(obj.subObjectives) do
					if(Objective_IsStarted(sobj) and not Objective_IsComplete(sobj) and not Objective_IsFailed(sobj)) then
						if(sobj.IsComplete ~= nil and sobj.IsComplete(sobj)) then
							Objective_Complete(sobj, sobj.showTitle, sobj.skipIntel)
						elseif(sobj.IsFailed ~= nil and sobj.IsFailed(sobj)) then
							Objective_Fail(sobj, sobj.showTitle, sobj.skipIntel)
						end
					end
				end
			end
		end	
	end
end

