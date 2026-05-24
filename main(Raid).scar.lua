-----------------------------------------------------------------------
-- Conquest mode (modified from VPTicker)
-----------------------------------------------------------------------
import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/AABattle_VPTickerWin-Annihilate_Functions.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")
import("WinConditions/AABattle_Annihilate.scar")

-----------------------------------------------------------------------
-- Global flags (used externally)
--  must be global because we don't know the order the Init functions
--  are called.
-----------------------------------------------------------------------
function SetGlobals()
	--Global Variables--
		g_VPConditionsLoaded = true
		g_VictoryAchieved = false
		g_SectorsUpdated = 0
		g_sectors = {}
		g_sectors[0] = 0
		g_sectors[1] = 0

		eg_CptPs = EGroup_CreateIfNotFound("eg_CptPs")
			World_GetStrategyPoints(eg_CptPs, true)
		eg_fuelpoints = EGroup_CreateIfNotFound("eg_fuelpoints")
			World_GetStrategyPoints(eg_fuelpoints, true)
			EGroup_Filter(eg_fuelpoints, BP_GetEntityBlueprint("territory_fuel_point_mp"), FILTER_KEEP)

		g_team1player = World_GetPlayerAt(1)
		g_team2player = Player_FindFirstEnemyPlayer(g_team1player)
		g_team1origin = Util_GetRandomPosition(Player_GetMapEntryPosition(g_team1player), 10)
		g_team2origin = Util_GetRandomPosition(Player_GetMapEntryPosition(g_team2player), 10)
		g_team1startpos = Player_GetStartingPosition(g_team1player)
		g_team2startpos = Player_GetStartingPosition(g_team2player)

		eg_german_muster_point = EGroup_CreateIfNotFound("eg_german_muster_point")
		g_german_muster_position = Util_GetOffsetPosition(g_team2startpos, 4, 15)
		sg_near_muster = SGroup_CreateIfNotFound("sg_near_muster")

	------Blueprints: Abilities---------
		ABILITY_TRANSFER_ORDERS = BP_GetAbilityBlueprint("transfer_orders")
		ABILITY_HULLDOWN = BP_GetAbilityBlueprint("6c196065c70546af8f51e48c1f0a0f75:german_hulldown_ability")
		ABILITY_WITHDRAW = BP_GetAbilityBlueprint("6c196065c70546af8f51e48c1f0a0f75:withdraw")
		ABILITY_FUEL_CONVOY = BP_GetAbilityBlueprint("6c196065c70546af8f51e48c1f0a0f75:fuel_convoy")

	------Blueprints: Entities---------
		bp_german_munitions = BP_GetEntityBlueprint("supply_drop_munitions_ostruppen")
		bp_allied_supplies_01 = BP_GetEntityBlueprint("alliedsupply_stack_l_01_explosive")
		bp_manpower_crates = BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:truck_supplies_manpower")
		bp_muster_point = BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:muster_point")
		bp_schu_mine = BP_GetEntityBlueprint("schu_mine_42_mp")

		bp_loot = {
			BP_GetEntityBlueprint("supply_drop_munitions_ostruppen"),
			BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:truck_supplies_manpower"),
			--BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:"),
			BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:truck_remains_manpower"),
			BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:truck_remains_munitions"),
			BP_GetEntityBlueprint("6c196065c70546af8f51e48c1f0a0f75:weapon_crate_mp44"),
		}

	------Blueprints: Squads---------
		bp_german_patrol_remnants = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:german_patrol_remnants")
		bp_ostwind = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:ostwind_emplacement")
		bp_pioneer_squad = BP_GetSquadBlueprint("pioneer_squad_mp")
		bp_vehicle_crew_german = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:vehicle_crew_german")
		bp_delivery_truck = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:opel_blitz_delivery_squad")
		bp_retreating_grenadiers = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:retreating_squad")

		bp_ober_schreck = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:obersoldaten_squad_invading")
		bp_ober_mg42 = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:obersoldaten_squad_invading_mg42")
		bp_ober_mp44 = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:obersoldaten_squad_invading_mp44")
		bp_ober_officer = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:invading_ober_officer")







	----------Events-------------
	--Main Event Controller
		g_event_id = 0
		g_event_running = 0
		g_event_interval = World_GetRand(2, 4)
		UI_event_ping1 = nil
		UI_event_ping2 = nil

	--Fuel Convoy Call-in
		sg_GermanConvoy = SGroup_CreateIfNotFound( "sg_GermanConvoy" )
		sg_GermanConvoySupply = SGroup_CreateIfNotFound( "sg_GermanConvoySupply" )
		sg_GermanConvoyTransport = SGroup_CreateIfNotFound( "sg_GermanConvoyTransport" )
		sg_GermanConvoySoldiers = SGroup_CreateIfNotFound( "sg_GermanConvoySoldiers" )
		g_fuelconvoy_origin = nil
		g_fuelconvoy_destination = nil
		g_fuelconvoy_point = nil
		g_fuel_convoy_amount = 0
		g_convoy_packuptime = 0
	
	--German Patrol
		sg_GermanPatrol = SGroup_CreateIfNotFound( "sg_GermanPatrol" )
		TotalSectors = World_GetNumStrategicPoints()
		sg_ostwind = SGroup_CreateIfNotFound( "sg_ostwind" )
		sg_ostwind_pio = SGroup_CreateIfNotFound( "sg_ostwind_pio" )

	--Evacuating Supplies
		Util_CreateEntities(g_team2player, eg_german_muster_point, bp_muster_point, g_german_muster_position, 1)
		sg_manpower_truck = SGroup_CreateIfNotFound( "sg_manpower_truck" )
		pos_manpower_truck_unload = nil
		g_supply_unload_order = 3
		sg_manpower_haulers = SGroup_CreateIfNotFound( "sg_manpower_haulers" )

	--Retreating Germans
		sg_retreating_germans = SGroup_CreateIfNotFound( "sg_retreating_germans" )
		g_retreating_interval = 0
		g_retreating_counter = World_GetRand(1, 2)

	--Obersoldaten Assault
		sg_ober_assault = SGroup_CreateIfNotFound( "sg_ober_assault" )
		sg_ober_assault_temp = SGroup_CreateIfNotFound( "sg_ober_assault_temp" )
		sg_ober_assault_officer = SGroup_CreateIfNotFound( "sg_ober_assault_officer" )
		sg_ober_assault_force = SGroup_CreateIfNotFound( "sg_ober_assault_force" )
		sg_obers_at_obj = SGroup_CreateIfNotFound( "sg_obers_at_obj" )
		g_ober_distance = 10
		g_ober_facing = 1

	--Armoured Convoy
		g_convoy_destination = nil
		g_convoy_destination_facing = nil
		g_convoy_origin = nil
		g_convoy_origin_facing = nil



end

function Init_Audio()
	g_MissionSpeechPath = "botb/gameplay"
end

Scar_AddInit(Init_Audio)

-----------------------------------------------------------------------
-- OnInit - Main script entry point (not called for saved games)
-----------------------------------------------------------------------
function Main_Init()
	Rule_RemoveIfExist(Annihilate_CheckAnnihilation)
	SetGlobals()

	-- call vanilla point control victory functions
	VPTicker_OnInit()

	Init_Objectives()

	-- check if a team holds all sectors: if activated, remember to also activate the related objective lines
	--Rule_AddInterval(Conquest, 3)

	--check for casualties
	Rule_AddGlobalEvent(checkCasualty, GE_EntityKilled)

	--giving my test faction extra resources for debugging purposes
	--Player_SetResource(g_team2player, RT_Munition, 500)
	--Player_SetResource(g_team2player, RT_Fuel, 500)
	--[[
	Modify_PlayerResourceRate(g_team1player, RT_Manpower, 0 )
	Modify_PlayerResourceRate(g_team1player, RT_Munition, 0)
	Modify_PlayerResourceRate(g_team1player, RT_Fuel, 0)
	Player_SetResource(g_team1player, RT_Manpower, 0)
	Player_SetResource(g_team1player, RT_Munition, 0)
	Player_SetResource(g_team1player, RT_Fuel, 0)
]]--
	Rule_AddOneShot(Limited_Resources, 1)
	Rule_AddOneShot(german_patrol, 5)
	Rule_AddOneShot(ostwind_emplacement, 1)
	Rule_AddInterval(event_controller, 60)
	Rule_AddOneShot(initial_speech, 5)
	Rule_AddOneShot(spawn_loot, 1)
