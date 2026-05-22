print("\tLoading Obj_AAGuns file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siegfried Line
-- Objective File - Eliminate the Enemy Artillery
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjAAGuns()
	print("Initializing Obj_AAGuns...")
	
	sg_enemyAA = SGroup_CreateIfNotFound("sg_enemyAA")
	sg_enemyAA_1 = SGroup_CreateIfNotFound("sg_enemyAA_1")
	sg_enemyAA_2 = SGroup_CreateIfNotFound("sg_enemyAA_2")
	 
	t_AAEncounters = {}									-- Encounters used in this objective.
	t_AA_UI = {}
	
	-- Pre-condition:		Artillery objective finished/failed
	-- Success condition:	AA guns are destroyed
	-- Failure condition:	All player units killed.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		N/A
	OBJ_AAGuns = {
		Title = 11076822,		-- LOCDB [11076822] 'Eliminate the Enemy AA Guns'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = nil,
--~ 		showTitle = false,
		
		Intel_Start = 				EVENTS.StartAAGuns,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.OutroAAGuns,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.DogObjectiveFailed,
		Intel_Fail_SkipFunc = 		nil,
		
		SetupUI = function()
				t_AA_UI.sg_enemyAA_1 = Objective_AddUIElements(OBJ_AAGuns, sg_enemyAA_1, false, 11076822, true, 3.0)		-- [11076822] 'Eliminate the Enemy AA Guns'
				t_AA_UI.sg_enemyAA_2 = Objective_AddUIElements(OBJ_AAGuns, sg_enemyAA_2, false, 11076822, true, 3.0)		-- [11076822] 'Eliminate the Enemy AA Guns'
				
				Objective_AddPing(OBJ_AAGuns, mkr_ui_AAGuns)
				Rule_AddDelayedInterval(_AA_CheckRetreats, 3, 0.5)
			end,
		PreStart = function()
				_SpawnAAEncounters()
				SGroup_SetInvulnerable(sg_enemyAA, false)
				Player_SetResource(player1, RT_Manpower, 320*2)
				Player_SetResource(player1, RT_Munition, 250)
				
				EGroup_DestroyAllEntities(eg_retreatPoint)
				Util_CreateEntities(player1, eg_retreatPoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_camStart_AA, 1)
			end,
		OnStart = function()
				SGroup_SetInvulnerable(sg_alliesAA, false)
				Event_NarrativeEventsNotRunning(_Line1RightRetreat, nil, 3.0)
			end,
		IsComplete = function()
				return SGroup_CountSpawned(sg_enemyAA) == 0 or SGroup_IsRetreating(sg_enemyAA, ALL)
			end,
		PreComplete = nil,
		OnComplete = function() 
				SGroup_DestroyAllSquads(sg_alliesAA)
				Rule_Remove(_AA_CheckRetreats)
				t_AA_UI = nil
		
				EGroup_InstantCaptureStrategicPoint(eg_line2_right, player1)
				EGroup_InstantCaptureStrategicPoint(eg_line1_right, player1)
				t_challengeData[g_currentChallenge].completed = true
				Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0)
				
				RetreatRemainingEncounters(t_AAEncounters, mkr_line3_right)
			end,
		IsFailed = function() return not SGroup_IsAlive(Player_GetSquads(player1)) end,
		PreFail = nil,
		OnFail = function() Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0) end,
	}
end
Scar_AddInit(INIT_ObjAAGuns)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
--Init pre-objective start
function ObjAAGuns_Init()
	t_AAEncounters.line1Right = ENCOUNTERS.Line1Right()
	
	sg_alliesAA = SGroup_CreateIfNotFound("sg_alliesAA")
	Util_CreateSquads(player3, sg_alliesAA, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_spawnAA_06)
	Util_CreateSquads(player3, sg_alliesAA, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_spawnAA_02, mkr_line1_right01, nil, nil, true)
	SGroup_SetInvulnerable(sg_alliesAA, true)
	Modify_ReceivedDamage(sg_alliesAA, 0.3)
	Modify_WeaponDamage(sg_alliesAA, "hardpoint_01", 0.2)
	
	--Pre-start units
	t_commanderSelection[g_currentCommander].prestartUnits()
end

