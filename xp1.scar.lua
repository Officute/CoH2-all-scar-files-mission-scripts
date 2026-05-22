import("XP1_Input.scar")
import("XP1_Difficulty.scar")
--Bonus objectives
import("Libraries/SecondaryObjectives/SecondaryObj_KillVIP.scar")
import("Libraries/SecondaryObjectives/SecondaryObj_RescueSquads.scar")
import("Libraries/SecondaryObjectives/SecondaryObj_DestroyTank.scar")
import("Libraries/SecondaryObjectives/SecondaryObj_DemolitionMan.scar")
import("Libraries/SecondaryObjectives/SecondaryObj_CaptureIntel.scar")

--======================================================================================================--
--=================================== XP1 Prototype Test Functions	(TO BE REMOVED) ====================--
--======================================================================================================--

-- Company enums
CD_NONE = 0
CD_AIRBORNE = 1
CD_MECHANIZED = 2
CD_SUPPORT = 3
CD_RANGER = 4

COMPANY_COUNT = 4		-- Update this each time a Company is added (Does not count CD_NONE)

-- Rankings
XPT_MSL_NONE = 0
XPT_MSL_BRONZE = 1
XPT_MSL_SILVER = 2
XPT_MSL_GOLD = 3

-- Metamap subphase
SUBPHASE_EARLY = 0
SUBPHASE_MID = 1
SUBPHASE_LATE = 2


--? @group scardoc;XP1

function XP1_Data_Init()

	-- Base Resource cap for each resource
	AE_RearEchelonSpawnEnable(false)
	
	-- Contains units that are going to refund popcap once they're gone
	-- We use this for the transfer orders function
	t_xp1PopCapRefund_units = {}
	
	-- list of sbps, abilities and upgrades we should lock out when the player reaches zero company health in the mission
	t_xp1ZeroHealthLockoutList = {
	
		-- hq
		{sbp = SBP.AEF.REAR_ECHELON_SQUAD_MP},
		{sbp = SBP.AEF.RIFLEMEN_SQUAD_MP},
		{sbp = SBP.AEF.DODGE_WC51_AMBULANCE_SQUAD_MP},
		{sbp = SBP.AEF.M3_HALFTRACK_SQUAD_MP},
		
		-- lieutenant building
		{upg = UPG.AEF.LIEUTENANT_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M20_UTILITY_CAR_SQUAD_MP},
		{sbp = SBP.AEF.M15A1_AA_HALFTRACK_SQUAD_MP},
		{sbp = SBP.AEF.DODGE_WC51_50CAL_SQUAD_MP},
		{sbp = SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP},
		{sbp = SBP.AEF.LIEUTENANT_SQUAD_MP},
		{sbp = SBP.AEF.M1_57MM_AT_GUN_SQUAD_BOB},
		{ability = BP_GetAbilityBlueprint("pm_airborne_dispatch_pathfinders")},
		
		-- captain building
		{upg = UPG.AEF.CAPTAIN_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M1_75MM_PACK_HOWITZER_SQUAD_MP},
		{sbp = SBP.AEF.M1_81MM_MORTAR_SQUAD_MP},
		{sbp = SBP.AEF.M5A1_STUART_SQUAD_MP},
		{sbp = SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP},
		{sbp = SBP.AEF.CAPTAIN_SQUAD_MP},
		{sbp = SBP.AEF.M8_GREYHOUND_SQUAD_MP},
		
		-- major building
		{upg = UPG.AEF.MAJOR_DISPATCHED_UPGRADE_MP},
		{sbp = SBP.AEF.M4A3_76MM_SHERMAN_BULLDOZER_SQUAD_MP},
		{sbp = SBP.AEF.M4A3_SHERMAN_SQUAD_MP},
		{sbp = SBP.AEF.M4A3_76MM_SHERMAN_SQUAD_MP},
		{sbp = SBP.AEF.M8A1_HMC_SQUAD_MP},
		{sbp = SBP.AEF.M36_TANK_DESTROYER_SQUAD_MP},
		{sbp = SBP.AEF.M10_TANK_DESTROYER_SQUAD_MP},
		{sbp = SBP.AEF.M7B1_PRIEST_SQUAD_MP},
		{sbp = SBP.AEF.MAJOR_SQUAD_MP},
		
		-- other
		{ability = BP_GetAbilityBlueprint("pm_airborne_paratroopers")},
		{ability = BP_GetAbilityBlueprint("pm_airborne_paratroopers_accurate")},
		{ability = BP_GetAbilityBlueprint("assault_engineer_call_in")},
		{ability = BP_GetAbilityBlueprint("pm_cavalry_riflemen_group")},
		{ability = BP_GetAbilityBlueprint("pm_armored_support")},
		{ability = BP_GetAbilityBlueprint("pm_ranger_dispatch")},
	}
	
	-- Starting Units
	t_xp1Division_starting_units = {
		{	-- Airborne
			{BP_GetSquadBlueprint("pathfinder_squad_mp"), BP_GetSquadBlueprint("riflemen_squad_mp")},
			{BP_GetSquadBlueprint("pathfinder_squad_mp"), BP_GetSquadBlueprint("riflemen_squad_mp")},
			{BP_GetSquadBlueprint("pathfinder_squad_mp"), BP_GetSquadBlueprint("m5a1_stuart_squad_mp")},
			{BP_GetSquadBlueprint("pathfinder_squad_mp"), BP_GetSquadBlueprint("riflemen_squad_mp"), BP_GetSquadBlueprint("m4a3_sherman_squad_mp")},
		},
		{	-- Mechanized
			{BP_GetSquadBlueprint("pm_riflemen_squad_omcg"), BP_GetSquadBlueprint("m3_halftrack_squad_mp")},
			{BP_GetSquadBlueprint("riflemen_squad_mp"), BP_GetSquadBlueprint("pm_riflemen_squad_omcg"), BP_GetSquadBlueprint("m3_halftrack_squad_mp")},
			{BP_GetSquadBlueprint("riflemen_squad_mp"), BP_GetSquadBlueprint("pm_riflemen_squad_omcg"), BP_GetSquadBlueprint("m5a1_stuart_squad_mp")},
			{BP_GetSquadBlueprint("riflemen_squad_mp"), BP_GetSquadBlueprint("pm_riflemen_squad_omcg"), BP_GetSquadBlueprint("m3_halftrack_squad_mp"), BP_GetSquadBlueprint("m4a3_sherman_squad_mp")},
		},
		{	-- Support
			{BP_GetSquadBlueprint("assault_engineer_squad_mp"), BP_GetSquadBlueprint("m2hb_50cal_hmg_squad_mp")},
			{BP_GetSquadBlueprint("assault_engineer_squad_mp"), BP_GetSquadBlueprint("m2hb_50cal_hmg_squad_mp"), BP_GetSquadBlueprint("m1_81mm_mortar_squad_mp")},
			{BP_GetSquadBlueprint("assault_engineer_squad_mp"), BP_GetSquadBlueprint("m2hb_50cal_hmg_squad_mp"), BP_GetSquadBlueprint("m1_81mm_mortar_squad_mp"), BP_GetSquadBlueprint("m1_57mm_at_gun_squad_mp")},
			{BP_GetSquadBlueprint("assault_engineer_squad_mp"), BP_GetSquadBlueprint("m2hb_50cal_hmg_squad_mp"), BP_GetSquadBlueprint("m1_75mm_pack_howitzer_squad_mp"), BP_GetSquadBlueprint("m4a3_sherman_squad_mp")},
		},
		{	-- Ranger
			{BP_GetSquadBlueprint("ranger_squad_mp")},
			{BP_GetSquadBlueprint("ranger_squad_mp")},
			{BP_GetSquadBlueprint("ranger_squad_mp"), BP_GetSquadBlueprint("ranger_squad_mp"), BP_GetSquadBlueprint("m5a1_stuart_squad_mp")},
			{BP_GetSquadBlueprint("ranger_squad_mp"), BP_GetSquadBlueprint("ranger_squad_mp"), BP_GetSquadBlueprint("m4a3_sherman_squad_mp")},
		},
	}
	
	eg_XP1_rifle_command = EGroup_CreateIfNotFound("eg_XP1_rifle_command")
	eg_XP1_weapons_pool = EGroup_CreateIfNotFound("eg_XP1_weapons_pool")
	eg_XP1_armored_rifle_command = EGroup_CreateIfNotFound("eg_XP1_armored_rifle_command")
	eg_XP1_armor_command = EGroup_CreateIfNotFound("eg_XP1_armor_command")
	eg_XP1_player_base = EGroup_CreateIfNotFound("eg_XP1_player_base")
	sg_XP1_base_units = SGroup_CreateIfNotFound("sg_XP1_base_units")
	
	XP1_SetupTuningVariables()
	
	-- LOC names for each company
	t_xp1Division_LocNames = {
		11078325, -- Able Company (Airborne)
		11078326, -- Baker Comapny (Mechanized)
		11078327, -- Dog Company (Support)
		11078473, -- Fox Company (Ranger)
	}
	
	-- Company Default actors
	g_xp1Division_DefaultActorName = ACTOR.American_Major_01
	t_xp1Division_ActorNames = {
		ACTOR.Vastano,
		ACTOR.Edwards,
		ACTOR.Derby,
		ACTOR.Durante,
	}
	
	-- Company names 
	t_xp1Division_Names = {
		"AIRBORNE",
		"MECHANIZED",
		"SUPPORT",
		"RANGER",
	}
	
	-- Company Icons
	t_xp1Division_Icons = {
		"Icons_bob_companies_type_airborne_small",	-- Airborne
		"Icons_bob_companies_type_infantry_small",	-- Mechanized
		"Icons_bob_companies_type_support_small",	-- Support
		"Icons_bob_companies_type_ranger_small",	-- Rangers
	}
	
	-- Requisition rewards for mission success level
	t_xp1Division_MissionSuccess_ReqRewards = {
		Util_DifVar({25, 24, 22}),		-- Bronze
		Util_DifVar({27, 27, 26}),		-- Silver
		Util_DifVar({30, 30, 30}),		-- Gold
	}
	
	tmr_levelUp = "tmr_levelUp"
	
	-- Stores any units that arrive on map vetted up as well as the amount of experience they have
	-- This is so gifted xp to that unit does not contribute to the overall company xp level
	t_vetGiftedUnits = {}
		
	-- Tracks if we've played the warning speech
	g_75_health_speech = false
	g_50_health_speech = false
	g_25_health_speech = false
	g_5_health_speech = false
	g_recover_health_speech = false

	