end

-----------------------------------------------------------------------
-- MainRules - Called every so often to process the win condition
-----------------------------------------------------------------------

function initial_speech()
	Actor_PlaySpeech(ACTOR.Vastano, 11079781) -- LOCDB [11079781] 'Listen -- we got 60 seconds to form up! This is how it'll shake out… We gotta' hit Oberkommando West and keep em' busy here while other forces hit adjacent A.O.'s. Don't let me down -- let's go!'
end


function event_controller()
	if g_event_running == 0 then
		g_event_running = 1
		
		--run a random event
		g_event_id = World_GetRand(1, 5)
		--g_event_id = 5

		if g_event_id == 1 then
			UI_event_ping1 = Objective_AddUIElements(obj_events, g_team1origin, true, Util_CreateLocString("Germans arrive here"), true, 3)
			UI_event_ping2 = Objective_AddUIElements(obj_events, g_german_muster_position, true, Util_CreateLocString("Germans Destination"), true, 3)

			Actor_PlaySpeech(ACTOR.Vastano, 11075771) -- LOCDB [11075771] 'Able Company!  Get your asses up front!  Give it to those  bastards!' - 'Lazzaro'

			Timer_Start("tmr_event", 30*World_GetRand(4,6))
			Rule_AddInterval(retreating_germans_timer, 1)
	
		elseif g_event_id == 2 then
			UI_event_ping1 = Objective_AddUIElements(obj_events, g_team1origin, true, Util_CreateLocString("German Supply Truck enters here"), true, 3)
			UI_event_ping2 = Objective_AddUIElements(obj_events, g_german_muster_position, true, Util_CreateLocString("Supply Truck Destination"), true, 3)
			Timer_Start("tmr_event", 30*World_GetRand(4,6))
			Rule_AddInterval(manpower_truck_timer, 1)

			local _voice_over = World_GetRand(1, 3)
			if _voice_over == 1 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079821) -- LOCDB [11079821] 'Alright boys, looks like these dumbassed Krauts are tryin' to drop supplies to their troops. Supplies we could use just as much as them.'
			elseif _voice_over == 2 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079772)      -- LOCDB [11079772] 'Alright, we gotta knock out the goddamn vehicles before they can supply their forces -- Get to it, Able!'
			elseif _voice_over == 3 then
				Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
				Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11080870)      -- LOCDB [11080870] 'We need to shut 'em down before they can get those supplies out'
				Actor_PlaySpeech(ACTOR.Vastano, 11075775) -- LOCDB [11075775] 'Able's got the objective,  redeploy front elements!' 
			end
	
		elseif g_event_id == 3 then
			Timer_Start("tmr_event", 30*World_GetRand(2,4))
			Rule_AddInterval(remarque_timer, 1)

		elseif g_event_id == 4 then
			UI_event_ping2 = Objective_AddUIElements(obj_events, g_team1origin, true, Util_CreateLocString("German Assault Destination"), true, 3)

			Actor_PlaySpeech(ACTOR.Vastano, 11079795)      -- LOCDB [11079795] 'We've got word The krauts are sendin' in a unit of seasoned vets to try and turn the tide.'
			Actor_PlaySpeech(ACTOR.Vastano, 11079796)      -- LOCDB [11079796] 'If we can block em' from joinin' the front-line, it oughta turn their command structure on it 's fuckin' head… Could help get our forces up here quicker.'

			Timer_Start("tmr_event", 30*World_GetRand(4,6))
			Rule_AddInterval(obersoldaten_assault_timer, 1)

		elseif g_event_id == 5 then

			if World_GetRand(0,1) == 0 then
				g_convoy_origin = g_team2origin
				g_convoy_origin_facing = g_team2startpos
				g_convoy_destination = g_team1origin
				g_convoy_destination_facing = g_team1origin
			else
				g_convoy_origin = g_team1origin
				g_convoy_origin_facing = g_team1startpos
				g_convoy_destination = g_team2origin
				g_convoy_destination_facing = g_team2origin
			end
			
			UI_event_ping1 = Objective_AddUIElements(obj_events, g_convoy_origin, true, Util_CreateLocString("German Armoured Convoy Entry"), true, 3)
			UI_event_ping2 = Objective_AddUIElements(obj_events, g_convoy_destination, true, Util_CreateLocString("German Armoured Convoy Exit"), true, 3)

			local _voice_over = World_GetRand(1, 2)
			if _voice_over == 1 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079758) -- LOCDB [11079758] 'Alright, these dumbassed Germans have their vehicles amassed in one spot.  Gives us a prime opportunity - let's take em' out!'
			
			elseif _voice_over == 2 then
				
				Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11079880) -- LOCDB [11079880] 'Germans got armor amassing in the area. If we can assemble and strike 'em here, it could spare a lot of lives down the line.'
				Actor_PlaySpeech(ACTOR.Vastano, 11075797) -- LOCDB [11075797] 'Able Company will be primary assault team.' - 'Lazzaro'
			end

			Timer_Start("tmr_event", 30*World_GetRand(4,6))
			Rule_AddInterval(armoured_convoy_timer, 1)


		end
	
	else
		if g_event_running == 2 then
			g_event_running = 0
			Objective_RemoveUIElements(obj_events, UI_event_ping1)
			Objective_RemoveUIElements(obj_events, UI_event_ping2)
			Objective_UpdateText(obj_events, Util_CreateLocString("No events to report for the moment. Stand by..."), nil, 	false)
		end
	end
end


function Conquest()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local enemyplayer = Player_FindFirstEnemyPlayer(player)
		local PlayerSectors = Player_GetNumStrategicPoints(player)
		local EnemySectors = Player_GetNumStrategicPoints(enemyplayer)
		local team = Player_GetTeam(Util_GetPlayerOwner(player))

		
		if VPTickerData.start_points == 1 then

			if PlayerSectors ~= g_sectors[team] then
				if PlayerSectors < g_sectors[team] then
					local morale_loss = VPTicker_GetTeamTickers(team) - 10
					VPTicker_SetTeamTickers(team, math.max(morale_loss, 0), true)
					if VPTicker_GetTeamTickers(team) == 0 and g_VictoryAchieved == false then
						g_VictoryAchieved = true
						VPTicker_GameOverLose(team)
					end


					--Player_AddResource(player, RT_Manpower, 100+5*(TotalSectors-PlayerSectors))
					--EGroup_CreateKickerMessage(eg_player_point, "+".. 100+5*(TotalSectors-PlayerSectors))
				end
				g_sectors[team] = PlayerSectors
			end
		end

		if Player_IsAlive(player) and Player_IsAlive(enemyplayer) and PlayerSectors == TotalSectors and g_VictoryAchieved == false then
			g_VictoryAchieved = true
			VPTicker_GameOverLose(Player_GetTeam(Util_GetPlayerOwner(enemyplayer)))
		end

	end
	Update_Conquest_Status()
end

