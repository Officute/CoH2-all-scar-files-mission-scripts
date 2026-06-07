--Container
EVENTS = {}

--Example event
EVENTS.Intel_Event = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, LOC("This is an Intel Event"))
	CTRL.WAIT()
end

function NIS_Init()
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1) 
	NIS01 = "SP/CoH2_Campaign/M11-Behind_Enemy_Lines/nis/m11_ania_presentation" 
	nis_load(NIS01)
end 

function NIS_InitPost()
	NIS01Post = "SP/CoH2_Campaign/M11-Behind_Enemy_Lines/nis/m11_ania_PostPres02" 
	nis_load(NIS01Post)
end


Scar_AddInit(NIS_Init)
Scar_AddInit(NIS_InitPost)

function Init_Audio()
  
	Sound_PreCacheSoundFolder("single_player/m11") 
	Sound_PreCacheSinglePlayerSpeech("mission/m11")
	g_MissionSpeechPath = "mission/m11"
	
                
end

Scar_AddInit(Init_Audio)

-------------------------------------
-- NIS
-------------------------------------

--Intro cinematic
EVENTS.NIS_Intro = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	CTRL.SitRep_PlayMovie("m11_cin01a")
	CTRL.WAIT()
end

--End cinematic
EVENTS.NIS_End = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 1.8)
	
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	CTRL.SitRep_PlayMovie("m11_cin04")
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT, 0)
	Game_EndSP(true)
end

EVENTS.SIT_REP = function()
	CTRL.SitRep_PlayMovie("m11_sitrep")
	CTRL.WAIT()
	Camera_ResetToDefault()
	Camera_FocusOnPosition(Marker_GetPosition(mkr_startCameraTarget), true)
	
	Event_Timer(_postSitRep, nil, 1.5)
end

function _postSitRep()
	Game_FadeToBlack(FADE_IN, 2.5)
	Game_SetMode(UI_Normal)

end

--[[********************************************************************************************************]]
------------------------------------------------PRE OBJECTIVE ---------------------------------------------------
--[[********************************************************************************************************]]
EVENTS.IntroNislet = function()
	
	modID_OfficerIntro = Util_ApplyModifier(sg_officer_intro, "posture_speed_modifier", -1, MUT_Addition)
	
	SGroup_SetMoodMode(sg_officer_intro, MM_ForceCalm)
	Modify_WeaponEnabled(sg_officer_intro, "hardpoint_01", false)
	Cmd_SquadPath(sg_officer_intro,"patrol_officerIntro",true,LOOP_NONE,false,2)
	Squad_SetInvulnerableToCritical(SGroup_GetSpawnedSquadAt(sg_officer_intro, 1), true)
	Game_SubTextFade(11046690, 11046696, 0.5, 4, 0.5) -- LOCDB [11046690] 'Rural Poland' ,  -- LOCDB [11046696] 'August 1944'
	
	FOW_RevealSGroupOnly(sg_officer_intro, -1)
	startTime = World_GetGameTime()
	
	CTRL.Scar_PlayNIS(NIS01)
		Game_FadeToBlack(FADE_IN, 2.5)
		CTRL.SUB()	
			CTRL.Event_Delay(9)
			CTRL.WAIT()
			CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036689) -- LOCDB [11036689] 'I remember Ania as a fearless sniper and the most passionate soldier I'd ever met.' - 'Isakovich'
			CTRL.WAIT()
			CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036696) -- LOCDB [11036696] 'Passionate, but lacking compassion for the Germans invading her homeland.' - 'Isakovich'
			CTRL.WAIT()
			if Util_IsSequenceSkipped() == false then
				Cmd_Attack( sg_ania, sg_officer_intro ,false ,false ) 
				Event_IsUnderAttack(KillOfficer, nil, sg_officer_intro, ANY, 1)
			end
			CTRL.Event_Delay(3.5)
			CTRL.WAIT()
			CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036697) -- LOCDB [11036697] 'With each shot, a German dies. We cannot afford to miss.' - 'Ania'
			if Util_IsSequenceSkipped() == false then
				Sound_PlayOnSquad( "speech/sp/mission/m11/11036697", sg_ania )
			end
			CTRL.WAIT()
		CTRL.END()	
	CTRL.WAIT()
	if Util_IsSequenceSkipped() == false then
		StartSitRep()
	end
end
function KillOfficer()
	SGroup_Kill(sg_officer_intro)
end

EVENTS.Ania_Presentation = function()
	CTRL.Event_Delay(9)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036689) -- LOCDB [11036689] 'I remember Ania as a fearless sniper and the most passionate soldier I'd ever met.' - 'Isakovich'
	CTRL.WAIT()