end

Scar_AddInit(XP1_Data_Init)

function XP1_SetupTuningVariables()
	g_tuningVariablesVersion = 1
	
	-- Controls the chance of a squad spawning in at a vet level
	t_xp1Division_vet_chance = {
		Util_DifVar({25, 20, 15}), -- Airborne (Easy, Normal, Hard)
		Util_DifVar({25, 20, 15}), -- Mechanized (Easy, Normal, Hard)
		Util_DifVar({25, 20, 15}), -- Support (Easy, Normal, Hard)
		Util_DifVar({25, 20, 15}), -- Ranger (Easy, Normal, Hard)
	}
	
	-- Represents the actual 'strength' of the company, how much strength they have
	t_xp1Division_popcap_total = {
		Util_DifVar({2000, 2000, 2000}), -- Airborne (Easy, Normal, Hard)
		Util_DifVar({2000, 2000, 2000}), -- Mechanized (Easy, Normal, Hard)
		Util_DifVar({2000, 2000, 2000}), -- Support (Easy, Normal, Hard)
		Util_DifVar({2000, 2000, 2000}), -- Ranger (Easy, Normal, Hard)
	}
	
	-- Multiplier applied to a squad popcap when a squad dies
	-- First number is for challenges, the second is for battles
	t_xp1Division_squad_popcap_loss = {
		{Util_DifVar({1, 2, 2}), Util_DifVar({1, 2, 2})}, -- Airborne (Easy, Normal, Hard)
		{Util_DifVar({0.8, 1.6, 1.6}), Util_DifVar({0.8, 1.6, 1.6})}, -- Mechanized (Easy, Normal, Hard)
		{Util_DifVar({1, 2, 2}), Util_DifVar({1, 2, 2})}, -- Support (Easy, Normal, Hard)
		{Util_DifVar({1, 2, 2}), Util_DifVar({1, 2, 2})}, -- Ranger (Easy, Normal, Hard)
	}
	 
	-- Multiplier applied to a entity popcap when a unit dies
	t_xp1Division_entity_popcap_loss = {
		{Util_DifVar({4, 4, 5}), Util_DifVar({4, 4, 5})}, -- Airborne (Easy, Normal, Hard)
		{Util_DifVar({3.4, 3.4, 4.5}), Util_DifVar({3.4, 3.4, 4.5})}, -- Mechanized (Easy, Normal, Hard)
		{Util_DifVar({4, 4, 5}), Util_DifVar({4, 4, 5})}, -- Support (Easy, Normal, Hard)
		{Util_DifVar({4, 4, 5}), Util_DifVar({4, 4, 5})}, -- Ranger (Easy, Normal, Hard)
	}
	
	-- Amount of Vet required to level up
	-- Within each Difficulty level are the numbertotalXPs to level up to Vet 1, 2, 3
	t_xp1Division_vet_level_requirement = {
		Util_DifVar({{240, 260, 280}, {260, 280, 300}, {280, 300, 320},}), -- Airborne (Easy, Normal, Hard)
		Util_DifVar({{240, 260, 280}, {260, 280, 300}, {280, 300, 320},}), -- Mechanized (Easy, Normal, Hard)
		Util_DifVar({{220, 240, 260}, {240, 260, 280}, {260, 280, 300},}), -- Support (Easy, Normal, Hard)
		Util_DifVar({{240, 260, 280}, {260, 280, 300}, {280, 300, 320},}), -- Ranger (Easy, Normal, Hard)
	}
	
	-- Amount of Company Strength (real) granted when a player vets up in game.
	t_xp1Division_level_up_strength_gift = {
		Util_DifVar({15, 10, 5}), -- Airborne (Easy, Normal, Hard)
		Util_DifVar({15, 10, 5}), -- Mechanized (Easy, Normal, Hard)
		Util_DifVar({15, 10, 5}), -- Support (Easy, Normal, Hard)
		Util_DifVar({15, 10, 5}), -- Ranger (Easy, Normal, Hard)
	}
	
	-- A resource rate added for each vet level
	t_xp1Division_resource_rate_bonus = {
		{	-- Airborne
			{1.1, 1.15, 1.2},	-- Manpower
			{1.25, 1.3, 1.35}, -- Munition
			{1.4, 1.45, 1.5},	-- Fuel
			{2.1, 2.2, 2.3}, -- Action
		},
		{	-- Mechanized
			{1.1, 1.15, 1.2},	-- Manpower
			{1.25, 1.3, 1.35}, -- Munition
			{1.4, 1.45, 1.5},	-- Fuel
			{2.1, 2.2, 2.3}, -- Action
		},
		{	-- Support
			{1.1, 1.15, 1.2},	-- Manpower
			{1.25, 1.3, 1.35}, -- Munition
			{1.4, 1.45, 1.5},	-- Fuel
			{2.1, 2.2, 2.3}, -- Action
		},
		{	-- Rangers
			{1.1, 1.15, 1.2},	-- Manpower
			{1.25, 1.3, 1.35}, -- Munition
			{1.4, 1.45, 1.5},	-- Fuel
			{2.1, 2.2, 2.3}, -- Action
		},
	}
end


function XP1_GetMissionType()
	if g_missionData.missionType == MT_XP1_CHALLENGE then
		return 1
	else
		return 2
	end
	return 1
end

--Creates the t_companiesTable based on the company data coming in from the frontend.
-- adds 'company', 'isPresent', 'isActive',
function Populate(companies)
	local masterTable = {}
	for i = 1, COMPANY_COUNT do
		local t = {}
		t.company = i
		t.isPresent = false
		t.isActive = false
		
		for k,v in pairs(companies) do
			if v.company == i then
				t = companies[k]
				t.isPresent = true
				if v.primaryCompany then
					t.isActive = true
					g_xp1_initialCompany = i
				end
				if v.companyVetLevel == 0 then
					t.companyVetLevel = 0
				end
			end
		end
		
		t.companyLocName = t_xp1Division_LocNames[i]
		t.companyName = t_xp1Division_Names[i]
		t.companyIcon = t_xp1Division_Icons[i]
		
		table.insert(masterTable, t)
	end
	if table.getn(masterTable) == 0 then
		fatal("ERROR: Unable to populate companies table")
	end
	return masterTable
end

function XP1_PrototypeSetupParameters(data, companies)
	player1 = player1 or Game_GetLocalPlayer()
	
	t_companiesTable = Populate(companies)
	g_xp1_activeCompany = CD_NONE
	
	t_activeCompanyBonusUpgrades = {}
	t_activeCompanyAbilityUpgrades = {}
	t_activeCompanySpecializations = {}
	t_activeCompanyUnits = {}
	g_spawnedStartingUnits = false
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("aef_pm"))
	
	g_missionSuccessLevel = XPT_MSL_BRONZE
	
	g_mission = data.mission
	
	g_currMetaSubphase = data.subphase
	
	g_currNodeStrength = data.strength
	
	_XP1_CollectBase()
	
	XP1_DifficultyLevel_Init(g_currNodeStrength)
	XP1_SetAbilities(t_companiesTable)
	
	XP1_SetActiveCommander(g_xp1_initialCompany, true)
	
	Rule_AddGlobalEvent(XP1_Squad_Killed_Callback, GE_SquadKilled)
	Rule_AddGlobalEvent(XP1_Entity_Killed_Callback, GE_EntityKilled)
	
	-- Mission type 
	g_missionType = XP1_GetMissionType()
	
end

function XP1_CompanyIsActive()
	if g_xp1_activeCompany == CD_NONE then
		return false
	else
		return true
	end
end

--? @shortdesc Returns true if there is a company active.  Used mainly to check if it's safe to alter stored data
--? @args bool isCompanyActive
function XP1_IsCompanyAvailable(companyID)
	for k,v in pairs(t_companiesTable) do
		if v.isPresent and v.company == companyID then
			return true
		end
	end
	return false
end