function Update_Conquest_Status()
	if(Game_HasLocalPlayer() == true) then
		local localplayer = Game_GetLocalPlayer()
		local localRace = Player_GetRaceName(localplayer)

		if Player_GetNumStrategicPoints(localplayer) > World_GetNumStrategicPoints()-3 then
			Objective_UpdateText(obj_Status, Util_CreateLocString("We've almost won. Capture the remaining sectors!"), nil, false)

		elseif Player_GetNumStrategicPoints(localplayer) > Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) then
			Objective_UpdateText(obj_Status, Util_CreateLocString("We control more sectors than the enemy!"), nil, false)

		elseif Player_GetNumStrategicPoints(localplayer) < Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) then
			Objective_UpdateText(obj_Status, Util_CreateLocString("The enemy controls more sectors than us!"), nil, false)
		
		elseif Player_GetNumStrategicPoints(Player_FindFirstEnemyPlayer(localplayer)) > World_GetNumStrategicPoints()-2 then
			Objective_UpdateText(obj_Status, Util_CreateLocString("We've almost lost. Do not let the enemy capture the last sector!"), nil, false)
		end
	end
end

function checkCasualty(victim, killer)
	if victim ~= nil then
		if Util_GetPlayerOwner(victim) ~= nil then
			local lossInflicted = 0
			if Entity_IsOfType(victim, "kubelwagen") then lossInflicted = 10
			elseif Entity_IsOfType(victim, "aircraft") then lossInflicted = 40
			elseif Entity_IsOfType(victim, "conscripts") then lossInflicted = 1
			elseif Entity_IsOfType(victim, "heavy_tank") then lossInflicted = 80
			elseif Entity_IsOfType(victim, "medium_tank") then lossInflicted = 40
			elseif Entity_IsOfType(victim, "armour") then lossInflicted = 35
			elseif Entity_IsOfType(victim, "halftrack") then lossInflicted = 20
			elseif Entity_IsOfType(victim, "light_vehicle") then lossInflicted = 10
			elseif Entity_IsOfType(victim, "snipers") then lossInflicted = 10
			elseif Entity_IsOfType(victim, "infantry_elite") then lossInflicted = 3
			elseif Entity_IsOfType(victim, "infantry") then lossInflicted = 2
			end
			local morale_loss = VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim))) - lossInflicted
			VPTicker_SetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim)), math.max(morale_loss, 0), true)
			if killer ~= nil then
				if Util_GetPlayerOwner(killer) ~= nil and Util_GetPlayerOwner(killer) ~= Util_GetPlayerOwner(victim) then
					local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(killer))) + math.ceil(lossInflicted/2)
					VPTicker_SetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(killer)), math.min(morale_boost, VPTickerData.start_points), true)
					
					local received_munitions = math.ceil(lossInflicted*4/World_GetRand(2, 3))
					if received_munitions > 0 then
						UI_CreateEntityKickerMessage( Util_GetPlayerOwner(killer), killer, Util_CreateLocString("+ ".. received_munitions .. " mun") )
						Player_AddResource(Util_GetPlayerOwner(killer), RT_Munition, received_munitions)
					end
				end
			end
			if VPTicker_GetTeamTickers(Player_GetTeam(Util_GetPlayerOwner(victim))) == 0 and g_VictoryAchieved == false then
				g_VictoryAchieved = true
				VPTicker_GameOverLose(Player_GetTeam(Util_GetPlayerOwner(victim)))
			end
		end
	end
end

--UI functions
function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Init_Objectives()

	obj_Conquest = {
	
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_Start(obj_Status, false)
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = Util_CreateLocString("Capture and hold all sectors."),
		Description = 0,
		Type = OT_Primary,
	}
	
	obj_Status = {
		Parent = obj_Conquest,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("The area is contested."),
		Description = 0,
		Type = OT_Secondary,
	}

	obj_tmr_manpower = {
		--Parent = obj_Conquest,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Secondary,
	}

	obj_fuel_convoy = {
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Secondary,
	}

	obj_fuel_convoy_load = {
		Parent = obj_fuel_convoy,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Secondary,
	}

	obj_events = {
		--Parent = obj_fuel_convoy,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString("No events to report for the moment. Stand by..."),
		Description = 0,
		Type = OT_Primary,
	}
	obj_events_timer = {
		Parent = obj_events,
		SetupUI = function()
		end,
		OnStart = function()
		end,
		OnComplete = function()
		end,
		OnFail = function()
		end,
		Title = Util_CreateLocString(""),
		Description = 0,
		Type = OT_Secondary,
	}

		
	--Objective_Register(obj_Conquest)
	--Objective_Start(obj_Conquest, false)
	--Objective_Register(obj_Status)
	--Objective_Register(obj_tmr_manpower)

	Objective_Register(obj_events)
	Objective_Start(obj_events, false)

	Objective_Register(obj_fuel_convoy)
	Objective_Start(obj_fuel_convoy, false)
	--Objective_Register(obj_fuel_convoy_load)
	--Objective_Start(obj_fuel_convoy_load, false)


	--Objective_Register(obj_events_timer)
	--Objective_Start(obj_events_timer, false)

end

----------------------Limited supplies code----------------------------
	function Limited_Resources()
		for i=1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			Modify_PlayerResourceRate(player, RT_Manpower, 0 )
			Modify_PlayerResourceRate(player, RT_Munition, 0)
			Modify_PlayerResourceRate(player, RT_Fuel, 0)
			Player_SetResource(player, RT_Manpower, 1200)
			Player_SetResource(player, RT_Munition, 100)
			Player_SetResource(player, RT_Fuel, 80)
			Player_SetPopCapOverride(player, 60)
			Player_AddAbility(player, ABILITY_TRANSFER_ORDERS)
		end
	end


