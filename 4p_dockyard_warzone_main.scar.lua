function Map_OnInit()
	SCENARIO_SOUNDS = {
		CRANE_ENGINE = "vehicles/su_85_tank/su_85_tank_engine.bsc",
		CRANE_MOVE_START_STOP = "vehicles/ostwind_flak_panzer/ostwind_turret_stop.bsc",
		GENERATOR_ENGINE = "foley/constuction/construction_generator_idle_loop.bsc",
		-- Sound has to be looping; otherwise it fades out between manual updates
		-- Many other sound effects were tried; only even remotely fitting one is the generator sound
		-- The game doesn't seem to have looping variants of engine sounds; all engine sounds have
		-- fades / engine start sounds
		BARGE_ENGINE = "foley/constuction/construction_generator_idle_loop.bsc",
		ALARM = "campaign/alarm_klaxon.bsc",
		ALERT_BEING_CRUSHED = "ui/in_game/event_cues/event_squad_cold.bsc",
		BLUB_BLUB_BLUB = "vehicles/vehicle_surface_loops/tank_submerge_bubbles.bsc",
		PANIC_CROWD = "campaign/m02_panic_crowd.bsc",
		RETREAT = "speech/sp/mission/m01/ambient/grenadier_retreat.bsc",
	}
	for _, sound_path in pairs(SCENARIO_SOUNDS) do
		Sound_PreCacheSound(sound_path)
	end
	
	Map_InitCranes()
	Map_InitRepairStations()
	Map_InitFloodlights()
	Map_InitBarges()
	-- Rule_AddInterval(__PlaySound, 0.5)
end

-- Debug code for listening sounds 
--[[
 _g_debug_sound_player = {
 	path = "",
 	handle = nil,
	preached = false,
	changed = false,
 }
 
 function __PlaySound()
 	local soundPath = loadfile("playsound.scar")()
 	if soundPath ~= _g_debug_sound_player.path then
 		_g_debug_sound_player.path = soundPath
 		_g_debug_sound_player.changed = true
		_g_debug_sound_player.preached = false
 	end
 	if (soundPath == "" or _g_debug_sound_player.changed) and _g_debug_sound_player.handle then
 		Sound_Stop(_g_debug_sound_player.handle)
 	end
 
 	if _g_debug_sound_player.path ~= "" then
		if not _g_debug_sound_player.preached then
			Sound_PreCacheSound(_g_debug_sound_player.path)
			_g_debug_sound_player.preached = true
			return
		elseif _g_debug_sound_player.changed then
			_g_debug_sound_player.handle = Sound_Play2D(_g_debug_sound_player.path)
			_g_debug_sound_player.changed = false
		end
 	end
 end
--]]

function Map_InitCranes()
	-- Logic:
	-- Once any player unit enters the central area of the map, the cranes will start to rotate
	-- until they've reached their final rotation.
	_g_crane_alarm_sound_handle = nil
	_g_cranes = {
		{
			egroup = eg_crane_01,
			start_rotation = 5,
			target_rotation = 140,
			start_position = Marker_GetPosition(mkr_crane_01_start),
		},
		{
			egroup = eg_crane_02,
			start_rotation = 135,
			target_rotation = 270,
			start_position = Marker_GetPosition(mkr_crane_02_start),
		},
	}
	-- Global entities that shouldn't be crushed by the cranes (mainly railroad tracks)
	_g_crane_non_crushable_entity_blueprints = {
		BP_GetEntityBlueprint("track_01"),
		BP_GetEntityBlueprint("track_02"),
		BP_GetEntityBlueprint("track_03"),
	}

	for crane_index, crane in ipairs(_g_cranes) do
		local entity = EGroup_GetSpawnedEntityAt(crane.egroup, 1)
		crane.entity = entity
		crane.active = true
		-- Destination is where the crane is visually on the map (WorldBuilder)
		crane.target_position = Entity_GetPosition(entity)
		-- Move to transition start position
		Entity_SetPosition(entity, crane.start_position)
		crane.current_position = Entity_GetPosition(entity)
		crane.current_rotation = crane.start_rotation
		-- Sync rotation to the beginning value
		-- The cranes are positioned in the map as they would appear at the end of the transition
		EGroup_SetAnimatorVariable(crane.egroup, "rotation", crane.current_rotation)
		crane.rotate_per_tick = 0.125 --0.125
		crane.move_per_tick = 0.125 / 4
		-- Partially invulnerable
		EGroup_SetInvulnerable(crane.egroup, 0.1)
		
		crane.sound_name = SCENARIO_SOUNDS.CRANE_ENGINE
		crane.sound_update_ticks_interval = 12 * 8 -- every 12 seconds
		crane.sound_update_ticks = 0
		crane.is_moving = true
		crane.is_rotating = true

		crane.crush_radius = 4
		crane.crush_health_damage_percentage_per_second = 0.225 -- 22.5% damage loss per second
		crane.crush_alert_cooldown_ticks_interval = 1.5 * 8 -- Every 1.5 seconds
		crane.crush_alert_cooldown_ticks = 0
	end

	Rule_AddInterval(Map_CraneTransitionBeginTriggerTick, 1)
