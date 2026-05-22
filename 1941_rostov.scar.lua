-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Theatre of War Co-Op Scenario: Faceoff at Rostov
-- Nov 1941
-- Designers: Chris Becker, NJR and Philippe Boulle 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = Setup_Player(3, 11048274, "soviet", 2) -- LOCDB [11048274] 'Soviet 37th Army'
	player4 = Setup_Player(4, 11048274, "soviet", 2) -- LOCDB [11048274] 'Soviet 37th Army'
end



function OnGameRestore()
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	Game_DefaultGameRestore()
end

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()

	Mission_Debug()
	Mission_Difficulty()
	Mission_Restrictions()
	Mission_MissionPreset()
	
	ToW_SetUpBattleObjectives ()
	SetupAchievements()
	
	Rule_AddOneShot(Rostov_MissionStart, 0.1)
	Rule_AddInterval(Rostov_UpdateOwnerShip, 1)

	World_SetIceHealingRate(0.001)

end

Scar_AddInit(OnInit)

function Mission_MissionPreset()
	STATUS_UNKNOWN				= 0
	STATUS_OPEN					= 1
	STATUS_GERMAN_CONTROL		= 2
	STATUS_GERMAN_ADVANTAGE		= 3
	STATUS_EVEN					= 4
	STATUS_SOVIET_ADVANTAGE		= 5
	STATUS_SOVIET_CONTROL		= 6

	g_currentStatus = STATUS_UNKNOWN
	g_neverSovietAdvantage = true
	g_RaidNumber = 0
	t_raids = {}
	t_status = {
	-- STATUS_OPEN (3 neutral)
		{
			name = "OPEN",
			cooldown = 0,
			lastUse = 0,
			onEntry = function (playerData, team)
			end,
			onExit = function (playerData, team)
			end,
		},
	-- STATUS_GERMAN_CONTROL (3 german)		
		{
			name = "GERMAN_CONTROL",
			cooldown = 60,
			lastUse = 0,
			onEntry = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets -- mass and attack one point
					g_sovietUrgent = true
				end
			end,
			onExit = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets					
				end
			end,
		},
	-- STATUS_GERMAN_ADVANTAGE	(german > sov)	
		{
			name = "GERMAN_ADVANTAGE",
			cooldown = 120,
			lastUse = 0,
			onEntry = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets -- penal battalion base rush
					if not Rule_Exists (SovietRaidCheck) then
						g_sovietUrgent = false
						SovietRaidCheck()
						Rule_AddInterval ( SovietRaidCheck, t_difficulty.raidInterval)
					end
				end
			end,
			onExit = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets
				
				end
			end,
		},
	-- STATUS_EVEN		(1 german, 1 soviet)			
		{
			name = "EVEN",
			cooldown = 0,
			lastUse = 0,
			onEntry = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets
				end
			end,
			onExit = function (playerData, team)
				if team == Germans.team then
				-- germans
				elseif team == Soviets.team then
				-- soviets
				end
			end,
		},
	-- STATUS_SOVIET_ADVANTAGE		(sov > german)
		{
			name = "SOVIET_ADVANTAGE",
			cooldown = 0,
			lastUse = 0,
			onEntry = function (playerData, team)
				g_neverSovietAdvantage = false
				if team == Germans.team then
				-- germans -- rapid capture
					Player_GetAll(playerData.playerid)
					Modify_SquadCaptureRate(sg_allsquads, 2)
					SGroup_Clear(sg_allsquads)
					if playerData.playerid == Game_GetLocalPlayer() then
						Util_MissionTitle(11046237) -- LOCDB [11046237] 'Your infantry now captures more rapidly.'
					end
					local data = {
						message = 11046237, -- LOCDB [11046237] 'Your infantry now captures more rapidly.'
						status = STATUS_SOVIET_ADVANTAGE,
					}
					Player_SetAbilityAvailability(playerData.playerid, BP_GetAbilityBlueprint("capture_speed"), ITEM_UNLOCKED)
					local flash = UI_FlashAbilityButton( BP_GetAbilityBlueprint("capture_speed"), false)
					Event_Timer (StopFlash, {id = flash}, 3)
				elseif team == Soviets.team then
				-- soviets
				end
			end,
			onExit = function (playerData, team)
				if team == Germans.team then
				-- germans
					Player_GetAll(playerData.playerid)
					Modify_SquadCaptureRate(sg_allsquads, 0.5)
					SGroup_Clear(sg_allsquads)
					if playerData.playerid == Game_GetLocalPlayer() then
						Util_MissionTitle(11046238) -- LOCDB [11046238] 'Your infantry now captures normally.'
					end
					Player_SetAbilityAvailability(playerData.playerid, BP_GetAbilityBlueprint("capture_speed"), ITEM_REMOVED)
				elseif team == Soviets.team then
				-- soviets
				end
			end,
		},
	-- STATUS_SOVIET_CONTROL	(3 soviet)	
		{
			name = "SOVIET_CONTROL",
			cooldown = 0,
			lastUse = 0,
			onEntry = function (playerData, team)
				g_neverSovietAdvantage = false
				if team == Germans.team then
				-- germans -- rapid unit production 
					Player_GetAll(playerData.playerid)
					EGroup_Filter(eg_allentities, {EBP.GERMAN.BEREICH_FESTUNG, EBP.GERMAN.DOLCH_AKTIONEN, EBP.GERMAN.GERMAN_HQ, EBP.GERMAN.HINTERE_PANZERWERK, EBP.GERMAN.SCHWERES_KRIEGSWERK}, FILTER_KEEP)
					Modify_ProductionRate(eg_allentities, 2)
					EGroup_Clear(eg_allentities)
					if playerData.playerid == Game_GetLocalPlayer() then
						Util_MissionTitle(11046239) -- LOCDB [11046239] 'Your units now train more rapidly.'

					end
					local data = {
						message = 11046239, -- LOCDB [11046239] 'Your units now train more rapidly.'
						status = STATUS_SOVIET_CONTROL,
					}
					Player_SetAbilityAvailability(playerData.playerid, BP_GetAbilityBlueprint("production_speed"), ITEM_UNLOCKED)
					local flash = UI_FlashAbilityButton( BP_GetAbilityBlueprint("production_speed"), false)
					Event_Timer (StopFlash, {id = flash}, 3)
				elseif team == Soviets.team then
				-- soviets
				end
			end,
			onExit = function (playerData, team)
				if team == Germans.team then
				-- germans
					Player_GetAll(playerData.playerid)
					EGroup_Filter(eg_allentities, {EBP.GERMAN.BEREICH_FESTUNG, EBP.GERMAN.DOLCH_AKTIONEN, EBP.GERMAN.GERMAN_HQ, EBP.GERMAN.HINTERE_PANZERWERK, EBP.GERMAN.SCHWERES_KRIEGSWERK}, FILTER_KEEP)
					Modify_ProductionRate(eg_allentities, 0.5)
					EGroup_Clear(eg_allentities)
					if playerData.playerid == Game_GetLocalPlayer() then
						Util_MissionTitle(11046240) -- LOCDB [11046240] 'Your units now train normally.'
					end
					Player_SetAbilityAvailability(playerData.playerid, BP_GetAbilityBlueprint("production_speed"), ITEM_REMOVED)
				elseif team == Soviets.team then
				-- soviets
				end
			end,
		},
	}

	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_raiders = SGroup_CreateIfNotFound ("sg_raiders")

	Germans = {
		players = {
			{
				playerid = World_GetPlayerAt(1),
				spawn = mkr_p1_stagingarea,
				stagingarea = mkr_p1_stagingarea,
			},
			{
				playerid = World_GetPlayerAt(2),
				spawn = mkr_p2_stagingarea,
				stagingarea = mkr_p2_stagingarea,
			},
		},
		team = Player_GetTeam(World_GetPlayerAt(1)),
		totalPoints = 0,
	}
	Soviets = {
		players = {
			{
				playerid = World_GetPlayerAt(3),
				spawn = mkr_p3_stagingarea,
				stagingarea = mkr_p3_stagingarea,
			},
			{
				playerid = World_GetPlayerAt(4),
				spawn = mkr_p4_stagingarea,
				stagingarea = mkr_p4_stagingarea,
			},
		},
		team = Player_GetTeam(World_GetPlayerAt(3)),
		totalPoints = 0,
	}	
	
	for k,player in pairs (Germans.players) do
		Player_AddAbility(player.playerid, BP_GetAbilityBlueprint("capture_speed"))
		Player_SetAbilityAvailability(player.playerid, BP_GetAbilityBlueprint("capture_speed"), ITEM_REMOVED)
		Player_AddAbility(player.playerid, BP_GetAbilityBlueprint("production_speed"))
		Player_SetAbilityAvailability(player.playerid, BP_GetAbilityBlueprint("production_speed"), ITEM_REMOVED)
	end
	
	
	--
	-- Table of VPs on this map
	--
	g_NeutralVPs = 0
	g_SovietVPs = 0
	g_GermanVPs = 0
	
	
	VPs = {
		{
			group = eg_vp1,
			marker = mkr_vp1,
		},
		{
			group = eg_vp2,
			marker = mkr_vp2,
		},
		{
			group = eg_vp3,
			marker = mkr_vp3,
		},
	}
	
	EGroup_SetInvulnerable(eg_roadbridge, true)
	EGroup_SetInvulnerable(eg_railbridge, true)
	
