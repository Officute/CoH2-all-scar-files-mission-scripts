print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Eschdorf Challenge - Encounters data
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
-- Remember to add a simple description for each encounter.



ENCOUNTERS.Outpost1 = function()
	-- The initial left-side of the road
	local encData = {
		name = "Outpost1",
		sgroups = {sg_outpost1, sg_enemyOvergroup},		
		units = {
			{				
				name = "Outpost1a",
				load = XP1_NodeDif({3,3,4,4,5}),
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				--difficulty = {GD_EASY, GD_NORMAL},				
				spawn = mkr_enemyOutpost1a,
				
				
			},
			
			{				
				name = "Outpost1b",
				sgroup = sg_gunRunner,
				--load = XP1_NodeDif({3,3,4,4,5}),
				--sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_enemyOutpost1b,				
			},
			{				
				name = "Outpost1c",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,											
				difficulty = {GD_NORMAL, GD_HARD},				
				spawn = mkr_enemyOutpost1c,				
			},
--~ 			{				
--~ 				name = "Outpost1c",
--~ 				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
--~ 				difficulty = {GD_HARD},				
--~ 				spawn = mkr_enemyOutpost1c,				
--~ 			},

		},	
		triggerGoalOnEngage = true,	
		goal = {
			name = "Defend",
			target = mkr_outpost1,
			range = 20,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_outpost1Facing},
		},
	}
	local enc_Outpost1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Outpost1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost1
end


ENCOUNTERS.Outpost2 = function()
	-- Straight up middle of road
	local encData = {
		name = "Outpost2",
		sgroups = {sg_outpost2, sg_enemyOvergroup},
		--spawn = {mkr_enemyOutpost2a, mkr_enemyOutpost2b, mkr_enemyOutpost2c},	
		units = {
			{				
				name = "Outpost2a",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_enemyOutpost2a,				
				instantSetup = true,
			},

		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_outpost2,
			range = 25,
			leashRange = 2,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_outpost2Facing},
		},
		
	}
	local enc_Outpost2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Outpost2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2
end



ENCOUNTERS.Outpost2b = function()
	-- Straight up middle of road
	local encData = {
		name = "Outpost2b",
		sgroups = {sg_outpost2, sg_enemyOvergroup},
		--spawn = {mkr_enemyOutpost2a, mkr_enemyOutpost2b, mkr_enemyOutpost2c},	
		units = {
			
			{				
				name = "Outpost2b",				
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_enemyOutpost2b,				
				difficulty = {GD_EASY},				
			},
			{				
				name = "Outpost2b",				
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_enemyOutpost2b,				
				difficulty = {GD_NORMAL},				
			},
			{				
				name = "Outpost2b",				
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.0, exclusive = nil}},										
				spawn = mkr_enemyOutpost2b,				
				difficulty = {GD_HARD},				
			},
		},		

		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_outpost2,
			range = 25,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 500},
				{tacticType = TACTIC_Hold, priority = 300},
			},
			
		},
		
	}
	local enc_Outpost2b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Outpost2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2b
end


ENCOUNTERS.Outpost2e = function()
	-- Straight up middle of road
	local encData = {
		name = "Outpost2e",
		sgroups = {sg_outpost2, sg_enemyOvergroup},
		--spawn = {mkr_enemyOutpost2a, mkr_enemyOutpost2b, mkr_enemyOutpost2c},	
		units = {
			
			
			{				
				name = "Outpost2e",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),		
				difficulty = {GD_EASY, GD_NORMAL},				
				spawn = mkr_enemyOutpost2e,					
			},
			
			{				
				name = "Outpost2e",				
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				difficulty = {GD_HARD},		
				spawn = mkr_enemyOutpost2e,				
				instantSetup = true, 
			},
		},		

		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyOutpost2e,
			range = 25,
			leashRange = 2,
			retaliateAttacks = false,
			tacticControlList = {				
				{tacticType = TACTIC_Hold, priority = 300},
			},
			
		},
		
	}
	local enc_Outpost2e = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Outpost2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2e
end


ENCOUNTERS.Outpost2_2 = function()
	-- Straight up middle of road
	local encData = {
		name = "Outpost2_2",
		sgroups = {sg_outpost2, sg_enemyOvergroup},
		--spawn = {mkr_enemyOutpost2a, mkr_enemyOutpost2b, mkr_enemyOutpost2c},		
		units = {
			{				
				name = "Outpost2b",				
				sbp =  SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,				
				difficulty = {GD_EASY},				
				spawn = mkr_enemyOutpost2c,					
			},
			{				
				name = "Outpost2b",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),		
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.0, exclusive = nil}},										
				difficulty = {GD_NORMAL, GD_HARD},				
				spawn = mkr_enemyOutpost2c,					
			},			
		},
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyOutpost2c,
			range = 25,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_outpost2Facing},
		},	
		
	}
	local enc_Outpost2_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--	enc_Outpost2_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2_2
end

ENCOUNTERS.Outpost2_2b = function()
	-- Straight up middle of road
	local encData = {
		name = "Outpost2_2b",
		sgroups = {sg_outpost2, sg_enemyOvergroup},
		--spawn = {mkr_enemyOutpost2a, mkr_enemyOutpost2b, mkr_enemyOutpost2c},		
		units = {
			{				
				name = "Outpost2_2b",				
				sbp =  SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,				
				instantSetup = true, 
				spawn = mkr_enemyOutpost2c,					
			},
		},
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyOutpost2c,
			range = 25,
			leashRange = 2,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_outpost2Facing},
		},	
		
	}
	local enc_Outpost2_2b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--	enc_Outpost2_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2_2b
end


ENCOUNTERS.Outpost2_3 = function()
	-- side encounter
	local encData = {
		name = "Outpost2_3",
		sgroups = {sg_outpost2, sg_enemyOvergroup},		
		units = {

			{				
				name = "Outpost2_3d",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),								
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyOutpost2d,								
			},
			{				
				name = "Outpost2_3d",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				difficulty = {GD_HARD},
				spawn = mkr_enemyOutpost2d,								
			},
		},
		
		triggerGoalOnSight = true,
		goal = {
			name = "Defend",
			target = mkr_outpost2SpawnTarget,
			range = 10,
			leashRange = 10,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},			
		},	
		
	}
	local enc_Outpost2_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Outpost2_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Outpost2_3
