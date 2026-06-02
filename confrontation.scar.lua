import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")

function OnGameSetup()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        World_EnableSharedLineOfSight(player1, player4, false)
        World_EnableSharedLineOfSight(player2, player4, false)
        World_EnableSharedLineOfSight(player3, player4, false)

end

Scar_AddInit(OnGameSetup)

function OnInit()

        Objective()

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)

        Hints()

        Reveal()

        Custom()

        LoadUnits()

        Upgrade()

        Assassination_MissionStart()

        UI_SetAbilityCardVisibility(false)
        UI_SetCPMeterVisibility(false)

	--Population cap override value
	g_popCapOverRide = 300
	
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetPopCapOverride(player, g_popCapOverRide)
	end


end

Scar_AddInit(OnInit)

function Objective()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Title = Util_CreateLocString("Assassination")
        Desc = Util_CreateLocString("Assassinate the German officer")

        Title1 = Util_CreateLocString("Kill the German officer in the city")
        Desc1 = Util_CreateLocString("Kill the German officer")

        ObjOne = Obj_Create(player1, Title, Desc, "Icons_abilities_ability_aef_reinforce", OT_Primary, 1)

        Obj1 = Obj_Create(player1, Title1, Desc1, "Icons_abilities_ability_aef_reinforce", OT_Secondary, 2)

        Obj_SetVisible(ObjOne, true)

        Obj_SetVisible(Obj1, true)

end

function CustomFailsafe()

        AI_EnableAll(false)

end


function Hints()

        local TextHint1 = Util_CreateLocString("Eliminate this officer")
        local TextHint2 = Util_CreateLocString("Capture points to move the halftrack and unlock a retreat point")
        local TextHint3 = Util_CreateLocString("Halftrack will immediately move to any point you captured")
        local TextHint4 = Util_CreateLocString("This is *K@BEL*, the destroyer of worlds, the eater of souls and the magnet of noobs")

        local Hint = HintPoint_Add(OfficerHint, true, TextHint1)
        HintPoint_SetVisible(Hint, true)

        local Point = HintPoint_Add(PointHint, true, TextHint2)
        HintPoint_SetVisible(Point, true)

        HintMouseover_Add(TextHint3, HalftrackHint, 5, true)

        HintMouseover_Add(TextHint4, EasterEgg, 5, true)

end

function AbilityFifth()

local player = World_GetPlayerAt(5)
Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("airborne_assault"))
Player_AddAbility(player, BP_GetAbilityBlueprint("airborne_assault"))

end

Scar_AddInit(AbilityFifth)

function Win()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        if SGroup_Count(OfficerVIP) == 0 then
                World_SetPlayerWin(player1)
                World_SetPlayerWin(player2)
                World_SetPlayerWin(player3)
                World_SetPlayerWin(player4)
        end

end

function Lose1()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Count1 = Player_GetSquadCount(player1)
        if Count1 == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end

end
function Lose2()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Count2 = Player_GetSquadCount(player2)
        if Count2 == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end

end

function Lose3()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Count3 = Player_GetSquadCount(player3)
        if Count3 == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
                World_SetPlayerLose(player4)
        end

end

function Reveal()

        FOW_RevealArea(Marker_GetPosition(mkr_officerareareveal), 5, -1)

end

function Upgrade()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("hq_anti_tank_grenade_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("hq_molotov_grenade_mp"))

end

function LoadUnits()

	Game_FadeToBlack(FADE_IN, 2.5)
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)

        Rule_AddDelayedInterval(Win, 1, 1)
        Rule_AddDelayedInterval(Lose1, 1, 1)
        Rule_AddDelayedInterval(Lose2, 1, 1)
        Rule_AddDelayedInterval(Lose3, 1, 1)

	Rule_AddOneShot(Camera, 1)
	Rule_AddOneShot(StartMove, 2)
	Rule_AddOneShot(ScoutCarMove, 4)
	Rule_AddOneShot(EnemyScoutCarSpawn, 6)
	Rule_AddOneShot(EnemyScoutCarMove, 7)
	Rule_AddOneShot(ScoutCarInvulnerable, 7)
	Rule_AddOneShot(Unload, 35)