--? @shortdesc Sets the current commander (CD_AIRBORNE, CD_MECHANIZED, CD_SUPPORT). If nil is passed in, will re-set to the primary commander.  Note this should be done behind a fade to black or something
--? @args int CommanderDivision[, bool showUIDetails]
function XP1_SetActiveCommander(companyID, showUIDetails)
	if XP1_IsCompanyAvailable(companyID) == false then
		fatal("Company with id "..companyID.." is not available")
	end
	
	-- If there is currently an active company, store it's data
	if XP1_CompanyIsActive() then
		t_companiesTable[g_xp1_activeCompany].companyStrengthTable = t_companyStrength
		t_companiesTable[g_xp1_activeCompany].currentVetLevel = g_xp1DivisionVetLevel
		t_companiesTable[g_xp1_activeCompany].currentXP = g_xp1DivisionVetXP
		t_companiesTable[g_xp1_activeCompany].giftXP = g_xp1_giftXP
		t_companiesTable[g_xp1_activeCompany].unitXP = g_xp1_unitXP
		t_companiesTable[g_xp1_activeCompany].companyPerformanceTable = t_companyPerformance
		
--~ 		t_companiesTable[g_xp1_activeCompany].earnedUnitXP = g_xp1_storedUnitXP
--~ 		t_companiesTable[g_xp1_activeCompany].storedGiftXP = g_xp1_storedGiftXP
		
		if g_eventIDVetCheck ~= nil then
			Event_Remove(g_eventIDVetCheck)
		end
		
		if g_xp1DivisionVetLevel > 0 then
			Modifier_Remove(g_xp1VetResourceRate_man)
			Modifier_Remove(g_xp1VetResourceRate_mun)
			Modifier_Remove(g_xp1VetResourceRate_fuel)
			Modifier_Remove(g_xp1VetResourceRate_action)
		end
		XP1_DivisionVetLevel_Set(0)
	end
	
	-- Data is stored safely, we can now switch to the new company
	-- Check if the company is actually active on the map
	g_xp1_activeCompany = companyID
	
	--Show/hide the company strength/exp. Show by default
	if scartype(showUIDetails) == ST_BOOLEAN then
		g_xp1_companyUIDetails = showUIDetails
	else
		g_xp1_companyUIDetails = true
	end
	
	for k,v in pairs(t_companiesTable) do
		if v.isActive == true then
			v.isActive = false
		elseif k == g_xp1_activeCompany then
			v.isActive = true
		end
	end
	
	local upgradesApplied = false
	
	if XP1_CompanyIsActive() then
		-- Company Veterancy
		-- Determine currently 'stored' Vet XP
		t_companiesTable[g_xp1_activeCompany].startingRealXP = t_companiesTable[g_xp1_activeCompany].companyVetXP -- 0-300 Value
		
		g_xp1DivisionVetLevel = t_companiesTable[g_xp1_activeCompany].companyVetLevel
		
		g_xp1_unitXP = t_companiesTable[g_xp1_activeCompany].unitXP or 0
		g_xp1_giftXP = t_companiesTable[g_xp1_activeCompany].giftXP or 0		
		
		if g_xp1DivisionVetLevel > 0 then
			g_xp1VetResourceRate_man = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Manpower, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][1][g_xp1DivisionVetLevel])
			g_xp1VetResourceRate_mun = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Munition, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][2][g_xp1DivisionVetLevel])
			g_xp1VetResourceRate_fuel = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Fuel, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][3][g_xp1DivisionVetLevel])
			g_xp1VetResourceRate_action = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Action, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][4][g_xp1DivisionVetLevel])
		end
		
		if t_companiesTable[g_xp1_activeCompany].companyStrengthTable == nil then
			t_companyStrength = {
				divisionStrength = t_companiesTable[g_xp1_activeCompany].companyStrength,
				startingStrength = t_companiesTable[g_xp1_activeCompany].companyStrength,
				divisionStrengthActual = t_xp1Division_popcap_total[g_xp1_activeCompany]*(t_companiesTable[g_xp1_activeCompany].companyStrength/100),
			}
		else
			t_companyStrength = t_companiesTable[g_xp1_activeCompany].companyStrengthTable
		end
		
		if t_companiesTable[g_xp1_activeCompany].companyPerformanceTable == nil then
			t_companyPerformance = {
				startingStrength = t_companyStrength.divisionStrength,
				startingVet = g_xp1DivisionVetXP,
				startingStrength_Actual = t_xp1Division_popcap_total[g_xp1_activeCompany]*(t_companyStrength.divisionStrength/100),
			}
		else
			t_companyPerformance = t_companiesTable[g_xp1_activeCompany].companyPerformanceTable
		end
		
		-- Const data
		g_xp1DivisionVetChance = t_xp1Division_vet_chance[g_xp1_activeCompany]
		g_xp1DivisionResourceRate = t_xp1Division_resource_rate_bonus[g_xp1_activeCompany]
		
		sg_xp1VetCheck = SGroup_CreateIfNotFound("sg_xp1VetCheck")
		Player_GetAll(Game_GetLocalPlayer(), sg_xp1VetCheck)
		g_eventIDVetCheck = Event_Timer(XP1_VeterancyCheck, {vetLevel = g_xp1DivisionVetLevel, vetChance = g_xp1DivisionVetChance}, 0.1)
--~ 		g_eventIDVetCheck = XP1_VeterancyCheck()
		
		
		if g_spawnedStartingUnits == false and g_missionData.missionType == MT_XP1_CHALLENGE then
			g_spawnedStartingUnits = true
			XP1_SetAbilityUpgrades(g_xp1_activeCompany)
			upgradesApplied = true
			_XP1_SpawnStartingUnits()
		end
	end
	
	XP1_SetBonusUpgrades(g_xp1_activeCompany)
	XP1_SetPerks(g_xp1_activeCompany)
	if upgradesApplied == false then
		XP1_SetAbilityUpgrades(g_xp1_activeCompany)
	end
	XP1_SetSpecializations(g_xp1_activeCompany)
	XP1_SetUnits(g_xp1_activeCompany)
	
	Setup_SetPlayerName(Game_GetLocalPlayer(), t_xp1Division_LocNames[g_xp1_activeCompany])
	
	-- Meta variables
	startingMetaXP = t_companiesTable[g_xp1_activeCompany].companyVetXP
	startingMetaLvl = t_companiesTable[g_xp1_activeCompany].companyVetLevel
	
	totalXP = 0
	minXP = 0
	giftXP = 0
	topUpXP = 0
	reqForLast = 0
	reqForLastAdj = 0
	Vet_Setup()
	XP1_ToggleUI()	
end

function _xp1_applyResourceIncomeModifiers()
	if g_xp1DivisionVetLevel > 0 then
		Modifier_Remove(g_xp1VetResourceRate_man)
		Modifier_Remove(g_xp1VetResourceRate_mun)
		Modifier_Remove(g_xp1VetResourceRate_fuel)
		Modifier_Remove(g_xp1VetResourceRate_action)
		
		g_xp1VetResourceRate_man = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Manpower, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][1][g_xp1DivisionVetLevel])
		g_xp1VetResourceRate_mun = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Munition, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][2][g_xp1DivisionVetLevel])
		g_xp1VetResourceRate_fuel = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Fuel, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][3][g_xp1DivisionVetLevel])
		g_xp1VetResourceRate_action = Modify_PlayerResourceRate(Game_GetLocalPlayer(), RT_Action, t_xp1Division_resource_rate_bonus[g_xp1_activeCompany][4][g_xp1DivisionVetLevel])
	end
end

--? @shortdesc Returns the indicated commander's data table.  If nil is passed, will return the current active commander.
--? @args int CommanderDivision
function XP1_GetCommanderDataTable(companyID)
	companyID = companyID or g_xp1_activeCompany
	
	return t_companiesTable[companyID]
end

function XP1_SetAbilities()	
	for i = 1, table.getn(t_companiesTable) do
		if t_companiesTable[i].companyAbilityNames ~= nil then
			for m = 1, table.getn(t_companiesTable[i].companyAbilityNames) do
				Player_AddAbility(Game_GetLocalPlayer(), BP_GetAbilityBlueprint(t_companiesTable[i].companyAbilityNames[m]))
			end
		end
	end
end

function XP1_SetPerks(companyID)
	company = companyID or g_xp1_activeCompany
		
	if table.getn(t_activeCompanyBonusUpgrades) > 0 then
		for i = table.getn(t_activeCompanyBonusUpgrades), 1, -1 do 
			Player_RemoveUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_activeCompanyBonusUpgrades[i]))
			table.remove(t_activeCompanyBonusUpgrades, i)
		end
	end
	
	if g_xp1_activeCompany ~= CD_NONE then
		for i = 1, table.getn(t_companiesTable[companyID].companyPerks) do 
			table.insert(t_activeCompanyBonusUpgrades, t_companiesTable[companyID].companyPerks[i])
			Player_CompleteUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_companiesTable[companyID].companyPerks[i]))
		end
	end
end

function XP1_SetBonusUpgrades(companyID)
	company = companyID or g_xp1_activeCompany
		
	if table.getn(t_activeCompanyBonusUpgrades) > 0 then
		for i = table.getn(t_activeCompanyBonusUpgrades), 1, -1 do 
			Player_RemoveUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_activeCompanyBonusUpgrades[i]))
			table.remove(t_activeCompanyBonusUpgrades, i)
		end
	end
	
	if g_xp1_activeCompany ~= CD_NONE then
		for i = 1, table.getn(t_companiesTable[companyID].companyBonusUpgrades) do 
			table.insert(t_activeCompanyBonusUpgrades, t_companiesTable[companyID].companyBonusUpgrades[i])
			Player_CompleteUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_companiesTable[companyID].companyBonusUpgrades[i]))
		end
	end