end


ENCOUNTERS.Forest1 = function()
	
	local encData = {
		name = "Forest1",
		sgroups = {sg_forest1, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest1a, mkr_enemyForest1b, mkr_enemyForest1c},		
		units = {
			
			{				
				name = "Forest1a",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				load = XP1_NodeDif({2,2,3,4,5}),				
				difficulty = {GD_EASY, GD_NORMAL},				
				spawn = mkr_enemyForest1a,
				instantSetup = true, 
			},
			
			{				
				name = "Forest1a",				
				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},						
				difficulty = {GD_HARD},				
				spawn = mkr_enemyForest1a,
				instantSetup = true, 
			},
			
--~ 			{				
--~ 				name = "Forest1b",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				difficulty = {GD_EASY, GD_NORMAL},				
--~ 				spawn = mkr_enemyForest1b,				
--~ 			},

--~ 			{				
--~ 				name = "Forest1b",
--~ 				sbp = SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,				
--~ 				difficulty = {GD_HARD},				
--~ 				spawn = mkr_enemyForest1b,
--~ 				
--~ 			},

		},		
		triggerGoalOnEngage = true,		
		goal = {
			name = "Defend",
			target = mkr_forest1, --mkr_enemyForest1a,
			range = 10,
			leashRange = 10,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest1Facing},
		},
	}
	local enc_Forest1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--~ 	enc_Forest1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest1
end

ENCOUNTERS.Forest1_2 = function()
	
	local encData = {
		name = "Forest1_2",
		sgroups = {sg_forest1, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest1a, mkr_enemyForest1b, mkr_enemyForest1c},		
		units = {
			{				
				name = "Forest1d",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,	 SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				load = XP1_NodeDif({3,3,3,4,4}),
				spawn = mkr_enemyForest1d,				
			},			
		},		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyForest1c,  --mkr_enemyForest1e_def,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest1_2Facing},
		},
	}
	local enc_Forest1_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest1_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest1_2
end

ENCOUNTERS.Forest1_3 = function()
	
	local encData = {
		name = "Forest1_3",
		sgroups = {sg_forest1, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest1a, mkr_enemyForest1b, mkr_enemyForest1c},
		units = {
--~ 			{				
--~ 				name = "Forest1c",
--~ 				sbp = SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
--~ 				--difficulty = {GD_NORMAL, GD_HARD},
--~ 				spawn = mkr_enemyForest1c,
--~ 				conditions = {(g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 4) or (g_difficulty == GD_HARD)},	
--~ 				
--~ 			},
			{				
				name = "Forest1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,	 SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				load = XP1_NodeDif({2,2,3,4,5}),
				
				spawn = mkr_enemyForest1c,				
			},
--~ 			{				
--~ 				name = "Forest1c",
--~ 				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
--~ 				--load = XP1_NodeDif({2,2,3,4,5}),
--~ 				spawn = mkr_enemyForest1e,				
--~ 			},


		},		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyForest1e_def,
			range = 12,
			leashRange = 12,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest1_2Facing},
		},
	}
	local enc_Forest1_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest1_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest1_3
end

ENCOUNTERS.Forest1_3b = function()
	
	local encData = {
		name = "Forest1_3",
		sgroups = {sg_forest1, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest1a, mkr_enemyForest1b, mkr_enemyForest1c},
		units = {

			{				
				name = "Forest1_3b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,	 SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				load = XP1_NodeDif({2,2,3,4,5}),
				spawn = mkr_enemyForest1e,			
			},


		},
		triggerGoalOnEngage = true,		
		goal = {
			name = "Defend",
			target = mkr_enemyForest1e_def,
			range = 12,
			leashRange = 12,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest1_2Facing},
		},
	}
	local enc_Forest1_3b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest1_3b:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest1_3b
end



ENCOUNTERS.Forest2 = function()
	
	local encData = {
		name = "Forest2",
		sgroups = {sg_forest2, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest2a, mkr_enemyForest2b, mkr_enemyForest2c},		
		units = {
			{				
				name = "Forest2a",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,				
				--conditions = {g_difficulty == GD_EASY or (g_difficulty == GD_NORMAL and XP1_GetNodeStrength() <= 3)},	
				spawn = mkr_enemyForest2a,				
				instantSetup = true,
			},
			
			{				
				name = "Forest2b",				 
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				load = XP1_NodeDif({2,2,3,4,5}),
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyForest2b,
				
			},
			{				
				name = "Forest2b",				 
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,}),
				difficulty = {GD_HARD},
				spawn = mkr_enemyForest2b,
				
			},
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_forest2,
			range = 13,
			leashRange = 13,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest2Facing},
		},
	}
	local enc_Forest2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest2
end

ENCOUNTERS.Forest2_2 = function()
	
	local encData = {
		name = "Forest2_2",
		sgroups = {sg_forest2, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest2a, mkr_enemyForest2b, mkr_enemyForest2c},

		units = {


			{				
				name = "Forest2d",
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				spawn = mkr_enemyForest2c,
				
			},
		},		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_forest2,
			range = 15,
			leashRange = 5,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_forest2Facing},
		},
	}
	local enc_Forest2_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest2_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest2_2
end



ENCOUNTERS.Forest3 = function()
	
	local encData = {
		name = "Forest3",
		sgroups = {sg_forest3, sg_enemyOvergroup},
		--spawn = {mkr_enemyForest3a, mkr_enemyForest3b, mkr_enemyForest3c},		
		units = {
			
			{				
				name = "Forest3a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				spawn = mkr_enemyForest3b,				
			},

		},
		triggerGoalOnEngage = true,		
		goal = {
			name = "Defend",
			target = mkr_enemyForest3b,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_outpost2Facing},
		},
	}
	local enc_Forest3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Forest3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Forest3
end


