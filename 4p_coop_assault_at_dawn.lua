import("ScarUtil.scar")


--[[ 

!Important!
This is a co-op scenario designed for 1-4 players.  Please place an AI into slot 8 and select a difficulty. Leave slots 5-7 empty.

Use the following settings:
No Mod(or use one at your risk)
Fixed Location
Standard Resources
Victory Point 500


Mission Brief:
Scouting runs have shown that the German's have dug in hard in order to keep this key road secure. We've received orders to dig em out and secure the road, we're expecting fierce resistence so stay sharp, the German's will not want to give up this sector without a fight.


Mission Objective:
- Clear out the Germans dug in around the road  
- Hold the Victory Point and repel any counter attacks


Difficulty affects:
Popcap 
Resource rate
Number of Enemies




Developer Note:
This is the first interactive scenario that I have created, I will be actively updating this map over the next couple months. I am keen to improve so I welcome all feedback no matter how harsh or constructive. I have big plans for more of these in the future so please share your thoughts.

Map designed, developed & coded by staiNz
]]--

function OnGameSetup()

	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	player5 = World_GetPlayerAt(5)
	player6 = World_GetPlayerAt(6)
	player7 = World_GetPlayerAt(7)
	player8 = World_GetPlayerAt(8)
	
	

end

function OnInit()

	-- Global Variables
		wave = 1
		ctr = 1
		diff = 0 -- difficulty setting
		mpval = 0 -- manpower value
		fuelval = 0 -- fuel value
		munival = 0 -- muni value
		popu4p = 0 -- population for 4 players 
		popu3 = 0 -- population for 3 players 
		popu2p = 0 -- population for 2 players 
		popu1p = 0 -- population for 1 player 
		numplayers = World_GetPlayerCount() - 1 -- number of players in the game 
		playercount = 0 -- number of ally players in the game
	
	AI_Enable(player8, false)
	getDifficultyOfAI()
	--FOW_RevealAll()
	Rule_AddOneShot(spawn_mgs, 1)
	Rule_AddOneShot(spawn_halftracks, 5)
	Rule_AddOneShot(spawn_grens, 15)
	Rule_AddOneShot(spawn_panzers, 20)
	Rule_AddOneShot(spawn_at_guns, 25)
	Rule_AddOneShot(spawn_obers, 10)
	Rule_AddOneShot(spawn_mortars, 30)
	Rule_AddOneShot(spawn_pgrens, 7)
	Rule_AddOneShot(pushback, 420)
	Rule_AddOneShot(pushback2, 500)
	Rule_AddOneShot(pushback3, 660)
	--Rule_AddOneShot(counter1, 300)
	--Rule_AddInterval(hugecounter, 200)
	Rule_AddInterval(begincounter, 5)
	Rule_AddInterval(timetimer, 1)
	Rule_AddInterval(sendwave, 1)
	ObjectiveHint()
	
	
	
	
	local ResourceSets = {
		standard = {
			--german:
			[0] = {
				manpower = 490,
				fuel = 20,
				munition = 0,
				action = 0,
				command = 1,
			},
			--soviet:
			[1] = {
				manpower = 490,
				fuel = 50,
				munition = 0,
				action = 0,
				command = 1,

			},
			--Obercommando west:
			[2] = {
				manpower = 240,
				fuel = 40,
				munition = 0,
				action = 0,
				command = 1,
			},
			--us forces:
			[3] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			--british forces:
			[4] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			income_modifier = {
				{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
			},
		},
		highResources = {
			--german:
			[0] = {
				manpower = 1390,
				fuel = 50,
				munition = 50,
				action = 0,
				command = 2,
			},
			--soviet:
			[1] = {
				manpower = 1390,
				fuel = 80,
				munition = 50,
				action = 0,
				command = 2,
			},
			--Obercommando west:
			[2] = {
				manpower = 1140,
				fuel = 70,
				munition = 50,
				action = 0,
				command = 2,
			},
			--us forces:
			[3] = {
				manpower = 1300,
				fuel = 45,
				munition = 50,
				action = 0,
				command = 2,
			},
			--british forces:
			[4] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			income_modifier = {
				{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
			},
		},
		customSet = {
			--german:
			[0] = {
				manpower = 490,
				fuel = 20,
				munition = 0,
				action = 0,
				command = 1,
			},
			--soviet:
			[1] = {
				manpower = 490,
				fuel = 50,
				munition = 0,
				action = 0,
				command = 1,

			},
			--Obercommando west:
			[2] = {
				manpower = 240,
				fuel = 40,
				munition = 0,
				action = 0,
				command = 1,
			},
			--us forces:
			[3] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			--british forces:
			[4] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			income_modifier = {
				{type = RT_Manpower, value = mpval, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Munition, value = munival, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Fuel, value = fuelval, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
			},
		},
		
	}
		--This will set the resource set to use in-game
		local g_ResourceSet = ResourceSets.customSet
		
		local Player_ApplyResourceSet = function(player, resourceSet)
			Player_SetResource(player, RT_Manpower, resourceSet.manpower)
			Player_SetResource(player, RT_Fuel, resourceSet.fuel)
			Player_SetResource(player, RT_Munition, resourceSet.munition)
			Player_SetResource(player, RT_Action, resourceSet.action)
			Player_SetResource(player, RT_Command, resourceSet.command)	
		end
		
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			local resource_set = g_ResourceSet[Player_GetRaceIndex(player)]
			Player_ApplyResourceSet(player, resource_set)
			for key, resource in ipairs(g_ResourceSet.income_modifier) do
				local _value = resource.value
				Modify_PlayerResourceRate(player, resource.type, _value, resource.math_type)
			end
		end
		
		--upkeep removed and pop cap implemented
		for i = 1, numplayers do
			local player = World_GetPlayerAt(i)
			Modify_Upkeep(player, 0.05)
			Player_SetPopCapOverride(player, g_popCapOverride)
		end

	end
	
function getDifficultyOfAI()
			
		if AI_GetDifficulty(player8) == 0 then
			if numplayers == 1 then
				playercount = 1
				diff = 0
				mpval = 3
				fuelval = 3
				munival = 3
				g_popCapOverride = 800
			elseif numplayers == 2 then
				playercount = 2
				diff = 0
				mpval = 2.5
				fuelval = 2.5
				munival = 2.5
				g_popCapOverride = 400
			elseif numplayers == 3 then
				playercount = 3
				diff = 0
				mpval = 2.25
				fuelval = 2.25
				munival = 2.25
				g_popCapOverride = 300
			else
				playercount = 4
				diff = 0
				mpval = 2
				fuelval = 2
				munival = 2
				g_popCapOverride = 250
			end
			
		elseif AI_GetDifficulty(player8) == 1 then
			if numplayers == 1 then
				playercount = 1
				diff = 1
				mpval = 2.5
				fuelval = 2.5
				munival = 2.5
				g_popCapOverride = 800
			elseif numplayers == 2 then
				playercount = 2
				diff = 1
				mpval = 2
				fuelval = 2
				munival = 2
				g_popCapOverride = 400
			elseif numplayers == 3 then
				playercount = 3
				diff = 1
				mpval = 2
				fuelval = 1.75
				munival = 1.75
				g_popCapOverride = 280
			else
				playercount = 4
				diff = 1
				mpval = 1.75
				fuelval = 1.5
				munival = 1.5
				g_popCapOverride = 225
			end
			
		elseif AI_GetDifficulty(player8) == 2 then
			if numplayers == 1 then
				playercount = 1
				diff = 2
				mpval = 2.25
				fuelval = 2
				munival = 2
				g_popCapOverride = 800
			elseif numplayers == 2 then
				playercount = 2
				diff = 2
				mpval = 1.75
				fuelval = 1.5
				munival = 1.5
				g_popCapOverride = 400
			elseif numplayers == 3 then
				playercount = 3
				diff = 2
				mpval = 1.5
				fuelval = 1.5
				munival = 1.5
				g_popCapOverride = 275
			else
				playercount = 4
				diff = 2
				mpval = 1.5
				fuelval = 1.5
				munival = 1.5
				g_popCapOverride = 225
			end
			
		elseif AI_GetDifficulty(player8) == 3 then
			if numplayers == 1 then
				playercount = 1
				diff = 3
				mpval = 1.8
				fuelval = 1.7
				munival = 1.7
				g_popCapOverride = 700
			elseif numplayers == 2 then
				playercount = 2
				diff = 3
				mpval = 1.5
				fuelval = 1.5
				munival = 1.5
				g_popCapOverride = 330
			elseif numplayers == 3 then
				playercount = 3
				diff = 3
				mpval = 1.4
				fuelval = 1.3
				munival = 1.3
				g_popCapOverride = 250
			else
				playercount = 4
				diff = 3
				mpval = 1.35
				fuelval = 1.25
				munival = 1.25
				g_popCapOverride = 200
			end
		end
	end
	
function Player_GetRaceIndex(player)
		local racename = Player_GetRaceName(player)
		if racename == "german" then
			return 0
		elseif racename == "soviet" then
			return 1
		elseif racename == "west_german" then
			return 2
		elseif racename == "aef" then
			return 3
		elseif racename == "british" then
			return 4
		else
			return 5
		end
end

Scar_AddInit(OnInit)

function spawn_mgs()

	--create squad group
	local sg_spawn_mg = SGroup_CreateIfNotFound("test")
	
	--create the blueprint of the MG42 team
	local bp_mg_squad = BP_GetSquadBlueprint("mg42_heavy_machine_gun_squad_mp")
	
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_1, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_2, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_3, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_4, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_5, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_6, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_7, nil, 1, 7, true, nil)
	Util_CreateSquads(player8, sg_spawn_mg, bp_mg_squad, mkr_mg_spwn_8, nil, 1, 7, true, nil)

	
end


function spawn_grens()

	--create squad group
	local sg_spawn_grens_1 = SGroup_CreateIfNotFound("grens_1")
	local sg_spawn_grens_2 = SGroup_CreateIfNotFound("grens_2")
	local sg_spawn_grens_3 = SGroup_CreateIfNotFound("grens_3")
	local sg_spawn_grens_4 = SGroup_CreateIfNotFound("grens_4")
	local sg_spawn_grens_5 = SGroup_CreateIfNotFound("grens_5")
	local sg_spawn_grens_6 = SGroup_CreateIfNotFound("grens_6")
	local sg_spawn_grens_7 = SGroup_CreateIfNotFound("grens_7")
	local sg_spawn_grens_8 = SGroup_CreateIfNotFound("grens_8")
	local sg_spawn_grens_9 = SGroup_CreateIfNotFound("grens_9")
	local sg_spawn_grens_10 = SGroup_CreateIfNotFound("grens_10")
	
	--create the blueprint of the MG42 team
	local bp_grens_squad = BP_GetSquadBlueprint("grenadier_squad_mp")
	
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_1, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_1, mkr_grens_spwn_1, true, nil, nil, nil, nil, 5)
		end 
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_2, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_2, mkr_grens_spwn_2, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_3) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_3, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_3, mkr_grens_spwn_3, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_4) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_4, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_4, mkr_grens_spwn_4, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_5) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_5, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_5, mkr_grens_spwn_5, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_6) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_6, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_6, mkr_grens_spwn_6, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_7) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_7, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_7, mkr_grens_spwn_7, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_8) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_8, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_8, mkr_grens_spwn_8, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_9) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_9, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_9, mkr_grens_spwn_9, true, nil, nil, nil, nil, 5)
		end
		
		--create a squad of grens and move them to the marker to find cover
		if SGroup_CountSpawned(sg_spawn_grens_10) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_grens_10, bp_grens_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_grens_10, mkr_grens_spwn_10, true, nil, nil, nil, nil, 5)
		end

	