end

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_Restrictions()
	for i = 1,World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		ToW_SetUpTechTreeByYear(player, 1941)
		ToW_SetStandardResources (player)
		Player_SetHeatLossRate(player, 0.1)
		Player_SetHeatGainRate(player, 3)
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("allow_building_campfires")) -- Allow building campfires in this cold weather map
	end
end

function Mission_Difficulty()
	g_difficulty = Game_GetSPDifficulty()   
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	t_difficulty = {
		numVeryMany 	= Util_DifVar ( { 4, 5, 6, 6} ),
		numMany 		= Util_DifVar ( { 3, 4, 5, 5} ),
		numSome 		= Util_DifVar ( { 2, 3, 4, 4} ),
		numFew 			= Util_DifVar ( { 1, 2, 3, 3} ),
		numVeryFew 		= Util_DifVar ( { 1, 1, 2, 2} ),
		raidInterval 	= Util_DifVar ( { 180, 120, 90, 90} ),
	}
end

function Rostov_MissionStart()
	Util_CreateSquads(player3, sg_blah, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_p3_stagingarea, nil, 2)
	Util_CreateSquads(player4, sg_blah, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_p4_stagingarea, nil, 2)
	Util_StartIntel(EVENTS.Intro)
end

-------------------------------------------
-- VP OWNERSHIP FUNCTIONS
-------------------------------------------

