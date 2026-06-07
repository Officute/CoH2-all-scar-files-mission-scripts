--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- NIS File for Best
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

g_MissionSpeechPath = "mission/m03"

function NIS_Init()

	NIS01 = "sp/CoH2_Campaign/M03-Moscow_Outskirts/nis/m03_intro_cut"
	nis_load(NIS01)
	NIS02 = "sp/CoH2_Campaign/M03-Moscow_Outskirts/nis/m03_t34Reveal"
	nis_load(NIS02)
	NIS03 = "sp/CoH2_Campaign/M03-Moscow_Outskirts/nis/m03_outro"
	nis_load(NIS03)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0.5)

end

Scar_AddInit(NIS_Init)

function Init_Audio()

	Sound_PreCacheSinglePlayerSpeech("mission/m03")
	g_MissionSpeechPath = "mission/m03"
	
end

Scar_AddInit(Init_Audio)



EVENTS = {}

--------------------------------------------------------------------------------
-- Opening Cinematic (NIS01)
--------------------------------------------------------------------------------

EVENTS.Intro = function ()
	SGroup_EnableAttention(sg_p_conscript01, false)
	Game_FadeToBlack(FADE_IN, 0)
	Game_SetMode(UI_Cinematic)
	Rule_AddOneShot(_delayedSubText, 3)
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.WAIT()
	_delayedStartSitrep()
end

_endIntroNIS = function ()
	Game_SubTextFade(11048265, 11048266, 0, 0, 0)
	Game_FadeToBlack(FADE_OUT, 0)
	g_sitrepStarted = true
	
	Util_PlayMovie("m03_sitrep", 1, 1, _delayedRevertUIMode, nil, true)
	SGroup_EnableAttention(sg_p_conscript01, true)
end

_delayedSubText = function ()
	if not g_sitrepStarted then
		Game_SubTextFade(11008180, 11008182, 0.5, 4, 0.5)
	end
end

_delayedRevertUIMode = function ()
	if Prox_AreSquadMembersNearMarker(sg_p_conscriptIntro, mkr_p_RDG_conscript_03, ANY, 5) == false then
		Squad_WarpToPos(SGroup_GetSpawnedSquadAt(sg_p_conscriptIntro, 1), Marker_GetPosition(mkr_p_RDG_conscript_01))
		Squad_WarpToPos(SGroup_GetSpawnedSquadAt(sg_p_conscriptIntro, 2), Marker_GetPosition(mkr_p_RDG_conscript_02))
		Squad_WarpToPos(SGroup_GetSpawnedSquadAt(sg_p_conscriptIntro, 3), Marker_GetPosition(mkr_p_RDG_conscript_03))
		Cmd_Stop(sg_p_conscriptIntro)
	end
	SGroup_DestroyAllSquads(sg_a_introTruck1)
	SGroup_DestroyAllSquads(sg_a_introTruck2)
	SGroup_Destroy(sg_a_introTruck1)
	SGroup_Destroy(sg_a_introTruck2)
	Mission_OBJ_HLR_DelayStart()
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
	UI_SetCPMeterVisibility(false)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(1000000)
	local select = function (gid, idx, sid)
		Misc_SelectSquad(sid, true)
	end
	SGroup_ForEach(sg_p_conscriptIntro, select)
	Game_FadeToBlack(FADE_IN, 0)
end

_delayedStartSitrep = function ()
	Rule_AddOneShot(_endIntroNIS, 0.5)
end

EVENTS.NIS01 = function()
	Game_SetMode(UI_Fullscreen)
	Game_Letterbox(true, 0)
	EGroup_Hide(LAYER_NIS_M03_CIN01, true)

	CTRL.SitRep_PlayMovie("m03_cin02")
	CTRL.WAIT()
--~ 	CTRL.SitRep_PlayMovie("m03_cin02")
--~ 	CTRL.WAIT()
	nis_stop()
	
	EGroup_Hide(LAYER_NIS_M03_CIN01, false)
end

EVENTS.NIS02 = function()

	Game_SetMode(UI_Fullscreen)
	Game_Letterbox(true, 0)
	FOW_Enable(false)
	
	EGroup_Hide(LAYER_NIS_M03_CIN02, true)
	
	CTRL.SitRep_PlayMovie("m03_cin04")
	CTRL.WAIT()
	
	nis_stop()
	
	Camera_ResetToDefault()
	Camera_SetInputEnabled(true)
	EGroup_Hide(LAYER_NIS_M03_CIN02, false)
	
	FOW_Enable(true)
	Game_Letterbox(false, 2)
	Game_SetMode(UI_Normal)
	
end