end

EVENTS.Ania_Presentation03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036696) -- LOCDB [11036696] 'Passionate, but lacking compassion for the Germans invading her homeland.' - 'Isakovich'
	CTRL.WAIT()
end

EVENTS.Ania_Presentation04 = function()
	CTRL.Event_Delay(2.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036697) -- LOCDB [11036697] 'With each shot, a German dies. We cannot afford to miss.' - 'Ania'
	Sound_PlayOnSquad( "speech/sp/mission/m11/11036697", sg_ania ) 
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------------OBJECTIVE 1---------------------------------------------------
--[[********************************************************************************************************]]
EVENTS.Obj1_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036893) -- LOCDB [11036893] 'Move into position around the German camps.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036894) -- LOCDB [11036894] 'Target the officers first, then deal with any retaliating forces.' - 'Ania'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022465) --Once in position, snipers must take out German officers first, then deal with forces they send after us.  - 'Ania'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania,11022464) -- If we are spotted before we are in position, we die. - 'Ania'
--~ 	CTRL.WAIT()
end

EVENTS.Obj1_RemindReinforce = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035147) -- LOCDB [11035147] 'The dogs have called for help! Get to cover and prepare an ambush!' - 'Partisans'
	CTRL.WAIT()
end

EVENTS.Obj1_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11034471)  -- LOCDB [11034471] 'The German officers have been eliminated.' - 'Russian_Commissar'
	CTRL.WAIT()
end

EVENTS.Obj1_Target04TruckIntro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036736)  -- LOCDB [11036736] 'Ania, there's a German transport truck in that camp. If the enemy officer mobilizes, we'll never catch up on foot.' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036737)  -- LOCDB [11036737] 'Then we must immobilize or destroy the transport. Use a demolition charge if necessary.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036738)  -- LOCDB [11036738] 'Destroy the truck or place some demolition charges at the exit' - 'Ania'
	CTRL.WAIT()
end

EVENTS.Obj1_Target04TruckLeaving = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036747)  -- LOCDB [11036747] 'Enemy transport is on the move!' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036748)  -- LOCDB [11036748] 'Destroy it! Use explosives or take out the driver!' - 'Ania'
	CTRL.WAIT()
	
end

--[[********************************************************************************************************]]
------------------------------------------------OBJECTIVE 3---------------------------------------------------
--[[********************************************************************************************************]]
EVENTS.Obj3_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11034472) -- LOCDB [11034472] 'Ania must survive.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Obj3_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11034473) -- LOCDB [11034473] 'Ania survived' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.Obj3_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11034474) -- LOCDB [11034474] 'Ania! She's ... gone.' - 'Partisan'
	CTRL.WAIT()
end
	

--[[********************************************************************************************************]]
------------------------------------------------OBJECTIVE 2---------------------------------------------------
--[[********************************************************************************************************]]

EVENTS.Obj2_TrucksTowardsInformant = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11040534)   -- LOCDB [11040534] 'Follow the truck. It must be going towards the informant's camp' - 'Ania'
	CTRL.WAIT()

end

EVENTS.Obj2_SeeCampNear = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022461)   -- 11022461	The informant is in this camp. - 'Ania'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania,11022463) -- 11022463	My partisans will circle the camp, taking up positions here, here and here.
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania,11022464) -- 11022464	If we are spotted before we are in position, we die.
--~ 	CTRL.WAIT()
end

EVENTS.Obj2_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022466)   -- While the Germans are distracted, a few of us will move into the camp and grab the informant. - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania,11022467) -- Once we have the informant, we will disengage and meet up with Pozharsky and his men. - 'Ania'
	CTRL.WAIT()
end

EVENTS.Obj2_CoverUs = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022471)   -- Cover us, we are coming out! - 'Ania'
	CTRL.WAIT()
end


------ NEW LINE
EVENTS.Obj2_Reinforcements = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022444)   -- 11022444	Partisans have reported more German reinforcements on the way.	M10s03	soviet_senior_officer
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046689)   -- LOCDB [11046689] 'Scouts ahead! More squads will be following them!' - 'Russian_Senior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046685)   -- LOCDB [11046685] 'Set a demolition charge to surprise the approaching enemies.' - 'Partisans'
	CTRL.WAIT()
end

------ NEW LINE
EVENTS.Obj2_Reinforcements02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046697)   -- LOCDB [11046697] 'More scouts ahead coming from the other side!' - 'Russian_Senior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046686)   -- LOCDB [11046686] 'Set a demolition charge on that path.' - 'Partisans'
	CTRL.WAIT()