end

function XP1_SetAbilityUpgrades(companyID)
	company = companyID or g_xp1_activeCompany
		
	if table.getn(t_activeCompanyAbilityUpgrades) > 0 then
		for i = table.getn(t_activeCompanyAbilityUpgrades), 1, -1 do 
			Player_RemoveUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_activeCompanyAbilityUpgrades[i]))
			table.remove(t_activeCompanyAbilityUpgrades, i)
		end
	end
	
	if g_xp1_activeCompany ~= CD_NONE then
		for i = 1, table.getn(t_companiesTable[companyID].companyAbilityUpgrades) do 
			table.insert(t_activeCompanyAbilityUpgrades, t_companiesTable[companyID].companyAbilityUpgrades[i])
			Player_CompleteUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_companiesTable[companyID].companyAbilityUpgrades[i]))
		end
	end
end

function XP1_SetSpecializations(companyID)
	company = companyID or g_xp1_activeCompany
		
	if table.getn(t_activeCompanySpecializations) > 0 then
		for i = table.getn(t_activeCompanySpecializations), 1, -1 do 
			Player_RemoveUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_activeCompanySpecializations[i]))
			table.remove(t_activeCompanySpecializations, i)
		end
	end
	
	if g_xp1_activeCompany ~= CD_NONE then
		for i = 1, table.getn(t_companiesTable[companyID].companySpecializations) do 
			table.insert(t_activeCompanySpecializations, t_companiesTable[companyID].companySpecializations[i])
			Player_CompleteUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_companiesTable[companyID].companySpecializations[i]))
		end
	end
end

function XP1_SetUnits(companyID)
	company = companyID or g_xp1_activeCompany
		
	if table.getn(t_activeCompanyUnits) > 0 then
		for i = table.getn(t_activeCompanyUnits), 1, -1 do 
			Player_RemoveUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_activeCompanyUnits[i]))
			table.remove(t_activeCompanyUnits, i)
		end
	end
	
	if g_xp1_activeCompany ~= CD_NONE then
		for i = 1, table.getn(t_companiesTable[companyID].companyUnits) do 
			table.insert(t_activeCompanyUnits, t_companiesTable[companyID].companyUnits[i])
			Player_CompleteUpgrade(Game_GetLocalPlayer(), BP_GetUpgradeBlueprint(t_companiesTable[companyID].companyUnits[i]))
		end
	end
end

--? @shortdesc Adjusts the current mission success level by the amount provided (Mission Success Level is an int clamped between 0 and 3)
--? @args int amount
function XP1_IncrementMissionSuccessLevel(amount)
	XP1_SetMissionSuccessLevel(g_missionSuccessLevel + amount)
end

--? @shortdesc Sets the current mission success level to the amount provided (Mission Success Level is an int clamped between 0 and 100)
--? @args int newValue
function XP1_SetMissionSuccessLevel(newValue)
	g_missionSuccessLevel = newValue
	
	if (g_missionSuccessLevel > XPT_MSL_GOLD) then
		g_missionSuccessLevel = XPT_MSL_GOLD
	end
	
	if (g_missionSuccessLevel < XPT_MSL_NONE) then
		g_missionSuccessLevel = XPT_MSL_NONE
	end
end

--? @shortdesc Return the current MissionSuccessLevel [0-100]
--? @result Int
function XP1_GetMissionSuccessLevel()
	return g_missionSuccessLevel
end


--? @shortdesc Stop tracking all real-time changes in Company Strength and Experience
--? @result Void
function XP1_StopCompanyStatTracking()
	if Rule_Exists(XP1_Squad_Killed_Callback) then Rule_RemoveGlobalEvent(XP1_Squad_Killed_Callback) end
	if Rule_Exists(XP1_Entity_Killed_Callback) then Rule_RemoveGlobalEvent(XP1_Entity_Killed_Callback) end
	Rule_RemoveIfExist(Vet_Update)
end

---------------------///////////////////////////////////////////////////-------------------------------
-- Process the fact a squad was killed (effects on popCap and Company Strength)
function XP1_Squad_Killed_Callback(victim, killer)
	if XP1_CompanyIsActive() == false then
		return
	end
	if Player_OwnsSquad(Game_GetLocalPlayer(), victim) then
		
		-- Check to see if the squad was the driver of a vehicle, if so, don't count it
		local countThisSquad = true
		for i=1, #driverSquadList do
			if (driverSquadList[i] == Squad_GetGameID(victim)) then
				countThisSquad = false
				table.remove(driverSquadList, i)
				break
			end
		end
		
		if (countThisSquad) then
			local squadPop = Squad_Population(victim, CT_Personnel)
			
			local totalHit = (squadPop*t_xp1Division_squad_popcap_loss[g_xp1_activeCompany][g_missionType])
			
			XP1_SetActualCompanyStrength(XP1_GetActualCompanyStrength()-totalHit)
			
			-- Update the UI
			local UIAmount = math.floor(((XP1_GetActualCompanyStrength()/t_xp1Division_popcap_total[g_xp1_activeCompany])*100)+0.5)
	 
			XP1_SetCompanyStrength(UIAmount)
			
			XP1_UpdateCompanyUI()
		end
	end
end

driverSquadList = {}

-- Processes the fact an entity was killed (effects on popCap and Company Strength)
function XP1_Entity_Killed_Callback(victim, killer, deathReason)
	if XP1_CompanyIsActive() == false then
		return
	end
	if Player_OwnsEntity(Game_GetLocalPlayer(), victim) then
	
		local countEntity = true
		if (Entity_IsPartOfSquad(victim)) then
			local victimSquad = Entity_GetSquad(victim)
			local driver = Squad_GetVehicleMobileDriverSquad(victimSquad)
			
			if (driver ~= nil) then					
				table.insert(driverSquadList, Squad_GetGameID(driver))
			end
			
			for k,squad in pairs(driverSquadList) do
				if (squad == Squad_GetGameID(victimSquad)) then
					countEntity = false
				end
			end
		end
		
		if (countEntity) then
			local entityPop = Entity_Population(victim, CT_Personnel)
			
			local totalHit = (entityPop*t_xp1Division_entity_popcap_loss[g_xp1_activeCompany][g_missionType])
		
			XP1_SetActualCompanyStrength(XP1_GetActualCompanyStrength()-totalHit)
			
			-- Update the UI
			local UIAmount = math.floor(((XP1_GetActualCompanyStrength()/t_xp1Division_popcap_total[g_xp1_activeCompany])*100)+0.5)

			XP1_SetCompanyStrength(UIAmount)

			XP1_UpdateCompanyUI()
		end

	end
end

--? @shortdesc Return the current Company's strength [0-100]
--? @result Int
function XP1_GetCompanyStrength()
	return math.floor(t_companyStrength.divisionStrength)
end

--? @shortdesc Return the current Company's Actual strength 
--? @extdesc Actual strength is a real number denoting the company's strength 
--? @result Int
function XP1_GetActualCompanyStrength()
	return t_companyStrength.divisionStrengthActual
end

--? @shortdesc Set the current Company's Actual strength
--? @extdesc Actual strength is a real number denoting the company's strength 
--? @args Int strength
function XP1_SetActualCompanyStrength(amount)
	t_companyStrength.divisionStrengthActual = amount
end
--? @shortdesc Set the current Company's strength [0-100]
--? @args Int strength
function XP1_SetCompanyStrength(amount)
	-- save the old value for later
	local oldAmount = t_companyStrength.divisionStrength
	-- force the amount into a bracketed range of 0 - 100
	amount = math.max(amount, 0)
	amount = math.min(amount, 100)
	
	t_companyStrength.divisionStrength = amount		-- set the new value
	
	-- deal with any warnings and/or effects that are now neccesary.
	if amount <= 0 and oldAmount > 0 then
		-- Play speech at 0%
		Util_StartIntel(t_metagameEVENTS._0_HEALTH)
		-- tell the player that they have hit zero health and do the lockouts
		if evt_XP1MissionLost == nil then
			evt_XP1MissionLost = Event_PlayerSquadCount(Mission_Fail, nil, player1, 0, 1)
		end
		XP1_SetAllUnitProductionAvailability(ITEM_LOCKED)
		Util_MissionTitle(11078321) -- LOCDB [11078321] 'All company strength lost. You can no longer build units.'	
	elseif amount > 0 and oldAmount <= 0 then
		
		-- the player has recovered from zero health!
		if evt_XP1MissionLost ~= nil then
			Event_Remove(evt_XP1MissionLost)
			evt_XP1MissionLost = nil 
		end
		-- Play speech at 75%
		if g_recover_health_speech == false then
			g_recover_health_speech = true
			Util_StartIntel(t_metagameEVENTS._RECOVER_HEALTH)
		end
		XP1_SetAllUnitProductionAvailability(ITEM_DEFAULT)
		Util_MissionTitle(11078322) -- LOCDB [11078322] 'Company strength regained.  Unit production reinstated.'
	elseif amount <= 75 and oldAmount > 75 then
		print("75% Health")
		-- Play speech at 75%
		if g_75_health_speech == false then
			g_75_health_speech = true
			Util_StartIntel(t_metagameEVENTS._75_HEALTH)
		end
	elseif amount <= 50 and oldAmount > 50 then
		print("50% Health")
		-- Play speech at 50%
		if g_50_health_speech == false then
			g_50_health_speech = true
			Util_StartIntel(t_metagameEVENTS._50_HEALTH)
		end
	elseif amount <= 25 and oldAmount > 25 then
		-- Play speech at 25%
		if g_25_health_speech == false then
			g_25_health_speech = true
			Util_StartIntel(t_metagameEVENTS._25_HEALTH)
		end
	elseif amount <= 5 and oldAmount > 5 then
		-- Play speech at 5%
		if g_5_health_speech == false then
			g_5_health_speech = true
			Util_StartIntel(t_metagameEVENTS._5_HEALTH)
		end
		-- warn the player that their company strength is dangerously low
		Util_MissionTitle(11078323) -- LOCDB [11078323] 'Company strength dangerously low.'
	end
	
	--TempUI update
	XP1_UpdateCompanyUI()