end

function Map_InitRepairStations()
	-- Logic:
	-- 1. Point is de-captured and disabled, generator destroyed
	-- 2. Generator gets repaired, point becomes capture-able
	-- 3. Point captured; repairs available
	-- 4. Point de-captured -> Generator becomes neutral
	-- 5. Point captured -> Generator changes ownership to the point owner
	-- 6. Generator gets killed -> point de-captures and becomes disabled
	-- -> 2.

	_g_repair_stations = {
		{
			territory_point = Util_CreateEntityEntry(eg_repair_station_alpha_territory_point),
			generator = Util_CreateEntityEntry(eg_repair_station_alpha_generator),
			sector_id = World_GetTerritorySectorID(EGroup_GetPosition(eg_repair_station_alpha_territory_point)),
			adjacent_territory_point = Util_CreateEntityEntry(eg_repair_station_alpha_adjacent_territory_point),
			exit_marker = mkr_repair_station_alpha_exit,
			is_enabled = true,
		},
		{
			territory_point = {egroup = eg_repair_station_bravo_territory_point, entity = EGroup_GetSpawnedEntityAt(eg_repair_station_bravo_territory_point, 1)}, 
			generator = {egroup = eg_repair_station_bravo_generator, entity = EGroup_GetSpawnedEntityAt(eg_repair_station_bravo_generator, 1)},
			sector_id = World_GetTerritorySectorID(EGroup_GetPosition(eg_repair_station_bravo_territory_point)),
			adjacent_territory_point = Util_CreateEntityEntry(eg_repair_station_bravo_adjacent_territory_point),
			exit_marker = mkr_repair_station_bravo_exit,
			is_enabled = true,
		},
	}

	local team_00_starting_position = nil
	local team_00_player = nil
	local team_01_starting_position = nil
	local team_01_player = nil
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)
		if team == 0 and team_00_starting_position == nil then
			team_00_starting_position = Player_GetStartingPosition(player)
			team_00_player = player
		elseif team == 1 and team_01_starting_position == nil then
			team_01_starting_position = Player_GetStartingPosition(player)
			team_01_player = player
		end
		if team_00_starting_position ~= nil and team_01_starting_position ~= nil then
			break
		end
	end

	-- Resolve repair station team by distance to the team
	for _, repair_station in ipairs(_g_repair_stations) do
		if (
			World_DistanceEGroupToPoint(repair_station.territory_point.egroup, team_00_starting_position, true) < 
			World_DistanceEGroupToPoint(repair_station.territory_point.egroup, team_01_starting_position, true)
		) then
			repair_station.team = 0
			repair_station.player = team_00_player
		else
			repair_station.team = 1
			repair_station.player = team_01_player
		end

		repair_station.ai_engineer_spawn_seconds_interval = 2 * 60 -- 2 * 60
		repair_station.ai_engineer_spawn_seconds = 0
		repair_station.out_of_power_message_seconds_interval = 6
		repair_station.out_of_power_message_seconds = 0
		repair_station.hint_point = HintPoint_Add(
			repair_station.generator.entity, 
			true,
			Util_CreateLocString(""),
			1,
			HPAT_Hint,
			"Icons_abilities_repair"
		)
	end

	Rule_AddInterval(Map_RepairStationGeneratorsTick, 2)
	Map_RepairStationGeneratorsTick()

	-- Modifier system is not available on the first frame of Scar_AddInit
	Rule_AddOneShot(Map_ApplyRepairStationModifiers, 0.125)
	Rule_AddInterval(Map_RepairStationAITask, 1)
end

