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

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function OnInit()

        Objective()

        Cinematic()

	Rule_AddOneShot(CinematicEnd, 7)

        BuildingRestrict()

        Hints()

        EggFailsafe()

        HouseUnload()

        Rule_AddDelayedInterval(Eject, 1, 1)

        Airstrikes()

        WinLose()

        Reactions()

        Custom()

        Rule_AddDelayedInterval(CustomFailsafe, 1, 1)

        LoadUnits()

        Elites()

        Retreat()

        Upgrade()

        UI_SetAbilityCardVisibility(false)
        UI_SetCPMeterVisibility(false)

	UpDownSpawn1 = SGroup_CreateIfNotFound("UpDownSpawn1")

	--Population cap override value
	g_popCapOverRide = 500
	
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

        Title = Util_CreateLocString("Retrieve and Extract")
        Desc = Util_CreateLocString("Get intelligence from one of the houses")

        Title1 = Util_CreateLocString("Retrieve the enemy intelligence from one of the houses in the village")
        Desc1 = Util_CreateLocString("Get intelligence from one of the houses")

        Title2 = Util_CreateLocString("(Optional) Capture the house with the radio to call in more air support")
        Desc2 = Util_CreateLocString("Get to radio house")

        Title3 = Util_CreateLocString("Get to the extraction point at the harbor")
        Desc3 = Util_CreateLocString("Get to the harbor")

        ObjOne = Obj_Create(player1, Title, Desc, "Icons_abilities_ability_aef_reinforce", OT_Primary, 1)

        Obj1 = Obj_Create(player1, Title1, Desc1, "Icons_abilities_ability_aef_reinforce", OT_Secondary, 2)

        Obj2 = Obj_Create(player1, Title2, Desc2, "Icons_abilities_ability_aef_reinforce", OT_Secondary, 3)

        Obj3 = Obj_Create(player1, Title3, Desc3, "Icons_abilities_ability_aef_reinforce", OT_Secondary, 4)


        Obj_SetVisible(ObjOne, true)

        Obj_SetVisible(Obj1, true)

end

function Cinematic()

	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
        Camera_Follow(CinematicUnit)

        Cmd_Move(CinematicUnit, mkr_first)
        Cmd_Move(CinematicUnit2, mkr_second)
        Cmd_Move(CinematicUnit3, mkr_third)

end

function CinematicEnd()

        Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
        Sabotage_MissionStart()


end

function BuildingRestrict()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)

end

function Custom()

        AI_EnableAll(false)

end

function CustomFailsafe()

        AI_EnableAll(false)

end

function LoadUnits()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Command_SquadSquadLoad(player5, PatrolUnit, SCMD_Load, PatrolCar, false, true)
        Command_SquadSquadLoad(player5, PatrolShock, SCMD_Load, PatrolShockCar, false, true)
        Command_SquadSquadLoad(player5, ShockLoad1, SCMD_Load, CarLoad1, false, true)
        Command_SquadSquadLoad(player5, GuardLoad2, SCMD_Load, CarLoad2, false, true)
        Command_SquadSquadLoad(player5, ConsLoad3, SCMD_Load, CarLoad3, false, true)
        Command_SquadEntityLoad(player5, GuardHouse, SCMD_Load, House1, false, true)
        Command_SquadEntityLoad(player5, ConsHouse, SCMD_Load, House3, false, true)
        Command_SquadEntityLoad(player5, MGHouse, SCMD_Load, MGHouseLoad, false, true)

end

