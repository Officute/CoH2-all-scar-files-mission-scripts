-- This following code contained in this file is copyright to Mike D. Do not re-use without express permission from all copyright holders, this work is partially protected by the Digital Millenium Copyright Act (DCMA), U.S.C, Title 17.

import("ScarUtil.scar")

function OnGameSetup()

        player1 = World_GetPlayerAt(1)
        player2 = World_GetPlayerAt(2)
        player3 = World_GetPlayerAt(3)
        player4 = World_GetPlayerAt(4)
        player5 = World_GetPlayerAt(5)
        player6 = World_GetPlayerAt(6)
        player7 = World_GetPlayerAt(7)
        player8 = World_GetPlayerAt(8)
		
				
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

        Custom()
		
		Rule_AddDelayedInterval(SafeguardAI, 1, 1)
		
		Rule_AddDelayedInterval(HalftrackFailsafe, 10, 1)
		
		Rule_AddOneShot(PlayerAIOne, 140)
		Rule_AddOneShot(PlayerAITwo, 140)
		Rule_AddOneShot(PlayerAIThree, 140)
		
		Rule_AddOneShot(Cinematic, 3)
		
		Rule_AddDelayedInterval(FightEvents, 1, 1)
		
		Halftime()
		
		PointSight()
		
		MovingStuve()
		
		Rule_AddOneShot(DelayAI, 60)
		
		Lose()
		
        Elites()

        EliteNames()
		
		Rule_AddDelayedInterval(SchneiderWarp, 1, 1)
		Rule_AddDelayedInterval(OpelWarp, 1, 1)
		
		RecurringUnload()
		
		RecurringPlanes()
		
		Rescue()
		
		ManpowerArrival()
		
		SpawnControl()

        Upgrade()
	
        Abilities()

        BuildingRestrict()

end

Scar_AddInit(OnInit)

function Custom()

        AI_EnableAll(false)
        UI_SetAllowLoadAndSave(false)
		
		Camera_MoveTo(mkr_startcamera)
		
	    Player_SetPopCapOverride(player1, 200)
	    Player_SetPopCapOverride(player2, 200)
		Player_SetPopCapOverride(player3, 200)
		Player_SetPopCapOverride(player4, 900)
	    Player_SetPopCapOverride(player5, 900)
		Player_SetPopCapOverride(player6, 900)
		Player_SetPopCapOverride(player7, 900)
		Player_SetPopCapOverride(player8, 900)
		
		Command_SquadSquadLoad(player4, StartUnitOne, SCMD_InstantLoad, StartHalftrackOne, true, false)
		Command_SquadSquadLoad(player4, StartUnitTwo, SCMD_InstantLoad, StartHalftrackTwo, true, false)
		Command_SquadSquadLoad(player4, StartUnitThree, SCMD_InstantLoad, StartHalftrackThree, true, false)
		Command_SquadSquadLoad(player8, TruckLoadOne, SCMD_InstantLoad, LoadTruck, true, false)
		
		local Ammotext = Util_CreateLocString("Losing each munition point will increase enemy attacks. Enemy capture of all three munition points will result in mission failure!")
        AmmoHint1 = HintPoint_Add(mkr_ammotop, true, Ammotext)
		AmmoHint2 = HintPoint_Add(mkr_ammomid, true, Ammotext)
		AmmoHint3 = HintPoint_Add(mkr_ammobottom, true, Ammotext)
		
		local Enemytext = Util_CreateLocString("Capture strategic points to reduce the chance of enemy elite reinforcements appearing in this area")
        EnemyText1 = HintPoint_Add(mkr_enemyhint1, true, Enemytext)
		EnemyText2 = HintPoint_Add(mkr_enemyhint2, true, Enemytext)
		EnemyText3 = HintPoint_Add(mkr_enemyhint3, true, Enemytext)
		
		local PickupText = Util_CreateLocString("Rescue separated units elsewhere in the city by moving your units close to them. Rescue them before the enemy kills them")
        PickupHint = HintPoint_Add(mkr_pickuphint, true, PickupText)

		
		ObjBlip1 = UI_CreateMinimapBlip(AmmoOne, 9000, BT_ObjectivePrimary)
		ObjBlip2 = UI_CreateMinimapBlip(AmmoBase, 9000, BT_ObjectivePrimary)
		ObjBlip3 = UI_CreateMinimapBlip(AmmoTwo, 9000, BT_ObjectivePrimary)
		ObjBlip4 = UI_CreateMinimapBlip(AmmoThree, 9000, BT_ObjectivePrimary)
		
		Modify_UnitSpeed(StartOpel, 0.7)
		Modify_UnitSpeed(AttackThreeKV, 0.6)
		Modify_UnitSpeed(AttackFourFlameOne, 0.7)
		Modify_UnitSpeed(AttackFourFlameTwo, 0.7)
		Modify_UnitSpeed(AttackSixTwoThree, 0.7)
		Modify_UnitSpeed(AttackSixThreeThree, 0.6)
		
		FOW_RevealMarker(mkr_hospitalsight, 5)
		FOW_RevealMarker(mkr_repairsight, 5)
		
		local TextPoint = Util_CreateLocString("You can reinforce your units near Opel Blitz trucks. Opel Blitz trucks that arrive at your base will provide additional manpower.")
        HintExtra = HintPoint_Add(StartOpel, true, TextPoint)
	
end

function SafeguardAI()
	
	    AI_Enable(player4, false)
		AI_Enable(player8, false)

end

function HalftrackFailsafe()

		local Control = SGroup_Count(HalftrackControl)
		if Control == 1 then
		        Cmd_Move(StartHalftrackThree, mkr_startdrop3)
        end
end

function PlayerAIOne()
	
		local Control = AI_IsAIPlayer(player1)
		if Control == true then
		        AI_Enable(player1, true)
				AI_SetDifficulty(player1, AD_Hardest)
        end
end

function PlayerAITwo()
	
		local Control = AI_IsAIPlayer(player2)
		if Control == true then
		        AI_Enable(player2, true)
				AI_SetDifficulty(player2, AD_Hardest)
        end
end

function PlayerAIThree()
	
		local Control = AI_IsAIPlayer(player3)
		if Control == true then
		        AI_Enable(player3, true)
				AI_SetDifficulty(player3, AD_Hardest)
        end
end

function DelayAI()
	
	    AI_Enable(player5, true)
        AI_Enable(player6, true)
        AI_Enable(player7, true)

end

function SchneiderWarp()

		local Control = Prox_AreSquadMembersNearMarker(Schneider, mkr_schneiderto2, false)
		if Control == true then
		        SGroup_WarpToMarker(Schneider, mkr_schneiderwarpto)
				Rule_RemoveMe()
        end
end

function OpelWarp()
	
		local Control = Prox_AreSquadMembersNearMarker(StartOpel, mkr_friendlyspawn, false)
		if Control == true then
		        SGroup_WarpToMarker(StartOpel, mkr_instantmoveto2)
				HintPoint_Remove(HintExtra)
				Rule_RemoveMe()
        end
end

function Cinematic()

        Util_StartIntel(EVENTS.StartCinematic)

end


----------------------------------Fight Events------------------------------

function FightEvents()

        
	    local Control = SGroup_Count(GameSpawnControl)
        if Control == 0 then
                Rule_AddOneShot(BackupOne, 300)
		        Rule_AddOneShot(AssaultOne, 480)
				Rule_AddOneShot(BackupTwo, 600)
				Rule_AddOneShot(AssaultTwo, 720)
				Rule_AddOneShot(BackupThree, 940)
				Rule_AddOneShot(AssaultThree, 1060)
				Rule_AddOneShot(BackupFour, 1240)
				Rule_AddOneShot(AssaultFour, 1390)
				Rule_AddOneShot(BackupFive, 1600)
				Rule_AddOneShot(AssaultFive, 1840)
				Rule_AddOneShot(BackupSix, 2020)
				Rule_AddOneShot(AssaultSix, 2140)
				Rule_AddOneShot(AssaultSeven, 2320)
                Rule_RemoveMe()
        end
end


function BackupOne()

        Util_StartIntel(EVENTS.AllyOne)

end

function AssaultOne()

        Util_StartIntel(EVENTS.EnemyOne)

end

function BackupTwo()

        Util_StartIntel(EVENTS.AllyTwo)

end

function AssaultTwo()

        Util_StartIntel(EVENTS.EnemyTwo)

end

function BackupThree()

        Util_StartIntel(EVENTS.AllyThree)

end

function AssaultThree()

        Util_StartIntel(EVENTS.EnemyThree)

end

function BackupFour()

        Util_StartIntel(EVENTS.AllyFour)

end

function AssaultFour()

        Util_StartIntel(EVENTS.EnemyFour)

end

function BackupFive()

        Util_StartIntel(EVENTS.AllyFive)

end

function AssaultFive()

        Util_StartIntel(EVENTS.EnemyFive)

end

function BackupSix()

        Util_StartIntel(EVENTS.AllySix)

end

function AssaultSix()

        Util_StartIntel(EVENTS.EnemySix)

end

function AssaultSeven()

        Util_StartIntel(EVENTS.EnemySeven)

end


-----------------------------------Halftime----------------------------------

function Halftime()

        Rule_AddDelayedInterval(FieldStart, 1, 1)
		Rule_AddDelayedInterval(FieldTrigger, 1, 1)

end

function FieldStart()

		local Control = Prox_AreSquadsNearMarker(Omega, mkr_omegato, false)
        if Control == true then
		        Cmd_Move(SpecialAT, mkr_specialatto)
				Cmd_Move(SpecialMG, mkr_specialmgto)
				SGroup_SetPlayerOwner(Greyshot, player1)
	            SGroup_SetPlayerOwner(Ace, player2)
	            SGroup_SetPlayerOwner(Omega, player3)
				Rule_RemoveMe()
		end
end

function FieldTrigger()

		local Control1 = Prox_ArePlayersNearMarker(player1, mkr_fieldmovetrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_fieldmovetrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_fieldmovetrigger, false)
        if Control1 == true or Control2 == true or Control3 == true then
		        Cmd_Move(FieldKVOne, mkr_fieldkvoneto)
				Cmd_Move(FieldKVTwo, mkr_fieldkvtwoto)
				Rule_RemoveMe()
		end
end

-------------------------------Moving Stuve--------------------------------

function MovingStuve()

        Rule_AddDelayedInterval(StuveOne, 1, 1)
		Rule_AddDelayedInterval(StuveTwo, 1, 1)
		Rule_AddDelayedInterval(StuveThree, 1, 1)
		Rule_AddDelayedInterval(StuveFour, 1, 1)
		Rule_AddDelayedInterval(StuveFive, 1, 1)

end

function StuveOne()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuveto1, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuveto2)
        end
end

function StuveTwo()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuveto2, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuveto3)
        end
end

function StuveThree()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuveto3, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuveto4)
        end
end

function StuveFour()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuveto4, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuveto5)
        end
end

function StuveFive()

		local Control1 = Prox_AreSquadMembersNearMarker(Stuve, mkr_stuveto5, true)
		if Control1 == true then
                Cmd_Move(Stuve, mkr_stuveto1)
        end
end


-----------------------------------Ammo Points Sight------------------------------

function PointSight()

        Rule_AddDelayedInterval(SightOne, 1, 1)
		Rule_AddDelayedInterval(SightBase, 1, 1)
		Rule_AddDelayedInterval(SightTwo, 1, 1)
		Rule_AddDelayedInterval(SightThree, 1, 1)

end

