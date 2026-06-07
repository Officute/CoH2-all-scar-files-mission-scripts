--Container
EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("mission/m02")
	g_MissionSpeechPath = "mission/m02"
	Sound_PreCacheSound("campaign/m02_panic_crowd")
	Sound_PreCacheSound("campaign/train_depart_mission_2")
end
Scar_AddInit(Init_Audio)

function Init_NIS()
	NIS_INTROCAM = "SP/CoH2_Campaign/M02-Scorched_Earth/nis/m02_introPan_v4"
	nis_load(NIS_INTROCAM)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)
end
Scar_AddInit(Init_NIS)


--Intro cinematic
EVENTS.NIS_Intro = function()
	Game_SetMode(UI_Cinematic)
	
	CTRL.SitRep_PlayMovie("m02_cin02")
	CTRL.WAIT()
end

EVENTS.NIS_Setup = function()
	Sound_PlayOnSquad("speech/sp/mission/m02/11035424", sg_civilians)  -- LOCDB [11035424] 'The Germans are almost here! We need to leave!' - 'Civilian'
	
	--Order intro moves
	Cmd_SquadPath(sg_introTrucks, "pth_tankAttack", true, LOOP_NONE, false, 0, mkr_retreatCheck, false, true)
	Cmd_MoveToAndDespawn(sg_introSquad1, mkr_exit2)
	Cmd_SquadPath(sg_introSquad2, "pth_footEvac", true, LOOP_NONE, false, 0, mkr_bridgeObj)
	Cmd_MoveToAndDespawn(sg_civilians, mkr_exit2)
	Cmd_MoveToAndDespawn(sg_civilians2, mkr_exit2)
	Cmd_MoveToAndDespawn(sg_civiliansTown, mkr_exit2)
	
	CTRL.Scar_PlayNIS(NIS_INTROCAM)
	Game_SubTextFade(11046892, 11048260, 0.5, 4, 0.5) -- LOCDB [11046892] 'September, 1941'  -- LOCDB [11048260] 'Outskirts of Moscow, USSR'
	CTRL.SUB()
		CTRL.Event_Delay(3.5)
		CTRL.WAIT()
		
		Sound_Play3D("speech/sp/mission/m02/11041932", EGroup_GetSpawnedEntityAt(eg_hq, 1))  -- LOCDB [11041932] 'German forces are on the edge of town. Evacuate immediately. Leave your belongings. Evacuate the town immediately.' - 'Senior Officer'
		CTRL.Event_Delay(2.5)
		CTRL.WAIT()		
		
		Sound_PlayOnSquad("campaign/m02_panic_crowd", sg_civilians2) --Crying
		CTRL.Event_Delay(2.5)
		CTRL.WAIT()
		
		--Move player units to show action
		Cmd_Move(sg_startingCons1, mkr_startUnit)
		Cmd_Move(sg_startingCons2, mkr_intersectionCenter)
		
		Sound_PlayOnSquad("speech/sp/mission/m02/11041931", sg_introSquad2) -- LOCDB [11041931] 'Leave your things! We must go, now!' - 'Civilian'
		CTRL.Event_Delay(5.0)
		CTRL.WAIT()
		
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035414) -- LOCDB [11035414] 'Move! Move! Move! Let's go, Comrades!' - 'Soldier_01'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
end

--End cinematic
EVENTS.NIS_End = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 1.8)
	
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	CTRL.SitRep_PlayMovie("m02_cin03")
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
end


 -- LOCDB CREATE  MISSION "M02" CHARACTER ""
--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE 1 - Reinforce -------------------------------------------
--[[********************************************************************************************************]]
EVENTS.Obj1_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035096) -- LOCDB [11035096] 'German forces are approaching! Reinforce the front line!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.CivilianPanic2 = function() --NOT BEING USED
	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11035425) -- LOCDB [11035425] 'We're running out of time! Leave your things and just go!' - 'Civilian'
	CTRL.WAIT()
end