function Map_InitBarges()
	-- Logic:
	-- Barges will slowly move along the river to the edge of the playable area.
	-- The barges are deleted once they've reached the edge of the map.
	-- A sound effect is played on the barges to pretend like its their engine.
	-- CoH2 Sound_Play3D does not follow the entity. Instead the sound effect
	-- is removed and re-added every n seconds (see the config below).
	_g_barges = {
		{
			egroup = eg_barge_01,
			target_position = Marker_GetPosition(mkr_barge_01_exit),
		},
		{
			egroup = eg_barge_02,
			target_position = Marker_GetPosition(mkr_barge_02_exit),
		},
	}

	for barge_index, barge in ipairs(_g_barges) do
		barge.entity = EGroup_GetSpawnedEntityAt(barge.egroup, 1)
		barge.entity_id = Entity_GetGameID(barge.entity)
		barge.sound_name = SCENARIO_SOUNDS.BARGE_ENGINE
		barge.sound_update_ticks_interval = 12 * 8 -- every 12 seconds
		barge.sound_update_ticks = 0
		barge.move_per_tick = 0.0625
		barge.is_escaping = false
		barge.is_moving = false
		barge.is_sinking = false
		barge.sinking_duration_ticks = 15 * 8
		barge.is_finished = false
		-- Barges will gain 1% health per second to simulate higher total amount of health
		-- We have to do this because none of the barge entities have modifier_ext
		barge.heal_health_percentage_per_tick = 0.005
	end
	Rule_Add(Map_ScanBargeEscapeTrigger)
	Rule_Add(Map_BargesTransitionTick)
end

function Map_ScanBargeEscapeTrigger()
	-- When a barge takes damage, it will begin to "escape"
	local finishedCount = 0
	for _, barge in ipairs(_g_barges) do
		if not barge.is_escaping and not barge.is_finished then
			local healthPercentage = Entity_GetHealthPercentage(barge.entity)
			if healthPercentage < 1.0 then
				barge.is_moving = true
				barge.is_escaping = true
				UI_CreateMinimapBlip(barge.entity, 5, BT_Reveal)
				Sound_Play3D(SCENARIO_SOUNDS.RETREAT, barge.entity)
			end
		else
			finishedCount = finishedCount + 1
		end
	end

	if finishedCount == #_g_barges then
		Rule_RemoveMe()
	end
end

function Map_InitFloodlights()
	Rule_AddInterval(Map_FixFloodLightHitboxes, 2)
end

function Map_BargesTransitionTick()
	local finishedCount = 0

	for index, barge in ipairs(_g_barges) do
		if not barge.is_finished then
			-- Invalid due to death_seconds + delete_when_dead
			if not Entity_IsValid(barge.entity_id) then
				barge.is_moving = false
				barge.is_finished = true
				-- stop the sound - it died unexpectedly
				Sound_StopSafe(barge.sound)
			elseif barge.is_moving then
				local healthPercentage = Entity_GetHealthPercentage(barge.entity)
				local pos = Entity_GetPosition(barge.entity)
				local distance = World_DistancePointToPoint(pos, barge.target_position)
				-- If the barge has been heavily damaged, it will sink as well
				if not barge.is_sinking and healthPercentage == 0 then
					barge.is_sinking = true
					Sound_Play3D(SCENARIO_SOUNDS.BLUB_BLUB_BLUB, barge.entity)
					UI_CreateMinimapBlip(pos, 5, BT_Reveal)
					-- Stop the sound; it's sinking
					Sound_StopSafe(barge.sound)
				end

				if (
					-- Destination: Edge of the map reached
					(barge.is_moving and distance <= 8) or 
					-- Destination: Bottom of the river reached (via simulated sinking)
					(barge.is_sinking and pos.y < 5) or 
					-- Destination: Bottom of the river reached (via timeout)
					(barge.is_sinking and barge.sinking_duration_ticks <= 0)
	 			) then
					-- Stop the sound if it managed to escape
					Sound_StopSafe(barge.sound)
					Entity_Destroy(barge.entity)
					barge.is_moving = false
					barge.is_finished = true
				else
					-- Heal the barge to simulate higher amount of HP
					-- if not barge.is_sinking and healthPercentage < 1.0 then
					-- 	healthPercentage = math.min(1.0, healthPercentage + barge.heal_health_percentage_per_tick)
					-- 	Entity_SetHealth(barge.entity, healthPercentage)
					-- end
					if not barge.is_sinking then
						-- Entity sound does not update its position, we'll have to manually update it periodically
						barge.sound_update_ticks = barge.sound_update_ticks - 1
						if barge.sound_update_ticks <= 0 then
							barge.sound_update_ticks = barge.sound_update_ticks_interval
							Sound_StopSafe(barge.sound)
							barge.sound = Sound_Play3D(barge.sound_name, barge.entity)
						end
					else
						barge.sinking_duration_ticks = barge.sinking_duration_ticks - 1
					end
					
					pos = Pos_GetOffsetPositionTowards(pos, barge.target_position, barge.move_per_tick, false)
					--if barge.is_sinking then
					--	pos.y = math.max(0, pos.y - (barge.move_per_tick / 2))
					--end
					Entity_SetPosition(barge.entity, pos)
				end
			end
		else
			finishedCount = finishedCount + 1
		end
	end

	if finishedCount == #_g_barges then
		Rule_RemoveMe()
	end
