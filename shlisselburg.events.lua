EVENTS = {}

function Init_Audio()

	Sound_PreCacheSinglePlayerSpeech("mission/m07")
	g_MissionSpeechPath = "mission/m07"
	
end

Scar_AddInit(Init_Audio)

EVENTS.NIS00 = function ()
	Game_SetMode(UI_Cinematic)
	CTRL.SitRep_PlayMovie("m07_cin01")
	CTRL.WAIT()
	Game_ScreenFade(255, 255, 255, 255, 0)
	Sound_PlayMusic("streamed/music/missions/m07/m07_cue_start_cross_river", 0, 0)
	Rule_AddOneShot(_startIntroNislet, 1.5)
end

_startIntroNislet = function ()
--~ 	Util_StartNIS(NIS02, nil, nil, nil, NIS00_revertUIMode, nil, true)
	Game_FadeToBlack(FADE_IN, 0)
	Util_StartIntel(EVENTS.IntroNislet)
	NIS00_Complete()
end

EVENTS.IntroNislet = function ()
	CTRL.Scar_PlayNIS(NIS02)
	CTRL.WAIT()
	NIS00_revertUIMode()
end


EVENTS.SitRep = function ()
	Game_ScreenFade(0, 0, 0, 0, 0)
	Rule_AddOneShot(_focusOnSU76, 1.9)
	Util_PlayMovie("m07_sitrep", 2, 2, Obj1_cutToSU76s, nil, true)
end

_focusOnSU76 = function ()
	Obj1_moveObstructionSquads()
	Camera_FocusOnPosition(Util_GetPosition(mkr_suDest2), false)
end

EVENTS.NIS00Complete = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031953) -- LOCDB [11031953] 'Cross that damn river and hold position on the eastern bank! Use Molotovs and grenades to clear trenches.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.MortarComplete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031954) -- LOCDB [11031954] 'Armor support incoming. Push forward and capture the German HQ! Use the SU-76's barrage to demolish German garrisons.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.BreachComplete = function()
	CTRL.WAIT()
end

EVENTS.ArtyOnHQ = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049537) -- LOCDB [11049537] 'The remaining German howitzer is targeting our headquarters!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DefendStart = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031955) -- LOCDB [11031955] 'The Germans are preparing a counter-attack. Fortify this territory and weather the assault.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DefendTankArrival = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031956) -- LOCDB [11031956] 'German armor incoming.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DefendAlmostDone = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031957) -- LOCDB [11031957] 'This will be their last push. Hold the sector.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DestroyStart = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031958) -- LOCDB [11031958] 'We've destroyed the bulk of their armor. Clear out the remaining enemy garrisons and Shlisselburg is ours.' - 'Commissar'
	CTRL.WAIT()
	Util_Autosave(nil, 7)
end

EVENTS.Breakthrough = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031959) -- LOCDB [11031959] 'The 2nd Shock Army is breaking through on the Volkhov Front.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.DestroyComplete = function()
	Game_SetMode(UI_Cinematic)
	FOW_RevealAll()
	Sound_SetMusicCombatValue(2, 25)
	M07_OutroSquads()
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.SUB()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031960) -- LOCDB [11031960] 'That's done it. The remaining German forces are falling back. We can begin re-building supply lines into Leningrad.' - 'Commissar'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	nis_stop()
	Game_FadeToBlack(FADE_OUT,0)
	Game_EndSP(true)
end


EVENTS.HighGround = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031961) -- LOCDB [11031961] 'Our allies from the 2nd Shock Army are nearly past the German defenses. Capture high-ground territory to hasten their advance.' - 'Commissar'
	CTRL.WAIT()
end

--

EVENTS.LosingHQ = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036717) -- LOCDB [11036717] 'Hold the German HQ! We must prevent the enemy from reinforcing!' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.LostHQ = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036718) -- LOCDB [11036718] 'We've lost the German headquarters. Enemy reinforcements are closing in...' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.Pak43 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11036719) -- LOCDB [11036719] 'Deal with that Pak-43 before it destroys our armor! Flank and eliminate the crewmen.' - 'Commissar'
	CTRL.WAIT()
end

EVENTS.SU76_Arrival = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11036720) -- LOCDB [11036720] 'SU-76 assault guns reporting in. We can shell the enemy from range, commander.' - 'SU-76 Crewman'
	CTRL.WAIT()
end

EVENTS.German_Panic_01 = function()
	FOW_RevealSGroupOnly(sg_e_howitzer, 10)
	Sound_PlayOnSquad("speech/sp/mission/m07/11036721", sg_e_howitzer) -- LOCDB [11036721] 'Scheisse! Barrage the rocket trucks before they crack our defenses!' - 'Howitzer Crewman'
end

EVENTS.German_Panic_02 = function()
	Sound_Play3D("speech/sp/mission/m07/11036722", EGroup_GetSpawnedEntityAt(eg_vp, 1))
	CTRL.WAIT()
end

EVENTS.German_Panic_03 = function()
	Sound_Play3D("speech/sp/mission/m07/11036723", EGroup_GetSpawnedEntityAt(eg_vp, 1))
	CTRL.WAIT()
end

EVENTS.German_Panic_04 = function()
	Sound_Play3D("speech/sp/mission/m07/11036724", g_panicSoundEntity)
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	Sound_Play3D("speech/sp/mission/m07/11036725", g_panicSoundEntity)
	CTRL.Event_Delay(8)
	CTRL.WAIT()
end

EVENTS.SecondHowitzer = function()
	CTRL.Event_Delay(7)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049531)-- LOCDB [11049531] 'Another German howitzer is barraging our ally's command post. Destroy or capture that weapon.' - 'Commissar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049532)-- LOCDB [11049532] 'Friendly artillery will cover the riverbank with a decoy barrage, to suppress the enemy.' - 'Commissar'
	CTRL.WAIT()
end