EVENTS.Merge_TeachMerge = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046482) -- LOCDB [11046482] 'Take those conscripts and use them to replenish our shock troops by the front line.' - 'Churkin'
	CTRL.WAIT()	
end

EVENTS.Merge_Benefit = function() --Not being used
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046766) -- LOCDB [11046766] 'Merging allows reinforcement of higher value infantry squads' - 'Russian_Senior_Officer'
	CTRL.WAIT()
end

EVENTS.Merge_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11049554) -- LOCDB [11049554] 'Sir, we could not get to the Shock Troops in time!' - 'Soviet_Soldier_03'
	CTRL.WAIT()
end

EVENTS.Obj1_Reminder = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025336) -- LOCDB [11025336] 'Hurry Comrade! It's only a matter of time before the fascists push us back!' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049994) -- LOCDB [11049994] 'Reinforce the front line!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Obj1_StartHold = function()	
--~ 	Sound_PlayOnSquad("speech/sp/mission/m02/11036857", sg_shock1) -- LOCDB [11036857] 'The fascists outnumber us!' - 'Soldier_02'
--~ 	CTRL.Event_Delay(3.0)
--~ 	CTRL.WAIT()
--~ 	Sound_PlayOnSquad("speech/sp/mission/m02/11035415", sg_shock2) -- LOCDB [11035415] 'Stay behind cover! Use grenades and Molotovs to keep them back!' - 'Junior Officer'
--~ 	CTRL.Event_Delay(3.0)
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035415) -- LOCDB [11035415] 'Stay behind cover! Use grenades and Molotovs to keep them back!' - 'Junior Officer'
	
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049548) -- LOCDB [11049548] 'You must hold the line and prevent the Germans from advancing!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.RemindReinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035099) -- LOCDB [11035099] 'We won't last long! We need reinforcements!' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046538) -- LOCDB [11046538] 'You must hold the line!' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046539) -- LOCDB [11046539] 'Call in more conscript squads if you have to!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS_Obj1_FrontChatter2 = function() --NOT BEING USED
	local intel = function()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035101)  -- LOCDB [11035101] 'Hold the line, Comrades! Our engineers need more time!' - 'Russian_Junior_Officer'
		CTRL.WAIT()
	end
	Util_StartIntel(intel)
end

EVENTS.GermanFallback = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036858) -- LOCDB [11036858] 'Ha! Look at the cowards run!' - 'Soldier_03'
	CTRL.WAIT()
end

EVENTS.StukaAttack = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11035103)  -- LOCDB [11035103] 'Sukin sin! Stukas! Take cover!' - 'Soldier_03'
	CTRL.WAIT()
end

EVENTS.Obj1_Flanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035107)  -- LOCDB [11035107] 'More of them! They're trying to flank us!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Obj1_EndHold = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035104) -- LOCDB [11035104] 'We can't hold this position any longer! Fall back to the trucks!' - 'Russian_Junior_Officer'
	CTRL.WAIT()
end

EVENTS.SetupDefensive = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035105) -- LOCDB [11035105] 'I'm sending additional reinforcements your way.'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035106) -- LOCDB [11035106] 'Set up defensive positions and defend those supplies at all costs.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.FailTrucks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11049553) -- LOCDB [11049553] 'Sir, we've lost one of the trucks!' - 'Soviet_Soldier_02'
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049549) -- LOCDB [11049549] 'Dammit! Those supplies were critical to our war efforts!' - 'Churkin'
	CTRL.WAIT()
end


EVENTS.Obj1_FailHold = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11025337) -- LOCDB [11025337] 'Sir, we can't hold them back! They have broken through the front line!' - 'Russian_Junior_Officer'
	CTRL.WAIT()
end

EVENTS.Obj1_WarnFail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11047033) -- LOCDB [11047033] 'The fascists are gaining ground! Don't let them push you back!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Obj1_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035108)  -- LOCDB [11035108] 'Well done, Comrade Lieutenant. The supply trucks are moving out.' - 'Churkin'
	CTRL.WAIT()