end

function Map_FixFloodLightHitboxes()
	-- Logic:
	-- Floodlight hitbox is bugged; it remains as a ghost hitbox after the entity has died. 
	-- We'll get around this issue by deleting the entity entirely once it's dead.
	-- Somewhat unfeasible to use GE_EntityKilled on floodlights; it is delayed by 10 seconds (death_seconds in the entity).
	-- Instead we periodically scan for health.

	-- The floodlight can be crushed by >= medium tanks. Crushing a floodlight doesn't seem to set its health to zero but instead kills it directly. 
	-- After death_seconds (10 seconds) the floodlight health is set to zero which leads to this function processing the floodlight entity.
	-- Technically a crushed floodlight can block rocket artillery projectiles for about 10 seconds but this is unlikely enough for now.

	-- All floodlights that are inaccessible to vehicle pathfinding, i.e. the floodlights on the canal walls,
	-- are set to Visual entities. They won't be scanned for health nor block projectiles.
	local deadFloodlightEntities = {}
	EGroup_ForEach(eg_floodlights, function(egid, idx, entity)
		local health = Entity_GetHealthPercentage(entity)
		if health == 0 then
			table.insert(deadFloodlightEntities, entity)
		end
	end)

	for _, entity in ipairs(deadFloodlightEntities) do
		EGroup_Remove(eg_floodlights, entity)
		Entity_Destroy(entity)
	end

	-- Stop scanning once we're done even though it's extremely unlikely for all floodlights to get destroyed during a match.
	if EGroup_CountSpawned(eg_floodlights) == 0 then
		Rule_RemoveMe()
	end
end

function Map_GetRepairStationAIEngineerSBP(player)
	local race = Player_GetRaceName(player)
	if race == "german" then
		return SBP.GERMAN.PIONEER_SQUAD_MP
	elseif race == "soviet" then
		return SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP
	elseif race == "west_german" then
		return SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP 
	elseif race == "aef" then
		return SBP.AEF.REAR_ECHELON_SQUAD_MP 
	elseif race == "british" then
		return SBP.BRITISH.SAPPER_SQUAD_MP 
	-- Fallback in case there's a new faction
	-- Extremely unlikely for a new official faction to appear,
	-- but mods that allow custom factions may one day be possible.
	else
		return SBP.GERMAN.PIONEER_SQUAD_MP
	end
end

function Map_GetRepairStationAIEngineerSpawnPosition(team)
	-- When team 0 requests spawn position for repairing team 1 station, they will
	-- still spawn in team 0 spawn
	for _, repair_station in ipairs(_g_repair_stations) do
		if repair_station.team == team then
			return Marker_GetPosition(repair_station.exit_marker)
		end
	end
end