EVENTS.NIS03 = function()

	Game_SetMode(UI_Fullscreen)
	Game_Letterbox(true, 0)
	FOW_Enable(false)
	
	EGroup_Hide(LAYER_NIS_M03_CIN03, true)
	
	CTRL.Scar_PlayNIS(NIS03)
	CTRL.WAIT()
	
	nis_stop()
	Game_FadeToBlack(FADE_OUT,0)
	Game_EndSP(true)
	
end

------------
-- RIDGE
------------
t_events = {}

-- SIT REP
m03_sitrep_onComplete = function ()
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
	Camera_ResetToDefault()
	Camera_SetSlideTargetRate(1000000)
	local select = function (gid, idx, sid)
		Misc_SelectSquad(sid, true)
	end
	SGroup_ForEach(sg_p_conscriptIntro, select)
	FOW_EnableTint(true)
end

EVENTS.HTP_Start = function()
	Game_SetMode(UI_Fullscreen)
--~ 	Util_PlayMovie("m03_sitrep", 1, 3, m03_sitrep_onComplete, nil, true)
end

-- FIRST WAVE - RIDGE
EVENTS.RIDGE_COLD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035350) -- LOCDB [11035350] 'I'm freezing out here. Let's shoot these krauts and get back to the village.' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.GERMANS_APPROACHING = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, 11035351) -- LOCDB [11035351] 'Push forward! Clear the Soviet trenches!' - 'GERMAN_GRENADIER'
	CTRL.WAIT()
end

EVENTS.RIFLE_GRENADE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11049526) -- LOCDB [11049526] 'They have rifle grenades! Stay alert!' - 'Soviet_Soldier_01
	CTRL.WAIT()
end

-- SOUTH
EVENTS.RDG_LEFT_INCOMING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008119) -- LOCDB [11008119] 'Contact! South road!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_LEFT_INCOMING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008120) -- LOCDB [11008120] 'Germans! South access road!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_LEFT_INCOMING_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008121) -- LOCDB [11008121] 'They're pushing on the south!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Left_Incoming = {EVENTS.RDG_LEFT_INCOMING_01, EVENTS.RDG_LEFT_INCOMING_02, EVENTS.RDG_LEFT_INCOMING_03}

EVENTS.RDG_LEFT_FALLING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008122) -- LOCDB [11008122] 'Reinforce the southern position!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_LEFT_FALLING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008123) -- LOCDB [11008123] 'The south is being overwhelmed!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Left_Falling = {EVENTS.RDG_LEFT_FALLING_01, EVENTS.RDG_LEFT_FALLING_02}

EVENTS.RDG_LEFT_LOST = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008124) -- LOCDB [11008124] 'We have lost the south; re-take it quickly, before they press their advantage!' - 'COMMISSAR'
	CTRL.WAIT()
end

-- MID
EVENTS.RDG_MID_INCOMING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008125) -- LOCDB [11008125] 'Central road, we have incoming!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_MID_INCOMING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008126) -- LOCDB [11008126] 'They are coming down the central road!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_MID_INCOMING_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008127) -- LOCDB [11008127] 'The central position is under attack!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Mid_Incoming = {EVENTS.RDG_MID_INCOMING_01, EVENTS.RDG_MID_INCOMING_02, EVENTS.RDG_MID_INCOMING_03}

EVENTS.RDG_MID_FALLING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008128) -- LOCDB [11008128] 'Defenses on the central position are failing!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_MID_FALLING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008129) -- LOCDB [11008129] 'The Central Road needs aid!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Mid_Falling = {EVENTS.RDG_MID_FALLING_01, EVENTS.RDG_MID_FALLING_02}

EVENTS.RDG_MID_LOST = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008130) -- LOCDB [11008130] 'We have lost the center!  Re-take it quickly, before they press their advantage!' - 'COMMISSAR'
	CTRL.WAIT()
end

-- RIGHT
EVENTS.RDG_RIGHT_INCOMING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008131) -- LOCDB [11008131] 'German contact on the northern pass!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_RIGHT_INCOMING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008132) -- LOCDB [11008132] 'Northern pass, we have contact!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT() 
end

EVENTS.RDG_RIGHT_INCOMING_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008133) -- LOCDB [11008133] 'Contact! North!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Right_Incoming = {EVENTS.RDG_RIGHT_INCOMING_01, EVENTS.RDG_RIGHT_INCOMING_02, EVENTS.RDG_RIGHT_INCOMING_03}

EVENTS.RDG_RIGHT_FALLING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008134) -- LOCDB [11008134] 'The north pass is breaking!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RDG_RIGHT_FALLING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008135) -- LOCDB [11008135] 'Commander, north pass needs help!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end
t_events.RDG_Right_Falling = {EVENTS.RDG_RIGHT_FALLING_01, EVENTS.RDG_RIGHT_FALLING_02}