end







--[[********************************************************************************************************]]
---------------------------------------- OBJECTIVE 2 - Destroy Military Assets -------------------------------
--[[********************************************************************************************************]]
EVENTS.Destroy_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035416) -- LOCDB [11035416] 'There are critical military assets that could not be evacuated in time.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035417) -- LOCDB [11035417] 'Order our engineers to wire them with explosives and destroy them before the Germans push us back.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Destroy_WarnFailure = function()
	--Replaced with check for engineers
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11041927) -- LOCDB [11041927] 'You must not let the Germans secure those territories!' - 'Churkin'
--~ 	CTRL.WAIT()

	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046483) -- LOCDB [11046483] 'You will need those engineers to destroy the remaining assets! Keep them safe!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Destroy_Discussion = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036867) -- LOCDB [11036867] 'But, sir, we can still use some of this equipment to aid the civilian evacuation.' - 'Isakovich'
	--added 2012-11-27
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11046484) -- LOCDB [11046484] 'Sir, we can use some of this equipment to hold off the Germans, or even aid the evacuation!' - 'Isakovich'
	CTRL.WAIT()
 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036868) -- LOCDB [11036868] 'We cannot risk having those assets fall into German hands. Destroy them at once!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Destroy_Munitions = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046767) -- LOCDB [11046767] 'There has to be more munitions lying somewhere around here.' - 'Soldier_03'
	CTRL.WAIT()
end

EVENTS.Destroy_Fail = function()
	--Removed in favour of having death of engineers as loss condition
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11041933) -- LOCDB [11041933] 'German forces have secured control of the area. Your failure will not be tolerated!' - 'Churkin'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046485) -- LOCDB [11046485] 'All the engineers are dead! We won't be able to destroy the assets!' - 'Soldier_1'
	CTRL.WAIT()
end

EVENTS.Destroy_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035111) -- LOCDB [11035111] 'Well done, Comrade. We have denied the Germans access to any of our supplies.' - 'Churkin'
	CTRL.WAIT()
end






--[[********************************************************************************************************]]
----------------------------------------------- Explosives ---------------------------------------------------
--[[********************************************************************************************************]]
EVENTS.Explosives_InformHT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035112) -- LOCDB [11035112] 'Sir! They are bringing in vehicles!' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035113) -- LOCDB [11035113] 'We have a special surprise for the German bastards…' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11041928)  -- LOCDB [11041928] 'But Sir, our troops…' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036870) -- LOCDB [11036870] 'We are out of time. Detonate the explosives!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Obj1_end = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025330) -- LOCDB [11025330] 'That will hold them off for now, but they won't give up that easily.' - 'Churkin'
	CTRL.WAIT()
end





--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE 3 - ScorchEarth ------------------------------------
--[[********************************************************************************************************]]
EVENTS.Scorch_Intro = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036871) -- LOCDB [11036871] 'This town may fall to the fascists, but all they will find is rubble and ashes.' - 'Churkin'
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049550) -- LOCDB [11049550] 'This town may fall to the Fascisti, but all they will find is smoldering ruins.' - 'Churkin'
	CTRL.WAIT()
	
	if(not Misc_IsEGroupOnScreen(eg_flamethrowers, 0.9, ANY)) then
		_PanToPosition(eg_flamethrowers)
	end
	
	--removed 2012-11-07
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036872) -- LOCDB [11036872] 'Comrade Lieutenant, requisition flamethrowers from the trainyard and burn this town to the ground.' - 'Churkin'
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046540)  -- LOCDB [11046540] 'Fall back towards the trainyard and requisition flamethrowers for your engineers.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049551)  -- LOCDB [11049551] 'We will burn this town to the ground!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.InformHQ = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035423) -- LOCDB [11035423] 'Our headquarters is still operational. Use it to request additional conscripts and engineers.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Scorch_UseEngineers = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046542) -- LOCDB [11046542] 'Use your engineers to pickup those flamethrowers.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Scorch_BurnOrders = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036873) -- LOCDB [11036873] 'Order your men to set the houses on fire. Once that is done, have them torch the surrounding fields.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035418) -- LOCDB [11035418] 'Leave nothing for the Germans!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Scorch_Reminder = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035419) -- LOCDB [11035419] 'Hurry comrade, we cannot waste any time!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.Scorch_AlliedPanic = function() --Called from burnFieldLeft
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035421) -- LOCDB [11035421] 'Oh God! There's fire everywhere! <Screams>' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Scorch_ShockLine1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11046486) -- LOCDB [11046486] 'Shit. I can't believe we're doing this...' - 'Soviet_Engineer'
	CTRL.WAIT()