end

function spawn_mortars()

	--create squad group
	local sg_spawn_mortar_1 = SGroup_CreateIfNotFound("mortar_1")
	local sg_spawn_mortar_2 = SGroup_CreateIfNotFound("mortar_2")
	local sg_spawn_mortar_3 = SGroup_CreateIfNotFound("mortar_3")
	local sg_spawn_leig_1 = SGroup_CreateIfNotFound("leig_1")
	local sg_spawn_leig_2 = SGroup_CreateIfNotFound("leig_2")
	local sg_spawn_leig_3 = SGroup_CreateIfNotFound("leig_3")
	
	--create the blueprint of the mortar team
	local bp_mortar_squad = BP_GetSquadBlueprint("mortar_team_81mm_mp")
	
	--create the blueprint of the infantry support gun
	local bp_isg_squad = BP_GetSquadBlueprint("le_ig_18_inf_support_gun_squad_mp")
	
		--create a squad of mortars and move them to the marker to setup
		if SGroup_CountSpawned(sg_spawn_mortar_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_mortar_1, bp_mortar_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_mortar_1, mkr_spwn_mtr_1, true, nil, nil, nil, nil, 5)
		end 
		
		--create a squad of mortars and move them to the marker to setup
		if SGroup_CountSpawned(sg_spawn_mortar_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_mortar_2, bp_mortar_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_mortar_2, mkr_spwn_mtr_2, true, nil, nil, nil, nil, 5)
		end 
		
		--create a squad of mortars and move them to the marker to setup
		if SGroup_CountSpawned(sg_spawn_mortar_3) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_mortar_3, bp_mortar_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_mortar_3, mkr_spwn_mtr_3, true, nil, nil, nil, nil, 5)
		end
		
		--create a infantry support gun and move it to the marker to setup
		if SGroup_CountSpawned(sg_spawn_leig_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_leig_1, bp_isg_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_leig_1, mkr_spwn_leig_1, true, nil, nil, nil, nil, 5)
		end

		--create a infantry support gun and move it to the marker to setup
		if SGroup_CountSpawned(sg_spawn_leig_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_leig_2, bp_isg_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_leig_2, mkr_spwn_leig_2, true, nil, nil, nil, nil, 5)
		end

		--create a infantry support gun and move it to the marker to setup
		if SGroup_CountSpawned(sg_spawn_leig_3) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_leig_3, bp_isg_squad, spawnpoint, nil, 1, 7, true, nil)
			Cmd_Move(sg_spawn_leig_3, mkr_spwn_leig_3, true, nil, nil, nil, nil, 5)
		end 		

	
end

