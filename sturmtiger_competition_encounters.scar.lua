
function Map_SetupEncounters()
	enc_EnemySpawnDefences = function(spawn, path)
		local encData = {
			name = "enemy defend", 
			player = enemyPlayer,
			spawn = spawn, 
			units = { 
				{
					name = "zis gun", 
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = 4,
				},
				{
					name = "guards",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = 1,
				},
				{
					name ="sniper",
					sbp = SBP.SOVIET.SNIPER_TEAM_MP,
					numSquads = 1,
				},
				{
					name ="SU-85",
					sbp = SBP.SOVIET.SU_85_MP,
					numSquads = 1,
				},
			},
			goal = { 
				name = "Defend", 
				target = defend, 
				attackMove = false,
				patrolParams = {
					path = path,
					wait = 3,
				},
			},
			onDeath = function(encounter)
				Map_SpawnEnemySpawnDefenders(spawn, path)
			end,
		}
		return Encounter:Create(encData)
	end
	enc_MunitionEvent = function(eventConfig)
		local encData = {
			name = "enemy munition cap", 
			player = enemyPlayer,
			spawn = eventConfig.spawn, 
			sgroups = {sg_munition_event_units},
			units = Table_GetRandomItem(g_munitionEventUnits),
			goal = { 
				name = "Defend", 
				range = 30,
				leashRange = 15,
				coordinatedSetup = true,
				coordinatedMoveRadius = 40,
				retaliateAttacks = true,
				useSkirmishAI = true,
				tacticControlsList = {
					{
						tacticType = TACTIC_Recrew,
						priority = 50,
					},
					{
						tacticType = TACTIC_Pickup,
						priority = 300,
						retryTimeSecs = 2,
						waitTimeSecs = 2,
					},
					{
						tacticType = TACTIC_Avoid,
						priority = -1,
					},
				},
				tacticTargetPreference = AITacticTargetPreference_Best,
				target = eventConfig.mkr, 
				attackMove = true,
				maxIdleTime = 1,
			},
		}

		return Encounter:Create(encData)
	end
	
	WAVES[1] = function(spawnpos)
		local encData = {
			name = "Enemy wave 1 attack", 
			player = enemyPlayer,
			spawn = spawnpos, 
			sgroups = {sg_wave_units},
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 2, 2, 3}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 3}),
				},
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "M3A1",
					sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 2, 3, 3}),
				},
			},
		}
		return Encounter:Create(encData)     
	end

	WAVES[2] = function(spawnpos)
		local encData = {
			name = "Enemy wave 2 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 2, 2, 3}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 3}),
				},
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 2}),
				},
				{
					name = "M3A1",
					sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
			},
		}
		return Encounter:Create(encData)     
	end

	WAVES[3] = function(spawnpos)
		local encData = {
			name = "Enemy wave 3 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = 1,
				},
				{
					name = "T34-76",
					sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
					numSquads = Mission_GetDifVar({0, 1, 2, 3}),
				},
				{
					name = "T34-85",
					sbp = SBP.SOVIET.T_34_85_SQUAD_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},
				{
					name = "M3A1",
					sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
			},
		}
		return Encounter:Create(encData)     
	end
	
	WAVES[4] = function(spawnpos)
		local encData = {
			name = "Enemy wave 4 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-76",
					sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-85",
					sbp = SBP.SOVIET.T_34_85_SQUAD_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},
				{
					name = "KV-1",
					sbp = SBP.SOVIET.KV_1_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},				
			},
		}
		return Encounter:Create(encData)     
	end
	
	WAVES[5] = function(spawnpos)
		local encData = {
			name = "Enemy wave 5 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 2}),
				},
				{
					name = "T34-76",
					sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-85",
					sbp = SBP.SOVIET.T_34_85_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 2}),
				},		
			},
		}
		return Encounter:Create(encData)     
	end
	
	WAVES[6] = function(spawnpos)
		local encData = {
			name = "Enemy wave 6 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "SU-85",
					sbp = SBP.SOVIET.SU_85_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 2}),
				},
				{
					name = "KV-1",
					sbp = SBP.SOVIET.KV_1_MP,
					numSquads = Mission_GetDifVar({0, 1, 2, 3}),
				},	
			},
		}
		return Encounter:Create(encData)     
	end	
	WAVES[7] = function(spawnpos)
		local encData = {
			name = "Enemy wave 7 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
				{
					name = "M3A1",
					sbp = SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 2, 4, 4}),
				},
			},
		}
		return Encounter:Create(encData)     
	end
	WAVES[8] = function(spawnpos)
		local encData = {
			name = "Enemy wave 8 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
				{
					name = "SU-85",
					sbp = SBP.SOVIET.SU_85_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},
				{
					name = "KV-1",
					sbp = SBP.SOVIET.KV_1_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},	
				{
					name = "IS-2",
					sbp = SBP.SOVIET.IS_2_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
				{
					name = "KV-2",
					sbp = SBP.SOVIET.KV_2_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 2}),
				},
			},
		}
		return Encounter:Create(encData)     
	end
	WAVES[9] = function(spawnpos)
		local encData = {
			name = "Enemy wave 9 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},
				{
					name = "parti poopers",
					sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
				{
					name = "Zis",
					sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-76",
					sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-85",
					sbp = SBP.SOVIET.T_34_85_SQUAD_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},
				{
					name = "SU-85",
					sbp = SBP.SOVIET.SU_85_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},
				{
					name = "KV-1",
					sbp = SBP.SOVIET.KV_1_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},	
				{
					name = "IS-2",
					sbp = SBP.SOVIET.IS_2_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},	
			},
		}
		return Encounter:Create(encData)     
	end
	WAVES[10] = function(spawnpos)
		local encData = {
			name = "Enemy wave 10 attack", 
			player = enemyPlayer,
			spawn = spawnpos,  
			sgroups = {sg_wave_units},
			
			units = { 
				{
					name = "guard",
					sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
					numSquads = Mission_GetDifVar({1, 1, 2, 2}),
				},		
				{
					name = "SU-76",
					sbp = SBP.SOVIET.SU_76M_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 1}),
				},
				{
					name = "T34-85",
					sbp = SBP.SOVIET.T_34_85_SQUAD_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},
				{
					name = "SU-85",
					sbp = SBP.SOVIET.SU_85_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},
				{
					name = "IS-2",
					sbp = SBP.SOVIET.IS_2_MP,
					numSquads = Mission_GetDifVar({0, 0, 1, 1}),
				},			
				{
					name = "KV-2",
					sbp = SBP.SOVIET.KV_2_MP,
					numSquads = Mission_GetDifVar({0, 1, 1, 1}),
				},			
				{
					name = "ISU-152",
					sbp = SBP.SOVIET.ISU_152_MP,
					numSquads = Mission_GetDifVar({1, 1, 1, 2}),
				},
			},
		}
		return Encounter:Create(encData)     
	end
