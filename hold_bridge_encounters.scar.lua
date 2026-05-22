print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- HoldBridge mini-challenge - Encounters data
-- Designer: Darwin Yuen
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}


--------------------
------ Wave 1 ------
--------------------
ENCOUNTERS.Wave01 = function()
    local waveData = {
        
		encounters = {
			{
				--Encounter1
			   -- direction = NORTH, 
				--sgroups = {sg_EnemyWave1},
				units = {
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP},
				},
				hint = WAVE_VEHICLES,
			},
			{
				direction = 3,
				units = {
					SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				}
			}
		},
    }
    return waveData
end

ENCOUNTERS.Wave1SupRight = function()
	local encData = {
		name = "Wave1_SupportRight",
		spawn = mkr_challenge_axisspawn5,
		sgroups = {sg_EnemySup1},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 1.0, exclusive = nil}},			
			},		
		},
	}
	local enc_Wave1SupRight = Encounter:Create(encData)
	
	GOALS.attackCenter(enc_Wave1SupRight)
	
	return enc_Wave1SupRight
end

ENCOUNTERS.Wave1SupLeft = function()
	local encData = {
		name = "Wave1_SupportLeft",
		spawn = mkr_challenge_axisspawn2,
		sgroups = {sg_EnemySup1},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 1.0, exclusive = nil}},			
			},
		},
	}
	local enc_Wave1SupLeft = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackCenter(enc_Wave1SupLeft)
	
	return enc_Wave1SupLeft
end
  
ENCOUNTERS.Wave1SupCenter = function()
	local encData = {
		name = "Wave1_SupportCenter",
		spawn = mkr_challenge_axisspawn3,
		sgroups = {sg_EnemySup1},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
				dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 1.0, exclusive = nil}},			
			},
		},
	}
	local enc_Wave1SupCenter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackCenter(enc_Wave1SupCenter)
	
	return enc_Wave1SupCenter
end



--------------------
------ Wave 2 ------
--------------------
ENCOUNTERS.Wave02 = function()
    local waveData = {
        
		encounters = {
			{
			  --  direction = SOUTH, 
				--sgroups = {sg_EnemyWave2},
				units = {
					{sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222},
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP},
					{sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP},					
				},
				hint = WAVE_VEHICLES,
			},
		},
    }
 
    return waveData
end

ENCOUNTERS.Wave2SupRight = function()
	local encData = {
		name = "Wave2_SupportRight",
		spawn = mkr_challenge_axisspawn5,
		sgroups = {sg_EnemySup2},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1.0, exclusive = nil}},
			},		
		},
	}
	local enc_Wave2SupRight = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackRightFlank(enc_Wave2SupRight)
	
	return enc_Wave2SupRight
end

ENCOUNTERS.Wave2SupLeft = function()
	local encData = {
		name = "Wave2_SupportLeft",
		spawn = mkr_challenge_axisspawn1,
		sgroups = {sg_EnemySup2},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1.0, exclusive = nil}},
			},
		},
	}
	local enc_Wave2SupLeft = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackLeftFlank(enc_Wave2SupLeft)
	
	return enc_Wave2SupLeft
end

ENCOUNTERS.Wave2SupCenter = function()
	local encData = {
		name = "Wave2_SupportCenter",
		spawn = mkr_challenge_axisspawn4,
		sgroups = {sg_EnemySup2},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1.0, exclusive = nil}},
			},
		},
	}
	local enc_Wave2SupCenter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackCenter(enc_Wave2SupCenter)
	
	return enc_Wave2SupCenter
end



--------------------
------ Wave 3 ------
--------------------
ENCOUNTERS.Wave03 = function()
    local waveData = {
        encounters = {
			{
			  --  direction = SOUTH, 
				--sgroups = {sg_EnemyWave3},
				units = {
					SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP,
					SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
					{
						sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
						slotItems = {SLOT_ITEM.GRENADIER_MG42_LMG},
						dropItems = {{slotItem = SLOT_ITEM.GRENADIER_MG42_LMG, dropChance = 1.0, exclusive = nil}},
					},
				},
				hint = WAVE_VEHICLES,
			},
		},
    }
 
    return waveData
end

ENCOUNTERS.Wave3SupRight = function()
	local encData = {
		name = "Wave3_SupportRight",
		spawn = mkr_challenge_axisspawn5,
		sgroups = {sg_EnemySup3},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
			},		
		},
	}
	local enc_Wave3SupRight = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackRightFlank(enc_Wave3SupRight)
	
	return enc_Wave3SupRight
end

ENCOUNTERS.Wave3SupLeft = function()
	local encData = {
		name = "Wave3_SupportLeft",
		spawn = mkr_challenge_axisspawn2,
		sgroups = {sg_EnemySup3},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1.0, exclusive = nil}},
			},
		},
	}
	local enc_Wave3SupLeft = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackLeftFlank(enc_Wave3SupLeft)
	
	return enc_Wave3SupLeft
end

ENCOUNTERS.Wave3SupCenter = function()
	local encData = {
		name = "Wave3_SupportCenter",
		spawn = mkr_challenge_axisspawn3,
		sgroups = {sg_EnemySup3},
		units = {
			{
				name = "Minion1",
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				slotItems = {SLOT_ITEM.PANZERSHRECK},
				dropItems = {{slotItem = SLOT_ITEM.PANZERSHRECK, dropChance = 1.0, exclusive = nil}},
			},
		},
	}
	local enc_Wave3SupCenter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	GOALS.attackCenter(enc_Wave3SupCenter)
	
	return enc_Wave3SupCenter
end



--------------------
------ Panzer ------
--------------------
ENCOUNTERS.PanzerEncounter = function()
	local encData = {
		name = "Panzer_Boss",
		spawn = mkr_challenge_axisspawn3,
		sgroups = {sg_PanzerGroup},
		units = {
			{
				sgroups = {sg_Panzer},
				name = "Panzer_Boss",
				sbp = SBP.GERMAN.PANZER_IV_SQUAD_MP,
			},
			SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP,
			SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP,
		},
		goal = {
			name = "Attack",
			target = mkr_enemyDest,
			attackMove = true,
			range = 16,
			movePathLengthFactor = 1,
			safeMoveWeight = 0.0,
		},
	}
	local enc_newPanzerEncounter = Encounter:Create(encData) -- Always declare locally and pass back as a return
	
	return enc_newPanzerEncounter
end





GOALS = {}

-- Attack left flank
GOALS.attackLeftFlank = function(encounter)
	local goalData = {
		name = "Attack",
		target = mkr_enemyLeftDest,
		range = 5,
		leashRange = 20,
		attackMove = true,
		garrison = true,
		movePathLengthFactor = 1,
		safeMoveWeight = 0.0,
	}
	encounter:SetGoal(goalData)
end

--Right flank
GOALS.attackRightFlank = function(encounter)
	local goalData = {
		name = "Attack",
		target = mkr_enemyRightDest,
		range = 5,
		leashRange = 20,
		attackMove = true,
		garrison = true,
		movePathLengthFactor = 1,
		safeMoveWeight = 0.0,
	}
	encounter:SetGoal(goalData)
end

--Center
GOALS.attackCenter = function(encounter)
	local goalData = {
		name = "Attack",
		target = mkr_enemyDest,
		attackMove = true,
		garrison = true,
		range = 5,
		leashRange = 20,
		movePathLengthFactor = 1,
		safeMoveWeight = 0.0,
	}
	encounter:SetGoal(goalData)
end