EVENTS.RDG_RIGHT_LOST = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008136) -- LOCDB [11008136] 'We have lost the north pass, re-take it quickly, before they press their advantage!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.MAXIM_DOWN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008137) -- LOCDB [11008137] 'Maxim gunner down. Re-crew that MG.' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.MAXIM_DOWN_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008138) -- LOCDB [11008138] 'Commander, get someone on that HMG - now!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.FLAME_PIONEER_SPOTTED = function()
	EventCue_Create(CUE.ATTACKED, 11008282, 11008282, sg_pioneers_flame)
	ThreatArrow_CreateGroup(sg_pioneers_flame)
	hint_firstFlamethrower = HintPoint_Add(sg_pioneers_flame, true, 11008282)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11045571) -- LOCDB [11045571] 'Enemy flamethrower! Fire!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.PANZER_GRENADER_SEEN = function()
	EventCue_Create(CUE.ATTACKED, 11007025, 11007025, SGroup_FromName("sg_e_RDG_wave3_PG"))
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008139) -- LOCDB [11008139] 'Panzer Grenadiers to the north! Suppress them before they can grenade our trenches!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.PANZER_GRENADER_REMIND_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008207) -- LOCDB [11008207] 'Use the HMG to suppress those Panzer Grenadiers!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.PANZER_GRENADER_REMIND_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008208) -- LOCDB [11008208] 'Quick, suppress the Panzer Grenadiers with the HMG!' - 'COMMISSAR'
	CTRL.WAIT()
end
t_events.Suppress_PG = {EVENTS.PANZER_GRENADER_REMIND_01, EVENTS.PANZER_GRENADER_REMIND_02}

EVENTS.MORE_MAXIMS_ENROUTE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008140) -- LOCDB [11008140] 'We are deploying additional Maxim squads to the ridge, commander.' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.MORE_MAXIMS_ARRIVE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008141) -- LOCDB [11008141] 'Maxim HMGs on site.' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.TANK_SPOTTED = function()
	EventCue_Create(CUE.ATTACKED, 11024608, 11024608, SGroup_FromName("sg_e_RDG_pnzrIII_04"))
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11045572) -- LOCDB [11045572] 'German tanks! Get down!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.FRONTOVIKI_UNLOCK = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	g_MissionSpeechPath = "mission/global"
	CTRL.Actor_PlaySpeech(ACTOR.None, 11049588) -- LOCDB [11049588] 'German tanks! Get down!' - 'Russian_Soldier_01'
	g_MissionSpeechPath = "mission/m03"
	CTRL.WAIT()
end


EVENTS.HTP_UpdateToVillage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008142) -- LOCDB [11008142] 'We cannot hold the ridge against these numbers; commander, pull back your forces and begin to shore up defenses in the village' - 'COMMISSAR'
	CTRL.WAIT() 
end

EVENTS.HTP_FRIENDLY_ARTILLERY_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008143) -- LOCDB [11008143] 'We are dropping artillery to cover your withdraw!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.HTP_FRIENDLY_ARTILLERY = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008144) -- LOCDB [11008144] 'Blyad! The artillery's coming up too short!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.HTP_Arty_CeaseFire = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008145) -- LOCDB [11008145] 'All batteries, cease fire! You are hitting friendlies!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.RECON_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008146) -- LOCDB [11008146] 'Contact!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.RECON_ATTACK = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008147) -- LOCDB [11008147] 'A probe attack - testing our defenses.' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.STUG_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008148) -- LOCDB [11008148] 'Enemy tanks are coming in. We have AT guns in the village; get them to the front line!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.ATGUN_REMINDER = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036705) -- LOCDB [11036705] 'Get a crew on those anti-tank guns! Now!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.ICE_COMMENT_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035352) -- LOCDB [11035352] 'Keep them on the ice!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.ICE_COMMENT_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035353) -- LOCDB [11035353] 'Sink the panzers! Break the ice with grenades or demolitions!' - 'RUSSIAN_SOLDIER_02'
	CTRL.WAIT()
end

EVENTS.ICE_COMMENT_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046684) -- LOCDB [11046684] 'Hah! Look at Fritz going for a swim!' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.ARTILLERY_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008149) -- LOCDB [11008149] 'Incoming artillery! Get down!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.CRAZY_ATTACK_BEGIN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049520) -- LOCDB [11049520] 'Steel yourselves, comrades! Enemy forces are rallying to overwhelm the village.' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.ARTILLERY_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008151) -- LOCDB [11008151] 'Another barrage - they have zeroed us in!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.OVERWHELM_ATTACK_BEGIN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008152) -- LOCDB [11008152] 'Another wave! All forces, fall back and defend the headquarters!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.DESPERATION_01 = function()
	-- This line was not recorded :(
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022203) -- LOCDB [11008153] 'Where are those fucking reinforcements?!' - 'RUSSIAN_SOLDIER_01'
	CTRL.WAIT()
end

EVENTS.DESPERATION_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11049527) -- LOCDB [11049527] 'There is no end to them. We cannot hold!' - 'Soviet_Soldier_01
	CTRL.WAIT()
