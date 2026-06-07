function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("mission/m05")
	g_MissionSpeechPath = "mission/m05"
end
Scar_AddInit(Init_Audio)

function Init_NIS()
	NIS_INTROCAM = "SP/CoH2_Campaign/M05-Stalingrad/nis/m05_introPan_v4"
	nis_load(NIS_INTROCAM)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0)
end
Scar_AddInit(Init_NIS)

--Container
EVENTS = {}


-------------------------------------
-- NIS
-------------------------------------
--Intro
EVENTS.NIS01 = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	CTRL.SitRep_PlayMovie("m05_cin01a")
	CTRL.WAIT()
end

EVENTS.NIS_IntroCam = function()
	FOW_EnableTint(false)
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_IN, 1.0)
	CTRL.Scar_PlayNIS(NIS_INTROCAM)
	Game_SubTextFade(11046890, 11046889, 0.5, 4, 0.5) -- LOCDB [11046890] 'September 1942' -- LOCDB [11046889] 'Stalingrad, USSR'
	
	--Intro NIS audio
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046950) -- LOCDB [11046950] 'By order of Stalin, there will be no retreating! Cowards will be shot on sight!' - 'Commissar'
	Sound_PlayOnSquad("speech/sp/mission/m05/11046950", SGroup_GetSpawnedSquadAt(sg_commissar, 1))
	
	Cmd_Move(sg_startingEngineers, mkr_katyusha1)
	Cmd_Move(sg_startingConscript, mkr_camStart)
	Cmd_Move(sg_startingGuards, mkr_start3)
	Cmd_Move(sg_startingHT, mkr_start1)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(9999)
	
	event_introGrenade = Event_ElementOnScreen(EVENTS.NIS_IntroGrenade, nil, player1, mkr_ptA_2, ANY, 0.8, 1.2)
	CTRL.WAIT()
end

EVENTS.NIS_IntroGrenade = function()
	SGroup_SetInvulnerable(sg_introShocks, false)
	SGroup_SetInvulnerable(sg_introHMG, false)
	
	Cmd_Ability(sg_introPG, ABILITY.GERMAN.PANZER_GRENADIER_BUNDLED_GRENADE, SGroup_GetPosition(sg_introShocks), nil, true)
	Cmd_AttackMove(sg_introPG, mkr_ptA_mg, true)
	
	sg_introHT = Util_CreateSquads(player2, "introHT", SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD, mkr_enc5_3)
	Cmd_SquadPath(sg_introHT, "pth_introHT", true, LOOP_NONE, false, 0)
	
	EGroup_SetStrategicPointNeutral(eg_pointA) --HACKY FIX - This point was starting 
end

EVENTS.Sitrep = function()
	CTRL.SitRep_PlayMovie("m05_sitrep")
	CTRL.WAIT()
end

--End
EVENTS.NIS02 = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 3.0)
	
	CTRL.Event_Delay(3.5)
	CTRL.WAIT()
	
	CTRL.SitRep_PlayMovie("m05_cin05")
	CTRL.WAIT()
end




 -- LOCDB CREATE  MISSION "M05" CHARACTER ""
--************************************************************************************************************************************************
-- 												OBJECTIVE 1 - Establish a Perimeter.
--************************************************************************************************************************************************
EVENTS.Obj1_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025759) -- LOCDB [11025759] 'We will push the fascist out of Stalingrad, block by block if we must!' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11041929) -- LOCDB [11041929] 'Comrade Captain, gather your men and secure a perimeter!' - 'Churkin'
	CTRL.WAIT()
	
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025749) -- LOCDB [11025749] 'The fascists are pushing forward!'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025750) -- LOCDB [11025750] 'We must secure a perimeter before we can advance!'
--~ 	CTRL.WAIT()
end