end

------ NEW LINE
EVENTS.Obj2_Reinforcements03_trucks = function()
	CTRL.Actor_PlaySpeech(ACTOR.Pozharsky, 11046698)   -- LOCDB [11046698] 'Trucks are coming your way. Be prepared!' - 'Pozharsky'
	CTRL.WAIT()
end


EVENTS.Obj2_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034475) -- LOCDB [11034475] 'We have the informant. Now find us a clear path out of here.' - 'Ania'
	CTRL.WAIT()
end

EVENTS.Obj2_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11034476) -- LOCDB [11034476] 'The informant is dead. You disappoint me, Ania.' - 'Russian_Senior_Officer'
	CTRL.WAIT()
end

EVENTS.Obj2_GoingInProtect = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036739) -- LOCDB [11036739] 'I'll find our talkative kolega, although he may need a little persuasion.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036740) -- LOCDB [11036740] 'Keep watch, and stay in cover.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036741) -- LOCDB [11036741] 'Ania, we have several allied squads concealed nearby.' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036742) -- LOCDB [11036742] 'Signal to them if necessary, but we must not draw unwanted attention.' - 'Ania'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE Liberate the Prisoners -------------------------------
--[[********************************************************************************************************]]

EVENTS.HelpPrisoners = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034477) -- LOCDB [11034477] 'Look there -- prisoners. Free them and we gain valuable allies.' - 'Ania'
	CTRL.WAIT()
end

EVENTS.ObjHelpPrisoners_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11040539) -- LOCDB [11040539] 'The informant told me there were some Polish prisoners in a camp nearby' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034478) -- LOCDB [11034478] 'Liberate those prisoners. Their knowledge of the camp could help us.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046937) -- LOCDB [11046937] 'But Ania...it's too dangerous. German troops have reinforced the area.' - 'Partisan'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11040540) -- LOCDB [11040540] 'We can't leave our own people behind. Let's go!' - 'Ania'
	CTRL.WAIT()
	
end

EVENTS.ObjHelpPrisoners_Direction = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11040331) -- LOCDB [11040331] 'Ania, there are dead partisans all around this path' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11040332) -- LOCDB [11040332] 'Seems like they were trying to escape' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11040333) -- LOCDB [11040333] 'Let's follow this path.  It must lead to the prison.' - 'Ania'
	CTRL.WAIT()
end

EVENTS.ObjHelpPrisoners_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046935) -- LOCDB [11046935] 'Thank you, Ania. We owe you a debt.' - 'Partisan'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046946) -- LOCDB [11046946] 'We've got their attention now. Get away from the alarm and take aim.' - 'Partisan'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046936) -- LOCDB [11046936] 'With a few borrowed German weapons, perhaps we can assist you.' - 'Partisan'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE Make sure informant doesnt die -------------------------------
--[[********************************************************************************************************]]
EVENTS.GetInformantToSafety = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035264) -- LOCDB [11035264] 'Make sure the informant gets to safety, my friends. We have a camp to secure.' - 'Ania'
	CTRL.WAIT()
end

--[[********************************************************************************************************]]
----------------------------------------------- OBJECTIVE Escape to extraction point -------------------------------
--[[********************************************************************************************************]]
EVENTS.EscapeIntelStart = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035265 ) -- LOCDB [11035265] 'Get to the rendezvous point.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035266) -- LOCDB [11035266] 'Surely more enemy troops have been alerted to our presence. Their numbers are too great.' - 'Partisans'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035267) -- LOCDB [11035267] 'Keep to the shadows and avoid direct conflict, but retaliate if you must.' - 'Ania'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035268) -- LOCDB [11035268] 'What of the informant?' - 'Partisans'
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035269) -- LOCDB [11035269] 'Bring him to the extraction point -- alive.' - 'Ania'
--~ 	CTRL.WAIT()
end

EVENTS.EscapeIntelComplete = function()
	
	if Player_GetSquadCount(player1) > 1 then
		CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035270 ) -- LOCDB [11035270] 'You're all here, and our loose-lipped friend still lives.' - 'Ania'
		CTRL.WAIT()
	end
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035271 ) -- LOCDB [11035271] 'Many Polish soldiers escaped the enemy camp thanks to our efforts.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035272 ) -- LOCDB [11035272] 'A successful operation. Now let us return to comrade Pozharsky.' - 'Ania'
	CTRL.WAIT() 
end