function spawn_panzers()

	--create squad group
	local sg_spawn_tiger_1 = SGroup_CreateIfNotFound("Tiger_1")
	local sg_spawn_panzer_3 = SGroup_CreateIfNotFound("Panzer_3")
	local sg_spawn_fpanzer = SGroup_CreateIfNotFound("fpanzer")
	local sg_spawn_stug = SGroup_CreateIfNotFound("stug")
	local sg_spawn_stug2 = SGroup_CreateIfNotFound("stug2")
	
	--create the blueprint of the panzer 
	local bp_panzer4 = BP_GetSquadBlueprint("panzer_iv_squad_mp")
	
	--create the blueprint of the flakpanzer
	local bp_fpanzer = BP_GetSquadBlueprint("ostwind_squad_mp")
	
	--create the blueprint of the stug
	local bp_stug = BP_GetSquadBlueprint("stug_iii_squad_mp")
		
	--create the blueprint of the stug
	local bp_tiger = BP_GetSquadBlueprint("tiger_squad_mp")
	
		--create a tiger, move it and face it
		if SGroup_CountSpawned(sg_spawn_tiger_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_tiger_1, bp_tiger, spawnpoint, nil, 1, 2, true, nil, UPG.GERMAN.TIGER_TOP_GUNNER_MP)
			Cmd_Move(sg_spawn_tiger_1, mkr_tgr_1, true, nil, mkr_face_1)
			SGroup_IncreaseVeterancyRank(sg_spawn_tiger_1, 3, false)
			--[[Modify_ReceivedDamage(sg_spawn_tiger_1, 0.3)
			Modify_ReceivedAccuracy(sg_spawn_tiger_1, 0.5)]]--
			Modify_Vulnerability(sg_spawn_tiger_1, 0.4)
			Modify_SightRadius(sg_spawn_tiger_1, 1.9)
			--Modify_WeaponRange(sg_spawn_tiger_1, hardpoint_01, 1.5)
			
		end 
		
		--create a panzer, move it and face it
		if SGroup_CountSpawned(sg_spawn_panzer_3) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_panzer_3, bp_panzer4, spawnpoint, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
			Cmd_Move(sg_spawn_panzer_3, mkr_p4_3, true, nil, mkr_face_road)
		end
		
		--create a fpanzer, move it and face it
		if SGroup_CountSpawned(sg_spawn_fpanzer) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_fpanzer, bp_fpanzer, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_fpanzer, mkr_spwn_flakp, true, nil, mkr_flakp_face)
		end
		
		--create a stug, move it and face it
		if SGroup_CountSpawned(sg_spawn_stug) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_stug, bp_stug, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_stug, mkr_spwn_stug, true, nil, mkr_face_l1)
		end
		
		--create a stug, move it and face it
		if SGroup_CountSpawned(sg_spawn_stug2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_stug2, bp_stug, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_stug2, mkr_spwn_stug2, true, nil, mkr_face_r)
		end

	
end

function spawn_halftracks()

	--create squad group
	local sg_spawn_251_1 = SGroup_CreateIfNotFound("251_1")
	local sg_spawn_251_2 = SGroup_CreateIfNotFound("251_2")
	local sg_spawn_mht_1 = SGroup_CreateIfNotFound("mht_1")
	local sg_spawn_flaktrak_1 = SGroup_CreateIfNotFound("flaktrak_1")
	local sg_spawn_flaktrak_2 = SGroup_CreateIfNotFound("flaktrak_2")
	
	--create the blueprint of the halftrack 
	local bp_vehicle_251 = BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp")
	
	--create the blueprint of the mortar halftrack 
	local bp_vehicle_mht = BP_GetSquadBlueprint("mortar_250_halftrack_squad_mp")
	
	--create the blueprint of the mortar halftrack 
	local bp_vehicle_flaktrak = BP_GetSquadBlueprint("sdkfz_251_17_flak_halftrack_squad_mp")
	
		--create a halftrack and move it to the marker and face a marker. Upgrade with flame package.
		if SGroup_CountSpawned(sg_spawn_251_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_251_1, bp_vehicle_251, spawnpoint, nil, 1, 2, true, nil, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP)
			Cmd_Move(sg_spawn_251_1, mkr_spwn_251_1, true, nil, mkr_face_l1)
		end 
		
		--create a halftrack and move it to the marker and face a marker. Upgrade with flame package.
		if SGroup_CountSpawned(sg_spawn_251_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_251_2, bp_vehicle_251, spawnpoint, nil, 1, 2, true, nil, UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP)
			Cmd_Move(sg_spawn_251_2, mkr_spwn_251_2, true, nil, mkr_face_l1)
		end
		
		--create a mortar halftrack and move it to the marker and face a marker. 
		if SGroup_CountSpawned(sg_spawn_mht_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_mht_1, bp_vehicle_mht, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_mht_1, mkr_spwn_mht, true, nil, mkr_face_l2)
		end
		
		--create a flak halftrack and move it to the marker and face a marker. 
		if SGroup_CountSpawned(sg_spawn_flaktrak_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_flaktrak_1, bp_vehicle_flaktrak, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_flaktrak_1, mkr_spwn_flaktrak1, true, nil, mkr_face_l1)
		end
		
		--create a flak halftrack and move it to the marker and face a marker. 
		if SGroup_CountSpawned(sg_spawn_flaktrak_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_flaktrak_2, bp_vehicle_flaktrak, spawnpoint, nil, 1, 2, true, nil)
			Cmd_Move(sg_spawn_flaktrak_2, mkr_spwn_flaktrak2, true, nil, mkr_face_r)
		end
		

	
end

function spawn_at_guns()


	--create squad group
	local sg_spawn_at_1 = SGroup_CreateIfNotFound("atgun1")
	local sg_spawn_at_2 = SGroup_CreateIfNotFound("atgun2")
	local sg_spawn_at_3 = SGroup_CreateIfNotFound("atgun3")
	local sg_spawn_at_4 = SGroup_CreateIfNotFound("atgun4")
	local sg_spawn_at_5 = SGroup_CreateIfNotFound("atgun5")
	local sg_spawn_at_6 = SGroup_CreateIfNotFound("atgun6")
	local sg_spawn_at_7 = SGroup_CreateIfNotFound("atgun7")
	local sg_spawn_at_8 = SGroup_CreateIfNotFound("atgun8")
	
	--create the blueprint of the Pak Gun
	local bp_atgun = BP_GetSquadBlueprint("pak40_75mm_at_gun_squad_mp")
	
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_1) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_1, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_1, mkr_at_1, true, nil, mkr_face_l1)
		end 
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_2) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_2, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_2, mkr_at_2, true, nil, mkr_face_l2)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_3) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_3, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_3, mkr_at_3, true, nil, mkr_face_road)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_4) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_4, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_4, mkr_at_4, true, nil, mkr_face_l2)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_5) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_5, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_5, mkr_at_5, true, nil, mkr_face_l1)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_6) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_6, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_6, mkr_at_6, true, nil, mkr_face_r)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_7) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_7, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_7, mkr_at_7, true, nil, mkr_face_r)
		end
		
		--create a pak and move them to the marker and set them to face the marker
		if SGroup_CountSpawned(sg_spawn_at_8) == 0 then
			random_spawns()
			Util_CreateSquads(player8, sg_spawn_at_8, bp_atgun, spawnpoint, nil, 1, 5, true, nil)
			Cmd_Move(sg_spawn_at_8, mkr_at_8, true, nil, mkr_face_r)
		end

	
end

function spawn_pgrens()

	local sg_spawn_pgrens_1 = SGroup_CreateIfNotFound("Pgrens_1")
	local sg_spawn_pgrens_2 = SGroup_CreateIfNotFound("Pgrens_2")
	local sg_spawn_pgrens_3 = SGroup_CreateIfNotFound("Pgrens_3")
	local sg_spawn_pgrens_4 = SGroup_CreateIfNotFound("Pgrens_4")
	local sg_spawn_pgrens_5 = SGroup_CreateIfNotFound("Pgrens_5")
	local sg_spawn_pgrens_6 = SGroup_CreateIfNotFound("Pgrens_6")
	local sg_spawn_pgrens_7 = SGroup_CreateIfNotFound("Pgrens_7")
	
	--create the blueprint of the pgren squad
	local bp_pgrens = BP_GetSquadBlueprint("panzer_grenadier_squad_mp")
	
		if SGroup_CountSpawned(sg_spawn_pgrens_1) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_1, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_1, mkr_spwn_pgrens_1, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_pgrens_2) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_2, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_2, mkr_spwn_pgrens_2, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_pgrens_3) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_3, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_3, mkr_spwn_pgrens_3, true, nil, nil, nil, nil, 5)
		end
		
		if SGroup_CountSpawned(sg_spawn_pgrens_4) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_4, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_4, mkr_spwn_pgrens_4, true, nil, nil, nil, nil, 5)
		end
		
		if SGroup_CountSpawned(sg_spawn_pgrens_5) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_5, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_5, mkr_spwn_pgrens_5, true, nil, nil, nil, nil, 5)
		end
		
		if SGroup_CountSpawned(sg_spawn_pgrens_6) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_6, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_6, mkr_spwn_pgrens_6, true, nil, nil, nil, nil, 5)
		end
		
		if SGroup_CountSpawned(sg_spawn_pgrens_7) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_pgrens_7, bp_pgrens, spawnpoint, nil, 1, 5, true, nil, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP)
				Cmd_Move(sg_spawn_pgrens_7, mkr_spwn_pgrens_7, true, nil, nil, nil, nil, 5)
		end
	