function Map_RepairStationAITask()
	-- Control special AI units to repair the generators.
	-- Adjacent territory point controls which team's AI (if available)
	-- will attempt to repair the generator. 
	for _, repair_station in ipairs(_g_repair_stations) do
		local no_alive_ai_engineers = (repair_station.ai_engineer_squad_id == nil or not Squad_IsValid(repair_station.ai_engineer_squad_id))
		local adjacent_owner_team = Entity_GetTeamOwnerSafe(repair_station.adjacent_territory_point.entity)
		if (
			-- Disabled point
			not repair_station.is_enabled and 
			repair_station.ai_engineer_spawn_seconds >= repair_station.ai_engineer_spawn_seconds_interval and
			-- Not an existing engineer performing task
			no_alive_ai_engineers and
			-- Adjacent point owned by a team
			adjacent_owner_team ~= nil
	 	) then
			for i = 1, World_GetPlayerCount() do
				local player = World_GetPlayerAt(i)
				local team = Player_GetTeam(player)
				if not Player_IsHuman(player) and team == adjacent_owner_team then
					local sbp = Map_GetRepairStationAIEngineerSBP(player)
					local spawn_position = Map_GetRepairStationAIEngineerSpawnPosition(adjacent_owner_team)
					local squad = Squad_CreateAndSpawnToward(sbp, player, 0, spawn_position, Entity_GetPosition(repair_station.generator.entity))
					repair_station.ai_engineer_squad = squad
					repair_station.ai_engineer_squad_id = Squad_GetGameID(squad)
					-- Same ability on all engineers
					Squad_AddAbility(squad, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY_MP)
					-- Block weapon upgrades; AI still seems to purchase flamethrowers on AI_LockSquad squads
					Squad_GiveSlotItem(squad, SLOT_ITEM.DUMMY_SLOT_ITEM_1)
					Squad_GiveSlotItem(squad, SLOT_ITEM.DUMMY_SLOT_ITEM_1)
					if AI_IsEnabled(player) then
						AI_LockSquad(player, squad)
					end
					repair_station.ai_engineer_spawn_seconds = 0
					break
				end
			end

		-- Not done yet; Give an order to repair (will repeat until done or dead)
		elseif (
			not repair_station.is_enabled and
			repair_station.ai_engineer_squad_id ~= nil and 
			Squad_IsValid(repair_station.ai_engineer_squad_id)
		)  then
			local sg_engineers = SGroup_Create("")
			SGroup_Add(sg_engineers, repair_station.ai_engineer_squad)
			-- Not moving and not repairing; Move to the generator
			if (
				not Squad_IsMoving(repair_station.ai_engineer_squad) 
				and not Squad_IsDoingAbility(repair_station.ai_engineer_squad, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY_MP)
		 	) then
				Cmd_Move(sg_engineers, Entity_GetPosition(repair_station.generator.entity))
			-- Otherwise repair
		 	else
				Cmd_Ability(sg_engineers, ABILITY.SOVIET.SOVIET_REPAIR_ABILITY_MP, repair_station.generator.egroup, nil, true, false)
			end
			
		-- Done; Retreat
		elseif (
			repair_station.is_enabled and
			repair_station.ai_engineer_squad_id ~= nil and 
			Squad_IsValid(repair_station.ai_engineer_squad_id)
		) then
			local sg_engineers = SGroup_Create("")
			SGroup_Add(sg_engineers, repair_station.ai_engineer_squad)
			UI_EnableSquadDecorator(repair_station.ai_engineer_squad, false)
			-- All engineers exit via the closest exit marker regardless of their spawn position
			Cmd_Retreat(sg_engineers, Marker_GetPosition(repair_station.exit_marker), repair_station.exit_marker, false)

		-- Repair station is disabled and no current set of engineers
		elseif (
			not repair_station.is_enabled and
			no_alive_ai_engineers
		) then
			repair_station.ai_engineer_spawn_seconds = repair_station.ai_engineer_spawn_seconds + 1
		end

		if not repair_station.is_enabled then
			repair_station.out_of_power_message_seconds = repair_station.out_of_power_message_seconds + 1
			if repair_station.out_of_power_message_seconds >= repair_station.out_of_power_message_seconds_interval then
				repair_station.out_of_power_message_seconds = 0
				UI_CreateColouredEntityKickerMessage(
					Game_GetLocalPlayer(),
					repair_station.territory_point.entity,
					Util_CreateLocString("No power"),
					255, 0, 0, 255
				)
			end
		end
	end
end

function Map_ApplyRepairStationModifiers()
	for _, repair_station in ipairs(_g_repair_stations) do
		-- Make generators a bit more durable
		Modify_ReceivedDamage(repair_station.generator.egroup, 0.5, true)
		-- Remove sight radius from the generator; Generators can't see
		Modify_SightRadius(repair_station.generator.egroup, 0)
	end
end

function Map_RepairStationGeneratorsTick()
	-- Control ownership of the generators and repair station
	-- territory point availability.
	for _, repair_station in ipairs(_g_repair_stations) do
		
		local generator_owner = Entity_GetPlayerOwnerSafe(repair_station.generator.entity)
		local territory_owner = Entity_GetPlayerOwnerSafe(repair_station.territory_point.entity)

		local health = Entity_GetHealthPercentage(repair_station.generator.entity)

		-- Generator killed
		if repair_station.is_enabled and health == 0.0 then
			repair_station.is_enabled = false
			EGroup_SetSelectable(repair_station.territory_point.egroup, false)
			Entity_EnableStrategicPoint(repair_station.territory_point.entity, false)
			EGroup_EnableMinimapIndicator(repair_station.territory_point.egroup, false)
			-- Priority based on DLC2Scenarios.sga\data\scenarios\tow\scenarios\1942_kalach\1942_kalach.scar
			Entity_SetAICaptureImportance(repair_station.territory_point.entity, -100)
			Sound_StopSafe(repair_station.sound)
		-- Disabled and fully repaired generator
		elseif not repair_station.is_enabled and health == 1.0 then
			repair_station.is_enabled = true
			EGroup_SetSelectable(repair_station.territory_point.egroup, true)
			Entity_EnableStrategicPoint(repair_station.territory_point.entity, true)
			EGroup_EnableMinimapIndicator(repair_station.territory_point.egroup, true)
			-- Priority based on DLC2Scenarios.sga\data\scenarios\tow\scenarios\1942_kalach\1942_kalach.scar
			Entity_SetAICaptureImportance(repair_station.territory_point.entity, 1500)
			UI_CreateMinimapBlip(repair_station.territory_point.egroup, 5, BT_Reveal)
			repair_station.sound = Sound_Play3D(SCENARIO_SOUNDS.GENERATOR_ENGINE, EGroup_GetSpawnedEntityAt(repair_station.generator.egroup, 1))
			-- Remove first time repair hint
			if repair_station.hint_point then
				HintPoint_Remove(repair_station.hint_point)
				repair_station.hint_point = nil
			end
		end

		-- Sync ownership of generator
		if territory_owner ~= generator_owner then
			if territory_owner == nil then
				Entity_SetWorldOwned(repair_station.generator.entity)
			else
				Entity_SetPlayerOwner(repair_station.generator.entity, territory_owner)
			end
		end
	end