end

EVENTS.Scorch_ShockLine2 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046487) -- LOCDB [11046487] 'Madness... This is our town! Our lands!' - 'Soviet_3'
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11049556) -- LOCDB [11049556] 'This is Madness! This is our town, our lands!' - 'Soviet_Soldier_04'
	CTRL.WAIT()
end


EVENTS.Scorch_StartFields = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036969)  -- LOCDB [11036969] 'The Germans are advancing through the fields!' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036970) -- LOCDB [11036970] 'Comrade Lieutenant, torch the fields before they push through!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Scorch_WarnGasoline = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11046488) -- LOCDB [11046488] 'We've doused the fields with gasoline. Be careful, comrade!' - 'Soviet_engineer'
	CTRL.WAIT()
end


EVENTS.Scorch_Argument = function()
	--removed 2012-12-04	
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025357) -- LOCDB [11025357] 'But Sir, our forces are still in the fields!'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025342) -- LOCDB [11025342] 'We cannot let the Germans capture those resources. Torch the fields, now!'

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046489) -- LOCDB [11046489] 'Our forces are still in the fields!' - 'Soldier_1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046490) -- LOCDB [11046490] 'We cannot let the Germans advance. Torch the fields, now!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Scorch_Failed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008050) -- LOCDB [11008050] 'Sir, we could not stop them! They have taken the fields!' - 'RUSSIAN_CONSCRIPT'
	CTRL.WAIT()
end

EVENTS.Scorch_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036874) -- LOCDB [11036874] 'Good job, Comrade.  Fritz will regret ever stepping foot on Soviet territory.' - 'Churkin'
	CTRL.WAIT()	
end




--[[********************************************************************************************************]]
----------------------------------------- OBJECTIVE 4 - Defend trainyard -------------------------------------
--[[********************************************************************************************************]]
EVENTS.Defend_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036971) -- LOCDB [11036971] 'You have done well holding off the fashisty, but we still need more time.' - 'Churkin'
	CTRL.WAIT()
	-- Removed 2012-11-23
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036972) -- LOCDB [11036972] 'Gather your men and prepare a last line of defense.' - 'Churkin'
end
	
EVENTS.Defend_Roads = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025349) -- LOCDB [11025349] 'The Germans will try and push through the town using armored vehicles.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025350) -- LOCDB [11025350] 'Place mines and demolition charges along the roads to stop their advance.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Defend_NoTanks = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046491) -- LOCDB [11046491] 'Sir, mines won't be enough if their vehicles push through.' - 'Soldier_3'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046492) -- LOCDB [11046492] 'We can use those T-34's to…' - 'Soldier_3'

	Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11049557) -- LOCDB [11049557] 'Sir, mines won't be enough if their vehicles push through. We can use those T-34's to...' - 'Soviet_Soldier_04'
	CTRL.Event_Delay(6.87)
	CTRL.WAIT()
	Subtitle_EndCurrentSpeech()
end

EVENTS.Defend_NoTanksInterrupt = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046493) -- LOCDB [11046493] 'Negative. Those assets are required elsewhere. Make do with what you have.' - 'Churkin'
	CTRL.WAIT()
end