ENCOUNTERS.Farm1 = function()
	
	local encData = {
		name = "Farm1",
		sgroups = {sg_farm1, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm1a, mkr_enemyFarm1b},
		--dynamicSpawnTarget = mkr_enemyFarm1a,
		--intent = ENC_INTENT.basicHMG,
		units = {
			{				
				name = "Farm1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				load = XP1_NodeDif({2,2,3,3,3}),
				spawn = mkr_enemyFarm1a_2,

			},
			{				
				name = "Farm1b",
				sbp =  SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,				
				spawn = mkr_enemyFarm1a,

			},
			{				
				name = "Farm1b",
				sbp =  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,				
				load = XP1_NodeDif({2,2,3,3,3}),
				difficulty = {GD_HARD},
				spawn = mkr_enemyFarm1a,
			},
			
		},		
		
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_farmIntersection,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			instantSetup = true,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_farm1Facing},
		},
	}
	local enc_Farm1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm1
end


ENCOUNTERS.Farm1_2 = function()
	
	local encData = {
		name = "Farm1_2",
		sgroups = {sg_farm1_2, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm1b, mkr_enemyFarm1c},
		
		units = {
			{				
				name = "Farm1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				spawn = mkr_enemyFarm1b,
				
			},
			
			{				
				name = "Farm1c",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				load = XP1_NodeDif({2,3,3,4,4}),
				difficulty = {GD_EASY},
				spawn = mkr_enemyFarm1c,

			},			
			
			{				
				name = "Farm1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_enemyFarm1c,

			},			
		},			
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			garrisonIdle = false,
			garrison = true,
			target = mkr_enemyFarm1,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200, maxUsers = 1},
			},
			coordinatedSetupFacingPositions = {mkr_farm1_2Facing},
		},
	}
	local enc_Farm1_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm1_2
end


ENCOUNTERS.Farm1_2b = function()
	
	local encData = {
		name = "Farm1_2b",
		sgroups = {sg_farm1_2, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm1b, mkr_enemyFarm1c},
		
		units = {

			{				
				name = "Farm1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				load = XP1_NodeDif({2,3,3,4,4}),
				spawn = mkr_enemyFarm1d,

			},			
		},			
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			target = mkr_enemyFarm1,
			range = 20,
			leashRange = 25,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200, maxUsers = 1},
			},
			coordinatedSetupFacingPositions = {mkr_farm1_2Facing},
		},
	}
	local enc_Farm1_2b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm1_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm1_2b
end
--~ ENCOUNTERS.Farm2 = function()
--~ 	
--~ 	local encData = {
--~ 		name = "Farm2",
--~ 		sgroups = {sg_farm2, sg_enemyOvergroup},
--~ 		spawn = {mkr_enemyFarm2a,},
--~ 		
--~ 		units = {
--~ 			{				
--~ 				name = "Farm2a",
--~ 				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,				
--~ 				spawn = mkr_enemyFarm2a,
--~ 				instantSetup = true,
--~ 			},

--~ 		},			
--~ 		
--~ 		goal = {
--~ 			name = "Defend",
--~ 			garrisonIdle = false,
--~ 			garrison = false,
--~ 			target = mkr_enemyFarm2,
--~ 			range = 10,
--~ 			leashRange = 10,
--~ 			retaliateAttacks = false,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Hold, priority = 200, maxUsers = 1},
--~ 			},
--~ 			--coordinatedSetupFacingPositions = {mkr_farm2Facing},
--~ 		},
--~ 	}
--~ 	local enc_Farm2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
--~ 	--enc_Farm2:SetGoal(encData.goalData)
--~ 	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
--~ 	
--~ 	return enc_Farm2
--~ end
ENCOUNTERS.Farm2_2 = function()
	
	local encData = {
		name = "Farm2_2",
		sgroups = {sg_farm2_2, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm2b, mkr_enemyFarm2c},
		
		units = {

			{				
				name = "Farm2b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				--load = XP1_NodeDif({3,3,4,5,6}),
				spawn = mkr_enemyFarm2b,
			},			
			{				
				name = "Farm2c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				load = XP1_NodeDif({2,3,3,4,5}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				spawn = mkr_enemyFarm2c,
			},	
			
			{				
				name = "Farm2c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				load = XP1_NodeDif({2,2,3,3,4}),
				difficulty = {GD_HARD},
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				spawn = mkr_enemyFarm2c,
			},	
		},			
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			garrisonIdle = true,
			garrison = true,
			target = mkr_enemyFarm2,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200, maxUsers = 1},
			},
			--coordinatedSetupFacingPositions = {mkr_farm2Facing},
		},
	}
	local enc_Farm2_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm2_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm2_2
end


ENCOUNTERS.Farm3 = function()
	
	local encData = {
		name = "Farm3",
		sgroups = {sg_farm3, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm3a, mkr_enemyFarm3b},

		units = {
			{				
				name = "Farm3b",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				spawn = mkr_enemyFarm3b,
				instantSetup = true,

			},
			
			
			{				
				name = "Farm3a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				difficulty = {GD_EASY},
				spawn = mkr_enemyFarm3a,
			},		
			
			{				
				name = "Farm3a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				difficulty = {GD_NORMAL, GD_HARD},
				spawn = mkr_enemyFarm3a,
			},				
			{				
				name = "Farm3c",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,				
				spawn = mkr_enemyFarm3c,
			},	
			{				
				name = "Farm3a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				difficulty = {GD_HARD},
				spawn = mkr_enemyFarm3d,
			},	
		},			
		triggerGoalOnEngage = true,
		goal = {
			name = "Defend",
			target = mkr_enemyFarm3,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_farm3Facing},
		},
	}
	local enc_Farm3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Farm3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm3
end