-----------Airborne Raid Objectives----------
------German Fuel Convoy------
	function ru_convoy_init()
		--Objective_Start(obj_tmr_manpower, false)
		--Timer_Start("tmr_manpower", 290)
		--Rule_Add(Manpower_Objective)
		g_fuelconvoy_point = EGroup_GetRandomSpawnedEntity(eg_fuelpoints)
		g_fuelconvoy_origin = g_team2origin
		g_fuelconvoy_destination = Entity_GetPosition(g_fuelconvoy_point)
		g_convoy_packuptime = 0
	
		UI_Convoy_Start = Objective_AddUIElements(obj_fuel_convoy, g_team2origin, true, Util_CreateLocString("Convoy arrives here"), true, 3)
		UI_Convoy_Dest = Objective_AddUIElements(obj_fuel_convoy, g_fuelconvoy_destination, true, Util_CreateLocString("Convoy destination"), true, 3)
	
		Timer_Start("tmr_fuel_convoy", 30*World_GetRand(4,6))
		Rule_Add(ru_convoy_expect)
		Player_SetAbilityAvailability(g_team2player, ABILITY_FUEL_CONVOY, ITEM_LOCKED)

		Actor_PlaySpeech(ACTOR.Vastano, 11079804)	-- LOCDB [11079804] 'We gotta' form up and take the fuel depot before the krauts get all that gas outta here!'
	end
	
	function ru_convoy_expect()
		if Timer_GetRemaining("tmr_fuel_convoy") <= 0 then
			Rule_RemoveMe()
			Timer_End("tmr_fuel_convoy")
			convoy_create()
			Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: Moving"), nil, false)
			--Objective_Complete(obj_fuel_convoy, false)
			--Objective_Show(obj_tmr_manpower, false)
			--Objective_RemoveUIElements(obj_tmr_manpower)

			Actor_PlaySpeech(ACTOR.Vastano, 11079776)      -- LOCDB [11079776] 'Move your asses goddamnit!  German convoy's up and running -- wipe it off the goddamn map…Now!'
		
		else
			Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: Incoming in " ..math.floor(Timer_GetRemaining("tmr_fuel_convoy")/60)..":"..math.floor	(math.floor(Timer_GetRemaining("tmr_fuel_convoy") % 60)/10)..math.floor(Timer_GetRemaining("tmr_fuel_convoy") % 60) - math.floor(math.floor(Timer_GetRemaining	("tmr_fuel_convoy") % 60)/10) * 10), nil, false)
		end
	end
	
	function convoy_create()
		eg_CptPs = EGroup_CreateIfNotFound("eg_CptPs")
		World_GetStrategyPoints(eg_CptPs, false)
			--World_GetRand(0, 1)
				local eid = g_fuelconvoy_point
				local _origin1 = Util_GetRandomPosition(g_team2origin, 10)
				local _destination1 = Entity_GetOffsetPosition(eid, 3, 10)
				local _origin2 = Util_GetRandomPosition(g_team2origin, 10)
				local _destination2 = Entity_GetOffsetPosition(eid, 6, 5)
				local _grenadier_transport = BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:opel_blitz_transport_squad_mp")
				Util_CreateSquads(g_team2player, {sg_GermanConvoyTransport, sg_GermanConvoy}, _grenadier_transport, _origin1, _destination2, 1, 1, false, nil, nil, _destination1)
				Util_CreateSquads(g_team2player, {sg_GermanConvoySupply, sg_GermanConvoy}, SBP.GERMAN.OPEL_BLITZ_SUPPLY_SQUAD, _origin2, _destination1, 1, 1, false, nil, nil, 	_destination1)
				--Util_GetRandomPosition(_destination1, 10)
				if AI_IsAIPlayer(g_team2player) then
					AI_LockSquads(g_team2player, sg_GermanConvoy)
					
				end
				SGroup_SetSelectable(sg_GermanConvoy, false)
				--Modify_UnitSpeed(sg_GermanConvoy, 1.5)
				--FOW_RevealSGroupOnly(sg_GermanConvoy, -1)
				Rule_AddInterval(ru_convoy_deploy, 3)
	end
	
	function ru_convoy_deploy()
		if SGroup_IsAlive(sg_GermanConvoySupply)==false then
			Rule_RemoveMe()
			convoy_aftermath(1)
			Actor_PlaySpeech(ACTOR.Vastano, 11079774)     	 -- LOCDB [11079774] 'Smoked the enemy convoy before it could slip away…Right on the money boys!'



			return true
		else
			local _convoy_damaged = false
			for i = 1, SGroup_CountSpawned(sg_GermanConvoy) do
				if Squad_GetHealthPercentage(SGroup_GetSpawnedSquadAt(sg_GermanConvoy, i)) < 0.4 then
					_convoy_damaged = true
				end
			end
			if _convoy_damaged == true then
					convoy_aftermath(0)
					return true
			end
		end
	
		if SGroup_IsIdle(sg_GermanConvoy, ALL) then
			Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: 0/200 Fuel"), nil, false)
			Cmd_Ability(sg_GermanConvoy, BP_GetAbilityBlueprint("supply_truck_lockdown"))
			local _transport_truck_position = Squad_GetOffsetPosition(SGroup_GetSpawnedSquadAt(sg_GermanConvoy, 1), 4, 2)
			Util_CreateSquads(g_team2player, {sg_GermanConvoy, sg_GermanConvoySoldiers}, bp_german_patrol_remnants, _transport_truck_position)
			
			
			if AI_IsAIPlayer(g_team2player) then
				AI_LockSquads(g_team2player, sg_GermanConvoy)
				
			end
			SGroup_SetSelectable(sg_GermanConvoy, false)
		
		
			Rule_RemoveMe()
			Rule_AddInterval(ru_convoy_loading, 5)
		end
	end
	
	function ru_convoy_loading()
		if SGroup_IsAlive(sg_GermanConvoySupply) then
			local _convoy_damaged = false
			for i = 1, SGroup_CountSpawned(sg_GermanConvoy) do
				if Squad_GetHealthPercentage(SGroup_GetSpawnedSquadAt(sg_GermanConvoy, i)) < 0.4 then
					_convoy_damaged = true
				end
			end
			if g_fuel_convoy_amount == 200 or _convoy_damaged == true then
				if _convoy_damaged == true then

					Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: ".. g_fuel_convoy_amount .. "/200: Leaving due to hostile action"), nil, false)
					if g_convoy_packuptime == 0 then 
						g_convoy_packuptime = 1
						Actor_PlaySpeech(ACTOR.Vastano, 11079797) -- LOCDB [11079797] 'German forces are rattled… One hell of a job, fellas.'
						return true
					end
				else
					Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: ".. g_fuel_convoy_amount .. "/200: Convoy Leaving"), nil, false)
				end
				Rule_RemoveMe()
				Cmd_Ability(sg_GermanConvoy, BP_GetAbilityBlueprint("supply_truck_lockdown"))
				Command_SquadSquadLoad(g_team2player, sg_GermanConvoySoldiers, SCMD_Load, sg_GermanConvoyTransport, false, false)
				Rule_AddOneShot(ru_convoy_leave, 10)
			else
				g_fuel_convoy_amount = g_fuel_convoy_amount + 5
				Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: ".. g_fuel_convoy_amount .. "/200"), nil, false)
				local _soldier_destination = Util_GetRandomPosition(Squad_GetPosition(SGroup_GetSpawnedSquadAt(sg_GermanConvoy, 2)), 10)
				Cmd_AttackMove(sg_GermanConvoySoldiers, _soldier_destination, true)
			end
		else
			convoy_aftermath(1)
		end
	end
	
	function ru_convoy_leave()
		Cmd_Ability(sg_GermanConvoyTransport, ABILITY_WITHDRAW)
		SGroup_DestroyAllSquads(sg_GermanConvoySoldiers)
		Cmd_Move( sg_GermanConvoySupply, g_team2origin, true )
		Rule_AddInterval(ru_convoy_left, 1)
	end
	
	function ru_convoy_left()
		if SGroup_IsAlive(sg_GermanConvoySupply) then
			if SGroup_IsIdle(sg_GermanConvoySupply, ALL) then
				--UI_CreateSGroupKickerMessage( g_team2player, sg_GermanConvoy, Util_CreateLocString("+ ".. g_fuel_convoy_amount .. " fuel") )
				--Cmd_Ability(sg_GermanConvoySupply, ABILITY_WITHDRAW)
				--SGroup_DestroyAllSquads(sg_GermanConvoySupply)
				Rule_RemoveMe()
				Player_AddResource(g_team2player, RT_Fuel, g_fuel_convoy_amount)
				Actor_PlaySpeech(ACTOR.Vastano, 11079806)      -- LOCDB [11079806] 'Goddamn, Jerry's got the fuel cache - their armour's gonna overrun us - fall the hell back!'
				convoy_aftermath(2)
			end
		else
			Rule_RemoveMe()
			Actor_PlaySpeech(ACTOR.Vastano, 11079774)     	 -- LOCDB [11079774] 'Smoked the enemy convoy before it could slip away…Right on the money boys!'

			convoy_aftermath(1)
		end
	end
	
	function convoy_aftermath(_success)
		g_convoy_packuptime = 0
		Objective_RemoveUIElements(obj_fuel_convoy, UI_Convoy_Start)
		Objective_RemoveUIElements(obj_fuel_convoy, UI_Convoy_Dest)
	if _success == 2 then
		Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: The previous convoy has successfuly delivered ".. g_fuel_convoy_amount .. " fuel which can now be used."), nil, 	false)
	elseif _success == 0 then
		Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: We were forced to pull the convoy back early. We only got ".. g_fuel_convoy_amount .. " fuel."), nil, false)
	else
		Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: The previous convoy was lost... "), nil, false)
	end
	
	--Objective_UpdateText(obj_fuel_convoy, Util_CreateLocString("German Fuel Convoy: OffMap"), nil, false)
	
	g_fuel_convoy_amount = 0
										
		local convoy_retreat = function(gid, idx, sid)
			local _sg_convoy_remnants = SGroup_CreateIfNotFound( "_sg_convoy_remnants" )
			Squad_AddAbility(sid, ABILITY_WITHDRAW)
			SGroup_Add(_sg_convoy_remnants, sid)
			Cmd_Ability(_sg_convoy_remnants, ABILITY_WITHDRAW)
			SGroup_Destroy(_sg_convoy_remnants)
		end
		SGroup_ForEach(sg_GermanConvoy, convoy_retreat)
		--Rule_AddOneShot(ru_convoy_init,	World_GetRand(20,30))
		Player_SetAbilityAvailability(g_team2player, ABILITY_FUEL_CONVOY, ITEM_UNLOCKED)
	end