end

function spawn_obers()

	local sg_spawn_obers_1 = SGroup_CreateIfNotFound("Obers_1")
	local sg_spawn_obers_2 = SGroup_CreateIfNotFound("Obers_2")
	local sg_spawn_obers_3 = SGroup_CreateIfNotFound("Obers_3")
	local sg_spawn_obers_4 = SGroup_CreateIfNotFound("Obers_4")
	local sg_spawn_obers_5 = SGroup_CreateIfNotFound("Obers_5")
	local sg_spawn_obers_6 = SGroup_CreateIfNotFound("Obers_6")
	local sg_spawn_obers_7 = SGroup_CreateIfNotFound("Obers_7")
	
	--create the blueprint of the obers squad
	local bp_obers = BP_GetSquadBlueprint("obersoldaten_squad_mp")
	
		if SGroup_CountSpawned(sg_spawn_obers_1) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_1, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_1, mkr_ober1, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_2) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_2, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_2, mkr_ober2, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_3) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_3, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_3, mkr_ober3, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_4) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_4, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_4, mkr_ober4, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_5) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_5, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_5, mkr_ober5, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_6) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_6, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_6, mkr_ober6, true, nil, nil, nil, nil, 5)
		end
	
		if SGroup_CountSpawned(sg_spawn_obers_7) == 0 then
				random_spawns()
				Util_CreateSquads(player8, sg_spawn_obers_7, bp_obers, spawnpoint, nil, 1, 5, true, nil, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP)
				Cmd_Move(sg_spawn_obers_7, mkr_ober7, true, nil, nil, nil, nil, 5)
		end
	
end

function pushback()

	--create squad group
	local sg_spawn_luchs_1 = SGroup_CreateIfNotFound("Luchs1")
	local sg_spawn_puma_1 = SGroup_CreateIfNotFound("Puma1")
	local sg_spawn_luchs_2 = SGroup_CreateIfNotFound("Luch2")
	local sg_spawn_puma_2 = SGroup_CreateIfNotFound("Puma2")
	local sg_spawn_volks_1 = SGroup_CreateIfNotFound("Volks1")
	local sg_spawn_volks_2 = SGroup_CreateIfNotFound("Volks2")
	local sg_spawn_volks_3 = SGroup_CreateIfNotFound("Volks3")
	local sg_spawn_volks_4 = SGroup_CreateIfNotFound("Volks4")
	
	--create the blueprint of the Luchs 
	local bp_luchs = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp")
	--create the blueprint of the Puma 
	local bp_puma = BP_GetSquadBlueprint("puma_east_german_mp")
	--create the blueprint of the Volksgrens 
	local bp_volks = BP_GetSquadBlueprint("volksgrenadier_squad_mp")

	
		--create a volks squad and attack move point1
		if SGroup_CountSpawned(sg_spawn_volks_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_1, bp_volks, mkr_spawn_r2, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_1, point1, true, nil, 15)
		end 
		
		--create a volks squad and attack move point1
		if SGroup_CountSpawned(sg_spawn_volks_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_2, bp_volks, mkr_spawn_r, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_2, point2, true, nil, 15)
		end 
		
		--create a volks squad and attack move point3
		if SGroup_CountSpawned(sg_spawn_volks_3) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_3, bp_volks, mkr_spawn_l, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_3, point3, true, nil, 15)
		end

		--create a volks squad and attack move point3
		if SGroup_CountSpawned(sg_spawn_volks_4) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_4, bp_volks, mkr_spawn_l2, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_4, point2, true, nil, 15)
		end		
		
		--create a luchs and attack move point1
		if SGroup_CountSpawned(sg_spawn_luchs_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs_1, bp_luchs, mkr_spawn_r, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_luchs_1, point1, true, nil, 15)
		end
		
		--create a luchs and attack move point3
		if SGroup_CountSpawned(sg_spawn_luchs_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs_2, bp_luchs, mkr_spawn_l, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_luchs_2, point3, true, nil, 15)
		end
		
		--create a puma and attack move point1
		if SGroup_CountSpawned(sg_spawn_puma_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma_1, bp_puma, mkr_spawn_r, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_puma_1, point1, true, nil, 15)
		end
		
		--create a puma and attack move point3
		if SGroup_CountSpawned(sg_spawn_puma_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma_2, bp_puma, mkr_spawn_l, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_puma_2, point3, true, nil, 15)
		end
	

	
end



function pushback2()

	--create squad group
	local sg_spawn_222 = SGroup_CreateIfNotFound("2221")
	local sg_spawn_222_1= SGroup_CreateIfNotFound("2222")
	local sg_spawn_222_2 = SGroup_CreateIfNotFound("2223")
	local sg_spawn_222_3 = SGroup_CreateIfNotFound("2224")
	local sg_spawn_250 = SGroup_CreateIfNotFound("2501")
	local sg_spawn_250_1 = SGroup_CreateIfNotFound("2502")
	local sg_spawn_250_2 = SGroup_CreateIfNotFound("2503")
	local sg_spawn_250_3 = SGroup_CreateIfNotFound("2504")
	
	--create the blueprint of the Luchs 
	local bp_222 = BP_GetSquadBlueprint("scoutcar_sdkfz222_mp")
	--create the blueprint of the Puma 
	local bp_250 = BP_GetSquadBlueprint("infantry_250_halftrack_mp")
		
		--create a 222 and attack move point1
		if SGroup_CountSpawned(sg_spawn_222) == 0 then
			Util_CreateSquads(player8, sg_spawn_222, bp_222, mkr_spawn_r, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_222, point1, true, nil, 15)
		end
		
		--create a 222 and attack move point1
		if SGroup_CountSpawned(sg_spawn_222_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_222_1, bp_222, mkr_spawn_r2, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_222_1, point1, true, nil, 15)
		end
		
		--create a 222 and attack move point3
		if SGroup_CountSpawned(sg_spawn_222_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_222_2, bp_222, mkr_spawn_l, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_222_2, point3, true, nil, 15)
		end
		
		--create a 222 and attack move point3
		if SGroup_CountSpawned(sg_spawn_222_3) == 0 then
			Util_CreateSquads(player8, sg_spawn_222_3, bp_222, mkr_spawn_l3, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_222_3, point3, true, nil, 15)
		end
		
		--create a 250 and attack move point1
		if SGroup_CountSpawned(sg_spawn_250) == 0 then
			Util_CreateSquads(player8, sg_spawn_250, bp_250, mkr_spawn_c2, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_250, point1, true, nil, 15)
		end
		
		--create a 250 and attack move point1
		if SGroup_CountSpawned(sg_spawn_250_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_250_1, bp_250, mkr_spawn_r3, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_250_1, point1, true, nil, 15)
		end
		
		--create a 250 and attack move point3
		if SGroup_CountSpawned(sg_spawn_250_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_250_2, bp_250, mkr_spawn_c5, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_250_2, point3, true, nil, 15)
		end
		
		--create a 250 and attack move point3
		if SGroup_CountSpawned(sg_spawn_250_3) == 0 then
			Util_CreateSquads(player8, sg_spawn_250_3, bp_250, mkr_spawn_l3, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_250_3, point3, true, nil, 15)
		end
	

	
end


