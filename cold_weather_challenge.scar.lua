-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- CHALLENGE Cold Weather Challenge (v2)
-- Designer: Philippe Boulle 
-------------------------------------------------------------------------
-------------------------------------------------------------------------
import("ScarUtil.scar")
import("Beginner.scar")
import("TheatreOfWar.scar")
import("Systems/AiManager/ai.scar")
import("Global_Values/CampaignGlobalConstants.scar")

g_isWinterMap = true

-------------------------------------------------------------------------
-- [[ SETUP ]]
-------------------------------------------------------------------------

function OnGameSetup()
	-- Required Players
	player1 = Setup_Player(1, 11038758, "soviet", 1)		-- player1 is always the human player
	player2 = Setup_Player(2, 11038759, "german", 2)		-- player2 is always the AI opponent
	-- Optional Players
	player3 = Setup_Player(3, 0, "soviet", 1)		-- player3 is always the AI ally
	player4 = Setup_Player(4, 0, "soviet", TEAM_NEUTRAL)		-- player4 is neutral
end

function OnGameRestore()
	
	-- function takes care of restoring all global mission parameters after a save/load
	player1 = World_GetPlayerAt(1)
	player2 = World_GetPlayerAt(2)
	player3 = World_GetPlayerAt(3)
	player4 = World_GetPlayerAt(4)
	
	Game_DefaultGameRestore()
end


-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()
	
	--[[ PRESET DEBUG CONDITIONS ]]
	Mission_Debug()
	
	--[[ SET DIFFICULTY ]]
	Mission_Difficulty()
	
	--[[ SET RESTRICTIONS ]]
	Mission_Restrictions()
	
	--[[ MISSION PRESETS ]]
	Mission_MissionPreset()
	
	--[[ REGISTER OBJECTIVES ]]
	Initialize_Objectives()
	
	--[[ GAME START CHECK ]]
	Rule_Add(Mission_MissionStart)
end

Scar_AddInit(OnInit)

function NIS_Init()
	NIS01  = "ToW/Challenges/Cold_Weather_Challenge/nis/intro"
	nis_load(NIS01)
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
end

Scar_AddInit(NIS_Init)

function Mission_Debug()
	g_debug = Misc_IsCommandLineOptionSet("debug")
end

function Mission_Restrictions()

	t_abilityBlacklist = {
		ABILITY.SOVIET.CONSCRIPT_OORAH,
		ABILITY.SOVIET.ANTI_TANK_GRENADE,
	}
	Player_SetAbilityAvailability (player1, t_abilityBlacklist, ITEM_REMOVED)
	
	t_ebpBlacklist = {
		EBP.SOVIET.BARRACKS,
		EBP.SOVIET.MOTORPOOL,
		EBP.SOVIET.OBSERVATION_POST_FUEL,
		EBP.SOVIET.OBSERVATION_POST_MUNITION,
		EBP.SOVIET.TANK_DEPOT,
		EBP.SOVIET.M1937_152MM_ML_20_ARTILLERY,
		EBP.SOVIET.WEAPON_SUPPORT_CENTER,
	}
	Player_SetEntityProductionAvailability(player1, t_ebpBlacklist, ITEM_REMOVED)

	Modify_PlayerResourceRate( player1, RT_Manpower, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Munition, 0, MUT_Multiplication )
	Modify_PlayerResourceRate( player1, RT_Fuel, 	 0, MUT_Multiplication )
	
	Player_SetResource(player1, RT_Manpower, 200)
	Player_SetResource(player1, RT_Munition, t_difficulty.startingMunition)
	
	Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("upgrade/campaign/allow_building_campfires"))
	Player_SetUpgradeAvailability(player1, 	UPG.GERMAN.SDKFZ_251_HALFTRACK_FLAMMPANZERWAGEN_UPGRADE, ITEM_REMOVED)
end

function Mission_Difficulty()
	-- get the difficulty
	g_difficulty = Game_GetSPDifficulty()  -- set a global difficulty variable 
	_ToWDebugDisplay("********* DIFFICULTY: "..g_difficulty)
	
	t_difficulty = {
		playerFreezeRate =				Util_DifVar( {0.75,    1, 1.25,  1.5, } ),
		playerWarmRate =				Util_DifVar( {   3,    3,    2,  1.5, } ),
		enemyFreezeRate =				Util_DifVar( {   2,  1.5, 1.25,  1.0, } ),
		enemyWarmRate =					Util_DifVar( { 1.5,    2,  2.5,    3, } ),
		startingMunition =				Util_DifVar( { 300,  120,    0,    0, } ),
		damageLight =					Util_DifVar( {0.60, 0.85, 1.00, 1.00, } ),
		damageMid =						Util_DifVar( {0.45, 0.60, 0.85, 1.00, } ),
		damageHeavy =					Util_DifVar( {0.15, 0.25, 0.55, 0.85, } ),
	}
	
	--adjust timer for panzergrenadier grenades
	Modify_ProjectileDelayTime (player2, BP_GetEntityBlueprint("bundled_stielgranate_campaign"), CAMPAIGN_PGREN_BUNDLED_TIMER)
	
