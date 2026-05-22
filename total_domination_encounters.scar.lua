print("\tLoading encdata file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- MISSION NAME - Encounters data
-- Designer: Joe Smith
-------------------------------------------------------------------------
-------------------------------------------------------------------------
ENCOUNTERS = {}

-- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
-- Remember to add a simple description for each encounter.
ENCOUNTERS.ai_base_defense_1 = function()
	local encData = {
		name = "Base Defense",
		spawn = {Util_GetRandomPosition(mkr_totalDomination_baseDef),
					Util_GetRandomPosition(mkr_totalDomination_baseDef),
					Util_GetRandomPosition(mkr_totalDomination_baseDef),
					Util_GetRandomPosition(mkr_totalDomination_baseDef),
					Util_GetRandomPosition(mkr_totalDomination_baseDef),
		},
		sgroups = {},
		intent = ENC_INTENT.battleBaseDefenses,
		
		onDeath = nil,
	}	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	GOALS.ai_base_defense_goal(enc_newEncounter)
	
	-- TODO: Add any events you want. Eg. Event_IsElementOnScreen(...)
	
	return enc_newEncounter
end

ENCOUNTERS.ai_VPAttacker_1 = function(spawnPoint)
	local encData = {
		name = "VPAttacker_1",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_VPAttacker_1, sg_VPAttacker_Overgroup},
		--intent = ENC_INTENT.battleTotalDominationPhase1Attack,

		units = 	Table_GetRandomItem({
			
			{
				XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),			
				SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
			
			},					
		
			{
				XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
				XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP}),						
				XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP}),						
							
			},	

			{
				XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),				
				XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP}),						
			},							
	
		}
		),	
		
--~ 		units = {
--~ 			{
--~ 				sbp = BP_GetSquadBlueprint("panzerfusilier_squad_mp"),
--~ 			},
--~ 		},
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomVP
	
	GOALS.ai_VP_attack_goal(enc_newEncounter, eg_randomVP)
	
	return enc_newEncounter
end


ENCOUNTERS.ai_VPAttacker_2 = function(spawnPoint)
	local encData = {
		name = "VPAttacker_2",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_VPAttacker_2, sg_VPAttacker_Overgroup},
		--intent = ENC_INTENT.battleTotalDominationPhase2Attack,
--~ 		units = {
--~ 			{
--~ 				sbp = BP_GetSquadBlueprint("panzerfusilier_squad_mp"),
--~ 			},
--~ 		},

		units = 	Table_GetRandomItem(
			{

				{
					XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),
					XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
					SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,			
				},			
			
			
				{			
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
					SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				},
				{
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,			
					SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
					SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				},
				{
					XP1_NodeDif({SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP}),
					XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP}),						
				},	
				{
					SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
					XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
					SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
				},	

			}
		),
		
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomVP
	
	GOALS.ai_VP_attack_goal(enc_newEncounter, eg_randomVP)
	
	return enc_newEncounter
end


ENCOUNTERS.ai_VPAttacker_3 = function(spawnPoint)
	local encData = {
		name = "VPAttacker_3",
		spawn = Util_GetPosition(spawnPoint),
		sgroups = {sg_VPAttacker_3, sg_VPAttacker_Overgroup},
		--intent = ENC_INTENT.battleTotalDominationPhase3Attack,
--~ 		units = {
--~ 			{
--~ 				sbp = BP_GetSquadBlueprint("panzerfusilier_squad_mp"),
--~ 			},
--~ 		},

	units = Table_GetRandomItem(
		{

			{
				SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
				SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP,
				SBP.WEST_GERMAN.MORTAR_250_HALFTRACK_SQUAD_WESTGERMAN_MP,			
			},
			{
				SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
				SBP.WEST_GERMAN.PANTHER_AUSF_G_SQUAD_MP,
				SBP.WEST_GERMAN.MG34_HEAVY_MACHINE_GUN_SQUAD_MP,
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP}),				
			},
			{
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),				
				XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP}),						
				XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.GERMAN.SCOUTCAR_SDKFZ222_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP, SBP.WEST_GERMAN.ARMORED_CAR_SDKFZ_234_SQUAD_MP}),						
				SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},	
			{
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),				
				XP1_NodeDif({SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP}),				
				SBP.WEST_GERMAN.GRW34_81MM_MORTAR_SQUAD_MP,
				XP1_NodeDif({SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP}),						
			},	

		}
	),
		onDeath = nil, -- start off countdown for next spawn?  --_pickupGroupDied,
	}
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return
	
	local target = eg_randomVP
	
	GOALS.ai_VP_attack_goal(enc_newEncounter, eg_randomVP)
	
	return enc_newEncounter
end

GOALS = {}

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_base_defense_goal = function(encounter)
	local goalData = {
		name = "Defend",
		target = mkr_totalDomination_baseDef,
		range = 65,
		leashRange = mkr_totalDomination_baseDef,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
		coordinatedSetupFacingPositions = {
			Util_GetOffsetPosition(mkr_totalDomination_baseDef, OFFSET_FRONT_LEFT, 200),
			Util_GetOffsetPosition(mkr_totalDomination_baseDef, OFFSET_FRONT, 200),
			Util_GetOffsetPosition(mkr_totalDomination_baseDef, OFFSET_FRONT_RIGHT, 200),
		},
	}
	
	encounter:SetGoal(goalData)
end

-- A goal that will be assigned to multiple encounters throughout the course of a single mission
GOALS.ai_VP_attack_goal = function(encounter, attackTar)
	local goalData = {
		name = "Defend",
		target = attackTar,
		range = 20,
		leashRange = 40,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 500,
			},
		},
		coordinatedSetupFacingPositions = {
			
		},
		coordinatedMoveRadius = 15,
	}
	
	encounter:SetGoal(goalData)
end