end

function Map_CraneTransitionBeginTriggerTick()
	-- Logic:
	-- When any player-owned squad enters the central area of the map, 
	-- the shipping cranes will start moving and mowing. 
	for i = 1, World_GetPlayerCount() do 
		local player = World_GetPlayerAt(i)
		local sgroup = SGroup_Create("")
		World_GetSquadsNearMarker(player, sgroup, mkr_crane_transition_trigger, OT_Player)
		if not SGroup_IsEmpty(sgroup) then
			for _, crane in ipairs(_g_cranes) do
				UI_CreateMinimapBlip(crane.entity, 2, BT_Reveal)
				-- Played without handle; only plays once
				Sound_Play3D(SCENARIO_SOUNDS.CRANE_MOVE_START_STOP, crane.entity)
			end
			Rule_Add(Map_CraneTransitionTick)
			_g_crane_alarm_sound_handle = Sound_PlayStreamed(SCENARIO_SOUNDS.ALARM)
			Rule_RemoveMe()
			break
		end
	end
end

function Map_CraneTransitionTick()
	-- Apply generator movement and rotation increments
	-- Scan for entities and squads (via squad entities) to crush by the moving cranes
	local has_unfinished_transitions = false
	for _, crane in ipairs(_g_cranes) do
		if crane.is_moving then
			-- Scan for crushes in the last tick's position
			local crushed_entities = World_GetAllEntitiesNearPoint(crane.current_position, crane.crush_radius, true, function(entity)
				-- Some entities are close enough to trigger crush radius; we don't want them to get crushed
				-- e.g. the cranes themselves, railroad track end pieces, decorative objects close to the tracks
				if EGroup_ContainsEntity(eg_cranes_crush_ignore, entity) then
					return false
				end
				for _, ebp in ipairs(_g_crane_non_crushable_entity_blueprints) do
					if Entity_GetBlueprint(entity) == ebp then
						return false
					end
				end
			end)
			
			-- Decrement cooldown between warning indicators by a random integer between 0 and 2 to slightly randomize 
			-- rapidly repeated warnings
			crane.crush_alert_cooldown_ticks = math.max(0, crane.crush_alert_cooldown_ticks - World_GetRand(0, 2))

			for _, crushed_entity in ipairs(crushed_entities) do
				local healthPercentage = Entity_GetHealthPercentage(crushed_entity)
				local owner = Entity_GetPlayerOwnerSafe(crushed_entity)
				if healthPercentage <= 0.1 then
					Entity_Kill(crushed_entity)
				else
					if owner ~= nil and Player_GetID(owner) == Player_GetID(Game_GetLocalPlayer()) and crane.crush_alert_cooldown_ticks == 0 then
						Sound_Play3D(SCENARIO_SOUNDS.ALERT_BEING_CRUSHED, crushed_entity)
						UI_CreateMinimapBlip(crushed_entity, 1, BT_Reveal)
					end

					Entity_SetHealth(
						crushed_entity, 
						-- Which ever is higher; 1% health or new reduced health. 
						-- Prevents setting negative health percentage or 0
						-- Divide by 8 since we're applying damage once per tick
						math.max(0.01, healthPercentage - (crane.crush_health_damage_percentage_per_second / 8))
					)
				end

				-- Cannot apply critical hits to squad entities. we'd like to use frozen to death crit here
			end

			if crane.crush_alert_cooldown_ticks == 0 then
				crane.crush_alert_cooldown_ticks = crane.crush_alert_cooldown_ticks_interval
			end

			-- Restart sound to update its 3D origin
			crane.sound_update_ticks = crane.sound_update_ticks - 1
			if crane.sound_update_ticks <= 0 then
				-- Randomize crane next sound update delay by 25%
				crane.sound_update_ticks = math.floor((World_GetRand(75, 100) / 100) * crane.sound_update_ticks_interval)
				Sound_StopSafe(crane.sound)
				crane.sound = Sound_Play3D(crane.sound_name, crane.entity)
			end

			-- Apply move increment 
			local pos = Entity_GetPosition(crane.entity)
			local distance = World_DistancePointToPoint(crane.current_position, crane.target_position)
			-- If the remaining distance is less than or equal to the distance to travel per tick
			-- With some rounding errors we might still overshoot the target position, but that will
			-- correct itself on the next turn as the distance is going to be less than the distance per tick
			if distance <= crane.move_per_tick then
				crane.current_position = crane.target_position
				crane.is_moving = false
				Sound_Play3D(SCENARIO_SOUNDS.CRANE_MOVE_START_STOP, crane.entity)
				UI_CreateMinimapBlip(crane.entity, 2, BT_Reveal)
			else
				crane.current_position = Pos_GetOffsetPositionTowards(crane.current_position, crane.target_position, crane.move_per_tick)
			end
			Entity_SetPosition(crane.entity, crane.current_position)
		end

		if crane.is_rotating then
			crane.current_rotation = crane.current_rotation + crane.rotate_per_tick
			if crane.current_rotation >= crane.target_rotation then
				crane.current_rotation = crane.target_rotation 
				crane.is_rotating = false
				Sound_Play3D(SCENARIO_SOUNDS.CRANE_MOVE_START_STOP, crane.entity)
				UI_CreateMinimapBlip(crane.entity, 2, BT_Reveal)
			end
			EGroup_SetAnimatorVariable(crane.egroup, "rotation", crane.current_rotation)
		end
		
		-- Done moving and rotating
		if not crane.is_moving and not crane.is_rotating then
			Sound_StopSafe(crane.sound)
			EGroup_SetInvulnerable(crane.egroup, false)
		else
			has_unfinished_transitions = true
		end
	end

	-- While iterating over cranes, no crane reported unfinished transitions
	if not has_unfinished_transitions then
		Sound_StopSafe(_g_crane_alarm_sound_handle)
		Rule_RemoveMe()
	end