end

function Custom()

        AI_EnableAll(false)

end


function Camera()

        Camera_Follow(ScoutCar3)

end

function StartMove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Command_SquadSquadLoad(player1, Commissar, SCMD_Load, ScoutCar1, false, true)
        Command_SquadSquadLoad(player2, Penal, SCMD_Load, ScoutCar2, false, true)
        Command_SquadSquadLoad(player3, Guard, SCMD_Load, ScoutCar3, false, true)

        Command_SquadEntityLoad(player5, BridgeSniper, SCMD_Load, house2, false, true)

end

function ScoutCarMove()

        Cmd_Move(ScoutCar1, mkr_scoutcar1)
        Cmd_Move(ScoutCar2, mkr_scoutcar2)
        Cmd_Move(ScoutCar3, mkr_scoutcar3)

end

function Unload()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)

        Command_SquadSquadLoad(player1, Commissar, SCMD_Unload, ScoutCar1, false, true)
        Command_SquadSquadLoad(player2, Penal, SCMD_Unload, ScoutCar2, false, true)
        Command_SquadSquadLoad(player3, Guard, SCMD_Unload, ScoutCar3, false, true)

        SGroup_SetInvulnerable(Guard, false)

        SGroup_SetPlayerOwner(PlayerUnits1, player1)
        SGroup_SetPlayerOwner(PlayerUnits2, player2)
        SGroup_SetPlayerOwner(PlayerUnits3, player3)

        SGroup_SetPlayerOwner(ScoutCar1, player4)
        SGroup_SetPlayerOwner(ScoutCar2, player4)
        SGroup_SetPlayerOwner(ScoutCar3, player4)

	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
	Util_StartIntel(EVENTS.Meeting)

end

function EnemyScoutCarSpawn()


        local player5 = World_GetPlayerAt(5)

	EnemyCar = SGroup_CreateIfNotFound("EnemyCar")
	Util_CreateSquads(player5, EnemyCar, SBP.GERMAN.SCOUTCAR_SDKFZ222, mkr_startscoutcar)

end

function EnemyScoutCarMove()

        Cmd_Move(EnemyCar, mkr_enemyscoutcarto)

end

function ScoutCarInvulnerable()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        SGroup_SetInvulnerable(ScoutCar3, true)
        SGroup_SetInvulnerable(Guard, true)

end

--------- Retreat ------------

function RetreatFirst()

	Rule_AddDelayedInterval(PointFirst, 1, 1)

end

Scar_AddInit(RetreatFirst)

function RetreatSecond()

        Rule_AddDelayedInterval(PointSecond, 1, 1)

end

Scar_AddInit(RetreatSecond)

function RetreatThird()

        Rule_AddDelayedInterval(PointThird, 1, 1)

end

Scar_AddInit(RetreatThird)


function PointFirst()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat1, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point1, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point1, player3, false)
        local Failsafe = EGroup_IsCapturedByPlayer(Point2, player5, false)
        if PointOne == true or PointTwo == true or PointThree == true and Failsafe == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Cmd_Move(Halftrack, mkr_halftrackto1)

                local ControlEntity = SGroup_Count(ControlPoint1)
                if ControlEntity == 1 then
                        local ControlAbilityEntity = SGroup_GetSpawnedSquadAt(ControlPoint1, 1)
                        Squad_Kill(ControlAbilityEntity)
                        local player5 = World_GetPlayerAt(5)
                        local Test1 = EGroup_GetOffsetPosition(Point1, 1, 1)
                        Cmd_Ability(player5, ABILITY.WEST_GERMAN.AIRBORNE_ASSAULT, Test1, nil, true)
                end
        end

end