EVENTS.Defend_Start = function()
	-- Edited 2012-11-27
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046495) -- LOCDB [11046495] 'Ready your weapons, Comrades, and remember: the trainyard must be protected at all costs!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ScoutCar1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035118) -- LOCDB [11035118] 'Ebat' kopat'! Scout car inbound!' - 'Soldier_02'
	CTRL.WAIT()
	if(#t_mineHints ~= 0) then
		CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036859) -- LOCDB [11036859] 'Where the hell are those mines!' - 'Churkin'
		CTRL.WAIT()
	end
end

EVENTS.Mines = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035119) -- LOCDB [11035119] 'Place mines on the roads!  More German vehicles are sure to come!' - 'Russian_Junior_Officer'
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11049555) -- LOCDB [11049555] 'Place more mines on the roads!  More German vehicles are sure to come!' - 'Soviet_Soldier_03'
	CTRL.WAIT()
end

EVENTS.RemindMines = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035120) -- LOCDB [11035120] 'Quickly Comrade! Place some mines on the roads!' - 'Russian_Junior_Officer'
	CTRL.WAIT()
end

EVENTS.Defend_HalftrackRight = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11025355) -- LOCDB [11025355] 'Another scout car coming in!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.Defend_HalftrackLeft = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11025354) -- LOCDB [11025354] 'German scout car, West road!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.Defend_HalftrackCenter = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008056) -- LOCDB [11008056] 'Incoming Half-track! Main road!' - 'RUSSIAN_CONSCRIPT'
	CTRL.WAIT()
end

EVENTS.Defend_EvacVehicles = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11025352) -- LOCDB [11025352] 'We're almost done! We're moving out the last of the tanks!' - 'Russian_Engineer'
	CTRL.WAIT()
end

EVENTS.Defend_Breach = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11025353) -- LOCDB [11025353] 'Sir, they've breached the train yard! They're going for our tanks!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.AttackTanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11049552) -- LOCDB [11049552] 'They've got Anti-tank weapons! Don't let them near our tanks!' - 'Soviet_Senior_Officer'
	CTRL.WAIT()
end

EVENTS.Defend_EnemyTanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11008058) -- LOCDB [11008058] 'Sir! They have tanks! We won't be able to stop them!' - 'RUSSIAN_CONSCRIPT'
	CTRL.WAIT()
end

EVENTS.Defend_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035123) -- LOCDB [11035123] 'Comrade Lieutenant your orders were to protect our supplies at all costs! I don't care how many men it took!' - 'Churkin'
	CTRL.WAIT()
end






--[[********************************************************************************************************]]
------------------------------------------- OBJECTIVE 5 - Escape ---------------------------------------------
--[[********************************************************************************************************]]
EVENTS.Escape_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035122) -- LOCDB [11035122] 'There is nothing more you can do! Fall back to the bridge!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Escape_NoFight = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11025356) -- LOCDB [11025356] 'We can't hold them off any longer! Fall back to the bridge!' - 'Soldier_05'
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------- BONUS OBJECTIVE - Keep Shocktroops alive -------------------------
--[[********************************************************************************************************]]
EVENTS.Bonus_Intro = function()
	--Added 2011-11-26
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046494) -- LOCDB [11046494] 'Those Shock Troops have invaluable equipment and training. Keep them safe!' - 'Churkin'
	CTRL.WAIT()
end




--Events that are not being used
-- LOCDB [11042846] 'Munitions'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035100)  -- LOCDB [11035100] 'I'm sending more men to your location, Comrade Lieutenant. Call in more conscript squads if you have to!'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11035117) -- LOCDB [11035117] 'Torch the fields before they push through!'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11025344) -- LOCDB [11025344] 'We have doused the fields with gasoline. Target the haystacks!' - 'Engineer'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11035422)  -- LOCDB [11035422] 'Stock up on munitions before the Germans attack.' - 'Churkin'
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11025358) -- LOCDB [11025358] 'Get ready Comrades, here they come!'