function SightOne()


        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoOne, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoOne, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoOne, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoOne, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        FOW_RevealMarker(mkr_sight1, 9000)
		elseif PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
		        FOW_UnRevealMarker(mkr_sight1)
		end
end

function SightBase()


        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoBase, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoBase, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoBase, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoBase, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        FOW_RevealMarker(mkr_sightbase, 9000)
		elseif PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
		        FOW_UnRevealMarker(mkr_sightbase)
		end
end

function SightTwo()


        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoTwo, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoTwo, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoTwo, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoTwo, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        FOW_RevealMarker(mkr_sight2, 9000)
		elseif PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
		        FOW_UnRevealMarker(mkr_sight2)
		end
end

function SightThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoThree, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoThree, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoThree, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoThree, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        FOW_RevealMarker(mkr_sight3, 9000)
		elseif PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
		        FOW_UnRevealMarker(mkr_sight3)
		end
end



-----------------------------Recurring Unload---------------------------------

function RecurringUnload()

        Rule_AddDelayedInterval(UnloadOne, 1, 1)
		Rule_AddDelayedInterval(UnloadTwo, 1, 1)
		Rule_AddDelayedInterval(UnloadThree, 1, 1)
		Rule_AddDelayedInterval(InstantMove, 1, 1)
		
end

function UnloadOne()

		local Control1 = Prox_AreSquadMembersNearMarker(StartHalftrackOne, mkr_startdrop1, true)
		if Control1 == true then
                Util_StartIntel(EVENTS.DropOne)
                Rule_RemoveMe()
        end
end

function UnloadTwo()

		local Control1 = Prox_AreSquadMembersNearMarker(StartHalftrackTwo, mkr_startdrop2, true)
		if Control1 == true then
                Util_StartIntel(EVENTS.DropTwo)
                Rule_RemoveMe()
        end
end

function UnloadThree()

		local Control1 = Prox_AreSquadMembersNearMarker(StartHalftrackThree, mkr_startdrop3, true)
		if Control1 == true then
                Util_StartIntel(EVENTS.DropThree)
                Rule_RemoveMe()
        end
end

function InstantMove()

		local Control1 = Prox_AreSquadMembersNearMarker(StartHalftrackOne, mkr_friendlyspawn, true)
		local Control2 = Prox_AreSquadMembersNearMarker(StartHalftrackTwo, mkr_friendlyspawn, true)
		local Control3 = Prox_AreSquadMembersNearMarker(StartHalftrackThree, mkr_friendlyspawn, true)
		if Control1 == true or Control2 == true or Control3 == true then
		        SGroup_DestroyAllSquads(StartHalftrackOne)
				SGroup_DestroyAllSquads(StartHalftrackTwo)
				SGroup_DestroyAllSquads(StartHalftrackThree)
                Rule_RemoveMe()
        end
end


-----------------------------Recurring Planes---------------------------

function RecurringPlanes()

		Rule_AddDelayedInterval(PlaneSupport, 1, 120)
		Rule_AddDelayedInterval(PlaneBomb, 1, 170)

end

function PlaneSupport()

        local Control = SGroup_Count(PlaneControl)
		if Control == 0 then
		        local PlayerOne = Player_GetSquads(player1)
	     		local PlayerTwo = Player_GetSquads(player2)
	        	local PlayerThree = Player_GetSquads(player3)
				local CountOne = SGroup_Count(PlayerOne)
				local CountTwo = SGroup_Count(PlayerTwo)
				local CountThree = SGroup_Count(PlayerThree)
                if CountOne > 0 and CountTwo > 0 and CountThree > 0 then
        				local Random = World_GetRand(1, 3)
      		   		    if Random == 1 then
     		  		            local Target = Player_GetSquadConcentration(player1)
             		            Cmd_Ability(player8, ABILITY.SOVIET.IL_2_SUPPORT, Target, nil, true)
     		 		    elseif Random == 2 then
     		 		            local Target = Player_GetSquadConcentration(player2)
              		            Cmd_Ability(player8, ABILITY.SOVIET.IL_2_SUPPORT, Target, nil, true)
     		 		    elseif Random == 3 then
      		  		            local Target = Player_GetSquadConcentration(player3)
              		            Cmd_Ability(player8, ABILITY.SOVIET.IL_2_SUPPORT, Target, nil, true)
						end
                end
        end
end

function PlaneBomb()

        local Control = SGroup_Count(PlaneControl)
		if Control == 0 then
		        local PlayerOne = Player_GetSquads(player1)
	     		local PlayerTwo = Player_GetSquads(player2)
	        	local PlayerThree = Player_GetSquads(player3)
				local CountOne = SGroup_Count(PlayerOne)
				local CountTwo = SGroup_Count(PlayerTwo)
				local CountThree = SGroup_Count(PlayerThree)
                if CountOne > 0 and CountTwo > 0 and CountThree > 0 then
        		        local Random = World_GetRand(1, 3)
      		            if Random == 1 then
     		                    local Target = Player_GetSquadConcentration(player1)
                                Cmd_Ability(player8, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, nil, true)
     		            elseif Random == 2 then
     		                    local Target = Player_GetSquadConcentration(player2)
                                Cmd_Ability(player8, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, nil, true)
     		            elseif Random == 3 then
      		                    local Target = Player_GetSquadConcentration(player3)
                                Cmd_Ability(player8, ABILITY.SOVIET.IL_2_PRECISION_BOMB_STRIKE, Target, nil, true)
						end
                end
        end
end

----------------------------Rescue-------------------------------

function Rescue()

        Rule_AddDelayedInterval(BaseRescue, 1, 1)
		Rule_AddDelayedInterval(SideRescue, 1, 1)
		Rule_AddDelayedInterval(RiverRescue, 1, 1)
		Rule_AddDelayedInterval(EdgeRescue, 1, 1)
		Rule_AddDelayedInterval(RuinsRescue, 1, 1)
		
end

function BaseRescue()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_pickuphint, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_pickuphint, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_pickuphint, false)
		if Control1 == true or Control2 == true or Control3 == true then
                SGroup_SetPlayerOwner(BaseOne, player1)
				SGroup_SetPlayerOwner(BaseVolks, player1)
				SGroup_SetPlayerOwner(BaseTwo, player2)
				SGroup_SetPlayerOwner(BaseThree, player3)
                Rule_RemoveMe()
        end
end

function SideRescue()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_sidetrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_sidetrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_sidetrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                SGroup_SetPlayerOwner(SideOne, player1)
				SGroup_SetPlayerOwner(SideTwo, player2)
				SGroup_SetPlayerOwner(SideThree, player3)
                Rule_RemoveMe()
        end
end

function RiverRescue()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_rivertrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_rivertrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_rivertrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                SGroup_SetPlayerOwner(RiverOne, player1)
				SGroup_SetPlayerOwner(RiverTwo, player2)
				SGroup_SetPlayerOwner(RiverThree, player3)
                Rule_RemoveMe()
        end
end

function EdgeRescue()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_edgetrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_edgetrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_edgetrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                SGroup_SetPlayerOwner(EdgeOne, player1)
				SGroup_SetPlayerOwner(EdgeTwo, player2)
				SGroup_SetPlayerOwner(EdgeThree, player3)
                Rule_RemoveMe()
        end
end

function RuinsRescue()

        local Control1 = Prox_ArePlayersNearMarker(player1, mkr_ruinstrigger, false)
		local Control2 = Prox_ArePlayersNearMarker(player2, mkr_ruinstrigger, false)
		local Control3 = Prox_ArePlayersNearMarker(player3, mkr_ruinstrigger, false)
		if Control1 == true or Control2 == true or Control3 == true then
                SGroup_SetPlayerOwner(RuinsOne, player1)
				SGroup_SetPlayerOwner(RuinsTwo, player2)
				SGroup_SetPlayerOwner(RuinsThree, player3)
                Rule_RemoveMe()
        end
end

----------------------------Manpower Arrival-------------------------

function ManpowerArrival()

        Rule_AddDelayedInterval(ManpowerSpawn, 140, 180)
		Rule_AddDelayedInterval(ManpowerMoveOne, 1, 1)
		Rule_AddDelayedInterval(ManpowerMoveTwo, 1, 1)
		Rule_AddDelayedInterval(ManpowerMoveThree, 1, 1)
		Rule_AddDelayedInterval(ManpowerDespawn, 1, 1)
		
		Rule_AddDelayedInterval(ManpowerWarning, 1, 6)

end

function ManpowerSpawn()

        local Random = World_GetRand(1, 3)
        if Random == 1 then
                Util_CreateSquads(player4, ManpowerVehicle, SBP.WEST_GERMAN.OPEL_BLITZ_SQUAD_MP, mkr_manpowercarspawn)
                Cmd_Move(ManpowerVehicle, mkr_manpower1)
	        	local WarningText = Util_CreateLocString("Friendly truck carrying additional manpower is arriving from the north")
	            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	        	FOW_RevealSGroupOnly(ManpowerVehicle, 500)
	        	Modify_UnitSpeed(ManpowerVehicle, 0.6)
        elseif Random == 2 then
                Util_CreateSquads(player4, ManpowerVehicle, SBP.WEST_GERMAN.OPEL_BLITZ_SQUAD_MP, mkr_startpoint)
                Cmd_Move(ManpowerVehicle, mkr_manpower3)
	        	local WarningText = Util_CreateLocString("Friendly truck carrying additional manpower is arriving from the south")
	            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	        	FOW_RevealSGroupOnly(ManpowerVehicle, 500)
	        	Modify_UnitSpeed(ManpowerVehicle, 0.6)
		elseif Random == 3 then
                Util_CreateSquads(player4, ManpowerVehicle, SBP.WEST_GERMAN.OPEL_BLITZ_SQUAD_MP, mkr_startpoint)
                Cmd_Move(ManpowerVehicle, mkr_manpower3)
	        	local WarningText = Util_CreateLocString("Friendly truck carrying additional manpower is arriving from the south")
	            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
	        	FOW_RevealSGroupOnly(ManpowerVehicle, 500)
	        	Modify_UnitSpeed(ManpowerVehicle, 0.6)
        end
end

function ManpowerMoveOne()

		local Control = Prox_AreSquadMembersNearMarker(ManpowerVehicle, mkr_manpower1, false)
		if Control == true then
		        Cmd_Move(ManpowerVehicle, mkr_manpower2)
        end
end

function ManpowerMoveTwo()

		local Control = Prox_AreSquadMembersNearMarker(ManpowerVehicle, mkr_manpower2, false)
		if Control == true then
		        Cmd_Move(ManpowerVehicle, mkr_manpower3)
        end
end

function ManpowerMoveThree()

        local Control1 = SGroup_Count(ManpowerVehicle)
		if Control1 > 0 then
	        	local Control2 = Prox_AreSquadMembersNearMarker(ManpowerVehicle, mkr_manpower3, false)
		        if Control2 == true then
		                Cmd_Move(ManpowerVehicle, mkr_friendlyspawn)
			        	Player_AddResource(player1, RT_Manpower, 30)
			        	Player_AddResource(player2, RT_Manpower, 30)
			        	Player_AddResource(player3, RT_Manpower, 30)
			    end
        end
end

function ManpowerDespawn()

		local Control = Prox_AreSquadMembersNearMarker(ManpowerVehicle, mkr_friendlyspawn, true)
		if Control == true then
		        SGroup_DestroyAllSquads(ManpowerVehicle)
        end
end