function Hints()

        local TextHint = Util_CreateLocString("Search this house")
        local TextExtraction = Util_CreateLocString("Collect enemy intelligence and return to this extraction point")
        local TextPoints = Util_CreateLocString("Capture territory points to unlock its retreat point")

        local Hint1 = HintPoint_Add(House1, true, TextHint)
        local Hint2 = HintPoint_Add(House2, true, TextHint)
        local Hint3 = HintPoint_Add(House3, true, TextHint)
        local Hint4 = HintPoint_Add(House4, true, TextHint)
        local Hint5 = HintPoint_Add(House5, true, TextHint)
        local Hint6 = HintPoint_Add(House6, true, TextHint)
        local Hint7 = HintPoint_Add(House7, true, TextHint)
        local Hint8 = HintPoint_Add(House8, true, TextHint)
        local Hint9 = HintPoint_Add(House9, true, TextHint)

        local HintExtraction = HintPoint_Add(mkr_extraction, true, TextExtraction)

        local HintPoint1 = HintPoint_Add(mkr_point1, true, TextPoints)
        local HintPoint5 = HintPoint_Add(mkr_point5, true, TextPoints)


        HintPoint_SetVisible(Hint1, true)
        HintPoint_SetVisible(Hint2, true)
        HintPoint_SetVisible(Hint3, true)
        HintPoint_SetVisible(Hint4, true)
        HintPoint_SetVisible(Hint5, true)
        HintPoint_SetVisible(Hint6, true)
        HintPoint_SetVisible(Hint7, true)
        HintPoint_SetVisible(Hint8, true)
        HintPoint_SetVisible(Hint9, true)

        HintPoint_SetVisible(HintExtraction, true)

        HintPoint_SetVisible(HintPoint1, true)
        HintPoint_SetVisible(HintPoint5, true)


end

function EggFailsafe()

        local hintText = Util_CreateLocString("This is Seth_Kiparis, the better of modest reviewers, the best of political debaters and the most Cynical Croat of them all")
        HintMouseover_Add(hintText, EasterEgg, 5, true)

end

---------------WinLose-----------------

function WinLose()

        Rule_AddDelayedInterval(WinOne, 1, 1)
        Rule_AddDelayedInterval(WinTwo, 1, 1)
        Rule_AddDelayedInterval(WinThree, 1, 1)
        Rule_AddDelayedInterval(LoseOne, 1, 1)
        Rule_AddDelayedInterval(LoseTwo, 1, 1)
        Rule_AddDelayedInterval(LoseThree, 1, 1)

end

function WinOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = Prox_ArePlayersNearMarker(player1, mkr_extraction, false, 12)
        local Control = SGroup_Count(WinControl)
        if Trigger == true and Control == 0 then
                World_SetPlayerWin(player1)
        end

end

function WinTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = Prox_ArePlayersNearMarker(player2, mkr_extraction, false, 12)
        local Control = SGroup_Count(WinControl)
        if Trigger == true and Control == 0 then
                World_SetPlayerWin(player2)
        end

end

function WinThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = Prox_ArePlayersNearMarker(player3, mkr_extraction, false, 12)
        local Control = SGroup_Count(WinControl)
        if Trigger == true and Control == 0 then
                World_SetPlayerWin(player3)
        end

end

function LoseOne()

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

function LoseTwo()

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

function LoseThree()

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

---------------Reactions----------------

function Reactions()

        Rule_AddDelayedInterval(Patrol, 1, 1)
        Rule_AddDelayedInterval(Patrol2, 1, 1)
        Rule_AddDelayedInterval(ScoutCar1, 1, 1)
        Rule_AddDelayedInterval(ScoutCar2, 1, 1)
        Rule_AddDelayedInterval(ScoutCar3, 1, 1)
        Rule_AddDelayedInterval(Guards, 1, 1)
        Rule_AddDelayedInterval(T34, 1, 1)
        Rule_AddDelayedInterval(Shocks, 1, 1)
        Rule_AddDelayedInterval(KVUp, 1, 1)
        Rule_AddDelayedInterval(ISAmbush, 1, 1)

end

function Patrol()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Cmd_SquadPatrolMarker(PatrolCar, mkr_patrol)

end

function Patrol2()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Cmd_SquadPatrolMarker(PatrolShockCar, mkr_patrol2)

end


function ScoutCar1()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(CarLoad1Trigger, false, 7200)

        if Trigger == true then
                Player_GetSquadConcentration(player1)
        end

end

function ScoutCar2()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(CarLoad2Trigger, false, 7200)

        if Trigger == true then
                Cmd_Move(CarLoad3, mkr_carto3)
        end

end