function pushback3()

	--create squad group
	local sg_spawn_pzj = SGroup_CreateIfNotFound("pzj1")
	local sg_spawn_pzj_1= SGroup_CreateIfNotFound("pzj2")
	local sg_spawn_pzj_2 = SGroup_CreateIfNotFound("pzj3")
	local sg_spawn_pzj_3= SGroup_CreateIfNotFound("pzj4")
	local sg_spawn_pzj_4 = SGroup_CreateIfNotFound("pzj5")
	local sg_spawn_pzj_5 = SGroup_CreateIfNotFound("pzj6")
	
	--create the blueprint of the Pz4 J 
	local bp_pzj = BP_GetSquadBlueprint("panzer_iv_ausf_j_battle_group_mp")
	
	
	--create a Pz4J and attack move point1 and point2
		if SGroup_CountSpawned(sg_spawn_pzj) == 0 then
			Util_CreateSquads(player8, sg_spawn_pzj, bp_pzj, mkr_spawn_r, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
			Cmd_AttackMove(sg_spawn_pzj, point1, true, nil, 15)
		end
		
		
		if SGroup_CountSpawned(sg_spawn_pzj_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_pzj_1, bp_pzj, mkr_spawn_l, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
			Cmd_AttackMove(sg_spawn_pzj_1, point2, true, nil, 15)
		end
		
		if diff == 2 or diff == 3 then
			if numplayers > 1 then 
				if SGroup_CountSpawned(sg_spawn_pzj_2) == 0 then
					Util_CreateSquads(player8, sg_spawn_pzj_2, bp_pzj, mkr_spawn_r3, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
					Cmd_AttackMove(sg_spawn_pzj_2, point3, true, nil, 15)
				end
			end
			
			if numplayers > 2 then 
				if SGroup_CountSpawned(sg_spawn_pzj_3) == 0 then
					Util_CreateSquads(player8, sg_spawn_pzj_3, bp_pzj, mkr_spawn_l3, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
					Cmd_AttackMove(sg_spawn_pzj_3, point3, true, nil, 15)
				end
			end
			
			if numplayers > 3 then
				if SGroup_CountSpawned(sg_spawn_pzj_5) == 0 then
					Util_CreateSquads(player8, sg_spawn_pzj_5, bp_pzj, mkr_spawn_l, nil, 1, 2, true, nil, UPG.GERMAN.PANZER_TOP_GUNNER_MP)
					Cmd_AttackMove(sg_spawn_pzj_5, point1, true, nil, 15)
				end
			end
		end
	
	
end

function hugecounter()
	
	if ctr == 1 then
		if EGroup_IsCapturedByPlayer(vpoint, player8, true) == false then
			executecounter()
			ctr = ctr + 1
		end
	end
	
end


function begincounter()
	
	if ctr == 1 then
		if EGroup_IsCapturedByPlayer(vpoint, player8, true) == false then
			starttime()
			ctr = ctr + 1
		end
	end
	
end

function starttime()
	
	tmr = "myTimer"
	inftimer_1 = "time_1"
	
	
	Timer_Start(tmr, 10)
	
end

function timetimer()
	Timer_Display(tmr)
	Timer_DisplayOnScreen(tmr)
end

function sendwave()
	sg_spawn_group_1 = SGroup_CreateIfNotFound("group_1")
	sg_spawn_group_2 = SGroup_CreateIfNotFound("group_2")
	sg_spawn_group_3 = SGroup_CreateIfNotFound("group_3")
	sg_spawn_group_4 = SGroup_CreateIfNotFound("group_4")
	sg_spawn_group_5 = SGroup_CreateIfNotFound("group_5")
	sg_spawn_group_6 = SGroup_CreateIfNotFound("group_6")
	sg_spawn_group_7 = SGroup_CreateIfNotFound("group_7")
	sg_spawn_group_8 = SGroup_CreateIfNotFound("group_8")
	sg_spawn_group_9 = SGroup_CreateIfNotFound("group_9")
	sg_spawn_group_10 = SGroup_CreateIfNotFound("group_10")
	sg_spawn_group_11 = SGroup_CreateIfNotFound("group_11")
	sg_spawn_group_12 = SGroup_CreateIfNotFound("group_12")
	sg_spawn_group_13 = SGroup_CreateIfNotFound("group_13")
	sg_spawn_group_14 = SGroup_CreateIfNotFound("group_14")
	sg_spawn_group_15 = SGroup_CreateIfNotFound("group_15")
	sg_spawn_group_16 = SGroup_CreateIfNotFound("group_16")
	sg_spawn_group_17 = SGroup_CreateIfNotFound("group_17")
	sg_spawn_group_18 = SGroup_CreateIfNotFound("group_18")
	sg_spawn_group_19 = SGroup_CreateIfNotFound("group_19")
	sg_spawn_group_20 = SGroup_CreateIfNotFound("group_20")
	sg_spawn_group_21 = SGroup_CreateIfNotFound("group_21")
	sg_spawn_group_22 = SGroup_CreateIfNotFound("group_22")
	sg_spawn_group_23 = SGroup_CreateIfNotFound("group_23")
	sg_spawn_group_24 = SGroup_CreateIfNotFound("group_24")
	sg_spawn_group_25 = SGroup_CreateIfNotFound("group_25")
	sg_spawn_group_26 = SGroup_CreateIfNotFound("group_26")
	sg_spawn_group_27 = SGroup_CreateIfNotFound("group_27")
	sg_spawn_group_28 = SGroup_CreateIfNotFound("group_28")
	sg_spawn_group_29 = SGroup_CreateIfNotFound("group_29")
	sg_spawn_group_30 = SGroup_CreateIfNotFound("group_30")
	
	if wave == 1 then
		addtime()
	end
	
	if Timer_GetRemaining(tmr) <= 0 then
		-- First Wave no panzers
		if wave > 1 and wave < 10 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_fusi_g43()
					squad_fusi_shreks()
					squad_obers()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_fusi_g43()
					squad_fusi_shreks()
					squad_obers()
					squad_puma()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_3
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_fusi_g43()
					squad_fusi_shreks()
					squad_obers()
					squad_flak_halftrack()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_4
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_fusi_g43()
					squad_volks()
					squad_luchs()
					squad_obers()
					addtimeCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_5
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_fusi_shreks()
						squad_volks()
						squad_puma()
						squad_fusi_g43()
						squad_obers()
						addtimeCount()
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_6
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_222()
							squad_222()
							squad_251_flame()
							squad_luchs()
							squad_puma()
							addtimeNoCount()
					end
				end
			end
			
		end
		
		-- First Break 
		if wave == 10 then
			addtimeBetweenWaves()
		end
		
		-- Second Wave -- no volks
		if wave > 10 and wave < 20 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_fusi_g43()
					squad_p4_okw()
					squad_obers()
					squad_puma()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_fusi_shreks()
					squad_fusi_g43()
					squad_luchs()
					squad_puma()
					squad_obers()
					squad_hetzer()
					addtimeCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_3
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_fusi_g43()
						squad_p4_okw()
						squad_p4_ost()
						squad_obers()
						squad_hetzer()
						squad_luchs()
						squad_puma()
						addtimeCount()
				end
			end
			
			tempsgroup = sg_spawn_group_4
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_fusi_shreks()
					squad_fusi_g43()
					squad_p4_okw()
					squad_luchs()
					squad_obers()
					squad_hetzer()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_5
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_obers()
					squad_fusi_g43()
					squad_puma()
					squad_p4_ost()
					squad_fusi_g43()
					squad_luchs()
					addtimeCount()
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_6
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_222()
							squad_222()
							squad_251_flame()
							squad_luchs()
							squad_puma()
							squad_hetzer()
							addtimeNoCount()
					end
				end
			end
			
		end
		
		
		-- Second Break
		if wave == 20 then
			addtimeBetweenWaves()
		end
		
		
		-- Third Set of Waves - no fusiliers
		if wave > 20 and wave < 40 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_brummbar()
					squad_obers()
					squad_puma()
					squad_p4_okw()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_obers()
					squad_puma()
					squad_p4_ost()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_3
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_obers()
					squad_puma()
					squad_p4_okw()
					addtimeCount()
			end
			
			tempsgroup = sg_spawn_group_4
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_obers()
					squad_puma()
					squad_brummbar()
					squad_p4_okw()
					squad_panther()
					addtimeCount()
			end
			
			if numplayers > 1 then
				tempsgroup = sg_spawn_group_5
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_obers()
						squad_volks()
						squad_puma()
						squad_p4_ost()
						squad_p4_okw()
						squad_panther()
						addtimeCount()
				end
			end
				
			tempsgroup = sg_spawn_group_6
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_luchs()
					squad_obers()
					squad_volks()
					squad_puma()
					squad_p4_okw()
					squad_panther()
					addtimeCount()
			end
			
			if diff > 1 then
				tempsgroup = sg_spawn_group_7
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_luchs()
						squad_obers()
						squad_volks()
						squad_puma()
						squad_p4_ost()
						squad_p4_okw()
						squad_panther()
						addtimeCount()
				end
			end
			
			tempsgroup = sg_spawn_group_8
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_luchs()
					squad_volks()
					squad_obers()
					squad_p4_okw()
					squad_panther()
					addtimeCount()
			end
			
			if diff > 0 then
					tempsgroup = sg_spawn_group_9
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_luchs()
							squad_volks()
							squad_obers()
							squad_p4_okw()
							squad_panther()
							addtimeCount()
					end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_10
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_puma()
							squad_volks()
							squad_obers()
							squad_p4_okw()
							squad_panther()
							addtimeCount()
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_11
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_brummbar()
							squad_panzercommandtank()
							squad_obers()
							addtimeNoCount()
					end
				end
			end
			
		end
		
		-- Third Break
		if wave == 40 then
			addtimeBetweenWaves()
		end
		
		
		if wave == 41 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_tiger()
					squad_p4_ost()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_p4_ost()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_3
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_volks()
					squad_tiger()
					addtimeNoCount()
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_4
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_volks()
							squad_tiger()
							addtimeNoCount()
					end
				end
			end
			
			tempsgroup = sg_spawn_group_5
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_obers()
					squad_volks()
					squad_panther()
					addtimeNoCount()
			end
			tempsgroup = sg_spawn_group_6
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_luchs()
					squad_volks()
					addtimeNoCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_7
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_luchs()
						squad_p4_ost()
						squad_tiger()
						squad_volks()
						addtimeNoCount()
				end
			end
			
			tempsgroup = sg_spawn_group_8
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_luchs()
					squad_p4_ost()
					squad_tiger()
					squad_volks()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_9
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_luchs()
					squad_p4_ost()
					squad_tiger()
					squad_volks()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_10
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_puma()
					squad_brummbar()
					squad_p4_ost()
					squad_volks()
					addtimeNoCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_12
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_tiger()
						squad_volks()
						squad_panther()
						addtimeNoCount()
				end
			end
				
			tempsgroup = sg_spawn_group_13
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_tiger()
					squad_volks()
					addtimeNoCount()
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_11
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_tiger()
							squad_volks()
							squad_panther()
							addtimeCount()
					end
				end
			end
			
		end
		
		-- Third Break
		if wave == 42 then
			addtimeBetweenWaves()
		end
		
		
		if wave == 43 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_okw()
					squad_tiger()
					squad_panther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_brummbar()
					squad_tiger()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_3
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_p4_okw()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_4
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_p4_okw()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_5
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_p4_okw()
					squad_panther()
					addtimeNoCount()
			end
			tempsgroup = sg_spawn_group_6
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_p4_okw()
					addtimeNoCount()
			end
			
			if diff > 1 then
				tempsgroup = sg_spawn_group_7
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_p4_okw()
						squad_p4_ost()
						squad_tiger()
						squad_panther()
						addtimeNoCount()
				end
			end
			
			if diff > 2 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_8
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_p4_okw()
							squad_p4_ost()
							squad_panther()
							squad_tiger()
							addtimeNoCount()
					end
				end
			end
			
			tempsgroup = sg_spawn_group_9
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_okw()
					squad_p4_ost()
					squad_tiger()
					squad_panther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_10
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_puma()
					squad_brummbar()
					squad_p4_ost()
					squad_p4_okw()
					addtimeNoCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_12
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_tiger()
						squad_puma()
						squad_panther()
						addtimeNoCount()
				end
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_13
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_tiger()
						squad_p4_okw()
						addtimeNoCount()
				end
			end
			
			if diff > 1 then
				tempsgroup = sg_spawn_group_11
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_p4_ost()
						squad_tiger()
						squad_panther()
						addtimeCount()
				end
			end
			
		end
		
		-- final Break
		if wave == 44 then
			addtimeBetweenWaves2()
		end
		
		if wave == 45 then
			tempsgroup = sg_spawn_group_1
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_okw()
					squad_tiger()
					squad_commandpanther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_2
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_brummbar()
					squad_tiger()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_3
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_jagdpanzer()
					squad_commandpanther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_4
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_jagdpanzer()
					squad_commandpanther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_5
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_commandpanther()
					squad_panther()
					addtimeNoCount()
			end
			tempsgroup = sg_spawn_group_6
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_ost()
					squad_commandpanther()
					addtimeNoCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_7
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_commandpanther()
						squad_p4_ost()
						squad_tiger()
						squad_panther()
						addtimeNoCount()
				end
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_8
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_commandpanther()
						squad_p4_ost()
						squad_panther()
						squad_tiger()
						addtimeNoCount()
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_9
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_commandpanther()
							squad_p4_ost()
							squad_tiger()
							squad_panther()
							addtimeNoCount()
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_10
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_puma()
							squad_brummbar()
							squad_p4_ost()
							squad_commandpanther()
							addtimeNoCount()
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_12
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_tiger()
							squad_puma()
							squad_panther()
							addtimeNoCount()
					end
				end
			end
		
			if numplayers > 1 then
				tempsgroup = sg_spawn_group_13
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_tiger()
						squad_commandpanther()
						addtimeNoCount()
				end
			end
			
			if numplayers > 1 then
				tempsgroup = sg_spawn_group_11
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_p4_ost()
						squad_tiger()
						squad_panther()
						addtimeCount()
				end
			end
			
		end
		
		-- final Break
		if wave == 46 then
			addtimeBetweenWaves2()
		end
		
		if wave == 47 then
			tempsgroup = sg_spawn_group_20
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_fusi_g43()
					squad_obers()
					squad_p4_ost()
					squad_kingtiger()
					squad_volks()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_21
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_p4_okw()
					squad_elefant()
					squad_volks()
					squad_panther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_23
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_jagdtiger()
					squad_tiger()
					squad_volks()
					squad_panther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_24
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_kingtiger()
					squad_obers()
					squad_volks()
					squad_panther()
					addtimeNoCount()
			end
			
			tempsgroup = sg_spawn_group_25
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_tiger()
					squad_fusi_g43()
					squad_volks()
					squad_panther()
					addtimeNoCount()
			end
			
			if numplayers > 1 then
				tempsgroup = sg_spawn_group_26
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_kingtiger()
						squad_fusi_g43()
						squad_volks()
						addtimeNoCount()
				end
			end
			
			tempsgroup = sg_spawn_group_27
			if SGroup_CountSpawned(tempsgroup) == 0 then
					squad_kingtiger()
					squad_volks()
					addtimeNoCount()
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_28
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_kingtiger()
						squad_obers()
						squad_volks()
						squad_p4_ost()
						addtimeNoCount()
				end
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_29
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_kingtiger()
						squad_fusi_g43()
						squad_volks()
						squad_p4_ost()
						addtimeNoCount()
				end
			end
			
			if diff > 0 then
				tempsgroup = sg_spawn_group_30
				if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_tiger()
						squad_obers()
						squad_volks()
						addtimeNoCount()
				end
			end
			
			if diff > 2 then
				if numplayers > 1 then 
					tempsgroup = sg_spawn_group_17
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_p4_okw()
							squad_p4_ost()
							squad_tiger()
							squad_panther()
							squad_elefant()
							squad_jagdtiger()
							addtimeNoCount()
					
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then 
					tempsgroup = sg_spawn_group_18
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_fusi_g43()
							squad_obers()
							squad_p4_ost()
							squad_kingtiger()
							squad_volks()
							addtimeNoCount()
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then 
					tempsgroup = sg_spawn_group_19
					if SGroup_CountSpawned(tempsgroup) == 0 then
							squad_jagdpanzer()
							squad_commandpanther()
							squad_elefant()
							squad_jagdtiger()
							addtimeNoCount()
					end
				end
			end
			
			if diff > 1 then
				if numplayers > 1 then
					tempsgroup = sg_spawn_group_16
					if SGroup_CountSpawned(tempsgroup) == 0 then
						squad_panzercommandtank()
						squad_fusi_shreks()
						addtimeNoCount()		
					end
				end
			end
				
		end
	
	end

end


function squad_volks()
	-- Volks
	bp_squad_1 = BP_GetSquadBlueprint("volksgrenadier_squad_mp")
	
	tempbp = bp_squad_1
	squad_count = 6
	squad_upgrade = UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE
	num_squad = 1
	num = 1
	check_squads()

end

function squad_fusi_g43()
	-- Fusiliers -- G43s
	bp_squad_1a = BP_GetSquadBlueprint("panzerfusilier_squad_mp")
	
	tempbp = bp_squad_1a
	squad_count = 6
	squad_upgrade = UPG.WEST_GERMAN.PANZERFUSILIER_G43
	num_squad = 1
	num = 1
	check_squads()

end

function squad_fusi_shreks()
	-- Fusiliers -- Shreks
	bp_squad_1b = BP_GetSquadBlueprint("panzerfusilier_squad_mp")
	
	tempbp = bp_squad_1b
	squad_count = 5
	squad_upgrade = UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP
	num_squad = 1
	num = 1
	check_squads()

end

function squad_obers()
	-- obers
	bp_squad_2 = BP_GetSquadBlueprint("obersoldaten_squad_mp")
	
	tempbp = bp_squad_2
	squad_count = 4
	squad_upgrade = UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP
	num_squad = 1
	num = 1
	check_squads()

end

function squad_luchs()
	-- Panzer2
	bp_squad_3 = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp")
	
	tempbp = bp_squad_3
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_222()
	-- 222 scoutcar
	bp_squad_222 = BP_GetSquadBlueprint("scoutcar_sdkfz222_mp")
	
	tempbp = bp_squad_222
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_251_flame()
	-- 251 flame halftrack
	bp_squad_251 = BP_GetSquadBlueprint("sdkfz_251_halftrack_squad_mp")
	
	tempbp = bp_squad_251
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP
	check_squads()

end

function squad_flak_halftrack()
	-- Flak Halftrack
	bp_squad_3a = BP_GetSquadBlueprint("sdkfz_251_17_flak_halftrack_squad_mp")
	
	tempbp = bp_squad_3a
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_puma()
	-- Puma
	bp_squad_4 = BP_GetSquadBlueprint("puma_east_german_mp")
	
	tempbp = bp_squad_4
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_hetzer()
	-- Hetzer
	bp_squad_4b = BP_GetSquadBlueprint("hetzer_squad_mp")
	
	tempbp = bp_squad_4b
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_tiger()
	-- Tiger
	bp_squad_5 = BP_GetSquadBlueprint("tiger_squad_mp")
	
	tempbp = bp_squad_5
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end


function squad_tiger_ace()
	-- Tiger Ace
	bp_tiger_ace = BP_GetSquadBlueprint("tiger_ace_squad_mp")
	
	tempbp = bp_tiger_ace
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_brummbar()
	-- Tiger
	bp_squad_5a = BP_GetSquadBlueprint("brummbar_squad_mp")
	
	tempbp = bp_squad_5a
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_p4_ost()
	-- Panzer4
	bp_squad_6 = BP_GetSquadBlueprint("panzer_iv_squad_mp")
	
	tempbp = bp_squad_6
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_jagdpanzer()
	-- JagdP
	bp_squad_6 = BP_GetSquadBlueprint("jagdpanzer_tank_destroyer_squad_mp")
	
	tempbp = bp_squad_6
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_p4_okw()
	-- Panzer4J
	bp_squad_7 = BP_GetSquadBlueprint("panzer_iv_ausf_j_battle_group_mp")
	
	tempbp = bp_squad_7
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_panther()
	-- Panther
	bp_squad_7a = BP_GetSquadBlueprint("panther_squad_mp")
	
	tempbp = bp_squad_7a
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_commandpanther()
	-- Command Panther
	bp_squad_7b = BP_GetSquadBlueprint("panther_commander_squad_mp")
	
	tempbp = bp_squad_7b
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end





function squad_kingtiger()
	-- King Tiger
	bp_squad_8 = BP_GetSquadBlueprint("king_tiger_squad_mp")
	
	tempbp = bp_squad_8
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end

function squad_elefant()
	-- Elefant
	bp_squad_8a = BP_GetSquadBlueprint("elefant_tank_destroyer_squad_mp")
	
	tempbp = bp_squad_8a
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end


function squad_panzercommandtank()
	-- panzercommandtank
	bp_squad_panzercommandtank = BP_GetSquadBlueprint("panzer_iv_command_squad_mp")
	
	tempbp = bp_squad_panzercommandtank
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = nil
	check_squads()

end



function squad_jagdtiger()
	-- Jagdtiger
	bp_squad_8b = BP_GetSquadBlueprint("jagdtiger_td_squad_mp")
	
	tempbp = bp_squad_8b
	squad_count = 1
	num_squad = 1
	num = 1
	squad_upgrade = UPG.WEST_GERMAN.JAGDTIGER_ENGINE_IMPROVEMENTS_I_MP
	check_squads()

end





function check_squads()
	local i = 0
	if Timer_GetRemaining(tmr) <= 0 then
		while i < num do
			getPaths()
			Util_CreateSquads(player8, tempsgroup, tempbp, spoint, nil, num_squad, squad_count, true, nil, squad_upgrade)
			Cmd_SquadPath(tempsgroup, spath, true, LOOP_NONE, true, 0)
			i = i + 1
		end
	end
	


end

function addtime()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 60)
			wave = wave + 1
		end
	end

end

function addtimeBetweenWaves()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 60)
			wave = wave + 1
		end
	end

end

function addtimeBetweenWaves2()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 220)
			wave = wave + 1
		end
	end

end

function addtimeNoCount()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 2)
		end
	end