end

-------------------------------------------------------------------------
-- MISSION Preset 
-------------------------------------------------------------------------

function Mission_MissionPreset()
	-- variables
	g_bronze = 6
	g_silver = 9
	g_gold = 12
	g_count = 0
	-- tables
	t_encounters = {}
	
	-- Camera
	Camera_SetDefault(nil, nil, 225)
	Camera_ResetToDefault()
	
	-- cold Weather
	Player_SetHeatLossRate(player1,t_difficulty.playerFreezeRate)
	Player_SetHeatGainRate(player1,t_difficulty.playerWarmRate)
	
	Player_SetHeatLossRate(player2,t_difficulty.enemyFreezeRate)
	Player_SetHeatGainRate(player2,t_difficulty.enemyWarmRate)

	-- player units
	sg_playerUnits = SGroup_CreateIfNotFound("sg_playerUnits")
	sg_guardPTRS = SGroup_CreateIfNotFound("sg_guardPTRS")
	sg_guardDP28 = SGroup_CreateIfNotFound("sg_guardDP28")
	sg_engineers = SGroup_CreateIfNotFound("sg_engineers")
	sg_conscripts = SGroup_CreateIfNotFound("sg_conscripts")
	
	Util_CreateSquads (player1, {sg_playerUnits, sg_guardPTRS}, BP_GetSquadBlueprint("tow_cold_weather_guards_troops"), mkr_playerSpawn, mkr_playerStart, 1, nil, nil, nil, UPG.SOVIET.PTRS_41_AT_RIFLE_PACKAGE_GUARD_TROOP)
	Util_CreateSquads (player1, {sg_playerUnits, sg_guardDP28}, BP_GetSquadBlueprint("tow_cold_weather_guards_troops"), mkr_playerSpawn2, mkr_playerStart, 1, nil, nil, nil, UPG.SOVIET.GUARD_DP_28_LMG_PACKAGE)
	SGroup_EnableAttention(sg_playerUnits, false)
	Misc_SetSquadControlGroup(SGroup_GetSpawnedSquadAt(sg_guardPTRS, 1), 1)
	Misc_SetSquadControlGroup(SGroup_GetSpawnedSquadAt(sg_guardDP28, 1), 2)
	
	World_EnableSharedLineOfSight(player1, player3, false)
	
	-- enemy units
	Event_Timer (SetupEncounters, nil, 0.25)
	
	-- Beginner Hints
	BeginnerHint_AddOpportunity (eg_pickups, HINT_PICKUP, true, 11046241)
	
	SetupAchievements()
end

-------------------------------------------------------------------------
-- MISSION START & OBJECTIVES
-------------------------------------------------------------------------

function Mission_MissionStart()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		if g_debug == true then
			DEBUG_Beat_Selection_01()
		else
			StartIntro()
		end
	end
end

function DEBUG_Beat_Selection_01()
	UI_MessageBoxSetText(LOC("SELECT START"), LOC("Select the Mission beat to play"))
	UI_MessageBoxSetButton(DB_Button1, LOC("WITH INTRO"), LOC("Part 1"), "", true)
	UI_MessageBoxSetButton(DB_Button2, LOC("NO INTRO"), LOC("Part 2"), "", true)
	UI_MessageBoxSetButton(DB_Button3, LOC("NO MISSION"), LOC("Part 3"), "", true)
	UI_MessageBoxShow(DC_Default, DEV_SelectPhase_Menu_01)
end

function DEV_SelectPhase_Menu_01(button)
	if button == DB_Button1 then
			StartIntro()
	elseif button == DB_Button2 then
			Mission_DelayObjTitle()
	elseif button == DB_Button3 then
		_ToWDebugDisplay("No mission!", "gold")
	end
end

function StartIntro()
	Camera_SetInputEnabled(false)
	Game_Letterbox(true, 2)
	UI_SetForceShowSubtitles(true)
	FOW_RevealMarker(mkr_enc01_space, -1)
	FOW_RevealMarker (mkr_enc05_leash , -1)
	Util_StartIntel(EVENTS.Intro)
end

function Return ()
	FOW_UnRevealMarker(mkr_enc01_space)
	FOW_UnRevealMarker(mkr_enc05_leash)
	Camera_SetInputEnabled(true)
	Game_Letterbox(false, 2)
	Mission_DelayObjTitle()