ENCOUNTERS.Farm4 = function()
	
	local encData = {
		name = "Farm4",
		sgroups = {sg_farm4, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm4a, mkr_enemyFarm4b},

		
		units = {
--~ 			{				
--~ 				name = "Farm4b",
--~ 				sbp = SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
--~ 				spawn = mkr_enemyFarm4b,
--~ 				instantSetup = true,				
--~ 				conditions = {(g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 4) or (g_difficulty == GD_HARD)},	
--~ 			},
--~ 			{				
--~ 				name = "Farm4b",
--~ 				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
--~ 				spawn = mkr_enemyFarm4b,				
--~ 				conditions = {g_difficulty == GD_NORMAL and XP1_GetNodeStrength() <= 4},	
--~ 			},

			{				
				name = "Farm4b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				conditions = {XP1_GetNodeStrength() >= 4},
				spawn = mkr_enemyFarm4b,
			},		
			{				
				name = "Farm4b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				conditions = {XP1_GetNodeStrength() <= 3},
				spawn = mkr_enemyFarm4b,
			},		

			
			{				
				name = "Farm4a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				conditions = {XP1_GetNodeStrength() >= 4},
				
				spawn = mkr_enemyFarm4a,
			},		
			{				
				name = "Farm4a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				conditions = {XP1_GetNodeStrength() <= 3},
				
				spawn = mkr_enemyFarm4a,
			},					
			
			{				
				name = "Farm4b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,  SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,}),												
				conditions = {XP1_GetNodeStrength() <= 4},				
				spawn = mkr_enemyFarm4c,				
			},
			
			
			{				
				name = "Farm4b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,}),												
				conditions = {XP1_GetNodeStrength() >= 5},				
				spawn = mkr_enemyFarm4c,				
			},
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyFarm4,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_farm4Facing},
		},
	}
	local enc_Farm4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Farm4:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm4
end


ENCOUNTERS.Farm5 = function()
	
	local encData = {
		name = "Farm5",
		sgroups = {sg_farm5, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm5a, mkr_enemyFarm5b},
		
		units = {
			{				
				name = "Farm5a",
				--sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_enemyFarm5b,								
			},
			
			{				
				name = "Farm5b",
				--sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,  SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				load = XP1_NodeDif({2,3,3,4,5}),
				difficulty = {GD_EASY, GD_NORMAL},
			--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
 				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},							
				spawn = mkr_enemyFarm5a,								
			},
			
			{				
				name = "Farm5b",
				--sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,  SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				difficulty = {GD_HARD},
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
 				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},							
				spawn = mkr_enemyFarm5a,								
			},
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyFarm5,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_farm4Facing},
		},
	}
	local enc_Farm5 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Farm5:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm5
end



ENCOUNTERS.Farm5_2 = function()
	
	local encData = {
		name = "Farm5_2",
		sgroups = {sg_farm5, sg_enemyOvergroup},
		spawn = {mkr_enemyFarm5_2a, mkr_enemyFarm5_2b},
		
		units = {
			{				
				name = "Farm5a",
				--sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
--~ 				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_enemyFarm5a,								
			},
			{				
				name = "Farm5_2b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				spawn = mkr_enemyFarm5_2b,		
			},
			

		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyFarm5_2,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_farm4Facing},
		},
	}
	local enc_Farm5_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Farm5_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Farm5_2
end

ENCOUNTERS.Urban1 = function()
	
	local encData = {
		name = "Urban1",
		sgroups = {sg_urban1, sg_enemyOvergroup},
		--spawn = {mkr_enemyUrban1a, mkr_enemyUrban1b},
		
		units = {
--~ 			{				
--~ 				name = "Urban1b",
--~ 				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
--~ 				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				--difficulty = {GD_HARD},
--~ 				spawn = mkr_enemyUrban1a,
--~ 				instantSetup = true,				
--~ 			},
			{				
				name = "Urban1a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, }),
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban1f,
				difficulty = {GD_EASY, GD_NORMAL},
			},
			
			{				
				name = "Urban1a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},			
				difficulty = {GD_HARD},
				spawn = mkr_enemyUrban1f,				
			},
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1,
			range = 20,
			leashRange = 20,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_urban1Facing},
		},
	}
	local enc_Urban1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1
end



ENCOUNTERS.Urban1b = function()
	
	local encData = {
		name = "Urban1b",
		sgroups = {sg_urban1b, sg_enemyOvergroup},
		--spawn = {mkr_enemyUrban1a, mkr_enemyUrban1b},
		
		units = {
			{				
				name = "Urban1b",
				sbp = SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--difficulty = {GD_HARD},
				spawn = mkr_enemyUrban1b,
				instantSetup = true,				
			},
	
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1,
			range = 30,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_urban1Facing},
		},
	}
	local enc_Urban1b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban1b:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1b
end


ENCOUNTERS.Urban1_2 = function()
	
	local encData = {
		name = "Urban1_2",
		sgroups = {sg_urban1, sg_enemyOvergroup},
		--spawn = {mkr_enemyUrban1c, mkr_enemyUrban1d},
		
		--intent = ENC_INTENT.basicHMG,
		
		units = {
			{				
				name = "Urban1c",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, }),
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban1c,
				conditions = {XP1_GetNodeStrength() <= 3},	
			},
			{				
				name = "Urban1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, }),
				--difficulty = {GD_EASY, GD_NORMAL},
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = mkr_enemyUrban1c,
				conditions = {XP1_GetNodeStrength() >= 4},	
			},

			{				
			name = "Urban1d",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, }),
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban1d,
				conditions = {XP1_GetNodeStrength() <= 3},	
			},
			{				
				name = "Urban1d",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, }),
				--difficulty = {GD_EASY, GD_NORMAL},
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				spawn = mkr_enemyUrban1d,
				conditions = {XP1_GetNodeStrength() >= 4},	
			},
			

			
		},
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1_2,
			--garrisonIdle = true,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200, maxUsers =2 },
			},
			coordinatedSetupFacingPositions = {mkr_urban1_2Facing},
		},
	}
	local enc_Urban1_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban1_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1_2
end

ENCOUNTERS.Urban1_3 = function()
	
	local encData = {
		name = "Urban1_3",
		sgroups = {sg_urban1, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban1e},
		
		units = {
			{				
				name = "Urban1_3",
				--sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
				conditions = {XP1_GetNodeStrength() <= 3},	
				--difficulty = {GD_EASY, GD_NORMAL}
				spawn = mkr_enemyUrban1_vehicle1,
				--dynamicSpawnTarget = mkr_enemyFarm4b
			},
			
			{				
				name = "Urban1_3",
				--sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
				sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 4},	
				--difficulty = {GD_EASY, GD_NORMAL}
				spawn = mkr_enemyUrban1_vehicle1,
				--dynamicSpawnTarget = mkr_enemyFarm4b
			},
--~ 			
--~ 			{				
--~ 				name = "Urban1_3",
--~ 				--sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,
--~ 				sbp = SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP,				
--~ 				difficulty = {GD_HARD}
--~ 				spawn = mkr_enemyUrban1_vehicle,
--~ 				--dynamicSpawnTarget = mkr_enemyFarm4b
--~ 			},
			
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1_2,
			--garrisonIdle = true,
			--garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200, maxUsers =2 },
			},
			coordinatedSetupFacingPositions = {mkr_urban1_2Facing},
		},
	}
	local enc_Urban1_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban1_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1_3