------German Patrol-------
	function german_patrol()
		-- spawn squad towards player spawn.
		-- get 2-4 sectors
		-- attack-move and wander a bit queued at each location
		-- if down to half hp, retreat
		--check if squad still exists, if it does and has 3 members, it retreats offmap

		Util_CreateSquads(g_team2player, sg_GermanPatrol, bp_german_patrol_remnants, g_team2origin)
		if AI_IsAIPlayer(g_team2player) then
			AI_LockSquads(g_team2player, sg_GermanPatrol)

		end
		SGroup_SetSelectable(sg_GermanPatrol, false)

		local _patrol_stops = World_GetRand(2, 4)

		for i = 1, _patrol_stops do
			--local _destination = Util_GetRandomPosition(Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_CptPs)), 5)
			local _target_point = EGroup_Create("_target_point")
			EGroup_Add(_target_point, EGroup_GetRandomSpawnedEntity(eg_CptPs))
			--Cmd_AttackMoveThenCapture()
			Cmd_AttackMoveThenCapture( sg_GermanPatrol, _target_point, true )
			EGroup_Destroy(_target_point)
			--_destination = Util_GetRandomPosition(_destination, 10)
			--Cmd_AttackMove( sg_GermanPatrol, _destination, true )
		end

		Cmd_AttackMove( sg_GermanPatrol, g_team2origin, true )

		--Modify_UnitSpeed(sg_GermanPatrol, 2)

		Rule_AddInterval(german_patrol_status, 2)
		--Rule_RemoveMe()

	end


	function german_patrol_status()
		if SGroup_IsAlive(sg_GermanPatrol) then
			local _squad = SGroup_GetSpawnedSquadAt(sg_GermanPatrol, 1)

			if Squad_GetHealthPercentage(_squad) < 0.6 then
				Cmd_Retreat(sg_GermanPatrol)
				SGroup_SetSelectable(sg_GermanPatrol, true)
				SGroup_Remove(sg_GermanPatrol, _squad)
				Rule_RemoveMe()
				Rule_AddOneShot(german_new_patrol, 5)
				return true
			end

			if SGroup_IsIdle(sg_GermanPatrol, ALL) then
				SGroup_DestroyAllSquads(sg_GermanPatrol)
				Rule_RemoveMe()
				Rule_AddOneShot(german_new_patrol, 5)
				return true
			end

		else 
			Rule_RemoveMe()
			Rule_AddOneShot(german_new_patrol, 60)
		end
	end

	function german_new_patrol()
		local _patrol_timer = World_GetRand(3, 5)
		Rule_AddOneShot(german_patrol, _patrol_timer*30)
	end

------Ostwind Emplacement Spawn------
	function ostwind_emplacement()
		-- get random point and cap
		-- spawn ostwind and grenadier squad

		local _destination = Util_GetRandomPosition(Entity_GetPosition(EGroup_GetRandomSpawnedEntity(eg_CptPs)), 20)
		Util_CreateSquads(g_team2player, sg_ostwind, bp_ostwind, _destination, nil, 1, 1, false, g_team1origin)
		--Cmd_CriticalHit(g_team2player, sg_ostwind, CRIT.VEHICLE_DESTROY_ENGINE, 1.0)
		Util_CreateSquads(g_team2player, sg_ostwind_pio, bp_vehicle_crew_german, _destination)

		local _destination = Util_GetRandomPosition(_destination, 20)
		Entity_CreateENV(bp_german_munitions, _destination, g_team1origin )
		local _destination = Util_GetRandomPosition(_destination, 5)
		Entity_CreateENV(bp_allied_supplies_01, _destination, g_team1origin )

		Command_SquadSquadAbility(g_team2player, sg_ostwind_pio, sg_ostwind, ABILITY_HULLDOWN, true, false)
		Cmd_AttackMove( sg_ostwind_pio, _destination, true )

		if AI_IsAIPlayer(g_team2player) then
			AI_LockSquads(g_team2player, sg_ostwind_pio)

		end
		SGroup_SetSelectable(sg_ostwind_pio, false)
		Rule_AddInterval(sg_ostwind_pio_status, 2)
	end

	function sg_ostwind_pio_status()
		if SGroup_IsAlive(sg_ostwind_pio) then
			local _squad = SGroup_GetSpawnedSquadAt(sg_ostwind_pio, 1)

			if Squad_GetHealthPercentage(_squad) < 0.6 then
				Cmd_Retreat(sg_ostwind_pio)
				SGroup_SetSelectable(sg_ostwind_pio, true)
				SGroup_Remove(sg_ostwind_pio, _squad)
			end
		else Rule_RemoveMe()
		end
	end


------Retreating Germans-----
	function retreating_germans_timer()
		if Timer_GetRemaining("tmr_event") <= 0 then
			Rule_RemoveMe()
			Timer_End("tmr_event")
			Objective_UpdateText(obj_events, Util_CreateLocString("German forces are in the area."), nil, false)


			local _voice_over = World_GetRand(1, 2)
			if _voice_over == 1 then
				Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11074930)	-- LOCDB [11074930] 'Contact!' - 'American Riflemen 1'
			elseif _voice_over == 2 then
				Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11074931)	-- LOCDB [11074931] 'Germans Spotted!' - 'American Riflemen 1'
			end

			retreating_germans_init()
		else
			Objective_UpdateText(obj_events, Util_CreateLocString("German forces are attempting to regroup to this area and will arrive in: " ..math.floor(Timer_GetRemaining("tmr_event")/		60)..":"..math.   floor	(math.floor(Timer_GetRemaining("tmr_event") % 60)/10)..math.floor(Timer_GetRemaining("tmr_event") % 60) - math.floor(math.floor		(Timer_GetRemaining	    ("tmr_event") % 60)/10) * 10), nil, false)
		end
	end
	function retreating_germans_init()
		local _retreat_interval = World_GetRand(1, 3)
		Rule_RemoveMe()
		Rule_AddOneShot(retreating_germans, _retreat_interval)
	end
	function retreating_germans()
		local _numbers = World_GetRand(3, 6)
		Util_CreateSquads(g_team2player, sg_retreating_germans, bp_retreating_grenadiers, g_team1origin, g_german_muster_position, 1, _numbers, false, g_team2startpos, nil, g_german_muster_position)
		local _health = World_GetRand(10 - _numbers, 10)/10
		local _squad = SGroup_GetSpawnedSquadAt(sg_retreating_germans, 1)
		Squad_SetHealth(_squad, _health)
		SGroup_Remove(sg_retreating_germans, _squad)
		Rule_RemoveMe()
		--g_retreating_counter = g_retreating_counter - 1
		if g_retreating_counter ~= 0 then 
			Rule_AddOneShot(retreating_germans_init, 1) 
			g_retreating_counter = g_retreating_counter - 1
		else 	
			g_retreating_counter = World_GetRand(1, 2)
			g_event_running = 2
		end
	end