end

function addtimeCount()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 6)
			wave = wave + 1
		end
	end

end


function addtimeNextWave()
	
	
	if Timer_GetRemaining(tmr) <= 0 then
		if Timer_Exists(tmr) == true then
			Timer_Start(tmr, 180)
			wave = wave + 1
		end
	end

end


	


function executecounter()

	--create squad group
	local sg_spawn_luchs = SGroup_CreateIfNotFound("Luchs")
	local sg_spawn_luchs2 = SGroup_CreateIfNotFound("Luchs2")
	local sg_spawn_puma = SGroup_CreateIfNotFound("Pumas")
	local sg_spawn_puma2 = SGroup_CreateIfNotFound("Pumas2")
	local sg_spawn_volks = SGroup_CreateIfNotFound("Volks1")
	local sg_spawn_volks2 = SGroup_CreateIfNotFound("Volks2")
	local sg_spawn_tigers = SGroup_CreateIfNotFound("Tigers")
	local sg_spawn_tigers2 = SGroup_CreateIfNotFound("Tigers2")
	local sg_spawn_tigers3 = SGroup_CreateIfNotFound("Tigers3")
	
	
	--create the blueprint of the Luchs 
	local bp_luchs = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp")
	--create the blueprint of the Puma 
	local bp_puma = BP_GetSquadBlueprint("puma_east_german_mp")
	--create the blueprint of the Volksgrens 
	local bp_volks = BP_GetSquadBlueprint("volksgrenadier_squad_mp")
	
	--create bp of tigers
	local bp_tigers = BP_GetSquadBlueprint("tiger_squad_mp")

	
		--create a volks squad and attack move point1
		if SGroup_CountSpawned(sg_spawn_volks) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks, bp_volks, mkr_spawn_l, point1, 5, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			--Cmd_AttackMove(sg_spawn_volks, point1, true, nil, 15)
		end 
		
		--create a volks squad and attack move point3
		if SGroup_CountSpawned(sg_spawn_volks2) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks2, bp_volks, mkr_spawn_r, point3, 5, 6, true, nil, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE)
			--Cmd_AttackMove(sg_spawn_volks, point1, true, nil, 15)
		end

			
		
		--create a luchs and attack move point1
		if SGroup_CountSpawned(sg_spawn_luchs) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs, bp_luchs, mkr_spawn_c2, point3, 4, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_luchs, point3, true, nil, 15)
		end
		
		--create a luchs and attack move point1
		if SGroup_CountSpawned(sg_spawn_luchs2) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs2, bp_luchs, mkr_spawn_l2, point1, 4, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_luchs, point3, true, nil, 15)
		end
		
		--create a puma and attack move point1
		if SGroup_CountSpawned(sg_spawn_puma) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma, bp_puma, mkr_spawn_c1, point1, 4, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_puma, point1, true, nil, 15)
		end
		
		--create a puma and attack move point1
		if SGroup_CountSpawned(sg_spawn_puma2) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma2, bp_puma, mkr_spawn_c2, point3, 3, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_puma, point1, true, nil, 15)
		end
		
		--create a tiger and attack move point3
		if SGroup_CountSpawned(sg_spawn_tigers) == 0 then
			Util_CreateSquads(player8, sg_spawn_tigers, bp_tigers, mkr_spawn_r2, point3, 5, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_tigers, point3, true, nil, 15)
		end
		
		--create a tiger and attack move point3
		if SGroup_CountSpawned(sg_spawn_tigers3) == 0 then
			Util_CreateSquads(player8, sg_spawn_tigers3, bp_tigers, mkr_spawn_r3, vpoint, 5, 6, true, nil)
			--Cmd_AttackMove(sg_spawn_tigers, point3, true, nil, 15)
		end

	