EVENTS.Obj1_Katyushas = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025751) -- LOCDB [11025751] 'I have assigned some Katyushas to your command, Comrade Captain. They should prove useful in flushing the German rats out of the city.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	--TODO: added 2012-11-10
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046497) -- LOCDB [11046497] 'If our forward lines spot for them, they'll be much more effective!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.Obj1_Pioneers = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025753) -- LOCDB [11025753] ''Watch out! Pioneers!'' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Obj1_Arty = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025755) -- LOCDB [11025755] 'Incoming Artillery! Clear the area!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Obj1_HoldGround = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11025757) -- LOCDB [11025757] 'Hold your ground Comrades! Don't let them push us back!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.Obj1_Stug = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037789) -- LOCDB [11037789] 'Incoming Stug! We need anti-tank support!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.Obj1_Garrisons = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036345) -- LOCDB [11036345] 'They are taking cover in those buildings! Take them out!' - 'Soldier_02'
	CTRL.WAIT()
end


EVENTS.Order227_Retreat = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049558) -- LOCDB [11049558] 'Order 227 is in effect! Anyone who retreats will be shot on sight!' - 'Churkin'
	CTRL.WAIT()
end






--************************************************************************************************************************************************
-- 														OBJECTIVE 2 - Secure the bridges
--************************************************************************************************************************************************
EVENTS.Obj2_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11041930) -- LOCDB [11041930] 'Continue pushing forward and secure the bridges leading to the enemy stronghold.' - 'Churkin'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036346) -- LOCDB [11036346] 'Secure access to the bridges!' - 'Churkin'
--~ 	CTRL.WAIT()
end

EVENTS.Obj2_BridgeSecured = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046498) -- LOCDB [11046498] 'Sir, we have secured one of the bridges!' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046499) -- LOCDB [11046499] 'Excellent. Set up defenses and proceed to the second bridge.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Bridges_HateBunker = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036355) -- LOCDB [11036355] 'I fucking hate those bunkers!' - 'Soldier_01'
	CTRL.WAIT()
end




--************************************************************************************************************************************************
-- 													OBJECTIVE 3 - Stop counterAttack
--************************************************************************************************************************************************
EVENTS.ObjDefend_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036347) -- LOCDB [11036347] 'The fascists will not renounce control of this area without a fight.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046500) -- LOCDB [11046500] 'We have reports of German forces approaching your position. Do not let them push you back!' - 'Churkin'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036348) -- LOCDB [11036348] 'Gather your men and prepare for a counter-attack.' - 'Churkin'
--~ 	CTRL.WAIT()
end

EVENTS.ObjDefend_Tanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036349) -- LOCDB [11036349] 'I am sending T-34's to assist you.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036350) -- LOCDB [11036350] 'You can request armor reinforcements from our heavy factory.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjDefend_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036351) -- LOCDB [11036351] 'That seems to be the last of them...' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjDefend_WarnLoss = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11046501) -- LOCDB [11046501] 'We cannot afford to lose ground! Secure those territories at once!' - 'Churkin'
	CTRL.WAIT()
end


EVENTS.ObjDefend_Wave2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11037790) -- LOCDB [11037790] 'They're attacking one of our positions!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.ObjDefend_WarnTanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036353) -- LOCDB [11036353] 'Incoming tanks!' - 'Soldier_02'
	CTRL.WAIT()
end





--************************************************************************************************************************************************
-- 													OBJECTIVE 4 - Destroy the Enemy base
--************************************************************************************************************************************************
EVENTS.ObjAttack_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025758) -- LOCDB [11025758] 'This is where we turn the tide, Comrades!' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036354) -- LOCDB [11036354] 'Push forward and destroy the enemy base!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjAttack_MoreTanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025763) -- LOCDB [11025763] 'Additional T-34 tanks have been released to your command.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjAttack_Complete = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025764) -- LOCDB [11025764] 'Well done, Comrade. The Germans are almost finished in Stalingrad.' - 'Churkin'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025752) -- LOCDB [11025752] 'Well done, Comrade Captain. This section of the city is now under our control.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjAttack_Panzer = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025765) -- LOCDB [11025765] 'Watch out, Panzer tank!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.ObjAttack_Panzer2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11049559) -- LOCDB [11049559] 'Another Panzer tank!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.ObjAttack_FinalPush = function()
	--TODO:added 2012-11-28
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046502)  -- LOCDB [11046502] 'Forward, Comrades! Into their base!' - 'Soldier_03'
	CTRL.WAIT()
