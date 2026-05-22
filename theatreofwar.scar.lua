--
--
-- Utility functions specific to the Theatre of War mode in CoH2
-- Designer: NJR
--
--

--
-- NOTE: This file is NOT included by default, you need to include it in ToW mission scripts
--

--? @group scardoc;TheatreOfWar


--=====================================================================================================--
--=================================	     GAME SETUP FUNCTIONS	  	===================================--
--=====================================================================================================--


--? @args PlayerID player, Int year
--? @shortdesc Restricts a given player's tech tree to just the units that were available in a specific year.
--? @extdesc You need to add import("TheatreOfWar.scar") to your mission script to use this - it isn't imported by default
function ToW_SetUpTechTreeByYear(player, year)

	-- 
	-- 1. General locking out all of the regular units that don't apply to this year
	--
	
	local all_items = {
		
		--
		-- Items can have any of these keys:
		--    sbp = SBP.???			Squad Blueprints		
		--    ebp = EBP.???			Entity Blueprints
		--    upg = UPG.???			Upgrades 
		--    abil = ABILITY.???	Abilities (any kind: player, squad, etc)
		--
		
		-- Soviet tech tree
		{sbp = SBP.SOVIET.M1937_152MM_ML_20_ARTILLERY,			available_from = 1937,	available_until = nil},
		{sbp = SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,			available_from = 1937,	available_until = nil},
		{sbp = SBP.SOVIET.KV_1,									available_from = 1939,	available_until = nil},
		{sbp = SBP.SOVIET.KATYUSHA_BM_13N_SQUAD,				available_from = 1939,	available_until = nil},
		{sbp = SBP.SOVIET.T_34_76_SQUAD,						available_from = 1940,	available_until = nil},
		{sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,					available_from = 1941,	available_until = nil},
		{sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,		available_from = 1941,	available_until = nil},
		{sbp = SBP.SOVIET.T_70M,								available_from = 1941,	available_until = nil},		-- Technically 1942, but we're adding it to the 1941 tech tree for now
		{sbp = SBP.SOVIET.KV_8,									available_from = 1942,	available_until = nil},
		{sbp = SBP.SOVIET.M5_HALFTRACK_SQUAD,					available_from = 1942,	available_until = nil},
		{sbp = SBP.SOVIET.SU_76M,								available_from = 1943,	available_until = nil},
		{sbp = SBP.SOVIET.SU_85,								available_from = 1943,	available_until = nil},
		{sbp = SBP.SOVIET.ISU_152,								available_from = 1943,	available_until = nil},
		{sbp = SBP.SOVIET.IS_2,									available_from = 1943,	available_until = nil},
		{sbp = SBP.SOVIET.T_34_85_SQUAD,						available_from = 1944,	available_until = nil},
		
		-- German tech tree
		{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,					available_from = 1935,	available_until = nil},
		{sbp = SBP.GERMAN.PANZER_IV_SQUAD,						available_from = 1939,	available_until = nil},
		{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,			available_from = 1939,	available_until = nil},		
		{sbp = SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY,		available_from = 1939,	available_until = nil},
		{sbp = SBP.GERMAN.STUG_III_E_SQUAD,						available_from = 1941,	available_until = nil},
		{sbp = SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,			available_from = 1941,	available_until = nil},
		{sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,				available_from = 1941,	available_until = nil},		-- Technically 1942, but saw service in limited numbers at the end of 1941
		{sbp = SBP.GERMAN.STUG_III_SQUAD,						available_from = 1942,	available_until = nil},
		{sbp = SBP.GERMAN.TIGER_SQUAD,							available_from = 1942,	available_until = nil},
		{sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,				available_from = 1942,	available_until = nil},
		{sbp = SBP.GERMAN.BRUMMBAR_SQUAD,						available_from = 1943,	available_until = nil},
		{sbp = SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD,			available_from = 1943,	available_until = nil},
		{sbp = SBP.GERMAN.PANTHER_SQUAD,						available_from = 1943,	available_until = nil},
		{sbp = SBP.GERMAN.PANZERWERFER_SQUAD,					available_from = 1943,	available_until = nil},
		{sbp = SBP.GERMAN.OSTWIND_SQUAD,						available_from = 1944,	available_until = nil},
		{ebp = EBP.GERMAN.SCHWERES_KRIEGSWERK,					available_from = 1942,	available_until = nil},
		
		{upg = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, 			available_from = 1943,	available_until = nil},
		{upg = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, 	available_from = 1943,	available_until = nil},
		{abil = ABILITY.GERMAN.GRENADIER_PANZERFAUST,						available_from = 1942,	available_until = nil},
	}

	-- go through each item
	for k, item in pairs(all_items) do 
		
		-- fill in blank from / until values
		if item.available_from == nil then
			item.available_from = 0000
		end
		if item.available_until == nil then
			item.available_until = 9999
		end
		
		-- if the ToW mode's given year is OUTSIDE the item's range, remove it
		if year < item.available_from or year > item.available_until then
			
			-- if it's an SBP...
			if item.sbp ~= nil then
				Player_SetSquadProductionAvailability(player, item.sbp, ITEM_REMOVED)
			end
			
			-- if it's an EBP...
			if item.ebp ~= nil then
				Player_SetEntityProductionAvailability(player, item.ebp, ITEM_REMOVED)
			end
			
			-- if it's an UPGRADE...
			if item.upg ~= nil then
				Player_SetUpgradeAvailability(player, item.upg, ITEM_REMOVED)
			end
			
			-- if it's an ABILITY...
			if item.abil ~= nil then
				Player_SetAbilityAvailability(player, item.abil, ITEM_REMOVED)
			end
		end
	end

	--
	-- 2. Year-specific fixes, in case things were a bit too unbalanced
	--
	
	if year == 1941 then
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("theatre_of_war_1941"))
		if Player_GetRaceName(player) == "soviet" then
			--  * Enable the Soviet KV1
			Player_CompleteUpgrade(player, UPG.SOVIET.KV_1_UNLOCK_DEMO)
		elseif Player_GetRaceName(player) == "german" then
			--  * Enable the Stug E variant
			Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("stug_iii_e_unlock"))
			--  * Give Panzer Grenadiers MP-40s instead of MP-44s
			Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("panzer_grenadier_mp40"))
			-- * If the German player is human, shorten the timer on SP PG grenades
			if Player_IsHuman(player) then
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("pg_grenade_short_timer"))		
			end
		end
	end

	if year == 1942 then
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("theatre_of_war_1942"))
		if Player_GetRaceName(player) == "soviet" then
			--  * Enable the Soviet KV1
			Player_CompleteUpgrade(player, UPG.SOVIET.KV_1_UNLOCK_DEMO)
		elseif Player_GetRaceName(player) == "german" then
			--  * Give Panzer Grenadiers MP-40s instead of MP-44s
			Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("panzer_grenadier_mp40"))
			-- * If the German player is human, shorten the timer on SP PG grenades
			if Player_IsHuman(player) then
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("pg_grenade_short_timer"))		
			end
		end
	end
	
	if year == 1943 then
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("theatre_of_war_1943"))
		if Player_GetRaceName(player) == "soviet" then
			--  * Enable the Soviet KV1
			Player_CompleteUpgrade(player, UPG.SOVIET.KV_1_UNLOCK_DEMO)
		elseif Player_GetRaceName(player) == "german" then
			--  * Give Panzer Grenadiers MP-40s instead of MP-44s
			Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("panzer_grenadier_mp40"))
			-- * If the German player is human, shorten the timer on SP PG grenades
			if Player_IsHuman(player) then
				Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("pg_grenade_short_timer"))		
			end
		end
	end
	
	