function PointSecond()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat2, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point2, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point2, player3, false)
        local Failsafe = EGroup_IsCapturedByPlayer(Point3, player5, false)
        if PointOne == true or PointTwo == true or PointThree == true and Failsafe == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Cmd_Move(Halftrack, mkr_halftrackto2)

                local ControlConvoyCount = SGroup_Count(ControlConvoy)
                if ControlConvoyCount == 1 then
                        local ControlConvoyEntity = SGroup_GetSpawnedSquadAt(ControlConvoy, 1)
                        local player1 = World_GetPlayerAt(1)
                        local player2 = World_GetPlayerAt(2)
                        local player3 = World_GetPlayerAt(3)
                        local player4 = World_GetPlayerAt(4)
                        local player5 = World_GetPlayerAt(5)

                        Squad_Kill(ControlConvoyEntity)
	                Convoy1 = SGroup_CreateIfNotFound("Convoy1")
	                Convoy2 = SGroup_CreateIfNotFound("Convoy2")
	                Convoy3 = SGroup_CreateIfNotFound("Convoy3")
	                Convoy4 = SGroup_CreateIfNotFound("Convoy4")
	                Util_CreateSquads(player5, Convoy1, SBP.WEST_GERMAN.PANZER_II_LUCHS_SQUAD_MP, mkr_convoyspawn1)
	                Util_CreateSquads(player5, Convoy2, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_convoyspawn2)
	                Util_CreateSquads(player5, Convoy3, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_convoyspawn3)
	                Util_CreateSquads(player5, Convoy4, SBP.WEST_GERMAN.PANZERFUSILIER_SQUAD_MP, mkr_convoyspawn4)
                end
        end

end

function PointThird()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat3, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point3, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point3, player3, false)
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
                Cmd_Move(Halftrack, mkr_halftrackto3)

                local ControlEntity = SGroup_Count(ControlPoint3)
                if ControlEntity == 1 then
                        local ControlEntity = SGroup_GetSpawnedSquadAt(ControlPoint3, 1)
                        Squad_Kill(ControlEntity)

                        local player1 = World_GetPlayerAt(1)
                        local player2 = World_GetPlayerAt(2)
                        local player3 = World_GetPlayerAt(3)
                        local player4 = World_GetPlayerAt(4)
                        local player5 = World_GetPlayerAt(5)

	                Convoy5 = SGroup_CreateIfNotFound("Convoy5")
	                Convoy6 = SGroup_CreateIfNotFound("Convoy6")
	                Convoy7 = SGroup_CreateIfNotFound("Convoy7")
	                Convoy8 = SGroup_CreateIfNotFound("Convoy8")

	                Util_CreateSquads(player5, Convoy5, SBP.WEST_GERMAN.SDKFZ_251_17_FLAK_HALFTRACK_SQUAD_MP, mkr_convoyspawn1)
	                Util_CreateSquads(player5, Convoy6, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_convoyspawn2)
	                Util_CreateSquads(player5, Convoy7, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_convoyspawn3)
	                Util_CreateSquads(player5, Convoy8, SBP.WEST_GERMAN.KUBELWAGEN_SQUAD_MP, mkr_convoyspawn4)
                end
        end

end
                
        

--------- Reactions -----------

function Encounters()

        Rule_AddDelayedInterval(OstMove, 1, 1)
        Rule_AddDelayedInterval(AssaultGren, 1, 1)
        Rule_AddDelayedInterval(ScoutCarCounterattack, 1, 1)
        Rule_AddDelayedInterval(BridgeCounterattack, 1, 1)
        Rule_AddDelayedInterval(Ambush, 1, 1)
        Rule_AddDelayedInterval(OfficerHide, 1, 1)

        Rule_AddDelayedInterval(ConvoyTo1, 1, 1)
        Rule_AddDelayedInterval(ConvoyTo2, 1, 1)
        Rule_AddDelayedInterval(AmbushTo, 1, 1)

        Rule_AddDelayedInterval(OfficerCall, 1, 90)

        AmbushGroup3 = SGroup_CreateIfNotFound("AmbushGroup3")

end

Scar_AddInit(Encounters)

function OstMove()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(Encounter1Trigger, false, 7200)
        if Trigger == true then
                Command_SquadEntityLoad(player5, Encounter1Trigger, SCMD_Load, house1, false, true)
        end

end

function AssaultGren()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = EGroup_IsUnderAttack(BunkerAssaultGrens, false, 7200)
        if Trigger == true then
                Cmd_AttackMove(AssaultGrens, mkr_AssaultGrensTo)
        end