function _SpawnAAEncounters()
	
	--NOTE: AA Guns are spawned in Mission_Preset()
	
	t_AAEncounters._enc_forest1 = ENCOUNTERS.AA_ForestLeft_01()
	t_AAEncounters._enc_forest2 = ENCOUNTERS.StaticDefenders(mkr_forestLeft_02, {SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP}, true, mkr_line3_right)
	t_AAEncounters._enc_forest3 = ENCOUNTERS.StaticDefenders(mkr_forestLeft_01, {SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP}, true, mkr_line3_right)
	
	t_AAEncounters._enc_forest4 = ENCOUNTERS.AA_ForestLeft_02()
	t_AAEncounters.forestLeft03 = ENCOUNTERS.AA_ForestLeft_03()
	
	t_AAEncounters.forestRight = ENCOUNTERS.AA_ForestRight()
	t_AAEncounters._enc_forest5 = ENCOUNTERS.AA_ForestRight_02()
	t_AAEncounters._enc_forest6 = ENCOUNTERS.AA_ForestRight_HMG()
	t_AAEncounters.gun2Armor = ENCOUNTERS.AA_Gun2Armor()
	

	
	-- EVENTS
	--Redirect right flank to protect AA gun
	Event_IsEngaged(_AAGun2Attacked, {encounter = t_AAEncounters.forestRight}, sg_enemyAA_2, ANY, 5)
	--Retreat AAGun1 defenders if gun is almost destroyed
	Event_OnHealth(EventHandler_StaggeredRetreat, {group = t_AAEncounters.forestLeft03:GetSgroup(), location = mkr_line3_right, tries = 10}, sg_enemyAA_1, 0.1, false)
	
	--Callout enemy armor on AAGun2
	Event_ElementOnScreen(AAGun2_ArmorAssist, nil, player1, t_AAEncounters.gun2Armor:GetSgroup(), ANY, 0.85, true, 1.5)
end

function _Line1RightRetreat()
	t_AAEncounters.line1Right:ClearGoal()
	
	Cmd_Retreat(t_AAEncounters.line1Right:GetSgroup(), mkr_forestLeft_04, mkr_forestLeft_04, false, true, true)
	
	Rule_AddOneShot(_AA_AirborneAssist, 2.0)
end


function _AA_AirborneAssist()
	if(XP1_GetCommanderDataTable(CD_AIRBORNE).isPresent and XP1_GetCommanderDataTable(CD_AIRBORNE).isAlive) then
		Util_StartIntel(EVENTS.AA_AirborneAssist)
		Cmd_Ability(player1, ABILITY.AEF.PARATROOPERS_PARADROP, mkr_line1_right03, nil, true, false)
	end
end

function _AAGun2Attacked(data)
	GOALS.DefendLocation(data.encounter, data._group)
	if(t_AAEncounters.gun2Armor:IsAlive()) then
		t_AAEncounters.gun2Armor:TriggerGoal()
	end
end

function AAGun2_ArmorAssist()
	if SGroup_IsAlive(t_AAEncounters.gun2Armor:GetSgroup()) then
		Util_StartIntel(EVENTS.AAGun2ArmorSpotted)
		UI_CreateMinimapBlip(t_AAEncounters.gun2Armor:GetSgroup(), 5, BT_General)
		if(XP1_GetCommanderDataTable(CD_MECHANIZED).isPresent and XP1_GetCommanderDataTable(CD_MECHANIZED).isAlive) then
			Util_StartIntel(EVENTS.AA_MechanizedAssist)
			Util_CreateSquads(player1, nil, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_spawnAA_road, Marker_GetPosition(mkr_forestRight_04), 1, nil, true)
			
		elseif(XP1_GetCommanderDataTable(CD_RANGER).isPresent and XP1_GetCommanderDataTable(CD_RANGER).isAlive and XP1_GetDivision() ~= CD_RANGER) then
			Util_StartIntel(EVENTS.FoxAssistanceCluster)
			UI_CreateMinimapBlip(t_AAEncounters.gun2Armor:GetSgroup(), 7.0, BT_General)
			Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_airdropped_mines"), t_AAEncounters.gun2Armor:GetSgroup(), nil, true, false)
		end
	end
end

--checks if any members of the AA gun crews are retreating
function _AA_CheckRetreats()
	for k,v in pairs({sg_enemyAA_1, sg_enemyAA_2}) do
		if SGroup_IsRetreating(v, true) and scartype(t_AA_UI[SGroup_GetName(v)]) ~= ST_NIL then
			Objective_RemoveUIElements(OBJ_AAGuns, t_AA_UI[SGroup_GetName(v)])
		end
	end
end