end

ENCOUNTERS.Urban1_4 = function()
	
	local encData = {
		name = "Urban1_4",
		sgroups = {sg_urban1_4, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban1a},
		instantSetup = true,				
		
		units = {
			{				
				name = "Urban1_4",
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
				instantSetup = true,
				--spawn = mkr_enemyUrban1a,
				--dynamicSpawnTarget = mkr_enemyFarm4b
			},
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1,
			garrisonIdle = false,
			garrison = false,
			range = 30,
			leashRange = 15, --20?
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200, maxUsers =2 },
			},
			--coordinatedSetupFacingPositions = {mkr_urban1Facing},
		},
	}
	local enc_Urban1_4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban1_4:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1_4
end

ENCOUNTERS.Urban1_5 = function()
	
	local encData = {
		name = "Urban1_5",
		sgroups = {sg_urban1, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban1g},
		instantSetup = true,		
		
		units = {
		
			{				
				name = "Urban1g",				
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban1g,
				conditions = {XP1_GetNodeStrength() <= 3},	
			},
			{				
				name = "Urban1g",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--difficulty = {GD_EASY, GD_NORMAL},
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_enemyUrban1g,
				conditions = {XP1_GetNodeStrength() >= 4},	
			},
		},
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1_5,
			--garrisonIdle = true,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200, maxUsers =2 },
			},
			
		},
	}
	local enc_Urban1_5 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Urban1_5:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1_5
end

ENCOUNTERS.Urban1_6 = function()
	
	local encData = {
		name = "Urban1_6",
		sgroups = {sg_urban1, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban1h},
		instantSetup = true,		
		
		units = {
			{				
				name = "Urban1h",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP}),				
				spawn = mkr_enemyUrban1h,				
			},		
		},
		goal = {
			name = "Defend",
			target = mkr_enemyUrban1_5,
			--garrisonIdle = true,
			
			range = 20,
			leashRange = 5, -- 20?
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200, maxUsers =2 },
			},
			
		},
	}
	local enc_Urban1_6 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Urban1_6:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban1_6
end

ENCOUNTERS.Urban2 = function()
	
	local encData = {
		name = "Urban2",
		sgroups = {sg_urban2, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2a, mkr_enemyUrban2b},
		
		units = {
			{				
				name = "Urban2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_enemyUrban2a,
				difficulty = {GD_EASY, GD_NORMAL},
				conditions = {XP1_GetNodeStrength() <= 3},				
			},
			{				
				name = "Urban2a",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				--difficulty = {GD_EASY, GD_NORMAL},
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban2a,				
				conditions = {XP1_GetNodeStrength() >= 4},
			},
			
			{				
				name = "Urban2a",
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				load = XP1_NodeDif({2,2,3,3,4}),
				difficulty = {GD_HARD},
				spawn = eg_urban2,
				--conditions = {XP1_GetNodeStrength() >= 4},
			},
			
			

--~ 			{				
--~ 				name = "Urban2b",
--~ 				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
--~ 				difficulty = {GD_NORMAL, GD_HARD},
--~ 				spawn = mkr_enemyUrban2b,
--~ 				
--~ 			},

		},		
		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban2,
			garrisonIdle = true,
			garrison = true,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200, maxUsers = 1},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2Facing},
		},
		
	}
	local enc_Urban2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2
end

ENCOUNTERS.Urban2_hard = function()
	
	local encData = {
		name = "Urban2_hard",
		sgroups = {sg_urban2b, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2a, mkr_enemyUrban2b},
		
		units = {
		
			{				
				name = "Urban2_hard",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				difficulty = {GD_HARD},
				spawn = mkr_enemyUrban2a,
				--conditions = {XP1_GetNodeStrength() >= 3},
			},

		},		
		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban2,			
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_HOLD, priority = 200, maxUsers = 1},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2Facing},
		},
		
	}
	local enc_Urban2_hard = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban2_hard:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2_hard
end

ENCOUNTERS.Urban2b = function()
	
	local encData = {
		name = "Urban2b",
		sgroups = {sg_urban2b, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2a, mkr_enemyUrban2b},
		
		units = {
		
			{				
				name = "Urban2b",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
				--difficulty = {GD_NORMAL, GD_HARD},
				conditions = {XP1_GetNodeStrength() >= 3},
				spawn = mkr_enemyUrban2b,
				
			},

		},		
		
		
		goal = {
			name = "Defend",
			target = mkr_scoutRadius,			
			range = 20,
			leashRange = 20,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200, maxUsers = 1},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2Facing},
		},
		
	}
	local enc_Urban2b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban2b:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2b
end


ENCOUNTERS.Urban2_2 = function()
	
	local encData = {
		name = "Urban2_2",
		sgroups = {sg_urban2, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2c, mkr_enemyUrban2d},
		
		units = {
			{				
				name = "Urban2c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				load = XP1_NodeDif({2,3,3,4,4}),
				spawn = mkr_enemyUrban2c,				
			},
--~ 			{				
--~ 				name = "Urban2d",
--~ 				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
--~ 				difficulty = {GD_EASY, GD_NORMAL},
--~ 				spawn = mkr_enemyUrban2d,
--~ 			},



		},		
		triggerGoalOnEngage = true,

--~ 		
		goal = {
			name = "Defend",
			target = mkr_enemyUrbanDef,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2_2Facing},
		},
	}
	local enc_Urban2_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Urban2_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2_2
end