end

function ConvoyTo1()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Convoy1 = SGroup_CreateIfNotFound("Convoy1")
	Convoy2 = SGroup_CreateIfNotFound("Convoy2")
	Convoy3 = SGroup_CreateIfNotFound("Convoy3")
	Convoy4 = SGroup_CreateIfNotFound("Convoy4")

        Cmd_Move(Convoy1, mkr_convoyto1)
        Cmd_AttackMove(Convoy2, mkr_convoyto2)
        Cmd_Move(Convoy3, mkr_convoyto3)
        Cmd_AttackMove(Convoy4, mkr_convoyto4)

end

function ConvoyTo2()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Convoy5 = SGroup_CreateIfNotFound("Convoy5")
	Convoy6 = SGroup_CreateIfNotFound("Convoy6")
	Convoy7 = SGroup_CreateIfNotFound("Convoy7")
	Convoy8 = SGroup_CreateIfNotFound("Convoy8")

        Cmd_AttackMove(Convoy5, mkr_halftrackto3)
        Cmd_AttackMove(Convoy6, mkr_halftrackto3)
        Cmd_AttackMove(Convoy7, mkr_halftrackto3)
        Cmd_AttackMove(Convoy8, mkr_halftrackto3)

end

function ScoutCarCounterattack()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_Count(ScoutCarAttackTrigger)
        if Trigger == 0 then
                Cmd_Move(ScoutCarAttack, mkr_ScoutCarAttackTo)
        end

end

function BridgeCounterattack()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_Count(BridgeAT)
        if Trigger == 0 then
                Cmd_Move(BridgePanzer2, mkr_panzerto)
        end

end

function Ambush()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(GermanHalftrack, false, 7200)
        if Trigger == true then
                local ControlAmbushCount = SGroup_Count(ControlAmbush)
                if ControlAmbushCount == 1 then
                        local ControlAmbushEntity = SGroup_GetSpawnedSquadAt(ControlAmbush, 1)
                        local player1 = World_GetPlayerAt(1)
                        local player2 = World_GetPlayerAt(2)
                        local player3 = World_GetPlayerAt(3)
                        local player4 = World_GetPlayerAt(4)
                        local player5 = World_GetPlayerAt(5)

                        Squad_Kill(ControlAmbushEntity)
	                
	                Util_CreateSquads(player5, AmbushGroup3, SBP.GERMAN.STUG_III_SQUAD, mkr_ambushspawn)
	                Util_CreateSquads(player5, AmbushGroup3, SBP.GERMAN.GRENADIER_SQUAD, mkr_ambushspawn)
	                Util_CreateSquads(player5, AmbushGroup3, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, mkr_ambushspawn)
                end
        end

end

function AmbushTo()

        Cmd_AttackMove(AmbushGroup3, mkr_ambushspawnto)

end


function OfficerHide()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(OfficerTrigger, false, 7200)
        if Trigger == true then
                Command_SquadEntityLoad(player5, OfficerGroup, SCMD_Load, OfficerHouse, false, true)
        end

end

function OfficerCall()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(OfficerTrigger, false, 7200)
        if Trigger == true then
                local player1 = World_GetPlayerAt(1)
                local player2 = World_GetPlayerAt(2)
                local player3 = World_GetPlayerAt(3)
                local player4 = World_GetPlayerAt(4)
                local player5 = World_GetPlayerAt(5)

                local Target = Player_GetSquadConcentration(player1)
                Cmd_Ability(player5, ABILITY.WEST_GERMAN.AIRBORNE_ASSAULT, Target, nil, true)
                Util_StartIntel(EVENTS.Officer)
        end

end

function First()

local player = World_GetPlayerAt(1)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(First)

function Second()

local player = World_GetPlayerAt(2)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(Second)

function Third()

local player = World_GetPlayerAt(3)
Modify_PlayerResourceRate(player, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Manpower, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player, RT_Action, 0, MUT_Multiplication)

end

Scar_AddInit(Third)