end

--? @shortdesc Add to the current Company's strength
--? @args Int strength, Bool announce
function XP1_AddCompanyStrength(newAmount, announce)
	
	if announce == nil then
		announce = true				-- default values for parameters
	end

	-- calculate old and new values
	local oldValue = XP1_GetCompanyStrength()
	local newValue = oldValue + newAmount
	XP1_SetCompanyStrength(newValue)
	
	if announce == true then
		Util_MissionTitle(Loc_FormatText(11076450, Loc_ConvertNumber(XP1_GetCompanyStrength())), 2, 5, 2)		-- LOCDB [11076450] 'Reinforcements received - Company Strength increased to %1COMPANY_STRENGTH%'
	end
end

--? @shortdesc Reduce the current Company's strength [0-100]
--? @result Int strength, Bool announce
function XP1_RemoveCompanyStrength(newAmount, announce)
	
	if announce == nil then
		announce = true				-- default values for parameters
	end
	
	-- calculate old and new values
	local oldValue = XP1_GetCompanyStrength()
	local newValue = oldValue - newAmount
	XP1_SetCompanyStrength(newValue)
	
	-- show message
	if announce == true then
		Util_MissionTitle(Loc_FormatText(11078324, Loc_ConvertNumber(XP1_GetCompanyStrength())), 2, 5, 2)
	end
end

-- stops the player building units once they've hit zero health
function XP1_SetAllUnitProductionAvailability(availability)
	
	for index, item in pairs(t_xp1ZeroHealthLockoutList) do 
		if item.sbp ~= nil then
			Player_SetSquadProductionAvailability(player1, item.sbp, availability)
		elseif item.ability ~= nil then
			Player_SetAbilityAvailability(player1, item.ability, availability)
		elseif item.upg ~= nil then
			Player_SetUpgradeAvailability(player1, item.upg, availability)
		end
	end
end

---------------------///////////////////////////////////////////////////-------------------------------
-- Mission Functions
function XP1_PrototypeSetup()
	if XP1SetupParameters ~= nil then
		-- Defined in XP1_Input.scar
		XP1SetupParameters()
	else
		fatal("Unable to find function 'XP1SetupParameters', please ensure XP1_Input.scar has been correctly formed!")
	end
end

--? @shortdesc Generates the output file read by XP1
--? @args Bool win
function XP1_ShowResults(win)
	print("Printing XP1 Results to file...")
	
	local totalVet = math.floor((Vet_ConvertGameToMeta()-startingMetaXP)+0.5)
	if totalVet < 0 then
		totalVet = 0
	elseif totalVet > 0 and totalVet < 1 then
		totalVet = 1
	end
	
	local totalReq = 0
	if win == false then
		g_missionSuccessLevel = XPT_MSL_NONE
	end
	
	totalReq = t_xp1Division_MissionSuccess_ReqRewards[g_missionSuccessLevel]

	local xml = ""
	local function addLine(line)
		xml = (xml .. line .. "\n")
	end
	
	addLine("<results type=\"com.bob.model.state::MissionHistory\">")
		-- rewards
		
		-- metrics
		addLine("<mission type=\"String\">" .. tostring(g_mission) .. "</mission>")
		addLine("\t<win type=\"Boolean\">" .. tostring(win) .. "</win>")
		addLine("\t<hpDelta type=\"Int\">" .. tostring(XP1_GetCompanyStrength()-t_companyPerformance.startingStrength) .. "</hpDelta>")
		addLine("\t<vetDelta type=\"Int\">" .. tostring(totalVet) .. "</vetDelta>")
		addLine("\t<reqDelta type=\"Int\">" .. tostring(totalReq) .. "</reqDelta>")
		addLine("\t<successLevel type=\"Int\">" .. tostring(g_missionSuccessLevel) .. "</successLevel>")
		
		-- objectives
		addLine("\t<objectiveHistory type=\"Array\">")
		local elementIndex = 0
		for i = 1, table.getn(__t_Objectives) do
			-- if parent, not information, and started
			if __t_Objectives[i].Parent == nil and __t_Objectives[i].Type ~= OT_Information and Objective_IsStarted(__t_Objectives[i]) then
				local objectiveType = 0
				if __t_Objectives[i].Type == OT_Secondary then
					objectiveType = 1
				elseif __t_Objectives[i].Type == OT_Bonus then
					objectiveType = 2
				end
				
				addLine("\t\t<element type=\"com.bob.model.state::ObjectiveHistory\" index=\"" .. elementIndex .. "\">")
					addLine("\t\t\t<name type=\"Int\">" .. tostring(__t_Objectives[i].Title) .. "</name>")
					addLine("\t\t\t<complete type=\"Boolean\">" .. tostring(Objective_IsComplete(__t_Objectives[i])) .. "</complete>")
					addLine("\t\t\t<type type=\"Int\">" .. tostring(objectiveType) .. "</type>")
				addLine("\t\t</element>")
				elementIndex = elementIndex + 1
			end
		end
		addLine("\t</objectiveHistory>");
	addLine("</results>")
	
	PersistentMode_SerializeResults("userdata:XP1_Output.scar", xml)
end

--? @shortdesc Wrapper function for creating an encounter. Randomly adds veterancy to enemy units based on XP1 campaign metamap node strength for the mission. If spawnNow is true, spawns specified units immediately.
--? @extdesc Randomly decides if a unit should be granted veterancy and what rank.
--? @args EncounterData data[, Bool spawnNow, Bool spawnStaggered]
--? @result Encounter
function XP1_EncounterCreate(data, spawnNow, spawnStaggered)
	
	local enc_newEncounter = Encounter:Create(data, spawnNow, spawnStaggered)
	
	if data.player == nil or Player_GetRelationship(player1, data.player) == R_ENEMY then 
	
		local RandomVeterancy = function(group, index, squadid)
			if Squad_GetVeterancyRank(squadid) == 0 then
				Squad_IncreaseVeterancyRank(squadid, XP1_GetNodeStrengthVeterancy(), true)
			end
		end
	
		SGroup_ForEach(enc_newEncounter.sgroup, RandomVeterancy)
	end
	
	return enc_newEncounter
end


--? @shortdesc Randomly return a veterancy rank based on mission node strength, between 0-5.
--? @extdesc Useful for when you want to use Squad_IncreaseVeterancyRank on a unit you have spawned and want to use the mission node strength logic to determine its veterancy.
--? @args Void
--? @result Integer
function XP1_GetNodeStrengthVeterancy()
	
	local vetChance = 0	-- chance that a squad gets veterancy
	local veterancyRank = 0
	local max_roll = 40	-- maximum number we can roll when determining which vet rank to give
	local difficulty = Game_GetSPDifficulty() 
	
	-- on higher node strengths, allow the random number to go higher (a higher number allows higher veterancy rank to be picked)
	-- on easy difficulty we don't allow higher veterancy ranks
	if difficulty == GD_EASY then

		if XP1_GetNodeStrength()  == 3 then
			max_roll = 45
		elseif XP1_GetNodeStrength()  == 4 then
			max_roll = 70
		elseif XP1_GetNodeStrength()  == 5 then
			max_roll = 85
		end
		
	else
		
		if XP1_GetNodeStrength()  == 2 then
			max_roll = 45
		elseif XP1_GetNodeStrength()  == 3 then
			max_roll = 80
		elseif XP1_GetNodeStrength()  == 4 then
			max_roll = 93
		elseif XP1_GetNodeStrength()  == 5 then
			max_roll = 100
		end
	end
	
	local random_roll = World_GetRand(1, max_roll)
	
	-- randomly select a veterancy rank
	if random_roll <= 40 then
		veterancyRank = 1
		
	elseif random_roll > 40 and random_roll <= 70 then
		veterancyRank = 2
		
	elseif random_roll > 70 and random_roll <= 85 then
		veterancyRank = 3
		
	elseif random_roll > 85 and random_roll <= 93 then
		veterancyRank = 4
		
	elseif random_roll > 93 and random_roll <= 100 then
		veterancyRank = 5
	end
	

	-- adjust the chance a squad will be granted veterancy based on node strength
	if XP1_GetNodeStrength() == 2 then
		vetChance = 10
	elseif XP1_GetNodeStrength() == 3 then
		vetChance = 15
	elseif XP1_GetNodeStrength() == 4 then	
		vetChance = 25
	elseif XP1_GetNodeStrength() == 5 then	
		vetChance = 35
	end
	
	-- randomly determine if a squad should be granted veterancy, does not vet up a squad that has already been given veterancy
	if (  World_GetRand(1, 100) <= vetChance ) then
	
		return veterancyRank
		
	else
		return 0
	end