end

--? @args PlayerID player[, Table overrideData]
--? @shortdesc Set a player to have standard starting resources, or use optional override data.
--? @extdesc You need to add import("TheatreOfWar.scar") to your mission script to use this - it isn't imported by default

function ToW_SetStandardResources (player, overrideData)

	local SovietData = {
		manpower 	=	250,
		munitions 	=	0,
		fuel 		=	50,
		action 		= 	0,
		command 	=	0,
	}
	
	local GermanData = {
		manpower 	=	290,
		munitions 	=	0,
		fuel 		=	20,
		action 		= 	0,
		command 	=	0,
	}
	
	if Player_GetRaceName(player) == "soviet" then
		if overrideData == nil then
			overrideData = SovietData
		else
			overrideData.manpower 	= overrideData.manpower 	or SovietData.manpower 	
			overrideData.munitions 	= overrideData.munitions 	or SovietData.munitions 	
			overrideData.fuel 		= overrideData.fuel 		or SovietData.fuel 		
			overrideData.action 	= overrideData.action 		or SovietData.action 	
			overrideData.command 	= overrideData.command 		or SovietData.command 	
		end
	elseif Player_GetRaceName(player) == "german" then
		if overrideData == nil then
			overrideData = GermanData
		else
			overrideData.manpower 	= overrideData.manpower 	or GermanData.manpower 	
			overrideData.munitions 	= overrideData.munitions 	or GermanData.munitions 	
			overrideData.fuel 		= overrideData.fuel 		or GermanData.fuel 		
			overrideData.action 	= overrideData.action 		or GermanData.action 	
			overrideData.command 	= overrideData.command 		or GermanData.command 	
		end
	end	

	Player_ResetResource(player, RT_Manpower)
	Player_ResetResource(player, RT_Munition)
	Player_ResetResource(player, RT_Fuel)
	Player_ResetResource(player, RT_Action)
	Player_ResetResource(player, RT_Command)
	
	if overrideData ~= nil then
		Player_AddResource(player, RT_Manpower, overrideData.manpower 	)
		Player_AddResource(player, RT_Munition, overrideData.munitions 	)
		Player_AddResource(player, RT_Fuel, 	overrideData.fuel 		)
		Player_AddResource(player, RT_Action, 	overrideData.action 	)
		Player_AddResource(player, RT_Command, 	overrideData.command 	)
	end