function ScoutCar3()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local CarLoad3Trigger1 = SGroup_GetSpawnedSquadAt(CarLoad3Trigger, 1)
        local CarLoad3Trigger2 = SGroup_GetSpawnedSquadAt(CarLoad3Trigger, 2)
        local See1 = Player_CanSeeSquad(player2, CarLoad3Trigger1, false)
        local See2 = Player_CanSeeSquad(player3, CarLoad3Trigger1, false)
        local See3 = Player_CanSeeSquad(player2, CarLoad3Trigger2, false)
        local See4 = Player_CanSeeSquad(player3, CarLoad3Trigger2, false)

        if See1 == true or See2 == true or See3 == true or See4 == true then
                Cmd_Move(CarLoad3, mkr_carto3)
        end

end

function Guards()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Guard = SGroup_GetSpawnedSquadAt(AssaultGuards, 1)
        local See2 = Player_CanSeeSquad(player2, Guard, true)
        local See3 = Player_CanSeeSquad(player3, Guard, true)

        if See2 == true or See3 == true then
                Cmd_AttackMove(AssaultGuardsAll, mkr_guardsto)
        end

end

function T34()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(TankTrigger, false, 7200)

        if Trigger == true then
                Cmd_AttackMove(Tank, mkr_tankto)
        end

end

function Shocks()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(ShockTrigger, false, 7200)

        if Trigger == true then
                Cmd_AttackMove(ShockAmbush, mkr_shockto)
        end

end

function KVUp()

        local Trigger = SGroup_IsUnderAttack(KV1UpTrigger, false, 7200)
        if Trigger == true then
                Cmd_Move(KV1Up, mkr_kv1upto)
        end

end

function ISAmbush()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger = SGroup_IsUnderAttack(ISTrigger, false, 7200)

        if Trigger == true then
                Cmd_Move(IS, mkr_istriggerto)
        end

end


---------------Houses----------------

function HouseUnload()

        Rule_AddDelayedInterval(HouseOne, 1, 1)
        Rule_AddDelayedInterval(HouseTwo, 1, 1)
        Rule_AddDelayedInterval(HouseThree, 1, 1)
        Rule_AddDelayedInterval(HouseFour, 1, 1)
        Rule_AddDelayedInterval(HouseFive, 1, 1)
        Rule_AddDelayedInterval(HouseSix, 1, 1)
        Rule_AddDelayedInterval(HouseSeven, 1, 1)
        Rule_AddDelayedInterval(HouseEight, 1, 1)
        Rule_AddDelayedInterval(HouseNine, 1, 1)
        Rule_AddDelayedInterval(HouseRadar, 1, 1)

end

function HouseOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House1, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local ControlOne = SGroup_Count(Control1)
                if ControlOne == 1 then
                        SGroup_Kill(Control1)
                end
        end

end

function HouseTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House2, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control2)
                if Control == 1 then
                        SGroup_Kill(Control2)
                end
        end

end

function HouseThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House3, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)


        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control3)
                if Control == 1 then
                        SGroup_Kill(Control3)
                end
        end

end

function HouseFour()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House4, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        local Control = SGroup_Count(Control4)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control4)
                if Control == 1 then

                        SGroup_Kill(Control4)

	                Rule_AddOneShot(Burn, 5)

                end
        end

end

function Eject()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Command_Entity(player1, HouseFourAlt, CMD_UnloadSquads)
        Command_Entity(player2, HouseFourAlt, CMD_UnloadSquads)
        Command_Entity(player3, HouseFourAlt, CMD_UnloadSquads)

end

