--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
-- NIS File for Best
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

--g_MissionSpeechPath = "mission/m03"

function NIS_Init()

	NIS01 = "mp/community/IAC_E3_Barricade/nis/intro"
	nis_load(NIS01)
	NIS02 = "mp/community/IAC_E3_Barricade/nis/sniper"
	nis_load(NIS02)
	NIS03 = "mp/community/IAC_E3_Barricade/nis/park"
	nis_load(NIS03)
	
	nis_setintransitiontime(0.25)
	nis_setouttransitiontime(0.5)

end

Scar_AddInit(NIS_Init)

function Init_Audio()

	Sound_PreCacheSinglePlayerSpeech("mission/m01")
	-- Sound_PreCacheSinglePlayerSpeech("mission/m03")
	g_MissionSpeechPath = "mission/m01"
	
	g_music_barricade = "streamed/music/missions/m01/m01_cue_start.bsc"
	g_music_park = "streamed/music/missions/m01/m01_cue_take_howitzers.bsc"
	g_music_panzer = "streamed/music/missions/m01/m01_cue_take_panzer.bsc"
	g_music_railstation = "streamed/music/missions/m01/m01_cue_rail_station.bsc"
 	g_music = "streamed/music/missions/m01/m01_full.bsc"
	
	Sound_PreCacheSound("campaign/m01_german_soldiers_charge")
	Sound_PreCacheSound("speech/sp/mission/m01/ambient/m01_tank_lost")
	Sound_PreCacheSound("speech/sp/mission/m01/ambient/grenadier_retreat")
	
end

Scar_AddInit(Init_Audio)



EVENTS = {}

--------------------------------------------------------------------------------
-- Opening Cinematic (NIS01)
--------------------------------------------------------------------------------

EVENTS.Intro = function ()
	-- SGroup_EnableAttention(ai_conscripts_start, false)
	-- SGroup_Hide(ai_conscripts_start, true)
	
	Game_FadeToBlack(FADE_IN, 0)
	Game_SetMode(UI_Cinematic)
	Rule_AddOneShot(_delayedSubText, 7)
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.WAIT()
	_delayedStartSitrep()
	
end

_endIntroNIS = function ()
	-- Game_SubTextFade(11048265, 11048266, 0, 0, 0)
	Game_FadeToBlack(FADE_OUT, 0)
	g_sitrepStarted = true
	
	-- Util_PlayMovie("m03_sitrep", 1, 1, _delayedRevertUIMode, nil, true)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	Game_SetMode(UI_Normal)
	-- SGroup_EnableAttention(ai_conscripts_start, true)
	-- SGroup_Hide(ai_conscripts_start, false)
end

_delayedSubText = function ()
	if not g_sitrepStarted then
		Game_SubTextFade(11008180, 11008182, 0.5, 4, 0.5) -- First upper text/location, second is middle text/time
	end
end

_delayedStartSitrep = function ()
	Rule_AddOneShot(_endIntroNIS, 0.5)
end

------------
-- NIS02
------------

EVENTS.NIS_SNIPER = function()

	Game_SetMode(UI_Fullscreen)
	Game_Letterbox(true, 0)
	FOW_Enable(false)
	
	-- EGroup_Hide(LAYER_NIS_M03_CIN02, true)
	
	CTRL.Scar_PlayNIS(NIS02)
	CTRL.WAIT()
	
	nis_stop()
	
	Camera_ResetToDefault()
	Camera_SetInputEnabled(true)
	-- EGroup_Hide(LAYER_NIS_M03_CIN02, false)
	
	FOW_Enable(true)
	Game_Letterbox(false, 2)
	Game_SetMode(UI_Normal)
	
end

------------
-- NIS03
------------

