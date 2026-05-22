print("\tLoading Obj_BreakLine file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siegfried Line
-- Objective File - Secure the main road
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjBreakLine()
	print("Initializing ObjBreakLine...")
	
	
	sg_line1 = SGroup_CreateIfNotFound("sg_line1")					--Enemy units in the first road checkpoint
	t_encountersRoadBack = {}										--List of encounters in this objective
	t_encountersRoadFront = {}										--List of encounters in this objective
	
	-- Pre-condition:		Mission start.
	-- Success condition:	Road terr point is secured
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		N/A
	OBJ_BreachLine = {
		Title = 11076824,		-- LOCDB [11076824] 'Secure the main road'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,						
		Parent = nil,
		subObjectives = {},
		
		Intel_Start = 				EVENTS.StartSecureRoad,		
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.OutroSecureRoad,		
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.BakerObjectiveFailed,
		Intel_Fail_SkipFunc = 		nil,
		
		SetupUI = function()
				Objective_AddUIElements(OBJ_BreachLine, eg_line1_center, true, 11076824, true, 3.0)
			end,
		PreStart = function()
				Player_AddResource(player1, RT_Munition, 200)
				
				_SpawnRoadEncounters()
				EGroup_DestroyAllEntities(eg_retreatPoint)
				Util_CreateEntities(player1, eg_retreatPoint, BP_GetEntityBlueprint("sp_retreat_point"), mkr_camStart_road, 1)
			end,
		OnStart = function()
				SGroup_SetInvulnerable(sg_alliesRoad, false)
				Event_NarrativeEventsNotRunning(_GiveAirborneGift, nil, 4.0)
			end,
		IsComplete = function()
				return SGroup_CountSpawned(sg_line1) == 0 or SGroup_IsRetreating(sg_line1, ALL)
			end,
		PreComplete = nil,
		OnComplete = function()
				Rule_Remove(_FireArtilleryOnPlayer)
				
				SGroup_DestroyAllSquads(sg_alliesRoad)
				
				EGroup_InstantCaptureStrategicPoint(eg_line1_center, player1)
				t_challengeData[g_currentChallenge].completed = true
				Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0)
				
				RetreatRemainingEncounters(t_encountersRoadBack, mkr_line3_road)
				RetreatRemainingEncounters(t_encountersRoadFront, mkr_line3_road)
			end,
		IsFailed = function() return not SGroup_IsAlive(Player_GetSquads(player1)) end,
		PreFail = nil,
		OnFail = function()
				Rule_Remove(_FireArtilleryOnPlayer)
				Event_NarrativeEventsNotRunning(GoToNextChallenge, nil, 1.0) 
			end,
	}
	
end
Scar_AddInit(INIT_ObjBreakLine)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
--Init pre-objective start
function ObjRoad_Init()
	t_encountersRoadFront = {
		enc_tank = ENCOUNTERS.Line1Tank(),
		enc_farm = ENCOUNTERS.Line1Farm(),
	}

	sg_alliesRoad = SGroup_CreateIfNotFound("sg_alliesRoad")
	Util_CreateSquads(player3, sg_alliesRoad, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_allySpawn01)
	Util_CreateSquads(player3, sg_alliesRoad, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_allySpawn02)
	SGroup_SetInvulnerable(sg_alliesRoad, true)
	Modify_ReceivedDamage(sg_alliesRoad, 0.3)
	Modify_WeaponDamage(sg_alliesRoad, "hardpoint_01", 0.2)
	
	--Pre-start units
	t_commanderSelection[g_currentCommander].prestartUnits()
end

-- Spawn enemy units on the front line
function _SpawnRoadEncounters()
	
	t_encountersRoadBack = {
		line1Left = ENCOUNTERS.Line1Left(),
		line1Center = ENCOUNTERS.Line1Center(),
	}

end


--If Airborne alive, give flyby to player. Callback from objective start.
function _GiveAirborneGift(data)
	
	if(t_challengeData[1].completed) then
		--TODO:DLC - add hooks for Commander assistance opportunities. 
		if(t_challengeData[1].commander == CD_AIRBORNE) then
			--Airborne aid
			Util_StartIntel(EVENTS.Artillery_AirborneGift)
			
			-- NOTE: because the airborne commander no longer has this ability, we must manually add and hide it
			Player_AddAbility(player3, ABILITY.AEF.RECON_SWEEP)
			Player_SetAbilityAvailability(player3, ABILITY.AEF.RECON_SWEEP, ITEM_REMOVED)

			Cmd_Ability(player3, ABILITY.AEF.RECON_SWEEP, Marker_GetPosition(mkr_line1_center06), nil, true)
			UI_CreateMinimapBlip(eg_line1_center, 10.0, BT_General)
		elseif(t_challengeData[1].commander == CD_RANGER) then
			--Recon aid
			Util_StartIntel(EVENTS.FoxAssistanceRangers)
			Util_CreateSquads(player1, nil, SBP.AEF.RANGER_SQUAD_MP, mkr_spawnRoad, mkr_camStart_road)
			UI_CreateMinimapBlip(mkr_camStart_road, 7.0, BT_General)
		end
		
	elseif(not t_challengeData[1].completed) then
		Util_StartIntel(EVENTS.WarnEnemyArtillery)
		_FireArtilleryOnPlayer()
		UI_CreateMinimapBlip(mkr_artyTarget_02, 8.0, BT_General)
		UI_CreateMinimapBlip(mkr_artyTarget_03, 8.0, BT_General)
		Rule_AddInterval(_FireArtilleryOnPlayer, 70)
		for k,v in pairs(t_artyTargets) do
			UI_CreateMinimapBlip(v, 5, BT_General)
		end
	end
end

function _FireArtilleryOnPlayer()
	if SGroup_IsAlive(sg_enemyArtillery) then
		FireEnemyArtillery(t_artyTargets)
	else
		Rule_RemoveMe()
	end
end