function Burn()

                local player1 = World_GetPlayerAt(1)
                local player2 = World_GetPlayerAt(2)
                local player3 = World_GetPlayerAt(3)
                local player4 = World_GetPlayerAt(4)
                local player5 = World_GetPlayerAt(5)

                local House = EGroup_GetSpawnedEntityAt(House4, 1)
                Obj_SetState(Obj1, OS_Complete)
                Obj_SetVisible(Obj3, true)
                Command_Entity(player1, House4, CMD_UnloadSquads)
                Command_Entity(player2, House4, CMD_UnloadSquads)
                Command_Entity(player3, House4, CMD_UnloadSquads)
                SGroup_Kill(UpDownControl)
                SGroup_Kill(WinControl)
                Entity_SetOnFire(House)
	        Util_StartIntel(EVENTS.Intelligence)
                Cmd_Move(KV1Down, mkr_kv1downtrigger)
                Cmd_Move(KV1Down2, mkr_kv1downto)
                Cmd_Move(KV1Down3, mkr_kv1downtrigger2)
                Cmd_Move(ISU, mkr_isuto)
                Cmd_Move(ISTrigger, mkr_istriggerto)
                Cmd_Move(LeftLeft, mkr_leftleft)
                Cmd_Move(Left, mkr_left)
                Cmd_Move(RightRight, mkr_rightright)
                Cmd_Move(Right, mkr_right)
                Cmd_Move(EngLeft, mkr_engleft)
                Cmd_Move(EngRight, mkr_engright)
                Cmd_Move(Top, mkr_top)
                Cmd_Move(Middle, mkr_middle)
                Cmd_Move(Bottom, mkr_bottom)
                Cmd_Move(ConsLeft, mkr_consleft)
                Cmd_Move(ConsRight, mkr_consright)
                Cmd_Move(ExtractionGuard, mkr_extractionguardto)
                local RetreatEntity1 = EGroup_GetSpawnedEntityAt(Retreat1, 1)
                local RetreatEntity2 = EGroup_GetSpawnedEntityAt(Retreat2, 1)
                local RetreatEntity3 = EGroup_GetSpawnedEntityAt(Retreat3, 1)
                local RetreatEntity4 = EGroup_GetSpawnedEntityAt(Retreat5, 1)
                local RetreatEntity5 = EGroup_GetSpawnedEntityAt(Retreat6, 1)
                local PointEntity1 = EGroup_GetSpawnedEntityAt(Point1, 1)
                local PointEntity2 = EGroup_GetSpawnedEntityAt(Point2, 1)
                local PointEntity3 = EGroup_GetSpawnedEntityAt(Point3, 1)
                local PointEntity4 = EGroup_GetSpawnedEntityAt(Point5, 1)
                local PointEntity5 = EGroup_GetSpawnedEntityAt(Point6, 1)
                Entity_SetPlayerOwner(RetreatEntity1, player5)
                Entity_SetPlayerOwner(RetreatEntity2, player5)
                Entity_SetPlayerOwner(RetreatEntity3, player5)
                Entity_SetPlayerOwner(RetreatEntity4, player5)
                Entity_SetPlayerOwner(RetreatEntity5, player5)
                Entity_SetPlayerOwner(PointEntity1, player5)
                Entity_SetPlayerOwner(PointEntity2, player5)
                Entity_SetPlayerOwner(PointEntity3, player5)
                Entity_SetPlayerOwner(PointEntity4, player5)
                Entity_SetPlayerOwner(PointEntity5, player5)

end



function HouseFive()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House5, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control5)
                if Control == 1 then
                        local TextHint1 = Util_CreateLocString("Occupy this house to call in more air support")
                        local RadioHint = HintPoint_Add(RadioHouse, true, TextHint1)
                        HintPoint_SetVisible(RadioHint, true)
                        Obj_SetVisible(Obj2, true)
                        SGroup_Kill(Control5)
                        Util_StartIntel(EVENTS.RadarIntelligence)
                end
        end

end

function HouseSix()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House6, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control6)
                if Control == 1 then
                        SGroup_Kill(Control6)
                end
        end

end

function HouseSeven()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House7, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control7)
                if Control == 1 then
                        SGroup_Kill(Control7)
                end
        end

end

function HouseEight()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House8, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control8)
                if Control == 1 then
                        SGroup_Kill(Control8)
                end
        end

end

function HouseNine()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local House = EGroup_GetSpawnedEntityAt(House9, 1)
        local IfHold1 = Player_OwnsEntity(player1, House)
        local IfHold2 = Player_OwnsEntity(player2, House)
        local IfHold3 = Player_OwnsEntity(player3, House)

        if IfHold1 == true or IfHold2 == true or IfHold3 == true then
                local Control = SGroup_Count(Control9)
                if Control == 1 then
                        SGroup_Kill(Control9)
                end
        end

end