end

--=====================================================================================================--
--=================================	     DEFENSE MISSION FUNCTIONS	  =================================--
--=====================================================================================================--

--[[
 -- EXAMPLE DATA FOR DEFENSE MISSIONS

	t_defData = {
		waves = {},
		spawnMarkers = {
			{
				mkr = mkr_enemy_spawn_01,
				obj = mkr_target_right,   --- this is a preliminary target location
			},
			{
				mkr = mkr_enemy_spawn_02,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn_03,
				obj = mkr_target_center,
			},
			{
				mkr = mkr_enemy_spawn_04,
				obj = mkr_target_left,
			},
		},
		target = mkr_enemy_attack_dest,
		playerSpawn = mkr_player_pioneer_01,
		objectives = {
			gold = OBJ_Gold,
			silver = OBJ_Silver,
			bronze = OBJ_Bronze,
		},
	}
	
	-- wave one -- conscript rush
	t_defData.waves[1] = { 
		units = {
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsMany,
				upgrades = {UPG.SOVIET.BASE_CONSCRIPT_MOLOTOV_UNLOCK,},
			},
			{
				sbp = SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS,
				numSquads = t_difficulty.squadsMany,
				upgrades = {UPG.SOVIET.BASE_CONSCRIPT_MOLOTOV_UNLOCK,},
				delay = 1,
			},
			{
				sbp = SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
				numSquads = t_difficulty.squadsMany,
				delay = 5,
				upgrades = {UPG.SOVIET.BASE_CONSCRIPT_MOLOTOV_UNLOCK,},
			},
			{
				sbp = SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS,
				numSquads = t_difficulty.squadsMany,
				delay = 6,
				upgrades = {UPG.SOVIET.BASE_CONSCRIPT_MOLOTOV_UNLOCK,},
			},
		},
		abilityBlacklist = nil,
		startAbilities = {						--- globals triggered at wave start; unique to wave logic
			ABILITY.SOVIET.IL_2_SUPPORT,
		},
		fallbackParams = {
			thresholds = {0.75},
			thresholdType = Threshold_PercentageEntitiesRemaining,
			retreat = true,
			retreatOnSuppression = true,
		},
		rewards = {
			resources = {
				{
					type = RT_Action,
					amount = t_difficulty.awardAction,
				},
			},
		},
	}


	]]--