end





--************************************************************************************************************************************************
-- 													BONUS 1 - Locate enemy howitzers
--************************************************************************************************************************************************
EVENTS.ObjArty_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025766) -- LOCDB [11025766] 'The Germans have set up Artillery somewhere within the area.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036356) -- LOCDB [11036356] 'Locate and destroy it' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjArty_Outro = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025768) -- LOCDB [11025768] 'Excellent work, Comrade Captain. Now use those Howitzers against the fascists.'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036357) -- LOCDB [11036357] 'Excellent work, Comrade Captain. This will give us some room to breathe.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjArty_Howitzer1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025769) -- LOCDB [11025769] 'That's one of the emplacements. Locate the second one.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjArty_Incoming = function()
	local t_lines = {
		{
			id = 11037792, -- LOCDB [11037792] 'Incoming artillery!' - 'Soldier_01'
			char = ACTOR.Russian_Soldier_01,
		},
		{
			id = 11037793, -- LOCDB [11037793] 'Artillery fire! Take cover!' - 'Soldier_02'
			char = ACTOR.Russian_Soldier_02,
		},
--~ 		{ --Removed 2012-11-28
--~ 			id = 11037794, -- LOCDB [11037794] 'Incoming!' - 'Soldier_03'
--~ 			char = ACTOR.Russian_Soldier_03,
--~ 		},
	}
	local line = t_lines[World_GetRand(1, #t_lines)]
	
	CTRL.Actor_PlaySpeech(line.char, line.id)
	CTRL.WAIT()
end

EVENTS.ObjArty_Locked = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037795) -- LOCDB [11037795] 'They've got a lock on our position! We need to move!' - 'Soldier_03'
	CTRL.WAIT()
end




--************************************************************************************************************************************************
-- 													BONUS 2 - Secure northern bridge
--************************************************************************************************************************************************
EVENTS.ObjBridge_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025770) -- LOCDB [11025770] 'Comrade Captain, there is a third bridge to the North.' - 'Churkin'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025771) -- LOCDB [11025771] 'If you can secure it, I will be able to send additional reinforcements to assist you.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ObjBridge_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025772) -- LOCDB [11025772] 'Well done, Comrade Captain. Reinforcements are on the way.' - 'Churkin'
	CTRL.WAIT()
end




--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025762) -- LOCDB [11025762] 'Comrade Captain, you will now launch your counter attack.'

--~ EVENTS.Obj1_Defend = function() --Removed 2012-12-14
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025754) -- LOCDB [11025754] 'Excellent work, Comrade. I'm sending in reinforcements to hold the area.'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.Obj1_Flammer = function() --Removed
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025756) -- LOCDB [11025756] 'Flammenwagen! Fall back! Fall back!'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.Obj2_AT = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11025760) -- LOCDB [11025760] 'We must clear the roads before we can push forward. Take care of those AT guns!'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.Obj2_Reinforcements = function() --Not used
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11025761) -- LOCDB [11025761] 'Reinforcements coming in!'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.ObjDefend_Flank = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036352) -- LOCDB [11036352] 'They're attacking our flanks!' - 'Soldier_02'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.GiveArtillery = function()--No longer used. 2012-11-06
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11036344) -- LOCDB [11036344] 'I am authorizing artillery support in your area. Use it wisely, Comrade.' - 'Churkin'
--~ 	CTRL.WAIT()
--~ end