function HouseRadar()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)
        if PointOne == true or PointTwo == true or PointThree == true then
                local Control = SGroup_Count(RadarControl)
                if Control == 1 then
                        SGroup_Kill(RadarControl)
                        Obj_SetState(Obj2, OS_Complete)
	                Util_StartIntel(EVENTS.Radar)
                end
        end
end

-----------------------Airstrikes-----------------------

function Airstrikes()

        Rule_AddDelayedInterval(LeftStrike, 1, 1)
        Rule_AddDelayedInterval(RightStrike, 1, 1)
        Rule_AddDelayedInterval(ISUStrike, 1, 1)
        Rule_AddDelayedInterval(ISStrike, 1, 1)

end

function AbilityFourth()

local player = World_GetPlayerAt(4)
Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
Player_AddAbility(player, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("stuka_close_air_support"))
Player_AddAbility(player, BP_GetAbilityBlueprint("stuka_close_air_support"))
Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
Player_AddAbility(player, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("stuka_flame_strike"))
Player_AddAbility(player, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))

end

Scar_AddInit(AbilityFourth)

function LeftStrike()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger1 = Player_CanSeeSGroup(player1, LeftLeft, false)
        local Trigger2 = Player_CanSeeSGroup(player2, LeftLeft, false)
        local Trigger3 = Player_CanSeeSGroup(player3, LeftLeft, false)
        if Trigger1 == true or Trigger2 == true or Trigger3 == true then
                local Control = SGroup_Count(LeftStrikeControl)
                if Control == 1 then
                        SGroup_Kill(LeftStrikeControl)
                	Rule_AddOneShot(LeftStrikeOne, 9)
                	Rule_AddOneShot(LeftStrikeTwo, 13)
                	Rule_AddOneShot(LeftStrikeThree, 16)
                end
        end

end

function RightStrike()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger1 = Player_CanSeeSGroup(player1, Top, false)
        local Trigger2 = Player_CanSeeSGroup(player2, Middle, false)
        local Trigger3 = Player_CanSeeSGroup(player3, ConsLeft, false)
        local Trigger4 = Player_CanSeeSGroup(player3, Bottom, false)
        if Trigger1 == true or Trigger2 == true or Trigger3 == true or Trigger4 == true then
                local Control = SGroup_Count(RightStrikeControl)
                if Control == 1 then
                        SGroup_Kill(RightStrikeControl)
                	Rule_AddOneShot(RightStrikeOne, 1)
                	Rule_AddOneShot(RightStrikeTwo, 3)
                	Rule_AddOneShot(RightStrikeThree, 4)
                	Rule_AddOneShot(RightStrikeFour, 9)
                end
        end

end

function ISUStrike()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger1 = Player_CanSeeSGroup(player1, ISU, false)
        local Trigger2 = Player_CanSeeSGroup(player2, ISU, false)
        local Trigger3 = Player_CanSeeSGroup(player3, ISU, false)
        if Trigger1 == true or Trigger2 == true or Trigger3 == true then
                local Control = SGroup_Count(ISUControl)
                if Control == 1 then
                        SGroup_Kill(ISUControl)
                        Util_StartIntel(EVENTS.AirISU)
                	Rule_AddOneShot(StrikeOne, 1)
                	Rule_AddOneShot(StrikeFour, 4)
                	Rule_AddOneShot(StrikeTwo, 7)
                	Rule_AddOneShot(StrikeFive, 9)
                	Rule_AddOneShot(StrikeThree, 11)
                end
        end

end

function ISStrike()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Trigger1 = Player_CanSeeSGroup(player1, IS, false)
        local Trigger2 = Player_CanSeeSGroup(player2, IS, false)
        local Trigger3 = Player_CanSeeSGroup(player3, IS, false)
        if Trigger1 == true or Trigger2 == true or Trigger3 == true then
                local Control = SGroup_Count(ISControl)
                if Control == 1 then
                        SGroup_Kill(ISControl)
                        Util_StartIntel(EVENTS.AirIS)
                	Rule_AddOneShot(ISStrikeOne, 1)
                	Rule_AddOneShot(ISStrikeTwo, 4)
                	Rule_AddOneShot(ISStrikeThree, 12)
                	Rule_AddOneShot(ISStrikeFour, 15)
                end
        end