end

EVENTS.T34s_ARRIVE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022205) -- LOCDB [11008156] 'Now is our chance - the T-34s are pushing deep into the enemy lines.' - 'COMMISSAR'
	CTRL.WAIT()
end


EVENTS.T34s_OUT_OF_AMMO = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11022208) -- LOCDB [11022208] 'Comrade Lieutenant, we’re low on fuel and out of ammunition.  We’ve been ordered to the rear to resupply.' - 'tank_commander'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11022209) -- LOCDB [11022209] 'I will leave mopping up to you.  Good work holding them here for us.' - 'tank_commander'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11022210) -- LOCDB [11022210] 'Thank you Comrade Captain! The bastards will not forget this day!' - 'isakovich'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11022211) -- LOCDB [11022211] 'Do svidaniya, Comrade Lieutenant. And good luck!' - 'tank_commander'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11022212) -- LOCDB [11022212] 'Forward men!  Let’s finish these dogs!  Hur RAH!' - 'isakovich'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.Russian_Soldier_01, 11022213) -- LOCDB [11022213] 'Hur RAH!' - 'cheering_troops'
	CTRL.WAIT()
end

---- RETAKE THE RIDGE ----
EVENTS.RTR_Start = function()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11022212) -- LOCDB [11022212] 'Forward men!  Let’s finish these dogs!  Hur RAH!' - 'isakovich'
	CTRL.WAIT()
end

EVENTS.RTR_Complete = function()
	g_missionIsComplete = true
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049525) -- LOCDB [11049525] 'Mtsensk is secure. Well done, comrades. The fascists will learn to fear Soviet armor!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.RTR_GermanArty = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049521) -- LOCDB [11049521] 'German howitzers are still barraging the village. Get our T-34s to the ridge and smash those fucking guns!' - 'Churkin'
	CTRL.WAIT()
end 

EVENTS.RTR_Urge_01 = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049524) -- LOCDB [11049524] 'Those Panzers are no match for T-34s. Flank them and reclaim the ridge!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.RTR_Urge_02 = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049523) -- LOCDB [11049523] 'Gather your forces! Lead the way with armour and crush the enemy!' - 'Churkin'
	CTRL.WAIT()
end

EVENTS.RTR_Urge_03 = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Churkin, 11049522) -- LOCDB [11049522] 'What are you waiting for, Commander? Finish them!' - 'Churkin'
	CTRL.WAIT()
end

-- TO BE SORTED
EVENTS.ENGINEERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008169) -- LOCDB [11008169] 'Commander, engineers are ready to set up defenses in the village.' - 'COMMISSAR'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046932) -- LOCDB [11046932] 'In addition, Guards Rifle Infantry are now available from the Kampaneya.' - 'Commissar'
	CTRL.WAIT()
	Objective_Start(OBJ_DefendCapturePointsTIMER, false)
end

EVENTS.GUARD_LMG = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046842) -- LOCDB [11046842] 'We need more firepower! Requisition Light Machine Guns for our Guards Rifle Infantry.' - 'Commissar'
	CTRL.WAIT()
end 

EVENTS.GERMANS_ALMOST_HERE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11008171) -- LOCDB [11008171] 'Comrade, the Germans will be upon us soon.' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.LOSS_TIMER_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036706) -- LOCDB [11036706] 'The Germans are overtaking the ridge! Push them back!' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046529)  -- LOCDB [11046529] 'Fight to reclaim the sector! Do not submit!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.LOSS_TIMER_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036707) -- LOCDB [11036707] 'We are losing the village! Repel the enemy infantry!' - 'Russian_Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046530) -- LOCDB [11046530] 'If we cannot hold a sector, we must fight to retake it!' - 'COMMISSAR'
	CTRL.WAIT()
end

EVENTS.MISSION_LOST_RIDGE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036708) -- LOCDB [11036708] 'The ridge is overwhelmed! Mtsensk is lost...' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.MISSION_LOST_VILLAGE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036709) -- LOCDB [11036709] 'The Germans have taken the village! Mtsensk is lost...' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.GermanFlamer1 = function()
	HintPoint_Remove(hint_firstFlamethrower)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036749) -- LOCDB [11036749] 'Take that German flamethrower!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.GermanMortars = function()
	EventCue_Create(CUE.ATTACKED, 11006677, 11006677, sg_e_ridgeMortar)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036752) -- LOCDB [11036752] 'German mortars in the woods! Push up and take them out, quickly!' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.ATvsInfantry = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046569) -- LOCDB [11046569] 'Focus your anti-tank guns on enemy armor.' - 'COMMISSAR'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11046570) -- LOCDB [11046570] 'Use high-explosive rounds against infantry targets.' - 'COMMISSAR'
	CTRL.WAIT()
end
