
function Waves_Setup()

	t_random_direction = {NORTH, SOUTH}
	t_random_direction_02 = {EAST, WEST}
	t_random_direction_03 = {CROSS, NORTH, SOUTH}
	
	-- Initial Direction
	wave_direction = World_GetRand(1, 2)
	
	if wave_direction == 1 then
		initial_direction = NORTH
		secondary_direction = SOUTH
	else
		initial_direction = SOUTH
		secondary_direction = NORTH
	end
	
	preset_random_direction = Table_GetRandomItem(t_random_direction) -- Random North or South Direction
	preset_random_direction_02 = Table_GetRandomItem(t_random_direction_02) -- Random East or West Direction
	-- Wave 1
	__t_waveDefenseData.t_waves[1] = {
		{
			direction = initial_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},			
				{sbp = SBP.GERMAN.PIONEER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = initial_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},			
				{sbp = SBP.GERMAN.PIONEER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
	}

	-- Wave 2
	__t_waveDefenseData.t_waves[2] = {
		{
			direction = secondary_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP},dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},			
				{sbp = SBP.GERMAN.PIONEER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = secondary_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},		
				{sbp = SBP.GERMAN.PIONEER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 3
	__t_waveDefenseData.t_waves[3] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = Table_GetRandomItem(t_random_direction), 
			units = {
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 1, exclusive = true,}}},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 0, exclusive = true,}}},
				
			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 4
	__t_waveDefenseData.t_waves[4] = {
		{
			direction = preset_random_direction_02, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},	
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},	
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}},		
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = preset_random_direction_02, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},	
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},					
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}},		
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
	}
	
	-- Wave 5
	__t_waveDefenseData.t_waves[5] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = Table_GetRandomItem(t_random_direction_03), 
			units = {
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
--~ 		{
--~ 			direction = SOUTH, 
--~ 			units = {
--~ 				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
--~ 			},
--~ 			hint = WAVE_INFANTRY,
--~ 		},
--~ 		{
--~ 			direction = Table_GetRandomItem(t_random_direction), 
--~ 			units = {
--~ 				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
--~ 				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.25, exclusive = true,}}},
--~ 			},
--~ 			hint = WAVE_INFANTRY,
--~ 		},
	}
	-- Wave 6
	__t_waveDefenseData.t_waves[6] = {
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD},			
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}},
			},
			hint = WAVE_INFANTRY,
		},
	}


	-- Wave 7
	__t_waveDefenseData.t_waves[7] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle, sg_Captureable},},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.15, exclusive = true,}}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.15, exclusive = true,}}},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle, sg_Captureable},},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.15, exclusive = true,}}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG_MP, dropChance = 0.15, exclusive = true,}}},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = Table_GetRandomItem(t_random_direction_03), 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},

			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 8
	__t_waveDefenseData.t_waves[8] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = Table_GetRandomItem(t_random_direction_03), 
			units = {
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_ARTILLERY,
		},
	}
	-- Wave 9
	__t_waveDefenseData.t_waves[9] = {
		{
			direction = NORTH, 
			units = {
--~ 				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 1, exclusive = true,}}},
				{sbp = SBP.GERMAN.PIONEER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}, dropItems = {{slotItem = SLOT_ITEM.PIONEER_FLAMETHROWER_MP, dropChance = 1, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}},
			},
			hint = WAVE_INFANTRY,
		},
		
		{
			direction = CROSS, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PIONEER_SQUAD, slotItems = {SLOT_ITEM.PIONEER_FLAMETHROWER_MP}},
			},
			hint = WAVE_INFANTRY,
		},
		
		
	}
	-- Wave 10
	__t_waveDefenseData.t_waves[10] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 1, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 0.25, exclusive = true,}}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
	}
	-- Wave 11
	__t_waveDefenseData.t_waves[11] = {
		{
			direction = CROSS, 
			units = {
				{sbp = SBP.GERMAN.STUG_III_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = EAST, 
			units = {
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_ARTILLERY,
		},
		{
			direction = WEST, 
			units = {
				{sbp = SBP.GERMAN.MORTAR_TEAM_81MM},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_ARTILLERY,
		},
		{
			direction = CROSS, 
			units = {
--~ 				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
--~ 				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 12 
	__t_waveDefenseData.t_waves[12] = {
		{
			direction = Table_GetRandomItem(t_random_direction_03), 
			units = {
--~ 				{sbp = SBP.GERMAN.PANZER_IV_SQUAD, slotItems = {SLOT_ITEM.MG42_TURRET_MOUNTED_PZIV}, sgroups = {sg_Vehicle},},
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle},},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, },
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 1, exclusive = true,}}},
			},
			hint = WAVE_MIXED,
			
		},
		{
			direction = Table_GetRandomItem(t_random_direction_02), 
			units = {
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle},},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 1, exclusive = true,}}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD,slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, },
			},
			hint = WAVE_VEHICLES,
		},
--~ 		{
--~ 			direction = SOUTH, 
--~ 			units = {
--~ 				{sbp = SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, sgroups = {sg_Vehicle},},
--~ 				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 1, exclusive = true,}}},
--~ 				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}},
--~ 			},
--~ 			hint = WAVE_MIXED,
--~ 		},
		{
			direction = Table_GetRandomItem(t_random_direction_02), 
			units = {
				{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222, sgroups = {sg_Vehicle},},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD, slotItems = {SLOT_ITEM.PANZERBUSCHE_39}, dropItems = {{slotItem = SLOT_ITEM.PANZERBUSCHE_39, dropChance = 1, exclusive = true,}}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD,slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG_MP}, },
			},
			hint = WAVE_VEHICLES,
		},
		

	}
	-- Wave 13
	__t_waveDefenseData.t_waves[13] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_IV_COMMAND_SQUAD, sgroups = {sg_Vehicle}, upgrades = {UPG.GERMAN.PANZER_TOP_GUNNER},},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_IV_COMMAND_SQUAD, sgroups = {sg_Vehicle},upgrades = {UPG.GERMAN.PANZER_TOP_GUNNER},},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_MIXED,
		},
	}
	-- Wave 14
	__t_waveDefenseData.t_waves[14] = {
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable}, upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = preset_random_direction, 
			units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 15
	__t_waveDefenseData.t_waves[15] = {
		{
			direction = CROSS, 
			units = {
				{sbp = SBP.GERMAN.STUG_III_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.STUG_III_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
			},
			hint = WAVE_VEHICLES,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
	}
	-- Wave 16
	__t_waveDefenseData.t_waves[16] = {
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = NORTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable}, upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP},},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = CROSS, 
			units = {
				{sbp = SBP.GERMAN.STUG_III_SQUAD, sgroups = {sg_Vehicle, sg_Captureable},},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
				{sbp = SBP.GERMAN.OSTRUPPEN_SQUAD},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = SOUTH, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, sgroups = {sg_Vehicle, sg_Captureable}, upgrades = {UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE_MP},},
			},
			hint = WAVE_MIXED,
		},
	}
	-- Wave 17
	__t_waveDefenseData.t_waves[17] = {
		{
			direction = Table_GetRandomItem(t_random_direction), 
			units = {
				{sbp = SBP.GERMAN.TIGER_SQUAD, sgroups = {sg_Vehicle},},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_MIXED,
		},
		{
			direction = EAST, 
			units = {
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
			},
			hint = WAVE_INFANTRY,
		},
		{
			direction = WEST, 
			units = {
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.GRENADIER_SQUAD, slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG}},
				{sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD},
			},
			hint = WAVE_INFANTRY,
		},
	}
end