EVENTS.NIS_PARK = function()
	
	-- Game_FadeToBlack(FADE_IN, 2.5)
	Game_SetMode(UI_Cinematic)
	
	-- FOW_RevealArea(Util_GetPosition(mkr_hmg_pin_hintPoint), 20, 8)
	-- Camera_MoveTo(sg_enemy_park_hmg, true, 0.4, false, false)
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046741)	-- LOCDB [11046741] 'Heavy Machine Gun north of the breach; they have the main route covered.' - 'Intel'
	CTRL.WAIT()
	-- Camera_MoveTo(sg_ally_park_01, true, 0.4, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046742)	-- LOCDB [11046742] 'Avoid his kill zone.' - 'Intel'
	CTRL.WAIT()
	-- CTRL.Actor_PlaySpeech(ACTOR.None, 11036255)	-- LOCDB [11036255] 'Flank the location and clear with grenades.' - 'Intel'
	-- CTRL.WAIT()
	-- Camera_MoveTo(sg_player_01, true, 0.4, false, true)
	-- CTRL.WAIT()
	
	-- Game_SetMode(UI_Normal)
	-- Game_EnableInput(true)
	-- Camera_SetInputEnabled(true)
	-- Camera_ResetToDefault()
	
end

------------
-- NIS04
------------

EVENTS.NIS_RAILWAY = function()
	
	--~ Game_FadeToBlack(FADE_IN, 2.5)
	Game_Letterbox(true, 2)
	
	-- FOW_RevealArea(Util_GetPosition(mkr_rail_entrance_hintPoint), 20, 8)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022142)		-- LOCDB [11022142] 'Good work, comrade captain. But we still have much to do.' - 'Polivanov'
	-- CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022138)	-- LOCDB [11022138] 'Well done. Our final challenge still lies before us.' - 'Polivanov'
 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022120)	-- LOCDB [11022120] 'Our goal is here, the rail-station. However, there are entrenched fascists in our path.' - 'Polivanov'
 	CTRL.WAIT()
	-- CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022139)		-- LOCDB [11022139] 'Gather your troops and assault the rail-station. For Stalin, for the Motherland!' - 'Polivanov'
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022109)	-- LOCDB [11022109] 'You will need machine-guns and mortars to clear the rats out of the railway station.' - 'Polivanov'
 	CTRL.WAIT()
	
	Game_Letterbox(false, 2)
	Game_EnableInput(true)
	Camera_SetInputEnabled(true)
	Camera_ResetToDefault()
	
end

EVENTS.NIS_END = function()
	--~ Game_FadeToBlack(FADE_IN, 3.0)
	Game_Letterbox( true, 2.5 )
	
	CTRL.Event_Delay(2.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022110)		-- LOCDB [11022110] 'Such Destruction...' - 'Soldier'
 	CTRL.WAIT()
	
	
end

--****************************
-- SPEECH --
--****************************

EVENTS.CLOSE_IN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11046653)	-- LOCDB [11046653] 'Close ground and tear them apart!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.INCOMING_STUKA = function()
	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11036242)	-- LOCDB [11036242] 'Incoming Stuka!' - 'Soldier_02'
	CTRL.WAIT()
end 

EVENTS.REINFORCEMENTS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036248)	-- LOCDB [11036248] 'Replacements, move up!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.BARRICADE_REMIND = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11036286)		-- LOCDB [11036286] 'Maybe we can flank their line - through the ruins to the east and west.' - 'Soldier_02'
 	CTRL.WAIT()
end

EVENTS.BARRICADE_END = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022136)		-- LOCDB [11036286] 'That was the last of them here - Get up, we have a city to take!' - 'Polivanov'
 	CTRL.WAIT()
end

------------
-- PARK
------------

EVENTS.CHARGE_01 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036250)		-- LOCDB [11036250] 'Charge! Drive the fascists from their holes!' - 'Commissar'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11046947)		-- LOCDB [11046947] 'Charge! Break the German line!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.CHARGE_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036250)		-- LOCDB [11036250] 'Charge! Drive the fascists from their holes!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.ENEMY_BREAKING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036253)	-- LOCDB [11036253] 'Their line is breaking, they run like cowards!' - 'Soldier_04'
	CTRL.WAIT()
end