--[[********************************************************************************************************]]
----------------------------------------------- Battle preparations - SOVIETS -------------------------------
--[[********************************************************************************************************]]

EVENTS.NearCamp = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022469)   -- Hit them now! - 'Ania'
	CTRL.WAIT()
end


EVENTS.TakeMortarTeam = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11022470)   -- Take out the mortar team! - 'Ania'
	CTRL.WAIT()
end

EVENTS.NormalReinforcementsComing = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11034482) -- LOCDB [11034482] 'Enemy vehicles incoming!' - 'Partisans'
	CTRL.WAIT() 
end





--[[********************************************************************************************************]]
----------------------------------------------- Capture Fire Camps --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.FireCamp_Farm = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034483) -- LOCDB [11034483] 'We can start a fire to distract enemy troops.' - 'Ania'
	UI_CreateMinimapBlip( eg_fire01_farm_turnOn, 10, BT_CaptureHere ) 
	CTRL.WAIT()
end

EVENTS.FireCamp_ForestGuards = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034484) -- LOCDB [11034484] 'Look there. Light that campfire to distract the guards.' - 'Ania'
	CTRL.WAIT()
end



EVENTS.FireCamp_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036949) -- LOCDB [11036949] 'I have an idea.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036950) -- LOCDB [11036950] 'Get to cover; I'm going to light that campfire. We'll ambush the enemy when they investigate.' - 'Ania'
	CTRL.WAIT()
end


EVENTS.FireCamp_Camp03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034485) -- LOCDB [11034485] 'More fire pits. As before, ambush the enemy when they approach the fire.' - 'Ania'
	UI_CreateMinimapBlip( mkr_fire03_target03, 10, BT_CaptureHere ) 
	UI_CreateMinimapBlip( mkr_fire02_target03, 10, BT_CaptureHere ) 
	UI_CreateMinimapBlip( mkr_fire01_target03, 10, BT_CaptureHere ) 
	CTRL.WAIT()
end

EVENTS.InvestigatingFireGerman = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036952) -- LOCDB [11036952] 'Feuer im Freien. Stay alert.' - 'German_Soldier_01'
	CTRL.WAIT()
end

EVENTS.InvestigatingFire02German = function()
	--1CTRL.Actor_PlaySpeech(ACTOR.None, 11027494) -- I have a bad feeling about this
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036951) -- LOCDB [11036951] 'Who lit that fire?' - 'German_Soldier_02'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
--[[********************************************************************************************************]]
----------------------------------------------- Radio building ---------------------------------------------------
--[[********************************************************************************************************]]

EVENTS.RadioBuilding_ToDestroy = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11034486) -- LOCDB [11034486] 'Destroy that structure or seize the camp.' - 'Ania'
	CTRL.WAIT()
end

EVENTS.RadioBuilding_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035031) -- LOCDB [11035031] 'The Germans have a radio in that camp.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11040381) -- LOCDB [11040381] 'It is probably linked to an antenna somewhere in the forest.' - 'Ania'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11040382) -- LOCDB [11040382] 'If we can disable it, we'll have fewer enemy reinforcements to contend with.' - 'Ania'
	CTRL.WAIT()
	
end

EVENTS.RadioCamp_RunningTowards = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036701)  -- LOCDB [11036701] 'Ania, that officer is making for the radio!' - 'Partisans'
	CTRL.WAIT() 
end

--[[********************************************************************************************************]]
----------------------------------------------- German Retaliate --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.AttackThemGerman = function() -- too quiet
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036953) -- LOCDB [11036953] 'After them! Schnell!' - 'German_Soldier_03'
--~ 	Sound_Play3D( String name, EntityID actor ) 
--~ 	Sound_Play3D("speech/sp/mission/m01/11036236", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_a_docks_commissar_speech, 
--~ 1), 0))
	CTRL.WAIT()
end

EVENTS.StayAwayGerman = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036954) -- LOCDB [11036954] 'Show yourself you sneaky arschwurm!' - 'German_Soldier_04'
	CTRL.WAIT()
end

EVENTS.RunAfterGerman = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036955) -- LOCDB [11036955] 'Let's get them!' - 'German_Soldier_05'
	CTRL.WAIT()
end

EVENTS.RunAfter02German = function() -- no audio
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036956) -- LOCDB [11036956] 'Time to die you Slavic bastards!' - 'German_Soldier_06'
	CTRL.WAIT()
end

EVENTS.SniperStayGerman = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036957) -- LOCDB [11036957] 'Sniper!  Stay down!' - 'German_Soldier_07'
	CTRL.WAIT()
end