end

function Mission_DelayObjTitle()
	SGroup_EnableAttention(sg_playerUnits, true)
	Objective_Start(OBJ_Main)
	Objective_Start(OBJ_Reinforce, false)
	
	local data = {
		group = {sg_guardPTRS,sg_guardDP28,},
		text = {11046244 , -- LOCDB [11046244] 'Squad One is armed with PTRS rifles effective against light vehicles.'
		11046245 ,}, -- LOCDB [11046245] 'Squad Two can use its Button Vehicle ability to paralize vehicles.'
		icon = {"Icons_upgrades_icon_upgrade_soviet_ptrs_41", "Icons_abilities_ability_soviet_button_vehicle",},
		index = 1,
	}
	local delay = 0
	Event_Timer(SquadHint, data, delay)
end

function Initialize_Objectives()

	OBJ_Main = {
		SetupUI = function() 
		end,
		OnStart = function()
			Objective_Start(OBJ_Silver, false)
			Rule_AddDelayedInterval(FailCheck, 10, 2)
			Event_PlayerCanSeeElement(FireHint, {egroup=eg_heat06, pos=EGroup_GetPosition(eg_heat06)}, player1, eg_heat06, ANY)
			Event_PlayerCanSeeElement(ReactWhenSeen, {sgroup=sg_enc01_all}, player1, sg_enc01_all, ANY, 10) 
			Event_PlayerCanSeeElement(ReactWhenSeen, {sgroup = sg_enc05_roadblock}, player1, sg_enc05_roadblock, ANY, 5)
			UI_SetCPMeterVisibility(false)	
		end,
		
		OnComplete = function()
			Mission_MissionComplete()
		end,
		
		OnFail = function()
			Mission_MissionComplete()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.ReturnToPlayer,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11038774, -- LOCDB [11038774] 'Eliminate German vehicles caught in the cold.'
		Description = 0,			-- Objective Description
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Silver = {
		Parent = OBJ_Main,
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Silver, g_count, g_silver)
		end,
		
		OnComplete = function()
			_ToWDebugDisplay("OBJ_Silver complete", "white")
			Rule_AddInterval(StartGold,1)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11047610,Loc_ConvertNumber(g_silver)),				-- LOCDB [11038775] '%1LEVEL%: Destroy %2NUMBER% German vehicles'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Gold = {
		SetupUI = function() 
		end,
		
		OnStart = function()
			Objective_SetCounter(OBJ_Gold, g_count - g_silver, g_gold - g_silver)
		end,
		
		OnComplete = function()		
			_ToWDebugDisplay("OBJ_Gold complete", "white")
			Achieve ("tow_cold_weather_gold_weather")
			Objective_Complete(OBJ_Main)
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = EVENTS.Bonus,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = Loc_FormatText(11038775,11047614,Loc_ConvertNumber(g_gold - g_silver)),				-- LOCDB [11038775] '%1LEVEL%: Destroy %2NUMBER% German vehicles'
		Description = 0,			-- Objective Description
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	OBJ_Reinforce = {

		SetupUI = function() 
			Objective_AddUIElements(OBJ_Reinforce, mkr_enc05_space, true, 11038778, true, 3, nil, HPAT_Objective)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()	
			Rule_AddOneShot( Reinforcements, 5 )
		end,
		
		OnFail = function()
		end,
		
		IsComplete = function()
			return false
		end,
		
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Complete = EVENTS.ReinforcementsComplete,			-- Event will play when obj completes but before UI is cleared
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Title = 11038784, -- LOCDB [11038784] 'Clear the crossroad to gain reinforcements.'
		Description = 0,			-- Objective Description
		TitleEnd = 11038785, -- LOCDB [11038785] 'Reinforcements inbound.'
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
	}
	
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Reinforce)
	Objective_Register(OBJ_Silver)
	Objective_Register(OBJ_Gold)

end

function StartGold()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		Objective_Start(OBJ_Gold)
	end
end

----------------- UI AND HINTS -------------------------

function SquadHint(data)
	if (data.hintID) then
		HintPoint_Remove(data.hintID)
	end
	if data.index <= #data.group then
		local group = data.group[data.index]
		local text = data.text[data.index]
		local icon = data.icon[data.index]
		data.hintID = HintPoint_Add (group, true, text, 3, HPAT_Hint, icon)
		data.index = data.index + 1
		Event_Timer(SquadHint, data, 10)
	end
end