end

--[[function counter1_inf()

	--create squad group
	local sg_spawn_ostr1 = SGroup_CreateIfNotFound("Obst1")
	local sg_spawn_ostr2 = SGroup_CreateIfNotFound("Obst2")
	local sg_spawn_ostr3 = SGroup_CreateIfNotFound("Obst3")
	local sg_spawn_ostr4 = SGroup_CreateIfNotFound("Obst4")
	local sg_spawn_ostr5 = SGroup_CreateIfNotFound("Obst1")
	local sg_spawn_ostr6 = SGroup_CreateIfNotFound("Obst2")
	local sg_spawn_ostr7 = SGroup_CreateIfNotFound("Obst3")
	local sg_spawn_ostr8 = SGroup_CreateIfNotFound("Obst4")
	
	
	--create the blueprint of the Ostruppen 
	local bp_ostr = BP_GetSquadBlueprint("panzer_ii_luchs_squad_mp")
	
	--create the blueprint of the Sturm Officer 
	local bp_puma = BP_GetSquadBlueprint("puma_east_german_mp")
	--create the blueprint of the Volksgrens 
	local bp_volks = BP_GetSquadBlueprint("volksgrenadier_squad_mp")

	
		--create a volks squad and attack move point1
		if SGroup_CountSpawned(sg_spawn_volks_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_1, bp_volks, mkr_spawn_r, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_1, point1, true, nil, 15)
		end 
		
		--create a volks squad and attack move point1
		if SGroup_CountSpawned(sg_spawn_volks_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_2, bp_volks, mkr_spawn_r, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_2, point1, true, nil, 15)
		end 
		
		--create a volks squad and attack move point3
		if SGroup_CountSpawned(sg_spawn_volks_3) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_3, bp_volks, mkr_spawn_l, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_3, point3, true, nil, 15)
		end

		--create a volks squad and attack move point3
		if SGroup_CountSpawned(sg_spawn_volks_4) == 0 then
			Util_CreateSquads(player8, sg_spawn_volks_4, bp_volks, mkr_spawn_l, nil, 1, 6, true, nil, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP)
			Cmd_AttackMove(sg_spawn_volks_4, point3, true, nil, 15)
		end		
		
		--create a luchs and attack move point1
		if SGroup_CountSpawned(sg_spawn_luchs_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs_1, bp_luchs, mkr_spawn_r, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_luchs_1, point1, true, nil, 15)
		end
		
		--create a luchs and attack move point3
		if SGroup_CountSpawned(sg_spawn_luchs_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_luchs_2, bp_luchs, mkr_spawn_l, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_luchs_2, point3, true, nil, 15)
		end
		
		--create a puma and attack move point1
		if SGroup_CountSpawned(sg_spawn_puma_1) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma_1, bp_puma, mkr_spawn_r, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_puma_1, point1, true, nil, 15)
		end
		
		--create a puma and attack move point3
		if SGroup_CountSpawned(sg_spawn_puma_2) == 0 then
			Util_CreateSquads(player8, sg_spawn_puma_2, bp_puma, mkr_spawn_l, nil, 1, 6, true, nil)
			Cmd_AttackMove(sg_spawn_puma_2, point3, true, nil, 15)
		end
	

	