function CustomStartingResources_Init()
	--[[
	
	Some information about income_modifier table and how to use it:
		- All resource income modifiers affect the # per minute value.
		- By default all resource income modifiers are set to 1 (value = 1, math_type = MUT_Multiplication). As you know, anything * 1 is the same value.
		- MUT_Multiplication multiplies the income rate and MUT_Addition adds to it. Here are some examples of that:
			- Let's say manpower income is 294 manpower per minute. With value = 10, math_type = MUT_Multiplication we will get 2940 manpower per minute,
			since 294 * 10 = 2940.
			Let's say manpower income is still 294 manpower per minute. With value = 10, math_type = MUT_Addition, we will get 304 manpower per minute, 
			since 294 + 10 = 304.
			
		- How to add 50 extra munition income? 
			{type = RT_Munition, value = 50, math_type = MUT_Addition}
		
		- How to remove 100 from manpower income?
			{type = RT_Manpower, value = -100, math_type = MUT_Addition}
			
		- How to double manpower income?
			{type = RT_Manpower, value = 2, math_type = MUT_Multiplication}
	]]
	
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
			income_modifier = {
				{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
				{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
			},
		},
		customSet_01 = {
			--player 1:
			[0] = {
				manpower = 400,
				fuel = 0,
				munition = 60,
				action = 0,
				command = 0,
			},
			--player 2:
			[1] = {
				manpower = 400,
				fuel = 0,
				munition = 60,
				action = 0,
				command = 0,
			},
			--player 3:
			[2] = {
				manpower = 400,
				fuel = 0,
				munition = 60,
				action = 0,
				command = 0,
			},
			--player 4:
			[3] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 5:
			[4] = {
				manpower = 2000,
				fuel = 2000,
				munition = 9000,
				action = 0,
				command = 16,
			},
			--player 6:
			[5] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
		income_modifier = {
			{type = RT_Manpower, value = 1, math_type = MUT_Multiplication}, -- manpower. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Munition, value = 1, math_type = MUT_Multiplication}, -- munition. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Fuel, value = 1, math_type = MUT_Multiplication}, -- fuel. math_type = MUT_Multiplication OR MUT_Addition
			{type = RT_Action, value = 1, math_type = MUT_Multiplication}, -- action/xp. math_type = MUT_Multiplication OR MUT_Addition
		},
                }, 
	}
	--This will set the resource set to use in-game
	local g_ResourceSet = ResourceSets.customSet_01
	
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
			if resource.math_type == MUT_Addition then
				_value = _value / (60 * 8)
			end
			Modify_PlayerResourceRate(player, resource.type, _value, resource.math_type)
		end
	end
end

function Player_GetRaceIndex(player)
	local racename = player
	if racename == World_GetPlayerAt(1) then
		return 0
	elseif racename == World_GetPlayerAt(2) then
		return 1
	elseif racename == World_GetPlayerAt(3) then
		return 2
	elseif racename == World_GetPlayerAt(4) then
		return 3
	elseif racename == World_GetPlayerAt(5) then
		return 4
	elseif racename == World_GetPlayerAt(6) then
		return 5
	end
end

Scar_AddInit(CustomStartingResources_Init)