function ManpowerWarning()

		local Control = Prox_AreSquadMembersNearMarker(ManpowerVehicle, mkr_manpower3, false)
		if Control == true then
		        local WarningText = Util_CreateLocString("Additional manpower has arrived")
	            Warning = WinWarning_ShowLoseWarning(WarningText, 2, 5, 2)
        end
end



----------------------------Spawn Control---------------------------

function SpawnControl()

        Rule_AddDelayedInterval(SpawnFive, 140, 140)

        Rule_AddDelayedInterval(SpawnSix, 140, 140)

        Rule_AddDelayedInterval(SpawnSeven, 140, 140)
		
		Rule_AddDelayedInterval(PointOne, 140, 200)
		
		Rule_AddDelayedInterval(PointTwo, 140, 205)
		
		Rule_AddDelayedInterval(PointThree, 140, 210)
		
		Rule_AddDelayedInterval(AmmoSpawnOne, 1, 140)
		
		Rule_AddDelayedInterval(AmmoSpawnTwo, 1, 140)
		
		Rule_AddDelayedInterval(AmmoSpawnThree, 1, 140)
		
		Rule_AddDelayedInterval(AmmoAllyOne, 1, 240)
		
		Rule_AddDelayedInterval(AmmoAllyBase, 1, 240)
		
		Rule_AddDelayedInterval(AmmoAllyTwo, 1, 240)
		
		Rule_AddDelayedInterval(AmmoAllyThree, 1, 240)

end

------------------------------Spawn Five-----------------------------

function SpawnFive()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 2 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 3 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 4 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 5 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 6 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 7 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 8 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 9 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 10 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 11 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 12 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 13 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 14 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 15 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 16 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 17 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 18 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 19 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.SU_76M_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 20 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)

        end
end

------------------------------Spawn Six-----------------------------

function SpawnSix()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 7 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 8 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 9 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 10 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 11 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 12 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 13 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 14 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 15 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 16 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 17 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 18 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 19 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 20 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)

        end
end

------------------------------Spawn Seven-----------------------------

function SpawnSeven()

        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.T_70M_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 5 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 6 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 7 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 8 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 9 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 10 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 11 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 12 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 13 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 14 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 15 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 16 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 17 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 18 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 19 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 20 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)

        end
end

function PointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point1, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point1, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point1, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(Point1, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
                local Random = World_GetRand(1, 10)
                if Random == 1 then
                        local Control = SGroup_Count(AlliesOne)
                        if Control == 0 then
                                Util_CreateSquads(player5, AlliesOne, SBP.SOVIET.SNIPER_TEAM_MP, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesOne)
                        end
                elseif Random == 2 then
                        local Control = SGroup_Count(AlliesTwo)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesTwo, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesTwo)
                        end
                elseif Random == 3 then
                        local Control = SGroup_Count(AlliesThree)
                        if Control == 0 then
					         	Util_CreateSquads(player5, AlliesThree, SBP.SOVIET.PENAL_BATTALION, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesThree)
                        end
                elseif Random == 4 then
                        local Control = SGroup_Count(AlliesFour)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesFour, SBP.SOVIET.PARTISANS_RIFLE_MP, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesFour)
                        end
                elseif Random == 5 then
                        local Control = SGroup_Count(AlliesFive)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesFive, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesFive)
                        end
                elseif Random == 6 then
                        local Control = SGroup_Count(AlliesSix)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesSix, SBP.SOVIET.PARTISANS_PTRS_MP, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesSix)
                        end
                elseif Random == 7 then
                        local Control = SGroup_Count(AlliesSeven)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesSeven, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesSeven)
                        end
                elseif Random == 8 then
                        local Control = SGroup_Count(AlliesEight)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesEight, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesEight)
                        end
                elseif Random == 9 then
                        local Control = SGroup_Count(AlliesNine)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesNine, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesNine)
                        end
                elseif Random == 10 then
                        local Control = SGroup_Count(AlliesTen)
                        if Control == 0 then
						        Util_CreateSquads(player5, AlliesTen, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn1)
                                Util_StartIntel(EVENTS.EliteAlliesTen)
					    end
                end
        end
end

function PointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point2, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point2, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point2, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(Point2, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
                local Random = World_GetRand(1, 10)
                if Random == 1 then
                        local Control = SGroup_Count(AlliesOne)
                        if Control == 0 then
                                Util_CreateSquads(player6, AlliesOne, SBP.SOVIET.SNIPER_TEAM_MP, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesOne)
                        end
                elseif Random == 2 then
                        local Control = SGroup_Count(AlliesTwo)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesTwo, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesTwo)
                        end
                elseif Random == 3 then
                        local Control = SGroup_Count(AlliesThree)
                        if Control == 0 then
					         	Util_CreateSquads(player6, AlliesThree, SBP.SOVIET.PENAL_BATTALION, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesThree)
                        end
                elseif Random == 4 then
                        local Control = SGroup_Count(AlliesFour)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesFour, SBP.SOVIET.PARTISANS_RIFLE_MP, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesFour)
                        end
                elseif Random == 5 then
                        local Control = SGroup_Count(AlliesFive)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesFive, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesFive)
                        end
                elseif Random == 6 then
                        local Control = SGroup_Count(AlliesSix)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesSix, SBP.SOVIET.PARTISANS_PTRS_MP, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesSix)
                        end
                elseif Random == 7 then
                        local Control = SGroup_Count(AlliesSeven)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesSeven, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesSeven)
                        end
                elseif Random == 8 then
                        local Control = SGroup_Count(AlliesEight)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesEight, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesEight)
                        end
                elseif Random == 9 then
                        local Control = SGroup_Count(AlliesNine)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesNine, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesNine)
                        end
                elseif Random == 10 then
                        local Control = SGroup_Count(AlliesTen)
                        if Control == 0 then
						        Util_CreateSquads(player6, AlliesTen, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn2)
                                Util_StartIntel(EVENTS.EliteAlliesTen)
					    end
                end
        end
end

function PointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(Point3, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(Point3, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(Point3, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(Point3, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
                local Random = World_GetRand(1, 10)
                if Random == 1 then
                        local Control = SGroup_Count(AlliesOne)
                        if Control == 0 then
                                Util_CreateSquads(player7, AlliesOne, SBP.SOVIET.SNIPER_TEAM_MP, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesOne)
                        end
                elseif Random == 2 then
                        local Control = SGroup_Count(AlliesTwo)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesTwo, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesTwo)
                        end
                elseif Random == 3 then
                        local Control = SGroup_Count(AlliesThree)
                        if Control == 0 then
					         	Util_CreateSquads(player7, AlliesThree, SBP.SOVIET.PENAL_BATTALION, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesThree)
                        end
                elseif Random == 4 then
                        local Control = SGroup_Count(AlliesFour)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesFour, SBP.SOVIET.PARTISANS_RIFLE_MP, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesFour)
                        end
                elseif Random == 5 then
                        local Control = SGroup_Count(AlliesFive)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesFive, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesFive)
                        end
                elseif Random == 6 then
                        local Control = SGroup_Count(AlliesSix)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesSix, SBP.SOVIET.PARTISANS_PTRS_MP, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesSix)
                        end
                elseif Random == 7 then
                        local Control = SGroup_Count(AlliesSeven)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesSeven, SBP.SOVIET.CONSCRIPT_SQUAD, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesSeven)
                        end
                elseif Random == 8 then
                        local Control = SGroup_Count(AlliesEight)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesEight, SBP.SOVIET.SOVIET_OFFICER_SQUAD, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesEight)
                        end
                elseif Random == 9 then
                        local Control = SGroup_Count(AlliesNine)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesNine, SBP.SOVIET.GUARDS_TROOPS, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesNine)
                        end
                elseif Random == 10 then
                        local Control = SGroup_Count(AlliesTen)
                        if Control == 0 then
						        Util_CreateSquads(player7, AlliesTen, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_enemyspawn3)
                                Util_StartIntel(EVENTS.EliteAlliesTen)
					    end
                end
        end
end

function AmmoSpawnOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoOne, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoOne, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoOne, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoOne, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 2 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 3 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.T_34_76_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 4 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 5 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 6 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 7 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 8 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 9 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 10 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 11 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 12 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 13 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 14 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 15 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 16 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 17 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 18 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 19 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
        elseif Random == 20 then
                Util_CreateSquads(player5, GroupFive, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn5)
				Util_StartIntel(EVENTS.ToFive)
                end
        end
end

function AmmoSpawnTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoTwo, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoTwo, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoTwo, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoTwo, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 2 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 3 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.T_70M_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 4 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 5 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 6 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 7 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 8 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 9 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 10 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 11 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 12 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 13 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 14 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 15 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 16 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 17 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 18 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 19 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
        elseif Random == 20 then
                Util_CreateSquads(player6, GroupSix, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn6)
				Util_StartIntel(EVENTS.ToSix)
                end
        end
end

function AmmoSpawnThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoThree, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoThree, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoThree, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoThree, player4, false)
        if PointFocus1 == false or PointFocus2 == false or PointFocus3 == false or PointFocus4 == false then
        local Random = World_GetRand(1, 20)
        if Random == 1 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 2 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.CONSCRIPT_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 3 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.SU_76M_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 4 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 5 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 6 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.PENAL_BATTALION_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 7 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 8 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 9 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 10 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 11 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 12 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMBAT_ENGINEER_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 13 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 14 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M5_HALFTRACK_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 15 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 16 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 17 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 18 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.COMMISSAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 19 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
        elseif Random == 20 then
                Util_CreateSquads(player7, GroupSeven, SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD_MP, mkr_spawn7)
				Util_StartIntel(EVENTS.ToSeven)
                end
        end
end

function AmmoAllyOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoOne, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoOne, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoOne, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoOne, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
                local Control1 = SGroup_Count(AmmoOneOne)
				local Control2 = SGroup_Count(AmmoOneTwo)
				if Control1 == 0 and Control2 == 0 then
				        Util_CreateSquads(player4, AmmoOneOne, SBP.GERMAN.PANZER_GRENADIER_SQUAD_MP, mkr_allyspawn)
						Util_CreateSquads(player4, AmmoOneTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_allyspawn)
						Cmd_Move(AmmoOneOne, mkr_ammoone1)
						Cmd_Move(AmmoOneTwo, mkr_ammoone2)
                end
        end
end

function AmmoAllyBase()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoBase, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoBase, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoBase, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoBase, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
                local Control1 = SGroup_Count(AmmoBaseOne)
				local Control2 = SGroup_Count(AmmoBaseTwo)
				if Control1 == 0 and Control2 == 0 then
				        Util_CreateSquads(player4, AmmoBaseOne, SBP.WEST_GERMAN.FALLSCHIRMJAGER_SQUAD_MP, mkr_allyspawn)
						Util_CreateSquads(player4, AmmoBaseTwo, SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP, mkr_allyspawn)
						Cmd_Move(AmmoBaseOne, mkr_ammobase1)
						Cmd_Move(AmmoBaseTwo, mkr_ammobase2)
                end
        end
end

function AmmoAllyTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoTwo, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoTwo, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoTwo, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoTwo, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
                local Control1 = SGroup_Count(AmmoTwoOne)
				local Control2 = SGroup_Count(AmmoTwoTwo)
				if Control1 == 0 and Control2 == 0 then
				        Util_CreateSquads(player4, AmmoTwoOne, SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP, mkr_allyspawn)
						Util_CreateSquads(player4, AmmoTwoTwo, SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP, mkr_allyspawn)
						Cmd_Move(AmmoTwoOne, mkr_ammotwo1)
						Cmd_Move(AmmoTwoTwo, mkr_ammotwo2)
                end
        end
end

function AmmoAllyThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoThree, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoThree, player2, false)
		local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoThree, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoThree, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
                local Control1 = SGroup_Count(AmmoThreeOne)
				local Control2 = SGroup_Count(AmmoThreeTwo)
				if Control1 == 0 and Control2 == 0 then
				        Util_CreateSquads(player4, AmmoThreeOne, SBP.GERMAN.ASSAULT_GRENADIER_SQUAD_MP, mkr_allyspawn)
						Util_CreateSquads(player4, AmmoThreeTwo, SBP.GERMAN.GRENADIER_SQUAD_MP, mkr_allyspawn)
						Cmd_Move(AmmoThreeOne, mkr_ammothree1)
						Cmd_Move(AmmoThreeTwo, mkr_ammothree2)
                end
        end
end



------------------------------Elites----------------------------

function Elites()

        Modify_ReceivedDamage(VonAsten, 0.5)
        Modify_ReceivedAccuracy(VonAsten, 0.5)
		Modify_ReceivedDamage(Stormless, 0.5)
        Modify_ReceivedAccuracy(Stormless, 0.5)
		Modify_ReceivedDamage(Gentlemen, 0.5)
        Modify_ReceivedAccuracy(Gentlemen, 0.5)
		Modify_ReceivedDamage(Propaganda, 0.5)
        Modify_ReceivedAccuracy(Propaganda, 0.5)
		Modify_ReceivedDamage(Imperial, 0.5)
        Modify_ReceivedAccuracy(Imperial, 0.5)
		Modify_ReceivedDamage(Greyshot, 0.4)
        Modify_ReceivedAccuracy(Greyshot, 0.4)
		Modify_ReceivedDamage(Ace, 0.5)
        Modify_ReceivedAccuracy(Ace, 0.5)
		Modify_ReceivedDamage(Omega, 0.6)
        Modify_ReceivedAccuracy(Omega, 0.6)
		
		
		Modify_ReceivedDamage(AttackFourElite, 0.7)
        Modify_ReceivedAccuracy(AttackFourElite, 0.7)
		Modify_ReceivedDamage(AttackFiveOneThree, 0.5)
        Modify_ReceivedAccuracy(AttackFiveOneThree, 0.5)
		Modify_ReceivedDamage(AttackFiveTwoThree, 0.5)
        Modify_ReceivedAccuracy(AttackFiveTwoThree, 0.5)
		Modify_ReceivedDamage(AttackSixTwoThree, 0.7)
        Modify_ReceivedAccuracy(AttackSixTwoThree, 0.7)
		Modify_ReceivedDamage(Stuve, 0.2)
        Modify_ReceivedAccuracy(Stuve, 0.2)
		
end

function EliteNames()

        local EliteName1 = Util_CreateLocString("Hermann 'Von Asten' Carius")
        HintMouseover_Add(EliteName1, VonAsten, 5, true)
        SGroup_IncreaseVeterancyRank(VonAsten, 3, false)
		local EliteName2 = Util_CreateLocString("Arnold 'Stormless' Franz")
        HintMouseover_Add(EliteName2, Stormless, 5, true)
        SGroup_IncreaseVeterancyRank(Stormless, 3, false)
		local EliteName3 = Util_CreateLocString("Hans 'Helping Hans' Hoffman")
        HintMouseover_Add(EliteName3, Gentlemen, 5, true)
        SGroup_IncreaseVeterancyRank(Gentlemen, 3, false)
		local EliteName4 = Util_CreateLocString("Walter 'Propaganda' Cast")
        HintMouseover_Add(EliteName4, Propaganda, 5, true)
        SGroup_IncreaseVeterancyRank(Propaganda, 3, false)
		local EliteName5 = Util_CreateLocString("Rolf 'Imperial' Dane")
        HintMouseover_Add(EliteName5, Imperial, 5, true)
        SGroup_IncreaseVeterancyRank(Imperial, 3, false)
		local EliteName6 = Util_CreateLocString("Honorary Guards Rifles")
        HintMouseover_Add(EliteName6, AttackFourElite, 5, true)
        SGroup_IncreaseVeterancyRank(AttackFourElite, 2, false)
		local EliteName7 = Util_CreateLocString("Axel 'Greyshot' Busch")
        HintMouseover_Add(EliteName7, Greyshot, 5, true)
        SGroup_IncreaseVeterancyRank(Greyshot, 5, false)
		local EliteName8 = Util_CreateLocString("Siegfried 'Ace' Schock")
        HintMouseover_Add(EliteName8, Ace, 5, true)
        SGroup_IncreaseVeterancyRank(Ace, 3, false)
		local EliteName9 = Util_CreateLocString("Wolfgang 'Omega' Schmidt")
        HintMouseover_Add(EliteName9, Omega, 5, true)
        SGroup_IncreaseVeterancyRank(Omega, 5, false)
		local EliteName10 = Util_CreateLocString("Ivan 'Von Ivan' Karpov")
        HintMouseover_Add(EliteName10, AttackFiveOneThree, 5, true)
        SGroup_IncreaseVeterancyRank(AttackFiveOneThree, 3, false)
		local EliteName11 = Util_CreateLocString("Pavel 'Talisman' Gusarov")
        HintMouseover_Add(EliteName11, AttackFiveTwoThree, 5, true)
        SGroup_IncreaseVeterancyRank(AttackFiveTwoThree, 3, false)
		local EliteName12 = Util_CreateLocString("Sergei 'Jeoyg 240' Petrov")
        HintMouseover_Add(EliteName12, AttackSixTwoThree, 5, true)
        SGroup_IncreaseVeterancyRank(AttackSixTwoThree, 3, false)
		local EliteName13 = Util_CreateLocString("Reinforced 'Stuve' Raid Halftrack")
        HintMouseover_Add(EliteName13, Stuve, 5, true)
        SGroup_IncreaseVeterancyRank(Stuve, 3, false)


end
------------------------------Upgrades-----------------------------

function Upgrade()

        local Entity1 = EGroup_GetSpawnedEntityAt(FlakBuilding, 1)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.BUILDING_1)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.BUILDING_2)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.BUILDING_3)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.PANZER_AUTHORIZATION_UPGRADE_MP)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.FLAK_PANZER_DEFENSIVES)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.FLAK_PANZER_IS_SETUP)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.FIRST_SWS_HALFTRACK_LOCKOUT)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.SWS_INTERVAL_UNLOCK)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.SWS_STARTING_DISPATCH_UNLOCK)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.CONSTRUCT_BASE_BUILDING_UPGRADE)
		Entity_CompleteUpgrade(Entity1, UPG.WEST_GERMAN.CALL_SWS_UPGRADE)

        local ControlEntity1 = SGroup_GetSpawnedSquadAt(BaseVolks, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity2 = SGroup_GetSpawnedSquadAt(HelpOneTwo, 1)
        Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity2, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity3 = SGroup_GetSpawnedSquadAt(HelpOneThree, 1)
        Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.PANZERSHRECK_MP)
		Squad_GiveSlotItem(ControlEntity3, SLOT_ITEM.PANZERSHRECK_MP)
		local ControlEntity4 = SGroup_GetSpawnedSquadAt(Stuve, 1)
        Squad_CompleteUpgrade(ControlEntity4, BP_GetUpgradeBlueprint("m5_halftrack_72k_aa_gun_package_mp"))

		
		
		
		
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_resources"))
		Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("air_drop_weapon_resupply"))
        Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_munitions"))
		Player_AddAbility(player4, BP_GetAbilityBlueprint("air_dropped_supplies"))
		
		Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
		
		Player_SetUpgradeAvailability(player1, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player2, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		Player_SetUpgradeAvailability(player3, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)
		
		Player_SetUpgradeAvailability(player3, UPG.AEF.FIGHTING_POSITION_MG_ADDITION_MP, ITEM_REMOVED)

        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player1, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player1, BP_GetUpgradeBlueprint("volk_fire_grenade"))
		
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player2, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player2, BP_GetUpgradeBlueprint("volk_fire_grenade"))
		
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)

        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_2_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("battle_phase_3_mp"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_1"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_2"))
        Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("building_3"))
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
        Player_SetAbilityAvailability(player3, ABILITY.GERMAN.GRENADIER_RIFLE_GRENADE_ABILITY_MP, ITEM_UNLOCKED)
		
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("sws_interval_unlock"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("ability_lock_out_sws_truck"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("first_sws_halftrack_lockout"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("call_sws_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("construct_base_building_upgrade"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("sws_starting_dispatch_unlock"))
		Player_CompleteUpgrade(player3, BP_GetUpgradeBlueprint("volk_fire_grenade"))
		
		Player_SetUpgradeAvailability(player3, UPG.WEST_GERMAN.VOLKS_STG44_UPGRADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player3, UPG.WEST_GERMAN.VOLK_FIRE_GRENADE, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player3, UPG.WEST_GERMAN.VOLKS_FLAMETHROWER_MP, ITEM_UNLOCKED)
		Player_SetUpgradeAvailability(player3, UPG.WEST_GERMAN.VOLKS_CQC_UPGRADE, ITEM_UNLOCKED)

        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player1, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)

        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.PIONEER_VOLKS_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetAbilityAvailability(player2, ABILITY.WEST_GERMAN.ASSAULT_PIONEER_DROP_MEDPACK_ABILITY_MP, ITEM_REMOVED)

        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_1_SCHREK_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_THIRD_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.GERMAN.GRENADIER_MG42_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.WAFFEN_INFRARED_STG44, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_REPAIR_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_PANZERSCHRECK_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player1, UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE, ITEM_REMOVED)

        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_1_SCHREK_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_SECOND_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.PANZER_GRENADIER_PANZERSHRECK_ATW_ITEM_THIRD_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.GRENADIER_MG42_LMG, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.GERMAN.GRENADIER_MG42_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.WAFFEN_INFRARED_STG44, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.MG34_DISPATCH, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.THROUGH_SALVAGE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.PANZERSCHRECK_UNLOCKED, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.WAFFEN_MG34_LMG_MP, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_REPAIR_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_PANZERSCHRECK_UPGRADE, ITEM_REMOVED)
        Player_SetUpgradeAvailability(player2, UPG.WEST_GERMAN.ASSAULT_PIONEER_COMBAT_UPGRADE, ITEM_REMOVED)
		

end

function Abilities()

        Player_AddAbility(player4, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player4, BP_GetUpgradeBlueprint("flare_artillery"))

        Player_AddAbility(player6, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("il-2_bomb_Strike"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("light_support_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("light_artillery_support"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("fire_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("fire_artillery"))
        Player_AddAbility(player6, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player6, BP_GetUpgradeBlueprint("time_on_target_artillery"))

        Player_AddAbility(player5, BP_GetAbilityBlueprint("flare_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("flare_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("time_on_target_artillery"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("time_on_target_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("recon_sweep"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("p47_rocket_attack"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("p47_rocket_attack"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_quick_recon_run"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_quick_recon_run_improved"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("recon_sweep"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("paratroopers_paradrop"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("paratroopers"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("glider_headquarters"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_custom_loadout_launch_available"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_hard_landed"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("ability_lock_out_glider_not_stopped"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("major_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("pack_howitzer_white_phosphorous_barrage_ability_mp"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_smoke_barrage"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("off_map_smoke_artillery"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("artillery_white_phosphorous"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_bombing_run_upgrade"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_bombing_strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_flame_strike"))

        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_fragmentation_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_fragmentation_bomb"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_close_air_support"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_close_air_support"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_smoke_bomb"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_smoke_bomb"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_flame_strike"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_incendiary_bombs"))
        Player_CompleteUpgrade(player5, BP_GetUpgradeBlueprint("stuka_strafe"))
        Player_AddAbility(player5, BP_GetAbilityBlueprint("stuka_strafing_run"))
		
		
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_sturmovik_attack"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_sturmovik_attack"))
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_support"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_support"))
		Player_AddAbility(player8, BP_GetAbilityBlueprint("il-2_precision_bomb_strike"))
		Player_CompleteUpgrade(player8, BP_GetUpgradeBlueprint("il-2_bomb_strike"))
		
end

function BuildingRestrict()

        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player1, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)

        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player2, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player3, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
		
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.BUNKER_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SLIT_TRENCH_GERMAN_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.GERMAN.SLIT_TRENCH_GERMAN, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WG_SANDBAG_FENCE_MP, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_02, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WEST_GERMAN_COMMAND_POST_SANDBAG_01, ITEM_REMOVED)
        Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.REINFORCED_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.BUNKER_WESTGERMAN_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.WEST_GERMAN.WG_BARBED_WIRE_FENCE_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.GERMAN_SANDBAG_FENCE, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.GERMAN_SANDBAG_FENCE_CMD_MP, ITEM_REMOVED)
		Player_SetEntityProductionAvailability(player4, EBP.GERMAN.TANK_TRAP, ITEM_REMOVED)
end



---------------------------------Lose----------------------------

function Lose()

        Rule_AddDelayedInterval(AllyPointOne, 1, 1)
		Rule_AddDelayedInterval(AllyPointTwo, 1, 1)
		Rule_AddDelayedInterval(AllyPointThree, 1, 1)
		
		Rule_AddDelayedInterval(EnemyPointOne, 1, 1)
		Rule_AddDelayedInterval(EnemyPointTwo, 1, 1)
		Rule_AddDelayedInterval(EnemyPointThree, 1, 1)

        Rule_AddDelayedInterval(PointsLose, 1, 1)

end

function AllyPointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoOne, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoOne, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoOne, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoOne, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseOne)
		        if Control == 0 then
				        Util_CreateSquads(player8, LoseOne, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_losespawn)
				end
		end