function FireHint(data)
	_ToWDebugDisplay("FireHint triggered for " .. EGroup_GetName(data.egroup))
	OBJ_Main.heatHint = HintPoint_Add (data.pos, true, 11038779, nil, nil, "Icons_commands_icon_command_build_fire") -- LOCDB [11038779] 'Use campfires to warm your troops.'
	Event_Proximity(RemoveUI, {obj = OBJ_Main, id = OBJ_Main.heatHint}, sg_playerUnits, data.egroup, 10, ANY)
end

function RemoveUI (data)
	HintPoint_Remove(data.id)
end

----------------- ENCOUNTERS AND MISSION MEAT -----------------

function SetupEncounters()
	SetupArea01()
	SetupArea02()
	SetupArea03()
	SetupArea04()
	SetupArea05()
	SetupArea06()
	SetupArea07()
	SetupArea08()
end


--- encounter area 1 : ostruppen in the cold ---
function SetupArea01()
	t_encounters[1] = {}
	sg_enc01_all = SGroup_CreateIfNotFound("sg_enc01_all")
	sg_enc01_infantry = SGroup_CreateIfNotFound("sg_enc01_infantry")
	sg_enc01_halftrack = SGroup_CreateIfNotFound("sg_enc01_halftrack")
	
	local encData = {
		player = player2,
		sgroups = {sg_enc01_all},
		units = {
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_enc01_ostruppen01,
				load = 4,
				sgroups = {sg_enc01_infantry},
			},
			{
				sbp = SBP.GERMAN.OSTRUPPEN_SQUAD,
				spawn = mkr_enc01_ostruppen02,
				load = 3,
				sgroups = {sg_enc01_infantry},
			},
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_enc01_halftrack,
				sgroups = {sg_enc01_halftrack},
				onDeath = IncrementCounter,
			},
		},
		onDeath = nil,
	}
	t_encounters[1].all = Encounter:Create(encData)
	t_encounters[1].all.reactData = {
		target = mkr_enc01_space,
		range = mkr_enc01_space,
	}
	
	Cmd_CriticalHit (player2, sg_enc01_halftrack, CRIT.VEHICLE_DESTROY_ENGINE, 1)
	SGroup_SetAvgHealth (sg_enc01_halftrack, t_difficulty.damageLight)
	
end		


--- area 2; panzer 4's broken down in a field --
function SetupArea02()

	sg_enc02_all = SGroup_CreateIfNotFound("sg_enc02_all")
	sg_enc02_tanks = SGroup_CreateIfNotFound("sg_enc02_tanks")
	sg_enc02_tank01 = SGroup_CreateIfNotFound("sg_enc02_tank01")
	sg_enc02_tank02 = SGroup_CreateIfNotFound("sg_enc02_tank02")
	sg_enc02_tank03 = SGroup_CreateIfNotFound("sg_enc02_tank03")
	sg_enc02_crew = SGroup_CreateIfNotFound("sg_enc02_crew")
	
	Util_CreateSquads(player2, 
		{sg_enc02_all,sg_enc02_tanks, sg_enc02_tank03}, 
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, 
		mkr_early_tank, 
		mkr_enc02_tanks03, 
		nil, nil, nil, nil, 
		UPG.GERMAN.PANZER_TOP_GUNNER)
	
	Util_CreateSquads(player2, 
		{sg_enc02_all,sg_enc02_tanks, sg_enc02_tank02}, 
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, 
		mkr_mid_tank, 
		mkr_enc02_tanks02)
	
	Util_CreateSquads(player2, 
		{sg_enc02_all,sg_enc02_tanks, sg_enc02_tank01}, 
		SBP.GERMAN.PANZER_IV_STUBBY_SQUAD, 
		mkr_later_tank, 
		mkr_enc02_tanks01)
	
	Event_Proximity(CripplePanzer, 
		{sgroup=sg_enc02_tanks, crippleMaingun = true, health = t_difficulty.damageMid}, 
		sg_enc02_tanks, mkr_enc02_space, 20)
	SGroup_SetAnimatorState(sg_enc02_tanks, "vehicle_variant", "f1")
end