end

---------------------///////////////////////////////////////////////////-------------------------------
-- Veterancy Functions

function Vet_Setup()
	minXP = Vet_ConvertMetaToGame(Vet_GetRemainder(startingMetaXP), startingMetaLvl)
	totalXP = minXP
	
	if Rule_Exists(Vet_Update) == false then Rule_Add(Vet_Update) end
end

function Vet_Update()	
	_xp1_removeVetUnit()
	Vet_CollectUnitXP()
	Vet_CheckForLevelUp()
end

-- Gets the remainder (amount of XP) we need to calculate for this level
-- eg: 123: 100 is the level (1) and 23 is the amount of XP for this level
function Vet_GetRemainder(amount)
	return math.fmod(amount, 100)	
end

-- Returns the required Xp for the current level
function Vet_GetRequiredLevelXP(level)
	if level < 3 then
		return t_xp1Division_vet_level_requirement[g_xp1_activeCompany][level+1]
	elseif level == 3 then
		return t_xp1Division_vet_level_requirement[g_xp1_activeCompany][level]
	end
end

-- Converts metaXP to gameXP based on the level requirement
function Vet_ConvertMetaToGame(amount, level)
	if level < 3 then
		return ((amount/100)*t_xp1Division_vet_level_requirement[g_xp1_activeCompany][level+1])
	end
end

-- Returns the total Meta XP (Still needs to have the starting XP subtracted to determine the difference)
function Vet_ConvertGameToMeta()
	-- 100 xp per vet level, plus current level's progress
	return XP1_DivisionVetLevel_Get() * 100 + Vet_GetCurrentLevelVet()		
end

-- Returns current vet amount for the level the player is on
function Vet_GetCurrentLevelVet()
	if XP1_GetCompanyLevel() == 3 then
		return 0
	else
		return Vet_ProcessGameAmount() / (Vet_GetRequiredLevelXP(XP1_DivisionVetLevel_Get())) * 100
	end
end

-- Converts gameXP to a float (for the UI)
function Vet_ConvertGameToFloat()
	if XP1_GetCompanyLevel() == 3 then
		return 1
	else
		return Vet_ProcessGameAmount() / (Vet_GetRequiredLevelXP(XP1_DivisionVetLevel_Get()))
	end
end

function Vet_ProcessGameAmount()	
	local totalVetXP = 0	
	
	--  top the player up using topUpXP once they've leveled to make sure they don't fall below the required XP to hit the level they are at
	if(reqForLastAdj - (totalXP + topUpXP) > 0) then
		topUpXP = topUpXP + (reqForLastAdj - (totalXP + topUpXP)) 
	end
	
	--Give the player XP on a curve (more XP gained when less units are vetted up)
	totalVetXP = (((totalXP + topUpXP)/300)^(1/1.45))*300
		
	return minXP+totalVetXP+giftXP-reqForLast
end

-- Checks if we can level up yet
function Vet_CheckForLevelUp()
	local currLevel = XP1_GetCompanyLevel()
	local xpToLvl = Vet_GetRequiredLevelXP(XP1_DivisionVetLevel_Get())
	
	if currLevel == 3 then
		return
	end
	
	if Vet_ProcessGameAmount() >= xpToLvl then		
	
		-- Determine the XP required for the last level up, both the actual, and the amount of raw XP required
		reqForLast = reqForLast + xpToLvl - minXP
		reqForLastAdj=300*((reqForLast/300)^1.45)

		-- Perform level up Event stuff (HERE)
		XP1_LevelUpCompany()
		
		-- reset min
		minXP = 0
		
		XP1_UpdateCompanyUI()
	end
end

function Vet_GetUnitVeterancy(sid)
	return Squad_GetVeterancyRank(sid) * (Squad_Count(sid)/Squad_GetMax(sid) * Squad_Population(sid, CT_Personnel)) 
end

-- Collects XP for units
function Vet_CollectUnitXP()



	if g_xp1_activeCompany ~= CD_NONE then
		if XP1_GetCompanyLevel() >= 3 then
			return
		end
		
		sg_xp1_allVet = SGroup_CreateIfNotFound("sg_xp1_allVet")
		Player_GetAll(Game_GetLocalPlayer(), sg_xp1_allVet)
		
		-- Iterate through all squads and collect all experience
		local totalVetXP = 0		
		
		local _keepVet = function(gid, idx, sid)
			local driver = Squad_GetVehicleMobileDriverSquad(sid)
			local squadVet = Vet_GetUnitVeterancy(sid)
			
			--Take the higher of the vehicle/squad veterancy to ensure the player isn't penalized for crewing a vehicle
			if (driver ~= nil) then
				local driverVet = Vet_GetUnitVeterancy(driver)
				if squadVet < driverVet then
					squadVet = driverVet
					sid = driver
				end
			end
			
			for k,v in pairs (t_vetGiftedUnits) do
				if (v.sid == Squad_GetGameID(sid)) then
					squadVet = math.max(squadVet - v.xp, 0)			
					break
				end
			end			
			
			totalVetXP = totalVetXP + squadVet
		end
		
		SGroup_ForEach(sg_xp1_allVet, _keepVet)		
		
		--Player is given XP on a curve, increasing amount given for the first few bits of veterancy
		totalXP = totalVetXP
		
		if Rule_Exists(Vet_Update) == false then 
			Rule_Add(Vet_Update) 
			
			Rule_RemoveIfExist(Vet_CollectUnitXP)
			Rule_RemoveIfExist(Vet_CheckForLevelUp)
			Rule_RemoveIfExist(XP1_GetReduceXP)
			Rule_RemoveIfExist(_xp1_removeVetUnit)
			
			XP1_SetupTuningVariables()

			if topUpXP == nil then
				topUpXP = 0
			end
			if reqForLast == nil then
				Vet_RecalculateReqXPForLast()
			end
		end
	
		XP1_UpdateCompanyUI()
	end
end

function Vet_RecalculateReqXPForLast()
	reqForLast = 0
	local totalVetXP =  (((totalXP)/300)^(1/1.45))*300 + Vet_ConvertMetaToGame(Vet_GetRemainder(startingMetaXP), startingMetaLvl)
	local reqXPForLvl = 0
	for i=0, startingMetaLvl do 
		reqXPForLvl = reqXPForLvl + Vet_GetRequiredLevelXP(i)
		if(startingMetaLvl ~= i) then
			totalVetXP = totalVetXP + Vet_GetRequiredLevelXP(i)
		end
	end	
	
	if totalVetXP > reqXPForLvl then
		reqForLast = reqForLast + Vet_GetRequiredLevelXP(startingMetaLvl) - Vet_ConvertMetaToGame(Vet_GetRemainder(startingMetaXP), startingMetaLvl)
		reqXPForLvl = reqXPForLvl + Vet_GetRequiredLevelXP(startingMetaLvl+1)
		
		if startingMetaLvl + 1 < 4 and totalVetXP > reqXPForLvl  then
			reqForLast = reqForLast + Vet_GetRequiredLevelXP(startingMetaLvl+1)			
			reqXPForLvl = reqXPForLvl + Vet_GetRequiredLevelXP(startingMetaLvl+2)
			
			if startingMetaLvl + 2 < 4 and totalVetXP > reqXPForLvl then
				reqForLast = reqForLast + Vet_GetRequiredLevelXP(startingMetaLvl+2)				
			end
		end		
	end
			
	reqForLastAdj=300*((reqForLast/300)^1.45)
end

-- When units spawn in with vet (due to company vet levels), we store these units and their starting xp
-- We then iterate through this table and create a reduction value, which we subtract from the total xp
-- This is to prevent these units from contributing to company XP.
-- These units can still contribute with any earned xp beyond this
function XP1_GetReduceXP()
	local total = 0
	
	if table.getn(t_vetGiftedUnits) > 0 then
		for k,v in pairs(t_vetGiftedUnits) do
			total = total + v.xp
		end
	end
	
	return total
end

-- Vets up units as they spawn in
function XP1_VeterancyCheck(data)
		
	if g_xp1DivisionVetLevel > 0 then
		local sg_xp1Temp = SGroup_CreateIfNotFound("sg_xp1Temp")
		
		Player_GetAll(player1, sg_xp1Temp)
		
		SGroup_RemoveGroup(sg_xp1Temp, sg_xp1VetCheck)
		
		if SGroup_Count(sg_xp1Temp) > 0 then

			local vetChance = data.vetChance

			local _applyVeterancy = function(gid, idx, sid)
				local chance = World_GetRand(0, 100)
				print(chance)
				if chance <= vetChance then
					if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
						-- The squad is a vehicle, so we should store the Crew
						local squad = Squad_GetVehicleMobileDriverSquad(sid)
						if scartype(squad) == ST_SQUAD and SGroup_ContainsSquad(sg_xp1VetCheck, Squad_GetGameID(squad)) == false then
							Squad_IncreaseVeterancyRank( squad, g_xp1DivisionVetLevel, true ) 
							_xp1_addVetUnit(squad)
						end
					else
						Squad_IncreaseVeterancyRank( sid, g_xp1DivisionVetLevel, true ) 
						_xp1_addVetUnit(sid)
					end
				end
			end

			SGroup_ForEach(sg_xp1Temp, _applyVeterancy)
		end
	end
	Player_GetAll(player1, sg_xp1VetCheck)
	g_eventIDVetCheck = Event_Timer(XP1_VeterancyCheck, data, 0.1)