ENCOUNTERS.Urban2_3 = function()
	
	local encData = {
		name = "Urban2_3",
		sgroups = {sg_urban2, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2e},
		--dynamicSpawnTarget = mkr_enemyUrban2a,
		units = {
			{				
				name = "Urban2e",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_enemyUrban2e,
				
			},
			
			{				
				name = "Urban2e",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},	
				difficulty = {GD_HARD},
				spawn = mkr_enemyUrban2e,
				
			},
			
			
				
			
--~ 			{				
--~ 				name = "Urban2f",
--~ 				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
--~ 				load = XP1_NodeDif({2,3,3,4,4}),
--~ 				slotItems = {SLOT_ITEM.PANZERSHRECK},
--~ 				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
--~ 				spawn = mkr_enemyUrban2f,				
--~ 			},
--~ 			
--~ 			
--~ 						
			{				
				name = "Urban2g",
				sbp = SBP.WEST_GERMAN.RAKETENWERFER43_88MM_PUPPCHEN_ANTITANK_GUN_SQUAD_MP,
				instantSetup = true,
				spawn = mkr_enemyUrban2f,
			},


		},		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban2_3,
			range = 20,
			leashRange = 20,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2_3Facing},
		},
	}
	local enc_Urban2_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Urban2_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2_3
end

ENCOUNTERS.Urban2_3b = function()
	
	local encData = {
		name = "Urban2_3b",
		sgroups = {sg_urban2_3b, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban2f},
		--dynamicSpawnTarget = mkr_enemyUrban2a,
		units = {

			{				
				name = "Urban2f",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				load = XP1_NodeDif({2,3,4,5,6}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},				
				spawn = mkr_enemyUrban2g,				
			},

		},		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban2_3,
			range = 20,
			leashRange = 20,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_urban2_3Facing},
		},
	}
	local enc_Urban2_3b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	--enc_Urban2_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2_3b
end



ENCOUNTERS.Urban2_4 = function()
	
	local encData = {
		name = "Urban2_4",
		sgroups = {sg_urban2, sg_enemyOvergroup, sg_patrolVehicle2},
		spawn = {mkr_enemyUrban5a, mkr_enemyUrban5b},
		units = {
			{				
				name = "Urban2_4a",
				sbp = SBP.GERMAN.STUG_III_SQUAD_MP,				
				spawn = mkr_enemyUrban2_4a,
			},	
		},		
		--triggerGoalOnEngage = true,

		goal = {
			name = "Defend",
			target = mkr_enemyUrban2_4,
			patrolParams = {
				path = "VehiclePath2",
				wait = 3,
				loop = LOOP_NORMAL,
			},
			range = 50,
			leashRange = 50,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
		},
	}
	local enc_Urban2_4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban2_4:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban2_4
end

ENCOUNTERS.Urban3 = function()
	
	local encData = {
		name = "Urban3",
		sgroups = {sg_urban3, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban3a, mkr_enemyUrban3b},
		
		units = {
			{				
				name = "Urban3a",
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--sbp = SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
				spawn = mkr_enemyUrban3b,
				
			},
			{				
				name = "Urban3b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				conditions = {(g_difficulty == GD_EASY or g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() <= 2},
				spawn = mkr_enemyUrban3a,				
			},			
			{				
				name = "Urban3c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_enemyUrban3a,				
				conditions = {((g_difficulty == GD_EASY or g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() >= 3) or (g_difficulty == GD_HARD)},	
			},			
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban3,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_urban3Facing},
		},
	}
	local enc_Urban3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban3
end

ENCOUNTERS.Urban3b = function()
	
	local encData = {
		name = "Urban3b",
		sgroups = {sg_urban3, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban3a, mkr_enemyUrban3b},
		
		units = {
			{				
				name = "Urban4_a",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				spawn = mkr_enemyUrban3a,
				instantSetup = true,
				conditions = {(g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 4) or (g_difficulty == GD_HARD)},	
			},
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban3,
			range = 15,
			leashRange = 15,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_urban3Facing},
		},
	}
	local enc_Urban3b = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban3b:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban3b
end

-- crew for vehicles here?
ENCOUNTERS.Urban4 = function()
	
	local encData = {
		name = "Urban4",
		sgroups = {sg_urban4, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban4a, mkr_enemyUrban4b, mkr_enemyUrban4c},
		
		units = {
			{				
				name = "Urban4_a",
				sbp = SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
				spawn = mkr_enemyUrban4a,
				instantSetup = true,
				conditions = {(g_difficulty == GD_NORMAL and XP1_GetNodeStrength() >= 4) or (g_difficulty == GD_HARD)},	
			},
			
			{				
				name = "Urban4_c",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
				spawn = mkr_enemyUrban4c,
				
			},	
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban4,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
		},
	}
	local enc_Urban4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban4:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban4
end