end

function MunitionEventUnitsConfig()
	g_munitionEventUnits = {
		{
			{
				name = "zis gun", 
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},
			{
				name = "guards",
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
				numSquads = Mission_GetDifVar({1, 1, 2, 2}),
			},
			{
				name ="SU-76",
				sbp = SBP.SOVIET.SU_76M_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},
			{
				name ="partisans",
				sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},	
		},
		{
			{
				name = "zis gun", 
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},
			{
				name = "guards",
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
				numSquads = Mission_GetDifVar({1, 1, 2, 2}),
			},
			{
				name ="SU-85",
				sbp = SBP.SOVIET.SU_85_MP,
				numSquads = Mission_GetDifVar({0, 1, 1, 1}),
			},
			{
				name ="partisans",
				sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},	
		},
		{
			{
				name = "zis gun", 
				sbp = SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD_MP,
				numSquads = Mission_GetDifVar({0, 1, 1, 1}),
			},
			{
				name = "guards",
				sbp = SBP.SOVIET.GUARDS_TROOPS_MP,
				numSquads = Mission_GetDifVar({1, 1, 2, 2}),
			},
			{
				name ="T34-76",
				sbp = SBP.SOVIET.T_34_76_SQUAD_MP,
				numSquads =  Mission_GetDifVar({0, 1, 1, 1}),
			},
			{
				name ="partisans",
				sbp = SBP.SOVIET.PARTISANS_PANZERSCHRECK_MP,
				numSquads = Mission_GetDifVar({1, 1, 1, 1}),
			},	
		},
	}
end