function Rostov_UpdateOwnerShip()
	local neutralVPs = 0
	local germanVPs = 0
	local sovietVPs = 0
	local oldStatus = g_currentStatus or STATUS_UNKNOWN

	-- go through each VP in the above table, and assign info to each entry with that point's initial config
	for k, victorypoint in pairs(VPs) do 
		victorypoint.entity = EGroup_GetSpawnedEntityAt(victorypoint.group, 1)
		if World_OwnsEGroup(victorypoint.group, ALL) then
			neutralVPs = neutralVPs + 1
			victorypoint.owner = nil
		else
			victorypoint.owner = Player_GetTeam(Entity_GetPlayerOwner(victorypoint.entity))
			if victorypoint.owner == Soviets.team then
				sovietVPs = sovietVPs + 1
				Soviets.totalPoints = Soviets.totalPoints + 1
			elseif victorypoint.owner == Germans.team then
				germanVPs = germanVPs + 1
				Germans.totalPoints = Germans.totalPoints + 1
			end
		end
	end

	if neutralVPs == 3 then
		g_currentStatus = STATUS_OPEN
	elseif sovietVPs == 3 then
		g_currentStatus = STATUS_SOVIET_CONTROL
	elseif germanVPs == 3 then
		g_currentStatus = STATUS_GERMAN_CONTROL
	elseif germanVPs == sovietVPs then
		g_currentStatus = STATUS_EVEN
	elseif germanVPs > sovietVPs then
		g_currentStatus = STATUS_GERMAN_ADVANTAGE
	elseif germanVPs < sovietVPs then
		g_currentStatus = STATUS_SOVIET_ADVANTAGE
	else
		g_currentStatus = STATUS_UNKNOWN
	end
	
	if g_currentStatus ~= oldStatus then
		Rostov_StatusChange (oldStatus, g_currentStatus)
	end
	
end


function Rostov_StatusChange (oldStatus, newStatus, data)
	local oldName = "UNKNOWN"
	local oldData = {}
	local newName = "UNKNOWN"
	local newData = {}
	
	if (t_status[oldStatus]) then
		oldData = t_status[oldStatus]
		oldName = t_status[oldStatus].name
	end
	
	if (t_status[newStatus]) then
		newData = t_status[newStatus]
		newName = t_status[newStatus].name
	end
	
	_ToWDebugDisplay ("STATUS CHANGE from " .. oldName .. " to " .. newName)
	local exitfunc  = oldData.onExit  or function() end
	local enterfunc = newData.onEntry or function() end
	
	for k,v in pairs (Germans.players) do
		exitfunc (v, Germans.team)
		enterfunc (v, Germans.team)
	end
	for k,v in pairs (Soviets.players) do
		exitfunc (v, Soviets.team)
		enterfunc (v, Soviets.team)
	end