end

-- Add a unit to the reduced vet units for tracking
function _xp1_addVetUnit(squad)
	local t = {}
	t.sid = Squad_GetGameID(squad)
	if Entity_IsVehicle(Squad_EntityAt(squad, 0)) then
		local driver = Squad_GetVehicleMobileDriverSquad(squad)
		if driver ~= nil then
			t.sid = Squad_GetGameID(driver)
		else
			return
		end
	end	

	t.xp = Vet_GetUnitVeterancy(squad)
	
	table.insert(t_vetGiftedUnits, t)
end

-- When a unit dies and it was part of our reduced vet units (see below), we remove it from the table
function _xp1_removeVetUnit()

	for i=#t_vetGiftedUnits, 1, -1 do 
		if Squad_IsValid(t_vetGiftedUnits[i].sid) == false or Squad_GetVeterancyRank(Squad_FromWorldID(t_vetGiftedUnits[i].sid)) <= 0 then
			table.remove(t_vetGiftedUnits, i)
		end
	end
end

-- Levels the company up; note, this is purely just for visual elements like the in-game UI
-- Division levels are controlled by experience
function XP1_LevelUpCompany()
	-- Grant the company an XP gift
	XP1_AddCompanyStrength(t_xp1Division_level_up_strength_gift[g_xp1_activeCompany], false)
	-- Update the variable
	g_xp1DivisionVetLevel = g_xp1DivisionVetLevel + 1
	-- Apply resource modifiers
	_xp1_applyResourceIncomeModifiers()
	-- Play the events (if no other events are running
	Event_NarrativeEventsNotRunning(_xp1_levelUpEvent, nil, 1)
	XP1_UpdateCompanyUI()
end

-- The level up event code
function _xp1_levelUpEvent()
	if Timer_Exists(tmr_levelUp) == false then
		_sortVetLevel_alert()
	else
		if Rule_Exists(_sortVetLevel_alert) == false then
			Rule_AddOneShot(_sortVetLevel_alert, Timer_GetRemaining(tmr_levelUp))
		end
	end
end

-- Display alert that you leveled up
function _sortVetLevel_alert()
	if Timer_Exists(tmr_levelUp) == false then
		Timer_Start(tmr_levelUp, 60)
	end
	Util_MissionTitle(11078320)
	EventCue_Create(CUE.UPGRADE, 11079488, LOC(""), nil)	-- LOCDB [11079488] 'Resource income increased!'
	EventCue_Create(CUE.UPGRADE, 11079489, LOC(""), nil)	-- LOCDB [11079489] 'Increased chance of veteran units!'
	EventCue_Create(CUE.UPGRADE, 11079490, LOC(""), nil)	-- LOCDB [11079490] 'Bonus XP Granted!'
end

--~ --? @group scardoc;XP1
--~ --? @shortdesc Hides/Unhides the temporary in-game Persistant Mode UI using debug render text.
--~ --? @result Void
function XP1_ToggleUI()
	XP1_UpdateCompanyUI()
end

--Internal function used to update the text-based Temp UI
function XP1_UpdateCompanyUI()
	if XP1_CompanyIsActive() then
		
		local icon = XP1_GetCompanyIcon()
		local companyLocName = XP1_GetCompanyLocName()
		local xp = Vet_ConvertGameToFloat()
		local level = XP1_DivisionVetLevel_Get()
		UI_SetCompany(companyLocName, icon, g_xp1_companyUIDetails, XP1_GetCompanyStrength()/100, level, xp)
	end
end

-- Used to give players an additional amount of experience
-- This will be 'free' as in the player will never lose it, even if they're defeated and all forces are wiped out
function XP1_GiftVeterancy(amount, announcement)
	local percentage = amount
	
	if XP1_DivisionVetLevel_Get() == 3 then
		return
	elseif XP1_DivisionVetLevel_Get() then
		percentage = Vet_GetRequiredLevelXP(XP1_DivisionVetLevel_Get())*amount
	end
	
	print(percentage)
	
	giftXP = giftXP + percentage
	
	amount = amount*100
	
	if announcement then
		Util_MissionTitle(Loc_FormatText(11076449, Loc_ConvertNumber(amount)), 2, 5, 2)	-- LOCDB [11076449] 'Company has earned %1VET_AMOUNT%%% bonus Company Veterancy'
	end
end

function XP1_GetCompanyLevel()
	return g_xp1DivisionVetLevel
end


-- Gets the Division XP
function XP1_DivisionVetXP_Get()
	return g_xp1DivisionVetXP
end

-- Sets the Division Level
function XP1_DivisionVetLevel_Set(newLevel)
	g_xp1DivisionVetLevel = newLevel
end

-- Gets the Division Level
function XP1_DivisionVetLevel_Get()
	return g_xp1DivisionVetLevel
end



function XP1_GetLevelRequirement(vetLevel)
	return t_xp1Division_vet_level_requirement[g_xp1_activeCompany][vetLevel+1]
end

---------------------///////////////////////////////////////////////////-------------------------------
-- Misc Functions


--? @shortdesc Returns the current metamap subphase (SUBPHASE_EARLY, SUBPHASE_MID, SUBPHASE_LATE)
--? @result Int subphase
function XP1_GetMetaSubPhase()
	return g_currMetaSubphase
end

--? @shortdesc Plays a line of speech dependant on your current active company. 
--? @args Table commanderLines
--? @result String companyID
function XP1_PlayCompanySpeechLine(commanderLines)
	for k,v in pairs(commanderLines) do
		if v.cmdr_id == g_xp1_activeCompany then
			Util_StartIntel(v.event_id)
			return
		end
	end
	Util_StartIntel(commanderLines[1].event_id)
end


--? @shortdesc Util function for constructing the data-table needed by XP1_PlayCompanySpeechLine.  It requires a STRICT naming convention of intelEvent functions: <intelEventName>_<companyNAME>. Eg. EVENTS.MissionIntro_AIRBORNE.
--? @args String intelEventName
--? @result Table companySpeechLines
function XP1_ConstructCompanySpeechTable(intelEventName)
	local _speechTable = {
		{cmdr_id = CD_NONE,	event_id = EVENTS[intelEventName .. "_DEFAULT"]}
	}
	
	for k,v in pairs(t_xp1Division_Names) do
		local _newItem = {}
		_newItem.cmdr_id = _G["CD_" .. v]
		_newItem.event_id = EVENTS[intelEventName .. "_" .. v]
		
		if _newItem.cmdr_id == nil then fatal(string.format("No global constant found for Company '%s'", v)) end
		if _newItem.event_id == nil then fatal(string.format("No intel event ID defined for %s under %s Company", intelEventName, v)) end
		
		table.insert(_speechTable, _newItem)
	end
	
	return _speechTable
end


--? @shortdesc Gets the current Company (CD_AIRBORNE/CD_MECHANIZED/CD_SUPPORT). 
--? @result String companyID
function XP1_GetDivision()
	return g_xp1_activeCompany
end

--? @shortdesc Gets the current Company's name 
--? @result String companyName
function XP1_GetDivisionName()
	if XP1_CompanyIsActive() then
		return t_companiesTable[g_xp1_activeCompany].companyName
	end
	return "NIL"
end

--? @shortdesc Gets the current Company's Localized name 
--? @result Int companyLocName
function XP1_GetCompanyLocName()
	if XP1_CompanyIsActive() then
		return t_companiesTable[g_xp1_activeCompany].companyLocName
	end
	return 300
end

--? @shortdesc Gets the current Company's Icon
--? @result string companyIcon
function XP1_GetCompanyIcon()
	if XP1_CompanyIsActive() then
		return t_companiesTable[g_xp1_activeCompany].companyIcon
	end
	return "Icons_factions_faction_aef_64"
end

--? @shortdesc Returns the actor ID for the company that is currently active. 
--? @result ActorID
function XP1_CommanderPortrait()
	if XP1_GetDivision() == CD_AIRBORNE then
		return ACTOR.Vastano
	elseif XP1_GetDivision() == CD_MECHANIZED then
		return ACTOR.Edwards
	elseif XP1_GetDivision() == CD_SUPPORT then
		return ACTOR.Derby
	elseif XP1_GetDivision() == CD_RANGER then
		return ACTOR.Durante
	else
		--TODO:DLC - Add commander portraits
		return ACTOR.American_Major_01
	end
end

-- Checks if the division matches a set division
function XP1_IsMatchingDivision(division)
	if division == XP1_GetDivision() or XP1_GetDivision() == nil then
		return true
	end
	return false
end

-- Handles spawning starting units for each division
function _XP1_SpawnStartingUnits()
	local spawns = Marker_GetTable("mkr_company_startUnit_spawn_%02d")
	sg_starting_units = SGroup_CreateIfNotFound("sg_starting_units")
	local vetTable = g_xp1DivisionVetLevel+1
	local startSquads = t_xp1Division_starting_units[g_xp1_activeCompany][vetTable]
	
	if #spawns == 0 then
		print("XP1: Company starting squad positions NOT FOUND! Skipping...")
		return
	elseif #spawns < 5 then
		fatal("XP1: NOT ENOUGH STARTING SPAWNS! Ensure there are 5 company starting squad markers!")
		return
	end
	
	for i = 1, table.getn(startSquads) do
		if startSquads[i] == BP_GetSquadBlueprint("assault_engineer_squad_mp") then
			print("Found assault engineer")
			local _is5Man = false
			if table.getn(t_activeCompanyAbilityUpgrades) > 0 then
				for k = table.getn(t_activeCompanyAbilityUpgrades), 1, -1 do 
					if t_activeCompanyAbilityUpgrades[k] == "pm_assault_engineer_extra_entity" then
						_is5Man = true
						print("Found 5 man")
						break
					end
				end
			end
			if _is5Man == true then
				print("Swapping with 5-man")
				Util_CreateSquads(player1, sg_starting_units, BP_GetSquadBlueprint("assault_engineer_squad_5_man_mp"), spawns[i])
			else
				Util_CreateSquads(player1, sg_starting_units, startSquads[i], spawns[i])
			end
		else
			print("spawn")
			Util_CreateSquads(player1, sg_starting_units, startSquads[i], spawns[i])
		end
	end
end

function _XP1_CollectBase()
	Player_GetAll(player1)
	
	local _sortBase = function(gid, idx, eid)
		if Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("rifle_command_mp") then
			EGroup_Add(eg_XP1_rifle_command, eid)
			EGroup_Add(eg_XP1_player_base, eid)
		elseif Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("armor_command_mp") then
			EGroup_Add(eg_XP1_armor_command, eid)
			EGroup_Add(eg_XP1_player_base, eid)
		elseif Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("company_weapons_pool_mp") then
			EGroup_Add(eg_XP1_weapons_pool, eid)
			EGroup_Add(eg_XP1_player_base, eid)
		elseif Entity_GetBlueprint(eid) == BP_GetEntityBlueprint("armored_rifle_command_mp") then
			EGroup_Add(eg_XP1_armored_rifle_command, eid)
			EGroup_Add(eg_XP1_player_base, eid)
		end
	end
	
	EGroup_ForEach(eg_allentities, _sortBase)
end

--? @group scardoc;XP1

--? @shortdesc Takes in a table and chooses the right variable for the current chosen company setting. CD_AIRBORNE, CD_MECHANIZED, CD_SUPPORT, CD_RANGER. 
--? @args Table companyVariables
--? @result Variable
function XP1_CompanyDif(vars)
	if scartype(vars) == ST_TABLE and table.getn(vars) == COMPANY_COUNT then
		return vars[XP1_GetDivision()]
	else
		fatal("XP1: XP1_CompanyDif parameter is either not a table, or has more or less than COMPANY_COUNT entries")
	end
end

--=====================================================================================================--
--==============================	   SPECIALIZATION AE FUNCTIONS	  =================================--
--=====================================================================================================--


-- Adds units to withdraw to a tracking table to refund their popcap
function AE_TransferOrders(caster, target)
	local t = {}
	t.sid = target
	t.sidID = Squad_GetGameID(target)
	t.sbp = Squad_GetBlueprint(target)
	t.counted = false
	t.popCap = Squad_Population(target, CT_Personnel)
	
	table.insert(t_xp1PopCapRefund_units, t)
end

-- Metagame speech events
t_metagameEVENTS = {}
-- 75% Health
t_metagameEVENTS._75_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._75_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._75_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._75_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._75_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._75_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._75_HEALTH_DEFAULT = function()
	local t = {
		{11079736, 11079737}, -- Early
		{11079744, 11079745}, -- Mid
		{11079752, 11079753}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._75_HEALTH_AIRBORNE = function()
	local t = {
		{11079736, 11079737}, -- Early
		{11079744, 11079745}, -- Mid
		{11079752, 11079753}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._75_HEALTH_MECHANIZED = function()
	local t = {
		{11081560, 11081561}, -- Early
		{11081568, 11081569}, -- Mid
		{11081576, 11081577}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._75_HEALTH_SUPPORT = function()
	local t = {
		{11079856, 11079857}, -- Early
		{11079864, 11079865}, -- Mid
		{11079872, 11079873}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._75_HEALTH_RANGER = function()
	local t = {
		{11080100, 11080101}, -- Early
		{11080108, 11080109}, -- Mid
		{11080116, 11080117}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

-- 50% Health
t_metagameEVENTS._50_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._50_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._50_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._50_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._50_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._50_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._50_HEALTH_DEFAULT = function()
	local t = {
		{11079734, 11079735}, -- Early
		{11079742, 11079743}, -- Mid
		{11079750, 11079751}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._50_HEALTH_AIRBORNE = function()
	local t = {
		{11079734, 11079735}, -- Early
		{11079742, 11079743}, -- Mid
		{11079750, 11079751}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._50_HEALTH_MECHANIZED = function()
	local t = {
		{11081558, 11081559}, -- Early
		{11081566, 11081567}, -- Mid
		{11081574, 11081575}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._50_HEALTH_SUPPORT = function()
	local t = {
		{11079854, 11079855}, -- Early
		{11079862, 11079863}, -- Mid
		{11079870, 11079871}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._50_HEALTH_RANGER = function()
	local t = {
		{11080098, 11080099}, -- Early
		{11080106, 11080107}, -- Mid
		{11080114, 11080115}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

-- 25% Health
t_metagameEVENTS._25_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._25_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._25_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._25_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._25_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._25_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._25_HEALTH_DEFAULT = function()
	local t = {
		{11079732, 11079733}, -- Early
		{11079740, 11079741}, -- Mid
		{11079748, 11079749}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._25_HEALTH_AIRBORNE = function()
	local t = {
		{11079732, 11079733}, -- Early
		{11079740, 11079741}, -- Mid
		{11079748, 11079749}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._25_HEALTH_MECHANIZED = function()
	local t = {
		{11081556, 11081557}, -- Early
		{11081564, 11081565}, -- Mid
		{11081572, 11081573}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._25_HEALTH_SUPPORT = function()
	local t = {
		{11079852, 11079853}, -- Early
		{11079860, 11079861}, -- Mid
		{11079868, 11079869}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._25_HEALTH_RANGER = function()
	local t = {
		{11080096, 11080097}, -- Early
		{11080104, 11080105}, -- Mid
		{11080112, 11080113}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

-- 5% Health
t_metagameEVENTS._5_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._5_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._5_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._5_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._5_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._5_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._5_HEALTH_DEFAULT = function()
	local t = {
		{11079731}, -- Early
		{11079739}, -- Mid
		{11079747}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._5_HEALTH_AIRBORNE = function()
	local t = {
		{11079731}, -- Early
		{11079739}, -- Mid
		{11079747}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._5_HEALTH_MECHANIZED = function()
	local t = {
		{11081555}, -- Early
		{11081563}, -- Mid
		{11081571}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._5_HEALTH_SUPPORT = function()
	local t = {
		{11079851}, -- Early
		{11079859}, -- Mid
		{11079867}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._5_HEALTH_RANGER = function()
	local t = {
		{11080095}, -- Early
		{11080103}, -- Mid
		{11080111}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

-- 0% Health
t_metagameEVENTS._0_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._0_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._0_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._0_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._0_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._0_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._0_HEALTH_DEFAULT = function()
	local t = {
		{11079730}, -- Early
		{11079738}, -- Mid
		{11079746}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._0_HEALTH_AIRBORNE = function()
	local t = {
		{11079730}, -- Early
		{11079738}, -- Mid
		{11079746}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._0_HEALTH_MECHANIZED = function()
	local t = {
		{11081554}, -- Early
		{11081562}, -- Mid
		{11081570}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._0_HEALTH_SUPPORT = function()
	local t = {
		{11079850}, -- Early
		{11079858}, -- Mid
		{11079866}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Derby, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._0_HEALTH_RANGER = function()
	local t = {
		{11080094}, -- Early
		{11080102}, -- Mid
		{11080110}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

-- Recover from 0% Health
t_metagameEVENTS._RECOVER_HEALTH = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = t_metagameEVENTS._RECOVER_HEALTH_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = t_metagameEVENTS._RECOVER_HEALTH_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = t_metagameEVENTS._RECOVER_HEALTH_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = t_metagameEVENTS._RECOVER_HEALTH_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = t_metagameEVENTS._RECOVER_HEALTH_RANGER},
	}
	XP1_PlayCompanySpeechLine(t)
end

t_metagameEVENTS._RECOVER_HEALTH_DEFAULT = function()
	local t = {
		{11080900}, -- Early
		{11080901}, -- Mid
		{11080902}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._RECOVER_HEALTH_AIRBORNE = function()
	local t = {
		{11080900}, -- Early
		{11080901}, -- Mid
		{11080902}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._RECOVER_HEALTH_MECHANIZED = function()
	local t = {
		{11081488}, -- Early
		{11081489}, -- Mid
		{11081490}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._RECOVER_HEALTH_SUPPORT = function()
	local t = {
		{11080590}, -- Early
		{11080591}, -- Mid
		{11080592}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end

t_metagameEVENTS._RECOVER_HEALTH_RANGER = function()
	local t = {
		{11080675}, -- Early
		{11080676}, -- Mid
		{11080677}, -- Late
	}
	local index = (XP1_GetMetaSubPhase()+1)
	CTRL.Actor_PlaySpeech(ACTOR.Durante, Table_GetRandomItem(t[index]))	
	CTRL.WAIT()
end