--? @args Integer waveNumber
--? @shortdesc Starts an enemy wave in a ToW mission set up with proper data. See TheatreOfWar.scar for example data.
--? @extdesc You need to add import("TheatreOfWar.scar") to your mission script to use this - it isn't imported by default
function ToW_DefenseCreateWave (data)
	
	-- if I don't get data, then set up data as 1
	if data == nil then
		data = { index = 1 }
	end

	-- if I get a number (the normal behavior) set it up in a table
	-- (This is set up this way so that it can be called with an Event_Timer)
	if scartype(data)==ST_NUMBER then
		data = { index = data }
	end

	local index = data.index
	local wave = t_defData.waves[index] or {}
	wave.totalUnits = 0
	
	wave.sgroup = SGroup_CreateIfNotFound("sg_wave_" .. tostring(index))
	
	-- if this is calling the first wave, we run an init to check and set up some data
	if index == 1 then
		_DefenseInit()
	end
	
	-- get a random position so that spawn locations are randomized
	local n = World_GetRand(1,#t_defData.spawnMarkers)
	
	-- if the wave has abilities set up, we fire those off
	-- use this to start with a straffing run or something
	if (wave.startAbilities) then
		for k, ability in pairs (wave.startAbilities) do
			if not Player_HasAbility(player2, ability) then
				Player_AddAbility(player2, ability)
			end
			Cmd_Ability (player2, ability, t_defData.target, t_defData.target, true, true)
		end
	end

	-- now we set up the basic encounter data we'll use for the wave
	local encData = {
		name = "wave " .. index,
		sgroups = {wave.sgroup,},
		player = player2,
		spawn = t_defData.spawnMarkers[n].mkr, 
		units = {},
	}
		
	local delayedUnits = {}
	local immediateUnits = {}

	-- now we look at the units to see if they need to be delayed or are vehicles
	-- in either case we'll put them in a separate encounter
	for k,unit in pairs (wave.units) do
		if not (unit.numSquads) then
			wave.totalUnits = wave.totalUnits + 1
		else
			wave.totalUnits = wave.totalUnits + unit.numSquads
		end

		local needsPhase = false
		
		if not (unit.delay) then
			unit.delay = 0
		end
		
		if not (unit.isTank) then
			unit.isTank = false
		end

		if (unit.delay) and (unit.delay > 0) then
			-- we need a seperate phase if there is a delay greater than 0
			needsPhase = true
		elseif (unit.isTank == true) then
			-- we also need one if the unit is a tank
			needsPhase = true
		end
			
		if (needsPhase) then
			local makeNewPhase = true
			for i,phase in pairs (delayedUnits) do
				-- if we already have a phase set up with the same delay/tank then we'll just add them
				if (phase.delay == unit.delay) and (phase.isTank == unit.isTank) then
					table.insert (phase, Clone(unit))
					makeNewPhase = false
				end
			end
			
			-- if we don't have a phase already, we set one up and populate it
			if (makeNewPhase) then
				local newPhase = { delay = unit.delay, isTank = unit.isTank }
				table.insert (newPhase, Clone(unit))
				table.insert (delayedUnits, newPhase)
			end
		else
			table.insert (immediateUnits, Clone(unit))
		end
	end
	
	-- we shuffle the start locations for the immediate units
	_SetSpawnMarkers (immediateUnits)
	
	-- we add them as the units data of the base encounter
	encData.units = immediateUnits
	
	-- set up the basic attack goal
	local goalData = {
		name = "Attack",
		target = t_defData.target,
		useSkirmishAI = true,
		attackMove = true,
		fallback = false,
		abilityBlacklist = wave.abilityBlacklist or nil,
		leashRange = wave.leashRange or nil,
		onFailure = _DespawnMe,
		movePathLengthFactor = wave.movePathLengthFactor or 1.0,
		tacticControlsList = wave.tacticsControlsList or nil,
		coordinatedSetup = wave.coordinatedSetup or false,
	}
	
	if scartype (t_defData.target) == ST_MARKER then
		if Marker_GetProximityRadius(t_defData.target) > 0 then
			goalData.range = t_defData.target
		end
	elseif scartype (t_defData.target) == ST_EGROUP then
		if EGroup_IsEmpty(t_defData.target) then
			return
		end
	elseif scartype (t_defData.target) == ST_SGROUP then
		if SGroup_IsEmpty(t_defData.target) then
			return
		end
	elseif scartype (t_defData.target) == ST_SQUAD then
		if Squad_IsValid(Squad_GetGameID(t_defData.target)) == false then
			return
		end
	elseif scartype (t_defData.target) == ST_ENTITY then
		if Entity_IsValid(Entity_GetGameID(t_defData.target)) == false then 
			return
		end
	end
			
	-- if we get fallback data, we set that up
	if (wave.fallbackParams) then
		goalData.fallback = true
		goalData.fallbackParams = wave.fallbackParams
		if goalData.fallbackParams.markers == nil then
			goalData.fallbackParams.markers = { t_defData.spawnMarkers[n].mkr }
		end
	end
	
	-- if we have any immediate units, we trigger that encounter and goal
	if #immediateUnits > 0 then
		t_waves[index] = Encounter:Create(encData, nil, true)
		t_waves[index]:SetGoal(goalData)
		local unitList = t_waves[index].units
		local delay = #unitList * t_defData.staggeredSpawnDelay
		Event_Timer(_CreateDecrementCheck, {units = unitList}, delay)
	end
	
	-- now we iterate through the table of delayed phases we created
	for k,phase in pairs (delayedUnits) do
		-- we clone encounter data and units
		local encData2 = Clone (encData)
		local units = Clone (phase)
		units.delay = nil
		units.isTank = nil
		-- we shuffle the phases spawn markers and remember the index we get back
		local ind = _SetSpawnMarkers (units)
		encData2.spawn = t_defData.spawnMarkers[ind].mkr
		encData2.units = units
		local refName = "delay" .. phase.delay
		-- we clone the goal data
		local goalData2 = Clone (goalData)
		if (goalData2.fallbackParams) then
			goalData2.fallbackParams.markers = { t_defData.spawnMarkers[ind].mkr }
		end
		
		-- if this is a tank phase, we give it a prelimary target to attack and clear, before going for the final goal
		-- infantry goes straight to the final goal
		-- this is to prevent vehicles from rushing in full tilt
		if phase.isTank == true then
			local prelimTarget = t_defData.spawnMarkers[ind].obj
			goalData2.target = prelimTarget
			goalData2.leashRange = prelimTarget
			goalData2.onSuccess = _NextTankGoal
		end
		
		-- we build some data for this phase
		local cbdata = 
		{
			index = index,
			refName = refName,
			encData = encData2,
			goalData = goalData2,
			phaseDelay = phase.delay, 
			
		}
		
		-- we pass that into a delayed event to spawn the phase
		Event_Timer (_CreateWave_Callback, cbdata, phase.delay)
	end
	
	-- we announce the wave to the player and log it 
	local waveTitle = Loc_FormatText(11035533, Loc_ConvertNumber( index )) -- LOCDB [11035533] 'Wave %1WAVE%'
	Util_MissionTitle(waveTitle) -- LOCDB [11035533] 'Wave %1WAVE%'
	_ToWDebugDisplay("Wave " .. index .. " at " .. Marker_GetName(encData.spawn)) 
	
	Obj_ShowProgress2 (waveTitle, 1)
	wave.remainingUnits = wave.totalUnits
end


function _CreateDecrementCheck (data)
	for k,unit in pairs (data.units) do
		Event_GroupIsDead(_DecrementProgressBar, nil, unit.sgroup)
	end
end

function _DecrementProgressBar(data)
	local wave = t_defData.waves[t_defData.currentWave]
	if not (wave.remainingUnits) then
		wave.remainingUnits = 1
	end
	wave.remainingUnits = wave.remainingUnits - 1
	if wave.remainingUnits <= 0 then
		Obj_HideProgress()
		_NextWave()
	else
		local waveTitle = Loc_FormatText(11035533, Loc_ConvertNumber( t_defData.currentWave )) -- LOCDB [11035533] 'Wave %1WAVE%'
		Obj_ShowProgress2 (waveTitle, wave.remainingUnits/wave.totalUnits )
	end
end

-- helper function to check we have the correct data, and create some support tables
function _DefenseInit ()
	if not (t_defData) then
		fatal ("t_defData has not been defined.")
	end
	
	-- clear any ToW debug that might be lingering
	_ToWDebugClear()
	t_ToWDebugText = {}
	
	-- create the table that will later hold the wave encounters, one sub-table for each wave
	t_waves = {}
	for i=1,#t_defData.waves do
		table.insert(t_waves, {})
	end
	
	-- makes sure we have goals defined for our objectives
	if (t_defData.objectives.gold) then
		t_defData.objectives.gold.Goal = t_defData.objectives.gold.Goal or #wavesData
	end
	if (t_defData.objectives.silver) then
		t_defData.objectives.silver.Goal = t_defData.objectives.silver.Goal or math.ceil(#wavesData * 0.75)
	end
	if (t_defData.objectives.bronze) then
		t_defData.objectives.bronze.Goal = t_defData.objectives.bronze.Goal or math.ceil(#wavesData * 0.5)
	end
	
	t_defData.currentWave = 1
	
	-- set a staggered spawn delay if we get that or use a default of 3 seconds
	t_defData.staggeredSpawnDelay = t_defData.staggeredSpawnDelay or 3
	AI_SetStaggeredSpawnDelay(t_defData.staggeredSpawnDelay)
end

-- callback function triggered for delayed forces
function _CreateWave_Callback(data)
	t_waves[data.index][data.refName] = Encounter:Create(data.encData, nil, true)
	t_waves[data.index][data.refName]:SetGoal(data.goalData)
	local unitList = t_waves[data.index][data.refName].units
	local delay = #unitList * t_defData.staggeredSpawnDelay
	Event_Timer(_CreateDecrementCheck, {units = unitList}, delay)
	_ToWDebugDisplay("Wave " .. data.index .. " flank with delay " .. data.phaseDelay .. " at " .. Marker_GetName(data.encData.spawn))	
end

-- helper function that sets a vehicle's goal to a basic attack once it clears its first area
function _NextTankGoal(enc)
	local goalData = {
		name = "Attack",
		target = t_defData.target,
		useSkirmishAI = true,
		attackMove = true,
		fallback = false,
		onFailure = _DespawnMe,
	}
	enc:SetGoal(goalData)
end

-- Next wave logic that triggers after the counter decrements to 0
function _NextWave()
	local wave = t_defData.waves[t_defData.currentWave]
	
	-- announce that the wave is over and log
	Util_MissionTitle(Loc_FormatText(11035534, Loc_ConvertNumber(t_defData.currentWave))) -- LOCDB [11035534] 'Wave %1WAVE% Complete!'
	_ToWDebugDisplay("Wave " .. t_defData.currentWave .. " defeated at " .. tostring(World_GetGameTime()))	
	
	-- rewards at the end of the wave
	local data = t_defData.waves[t_defData.currentWave]
	
	if data.rewards ~= nil then
		local resources = data.rewards.resources or {}
		local reinforcements = data.rewards.reinforcements or {}
		
		-- award resources if appropriate
		for k,v in pairs (resources) do
			Player_AddResource(player1, v.type, v.amount)
		end
	
		-- award reinforcements if appropriate
		for k,v in pairs (reinforcements) do
			Util_CreateSquads(player1, "sg_player_starting_units", v.sbp, t_defData.playerSpawn, t_defData.target, v.numSquads, v.loadout, false, nil, v.upgrades, nil)
		end
	end
	
	-- run any onWaveComplete functions
	if (data.onWaveComplete) then
		if scartype (data.onWaveComplete) == ST_FUNCTION then
			_ToWDebugDisplay ("Running onWaveComplete for wave " .. t_defData.currentWave, "gold")
			data.onWaveComplete()
		end
	end
	
	-- update objectives
	local obj = nil
	local goal = 0
	
	-- find the active objective (either gold, silver, or bronze)
	if (t_defData.objectives.gold) and Objective_IsStarted(t_defData.objectives.gold) then
		obj = t_defData.objectives.gold
		goal = t_defData.objectives.gold.Goal
	elseif (t_defData.objectives.silver) and Objective_IsStarted (t_defData.objectives.silver) then
		obj = t_defData.objectives.silver
		goal = t_defData.objectives.silver.Goal
	elseif (t_defData.objectives.bronze) and Objective_IsStarted (t_defData.objectives.bronze) then
		obj = t_defData.objectives.bronze
		goal = t_defData.objectives.bronze.Goal
	end
	
	-- update the counter and (if appropriate) complete the objective
	if (obj) then
		Objective_SetCounter (obj, t_defData.currentWave, goal)
		if t_defData.currentWave >= goal then
			Objective_Complete(obj)
		end
	end
	
	-- increments the wave number
	t_defData.currentWave = t_defData.currentWave + 1

	-- calculate the delay until the next wave
	-- this uses a default of 10 seconds, or data provided in the difficulty tables of the mission
	local delay = t_difficulty.baseWaveDelay or 10
	local delayDecrement = t_difficulty.waveDelayReduction or 0
	delay = delay - ((t_defData.currentWave - 2) * delayDecrement)
	if delay < 1 then
		delay = 0
	end
	
	-- set up the timer to trigger the next wave if there is one
	if t_defData.waves[t_defData.currentWave] ~= nil then
		Event_Timer(ToW_DefenseCreateWave, {index = t_defData.currentWave}, delay)
	end
end

-- helper function that despawns an encounter if it fails its goal (usually by falling back)
function _DespawnMe(enc)
	SGroup_DestroyAllSquads(enc.sgroup)
end

-- function that randomly offsets spawn positions within a phase
function _SetSpawnMarkers (unitList)
	local maxpos = #t_defData.spawnMarkers
	local ind = World_GetRand(1, maxpos)
	for k,unit in pairs (unitList) do
		if (unit.pos) then
			while unit.pos > maxpos do
				unit.pos = unit.pos - maxpos
			end
			local n = ind - 1 + unit.pos
			if n > maxpos then
				n = n - maxpos
			elseif n < 0 then
				n = n + maxpos
			end
			if n ~= 1 then
				unit.spawn = t_defData.spawnMarkers[n].mkr
			end
			unit.pos = nil
		end
	end
	return ind
end

--=====================================================================================================--
--===================================	     DEBUG TEXT FUNCTIONS	  =================================--
--=====================================================================================================--

-- debug print function that prints to log and (if -debug is set) to screen
function _ToWDebugDisplay (text, color, index)

	text = tostring(World_GetGameTime()) .. " " .. text
	print ("THEATRE OF WAR: " .. text)
	
	if g_debug ~= true then
		return
	end
	
	if not (t_ToWDebugText) then
		t_ToWDebugText = {}
		_ToWDebugClear()
	elseif #t_ToWDebugText > 35 then
		_ToWDebugClear()
		t_ToWDebugText = {}
		index = 1
	end
	
	local GOLDENROD = 	{ r = 255, 	g = 193, 	b = 37,}
	local CYAN = 			{ r = 0, 	g = 238, 	b = 238,}
	local WHITE = 		{ r = 213, 	g = 213, 	b = 213,}
	color = color or CYAN
	
	if scartype(color) == ST_STRING then
		if color == "gold" then
			color = GOLDENROD
		elseif color == "cyan" or color == "blue" then
			color = CYAN
		else
			color = WHITE
		end
	elseif scartype(color) == ST_TABLE then
		if (color.r) and (color.g) and (color.b) then
			
		else
			color = WHITE
		end
	end
	
	local pos = 0.185
	if (index) then
		t_ToWDebugText[index] = text
	else
		table.insert(t_ToWDebugText, text)
		index = #t_ToWDebugText
	end
	pos = pos + (index * 0.015)
	
	local name = "debug"..pos
	
	dr_clear (name)
	dr_setautoclear(name, 0)
	dr_text2d(name, 0.70, pos, text, color.r, color.g, color.b) 
end

function _ToWDebugClear()
	for i = 1,99 do
		local pos = ( i * 0.015) + 0.185
		local name = "debug"..pos
		dr_clear (name)
	end
end

--=====================================================================================================--
--===================================	     OBJECTIVE FUNCTIONS	  =================================--
--=====================================================================================================--

--? @shortdesc Sets up a default mission objective for Victory Point battles.
--? @extdesc You need to add import("TheatreOfWar.scar") to your mission script to use this - it isn't imported by default
function ToW_SetUpBattleObjectives ()

	OBJ_Main = {
		SetupUI = function() 
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		IsComplete = function()
			return false
		end,
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11046899,				-- LOCDB [11046899] 'Capture and hold Victory Points to win the match.'
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	Objective_Register(OBJ_Main)
	Event_Timer (_StartObjective, {obj=OBJ_Main}, 1)
end

function _StartObjective (data)
	Objective_Start(data.obj)
end


--=====================================================================================================--
--===================================	     VICTORY FUNCTIONS	  =================================--
--=====================================================================================================--

-- this is a function the VP logic looks for to call at the end of the game. It is defined here for all Theater of War games.
function VPVictoryMessage()
	-- only if the mission has an EVENTS table and a EVENTS.VPVictoryMessage event will any of this trigger
	if (EVENTS) and (EVENTS.VPVictoryMessage) then
		-- if only player 1 is human, then we can do a camera move
		if not (Player_IsHuman (World_GetPlayerAt(1)) and Player_IsHuman (World_GetPlayerAt(2))) then
			Game_SetMode(UI_Cinematic)
			sg_temp = SGroup_CreateIfNotFound("sg_temp")
			SGroup_Clear(sg_temp)
			sg_temp = Player_GetSquadConcentration(World_GetPlayerAt(1))
			-- check to make sure that there is a valid group to move to
			if scartype(sg_temp) == ST_SGROUP and SGroup_CountSpawned(sg_temp) >= 1 then 
				Camera_MoveTo(sg_temp, true, 0.05, nil, true)
			end
		end
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
end