end

function DelayedEffect (data)
	if g_currentStatus == data.status then
		data.func(data.playerData, data.team)
	end
end

function StopFlash(data)
	UI_StopFlashing(data.id)
end

-------------------------------------------
-- SOVIET RAIDS
-------------------------------------------

function SovietRaidCheck ()
	_ToWDebugDisplay("SovietRaidCheck")
	if g_sovietUrgent then
			local raidData = {
				isHeavy = false,
				numUnits = t_difficulty.numSome,
				isNeutral = true,
				baseIsValid = false,
				veterancyRank = 0,
			}
			if World_GetGameTime() > (20 * 60) then
				raidData.isHeavy = true
				raidData.veterancyRank = g_difficulty
			end
		if g_currentStatus == STATUS_GERMAN_ADVANTAGE then
			g_sovietUrgent = false
			if VPTicker_GetTeamTickers(Soviets.team) < 100 then
				raidData.isHeavy = true
				numUnits = t_difficulty.numVeryMany
				g_sovietUrgent = true
				raidData.veterancyRank = g_difficulty + 1
			elseif VPTicker_GetTeamTickers(Soviets.team) < 250 then
				raidData.isHeavy = true
				numUnits = t_difficulty.numMany
				raidData.veterancyRank = g_difficulty
			end
			LaunchSovietRaid(raidData)
		elseif g_currentStatus == STATUS_GERMAN_CONTROL then
			raidData.isHeavy = true
			raidData.baseIsValid = false
			raidData.isNeutral = false
			raidData.numUnits = t_difficulty.numVeryMany
			raidData.veterancyRank = g_difficulty + 1
			LaunchSovietRaid(raidData)
		end
	else
		g_sovietUrgent = true
	end
end



function LaunchSovietRaid(data) -- player, isHeavy, numUnits, isNeutral, baseIsValid
	data.player = data.player or player4
	data.isHeavy = data.isHeavy or false
	data.numUnits = data.numUnits or 3
	data.isNeutral = data.isNeutral or false
	data.baseIsValid = data.baseIsValid or false
	g_RaidNumber = g_RaidNumber + 1
	local encData = {
		name = "Raid "..tostring(g_RaidNumber),
		spawn = EGroup_GetPosition(eg_p4_entry),
		sgroups = {SGroup_CreateIfNotFound("sg_raid_" .. tostring(g_RaidNumber)), sg_raiders,},
		onDeath = nil,
	}
	encData.player = data.player or player4
	encData.units = ChooseRaidUnits(data)
	local marker = ChooseRaidTarget(data)
	local goalData = {
		target = marker,
		range = marker,
		attackMove = true,
	}
	if data.isNeutral then
		goalData.name = "Defend"
		goalData.leashRange = marker
	else
		goalData.name = "Attack"
	end
	t_raids[g_RaidNumber] = Encounter:Create(encData, nil, true)
	t_raids[g_RaidNumber]:SetGoal(goalData)
	_ToWDebugDisplay ("LaunchSovietRaid number " .. tostring(g_RaidNumber), "gold")
	_ToWDebugDisplay ("isHeavy="..tostring(data.isHeavy).." numUnits="..tostring(data.numUnits).." isNeutral="..tostring(data.isNeutral).." baseIsValid"..tostring(data.baseIsValid),"gold")
	_ToWDebugDisplay ("Launching "..goalData.name.." with target ".. Marker_GetName(marker) .. " and units:","white")
	for k,unit in pairs (encData.units) do
		_ToWDebugDisplay(BP_GetName(unit.sbp), "white")
	end
end