end

function LeftStrikeOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_leftstrike)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_leftstrike, Direction, true)
                Util_StartIntel(EVENTS.AirLeft)
        end

end

function LeftStrikeTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_leftstrike)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_leftstrike, Direction, true)
        end

end

function LeftStrikeThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_leftstrike)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_leftstrike, Direction, true)
        end

end

function RightStrikeOne()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_rightstrike1)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, mkr_rightstrike1, Direction, true)
                Util_StartIntel(EVENTS.AirRight)
        end

end

function RightStrikeTwo()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_rightstrike2)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_INCENDIARY_BOMBS, mkr_rightstrike2, Direction, true)
        end

end

function RightStrikeThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_rightstrike1)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_rightstrike1, Direction, true)
        end

end

function RightStrikeFour()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_rightstrike2)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_rightstrike2, Direction, true)
        end

end

function StrikeOne()

        local player4 = World_GetPlayerAt(4)

        local Direction = Marker_GetDirection(mkr_isuto)
        Cmd_Ability(player4, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_isuto, Direction, true)

end

function StrikeTwo()

        local player4 = World_GetPlayerAt(4)

        local Direction = Marker_GetDirection(mkr_isuto)
        Cmd_Ability(player4, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_isuto, Direction, true)

end

function StrikeThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then
                local Direction = Marker_GetDirection(mkr_isuto)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_FRAGMENTATION_BOMB, mkr_isuto, Direction, true)
        end

end

function StrikeFour()

        local player4 = World_GetPlayerAt(4)

        local Direction = Marker_GetDirection(mkr_isuto)
        Cmd_Ability(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_isuto, Direction, true)

end

function StrikeFive()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then

                local Direction = Marker_GetDirection(mkr_isuto)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_CLOSE_AIR_SUPPORT, mkr_isuto, Direction, true)
        end

end

function ISStrikeOne()

        local player4 = World_GetPlayerAt(4)

        local Direction = Marker_GetDirection(mkr_istriggerto)
        Cmd_Ability(player4, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_istriggerto, Direction, true)

end

function ISStrikeTwo()

        local player4 = World_GetPlayerAt(4)

        local Direction = Marker_GetDirection(mkr_istriggerto2)
        Cmd_Ability(player4, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_istriggerto2, Direction, true)

end

function ISStrikeThree()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then

                local Direction = Marker_GetDirection(mkr_istriggerto)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_istriggerto, Direction, true)
        end

end

function ISStrikeFour()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local PointOne = EGroup_IsCapturedByPlayer(Radar, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Radar, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Radar, player3, false)

        if PointOne == true or PointTwo == true or PointThree == true then

                local Direction = Marker_GetDirection(mkr_istriggerto2)
                Cmd_Ability(player4, ABILITY.GERMAN.STUKA_SMOKE_BOMB, mkr_istriggerto2, Direction, true)
        end

end
        

-----------------------Elites------------------------

function Elites()

        PenalOne()
        ConsOne()
        GuardsOne()
        ShockOne()
        GuardsTwo()

        Rule_AddDelayedInterval(PenalOneHint, 1, 1)
        Rule_AddDelayedInterval(ConsOneHint, 1, 1)
        Rule_AddDelayedInterval(GuardsOneHint, 1, 1)
        Rule_AddDelayedInterval(ShockOneHint, 1, 1)
        Rule_AddDelayedInterval(GuardsTwoHint, 1, 1)

end

function PenalOne()

        local ControlEntity = SGroup_GetSpawnedSquadAt(PenalElite, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PPSH41_ASSAULT_PACKAGE)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PPSH41_ASSAULT_PACKAGE)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)

        Modify_ReceivedDamage(PenalElite, 0.7)
        SGroup_IncreaseVeterancyRank(PenalElite, 3, false)

end