------Evacuating Supplies-----
	---spawn covered truck from enemyorigin to muster_location, force move every second?
	---stop when near muster_point
	---start spawning supplies
	function manpower_truck_timer()
		if Timer_GetRemaining("tmr_event") <= 0 then
			Rule_RemoveMe()
			Timer_End("tmr_event")
			Objective_UpdateText(obj_events, Util_CreateLocString("German Supply Truck is in the area."), nil, false)

			Actor_PlaySpeech(ACTOR.Vastano, 11079776)      -- LOCDB [11079776] 'Move your asses goddamnit!  German convoy's up and running -- wipe it off the goddamn map…Now!'

			manpower_truck_init()
		else
			Objective_UpdateText(obj_events, Util_CreateLocString("Germans are moving supplies to this area and will arrive in: " ..math.floor(Timer_GetRemaining("tmr_event")/60)..":"..	math.   floor	(math.floor(Timer_GetRemaining("tmr_event") % 60)/10)..math.floor(Timer_GetRemaining("tmr_event") % 60) - math.floor(math.floor(Timer_GetRemaining	    	("tmr_event") % 60)/10) * 10), nil, false)
		end
	end

	function manpower_truck_init()
		Util_CreateSquads(g_team2player, sg_manpower_truck, bp_delivery_truck, g_team1origin, g_german_muster_position, 1, 1, false, g_team2startpos, nil, g_german_muster_position)
		Rule_AddInterval(manpower_truck_travel, 1)
	end

	function manpower_truck_travel()
		if SGroup_IsAlive(sg_manpower_truck) then
			Cmd_Move(sg_manpower_truck, g_german_muster_position)
			World_GetSquadsNearPoint(g_team2player, sg_near_muster, g_german_muster_position, 15, OT_Ally)
			SGroup_Filter(sg_near_muster, bp_delivery_truck, FILTER_KEEP)
			if SGroup_IsEmpty(sg_near_muster) == false then
				Rule_RemoveMe()
				Cmd_Stop(sg_manpower_truck)

				pos_manpower_truck_unload = SGroup_GetPosition(sg_manpower_truck)


				local _transport_truck_position = Squad_GetOffsetPosition(SGroup_GetSpawnedSquadAt(sg_manpower_truck, 1), 0, 1)
				Util_CreateSquads(g_team2player, {sg_manpower_haulers, sg_manpower_truck}, bp_vehicle_crew_german, _transport_truck_position, Util_GetOffsetPosition(pos_manpower_truck_unload, g_supply_unload_order, 1), 1, 2)

				if AI_IsAIPlayer(g_team2player) then
					AI_LockSquads(g_team2player, sg_manpower_truck)
		
				end
				SGroup_SetSelectable(sg_manpower_truck, false)

				Rule_AddInterval(manpower_truck_unload, 5)


			end
		else 
			Actor_PlaySpeech(ACTOR.Vastano, 11079774)     	 -- LOCDB [11079774] 'Smoked the enemy convoy before it could slip away…Right on the money boys!'
			Rule_RemoveMe()
			g_event_running = 2
		end
	end
	
	function manpower_truck_unload()
		--offset 3-5
		if SGroup_IsAlive(sg_manpower_truck) then
			if g_supply_unload_order <= 5 then
				local _unload_here = Util_GetRandomPosition(Util_GetOffsetPosition(pos_manpower_truck_unload, g_supply_unload_order, 2), 1)
				Util_CreateEntities(g_team2player, nil, bp_manpower_crates, _unload_here, 1)
				Cmd_Move(sg_manpower_haulers, _unload_here, true)
				Cmd_Move(sg_manpower_haulers, pos_manpower_truck_unload, true)
				g_supply_unload_order = g_supply_unload_order + 1

				if g_supply_unload_order == 6 then
					Command_SquadSquadLoad(g_team2player, sg_manpower_haulers, SCMD_Load, sg_manpower_truck, false, false)
				end
			else
				--Rule_RemoveMe()
				SGroup_DestroyAllSquads(sg_manpower_haulers)
				g_supply_unload_order = 3
				SGroup_AddAbility(sg_manpower_truck, ABILITY_WITHDRAW)
				Cmd_Ability(sg_manpower_truck, ABILITY_WITHDRAW)

				Actor_PlaySpeech(ACTOR.Vastano, 11079773)      -- LOCDB [11079773] 'Goddamnit! We couldn't hit the convoy before it bailed out… Hope this doesn't sink us.'

				local _squad = SGroup_GetSpawnedSquadAt(sg_manpower_truck, 1)
				SGroup_Remove(sg_manpower_truck, _squad)

			end
		else 
			if SGroup_IsAlive(sg_manpower_haulers) then
				Cmd_Retreat(sg_manpower_haulers)
				SGroup_SetSelectable(sg_manpower_haulers, true)
				SGroup_Remove(sg_manpower_haulers, SGroup_GetSpawnedSquadAt(sg_GermanPatrol, 1))
			end
			Rule_RemoveMe()
			g_event_running = 2
		end
	end

------Fuel Request to the front: TODO-----
------All Quiet on The Western Front-----
	function remarque_timer()
		if Timer_GetRemaining("tmr_event") <= 0 then
			Rule_RemoveMe()
			Timer_End("tmr_event")
			g_event_running = 2
		else
			Objective_UpdateText(obj_events, Util_CreateLocString("All Quiet on the Western Front..."), nil, false)
		end
	end
------Convoy going to reinforce the front: TODO-----
------Spawn supplies on every node if there are none (maybe also some mines?): TODO-----
	function spawn_loot()
		Rule_RemoveMe()		
		local point_loot = function(gid, idx, eid)
			_pointpos = Entity_GetPosition(eid)
			if World_IsTerritorySectorOwnedByPlayer( g_team2player, World_GetTerritorySectorID(_pointpos) ) == false and World_IsTerritorySectorOwnedByPlayer( 	g_team1player, World_GetTerritorySectorID(_pointpos) ) == false then
				local _loot_count = World_GetRand(0, 3)
				for i=1, _loot_count do
					local _pos = Util_GetRandomPosition(_pointpos, 15)
					Entity_CreateENV(Table_GetRandomItem(bp_loot), _pos, _pointpos)
					local _trap_chance = World_GetRand(0, 10)
					if _trap_chance == 10 then
						Entity_Create(bp_schu_mine, g_team2player, _pos, _pointpos)
					end
				end
			end
		end
		EGroup_ForEach(eg_CptPs, point_loot)

		local _timer = World_GetRand(16, 20)
		Rule_AddOneShot(spawn_loot, _timer*30)
	end