end

Scar_AddInit(Map_OnInit)

function Sound_StopSafe(handle)
	if handle then
		Sound_Stop(handle)
	end
end

function Util_CreateEntityEntry(egroup)
	return {
		egroup = egroup,
		entity = EGroup_GetSpawnedEntityAt(egroup, 1)
	}
end

function Entity_GetPlayerOwnerSafe(entity)
	if World_OwnsEntity(entity) then return nil end
	return Entity_GetPlayerOwner(entity)
end

function Entity_GetTeamOwnerSafe(entity)
	if World_OwnsEntity(entity) then return nil end
	return Player_GetTeam(Entity_GetPlayerOwner(entity))
end

function Entity_SetAICaptureImportance(entity, importance)
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if AI_IsEnabled(player) then
			AI_SetCaptureImportanceBonus(player, entity, importance)
		end
	end
end

-- Internal helper function for World_GetAllEntitiesNearPoint to add entities to the result collection 
-- if the entities pass the predicate and distance check.
---@param point ScarPosition
---@param radius number
---@param result table 
---@param entity Entity
---@param predicate function
---@param skipRadiusCheck boolean
function _World_GetAllEntitiesNearPointEntityCallback(point, radius, result, entity, predicate, skipRadiusCheck)
	if predicate and predicate(entity) == false then
		return
	end
	if skipRadiusCheck or World_DistancePointToPoint(Entity_GetPosition(entity), point) <= radius then
		table.insert(result, entity)
	end
end

---Collects all neutral and player owned entities near a point.
---Returns a table instead of EGroup because squad entities cannot be stored in EGroups.
---@return table
---@param point ScarPosition
---@param radius number
---@param includeSquadEntities boolean Whether or not to include individual squad entities in the result.
---@param predicate function Optional function to initially filter the entities before checking for distance. Called with 1 argument: The entity. Should return true/false.
function World_GetAllEntitiesNearPoint(point, radius, includeSquadEntities, predicate)
	local eg_entities = EGroup_Create("")
	local result = {}
	-- Collect all player entities
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if includeSquadEntities then
			-- Technically any squad entity can be really far away from the rest of the squad's position (average position / centroid?)
			-- We'll have to check squad entities manually one by one
			SGroup_ForEach(Player_GetSquads(player), function(sgid, idx, squad)
				Squad_ForEachEntity(squad, function(entity)
					_World_GetAllEntitiesNearPointEntityCallback(point, radius, result, entity, predicate)
				end)
			end)
		end
		-- Append the player's entities to the egroup
		World_GetEntitiesNearPoint(player, eg_entities, point, radius, OT_Player)
	end
	-- Append neutral entities to the egroup
	World_GetNeutralEntitiesNearPoint(eg_entities, point, radius)

	-- Process egroup contents. These entities have already passed the distance check (result of Get...EntitiesNearPoint)
	EGroup_ForEach(eg_entities, function(egid, idx, entity)
		_World_GetAllEntitiesNearPointEntityCallback(point, radius, result, entity, predicate, true)
	end)
	return result