ENCOUNTERS.Urban4_2 = function()
	
	local encData = {
		name = "Urban4_2",
		sgroups = {sg_urban4, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban4a, mkr_enemyUrban4b, mkr_enemyUrban4c},
		
		units = {

			{				
				name = "Urban4_b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_enemyUrban4b,
				conditions = {(g_difficulty == GD_EASY or g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() <= 2},
				
			},		
			{				
				name = "Urban4_b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_enemyUrban4b,
				conditions = {((g_difficulty == GD_EASY or g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() >= 3) or (g_difficulty == GD_HARD)},				
			},					
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban4,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
		},
	}
	local enc_Urban4_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban4_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban4_2
end

ENCOUNTERS.Urban5 = function()
	
	local encData = {
		name = "Urban5",
		sgroups = {sg_urban5, sg_enemyOvergroup, sg_patrolVehicle1},
		spawn = {mkr_enemyUrban5a, mkr_enemyUrban5b},
		
		units = {
			{				
				name = "Urban5_a",
				sbp = XP1_NodeDif({SBP.GERMAN.STUG_III_SQUAD_MP, SBP.GERMAN.STUG_III_SQUAD_MP, SBP.GERMAN.STUG_III_SQUAD_MP, SBP.GERMAN.STUG_III_SQUAD_MP, SBP.GERMAN.PANZER_IV_SQUAD}),
				--sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
				difficulty = {GD_EASY, GD_NORMAL},				
				spawn = mkr_enemyUrban5a,				
			},
			
			{				
				name = "Urban5_a",
				--sbp = SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,				
				sbp = SBP.GERMAN.PANZER_IV_SQUAD,
				difficulty = {GD_HARD},
				upgrades = (g_difficulty == GD_HARD and UPG.GERMAN.PANZER_TOP_GUNNER_MP or nil),
				spawn = mkr_enemyUrban5a,
				
			},
			
--~ 			{				
--~ 				name = "Urban5_b",
--~ 				sbp = SBP.GERMAN.STUG_III_SQUAD,
--~ 				spawn = mkr_enemyUrban5b,
--~ 				--dynamicSpawnTarget = mkr_enemyFarm4a
--~ 			},			
		},		
		--triggerGoalOnEngage = true,
--~ 		goal = {
--~ 			name = "Defend",
--~ 			target = mkr_enemyUrban5,
--~ 			range = 50,
--~ 			leashRange = 50,
--~ 			retaliateAttacks = true,
--~ 			tacticControlList = {
--~ 				{tacticType = TACTIC_Vehicle, priority = 200},
--~ 			},
--~ 			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
--~ 		},
		goal = {
			name = "Defend",
			target = mkr_enemyUrban5,
			patrolParams = {
				path = "VehiclePath1",
				wait = 5,
				loop = LOOP_NORMAL,
			},
			range = 50,
			leashRange = 50,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
		},
	}
	local enc_Urban5 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban5:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban5
end


ENCOUNTERS.Urban5_2 = function()
	
	local encData = {
		name = "Urban5_2",
		sgroups = {sg_urban5_2, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban5a, mkr_enemyUrban5b},
		
		units = {
			
			{				
				name = "Urban5_c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_enemyUrban5c,
				conditions = {XP1_GetNodeStrength() <= 2},
				
			},		
			{				
				name = "Urban5_c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				spawn = mkr_enemyUrban5c,
				conditions = {XP1_GetNodeStrength() >= 3},				
			},		
			
			
			{				
				name = "Urban5_e",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				spawn = mkr_enemyUrban5e,
				conditions = {XP1_GetNodeStrength() <= 2},
				
			},		
			{				
				name = "Urban5_e",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},			
				spawn = mkr_enemyUrban5e,
				conditions = {XP1_GetNodeStrength() >= 3},				
			},	
			
			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban5_2,
			range = 25,
			leashRange = 25,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enemyUrban5_facing},
		},
		
		
	}
	local enc_Urban5_2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban5_2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban5_2
end


ENCOUNTERS.Urban5_3 = function()
	
	local encData = {
		name = "Urban5_3",
		sgroups = {sg_urban5_3, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban5b},
		
		units = {
			{				
				name = "Urban5_3a",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				--slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				--dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				spawn = mkr_enemyUrban5b,		
				conditions = {(g_difficulty == GD_EASY or g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() <= 3},				
			},
			{				
				name = "Urban5_3a",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				spawn = mkr_enemyUrban5b,		
				conditions = {((g_difficulty == GD_NORMAL) and XP1_GetNodeStrength() >= 4) or g_difficulty == GD_HARD},				
			},

		
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban5_2,
			range = 15,
			leashRange = 15,
			garrisonIdle = true,
			garrison = true,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Hold, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_enemyUrban5_facing},
		},
		
		
	}
	local enc_Urban5_3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban5_3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban5_3
end


ENCOUNTERS.Urban5_4 = function()
	
	local encData = {
		name = "Urban5_4",
		sgroups = {sg_urban5_3, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban5d},
		
		units = {

			{				
				name = "Urban5_4b",
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222_MP,
				spawn = mkr_enemyUrban5_vehicle1,
		
			},			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban5_2,
			range = 25,
			leashRange = 25,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200}, -- TACTIC_Hold
			},
			--coordinatedSetupFacingPositions = {mkr_enemyUrban5_facing},
		},
		
		
	}
	local enc_Urban5_4 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban5_4:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban5_4
end



ENCOUNTERS.Urban6 = function()
	
	local encData = {
		name = "Urban6",
		sgroups = {sg_urban6, sg_enemyOvergroup},
		spawn = {mkr_enemyUrban6a, mkr_enemyUrban3b},
		
		
		units = {
			{				
				name = "Urban6a",
				--sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_enemyUrban6b,
		
			},
			{				
				name = "Urban6b",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_enemyUrban6a,				
				--difficulty = {GD_EASY, GD_NORMAL},
				conditions = {XP1_GetNodeStrength() <= 3},				
		
			},
			{				
				name = "Urban6b",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				spawn = mkr_enemyUrban6a,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 0.5, exclusive = nil}},		
				--difficulty = {GD_HARD},
				conditions = {XP1_GetNodeStrength() >= 4},				
		
			},

			
		},		
		
		goal = {
			name = "Defend",
			target = mkr_enemyUrban6,
			range = 20,
			leashRange = 16,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_urban6Facing},
		},
	}
	local enc_Urban6 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban6:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban6
end