function CripplePanzer (data)
	Cmd_CriticalHit (player2, data.sgroup, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	SGroup_SetAvgHealth(data.sgroup, data.health)
	if (data.crippleMaingun) then
		Cmd_CriticalHit (player2, data.sgroup, CRIT.VEHICLE_DESTROY_MAINGUN, 1)
	end
	if (data.sgroup == sg_enc02_tanks) then
		CompleteArea02()
	end
end

function CompleteArea02()

	t_encounters[2] = {}
	local encData = {
		player = player2,
		sgroups = {sg_enc02_all},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc02_tanks01,
				sgroups = {sg_enc02_crew},
				load = 3,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc02_tanks02,
				sgroups = {sg_enc02_crew},
			},
		},
		onDeath = nil,
	}
	t_encounters[2].all = Encounter:Create(encData)
	
	local goalData = {
		name = "Defend",
		target = mkr_enc02_space,
		range = mkr_enc02_space,
		useSkirmishAI = true,
		tacticControlsList = {
			{
				tacticType = TACTIC_Cover,
				priority = 1000,
			},
		},
	}
	t_encounters[2].all:SetGoal(goalData)
	t_encounters[2].all:AddSgroup ( sg_enc02_tanks )
	
	Event_GroupIsDead(IncrementCounter, nil, sg_enc02_tank01)
	Event_GroupIsDead(IncrementCounter, nil, sg_enc02_tank02)
	Event_GroupIsDead(IncrementCounter, nil, sg_enc02_tank03)
end 	


--- area 3; machinegun nest near central point --
function SetupArea03()

	t_encounters[3] = {}
	sg_enc03_hmgs = SGroup_CreateIfNotFound("sg_enc03_hmgs")
	Util_CreateSquads(player2, sg_enc03_hmgs, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_enc03_hmg02, mkr_enc03_hmg01)
	
	t_encounters[3].hmgs = Encounter:ConvertSgroup(sg_enc03_hmgs)
	t_encounters[3].hmgs.reactData = {
		target = mkr_enc03_space,
		range = mkr_enc03_space,
		useSkirmishAI = true,
		fallback = false,
		}

	Event_PlayerCanSeeElement(ReactWhenSeen, {sgroup = sg_enc03_hmgs}, player1, sg_enc03_hmgs, ANY, 10)
end 	

--- area 4; infantry in combat with partisans --
function SetupArea04()

	t_encounters[4] = {}
	sg_enc04 = SGroup_CreateIfNotFound("sg_enc04")
	sg_enc04_grenadiers = SGroup_CreateIfNotFound("sg_enc04_grenadiers")
	sg_enc04_halftrack = SGroup_CreateIfNotFound("sg_enc04_halftrack")
	sg_enc04_partisans = SGroup_CreateIfNotFound("sg_enc04_partisans")
	
	local encData = {
		name = "Area 4 Germans",
		player = player2,
		sgroups = {sg_enc04, sg_enc04_grenadiers},
		units = {
			{
				sbp = SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
				spawn = mkr_enc04_grenadiers01,
				onDeath = IncrementCounter,
				sgroups = {sg_enc04_halftrack},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = sg_enc04_halftrack,
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = mkr_enc04_grenadiers02,
			},
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_enc04_panzerGrenadiers01,
			},
		},
		onDeath = PartisansToPlayer,
	}
	t_encounters[4].grenadiers = Encounter:Create(encData)
	t_encounters[4].grenadiers.reactData = {
		name = "Defend",
		target = mkr_enc04_space,
		range = mkr_enc04_space,
		}

	Util_CreateSquads(player4, {sg_enc04, sg_enc04_partisans}, SBP.SOVIET.PARTISAN_SQUAD_GRANATEWERFER_34_81MM_MORTAR, mkr_enc04_partisans01)
	Util_CreateSquads(player4, {sg_enc04, sg_enc04_partisans}, SBP.SOVIET.PARTISAN_SQUAD_KAR98K_RIFLE, mkr_enc04_partisans02)
	Util_CreateSquads(player4, {sg_enc04, sg_enc04_partisans}, SBP.SOVIET.PARTISAN_SQUAD_KAR98K_RIFLE, mkr_enc04_partisans02, eg_enc04_partisanHouse)

	SGroup_SetInvulnerable(sg_enc04, true)
	Event_PlayerCanSeeElement(ReactWhenSeen, 	  {sgroup = sg_enc04_grenadiers}, player1, sg_enc04, ANY, 5)
	Event_PlayerCanSeeElement(PartisanReaction, {sgroup = sg_enc04_partisans}, player1, sg_enc04, ANY, 0)
end 	