function PenalOneHint()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Penal = SGroup_GetSpawnedSquadAt(PenalElite, 1)
        local See1 = Player_CanSeeSquad(player1, Penal, true)
        local See2 = Player_CanSeeSquad(player2, Penal, true)
        local See3 = Player_CanSeeSquad(player3, Penal, true)

        if See1 == true or See2 == true or See3 == true then

                local Elite1 = Util_CreateLocString("Prestige NKVD Selects")
                HintPoint_Add(PenalElite, true, Elite1)
        end

end

function ConsOne()

        local ControlEntity = SGroup_GetSpawnedSquadAt(ConsElite, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PPSH41_ASSAULT_PACKAGE)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)

        Modify_ReceivedDamage(ConsElite, 0.7)
        SGroup_IncreaseVeterancyRank(ConsElite, 3, false)

end

function ConsOneHint()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Cons = SGroup_GetSpawnedSquadAt(ConsElite, 1)
        local See1 = Player_CanSeeSquad(player1, Cons, true)
        local See2 = Player_CanSeeSquad(player2, Cons, true)
        local See3 = Player_CanSeeSquad(player3, Cons, true)

        if See1 == true or See2 == true or See3 == true then

                local Elite1 = Util_CreateLocString("Veteran Conscript Troops")
                HintPoint_Add(ConsElite, true, Elite1)
        end

end

function GuardsOne()

        local ControlEntity = SGroup_GetSpawnedSquadAt(GuardsElite, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PPSH41_ASSAULT_PACKAGE)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.BAZOOKA_MP)

        Modify_ReceivedDamage(GuardsElite, 0.7)
        SGroup_IncreaseVeterancyRank(GuardsElite, 3, false)

end

function GuardsOneHint()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Guards = SGroup_GetSpawnedSquadAt(GuardsElite, 1)
        local See1 = Player_CanSeeSquad(player1, Guards, true)
        local See2 = Player_CanSeeSquad(player2, Guards, true)
        local See3 = Player_CanSeeSquad(player3, Guards, true)

        if See1 == true or See2 == true or See3 == true then

                local Elite1 = Util_CreateLocString("22nd Elite Guards Rifles")
                HintPoint_Add(GuardsElite, true, Elite1)
        end

end


function ShockOne()

        local ControlEntity = SGroup_GetSpawnedSquadAt(ShockElite, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)

        Modify_ReceivedDamage(ShockElite, 0.8)
        SGroup_IncreaseVeterancyRank(ShockElite, 3, false)

end

function ShockOneHint()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Shock = SGroup_GetSpawnedSquadAt(ShockElite, 1)
        local See1 = Player_CanSeeSquad(player1, Shock, true)
        local See2 = Player_CanSeeSquad(player2, Shock, true)
        local See3 = Player_CanSeeSquad(player3, Shock, true)

        if See1 == true or See2 == true or See3 == true then

                local Elite1 = Util_CreateLocString("3rd Shock Honor Guards")
                HintPoint_Add(ShockElite, true, Elite1)
        end

end

function GuardsTwo()

        local ControlEntity = SGroup_GetSpawnedSquadAt(GuardsElite2, 1)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_MP)
        Squad_GiveSlotItem(ControlEntity, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)

        Modify_ReceivedDamage(GuardsElite2, 0.8)
        SGroup_IncreaseVeterancyRank(GuardsElite2, 3, false)

end

function GuardsTwoHint()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local Shock = SGroup_GetSpawnedSquadAt(GuardsElite2, 1)
        local See1 = Player_CanSeeSquad(player1, Shock, true)
        local See2 = Player_CanSeeSquad(player2, Shock, true)
        local See3 = Player_CanSeeSquad(player3, Shock, true)

        if See1 == true or See2 == true or See3 == true then

                local Elite1 = Util_CreateLocString("14th Elite Guards Rifles")
                HintPoint_Add(GuardsElite2, true, Elite1)
        end

end

-----------------Retreat---------------------

function Retreat()

        Rule_AddDelayedInterval(PointFirst, 1, 1)
        Rule_AddDelayedInterval(PointSecond, 1, 1)
        Rule_AddDelayedInterval(PointThird, 1, 1)
        Rule_AddDelayedInterval(PointFourth, 1, 1)
        Rule_AddDelayedInterval(PointFifth, 1, 1)
        Rule_AddDelayedInterval(PointSixth, 1, 1)