------Civilians: TODO-----
-- lose points for shooting them, have all squads have the option to hold fire, may use propaganda blasts to make them flee.
------Stranded Paras or Resistance Nest: TODO-----
------Obersoldaten Assault-----
	function obersoldaten_assault_timer()
		if Timer_GetRemaining("tmr_event") <= 0 then
			Rule_RemoveMe()
			Timer_End("tmr_event")

			Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11074931)	-- LOCDB [11074931] 'Germans Spotted!' - 'American Riflemen 1'


			Timer_Start("tmr_event", 240)
			obersoldaten_assault_init()
			Rule_AddInterval(obersoldaten_time_limit, 1)
		else
			Objective_UpdateText(obj_events, Util_CreateLocString("50 VPs: Elite German infantry will pass through the area: " ..math.floor(Timer_GetRemaining("tmr_event")/		60)..":"..math.   floor	(math.floor(Timer_GetRemaining("tmr_event") % 60)/10)..math.floor(Timer_GetRemaining("tmr_event") % 60) - math.floor(math.floor		(Timer_GetRemaining	    ("tmr_event") % 60)/10) * 10), nil, false)
		end
	end

	function obersoldaten_time_limit()
		if Timer_GetRemaining("tmr_event") <= 0 then
			Rule_RemoveMe()

			obersoldaten_aftermath(0)

		else
			Objective_UpdateText(obj_events, Util_CreateLocString("50 VPs: German units must reach destination in time: " ..math.floor(Timer_GetRemaining("tmr_event")/		60)..":"..math.   floor	(math.floor(Timer_GetRemaining("tmr_event") % 60)/10)..math.floor(Timer_GetRemaining("tmr_event") % 60) - math.floor(math.floor		(Timer_GetRemaining	    ("tmr_event") % 60)/10) * 10), nil, false)
		end
	end



	function obersoldaten_assault_init()
		Rule_RemoveMe()
		Util_CreateSquads(g_team2player, {sg_ober_assault_force, sg_ober_assault}, bp_ober_officer, g_team2origin, g_german_muster_position)
		Rule_AddOneShot(obersoldaten_assault_force_create, 3)
	end

	function obersoldaten_assault_force_create()
		Util_CreateSquads(g_team2player, {sg_ober_assault_force, sg_ober_assault}, {bp_ober_schreck, bp_ober_mp44,}, g_team2origin, g_german_muster_position, 2)
		Util_CreateSquads(g_team2player, {sg_ober_assault_force, sg_ober_assault}, {bp_ober_mg42, bp_ober_mp44,}, g_team2origin, g_german_muster_position, 2)
		g_ober_distance = 10
		g_ober_facing = 1
		Modify_UnitSpeed(sg_ober_assault_officer, 0.9)
		Rule_AddInterval(obersoldaten_sweep, 4)
	end

	function obersoldaten_sweep()

		if SGroup_IsAlive(sg_ober_assault) == false or SGroup_TotalMembersCount(sg_ober_assault_force)<5 then
				obersoldaten_aftermath(0)
				Rule_RemoveMe()
				return true
		else
			if SGroup_IsAlive(sg_ober_assault_officer) == false then
				local _squad = SGroup_GetRandomSpawnedSquad(sg_ober_assault)
				SGroup_Add(sg_ober_assault_officer, _squad)
				SGroup_Remove(sg_ober_assault, _squad)
			end

			Cmd_AttackMove(sg_ober_assault_officer, g_team1origin)
			Objective_RemoveUIElements(obj_events, UI_event_ping1)
			UI_event_ping1 = Objective_AddUIElements(obj_events, SGroup_GetPosition(sg_ober_assault_officer), true, Util_CreateLocString("German Assault Leader"), true, 3)

			g_ober_facing = 1
			g_ober_distance = 10
		
			local ober_formation = function(gid, idx, sid)
				--g_ober_distance = World_GetRand(2, 3)
				local _formation_pos = SGroup_GetOffsetPosition(sg_ober_assault_officer, g_ober_facing, g_ober_distance)
				SGroup_Add(sg_ober_assault_temp, sid)
				Cmd_Move(sg_ober_assault_temp, _formation_pos)
				SGroup_Remove(sg_ober_assault_temp, sid)
			
				if g_ober_facing == 1 then
					g_ober_facing = 7
				elseif g_ober_facing == 7 then
					g_ober_facing = 2
				elseif g_ober_facing == 2 then
					g_ober_facing = 6
				elseif g_ober_facing == 6 then
					g_ober_facing = 1
				end
			end
			SGroup_ForEach(sg_ober_assault, ober_formation)
		end


		World_GetSquadsNearPoint(g_team2player, sg_obers_at_obj, g_team1origin, 15, OT_Ally)
		SGroup_Filter(sg_obers_at_obj, {bp_ober_schreck, bp_ober_mp44, bp_ober_mg42, bp_ober_mp44, bp_ober_officer}, FILTER_KEEP)
		if SGroup_CountSpawned(sg_obers_at_obj) == SGroup_CountSpawned(sg_ober_assault_force) then
			obersoldaten_aftermath(SGroup_TotalMembersCount(sg_ober_assault_force))
			SGroup_DestroyAllSquads(sg_ober_assault_force)
			Rule_RemoveMe()
		end
	end

	function obersoldaten_aftermath(_success)

		Timer_End("tmr_event")
		Rule_RemoveIfExist(obersoldaten_sweep)
		Rule_RemoveIfExist(obersoldaten_time_limit)

		if _success == 0 then
			if SGroup_IsAlive(sg_ober_assault_force) then
				SGroup_AddAbility(sg_ober_assault_force, ABILITY_WITHDRAW)
				Cmd_Ability(sg_ober_assault_force, ABILITY_WITHDRAW)
			end

			local _voice_over = World_GetRand(1, 3)
			if _voice_over == 1 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079800) -- LOCDB [11079800] 'Fuck yeah -- nailed em'! Goddamn impressive work, boys!'
			elseif _voice_over == 2 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079797) -- LOCDB [11079797] 'German forces are rattled… One hell of a job, fellas.'
			else
				Actor_PlaySpeech(ACTOR.Vastano, 11079788) -- LOCDB [11079788] 'Good goddamn work! Now hold that crossing at all costs!'
			end


			local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(g_team1player)) + 50
			VPTicker_SetTeamTickers(Player_GetTeam(g_team1player), math.min(morale_boost, VPTickerData.start_points), true)
			Objective_UpdateText(obj_events, Util_CreateLocString("German assault was stopped. Allies gain 50 VPs."), nil, false)

			--total failure
		elseif _success < 10 then
			-- partial failure

			Objective_UpdateText(obj_events, Util_CreateLocString("Some Germans made it through, prolonging the stalemate. No VP change."), nil, false)
			Actor_PlaySpeech(ACTOR.Vastano, 11079818) -- LOCDB [11079818] 'Listen -- we gotta'  secure the sector.  Maintain the target areas -- show the Krauts we mean business!'

		else
			Objective_UpdateText(obj_events, Util_CreateLocString("The Germans reinforced their frontlines. Germans gain 50 VPs."), nil, false)
			
			local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(g_team2player)) + 50
			VPTicker_SetTeamTickers(Player_GetTeam(g_team2player), math.min(morale_boost, VPTickerData.start_points), true)
			

			--success

			local _voice_over = World_GetRand(1, 3)
			if _voice_over == 1 then
				Actor_PlaySpeech(ACTOR.Vastano, 11079798) -- LOCDB [11079798] 'Goddamnit -- they've beefed up their lines…We're outmatched…Bail out!'
			elseif _voice_over == 2 then
				Actor_PlaySpeech(ACTOR.Vastano,  11075718)	-- LOCDB [11075718] 'No.  The whole place is crawling with Germans.' - 'Lazzaro'
			else
				CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079813)	-- LOCDB [11079813] 'Goddamnit!  German's punched through our defenses.  Bail out…Now!'
			end
		end
		Rule_AddOneShot(obersoldaten_assault_delay, 30)
	end

	function obersoldaten_assault_delay()
		g_event_running = 2
	end