ENCOUNTERS.Urban7 = function()
	
	local encData = {
		name = "Urban7",
		sgroups = {sg_urban5, sg_enemyOvergroup, sg_patrolVehicle3},
		spawn = {mkr_enemyUrban7a},
		
		units = {
			{				
				name = "Urban7_a",
				sbp = SBP.GERMAN.STUG_III_SQUAD_MP,				
				spawn = mkr_enemyUrban7a,
				
			},
			
		},
		goal = {
			name = "Defend",
			target = mkr_enemyUrban7,
			patrolParams = {
				path = "VehiclePath3",
				wait = 5,
				loop = LOOP_NORMAL,
			},
			range = 50,
			leashRange = 50,
			retaliateAttacks = true,
			tacticControlList = {
				{tacticType = TACTIC_Vehicle, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_enc1_facing},
			
		},
	}
	local enc_Urban7 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_Urban7:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_Urban7
end


ENCOUNTERS.ConvoyDef1 = function()
	
	local encData = {
		name = "ConvoyDef1",
		sgroups = {sg_convoyDef1, sg_enemyOvergroup},
		--spawn = {mkr_convoyDefense1a, mkr_convoyDefense1b},
		
		units = {
			{				
				name = "ConvoyDef1a",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				spawn = mkr_convoyDefense1a,
				instantSetup = true,
				
			},
--~ 			{				
--~ 				name = "ConvoyDef1b",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				difficulty = {GD_EASY},
--~ 				spawn = mkr_convoyDefense1b,
--~ 				
--~ 			},
--~ 			{				
--~ 				name = "ConvoyDef1b",
--~ 				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
--~ 				conditions = {g_difficulty == GD_NORMAL and XP1_GetNodeStrength() <= 3},					
--~ 				spawn = mkr_convoyDefense1b,				
--~ 			},
			
			{				
				name = "ConvoyDef1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				conditions = {XP1_GetNodeStrength() <= 3},	
				spawn = mkr_convoyDefense1c,				
			},
			
			{				
				name = "ConvoyDef1c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,}),
				conditions = {XP1_GetNodeStrength() >= 4},	
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_convoyDefense1c,				
			},
			
			
			
			{				
				name = "ConvoyDef1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				conditions = {XP1_GetNodeStrength() <= 3},	
				spawn = mkr_convoyDefense1b,				
			},
			
			{				
				name = "ConvoyDef1b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,}),
				conditions = {XP1_GetNodeStrength() >= 4},	
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_convoyDefense1b,				
			},
			
			
		},		
		goal = {
			name = "Defend",
			target = mkr_convoyDefense1,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			--coordinatedSetupFacingPositions = {mkr_convoyDef1Facing},
		},
	}
	local enc_ConvoyDef1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_ConvoyDef1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_ConvoyDef1
end


ENCOUNTERS.ConvoyDef2 = function()
	
	local encData = {
		name = "ConvoyDef2",
		sgroups = {sg_convoyDef2, sg_enemyOvergroup},
		spawn = {mkr_convoyDefense2},
		
		
		units = {
			{				
				name = "ConvoyDef2a",
				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
				spawn = mkr_convoyDefense2a,
				instantSetup = true,
				
			},
--~ 			{				
--~ 				name = "ConvoyDef2b",
--~ 				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD_MP,
--~ 				spawn = mkr_convoyDefense2b,
--~ 				
--~ 			},
		},		
		
		
		goal = {
			name = "Defend",
			target = mkr_convoyDefense2,
			range = 15,
			leashRange = 15,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Cover, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_convoyDef2Facing},
		},
	}
	local enc_ConvoyDef2 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_ConvoyDef2:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_ConvoyDef2
end

ENCOUNTERS.ConvoyDef3 = function()
	
	local encData = {
		name = "ConvoyDef3",
		sgroups = {sg_convoyDef3, sg_enemyOvergroup},
		spawn = {mkr_convoyDefense3},
		
		units = {			
--~ 			{				
--~ 				name = "ConvoyDef3a",
--~ 				sbp = SBP.WEST_GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD_WG_MP,
--~ 				spawn = mkr_convoyDefense3a, 				
--~ 			},
			
			
			{				
				name = "ConvoyDef3b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),			
				spawn = mkr_convoyDefense3b,
				conditions = {XP1_GetNodeStrength() <= 3},					
			},
			
			{				
				name = "ConvoyDef3b",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),			
				spawn = mkr_convoyDefense3b,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				conditions = {XP1_GetNodeStrength() >= 4},					
			},
			

			{				
				name = "ConvoyDef3c",
				sbp = XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),			
				spawn = mkr_convoyDefense3c,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},			
			},
		},		
		
		goal = {
			name = "Defend",
			target = mkr_convoyDefense3,
			range = 15,
			leashRange = 15,
			instantSetup = true,
			retaliateAttacks = false,
			tacticControlList = {
				{tacticType = TACTIC_Ability, priority = 200},
			},
			coordinatedSetupFacingPositions = {mkr_convoyDef3Facing},
			--coordinatedSetupFacingPositions = {mkr_testFacing},
		},
	}
	local enc_ConvoyDef3 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_ConvoyDef3:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_ConvoyDef3
end




ENCOUNTERS.TankDef = function()
	local encData = {
		name = "TankDef",
		spawn = {mkr_defSquad1},
		
		sgroups = {sg_tankDef},
		units = {
			{
				name = "TankDef1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				difficulty = {GD_EASY, GD_NORMAL},
				spawn = mkr_defSquad1
			},
			
			{
				name = "TankDef1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				difficulty = {GD_HARD},
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 0.5, exclusive = nil}},
				spawn = mkr_defSquad1
			},
			
			{
				name = "TankDef2",
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				difficulty = {GD_EASY, GD_NORMAL, GD_HARD},
				spawn = mkr_defSquad2
			},
		},
		onDeath = nil,
		goalData = {
			name = "Defend",
			target = mkr_secondaryObj3,
			retaliateAttacks = false,
			range = 15,			
			leashRange = 15,
		},

	}
	local enc_TankDef = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_TankDef:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_TankDef
end



ENCOUNTERS.ATGun1 = function()
	local encData = {
		name = "ATGun1",
		spawn = {g_randomSpawnLoc},
		
		sgroups = {sg_ATGun1},
		units = {
			{
				name = "ATGun1",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,				
				spawn = g_randomSpawnLoc,
			},		
		},
		onDeath = nil,
		goalData = {
			name = "Defend",
			target = g_randomSpawnLoc,
			retaliateAttacks = true,
			range = 50,			
			--leashRange = 50,
		},

	}
	local enc_ATGun1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_ATGun1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_ATGun1
end

ENCOUNTERS.ATGun2 = function()
	local encData = {
		name = "ATGun2",
		spawn = {g_randomSpawnLoc2},
		
		sgroups = {sg_ATGun2},
		units = {
			{
				name = "ATGun2",
				sbp = SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,				
				spawn = g_randomSpawnLoc2
			},		
		},
		onDeath = nil,
		goalData = {
			name = "Defend",
			target = g_randomSpawnLoc2,
			retaliateAttacks = true,
			range = 50,			
			--leashRange = 50,
		},

	}
	local enc_ATGun1 = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	enc_ATGun1:SetGoal(encData.goalData)
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_ATGun1
end

GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.myGenericGoal = function(encounter)
	local goalData = {
		name = "Defend",
		target = mkr_O1_space,
		range = 45,
		leashRange = mkr_O1_space,
		tacticControlsList = {
			{
				tacticType = TACTIC_Hold,
				priority = 500,
			},
		},
	}
	
	encounter:SetGoal(goalData)
end
