print("\tLoading Obj_DesttoyBunker file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siegfried Line
-- Objective File - Destroy the german bunker
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_ObjDestroyBunker()
	print("Initializing Obj_DestroyBunker...")
	
	g_playerBaseLocation = -1			-- Marker where the player base is
	eg_bunkerPillboxes = EGroup_CreateIfNotFound("eg_bunkerPillboxes")
	EGroup_AddEGroup(eg_bunkerPillboxes, eg_pillbox1)
	EGroup_AddEGroup(eg_bunkerPillboxes, eg_pillbox2)
	
	eg_hillPillboxes = EGroup_CreateIfNotFound("eg_hillPillboxes")
	EGroup_AddEGroup(eg_hillPillboxes, eg_bunkerHill2)
	EGroup_AddEGroup(eg_hillPillboxes, eg_bunkerHill3)
	
	--Bunker pillboxes on hill that get recrewed
	t_recrewBunkers = {"bunkerHill2", "bunkerHill3"}
	sg_bunkerHill2 = SGroup_CreateIfNotFound("sg_bunkerHill2")
	sg_bunkerHill3 = SGroup_CreateIfNotFound("sg_bunkerHill3")
	
	
	-- Pre-condition:		OBJ_AAGuns completed
	-- Success condition:	Bunkerspawner sequence completed (timeout)
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		Mission complete.
	--		Failure:		N/A
	OBJ_DestroyBunker = {
		Title = 11076825,		-- LOCDB [11076825] 'Destroy the Command Bunker'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,			
		
		Intel_Start = 				nil,		-- This is defined in runtime when the player selects a commander to lead the final assault. See 'Order<Company>Assist()' functions
		Intel_Start_SkipFunc = 		nil,		
		Intel_Complete = 			EVENTS.CommandBunkerSecured,		
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				EVENTS.PlayerBaseDestroyed,		
		Intel_Fail_SkipFunc = 		nil,		
		
		SetupUI = function() 
				FOW_RevealArea(Marker_GetPosition(mkr_commandBunker), 80, 0.3)
				Objective_AddUIElements(OBJ_DestroyBunker, mkr_bunkerStrike, true, 11076825, true, 3.0)	--[11076825] 'Destroy the Command Bunker'
			end,
		PreStart = function()
				Player_SetPopCapOverride(player1, 150)
				
				--Give the player back his units
				local _survivorGroup = t_commanderSelection[g_currentCommander].survivingSgroup
				SGroup_SetPlayerOwner(_survivorGroup, player1)
				--Don't forget about the vehicle drivers!
				for i=1, SGroup_CountSpawned(_survivorGroup) do
					local _driver = Squad_GetVehicleMobileDriverSquad(SGroup_GetSpawnedSquadAt(_survivorGroup, i))
					if scartype(_driver) == ST_SQUAD then
						Squad_SetPlayerOwner(_driver, player1)
					end
				end
				
				
				EGroup_SetInvulnerable(eg_bunkerPillboxes, true)
				
				_SpawnPlayerBase()
				Bunker_SetupEncounters()
				_CleanMainRoad()
				
				XP1_SetActiveCommander(g_currentCommander, false)
				XP1_StopCompanyStatTracking()
				Camera_MoveTo(g_playerBaseLocation, false)
				Game_SetMode(UI_Normal)
				Camera_SetInputEnabled(true)
				Game_FadeToBlack(FADE_IN, 1.2)
			end,
		OnStart = function()
				EGroup_DestroyAllEntities(eg_retreatPoint)
				
				--Send allies to attack bunker.
				Rule_AddOneShot(StartAlliedSurvivorAttack, 3.0)
				
				-- Start the bunker sequence when the player is up the hill and Hill bunker defenders are defeated
				Event_Proximity(StartBunkerSequence, nil, player1, mkr_commandBunker, nil, ANY, 2.0)
				--Callout bunkers on the hillsides
				Event_ElementOnScreen(StartRecrewPillboxes, nil, player1, eg_hillPillboxes, ANY, 0.8, true, 1.0)
				--Callout tank on the main road
				Event_ElementOnScreen(_RoadTankSpotted, nil, player1, g_enc_roadTank:GetSgroup(), ANY, 0.8, true, 1.0)
				--Send an attack wave against the player
				Event_NarrativeEventsNotRunning(SpawnGermanAttackWave, nil, t_difficulty.germanAttackDelay)
			end,
		IsComplete = nil,
		PreComplete = function()
				Rule_RemoveIfExist(CombatFlavourEnemy)
				Cmd_Stop(Player_GetSquads(player1))
				SGroup_SetAutoTargetting(Player_GetSquads(player1), "hardpoint_01", false)
				SGroup_SetSelectable(Player_GetSquads(player2), false)
			end,
		OnComplete = function()
				Event_RemoveAll()
				Rule_AddInterval(Mission_Complete, 1)
			end,
		IsFailed = function() return EGroup_GetAvgHealth(eg_XP1_player_base) <= 0.1 end,
		PreFail = nil,
		OnFail = function()
				Event_RemoveAll()
				Rule_AddInterval(Mission_Fail, 1)
			end,
	}

end
Scar_AddInit(INIT_ObjDestroyBunker)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
-- Spawn encounters protecting DefensiveLine#3
function Bunker_SetupEncounters()
	--Left
	local _enc_line3Left = ENCOUNTERS.Line3Left()
	Event_Proximity(EventHandler_AssignEncounterGoal, {encounter = _enc_line3Left, goalData = _enc_line3Left.data.goalData}, player1, mkr_line3_left, nil, ANY)
	
	ENCOUNTERS.Line3Left_Attack()
	Util_CreateSquads(player2, sg_bunkerHill2, SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP, eg_bunkerHill2)
	Util_CreateSquads(player2, nil, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_line3_left05)


	--Center
	ENCOUNTERS.Line3Road()
	g_enc_roadTank = ENCOUNTERS.Line3Tank()
	ENCOUNTERS.Line3Center()
	Util_CreateSquads(player2, nil, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, eg_bunkerHill1)

	
	--Right
	ENCOUNTERS.Line3Right()
	Util_CreateSquads(player2, sg_bunkerHill3, SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP, eg_bunkerHill3)

	
	--Hill/Bunker
	g_enc_hillRight = ENCOUNTERS.HillRight1()
	g_enc_bunker = ENCOUNTERS.BunkerDefenders()
	
	sg_bunkerMortars = SGroup_CreateIfNotFound("sg_bunkerMortars")
	Util_CreateSquads(player2, sg_bunkerMortars, SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP, mkr_commandBunker04)
	Util_CreateSquads(player2, sg_bunkerMortars, SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP, mkr_commandBunker05)
	
	sg_pillboxSquads = SGroup_CreateIfNotFound("sg_pillboxSquads")
	Util_CreateSquads(player2, sg_pillboxSquads, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, eg_pillbox1)
	Util_CreateSquads(player2, sg_pillboxSquads, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, eg_pillbox2)
end

--Spawn player base at a given position
function _SpawnPlayerBase(pos)
	print("Spawning player base...")
	local position = pos or t_challengeData[t_commanderSelection[g_currentCommander].challenge].basePos
	
	g_playerBaseLocation = position
	local _rallyPt = Marker_FromName(Marker_GetName(g_playerBaseLocation).."_rally", "")
	
	--Activate the corresponding entry point
	EGroup_ReSpawn( t_challengeData[t_commanderSelection[g_currentCommander].challenge].entryPt)
	
	--Move away any units in the base radius
	_sgTemp = SGroup_CreateIfNotFound("_sgTemp")
	World_GetSquadsNearMarker(player1, _sgTemp, position, OT_Player)
	SGroup_WarpToMarker(_sgTemp, _rallyPt)
	Cmd_Move(_sgTemp, _rallyPt, true, false, nil, nil, nil, 10)
	SGroup_Destroy(_sgTemp)
	
	
	--Clear any potential colliding objects
	_egTemp = EGroup_CreateIfNotFound("egTemp_World_KillNeutralEntitesNearMarker")
	World_GetNeutralEntitiesNearMarker(_egTemp, position)
	EGroup_DestroyAllEntities(_egTemp)
	EGroup_Destroy(_egTemp)
	
	--Spawn the base
	Util_CreateEntities(player1, nil, BP_GetEntityBlueprint("aef_base_stamper"), position, 1)
	_XP1_CollectBase()
	
	--Set rally point
	EGroup_SetRallyPoint(eg_XP1_player_base, _rallyPt)
	
	
	--This spawns the officers so all base buildings are unlocked
	Player_CompleteUpgrade(player1, UPG.AEF.LIEUTENANT_DISPATCHED_UPGRADE_MP)
	Player_CompleteUpgrade(player1, UPG.AEF.MAJOR_DISPATCHED_UPGRADE_MP)
	Player_CompleteUpgrade(player1, UPG.AEF.CAPTAIN_DISPATCHED_UPGRADE_MP)
	
end

function _CleanMainRoad()
	EGroup_DeSpawn(eg_barricadeLine2)
	local _eg_objects = EGroup_Create("")
	World_GetNeutralEntitiesNearMarker(_eg_objects, mkr_pathCleaner1)
	EGroup_Filter(_eg_objects, {BP_GetEntityBlueprint("hedgehog_03"), BP_GetEntityBlueprint("barbed_wire_01")}, FILTER_KEEP)
	EGroup_Kill(_eg_objects)
	EGroup_Destroy(_eg_objects)
end


----------------------------------------------
-- Commander hooks
----------------------------------------------
--Callback when tank on main road is spotted.
function _RoadTankSpotted(data)
	local target = g_enc_roadTank:GetSgroup()
--~ 	local target = Util_Grab() --debug
	
	if(SGroup_IsAlive(target)) then
		Util_StartIntel(EVENTS.RoadTankSpotted)
		UI_CreateMinimapBlip(target, 8, BT_General)
		FOW_RevealSGroupOnly(target, 15)
		
		--Get assistance from another company (if possible)
		if(XP1_GetDivision() ~= CD_SUPPORT and XP1_GetCommanderDataTable(CD_SUPPORT).isPresent and XP1_GetCommanderDataTable(CD_SUPPORT).isAlive) then
			--Call anti-tank artillery
			Util_StartIntel(EVENTS.RoadTankArtillery)
			Cmd_Ability(player1, BP_GetAbilityBlueprint("pm_artillery_support_anti_tank"), target, nil, true)
			local hint_ATArty = HintPoint_Add(target, true, 11076826)		-- LOCDB [11076826] 'Incoming Anti-Tank Artillery'
			Event_Timer(EventHandler_RemoveHint, {hint = hint_ATArty}, 10)
		
		elseif(XP1_GetDivision() ~= CD_MECHANIZED and XP1_GetCommanderDataTable(CD_MECHANIZED).isPresent and XP1_GetCommanderDataTable(CD_MECHANIZED).isAlive) then
			--Send M10 to assist
			Util_StartIntel(EVENTS.RoadTankM10)
			--TODO: This spawnPos is very hacky. need to get the proper map entry point.
			local spawnPos = Util_GetOffsetPosition(t_challengeData[t_commanderSelection[g_currentCommander].challenge].basePos, OFFSET_FRONT, 22)
			Util_CreateSquads(player1, nil, SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP, spawnPos, SGroup_GetPosition(target), nil, nil, true) 
		
		elseif(XP1_GetDivision() ~= CD_RANGER and XP1_GetCommanderDataTable(CD_RANGER).isPresent and XP1_GetCommanderDataTable(CD_RANGER).isAlive) then
			--Precision artillery drop
			Util_StartIntel(EVENTS.FoxAssistanceArtillery)
			Cmd_Ability(player3, BP_GetAbilityBlueprint("pm_pinpoint_artillery"), target, nil, true)
		end
	end
end

function _BunkerResistance(data)
	Util_StartIntel(EVENTS.BunkerResistance)
	if(XP1_GetDivision() ~= CD_AIRBORNE and XP1_GetCommanderDataTable(CD_AIRBORNE).isAlive) then
		Util_StartIntel(EVENTS.BunkerResistanceAirstrike)
		Cmd_Ability(player3, ABILITY.AEF.P47_ROCKET_ATTACK, mkr_commandBunker02, nil, true)
	end
end



--Sends attack wave to player's base. Callback after objective start.
function SpawnGermanAttackWave(data)
	Util_StartIntel(EVENTS.WarnGermanAttack)
	local enc = ENCOUNTERS.GermanAttack(g_playerBaseLocation)
	if g_difficulty <= GD_NORMAL then
		Modify_ReceivedDamage(enc:GetSgroup(), 1.5)
	end
	FOW_RevealSGroupOnly(enc:GetSgroup(), 15)
	UI_CreateMinimapBlip(enc:GetSgroup(), 10, BT_General)
end


--Takes surviving allied units and turns them into an attack encounter against the german bunker.
function StartAlliedSurvivorAttack()
	
	for k,v in pairs(t_commanderSelection) do
		if k ~= g_currentCommander and v.survivingSgroup ~= nil then
			--First, respawn them
			SGroup_ReSpawn(v.survivingSgroup)
			
			--If alive, give attack goal
			if(SGroup_CountSpawned(v.survivingSgroup) > 0) then
				local enc = Encounter:ConvertSgroup(v.survivingSgroup)
				GOALS.AlliedAttackBunker(enc)
				Modify_WeaponAccuracy(v.survivingSgroup, "hardpoint_01", 0.2)
				Modify_ReceivedDamage(v.survivingSgroup, 1.5)
				
				--Store it just in case.
				t_commanderSelection[k].endAttackEncounter = enc
			end
		end
	end
end


----------------------------------------------
-- Pillboxes surrounding the bunker
----------------------------------------------
--Callback when either of the hill pillboxes get spotted.
function StartRecrewPillboxes()
	Util_StartIntel(EVENTS.WarnPillboxRecrew)
	
	for k,pillboxName in pairs(t_recrewBunkers) do
		local _eg_box = EGroup_FromName("eg_"..pillboxName)
		if EGroup_CountSpawned(_eg_box) > 0 then
			HintPoint_Add(_eg_box, true, 11076827)		-- LOCDB [11076827] 'Destroy the pillbox'
		end
	end
	
	Rule_AddInterval(CheckRecrewPillboxes, 3.5)
end

-- These bunkers get recrewed until the player destroys them
function CheckRecrewPillboxes()
	
	for k,pillboxName in pairs(t_recrewBunkers) do
		local _eg_box = EGroup_FromName("eg_"..pillboxName)
		local _sg_unit = SGroup_FromName("sg_"..pillboxName)
		
		if EGroup_CountSpawned(_eg_box) > 0 and not SGroup_IsAlive(_sg_unit) then
			Util_CreateSquads(player2, _sg_unit, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, Marker_FromName("mkr_"..pillboxName.."_spawner",""))
			Cmd_Garrison(_sg_unit, _eg_box, nil, true, false)
		end
	end
	
end



----------------------------------------------
-- Ending bunker assault sequence
----------------------------------------------
--Starts once the player is up the hill (prox) and the encounter on top retreats into the bunker (onHealth)
function StartBunkerSequence()
	Util_StartIntel(EVENTS.HillTaken)
	
	if g_enc_hillRight ~= nil and g_enc_hillRight:IsAlive() then
		g_enc_hillRight:ClearGoal()
		Cmd_StaggeredRetreat(g_enc_hillRight:GetSgroup(), {mkr_retreat01}, nil, true)
	end
	
	if SGroup_IsAlive(sg_bunkerMortars) then
		Cmd_Retreat(sg_bunkerMortars, mkr_retreat02, mkr_retreat02, nil, nil, true)
	end
	
	Modify_ReceivedDamage(Player_GetSquads(player1), 0.75)
	
	local _enemySquads = Player_GetSquads(player2)
	SGroup_Filter(_enemySquads, SBP.GERMAN.M01_STUKA_DOGFIGHT, FILTER_REMOVE)
	Modify_ReceivedDamage(_enemySquads, 1.5)
	
	Event_NarrativeEventsNotRunning(CalloutBunkerPillboxes, nil, 0.0)
end

function CalloutBunkerPillboxes(data)
	Util_StartIntel(EVENTS.TargetBunker)
	hpid_pillbox1 = HintPoint_Add(eg_pillbox1, true, 11076828, 1, HPAT_Critical)		-- LOCDB [11076828] 'Target the pillboxes'
	hpid_pillbox2 = HintPoint_Add(eg_pillbox2, true, 11076828, 1, HPAT_Critical)
	
	EGroup_SetInvulnerable(eg_bunkerPillboxes, false)
	Event_OnHealth(EndBunkerSpawning, nil, eg_bunkerPillboxes, 0.0, false, 4.0)
	
	--Give the player some additional units to end things quickly
--~ 	local _tankCount = _CountTanks(Player_GetSquads(player1))
	
--~ 	if(_tankCount < 2) then
		--TODO: This spawnPos is very hacky. need to get the proper map entry point.
		local spawnPos = Marker_FromName(Marker_GetName(g_playerBaseLocation).."_rally", "")
		Util_GetOffsetPosition(g_playerBaseLocation, OFFSET_FRONT, 22)
		local _tanks = SGroup_CreateIfNotFound("tanks")
		Util_CreateSquads(player1, _tanks, SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP, spawnPos, nil, nil, nil, false, nil, nil, Marker_GetPosition(mkr_commandBunker04)) 
		Util_CreateSquads(player1, _tanks, SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP, spawnPos, nil, nil, nil, false, nil, nil, Marker_GetPosition(mkr_commandBunker04)) 
		
		Cmd_Attack(_tanks, eg_bunkerPillboxes, true)
--~ 	end
end

--Callback when pillboxes are destroyed
function EndBunkerSpawning(data)
	Util_StartIntel(EVENTS.BunkerSpawningEnded)
	HintPoint_Remove(hpid_pillbox1)
	HintPoint_Remove(hpid_pillbox2)
	
	--Make remainder attackers surrender
	g_enc_bunker:ClearGoal()
	g_enc_bunker:RemoveOnDeath(true)
	if SGroup_IsAlive(sg_pillboxSquads) then
		g_enc_bunker:AddSgroup(sg_pillboxSquads)
	end
	SGroup_SetPlayerOwner(g_enc_bunker:GetSgroup(), player3)
	SGroup_EnableMinimapIndicator(g_enc_bunker:GetSgroup(), false)
	
	
	
	--Stop player units
	Cmd_Stop(Player_GetSquads(player1))
	
	--Stop allied units
	for k,v in pairs(t_commanderSelection) do
		if v.endAttackEncounter ~= nil and scartype(v.endAttackEncounter) == ST_TABLE then
			v.endAttackEncounter:ClearGoal()
		end
	end
	Cmd_Stop(Player_GetSquads(player3))
	
	Cmd_Surrender(g_enc_bunker:GetSgroup(), nil, mkr_commandBunker04, false, true)
	
	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveComplete, {objective = OBJ_DestroyBunker}, 5.0)
end



--Replaces a unit on an encounter.
function ReplaceUnitBunker(unit)
	local enc = unit.encounter
	unit.data.spawn = {mkr_bunkerSpawner, mkr_bunkerSpawner2, mkr_bunkerSpawner3, mkr_bunkerSpawner4}
	enc:AddUnit(unit.data)
	
	Modify_ReceivedDamage(enc:GetSgroup(), 1.5, true)
	
	if(not enc:Goal_HasValidObjective()) then
		enc:RestartGoal()
	end	
end