end

function AllyPointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoTwo, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoTwo, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoTwo, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoTwo, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseTwo)
		        if Control == 0 then
				        Util_CreateSquads(player8, LoseTwo, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_losespawn)
				end
		end
end

function AllyPointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoThree, player1, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoThree, player2, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoThree, player3, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoThree, player4, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseThree)
		        if Control == 0 then
				        Util_CreateSquads(player8, LoseThree, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_losespawn)
				end
		end
end


function EnemyPointOne()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoOne, player5, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoOne, player6, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoOne, player7, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoOne, player8, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseOne)
		        if Control == 1 then
				        SGroup_Kill(LoseOne)
				end
		end
end

function EnemyPointTwo()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoTwo, player5, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoTwo, player6, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoTwo, player7, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoTwo, player8, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseTwo)
		        if Control == 1 then
				        SGroup_Kill(LoseTwo)
				end
		end
end

function EnemyPointThree()

        local PointFocus1 = EGroup_IsCapturedByPlayer(AmmoThree, player5, false)
        local PointFocus2 = EGroup_IsCapturedByPlayer(AmmoThree, player6, false)
        local PointFocus3 = EGroup_IsCapturedByPlayer(AmmoThree, player7, false)
		local PointFocus4 = EGroup_IsCapturedByPlayer(AmmoThree, player8, false)
        if PointFocus1 == true or PointFocus2 == true or PointFocus3 == true or PointFocus4 == true then
		        local Control = SGroup_Count(LoseThree)
		        if Control == 1 then
				        SGroup_Kill(LoseThree)
				end
		end
end

function PointsLose()

        local PointFocus1 = SGroup_Count(LoseOne)
        local PointFocus2 = SGroup_Count(LoseTwo)
        local PointFocus3 = SGroup_Count(LoseThree)
        if PointFocus1 == 0 and PointFocus2 == 0 and PointFocus3 == 0 then
                World_SetPlayerLose(player1)
                World_SetPlayerLose(player2)
                World_SetPlayerLose(player3)
				World_SetPlayerLose(player4)
        end
end


------------------------------Events and Actors--------------------


EXTRA = {}

EXTRA.AEF = {
	PHOSPHOROUS_STRIKE = BP_GetAbilityBlueprint("artillery_strike_white_phosphorous"),
}

--? @enum EXTRA.AEF
--? EXTRA.AEF.PHOSPHOROUS_STRIKE



ACTOR = {
	
	__scardoc_enum = true,

	None					= "",

        Friedrich = "Icons_portraits_unit_german_panzer_grenadiers_w_portrait",
        Walter = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Fritz = "Icons_portraits_unit_west_german_fallschirmjager_w_portrait",
        Jozef = "Icons_portraits_unit_west_german_assault_pioneer_w_portrait",
        Hans = "Icons_portraits_unit_west_german_honor_guard_w_portrait",
        Assailant = "Icons_portraits_unit_german_grenadiers_w_portrait",
        Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
        Simmons = "Icons_portraits_unit_aef_captain_w_portrait",
        Winter = "Icons_portraits_unit_british_officer_w_portrait",
		Tomislav = "Icons_portraits_unit_west_german_volksgrenadier_w_portrait",
        Protector = "Icons_portraits_unit_aef_rear_echelon_w_portrait",

	-- Generic Russians
	Russian_Commissar		= "Icons_portraits_dialogue_soviet_commissar_s_portrait",
	Russian_Junior_Officer	= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait", -- Poznan_01 looks junior. No unique art for "junior officer".
	Russian_Senior_Officer	= "Icons_portraits_dialogue_soviet_senior_officer_s_portrait",
	Russian_Radio_Command	= "Icons_portraits_dialogue_soviet_command_radio_s_portrait",
	
	Russian_Soldier_01		= "Icons_portraits_dialogue_soviet_soldier_01_s_portrait",
	Russian_Soldier_02		= "Icons_portraits_dialogue_soviet_soldier_02_s_portrait",
	Russian_Soldier_03		= "Icons_portraits_dialogue_soviet_soldier_03_s_portrait",
	Russian_Soldier_04		= "Icons_portraits_dialogue_soviet_soldier_04_s_portrait",
	Russian_Soldier_05		= "Icons_portraits_dialogue_soviet_soldier_05_s_portrait",
	Russian_Soldier_06		= "Icons_portraits_dialogue_soviet_soldier_06_s_portrait",
	Russian_Soldier_07		= "Icons_portraits_dialogue_soviet_soldier_07_s_portrait",
	
	Russian_Sniper			= "Icons_portraits_dialogue_soviet_sniper_s_portrait",
	
	Russian_Engineer		= "Icons_portraits_dialogue_soviet_engineer_s_portrait",
	
	Russian_Tank_Commander	= "Icons_portraits_dialogue_soviet_tank_commander_s_portrait",
	Russian_Tank_Gunner		= "Icons_portraits_dialogue_soviet_tank_gunner_s_portrait",
	Russian_Tank_Officer	= "Icons_portraits_dialogue_soviet_tank_officer_s_portrait",
	
	Civilian				= "Icons_portraits_dialogue_civilian_s_portrait",
	Civilian_Female			= "Icons_portraits_dialogue_civilian_female_s_portrait",
	
	Partisans				= "Icons_portraits_dialogue_partisan_male_s_portrait",
	Partisans_Female 		= "Icons_portraits_dialogue_partisan_female_s_portrait",
	
	-- CoH2 Campaign
	Ania					= "Icons_portraits_dialogue_ania_s_portrait",
	Churkin					= "Icons_portraits_dialogue_churkin_s_portrait",
	Isakovich				= "Icons_portraits_dialogue_isakovich_s_portrait",
	Polivanov				= "Icons_portraits_dialogue_major_polivanov_s_portrait",
	Pozharsky				= "Icons_portraits_dialogue_pozharski_s_portrait",
	Yuri					= "Icons_portraits_dialogue_yuri_s_portrait",
	
	Poznan_Officer_01		= "Icons_portraits_dialogue_soviet_poznan_officer_01_w_portrait",
	Poznan_Officer_02		= "Icons_portraits_dialogue_soviet_poznan_officer_02_w_portrait",
	
	-- Generic Germans
	German_Officer			= "Icons_portraits_dialogue_german_officer_s_portrait",
	German_Ostruppen		= "Icons_portraits_dialogue_german_ostruppen_s_portrait",
	German_Grenadier		= "Icons_portraits_dialogue_german_grenadier_s_portrait",
	German_Panzer_Grenadier	= "Icons_portraits_dialogue_german_panzer_grenadier_s_portrait",
	German_Artillery		= "Icons_portraits_dialogue_german_artillery_officer_s_portrait",
	
	-- CoH2 XP1
	Derby					= {nameID = 11077130, icon = "Icons_bob_companies_dialog_support"},					-- Dog Company – Support
	Vastano					= {nameID = 11077122, icon = "Icons_bob_companies_dialog_airborne"},				-- Able Company - Airborne
	Edwards					= {nameID = 11077126, icon = "Icons_bob_companies_dialog_infantry"},				-- Baker Company - Mechanized
	Durante					= {nameID = 11081058, icon = "Icons_bob_companies_dialog_ranger"},					-- Fox Company - Ranger
	Jackson					= {nameID = 11077132, icon = "Icons_portraits_dialogue_aef_captain_w_portrait"},	-- the commander in the intro mission, temp since we have no jackson portrait
	
	Ouren_112th 			= {nameID = 11080987, icon = ""},	
	Houffalize_1st 			= {nameID = 11080988, icon = ""},	
	
	-- Generic Americans
	American_Riflemen_01	= "Icons_portraits_dialogue_aef_rifleman_w_portrait",
	American_Engineer_01	= "Icons_portraits_dialogue_aef_assault_engineer_w_portrait",
	American_Paratrooper_01	= "Icons_portraits_dialogue_aef_paratrooper_w_portrait", -- temp
	
	American_Lieutenant_01	= "Icons_portraits_dialogue_aef_lieutenant_w_portrait",
	American_Captain_01		= "Icons_portraits_dialogue_aef_captain_w_portrait",
	American_Major_01		= "Icons_portraits_dialogue_aef_major_w_portrait",
}






























--------------------------------Resources----------------------------------

function Resources()

Modify_PlayerResourceRate(player1, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player1, RT_Munition, 0.4, MUT_Multiplication)
Modify_PlayerResourceRate(player1, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player2, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Munition, 0.4, MUT_Multiplication)
Modify_PlayerResourceRate(player2, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player3, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Munition, 0.4, MUT_Multiplication)
Modify_PlayerResourceRate(player3, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player4, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player4, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player5, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player5, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player6, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player6, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player7, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Munition, 0.2, MUT_Multiplication)
Modify_PlayerResourceRate(player7, RT_Manpower, 0, MUT_Multiplication)

Modify_PlayerResourceRate(player8, RT_Fuel, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Munition, 0, MUT_Multiplication)
Modify_PlayerResourceRate(player8, RT_Manpower, 0, MUT_Multiplication)

end