function SetupArea05()

	t_encounters[5] = {}
	sg_enc05_roadblock = SGroup_CreateIfNotFound("sg_enc05_roadblock")
	sg_enc05_infantry = SGroup_CreateIfNotFound("sg_enc05_infantry")
	sg_enc05_scout_car = SGroup_CreateIfNotFound("sg_enc05_scout_car")
	sg_enc05_atgun = SGroup_CreateIfNotFound("sg_enc05_atgun")
	eg_enc05_abandonnedAT = EGroup_CreateIfNotFound("eg_enc05_abandonnedAT")
	
	local encData = {
		player = player2,
		sgroups = {sg_enc05_roadblock},
		units = {
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = eg_enc05_bunker,
				sgroups = {sg_enc05_infantry},
			},
			{
				sbp = SBP.GERMAN.SCOUTCAR_SDKFZ222,
				spawn = mkr_enc05_scout_car,
				sgroups = {sg_enc05_scout_car},
				onDeath = IncrementCounter,
			},
			{
				sbp = SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
				spawn = mkr_enc05_atgun,
				sgroups = {sg_enc05_atgun},
			},
		},
	}
	t_encounters[5].roadblock = Encounter:Create(encData)
	t_encounters[5].roadblock.reactData = {
		name = "Defend",
		target = mkr_enc05_space,
		range = mkr_enc05_space,
		garrison = true,
		garrisonIdle = true,
		leashRange = mkr_enc05_leash,
	}
	
	SGroup_SetAvgHealth(sg_enc05_scout_car, t_difficulty.damageLight)
	Cmd_CriticalHit(player2, sg_enc05_scout_car, CRIT.VEHICLE_LIGHT_DAMAGE_ENGINE, 1)
	Rule_AddInterval(GetATPosition, 1)
	Event_GroupIsDead(CompleteReinforceObj, nil, sg_enc05_roadblock)
end


function SetupArea06()
	t_encounters[6] = {}
	t_encounters[6].vehicles = Encounter:ConvertSgroup(sg_enc06_vehicles)

	SGroup_IncreaseVeterancyRank(sg_enc06_panzerIV, 2, true)
	SGroup_IncreaseVeterancyRank(sg_enc06_panzerIV_01, 2, true)
	Cmd_InstantUpgrade(sg_enc06_panzerIV, UPG.GERMAN.PANZER_TOP_GUNNER)
	Cmd_CriticalHit (player2, sg_enc06_vehicles, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 1)
	SGroup_SetAvgHealth(sg_enc06_vehicles, t_difficulty.damageLight)
	
	Event_GroupIsDead(IncrementCounter, nil, sg_enc06_panzerIV)
	Event_GroupIsDead(IncrementCounter, nil, sg_enc06_panzerIV_01)
	Event_GroupIsDead(IncrementCounter, nil, sg_enc06_panzerIV_02)
	Event_GroupIsDead(IncrementCounter, nil, sg_enc06_halftrack)
	
	SGroup_SetAnimatorState(sg_enc06_panzerIV, "vehicle_variant", "f1")
	SGroup_SetAnimatorState(sg_enc06_panzerIV_01, "vehicle_variant", "f1")
	SGroup_SetAnimatorState(sg_enc06_panzerIV_02, "vehicle_variant", "f1")
end

function SetupArea07()

	t_encounters[7] = {}
	
	sg_enc07_all = SGroup_CreateIfNotFound("sg_enc07_all")
	sg_enc07_StuG_01 = SGroup_CreateIfNotFound("sg_enc07_StuG_01")
	sg_enc07_at = SGroup_CreateIfNotFound("sg_enc07_at")
	sg_enc07_StuG_02 = SGroup_CreateIfNotFound("sg_enc07_StuG_02")
	sg_enc07_infantry = SGroup_CreateIfNotFound("sg_enc07_infantry")
	sg_enc07_vehicles = SGroup_CreateIfNotFound("sg_enc07_vehicles")

	local encData = {
		player = player2,
		sgroups = {sg_enc07_all},
		units = {
			{
				sbp = SBP.GERMAN.PANZER_GRENADIER_SQUAD,
				spawn = mkr_enc07_infantry_01,
				sgroups = {sg_enc07_infantry},
			},
			{
				sbp = SBP.GERMAN.GRENADIER_SQUAD,
				spawn = eg_enc07_infantryHouse,
				sgroups = {sg_enc07_infantry},
			},
			{
				sbp = SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
				spawn = eg_enc07_hmgHouse,
				sgroups = {sg_enc07_infantry},
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				spawn = mkr_enc07_panzerIV_01,
				sgroups = {sg_enc07_StuG_01, sg_enc07_vehicles},
				onDeath = IncrementCounter,
				veterancyRank = 2,
			},
			{
				sbp = SBP.GERMAN.STUG_III_E_SQUAD,
				spawn = mkr_enc07_tiger,
				sgroups = {sg_enc07_StuG_02, sg_enc07_vehicles},
				onDeath = IncrementCounter,
				veterancyRank = 3,
			},
		},
		onDeath = nil,
	}   

	local goalData = {
		name = "Defend",
		target = mkr_enc07_space,
		range = mkr_enc07_space,
		useSkirmishAI = true,
		fallback = false,
		garrison = true,
		garrisonIdle = true,
	}   

	t_encounters[7].all = Encounter:Create(encData)
	t_encounters[7].all:SetGoal(goalData)
	
	Event_GroupIsDead(MoraleBreak, {enc=t_encounters[7].all}, sg_enc07_vehicles, 1)