--------Armored Convoy----------------
function armoured_convoy_timer()
	if Timer_GetRemaining("tmr_event") <= 0 then
		Rule_RemoveMe()
		Timer_End("tmr_event")
		Objective_UpdateText(obj_events, Util_CreateLocString("50 VPs: German Armour Convoy is in the area."), nil, false)


		local _voice_over = World_GetRand(1, 2)
		if _voice_over == 1 then
			Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11075633) -- LOCDB [11075633] 'German Panzer reinforcements are rollin' in.' - 'Intel'
			Actor_PlaySpeech(ACTOR.Vastano, 11075771) -- LOCDB [11075771] 'Able Company!  Get your asses up front!  Give it to those  bastards!' - 'Lazzaro'
		elseif _voice_over == 2 then
			Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11075632) -- LOCDB [11075632] 'Enemy vehicles are being reported across the lines. Prepare for contact.' - 'Intel'
			Actor_PlaySpeech(ACTOR.Vastano, 11075771) -- LOCDB [11075771] 'Able Company!  Get your asses up front!  Give it to those  bastards!' - 'Lazzaro'
		end
		--Actor_PlaySpeech(ACTOR.Vastano, 11079776)      -- LOCDB [11079776] 'Move your asses goddamnit!  German convoy's up and running -- wipe it off the goddamn map…Now!'

		armoured_convoy_init()
	else
		Objective_UpdateText(obj_events, Util_CreateLocString("50 VPs: German Armour Convoy will arrive in:  " ..math.floor(Timer_GetRemaining("tmr_event")/60)..":"..	math.   floor	(math.floor(Timer_GetRemaining("tmr_event") % 60)/10)..math.floor(Timer_GetRemaining("tmr_event") % 60) - math.floor(math.floor(Timer_GetRemaining	    	("tmr_event") % 60)/10) * 10), nil, false)
	end
end

function armoured_convoy_init()
	g_tanks_numbers = 4
	g_tanks_spawned = 1
	g_tanks_safe = 0
	sg_tank_convoy = SGroup_CreateIfNotFound( "sg_tank_convoy" )
	sg_tanks_at_dest = SGroup_CreateIfNotFound( "sg_tanks_at_dest" )


	convoy_tanks = {
		BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:convoy_panther"),
		BP_GetSquadBlueprint("jagdtiger_td_squad_mp"),
		BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:convoy_ostwind"),
		BP_GetSquadBlueprint("6c196065c70546af8f51e48c1f0a0f75:convoy_panther"),
	}
	Rule_AddInterval(armoured_convoy_spawn, 3)
end

function armoured_convoy_spawn()
	if g_tanks_spawned == g_tanks_numbers+1 then
		Rule_RemoveMe()
		
		if AI_IsAIPlayer(g_team2player) then
			AI_LockSquads(g_team2player, sg_tank_convoy)

		end

		--Modify_UnitSpeed(sg_tank_convoy, 0.5)
		Rule_AddInterval(armoured_convoy_travel, 1)

	else
		Util_CreateSquads(g_team2player, sg_tank_convoy, convoy_tanks[g_tanks_spawned], g_convoy_origin, g_convoy_destination, 1, 1, false, g_convoy_origin_facing, nil, g_convoy_destination_facing)
		g_tanks_spawned = g_tanks_spawned + 1
	end

end

function armoured_convoy_travel()
	if SGroup_IsAlive(sg_tank_convoy) then

		Objective_RemoveUIElements(obj_events, UI_event_ping1)
		UI_event_ping1 = Objective_AddUIElements(obj_events, SGroup_GetPosition(sg_tank_convoy), true, Util_CreateLocString("German Armoured Column"), true, 3)

		Cmd_Move(sg_tank_convoy, g_convoy_destination)
		World_GetSquadsNearPoint(g_team2player, sg_tanks_at_dest, g_convoy_destination, 15, OT_Ally)
		SGroup_Filter(sg_tanks_at_dest, convoy_tanks, FILTER_KEEP)
		g_tanks_safe = g_tanks_safe + SGroup_CountSpawned(sg_tanks_at_dest)
		SGroup_DestroyAllSquads(sg_tanks_at_dest)

	else

		Rule_AddOneShot(armoured_convoy_aftermath, 1)
		Rule_RemoveMe()
	end
end

function armoured_convoy_aftermath()
	if g_tanks_safe == g_tanks_numbers then
		--success

		local _voice_over = World_GetRand(1, 2)
		if _voice_over == 1 then
			Actor_PlaySpeech(ACTOR.Vastano, 11079798) -- LOCDB [11079798] 'Goddamnit -- they've beefed up their lines…We're outmatched…Bail out!'
		else
			Actor_PlaySpeech(ACTOR.Vastano, 11079813)	-- LOCDB [11079813] 'Goddamnit!  German's punched through our defenses.  Bail out…Now!'
		end

		local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(g_team2player)) + 50
		VPTicker_SetTeamTickers(Player_GetTeam(g_team2player), math.min(morale_boost, VPTickerData.start_points), true)

		Objective_UpdateText(obj_events, Util_CreateLocString("Tanks made it to destination. Germans gain 50 VPs."), nil, false)
	elseif g_tanks_safe >= g_tanks_numbers - 2 then
		--stalemate
		Objective_UpdateText(obj_events, Util_CreateLocString("Some tanks escaped, prolonging the stalemate."), nil, false)
		Actor_PlaySpeech(ACTOR.Vastano, 11079818) -- LOCDB [11079818] 'Listen -- we gotta'  secure the sector.  Maintain the target areas -- show the Krauts we mean business!'

	else
		--fail
		local morale_boost = VPTicker_GetTeamTickers(Player_GetTeam(g_team1player)) + 50
		VPTicker_SetTeamTickers(Player_GetTeam(g_team1player), math.min(morale_boost, VPTickerData.start_points), true)

		local _voice_over = World_GetRand(1, 3)
		if _voice_over == 1 then
			Actor_PlaySpeech(ACTOR.Vastano, 11079800) -- LOCDB [11079800] 'Fuck yeah -- nailed em'! Goddamn impressive work, boys!'
		elseif _voice_over == 2 then
			Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11075658) -- LOCDB [11075658] 'They've lost too many vehicles. Their attack is stalled!' - 'American Captain'
		elseif _voice_over == 3 then
			Actor_PlaySpeech(ACTOR.Vastano, 11079760) -- LOCDB [11079760] 'Now that we've hit their vehicles the German's don't have the stomach for a fight…Fuckin' cowards are bailing out. Good job Able!'
		end

		Objective_UpdateText(obj_events, Util_CreateLocString("The armoured column was destroyed. Allies gain 50 VPs."), nil, false)
	end
	Rule_AddOneShot(armoured_convoy_delay, 30)
end

function armoured_convoy_delay()
	g_event_running = 2
end



	--[[
stranded paras
loop through sectors or get random sector
	if sector is not owned by player
		if sector (grab nearest building from position ~= null)
			spawn paras in building
			add_rule if player units are in proximity, gain control of paras

			EntityID  Util_GarrisonNearbyBuilding( SGroupID sgroup, Position pos, Real radius[, Boolean occupied, SGroup/Table filter] )
 	
Finds a nearby building to garrison. can ignore occupied [friendly] buildings. return ID of entity it found, or nil if not found 

Can also filter out groups not to occupy

]]--


--[[
	g_Sweep_Start = World_GetNearestInteractablePoint(g_team2origin, math.min(World_GetLength(), World_GetWidth()), math.min(World_GetLength(), World_GetWidth()) - 20))
	g_ConDest = Convoy_GetDest()

	g_team2origin
	
function Convoy_GetDest()
	local pot_pos = World_GetNearestInteractablePoint(Prox_GetRandomPosition(World_Pos(0, 0, 0), math.max(World_GetLength(), World_GetWidth()), math.min(World_GetLength(), World_GetWidth()) - 20))
	if Util_GetDistance(pot_pos, g_ConStart) <= math.min(World_GetLength(), World_GetWidth())/2 then
		return Convoy_GetDest()
	else
		return pot_pos
	end
end
--]]

----Audio stuff

-----------------------------------------------------------------------
-- Register the OnInit function w/ the SCAR system
-----------------------------------------------------------------------
Scar_AddInit( Main_Init )