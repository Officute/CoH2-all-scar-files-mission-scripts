print("\tLoading ObjSecureTheFlank file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Elsenborn Ridge
-- Objective File - Secure the Flank
-- Designer: Ryan McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjSecureTheFlank()
	print("Initializing OBJ_SecureTheFlank...")
	
	-- Pre-condition:		<What are the conditions before the objective starts?>
	-- Success condition:	<What conditions complete the objective?>
	-- Failure condition:	<What conditions fail the objective?>
	-- Post-condition:
	--		Success:		<What happens if the objective is completed?>
	--		Failure:		<What happens if the objective is failed?>
	OBJ_SecureTheFlank = {
		--Info
		Title = 11076810, 		-- LOCDB [11076810] 'Secure the left Flank'
		Type = OT_Secondary,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				EVENTS.SecureTheFlank_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			EVENTS.SecureTheFlank_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = function()
			hpid_OBJ_SecureTheFlank = Objective_AddUIElements(OBJ_SecureTheFlank, eg_left_flank, true, 11076810, true)	--  [11076810] 'Secure the left Flank'
		end,
		PreStart = function()
			SecureTheLine_Init()
		end,
		OnStart = function()
			World_IncreaseInteractionStage()
			eventID_STF_Warning_01 = Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SecureTheFlank_Warning_01}, 2*60)
			eventID_STF_Warning_02 = Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SecureTheFlank_Warning_02}, 6.5*60)
			eventID_STF_Warning_03 = Event_Timer(EventHandler_StartIntel, {intel = EVENTS.SecureTheFlank_Warning_03}, 10*60)
			eventID_STF_StartAttacks = Event_Timer(SecureTheLine_StartAttacks, nil, 9.5*60)
		end,
		IsComplete = function()
			return Player_OwnsEGroup(player1, eg_left_flank)
		end,
		PreComplete = nil,
		OnComplete = function()
			if Event_Exists(eventID_STF_Warning_01) then
				Event_Remove(eventID_STF_Warning_01)
			end
			if Event_Exists(eventID_STF_Warning_02) then
				Event_Remove(eventID_STF_Warning_02)
			end
			if Event_Exists(eventID_STF_Warning_03) then
				Event_Remove(eventID_STF_Warning_03)
			end
			if Event_Exists(eventID_STF_StartAttacks) then
				Event_Remove(eventID_STF_StartAttacks)
			end
			
			-- Logic for closing wave defense encounters
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() 
			
		end,
	}
	
end
Scar_AddInit(INIT_ObjSecureTheFlank)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

-- This is where any supplemental functions should be written.
-- If any of the objective functions are too big/complex, they should be defined here.
function SecureTheLine_Init()
	-- Initialize Encounters
	ENCOUNTERS.SecureTheFlank_left_smlForest_01()
	ENCOUNTERS.SecureTheFlank_left_smlForest_02()
	ENCOUNTERS.SecureTheFlank_left_medForest_01()
	ENCOUNTERS.SecureTheFlank_left_vpDef_01()
	ENCOUNTERS.SecureTheFlank_left_vpDef_02()
	
	sg_a_runners = SGroup_CreateIfNotFound("sg_a_runners")
	Util_CreateSquads(player3, sg_a_runners, SBP.AEF.REAR_ECHELON_SQUAD_MP, mkr_left_a_runners_spawn, mkr_left_a_runners_dest, 2)
	SGroup_SetInvulnerable(sg_a_runners, true)
	Cmd_Retreat(sg_a_runners, mkr_left_a_runners_dest, mkr_left_a_runners_dest)
end

function SecureTheLine_StartAttacks()
	print("Opening Left Attacks")
	-- Logic to add to the wave defense system
	
	-- HACK TEMP
	sg_e_left = SGroup_CreateIfNotFound("sg_e_left")
	
	ENCOUNTERS.SecureTheFlank_left_wave()
--~ 	local waveEnc = ENCOUNTERS.SecureTheFlank_left_wave()
end

function _secureTheLine_Reset(encounterID)
	if Objective_IsComplete(OBJ_SecureTheFlank) == false then
		ENCOUNTERS.SecureTheFlank_left_wave()
	end
end


function DoNothing()
end



function __MonitorTerritories()
	
	for k,v in pairs(__terrMonitorData.territories) do
		if World_OwnsEGroup(v.egroup, ANY) or Util_GetPlayerOwner(v.egroup) == player2 then
			if v.counter == 0 then
				g_pointsLost = g_pointsLost + 1
				if g_pointsLost >= 2 then
					Rule_RemoveMe()
					Objective_Fail(OBJ_HoldTheLine)
					return
				end
				Util_StartIntel(EVENTS.HoldTheLine_PointCapturing)
				Objective_StartTimer(SOBJ_DefendVictoryPoints, COUNT_DOWN, 180, 90)
				Objective_UpdateText(SOBJ_DefendVictoryPoints, 11076811, 11076811, true) 		-- LOCDB [11076811] 'Reclaim the lost Victory Point'
				Objective_SetAlwaysShowDetails(SOBJ_DefendVictoryPoints, true, false, false)
				flashID_defend = UI_FlashObjectiveIcon(SOBJ_DefendVictoryPoints.ID, true)
--~ 				Rule_AddOneShot(_losingHQReminder, 30)
			end
			v.counter = v.counter + 1
--~ 			print(g_loseTerritoryCounter)
			if v.counter <= 180 then
				local timerSeconds = Objective_GetTimerSeconds(SOBJ_DefendVictoryPoints)
				local message = Loc_FormatText(11045653, Loc_ConvertNumber(timerSeconds)) -- LOCDB [11045653] 'Sector lost in %1SECONDS% seconds'
				UI_CreateEntityKickerMessage(World_GetPlayerAt(1), EGroup_GetRandomSpawnedEntity(v.egroup), message)
			end
			if v.counter > 180 then
				Objective_Fail(OBJ_HoldTheLine)
				Rule_RemoveMe()
				return
			end
		elseif (Util_GetPlayerOwner(v.egroup) == player1) and v.counter > 0 then
			print("Player owns")
			v.counter = 0
			g_pointsLost = g_pointsLost - 1
			UI_StopFlashing(flashID_defend)
			Objective_UpdateText(SOBJ_DefendVictoryPoints, 11076812, 11076812, false) 		-- LOCDB [11076812] 'Hold both points'
			Objective_SetAlwaysShowDetails(SOBJ_DefendVictoryPoints, false, false, false)
			Objective_StopTimer(SOBJ_DefendVictoryPoints)
		end
	end
end