end


function SetupArea08()

	t_encounters[8] = {}
	sg_enc08_all = SGroup_CreateIfNotFound("sg_enc08_all")

	local encData = {
		player = player2,
		sgroups = {sg_enc08_all},
		units = {
			{
				sbp = SBP.GERMAN.SNIPER_SQUAD,
				spawn = mkr_enc08_sniper,
				veterancyRank = 2,
			},
		},
		onDeath = nil,
	}   

	local goalData = {
		name = "Defend",
		target = mkr_enc08_space,
		range = mkr_enc08_space,
		useSkirmishAI = true,
		fallback = false,
		garrison = true,
		garrisonIdle = true,
	}   

	t_encounters[8].all = Encounter:Create(encData)
	t_encounters[8].all:SetGoal(goalData)
	
end


---- MISSION HELPER FUNCTIONS		

function IncrementCounter(unit)
	local sgroup = nil
	if (unit.data) then
		sgroup = unit.data.sgroups[1]
	elseif (unit._group) then
		sgroup = unit._group
	end
    
	g_count = g_count + 1
	
	local obj = nil
	local goal = 0
	local count = "ERR"
	if Objective_IsStarted(OBJ_Gold) then
		obj = OBJ_Gold
		count = g_count - g_silver
		goal = g_gold - g_silver
	elseif not Objective_IsComplete(OBJ_Silver) then
		obj = OBJ_Silver
		count = g_count
		goal = g_silver
	end
	
	if (obj) then
		Objective_SetCounter(obj, count, goal)
		if count >= goal then
			Objective_Complete(obj)
		end
	end
	_ToWDebugDisplay("IncrementCounter: " .. SGroup_GetName(sgroup) .. " (" .. count .. "/" .. goal ..")" , "gold") 
end

-- helper function for having groups react (gain a goal) only when spotted and only after a delay 
-- delay is set in the Event_PlayerCanSeeElement call

function ReactWhenSeen(data)
	local player = data._player
	local sgroup = data.sgroup
	_ToWDebugDisplay("ReactWhenSeen triggered", "gold")

	local groupName = SGroup_GetName(sgroup)
	_ToWDebugDisplay ("ReactWhenSeen received: " .. groupName)
	local encArea = string.sub(groupName,4,8)
	local index = tonumber(string.sub(encArea,5,5))
	local encName = string.sub(groupName,10,-1)
	local enc = t_encounters[index][encName]
	
	local reaction = Clone(enc.reactData) or {}
	reaction.name = reaction.name or "Defend"
	reaction.target = reaction.target or Marker_FromName("mkr_" .. encArea .. "_space", "")
	reaction.fallback = nil
		reaction.fallbackParams = reaction.fallbackParams or {}
		reaction.fallbackParams.thresholds = reaction.fallbackParams.thresholds or {0.01}
		reaction.fallbackParams.thresholdType = reaction.fallbackParams.thresholdType or Threshold_PercentageEntitiesRemaining
		reaction.fallbackParams.markers = reaction.fallbackParams.markers or {mkr_enemy_retreat_01}
		reaction.fallbackParams.retreat = reaction.fallbackParams.retreat or true

	Cmd_Stop(sgroup)
	enc:SetGoal(reaction)
end

function PartisanSwitch(data)
	World_EnableSharedLineOfSight(player1, player3, false)
	Util_SetPlayerOwner(data.sgroup, player3)
	Util_SetPlayerOwner(eg_enc04_partisanHouse, player3)
end

function PartisanReaction(data)
	Util_SetPlayerOwner(data.sgroup, player3)
	Util_SetPlayerOwner(eg_enc04_partisanHouse, player3)
	SGroup_SetInvulnerable(sg_enc04, false)
	t_encounters[4].partisans = Encounter:ConvertSgroup(sg_enc04_partisans)
	t_encounters[4].partisans.reactData = {
		name = "Defend",
		target = mkr_enc04_space,
		range = mkr_enc04_space,
		garrison = true,
		garrisonIdle = true,
		}
	ReactWhenSeen(data)
end

function PartisansToPlayer()
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	local function GetOut (sgroup, index, squad)
		if Squad_IsInHoldEntity(squad) or Squad_IsInHoldSquad(squad) then
			SGroup_Clear(sg_temp)
			SGroup_Add(sg_temp, squad)
			Cmd_UngarrisonSquad(sg_temp)
		end	
	end
	SGroup_ForEach(sg_enc04_partisans, GetOut)
	Rule_AddOneShot(PartisansToPlayer2, 0.2)
end