end

--------------------------------------------------------------------------
-- 	     Inline copies if functions from the main library        		--
--------------------------------------------------------------------------

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

---Calculates a new position by moving towards a position by distance.
---@param pos ScarPosition
---@param towards ScarPosition
---@param distance number
---@param onTerrain boolean Whether or not the resulting position should have its y component set to terrain height at the position. Defaults to true.
---@return ScarPosition
function Pos_GetOffsetPositionTowards(pos, towards, distance, onTerrain)
    if onTerrain == nil then onTerrain = true end
    local distanceVector = Pos_Subtract(towards, pos)
    local distanceVectorNormalized = Pos_Normalize(distanceVector)

    local result = Pos_Add(pos, Pos_Multiply(distanceVectorNormalized, distance))
    if onTerrain then
        return Pos_OnTerrain(result)
    end

    return result
end

---Calculates a new ScarPosition with its y component matching the terrain height at the (x, z) position.
---@param pos ScarPosition
---@return ScarPosition
function Pos_OnTerrain(pos)
    return World_Pos(pos.x, Misc_GetTerrainHeight(pos), pos.z)
end

---Subtracts a ScarPosition from a ScarPosition.
---@param pos1 ScarPosition
---@param pos2 ScarPosition
---@return ScarPosition
function Pos_Subtract(pos1, pos2)
    return World_Pos(pos1.x - pos2.x, pos1.y - pos2.y, pos1.z - pos2.z)
end

---Adds a ScarPosition to a ScarPosition.
---@param pos1 ScarPosition
---@param pos2 ScarPosition
---@return ScarPosition
function Pos_Add(pos1, pos2)
    return World_Pos(pos1.x + pos2.x, pos1.y + pos2.y, pos1.z + pos2.z)
end

---Multiplies a ScarPosition with another ScarPosition or multiplies a ScarPosition's all components (x, y, z) by a multiplier (number).
---@param pos1 ScarPosition
---@param pos2OrMultiplier ScarPosition
---@return ScarPosition
function Pos_Multiply(pos1, pos2OrMultiplier)
    if type(pos2OrMultiplier) == "number" then
        local multiplier = pos2OrMultiplier
        return World_Pos(pos1.x * multiplier, pos1.y * multiplier, pos1.z * multiplier)
    end

    local pos2 = pos2OrMultiplier
    return World_Pos(pos1.x * pos2.x, pos1.y * pos2.y, pos1.z * pos2.z)
end

---Divides a ScarPosition with another ScarPosition or divides a ScarPosition's all components (x, y, z) by a divisor (number).
---@param pos1 ScarPosition
---@param pos2OrDivisor ScarPosition
---@return ScarPosition
function Pos_Divide(pos1, pos2OrDivisor)
    if type(pos2OrDivisor) == "number" then
        local divisor = pos2OrDivisor
        return World_Pos(pos1.x / divisor, pos1.y / divisor, pos1.z / divisor)
    end
    local pos2 = pos2OrDivisor
    return World_Pos(pos1.x / pos2.x, pos1.y / pos2.y, pos1.z / pos2.z)
end

---Calculates the length/magnitude of a ScarPosition.
---@param pos ScarPosition
---@return number
function Pos_Length(pos)
    return math.sqrt((pos.x * pos.x) + (pos.y * pos.y) + (pos.z * pos.z))
end

---Normalizes a ScarPosition.
---@param pos ScarPosition
---@return ScarPosition
function Pos_Normalize(pos)
    local length = Pos_Length(pos)

    if length == 0 then
        return World_Pos(0, 0, 0)
    end
    return Pos_Divide(pos, length)
end

---Iterates over squad entities. 
---Passes the entity and the 0-based index of the squad entity to the callback function.
---breaks the iteration if the callback function returns false.
---@param squad Squad
---@param callback function
function Squad_ForEachEntity(squad, callback)
	for i = 1, Squad_Count(squad) do
        local entityIndex = i - 1
		local entity = Squad_EntityAt(squad, entityIndex)
	    local result = callback(entity, entityIndex)
        if result == false then
            break
        end
	end	
end
