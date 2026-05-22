print("\tLoading Obj_Artillery file...")
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
function INIT_ObjArtillery()
	print("Initializing ObjArtillery...")
	
	t_artilleryEncounters = {}									--List of encounters in this objective
	t_artyTargets = {mkr_artyTarget_02, mkr_artyTarget_03}
	
	-- Pre-condition:		Road objective completed/failed
	-- Success condition:	Artillery positions killed
	-- Failure condition:	All player units killed
	-- Post-condition:
	--		Success:		None.
	--		Failure:		N/A
	OBJ_Artillery = {
		Title = 11076823,		-- LOCDB [11076823] 'Eliminate the Enemy Artillery'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = nil,
		
		Intel_Start = 				EVENTS.StartArtillery,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.OutroArtillery,		
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.AbleObjectiveFailed,
		Intel_Fail_SkipFunc = 		nil,
		
		SetupUI = function()
				t_artyUI = {
					Objective_AddUIElements(OBJ_Artillery, sg_artillery1, false, 11076823, true, 3.0),
					Objective_AddUIElements(OBJ_Artillery, sg_artillery2, false, 11076823, true, 3.0),
					Objective_AddUIElements(OBJ_Artillery, sg_artillery3, false, 11076823, true, 3.0),
				}
				Objective_AddPing(OBJ_Artillery, mkr_ui_artillery)
			end,
		PreStart = function()
				FOW_RevealMarker(mkr_line1_top, 0.3)
				Player_SetResource(player1, RT_Manpower, 420*2)
				Player_AddResource(player1, RT_Munition, 120)
				
				EGroup_DestroyAllEntities(eg_retreatPoint)
				Util_CreateEntities(player1, eg_retreatPoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_spawnArty_06, 1)
				
				Cmd_Ability(sg_artillery1, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, mkr_artyTarget_01, mkr_artyTarget_01, true, false)
				
				_SpawnArtilleryEncounters()
			end,
		OnStart = function()
				SGroup_SetInvulnerable(sg_alliesArtillery, false)
				Event_NarrativeEventsNotRunning(_WarnParatroopers, nil, 3.0)
				
				Rule_AddInterval(_FakeFireArtillery, 60) --This function is in the main mission file
			end,
		IsComplete = function()
				return SGroup_CountSpawned(sg_enemyArtillery) == 0 or SGroup_IsRetreating(sg_enemyArtillery, ALL)
			end,
		PreComplete = nil,
		OnComplete = function() 
				Rule_Remove(_FakeFireArtillery)
				t_artyUI = nil
				
				SGroup_DestroyAllSquads(sg_alliesArtillery)
				SGroup_Kill(sg_artillery1)
				SGroup_Kill(sg_artillery2)
				SGroup_Kill(sg_artillery3)
				
				EGroup_InstantCaptureStrategicPoint(eg_terrArtilleryFront, player1)
				t_challengeData[g_currentChallenge].completed = true
				Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0)
				
				RetreatRemainingEncounters(t_artilleryEncounters, mkr_hillLeft1)
			end,
		IsFailed = function() return not SGroup_IsAlive(Player_GetSquads(player1)) end,
		PreFail = nil,
		OnFail = function()
				Rule_Remove(_FakeFireArtillery)
				Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0)
			end,
	}
	
end
Scar_AddInit(INIT_ObjArtillery)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function ObjArtillery_Init()
	--NOTE: Starting player units and allies are spawned in mission_preset()
	
	--Enemy starting forces
	t_artilleryEncounters.treeline = ENCOUNTERS.Artillery_Treeline()
end

function _SpawnArtilleryEncounters()
	
	--NOTE: Artillery Guns are spawned in Mission_Preset()
	
--~ 	t_artilleryEncounters.treeline = ENCOUNTERS.Artillery_Treeline()
	
	--Static HMG's
	for k,v in ipairs(Marker_GetSequence("mkr_line1_topHMG",  "")) do
		t_artilleryEncounters["staticHMG"..k] = ENCOUNTERS.Artillery_TreelineStatic(v, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, Game_GetSPDifficulty() == GD_HARD)
	end
	
	--Static AT guns
	for k,v in pairs(Marker_GetSequence("mkr_line1_topAT",  "")) do
		t_artilleryEncounters["staticAT"..k] = ENCOUNTERS.Artillery_TreelineStatic(v, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, true)
	end
	
	t_artilleryEncounters.defenders1 = ENCOUNTERS.Artillery_Defenders1()
	t_artilleryEncounters.defenders2 = ENCOUNTERS.Artillery_Defenders2()
	t_artilleryEncounters.vehicle = ENCOUNTERS.Artillery_DefendersVehicle()
	
	
	
	--EVENTS
	--increase obj counter when an artillery piece is destroyed/killed
	Event_OnHealth(_ArtilleryKilled, {ui = 1}, sg_artillery1, 0.67, false)
	Event_OnHealth(_ArtilleryKilled, {ui = 2}, sg_artillery2, 0.67, false)
	Event_OnHealth(_ArtilleryKilled, {ui = 3}, sg_artillery3, 0.67, false)
end

function _WarnParatroopers()
	Player_AddAbility(player3, BP_GetAbilityBlueprint("major_quick_recon_run"))
	Cmd_Ability(player3, BP_GetAbilityBlueprint("major_quick_recon_run"), mkr_line1_topHMG2, nil, true)
end

--Callback when an artillery piece is destroyed
function _ArtilleryKilled(data)
	Objective_RemoveUIElements(OBJ_Artillery, t_artyUI[data.ui])
	Cmd_AbandonTeamWeapon(data._target, true)
	SGroup_RemoveGroup(sg_enemyArtillery, data._target)
end


function _FakeFireArtillery()
	if SGroup_IsAlive(sg_enemyArtillery) then
		FireEnemyArtillery(t_artyTargets)
	else
		Rule_RemoveMe()
	end
end



--~ Rule_AddGlobalEvent(Airborne_PlayerCalledInParatroopers, GE_AbilityExecuted)

--~ function Airborne_PlayerCalledInParatroopers(caster, ability, target)

--~   if caster == player1 and ability == BP_GetAbilityBlueprint("pm_aef_paratroopers") then
--~     
--~     Rule_RemoveMe()
--~     Rule_AddOneShot(Airborne_ParatroopersEnRoute, 4)
--~     
--~   end

--~ end