Scar_AddInit(Resources)

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
			[4] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[5] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[6] = {
				manpower = 400,
				fuel = 15,
				munition = 0,
				action = 0,
				command = 1,
			},
			[7] = {
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
				manpower = 200,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 2:
			[1] = {
				manpower = 200,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			--player 3:
			[2] = {
				manpower = 200,
				fuel = 0,
				munition = 0,
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
			[4] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[5] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[6] = {
				manpower = 0,
				fuel = 0,
				munition = 0,
				action = 0,
				command = 0,
			},
			[7] = {
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
	elseif racename == World_GetPlayerAt(7) then
		return 6
	elseif racename == World_GetPlayerAt(8) then
		return 7
	end
end

Scar_AddInit(CustomStartingResources_Init)


EVENTS = {}

        local Text1 = Util_CreateLocString("Get ready men. We're arriving at Strongpoint Bismarck. This is going to be a really quick drop off.")
        local Text2 = Util_CreateLocString("Get out! Get out! We are needed back at Strongpoint Von Strauss. Good luck to you and Commander Schneider.")
		local Text3 = Util_CreateLocString("Men! Welcome to the last streets of Berlin! We appreciate your companionship in this rather... difficult time!")
		local Text4 = Util_CreateLocString("Our objective is to hold three critical ammunition points in the surrounding streets to provide time for civilians to escape. It's all we can do for them now.")
		local Text5 = Util_CreateLocString("If we can hold at least one of these ammunition points, the enemy will not be able to fully secure these vital streets, which means Strongpoint Bismarck will stand!")
		local Text6 = Util_CreateLocString("If we lose all of these ammunition points, then civilians will be cut off from their escape route. We cannot let that happen!")
		local Text7 = Util_CreateLocString("Remember men! We are the Wehrmacht! For our honor and for our people, let us place one final act of sacrifice!")
		local Text8 = Util_CreateLocString("Rolf, Walter, Hans! This truck needs to leave, but you can find reinforcements in future trucks that arrive. The trucks will drop off additional manpower if they reach this base.")
		local ExtraText1 = Util_CreateLocString("Do not forget men... Protect the trucks so we can attain reinforcements. It has been an absolute privilege serving with every one of you!")
		
		local Text9 = Util_CreateLocString("Men! This is Commander Schneider. I am receiving reports that Strongpoint Gerlach has fallen to the enemy.")
		local Text10 = Util_CreateLocString("A few survivors from Strongpoint Gerlach will be arriving from the south in roughly two minutes. We should clear a path for them!")
		
		local Text11 = Util_CreateLocString("Commander! We have spotted a large group of Soviets organizing not far from the western bridge.")
		local Text12 = Util_CreateLocString("No doubt an attempt to overrun one of our street defences is imminent! Get to your positions!")
		
		local Text13 = Util_CreateLocString("It seem the Red Army has overrun Strongpoint Muller. This is a complete disaster...")
		local Text14 = Util_CreateLocString("There are a few light vehicles that did survive the enemy assault. They are incoming from the south now.")
		
		local Text15 = Util_CreateLocString("Enemy light and medium armor rolling in from the south!")
		local Text16 = Util_CreateLocString("You will need anti-tank weapons for this. Take some men and stop that assault!")
		
		local Text17 = Util_CreateLocString("Commander Schneider. Captain Carius and a few men from the canal defence zone is requesting to join Strongpoint Bismarck.")
		local Text18 = Util_CreateLocString("Permission granted. The canal defence zone was lost days ago. I am amazed they are still alive!")
		
		local Text19 = Util_CreateLocString("This is bad! Looks like the Soviets are taking us seriously now! They brought a KV-2 from the south!")
		local Text20 = Util_CreateLocString("Prepare yourselves. Soviet attacks from the north, east and south. This is going to get tougher now!")
		
		local Text21 = Util_CreateLocString("Commander! Captain Franz and some of his armored group is coming from the south.")
		local Text22 = Util_CreateLocString("Captain Franz? He was supposed to be defending the Reichstag. Has the Reichstag been lost to the Soviets? Let them in!")
		
		local Text23 = Util_CreateLocString("Men, I've received some grim news... It seems we are the last remaining strongpoint in Berlin still in control of our territory.")
		local Text24 = Util_CreateLocString("The Soviets have taken notice and are moving in from the north and south with flamethrower tanks. We must hold out as long as we can!")
		
		local Text25 = Util_CreateLocString("Commander! Look to the south! We have our best tank commanders coming to our aid!")
		local Text26 = Util_CreateLocString("This is certainly a surprise! With these behemoths we can target the enemy artillery guns which is still setting up to the east.")
		local Text27 = Util_CreateLocString("If we can eliminate those artillery guns within four minutes. It will prevent a lot of casualties for us. But we can also pull them back to defend the streets if we want to risk leaving the enemy guns alone.")
		local ExtraText2 = Util_CreateLocString("Four minutes has passed. I hope you destroyed those artillery guns, or else we will feel their wrath very soon.")
		
		local Text28 = Util_CreateLocString("Soviet armored assault from the east! Commander, what do we do!")
		local Text29 = Util_CreateLocString("Only our legendary tank commanders can save us now. Show them what the Wehrmacht is made of. We are all counting on you!")
		
		local Text30 = Util_CreateLocString("We have sad news that our brothers at Strongpoint Von Strauss has fallen to the enemy. The survivors are arriving here now.")
		local Text31 = Util_CreateLocString("Strongpoint Von Strauss was the only other territory which the Wehrmacht still had control... We really are the only holdout left.")
		
		local Text32 = Util_CreateLocString("Our scouts report that the Soviets are gathering men and vehicles from the east and west. What do we do?")
		local Text33 = Util_CreateLocString("Direct anyone we can spare to blunt their advance! They must not break through!")
		
		local Text34 = Util_CreateLocString("The end has arrived men. The Red Army gathers all of its forces for its final assault on our position... The odds are insurmountable, we cannot survive this attack.")
		local Text35 = Util_CreateLocString("All this in front of you men... these are the last streets of Berlin which the German people still control. Let us stand firm to the end men... make our sacrifice into legend!")
		local Text36 = Util_CreateLocString("What? Why are they suddenly pulling back? What is happening!")
		local Text37 = Util_CreateLocString("Cease fire! Cease fire! They are just pulling back to let me read a message I just received! It is over men... put down your weapons! Now! Do it!")
		local Text38 = Util_CreateLocString("Listen carefully men... I will quote from the message... The message reads...")
		local Text39 = Util_CreateLocString("On thirtieth April nineteen-fourty-five, the Führer committed suicide, and thus abandoned those who had sworn loyalty to him...")
		local Text40 = Util_CreateLocString("According to the Führer's order, you German soldiers would have had to go on fighting for Berlin despite the fact that our ammunition has run out and despite the general situation which makes our further resistance meaningless...")
		local Text41 = Util_CreateLocString("I order the immediate cessation of resistance. Every hour you keep on fighting prolongs the suffering of the civilians in Berlin and of our wounded...")
		local Text42 = Util_CreateLocString("Together with the commander-in-chief of the Soviet forces I order you to stop fighting immediately...")
		local Text43 = Util_CreateLocString("Helmuth Weidling, General of Artillery, former District Commandant in the defence of Berlin.")
		local Text44 = Util_CreateLocString("The message also instructs us to surrender at the location of Strongpoint Von Strauss.")
		local Text45 = Util_CreateLocString("Well... men. The war is over for us. I can only hope what we have done here helped save a few civilians today.")
		local Text46 = Util_CreateLocString("It has been my honor to lead you. Good luck to you, good luck to us all...")
		
---------------------------------Elite Allies List-------------------------------------

EVENTS.EliteAlliesOne = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesOne, 0.8)
        Modify_ReceivedAccuracy(AlliesOne, 0.8)
        local EliteName1 = Util_CreateLocString("Sniper Ace")
        HintMouseover_Add(EliteName1, AlliesOne, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesOne, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesTwo = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesTwo, 0.8)
        Modify_ReceivedAccuracy(AlliesTwo, 0.9)
        local EliteName1 = Util_CreateLocString("81st Shock Vanguards")
        HintMouseover_Add(EliteName1, AlliesTwo, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesTwo, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesThree = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesThree, 0.9)
        Modify_ReceivedAccuracy(AlliesThree, 0.6)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesThree, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_PARTISAN_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        local EliteName1 = Util_CreateLocString("9th Penal Specialists")
        HintMouseover_Add(EliteName1, AlliesThree, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesThree, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesFour = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesFour, 0.7)
        Modify_ReceivedAccuracy(AlliesFour, 0.4)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesFour, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        local EliteName1 = Util_CreateLocString("Elite NKVD Infiltrators")
        HintMouseover_Add(EliteName1, AlliesFour, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesFour, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesFive = function()
       
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesFive, 0.7)
        Modify_ReceivedAccuracy(AlliesFive, 0.8)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesFive, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        local EliteName1 = Util_CreateLocString("15th Elite Guards Rifles")
        HintMouseover_Add(EliteName1, AlliesFive, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesFive, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesSix = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesSix, 0.9)
        Modify_ReceivedAccuracy(AlliesSix, 0.4)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesFive, 1)
        local EliteName1 = Util_CreateLocString("Anti Tank Infiltrators")
        HintMouseover_Add(EliteName1, AlliesSix, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesSix, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesSeven = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedAccuracy(AlliesSeven, 0.5)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesSeven, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.OBERSOLDATEN_MG34_LMG_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.ROKS_2_FLAMETHROWER_ITEM_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PTRS_41_ANTI_TANK_RIFLE_GUARD_TROOP_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        local EliteName1 = Util_CreateLocString("Veteran Stalingrad Skirmishers")
        HintMouseover_Add(EliteName1, AlliesSeven, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesSeven, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesEight = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesEight, 0.4)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesEight, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GRENADIER_MG42_LMG_MOVING_NO_PRONE_MP)
        local EliteName1 = Util_CreateLocString("NKVD Enforcers")
        HintMouseover_Add(EliteName1, AlliesEight, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesEight, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesNine = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesNine, 0.6)
        Modify_ReceivedAccuracy(AlliesNine, 0.8)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesNine, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.GUARD_TROOP_ASSAULT_PACKAGE)
        local EliteName1 = Util_CreateLocString("3rd Assault Guards Veterans")
        HintMouseover_Add(EliteName1, AlliesNine, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesNine, 3, false)
	CTRL.WAIT()

end

EVENTS.EliteAlliesTen = function()

	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
        CTRL.WAIT()
        Modify_ReceivedDamage(AlliesTen, 0.6)
        Modify_ReceivedAccuracy(AlliesTen, 0.7)
        local ControlEntity1 = SGroup_GetSpawnedSquadAt(AlliesTen, 1)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.PANZERSHRECK_MP)
        Squad_GiveSlotItem(ControlEntity1, SLOT_ITEM.DP_28_LIGHT_MACHINE_GUN_PACKAGE_MOVING_NO_PRONE_MP)
        local EliteName1 = Util_CreateLocString("Elite Shock Vanguards")
        HintMouseover_Add(EliteName1, AlliesTen, 5, true)
        SGroup_IncreaseVeterancyRank(AlliesTen, 3, false)
	CTRL.WAIT()

end


--------------------------------Speech------------------------------

			
EVENTS.ToFive = function()

	CTRL.WAIT()
	Cmd_Move(GroupFive, mkr_spawn5to)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_Clear(GroupFive)
    CTRL.WAIT()

end

EVENTS.ToSix = function()

	CTRL.WAIT()
	Cmd_Move(GroupSix, mkr_spawn6to)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_Clear(GroupSix)
    CTRL.WAIT()

end

EVENTS.ToSeven = function()

	CTRL.WAIT()
	Cmd_Move(GroupSeven, mkr_spawn7to)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_Clear(GroupSeven)
    CTRL.WAIT()

end	
		