end
]]--

function random_spawns()

	local spwnpnt = World_GetRand(1, 4)
	spawnpoint = nil
	
	if spwnpnt == 1 then
		spawnpoint = mkr_spawn_l
	elseif spwnpnt == 2 then
		spawnpoint = mkr_spawn_c1
	elseif spwnpnt == 3 then
		spawnpoint = mkr_spawn_c2
	elseif spwnpnt == 4 then
		spawnpoint = mkr_spawn_r
	end
	
end

function getPaths()

	dest = World_GetRand(1, 11)
	spoint = nil
	spath =  nil
		
		if dest == 1 then
			spoint = mkr_spawn_l3
			spath = "path_left3"
		elseif dest == 2 then
			spoint = mkr_spawn_l2
			spath = "path_left2"
		elseif dest == 3 then
			spoint = mkr_spawn_l
			spath = "path_left1"
		elseif dest == 4 then
			spoint = mkr_spawn_c1
			spath = "path_centerleft"
		elseif dest == 5 then
			spoint = mkr_spawn_c2
			spath = "path_centerright"
		elseif dest == 6 then
			spoint = mkr_spawn_r
			spath = "path_right1"
		elseif dest == 7 then
			spoint = mkr_spawn_r2
			spath = "path_right2"
		elseif dest == 8 then
			spoint = mkr_spawn_r3
			spath = "path_right3"
		elseif dest == 9 then
			spoint = mkr_spawn_c3
			spath = "path_center3"
		elseif dest == 10 then
			spoint = mkr_spawn_c4
			spath = "path_center4"
		elseif dest == 11 then
			spoint = mkr_spawn_c5
			spath = "path_center5"
		end
		
	
end


function random_spawns_right()

	local spwnpnt = World_GetRand(1, 3)
	rightspawn = nil
	
	if spwnpnt == 1 then
		spawnpoint = mkr_spawn_r
	elseif spwnpnt == 2 then
		spawnpoint = mkr_spawn_r2
	elseif spwnpnt == 3 then
		spawnpoint = mkr_spawn_r3
	end
	
end

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function ObjectiveHint()
	local ObjHint = Util_CreateLocString("The Germans will try to recapture this point")
    HintMouseover_Add(ObjHint, vpoint, 5, true)
end