function ChooseRaidTarget(data) -- isNeutral, baseIsValid
	local germanTargets = {}
	local neutralTargets = {}
	for k, victorypoint in pairs(VPs) do 
		if (victorypoint.owner) then
			if victorypoint.owner == Germans.team then
				table.insert(germanTargets, victorypoint.marker)
				if victorypoint.group ~= eg_vp1 then
					table.insert(germanTargets, victorypoint.marker)
				end
			end
		else
			table.insert(neutralTargets, victorypoint.marker)
			if victorypoint.group ~= eg_vp1 then
				table.insert(neutralTargets, victorypoint.marker)
			end
		end
	end
	if #neutralTargets < 1 then
		data.isNeutral = false
	end
	if #germanTargets < 1 then
		data.baseIsValid = true
	end
	if data.baseIsValid then
		table.insert(germanTargets, mkr_p1_stagingarea)
		table.insert(germanTargets, mkr_p2_stagingarea)
	end
	if data.isNeutral then
		local index = World_GetRand(1,#neutralTargets)
		return neutralTargets[index]
	else
		local index = World_GetRand(1,#germanTargets)
		return germanTargets[index]
	end
end


function ChooseRaidUnits (data) -- player, isHeavy, numUnits
	local lightUnits = {
		{
			sbp = SBP.SOVIET.CONSCRIPT_SQUAD,
			upgrades = {UPG.SOVIET.CONSCRIPT_ASSAULT_PACKAGE_INGAME,},
			requirement = nil,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.PENAL_BATTALION,
			requirement = EBP.SOVIET.BARRACKS,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.SHOCK_TROOPS,
			requirement = EBP.SOVIET.BARRACKS,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
			requirement = EBP.SOVIET.BARRACKS,
			numSquads = t_difficulty.numVeryFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
			requirement = EBP.SOVIET.WEAPON_SUPPORT_CENTER,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.PM_82_41_MORTAR_SQUAD,
			requirement = EBP.SOVIET.WEAPON_SUPPORT_CENTER,
			numSquads = t_difficulty.numVeryFew,
			veterancyRank = data.veterancyRank,
		},
	}

	local heavyUnits = {
		{
			sbp = SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
			upgrades = {UPG.SOVIET.ENGINEER_FLAMETHROWER,},
			requirement = nil,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.PENAL_BATTALION,
			upgrades = {UPG.SOVIET.PENAL_BATTALION_FLAMETHROWER_PACKAGE,},
			requirement = EBP.SOVIET.BARRACKS,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.GUARDS_TROOPS,
			requirement = EBP.SOVIET.BARRACKS,
			numSquads = t_difficulty.numFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
			requirement = EBP.SOVIET.WEAPON_SUPPORT_CENTER,
			numSquads = t_difficulty.numVeryFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.T_70M,
			requirement = EBP.SOVIET.MOTORPOOL,
			numSquads = t_difficulty.numVeryFew,
			veterancyRank = data.veterancyRank,
		},
		{
			sbp = SBP.SOVIET.T_34_76_SQUAD,
			requirement = EBP.SOVIET.MOTORPOOL,
			numSquads = t_difficulty.numVeryFew,
			veterancyRank = data.veterancyRank,
		},
	}
	
	local unitList = lightUnits
	if data.isHeavy then
		unitList = heavyUnits
	end

	for i=#unitList,1,-1 do
		local unit = unitList[i]
		if (unit.requirement) then
			Player_GetAll(data.player)
			EGroup_Filter(eg_allentities, unit.requirement, FILTER_KEEP)
			if EGroup_Count(eg_allentities) < 1 then
				table.remove(unitList, i)
			end
		end
	end
	
	local units = {}
	
	for i=1,data.numUnits do
		local rand = World_GetRand(1,#unitList)
		table.insert(units, unitList[rand])
	end
	
	return units
end

--------------------------------------------------
-- ACHIEVEMENT FUNCTIONS
--------------------------------------------------


function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
	if not AI_IsEnabled(player2) then
		Scar_CompleteIntelBulletinTask(player2, data.id)
	end
end

function SetupAchievements()
	g_redDeadKillCount = 0
	Rule_AddGlobalEvent(RedDeadCount, GE_SquadKilled )
end


function RedDeadCount (squad)
	if Squad_GetBlueprint(squad) == SBP.SOVIET.SHOCK_TROOPS or Squad_GetBlueprint(squad) == SBP.SOVIET.PENAL_BATTALION then
		g_redDeadKillCount = g_redDeadKillCount + 1
		_ToWDebugDisplay("RedDeadCount is now " .. g_redDeadKillCount)
		if g_redDeadKillCount >= 20 then
			Achieve ("tow_faceoff_at_rostov_red_dead")
			Rule_RemoveMe()
		end
	end
end

function VPVictoryMessage()
	if g_neverSovietAdvantage then
		Achieve ("tow_faceoff_at_rostov_uncompromising")
	end

	if (EVENTS) and (EVENTS.VPVictoryMessage) then
		-- if only player 1 is human, then we can do a camera move
		if not (Player_IsHuman (World_GetPlayerAt(1)) and Player_IsHuman (World_GetPlayerAt(2))) then
			Game_SetMode(UI_Cinematic)
			sg_temp_ = SGroup_CreateIfNotFound("sg_temp")
			SGroup_Clear(sg_temp)
			sg_temp = Player_GetSquadConcentration(World_GetPlayerAt(1))
			Camera_MoveTo(sg_temp, true, 0.05)
		end
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
end