EVENTS.StartCinematic = function()

	CTRL.WAIT()
	SGroup_WarpToMarker(StartHalftrackOne, mkr_startpoint)
	SGroup_SetPlayerOwner(StartUnitOne, player1)
	Cmd_Move(StartHalftrackOne, mkr_startdrop1)
	CTRL.WAIT()
	CTRL.Event_Delay(2.5)
	CTRL.WAIT()
	SGroup_WarpToMarker(StartHalftrackTwo, mkr_startpoint)
	SGroup_SetPlayerOwner(StartUnitTwo, player2)
	Cmd_Move(StartHalftrackTwo, mkr_startdrop2)
	CTRL.WAIT()
	CTRL.Event_Delay(2.5)
	CTRL.WAIT()
    CTRL.Actor_PlaySpeech(ACTOR.Radio, Text1)
	SGroup_WarpToMarker(StartHalftrackThree, mkr_startpoint)
	SGroup_SetPlayerOwner(StartUnitThree, player3)
	Cmd_Move(StartHalftrackThree, mkr_startdrop3)
	CTRL.WAIT()

end

EVENTS.DropOne = function()

	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitOne, player4)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	Command_Squad(player4, StartHalftrackOne, SCMD_UnloadSquads, false)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitOne, player1)
	CTRL.WAIT()
	Cmd_Move(StartHalftrackOne, mkr_friendlyspawn)
	CTRL.WAIT()

end

EVENTS.DropTwo = function()

	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitTwo, player4)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	Command_Squad(player4, StartHalftrackTwo, SCMD_UnloadSquads, false)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitTwo, player2)
	CTRL.WAIT()
	Cmd_Move(StartHalftrackTwo, mkr_friendlyspawn)
	CTRL.WAIT()

end

EVENTS.DropThree = function()

	CTRL.WAIT()
	SGroup_Kill(HalftrackControl)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitThree, player4)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	Command_Squad(player4, StartHalftrackThree, SCMD_UnloadSquads, false)
	CTRL.WAIT()
	CTRL.Event_Delay(0.1)
	CTRL.WAIT()
	SGroup_SetPlayerOwner(StartUnitThree, player3)
	CTRL.WAIT()
	Cmd_Move(StartHalftrackThree, mkr_friendlyspawn)
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text2)
	CTRL.WAIT()
	Cmd_Move(Schneider, mkr_schneiderto1)
	CTRL.WAIT()
	Cmd_Move(StartUnitOne, mkr_startdrop1)
	Cmd_Move(StartUnitTwo, mkr_startdrop2)
	Cmd_Move(StartUnitThree, mkr_startdrop3)
	Camera_SetInputEnabled(false)
	Game_SetMode(UI_Cinematic)
	Camera_ResetToDefault()
	Camera_Follow(Schneider)
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text3)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text4)
	Camera_MoveTo(mkr_ammobottom)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text5)
	Camera_MoveTo(mkr_ammomid)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text6)
	Camera_MoveTo(mkr_ammotop)
	Cmd_Move(Gentlemen, mkr_gento)
	Cmd_Move(Propaganda, mkr_walterto)
	Cmd_Move(Imperial, mkr_rolfto)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.WAIT()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Camera_MoveTo(Schneider)
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text7)
	CTRL.WAIT()
	Camera_MoveTo(Schneider)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
    Camera_ResetToDefault()
	SGroup_SetPlayerOwner(Gentlemen, player1)
	SGroup_SetPlayerOwner(Propaganda, player2)
	SGroup_SetPlayerOwner(Imperial, player3)
	CTRL.WAIT()
	Cmd_Move(Schneider, mkr_schneiderto2)
	SGroup_Kill(GameSpawnControl)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, Text8)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, ExtraText1)
	CTRL.WAIT()
	CTRL.Event_Delay(15)
	CTRL.WAIT()
	Cmd_Move(StartOpel, mkr_friendlyspawn)
	CTRL.WAIT()

end

EVENTS.AllyOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text10)
	SGroup_WarpToMarker(CounterOneSniper, mkr_counterspawn1)
	SGroup_WarpToMarker(CounterOnePenal, mkr_counterspawn1)
	SGroup_WarpToMarker(CounterOneCons, mkr_counterspawn1)
	local TextHint1 = Util_CreateLocString("Optional: Secure and hold the road before friendly reinforcements arrive")
    Hint1 = HintPoint_Add(mkr_startpoint, true, TextHint1)
	Blip1 = UI_CreateMinimapBlip(mkr_startpoint, 9000, BT_AttackHere)
	CTRL.WAIT()
	Cmd_Move(CounterOneSniper, mkr_counterto1)
	Cmd_Move(CounterOnePenal, mkr_counterto2)
	Cmd_Move(CounterOneCons, mkr_counterto1)
	CTRL.WAIT()
	CTRL.Event_Delay(120)
	CTRL.WAIT()
	SGroup_WarpToMarker(HelpOneOne, mkr_startpoint)
	SGroup_WarpToMarker(HelpOneTwo, mkr_startpoint)
	SGroup_WarpToMarker(HelpOneThree, mkr_startpoint)
	SGroup_SetPlayerOwner(HelpOneOne, player1)
	SGroup_SetPlayerOwner(HelpOneTwo, player2)
	SGroup_SetPlayerOwner(HelpOneThree, player3)
	HintPoint_Remove(Hint1)
	HintPoint_Remove(AmmoHint1)
	HintPoint_Remove(AmmoHint2)
	HintPoint_Remove(AmmoHint3)
	HintPoint_Remove(EnemyText1)
	HintPoint_Remove(EnemyText2)
	HintPoint_Remove(EnemyText3)
	HintPoint_Remove(PickupHint)
	UI_DeleteMinimapBlip(Blip1)
    CTRL.WAIT()
	Cmd_Move(HelpOneOne, mkr_ally1)
	Cmd_Move(HelpOneTwo, mkr_ally2)
	Cmd_Move(HelpOneThree, mkr_ally3)
	CTRL.WAIT()

end	

EVENTS.EnemyOne = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text11)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text12)
	CTRL.WAIT()
	Cmd_Move(AttackGroupOne, mkr_attackto1)
	Cmd_AttackMove(AttackGroupTwo, mkr_attackto2)
	SGroup_WarpToMarker(Stuve, mkr_spawn5)
    CTRL.WAIT()
	Cmd_Move(Stuve, mkr_stuveto5)
	CTRL.WAIT()

end	

EVENTS.AllyTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text13)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text14)
    CTRL.WAIT()
	SGroup_WarpToMarker(HelpTwoOne, mkr_startpoint)
	SGroup_WarpToMarker(HelpTwoTwo, mkr_startpoint)
	SGroup_WarpToMarker(HelpTwoThree, mkr_startpoint)
	SGroup_SetPlayerOwner(HelpTwoOne, player1)
	SGroup_SetPlayerOwner(HelpTwoTwo, player2)
	SGroup_SetPlayerOwner(HelpTwoThree, player3)
    CTRL.WAIT()
	Cmd_Move(HelpTwoOne, mkr_startdrop1)
	Cmd_Move(HelpTwoTwo, mkr_startdrop2)
	Cmd_Move(HelpTwoThree, mkr_startdrop3)
	CTRL.WAIT()

end

EVENTS.EnemyTwo = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text15)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text16)
	CTRL.WAIT()
	SGroup_WarpToMarker(LoadTruck, mkr_spawn5)
	SGroup_WarpToMarker(AttackTwoOne, mkr_spawn5)
	SGroup_WarpToMarker(AttackTwoTwo, mkr_spawn5)
	SGroup_WarpToMarker(AttackTwoThree, mkr_spawn5)
	CTRL.WAIT()
	Cmd_Move(LoadTruck, mkr_attackto3)
	Cmd_Move(AttackTwoOne, mkr_attackto4)
	Cmd_AttackMove(AttackTwoTwo, mkr_attackto5)
	Cmd_Move(AttackTwoThree, mkr_attackto6)
    CTRL.WAIT()

end



EVENTS.AllyThree = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text17)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text18)
    CTRL.WAIT()
	SGroup_WarpToMarker(HelpThreeOne, mkr_startpoint)
	SGroup_WarpToMarker(HelpThreeTwo, mkr_startpoint)
	SGroup_WarpToMarker(HelpThreeThree, mkr_startpoint)
	SGroup_SetPlayerOwner(HelpThreeOne, player1)
	SGroup_SetPlayerOwner(HelpThreeTwo, player2)
	SGroup_SetPlayerOwner(HelpThreeThree, player3)
    CTRL.WAIT()
	Cmd_Move(HelpThreeOne, mkr_startdrop1)
	Cmd_Move(HelpThreeTwo, mkr_startdrop2)
	Cmd_Move(HelpThreeThree, mkr_startdrop3)
	CTRL.WAIT()

end

EVENTS.EnemyThree = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text19)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text20)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackThreeEastOne, mkr_spawn6)
	SGroup_WarpToMarker(AttackThreeEastTwo, mkr_spawn6)
	SGroup_WarpToMarker(AttackGroupThree, mkr_spawn7)
	SGroup_WarpToMarker(AttackThreeNorth, mkr_spawn7)
	SGroup_WarpToMarker(AttackThreeSouth, mkr_spawn5)
	SGroup_WarpToMarker(AttackThreeKV, mkr_spawn5)
	CTRL.WAIT()
	FOW_RevealSGroupOnly(AttackThreeKV, 9000)
	Cmd_AttackMove(AttackThreeEastOne, mkr_attackto6)
	Cmd_Move(AttackThreeEastTwo, mkr_attackto6)
	Cmd_Move(AttackGroupThree, mkr_attackto6)
	Cmd_AttackMove(AttackThreeNorth, mkr_attackto6)
	Cmd_Move(AttackThreeSouth, mkr_attackto6)
	Cmd_AttackMove(AttackThreeKV, mkr_attackto6)
    CTRL.WAIT()

end

EVENTS.AllyFour = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text21)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text22)
    CTRL.WAIT()
	SGroup_WarpToMarker(HelpFourOne, mkr_startpoint)
	SGroup_WarpToMarker(HelpFourTwo, mkr_startpoint)
	SGroup_WarpToMarker(HelpFourThree, mkr_startpoint)
	SGroup_SetPlayerOwner(HelpFourOne, player1)
	SGroup_SetPlayerOwner(HelpFourTwo, player2)
	SGroup_SetPlayerOwner(HelpFourThree, player3)
    CTRL.WAIT()
	Cmd_Move(HelpFourOne, mkr_startdrop1)
	Cmd_Move(HelpFourTwo, mkr_startdrop2)
	Cmd_Move(HelpFourThree, mkr_startdrop3)
	SGroup_Kill(PlaneControl)
	CTRL.WAIT()

end

EVENTS.EnemyFour = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text23)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text24)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackFourNorth, mkr_spawn7)
	SGroup_WarpToMarker(AttackFourElite, mkr_spawn7)
	SGroup_WarpToMarker(AttackFourPenal, mkr_spawn5)
	SGroup_WarpToMarker(AttackFourSouth, mkr_spawn5)
	SGroup_WarpToMarker(AttackFourFlameOne, mkr_spawn5)
	SGroup_WarpToMarker(AttackFourFlameTwo, mkr_spawn7)
	SGroup_WarpToMarker(AttackFourKV, mkr_spawn5)
	CTRL.WAIT()
	FOW_RevealSGroupOnly(AttackFourFlameOne, 9000)
	FOW_RevealSGroupOnly(AttackFourFlameTwo, 9000)
	Cmd_AttackMove(AttackFourNorth, mkr_attackto7)
	Cmd_AttackMove(AttackFourElite, mkr_ammomid)
	Cmd_AttackMove(AttackFourPenal, mkr_ammobottom)
	Cmd_Move(AttackFourSouth, mkr_attackto8)
	Cmd_AttackMove(AttackFourFlameOne, mkr_attackto8)
	Cmd_AttackMove(AttackFourKV, mkr_attackto6)
	Cmd_Move(AttackFourFlameTwo, mkr_attackto6)
    CTRL.WAIT()