EVENTS.ENEMY_BREAKING_02 = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11036287)		-- LOCDB [11036287] 'Keep it up! They're taking losses!' - 'Soldier_02'
 	CTRL.WAIT()
end

EVENTS.ENEMY_BREAKING_03 = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11048740)		-- LOCDB [11036287] 'Thats it, the Germans are starting to break!' - 'Soldier_04'
 	CTRL.WAIT()
end

EVENTS.HMG_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046743)	-- LOCDB [11046743] 'Get up there and flank that Heavy Machine Gun!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HMG_AMBIENT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11036257)		-- LOCDB [11036257] 'This HMG is chewing us apart!' - 'Soldier_03'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036258)		-- LOCDB [11036258] 'Keep advancing, comrade! He cannot stop you all!' - 'Commissar'
	CTRL.WAIT()
end

----------------------
-- AMBIENT SPEECH NAGS
-- 3D SPEECH FOR USE FROM SQUADS
----------------------
--~ park_ambient_speech_table = {11022127, 11022137, 11022144, 11036278, 11036280, 11036256, 11036248, 11036282}
-- In SCAR instead

EVENTS.HMG_AMBIENT_NAGS = function()
	Actor_PlaySpeechWithoutPortrait(ACTOR.Partisans, park_ambient_speech_table[World_GetRand(1, table.getn(park_ambient_speech_table))])		-- Incoming!  Get to some cover!
end
----------------------

EVENTS.HMG_SUPPRESSED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036259)	-- LOCDB [11036259] 'What are you doing? Stay out of its firing arc!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.HMG_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036476)		-- LOCDB [11036476] 'Their HMG is down - advance!' - 'Commissar'
	CTRL.WAIT()
	-- CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022107)		-- LOCDB [11022107] 'Excellent work comrades. Now we take the railway station.' - 'Polivanov'
 	-- CTRL.WAIT()
end

EVENTS.HMG_FLANK = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11048737)		-- LOCDB [11048737] 'Remember to flank them if you can!' - 'Commissar'
	CTRL.WAIT()
end

------------
-- PARK COUNTERATTACK
------------

EVENTS.BARRAGE_01_WARNING = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036265)		-- LOCDB [11036265] 'Another artillery barrage!' - 'Soldier_06'
 	CTRL.WAIT()
end

EVENTS.BARRAGE_01_WARNING_ALT = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022128)	-- LOCDB [11022128] 'Incoming fire. Take cover.' - 'Soldier_02'
 	CTRL.WAIT()
end

EVENTS.BARRAGE_02_WARNING = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036265)		-- LOCDB [11036265] 'Another artillery barrage!' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036266)	-- LOCDB [11036266] 'Close ground!' - 'Soldier_06'
	CTRL.WAIT()
end

EVENTS.BARRAGE_02_WARNING_ALT = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11036265)		-- LOCDB [11036265] 'Another artillery barrage!' - 'Soldier_06'
 	CTRL.WAIT()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036264)	-- LOCDB [11036264] 'Forward, they will not target close to their own!' - 'Commissar'
 	CTRL.WAIT()
end

EVENTS.OUT_OF_BOUNDS_PARK_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036281)	-- LOCDB [11036281] 'You will attack the German line, or you will die by my pistol!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.OUT_OF_BOUNDS_PARK_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11048730)	-- LOCDB [11048730] 'The germans are closing in, we must push them back!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.PICKUP_WEAPONS_01 = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11036283)	-- LOCDB [11036283] 'Pick up those weapons!' - 'Soldier_05'
 	CTRL.WAIT()
end

--~ EVENTS.PICKUP_WEAPONS_02 = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11036284)	-- LOCDB [11036284] 'We need those weapons!' - 'Soldier_05'
--~ 	CTRL.WAIT()
--~ end

EVENTS.PICKUP_WEAPONS_02 = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11022126)	-- LOCDB [11022126] 'We should get those dropped weapons and use them against the fascists.' - 'Soldier_05'
 	CTRL.WAIT()