function PartisansToPlayer2()
	Util_SetPlayerOwner (sg_enc04_partisans, player1)
	Util_StartIntel (EVENTS.Partisans)
	if SGroup_Count(sg_enc04_partisans) >= 3 then
		Achieve ("tow_cold_weather_help_indeed")
	end
end


function CompleteReinforceObj ()
	Objective_Complete (OBJ_Reinforce)
end

function Reinforcements ()
	Util_CreateSquads (player1, {sg_playerUnits, sg_conscripts}, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_ally_reinforce_01, mkr_enc05_infantry_01, 2)
	Util_CreateSquads (player1, {sg_playerUnits, sg_engineers}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_ally_reinforce_01, mkr_enc05_infantry_01, 1)
	local data = {}
	data.id = HintPoint_Add(sg_engineers, true, 11037926, 3, HPAT_Hint, "Icons_commands_icon_command_build_fire")
	Event_Timer(RemoveUI, data, 60)
	local data2 = {}
	data2.id = HintPoint_Add(g_ATPosition, true, 11046246, 3, HPAT_Hint) -- LOCDB [11046246] 'Use Conscripts to recrew enemy anti-tank guns.'
	Event_Timer (RemoveUI, data2, 30)
	BeginnerHint_AddOpportunity (sg_conscripts, HINT_MERGE, true)
end


function MoraleBreak (data)
	data.enc:ClearGoal()
	Cmd_AbandonTeamWeapon ( data.enc.sgroup, false )
	Cmd_Retreat(data.enc.sgroup, mkr_enemy_retreat_01, mkr_enemy_retreat_01)
end


function GetATPosition ()
	if SGroup_IsAlive(sg_enc05_atgun) and (SGroup_IsRetreating(sg_enc05_atgun, ANY) == false) then
		g_ATPosition = SGroup_GetPosition(sg_enc05_atgun)
	else
		Rule_RemoveMe()
	end
end


function FailCheck()
	if Player_GetSquadCount(player1) < 1 then
		Mission_MissionComplete()
		Rule_RemoveMe()
	else
		Player_GetAll(player1)
		local movers = 0
		local function CanIMove (sgroup, index, squad)
			if Squad_HasCritical(squad, CRIT.VEHICLE_DESTROY_ENGINE) 
			or Squad_HasCritical(squad, CRIT.VEHICLE_LIGHT_DESTROY_ENGINE)
			or Squad_HasCritical(squad, CRIT.VEHICLE_KILL_DRIVER_RUSSIAN)
			or Squad_HasCritical(squad, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS) then
				movers = movers
			else
				movers = movers + 1
			end
		end
		SGroup_ForEach(sg_allsquads, CanIMove )
		if movers == 0 then
			Mission_MissionComplete()
			Rule_RemoveMe()
		end
	end
end
---------------- 	MISSION END FUNCTIONS ---------------------

function CompleteObjectives()
	Objective_Complete(OBJ_Main)
end


function Mission_MissionComplete()
	Game_SetMode(UI_Cinematic)
	FOW_RevealAll()
	Camera_MoveTo(mkr_enc07_space, true, 0.05)
	if Objective_IsComplete(OBJ_Silver) then
		Util_StartIntel(EVENTS.VPVictoryMessage)
	end
	Rule_AddDelayedInterval(Mission_MissionEnd, 1.5, 1)
end

function Mission_MissionEnd()
	if Event_IsAnyRunning() == false then
		Rule_RemoveMe()
		if Objective_IsComplete(OBJ_Silver) then
			Game_EndSP (true)
		else
			Game_EndSP(false)
		end
	end
end

function Achieve(data)
	if scartype (data) == ST_STRING then
		data = { id = data }
	end
	_ToWDebugDisplay("ACHIEVEMENT: " .. data.id, "gold")
	Scar_CompleteIntelBulletinTask(player1, data.id)
end

function SetupAchievements()
	Rule_AddInterval (AchievementCheck, 1)
end

function AchievementCheck ()
	Player_GetAll(player1)
	SGroup_Filter(sg_allsquads, { SBP.GERMAN.PANZER_IV_COMMAND_SQUAD, SBP.GERMAN.PANZER_IV_SQUAD, SBP.GERMAN.PANZER_IV_STUBBY_SQUAD}, FILTER_KEEP)
	local function HealthCheck (sgroup, index, squad)
		if Squad_GetHealthPercentage(squad) >= 1 then
			Rule_Remove(AchievementCheck)
			Achieve ("tow_cold_weather_winter_driver")
		end
	end
	if SGroup_Count(sg_allsquads) > 0 then
		SGroup_ForEach(sg_allsquads, HealthCheck)
	end
end