end

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
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
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
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
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
        end

end

function PointFourth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat4, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point4, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point4, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point4, player3, false)
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
        end

end

function PointFifth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat5, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point5, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point5, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point5, player3, false)
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
        end

end

function PointSixth()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        local RetreatEntity = EGroup_GetSpawnedEntityAt(Retreat6, 1)
        local PointOne = EGroup_IsCapturedByPlayer(Point6, player1, false)
        local PointTwo = EGroup_IsCapturedByPlayer(Point6, player2, false)
        local PointThree = EGroup_IsCapturedByPlayer(Point6, player3, false)
        if PointOne == true or PointTwo == true or PointThree == true then
                Entity_SetPlayerOwner(RetreatEntity, player1)
        end

end

------------------------Upgrade--------------------------

function Upgrade()

        local player1 = World_GetPlayerAt(1)
        local player2 = World_GetPlayerAt(2)
        local player3 = World_GetPlayerAt(3)
        local player4 = World_GetPlayerAt(4)
        local player5 = World_GetPlayerAt(5)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)

end

-------------------------Resources---------------------------

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
				manpower = 800,
				fuel = 0,
				munition = 80,
				action = 0,
				command = 0,
			},
			--player 2:
			[1] = {
				manpower = 800,
				fuel = 0,
				munition = 80,
				action = 0,
				command = 0,
			},
			--player 3:
			[2] = {
				manpower = 800,
				fuel = 0,
				munition = 80,
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

function Sabotage_MissionStart()
	Util_StartIntel(EVENTS.Intro)
end

EVENTS = {}

        local Text = Util_CreateLocString("Halt! The Soviets are everywhere past this point.")
        local Text1 = Util_CreateLocString("The tactical assault force has landed and will be moving soon.")
        local Text2 = Util_CreateLocString("We should move now to meet them inside enemy territory.")
        local TextExtra1 = Util_CreateLocString("Once we grab the intelligence, the Luftwaffe should come to support us on our way out.")
        local TextExtra2 = Util_CreateLocString("But if we had a radio, we could call in more support from Airfield Four to provide more help.")
        local Text3 = Util_CreateLocString("Remember men, think before you shoot! Let's move out.")

        local Text4 = Util_CreateLocString("Okay we got the intelligence, Get to the extraction point! GO GO GO!")

        local Text6 = Util_CreateLocString("This is task force three... zero... six... calling Airfield Four. We require air assistance at co-ordinates five... one... seven...")
        local Text7 = Util_CreateLocString("Task force three zero six this is Airfield Four. We acknowledge that request and are en route to provide assistance.")
        local Text8 = Util_CreateLocString("Good! Now we will have additional air support during our run to the extraction point.")

        local Text9 = Util_CreateLocString("Um... this is not the intelligence we need, but apparently there is a house with a radio nearby.")
        local Text10 = Util_CreateLocString("If we occupy it we can call in more air support to help us when we run back to the extraction point.")

        local Text11 = Util_CreateLocString("Soviet targets at co-ordinates four... two... seven. Friendly airstrikes incoming... standby.")

        local Text12 = Util_CreateLocString("Soviet column at co-ordinates six... two... seven. Friendly airstrikes incoming... standby.")

        local Text13 = Util_CreateLocString("Enemy ISU on the main road. Commencing tactical aerial bombing... standby.")

        local Text14 = Util_CreateLocString("Soviet IS tank spotted. Too many friendlies near target. Providing non-lethal smoke cover... standby")

EVENTS.Intro = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text1)
        CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, TextExtra1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, TextExtra2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text3)
	CTRL.WAIT()

end

EVENTS.Intelligence = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text4)
        CTRL.WAIT()

end

EVENTS.Radar = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text8)
	CTRL.WAIT()

end

EVENTS.RadarIntelligence = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text10)
	CTRL.WAIT()

end

EVENTS.AirLeft = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text11)
	CTRL.WAIT()

end

EVENTS.AirRight = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text12)
	CTRL.WAIT()

end

EVENTS.AirISU = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text13)
	CTRL.WAIT()

end

EVENTS.AirIS = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, Text14)
	CTRL.WAIT()

end