end

EVENTS.PICKUP_WEAPONS_CMDR = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022105)	-- LOCDB [11022105] 'Pickup those weapons. Use them against the germans.' - 'Polivanov'
 	CTRL.WAIT()
end

EVENTS.PANZER_SPOTTED = function()
	EventCue_Create(CUE.ATTACKED, 11046815, 11046815, sg_enemy_panzer4, nil, _panToPanzer)	-- LOCDB [11046815] 'Panzer IV'
--~ 	ThreatArrow_CreateGroup(sg_e_panzer)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037841)		-- LOCDB [11037841] 'Panzer IV!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.PANZER_REMIND = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036270)		-- LOCDB [11036270] 'Comrade, a Panzer IV has been spotted in the ruins to the north.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11036271)		-- LOCDB [11036271] 'Locate an anti-tank weapon to use against it.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.PANZER_DEFLECT = function()
--~ 	Sound_SetMusicCombatValue(2, 60*99999999)
	Rule_Remove(_panzer_fire_Foward)
	Cmd_Stop(sg_enemy_panzer4)
	Cmd_Attack(sg_enemy_panzer4, sg_player_01, false, true)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11036276)	-- LOCDB [11036276] 'Chyort voz'mi! Deflection - fire again!' - 'Soldier_07'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11036277)	-- LOCDB [11036277] 'Oh no! It's turning! Fire!' - 'Soldier_07'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046831)	-- LOCDB [11046831] 'Shit, reload - hurry!' - 'Soldier_07'
	CTRL.WAIT()
end

EVENTS.PANZER_ALMOST_THERE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11047645)	-- LOCDB [11047645] 'Oh shit... shit, shit!' - 'Soldier_07'
	CTRL.WAIT()
end

EVENTS.PARK_WAVE2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11022143)		-- LOCDB [11036257] 'My god there are too many!' - 'Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Civilian, 11022144)		-- LOCDB [11036257] 'We must retreat!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.CONSCRIPTS_AVAILABLE = function()
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_05, 11041882)		-- LOCDB [11041882] 'You will need to press the attack with conscripts' - 'Commissar'
	CTRL.WAIT()
	UI_FlashAbilityButton(BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_conscript_dispatch"), true)
	-- CTRL.UI_NewHUDFeature(HUDF_AbilityCard, 11045531, "Icons_units_unit_soviet_conscript_03", 6)	-- LOCDB [11045531] 'Mobilize Conscripts are now available!'
end

EVENTS.PARTISANS_AVAILABLE = function()
	CTRL.WAIT()
	UI_FlashAbilityButton(BP_GetAbilityBlueprint("312430cd68d346ad8badb0bc1ef14b77:e3_barricade_rebel_dispatch"), true)
	-- CTRL.UI_NewHUDFeature(HUDF_AbilityCard, 11050421, "ModIcons_312430cd68d346ad8badb0bc1ef14b77_symbols_unit_soviet_rebels", 6)	-- LOCDB [11050421] 'Call in additional Partisans'
end

EVENTS.BERNOI_DEMO_MARK = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022113)	-- LOCDB [11022113] 'On my mark...' - 'Polivanov'
 	CTRL.WAIT()
end

EVENTS.BERNOI_DEMO_GO = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022114)	-- LOCDB [11022114] 'Charge!' - 'Polivanov'
 	CTRL.WAIT()
end

EVENTS.BERNOI_DEMO_AMBIENT = function()
 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022115)	-- LOCDB [11022114] 'Push them off every inch of ground, and do not stop until every invader lies dead at your feet!' - 'Polivanov'
 	CTRL.WAIT()
end

------------
-- TRAINSTATION
------------

EVENTS.BONUS_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022138)	-- LOCDB [11022138] 'Well done. Our final challenge still lies before us.' - 'Polivanov'
 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022139)		-- LOCDB [11022139] 'Gather your troops and assault the rail-station. For Stalin, for the Motherland!' - 'Polivanov'
	CTRL.WAIT()
end