EVENTS.SniperPinnedGerman = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11036958) -- LOCDB [11036958] 'Sniper has us pinned! Verdammt  sniper!  - who deploys those bastards!' - 'German_Soldier_08'
	Sound_Play3D("speech/sp/mission/m11/11036958")
	CTRL.WAIT()
end

EVENTS.MortarGerman = function() -- no audio
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036959) -- LOCDB [11036959] 'Red Army target confirmed, Mortar' - 'German_Soldier_09'
	CTRL.WAIT()
end

EVENTS.CallReinforcementGerman = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11034487)  -- LOCDB [11034487] 'Ivan's in the camp! I will radio for support.' - 'German_Soldier_10'
	CTRL.WAIT() 
end

------------ Sniper sees your squad 
EVENTS.SniperSeesYou = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036703)  -- LOCDB [11036703] 'Enemy sniper!' - 'Partisans'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036704) -- LOCDB [11036704] 'Stay down! Use cover to approach, and eliminate that sniper.' - 'Ania'
--	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11035064)  -- LOCDB [11035064] 'We've been spotted! Remain in cover!'
	CTRL.WAIT() 
end

--[[********************************************************************************************************]]
----------------------------------------------- Infirmary --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.CaptureInfirmary = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11035032)  -- LOCDB [11035032] 'There's an infirmary in that camp. Capture it and we can re-purpose a few German medical supplies.' - 'Ania'
	CTRL.WAIT() 
end

--[[********************************************************************************************************]]
----------------------------------------------- Chatter between camps --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.VisitInfirmary = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036902)  -- LOCDB [11036902] 'Brother, you're wounded. You should return to the infirmary and make use of those German supplies.' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036903)  -- LOCDB [11036903] 'It is only a scratch...but thank you.' - 'Partisans'
	CTRL.WAIT() 
end

EVENTS.AloneInfirmary = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036904)  -- LOCDB [11036904] 'This wound is deep. Perhaps I should return to the infirmary.' - 'Ania'
	CTRL.WAIT() 
	
end

EVENTS.ThinkInfirmary = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036905)  -- LOCDB [11036905] 'The Germans must have medical supplies nearby.' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036906)  -- LOCDB [11036906] 'Look for an infirmary or medical camp, so we can bandage these wounds.' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036907)  -- LOCDB [11036907] 'Yes, Ania. I could do with a little less blood in my boots.' - 'Partisans'
	CTRL.WAIT() 
end

EVENTS.ChatterFiller = function()

	if Player_GetSquadCount(player1) > 1 then
		CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036908)  -- LOCDB [11036908] 'I am glad to have you with me, brothers. We do this bloody work for the good of Polska.' - 'Ania'
		CTRL.WAIT() 
		CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046938)  -- LOCDB [11036909] 'For Polska.' - 'Partisans'
		CTRL.WAIT() 
	end
end


EVENTS.ReinforcementComingFromBelow = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036912)  -- LOCDB [11036912] 'Ania! German reinforcements are coming!' - 'Partisans'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036913)  -- LOCDB [11036913] 'Where?' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11036914)  -- LOCDB [11036914] 'They approach from the south to investigate the camps we've cleared.' - 'Partisans'
	CTRL.WAIT() 
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036915)  -- LOCDB [11036915] 'Glad we are out of there' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11036916)  -- LOCDB [11036916] 'Press on. Our objective is close.' - 'Ania'
	CTRL.WAIT() 
end

--[[********************************************************************************************************]]
----------------------------------------------- Random lines --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.KeepOffRoads = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ania, 11041144)  -- LOCDB [11041144] 'Keep off the main road as much as possible, we don't want the enemy seeing us and calling for reinforcements.' - 'Ania'
	CTRL.WAIT() 
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11046939)  -- LOCDB [11046939] 'Alright. But if an enemy truck approaches, aim for the driver... then take care of any survivors.' - 'Partisan'
	CTRL.WAIT() 
end

--[[********************************************************************************************************]]
----------------------------------------------- Partisan need liberation --------------------------------------------
--[[********************************************************************************************************]]

EVENTS.LiberateUs01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11043110) -- LOCDB [11043110] 'Free us.' - 'Partisans'
	CTRL.WAIT()
end

EVENTS.LiberateUs02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11043111) -- LOCDB [11043111] 'Can you help us?' - 'Partisans'
	CTRL.WAIT()
end

EVENTS.LiberateUs03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Partisans, 11043112) -- LOCDB [11043112] 'They will kill us...help!!' - 'Partisans'
	CTRL.WAIT()
end