end

EVENTS.AllyFive = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, Text25)
	World_GetCurrentInteractionStage()
    World_IncreaseInteractionStage()
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text26)
    CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text27)
	FOW_RevealSGroupOnly(ArtilleryOne, 9000)
	FOW_RevealSGroupOnly(ArtilleryTwo, 9000)
	local TextHintOne = Util_CreateLocString("Optional: Destroy the artillery gun to prevent it firing on your position")
    HintOne = HintPoint_Add(mkr_artilleryone, true, TextHintOne)
	HintTwo = HintPoint_Add(mkr_artillerytwo, true, TextHintOne)
	Blip2 = UI_CreateMinimapBlip(mkr_artilleryone, 9000, BT_AttackHere)
	Blip3 = UI_CreateMinimapBlip(mkr_artillerytwo, 9000, BT_AttackHere)
    CTRL.WAIT()
	SGroup_WarpToMarker(HelpFiveOne, mkr_greyshotspawn)
	SGroup_WarpToMarker(HelpFiveTwo, mkr_acespawn)
	SGroup_WarpToMarker(HelpFiveThree, mkr_omegaspawn)
	FOW_RevealSGroupOnly(Greyshot, 9000)
	FOW_RevealSGroupOnly(Ace, 9000)
	FOW_RevealSGroupOnly(Omega, 9000)
    CTRL.WAIT()
	Cmd_Move(HelpFiveOne, mkr_greyshotto)
	Cmd_Move(HelpFiveTwo, mkr_aceto)
	Cmd_Move(HelpFiveThree, mkr_omegato)
	CTRL.WAIT()
	CTRL.Event_Delay(230)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, ExtraText2)
	HintPoint_Remove(HintOne)
	HintPoint_Remove(HintTwo)
	UI_DeleteMinimapBlip(Blip2)
	UI_DeleteMinimapBlip(Blip3)
	SGroup_SetPlayerOwner(ArtilleryOne, player5)
	SGroup_SetPlayerOwner(ArtilleryTwo, player5)
	CTRL.WAIT()

end

EVENTS.EnemyFive = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text28)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text29)
	CTRL.WAIT()
	FOW_RevealSGroupOnly(AttackFiveOneThree, 9000)
	FOW_RevealSGroupOnly(AttackFiveTwoThree, 9000)
	Cmd_Move(AttackFiveOneOne, mkr_attackto9)
	Cmd_Move(AttackFiveTwoOne, mkr_attackto5)
	Cmd_AttackMove(AttackFiveOneTwo, mkr_attackto9)
	Cmd_AttackMove(AttackFiveTwoTwo, mkr_attackto5)
	Cmd_Attack(AttackFiveOneThree, Greyshot)
	Cmd_Attack(AttackFiveTwoThree, Ace)
    CTRL.WAIT()
	CTRL.Event_Delay(120)
	CTRL.WAIT()
	Cmd_AttackMove(AttackFiveOneThree, mkr_attackto9)
	Cmd_AttackMove(AttackFiveTwoThree, mkr_attackto5)
	CTRL.WAIT()

end

EVENTS.AllySix = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text30)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text31)
    CTRL.WAIT()
	SGroup_SetPlayerOwner(HelpSixOne, player1)
	SGroup_SetPlayerOwner(HelpSixTwo, player2)
	SGroup_SetPlayerOwner(HelpSixThree, player3)
	SGroup_WarpToMarker(HelpSixOne, mkr_startpoint)
	SGroup_WarpToMarker(HelpSixTwo, mkr_startpoint)
	SGroup_WarpToMarker(HelpSixThree, mkr_startpoint)
    CTRL.WAIT()
	Cmd_Move(HelpSixOne, mkr_startdrop1)
	Cmd_Move(HelpSixTwo, mkr_startdrop2)
	Cmd_Move(HelpSixThree, mkr_startdrop3)
	CTRL.WAIT()

end

EVENTS.EnemySix = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Text32)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text33)
	CTRL.WAIT()
	FOW_RevealSGroupOnly(AttackSixOneOne, 9000)
	FOW_RevealSGroupOnly(AttackSixTwoThree, 9000)
	FOW_RevealSGroupOnly(AttackSixThreeThree, 9000)
	SGroup_WarpToMarker(AttackSixOneOne, mkr_spawn5)
	SGroup_WarpToMarker(AttackSixOneTwo, mkr_spawn5)
	SGroup_WarpToMarker(AttackSixTwoOne, mkr_spawn6)
	SGroup_WarpToMarker(AttackSixTwoTwo, mkr_spawn6)
	SGroup_WarpToMarker(AttackSixTwoThree, mkr_spawn6)
	SGroup_WarpToMarker(AttackSixThreeOne, mkr_spawn7)
	SGroup_WarpToMarker(AttackSixThreeTwo, mkr_spawn7)
	SGroup_WarpToMarker(AttackSixThreeThree, mkr_spawn7)
	CTRL.WAIT()
	Cmd_AttackMove(AttackSixOneOne, mkr_attackto10)
	Cmd_Move(AttackFiveTwoOne, mkr_attackto11)
	Cmd_Move(AttackFiveTwoTwo, mkr_attackto12)
	Cmd_AttackMove(AttackFiveTwoThree, mkr_attackto13)
	Cmd_Move(AttackSixThreeOne, mkr_attackto6)
	Cmd_Move(AttackSixThreeTwo, mkr_attackto6)
	Cmd_AttackMove(AttackSixThreeThree, mkr_attackto6)
    CTRL.WAIT()

end

EVENTS.EnemySeven = function()

	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text34)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text35)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackSevenOneOne, mkr_counterspawn1)
	SGroup_WarpToMarker(AttackSevenOneTwo, mkr_sevenspawn9)
	SGroup_WarpToMarker(AttackSevenOneThree, mkr_sevenspawn10)
	SGroup_WarpToMarker(AttackSevenOneFour, mkr_sevenspawn11)
	SGroup_WarpToMarker(AttackSevenOneFive, mkr_sevenspawn12)
	SGroup_WarpToMarker(AttackSevenOneSix, mkr_sevenspawn13)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sevenspawn6)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sevenspawn6)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_sevenspawn15)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_sevenspawn15)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_sevenspawn14)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sevenspawn14)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackSevenTwoOne, mkr_sevenspawn1)
	SGroup_WarpToMarker(AttackSevenTwoTwo, mkr_sevenspawn16)
	SGroup_WarpToMarker(AttackSevenTwoThree, mkr_sevenspawn17)
	SGroup_WarpToMarker(AttackSevenTwoFour, mkr_sevenspawn18)
	SGroup_WarpToMarker(AttackSevenTwoFive, mkr_sevenspawn19)
	SGroup_WarpToMarker(AttackSevenTwoSix, mkr_sevenspawn20)
	SGroup_WarpToMarker(AttackSevenTwoSeven, mkr_sevenspawn21)
	SGroup_WarpToMarker(AttackSevenTwoEight, mkr_sevenspawn22)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn2)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn2)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn4)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn4)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn5)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn5)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn23)
	Util_CreateSquads(player8, AttackSevenInfantrySE, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn23)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackSevenThreeOne, mkr_sevenspawn24)
	SGroup_WarpToMarker(AttackSevenThreeTwo, mkr_sevenspawn25)
	SGroup_WarpToMarker(AttackSevenThreeThree, mkr_spawn6)
	SGroup_WarpToMarker(AttackSevenThreeFour, mkr_sevenspawn26)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn7)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sevenspawn7)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sevenspawn27)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_sevenspawn27)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.SHOCK_TROOPS_MP, mkr_sevenspawn28)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sevenspawn28)
	CTRL.WAIT()
	SGroup_WarpToMarker(AttackSevenFourOne, mkr_spawn7)
	SGroup_WarpToMarker(AttackSevenFourTwo, mkr_sevenspawn29)
	SGroup_WarpToMarker(AttackSevenFourThree, mkr_sevenspawn30)
	SGroup_WarpToMarker(AttackSevenFourFour, mkr_sevenspawn31)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.GUARDS_TROOPS_MP, mkr_sevenspawn8)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.BASE_CONSCRIPT_SQUAD_MP, mkr_sevenspawn8)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.PENAL_BATTALION_MP, mkr_sevenspawn32)
	Util_CreateSquads(player8, AttackSevenInfantryNW, SBP.SOVIET.GUARDS_TROOPS_ASSAULT_MP, mkr_sevenspawn32)
	CTRL.WAIT()
	FOW_RevealSGroupOnly(NorthWestAll, 120)
	FOW_RevealSGroupOnly(SouthEastAll, 120)
	FOW_RevealSGroupOnly(AttackSevenInfantrySE, 120)
	FOW_RevealSGroupOnly(AttackSevenInfantryNW, 120)
	Cmd_AttackMove(NorthWestAll, mkr_attackto11)
    Cmd_AttackMove(SouthEastAll, mkr_attackto14)
	Cmd_AttackMove(AttackSevenInfantryNW, mkr_attackto11)
	Cmd_AttackMove(AttackSevenInfantrySE, mkr_attackto14)
    CTRL.WAIT()
	CTRL.Event_Delay(100)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text36)
	Modify_CaptureTime(AllStrategicPoints, 0.01)
	Modify_CaptureTime(AllAmmoPoints, 0.01)
	Cmd_Move(SouthEastAll, mkr_spawn5)
	Cmd_Move(AttackSevenInfantrySE, mkr_spawn5)
	Cmd_Move(NorthWestAll, mkr_endto1)
	Cmd_Move(AttackSevenInfantryNW, mkr_endto1)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text37)
	CTRL.WAIT()
    local PlayerOne = Player_GetSquads(player1)
	local PlayerTwo = Player_GetSquads(player2)
	local PlayerThree = Player_GetSquads(player3)
	local PlayerFour = Player_GetSquads(player4)
	Cmd_Surrender(PlayerOne, 0, mkr_startpoint, true, true)
	Cmd_Surrender(PlayerTwo, 0, mkr_startpoint, true, true)
	Cmd_Surrender(PlayerThree, 0, mkr_startpoint, true, true)
	Cmd_Surrender(PlayerFour, 0, mkr_startpoint, true, true)
	FOW_RevealSGroupOnly(PlayerOne, 9000)
	FOW_RevealSGroupOnly(PlayerTwo, 9000)
	FOW_RevealSGroupOnly(PlayerThree, 9000)
	FOW_RevealSGroupOnly(PlayerFour, 9000)
	CTRL.WAIT()
	SGroup_SetWorldOwned(PlayerOne)
	SGroup_SetWorldOwned(PlayerTwo)
	SGroup_SetWorldOwned(PlayerThree)
	SGroup_SetWorldOwned(PlayerFour)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text38)
    CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text39)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text40)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text41)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text42)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text43)
	CTRL.WAIT()
	CTRL.Event_Delay(5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text44)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text45)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Radio, Text46)
	CTRL.WAIT()
	World_SetPlayerWin(player1)
    World_SetPlayerWin(player2)
    World_SetPlayerWin(player3)
	World_SetPlayerWin(player4)
	CTRL.WAIT()

end