function UnitBan()

	-- List of available units, stored as variables for easy access
	_grenadier_squad = {squad = "grenadier_squad_mp"}
	_assault_grenadier_squad = {ability = "assault_grenadiers"}
	_hmg42_team = {squad = "mg42_heavy_machine_gun_squad_mp"}
	_mortar_team = {squad = "mortar_team_81mm_mp"}
	_officer_squad = {ability = "assault_field_officer"}
	_osttruppen_squad = {ability = "ostruppen"}
	_panzer_grenadier_squad = {squad = "panzer_grenadier_squad_mp"}
	_urban_assault_panzer_grenadier_squad = {ability = "urban_assault_grenadiers"}
	_pioneer_squad = {squad = "pioneer_squad_mp"}
	_sniper_squad = {squad = "sniper_squad_mp"}
	_stormtrooper_squad = {ability = "stormtroopers"}
	
	_pak40_at_gun_squad = {squad = "pak40_75mm_at_gun_squad_mp", isvehicle = true}
	_pak43_at_gun_squad = {ability = "pak_43_emplacement_unlock", entity = "pak43_88mm_at_gun_mp", isvehicle = true}
	_brummbar_squad = {squad = "brummbar_squad_mp", isvehicle = true}
	_elefant_squad = {ability = "elefant_unlock", isvehicle = true}
	_mechanized_250_halftrack_grenadiers_squad = {ability = "mechanized_grenadier_group", isvehicle = true}
	_mortar_250_halftrack_squad = {ability = "mortar_halftrack", isvehicle = true}
	_sdkfz_251_halftrack_squad = {squad = "sdkfz_251_halftrack_squad_mp", isvehicle = true}
	_sdkfz_251_halftrack_squad_sp = {squad = "sdkfz_251_halftrack_squad", isvehicle = true}
	_le_fh18_howitzer_squad = {ability = "howitzer_105mm_emplacement_unlock", entity = "howitzer_105mm_le_fh18_mp", isvehicle = true}
	_opel_blitz_supply_truck_squad = {ability = "supply_truck", isvehicle = true}
	_ostwind_squad = {squad = "ostwind_squad_mp", isvehicle = true}
	_panther_squad = {squad = "panther_squad_mp", isvehicle = true}
	_panzer_iv_squad = {squad = "panzer_iv_squad_mp", isvehicle = true}
	_panzer_iv_command_squad = {ability = "armor_commander", isvehicle = true}
	_panzerwerfer_squad = {squad = "panzerwerfer_squad_mp", isvehicle = true}
	_scoutcar_222_squad = {squad = "scoutcar_sdkfz222_mp", isvehicle = true}
	_stug_3_e_squad = {ability = "stug_iii_e", isvehicle = true}
	_stug_3_squad = {squad = "stug_iii_squad_mp", isvehicle = true}
	_tiger_ace_squad = {ability = "tiger_tank_ace", isvehicle = true}
	_tiger_squad = {ability = "tiger_tank", isvehicle = true}
	_puma_squad = {ability = "puma_dispatch", isvehicle = true}
	_mortar_team = {squad = "mortar_team_81mm_mp", isvehicle = true}

	_combat_engineer_squad = {squad = "combat_engineer_squad_mp"} 
	_conscript_squad = {squad = "conscript_squad_mp"}
	_dshk_38_hmg_squad = {ability = "dshk_mp"}
	_maxim_hmg_squad = {squad = "m1910_maxim_heavy_machine_gun_squad_mp"}
	_mortar_squad = {squad = "pm-82_41_mortar_squad_mp"}
	_mortar_120mm_squad = {ability = "cmd_120mm_mortar_crew"}
	_partisan_squad = {ability = "partisans_commander_anti_infantry"}
	_partisan_at_squad = {ability = "partisans_commander_anti_vehicle"}
	_sniper_squad = {squad = "sniper_team_mp"}
	_guards_troops_squad = {ability = "cmd_guard_troops"}
	_penal_battalion_squad = {squad = "penal_battalion_mp"}
	_shock_troop_squad = {ability = "cmd_shock_troops"}

	_is_2_squad = {ability = "cmd_is2_heavy_tank", isvehicle = true}
	_isu_152_squad = {ability = "cmd_isu-152", isvehicle = true}
	_katyusha_squad = {squad = "katyusha_bm-13n_squad_mp", isvehicle = true}
	_kv_1_squad = {ability = "cmd_kv-1_unlock", isvehicle = true}
	_kv_2_squad = {ability = "kv-2", isvehicle = true}
	_kv_8_squad = {ability = "cmd_kv-8_unlock_mp", isvehicle = true}
	_m3a1_squad = {squad = "m3a1_scout_car_squad_mp", isvehicle = true}
	_m5_squad = {squad = "m5_halftrack_squad_mp", isvehicle = true}
	_howitzer_203mm_squad = {ability = "b4_203mm_howitzer", entity = "artillery_203mm_b4", isvehicle = true}
	_howitzer_152mm_squad = {ability = "cmd_ml_20", entity = "m1937_152mm_ml_20_artillery_mp", isvehicle = true}
	_zis_3_at_gun_squad = {squad = "m1942_zis-3_76mm_at_gun_squad_mp", isvehicle = true}
	_k_45mm_at_gun_squad = {ability = "m-42_at_gun", isvehicle = true}
	_su_76_squad = {squad = "su-76m_mp", isvehicle = true}
	_su_85_squad = {squad = "su-85_mp", isvehicle = true}
	_t_34_squad = {squad = "t_34_76_squad_mp", isvehicle = true}
	_t_34_85_squad = {ability = "cmd_t34_85_medium_tank", isvehicle = true}
	_t_34_85_one_squad = {ability = "cmd_advanced_t34_85_medium_tank", isvehicle = true}
	_t_70_squad = {squad = "t-70m_mp", isvehicle = true}
	_m4c_sherman_squad = {ability = "sherman_soviet_dispatch", isvehicle = true}

        _command_panther_squad = {ability = "command_panther", isvehicle = true}
        _ostwind_okw_squad = {ability = "ostwind_dispatch", isvehicle = true}
        _jagdtiger_squad = {ability = "jagdtiger", isvehicle = true}
        _panzer_iv_group_squad = {ability = "panzer_iv_group_dispatch", isvehicle = true}
        _sdkfz_251_17_flak_halftrack_squad = {squad = "sdkfz_251_17_flak_halftrack_squad_mp", isvehicle = true}
        _sdkfz_251_20_ir_searchlight_halftrack_squad = {squad = "sdkfz_251_20_ir_searchlight_halftrack_squad_mp", isvehicle = true}
        _sdkfz_251_halftrack_squad = {squad = "sdkfz_251_halftrack_squad_mp_2", isvehicle = true}
        _sdkfz_251_wurfrahmen_40_halftrack_squad = {squad = "sdkfz_251_wurfrahmen_40_halftrack_squad_mp", isvehicle = true}
        _king_tiger_squad = {squad = "king_tiger_squad_mp", isvehicle = true}
        _kubelwagen_squad = {squad = "kubelwagen_squad_mp", isvehicle = true}
        _panther_ausf_g_squad = {squad = "panther_ausf_g_squad_mp", isvehicle = true}
        _panzer_ii_luchs_squad = {squad = "panzer_ii_luchs_squad_mp", isvehicle = true}
        _armored_car_sdkfz_234_squad = {squad = "armored_car_sdkfz_234_squad_mp", isvehicle = true}
        _sturmtiger_squad = {squad = "sturmtiger_squad_mp", isvehicle = true}
        _jagdpanzer_tank_destroyer_squad = {squad = "jagdpanzer_tank_destroyer_squad_mp", isvehicle = true}

	_barracks = {squad = "barracks_mp", isvehicle = true}
	_motorpool = {squad = "motorpool_mp", isvehicle = true}
	_tank_depot = {squad = "tank_depot_mp", isvehicle = true}
	_weapon_support_center = {squad = "weapon_support_center_mp", isvehicle = true}

	-- List of units in a table
	_unitList = {
		_panzer_iv_command_squad,_dshk_38_hmg_squad,_conscript_squad,_sdkfz_251_halftrack_squad,_stormtrooper_squad,_tiger_ace_squad,_t_70_squad,
		_partisan_at_squad,_tiger_squad,_t_34_85_squad,_kv_2_squad,_mortar_squad,_penal_battalion_squad,_le_fh18_howitzer_squad,_su_76_squad,_sniper_squad,
		_isu_152_squad,_is_2_squad,_mortar_team,_pak43_at_gun_squad,_howitzer_203mm_squad,_osttruppen_squad,_maxim_hmg_squad,
		_k_45mm_at_gun_squad,_grenadier_squad,_brummbar_squad,_combat_engineer_squad,_sdkfz_251_halftrack_squad,_panzer_grenadier_squad,_assault_grenadier_squad,_officer_squad,
		_howitzer_152mm_squad,_t_34_squad,_scoutcar_222_squad,_kv_1_squad,_kv_8_squad,_pioneer_squad,_su_85_squad,
		_t_34_85_one_squad,_elefant_squad,_partisan_squad,_guards_troops_squad,_mortar_120mm_squad,_stug_3_squad,_stug_3_e_squad,_panzerwerfer_squad,
		_panzer_iv_squad,_shock_troop_squad,_ostwind_squad,_opel_blitz_supply_truck_squad,_mortar_250_halftrack_squad,_mechanized_250_halftrack_grenadiers_squad,
		_hmg42_team,_panther_squad,_urban_assault_panzer_grenadier_squad,_m4c_sherman_squad,_puma_squad,_command_panther_squad,_ostwind_okw_squad,
		_jagdtiger_squad,_panzer_iv_group_squad,_sdkfz_251_20_ir_searchlight_halftrack_squad,_sdkfz_251_halftrack_squad,
		_sdkfz_251_wurfrahmen_40_halftrack_squad,_king_tiger_squad,_panther_ausf_g_squad,_panzer_ii_luchs_squad,_armored_car_sdkfz_234_squad,_jagdpanzer_tank_destroyer_squad,
		_sdkfz_251_halftrack_squad_sp,_sdkfz_251_17_flak_halftrack_squad,_sturmtiger_squad,_mortar_120mm_squad,_shock_troop_squad,_guards_troops_squad,_assault_grenadier_squad,
	}

	-- List of units to block
	_block_list = {
		_t_70_squad,
	}
	
	-- Method of blocking units. 
	--	ITEM_REMOVED = The production icon/ability icon of the unit is removed.
	--	ITEM_LOCKED = The production icon/ability icon of the unit is visible but locked
	_block_method = ITEM_LOCKED 
	
	-- Block all vehicles by default, true/false
	_disable_vehicles = true
	
	-- Free text, displayed as a reason if the blocking method is ITEM_LOCKED
	_block_message = "This resource has been re-deployed elsewhere by the dispatcher."
	
	-- String converstion to a loc string
	local _loc = LOC(_block_message)
	_loc[1] = _block_message
	_block_message = _loc

	-- Helper function for applying unit restrictions
	local _blockItem = function(item)
		for i = 1, World_GetPlayerCount() do
			local player = World_GetPlayerAt(i)
			if item.squad then
				Player_SetSquadProductionAvailabilityInternal(player, BP_GetSquadBlueprint(item.squad), _block_method, _block_message)
			end
			if item.entity then
				Player_SetEntityProductionAvailabilityInternal(player, BP_GetEntityBlueprint(item.entity), _block_method, _block_message)
			end
			if item.ability then
				Player_SetAbilityAvailabilityInternal(player, BP_GetAbilityBlueprint(item.ability), _block_method, _block_message)
			end
		end
	end
	-- Apply unit restrictions based on the table _block_list
	for key, item in ipairs(_block_list) do
		_blockItem(item)
	end
	
	-- Block all vehicles if _disable_vehicles set to true
	if _disable_vehicles then
		for key, item in pairs(_unitList) do
			if item.isvehicle then
				_blockItem(item)
			end
		end
	end
end

Scar_AddInit(UnitBan)

function Assassination_MissionStart()
	Util_StartIntel(EVENTS.Intro)
end

EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/t03")
	g_MissionSpeechPath = "theater_of_war/t03"
end

Scar_AddInit(Init_Audio)

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

        local Text1 = Util_CreateLocString("Come men, we need to rendez vous with the others.")
        local Text2 = Util_CreateLocString("This is enemy territory, we need to be extremely careful where we tread.")

        local Text3 = Util_CreateLocString("Remember men, teamwork is critical here! Look out for the man beside you.")
        local Text4 = Util_CreateLocString("Our halftrack will catch up to us with additional men once we have secured an area.")
        local Text5 = Util_CreateLocString("May Morther Russia watch over us... move out!")

        local Text6 = Util_CreateLocString("Need reinforcements! I repeat! NEED MORE BACKUP!!!")

EVENTS.Intro = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text1)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text2)
	CTRL.WAIT()

end

EVENTS.Meeting = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text3)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Text5)
	CTRL.WAIT()

end

EVENTS.Officer = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text6)
        CTRL.WAIT()

end