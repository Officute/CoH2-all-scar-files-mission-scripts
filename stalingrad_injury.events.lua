EVENTS = {}

function Init_Audio()

	Sound_PreCacheSinglePlayerSpeech("mission/m06")
	g_MissionSpeechPath = "mission/m06"
	
end

Scar_AddInit(Init_Audio)

g_nisEnded = false

EVENTS.Intro = function ()
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.WAIT()
	_postIntro_startMission()
end

EVENTS.SitRep = function ()
	Game_SetMode(UI_Fullscreen)
	Game_Letterbox(true, 0)
	CTRL.SitRep_PlayMovie("m06_sitrep")
	CTRL.WAIT()
	Rule_Add(Mission_MissionStart)
	UI_SetCPMeterVisibility(false)
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	Game_FadeToBlack(FADE_IN, 1.5)
	FOW_EnableTint(true)
end

EVENTS.NIS01 = function ()
	Game_SetMode(UI_Cinematic)
	
	CTRL.SitRep_PlayMovie("m06_cin01")
	CTRL.WAIT()
	
	Rule_AddOneShot(NIS01_Complete, 1)
end

EVENTS.NIS02 = function ()
	Game_SetMode(UI_Cinematic)
	CTRL.SitRep_PlayMovie("m06_cin02")
	CTRL.WAIT()
	Game_FadeToBlack(FADE_OUT,0)
	Game_EndSP(true)
end

EVENTS.MissionStart = function()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11040295)  -- LOCDB [11040295] 'We have our orders. My squad will search the area for German maps and documents.' - 'Isakovich'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11040296)  -- LOCDB [11040296] 'Your task is to find and eliminate the enemy snipers. Clear us a safe path back to headquarters, comrade.' - 'Isakovich'
	CTRL.WAIT()	
end

-- Objective 1
EVENTS.SniperUpdate1 = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11031944) -- LOCDB [11031944] 'That's one sector cleared of snipers.' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.SniperUpdate2 = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11031952) -- LOCDB [11031952] 'Another sector cleared.' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.Flavor1 = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046839) -- LOCDB [11046839] 'Look, someone left behind their underwear.' - 'Soviet_Soldier_02'
	CTRL.WAIT()
end

EVENTS.Flavor2 = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11046840) -- LOCDB [11046840] 'These Germans are really getting on my tits!' - 'Soviet_Soldier_03'
	CTRL.WAIT()
end

EVENTS.GermanTanks = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11049530) -- LOCDB [11049530] 'That tank is crippled; look at the turret. It's no threat to us for now.' - 'Soviet_Soldier_02'
	CTRL.WAIT()
end

-- Objective 2
EVENTS.Injury = function()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11022325) -- LOCDB [11022325] 'We have to go back for the Captain.  The Nazis don’t even know he’s there.' - 'soviet_soldier_#2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11022326) -- LOCDB [11022326] 'Are you sure, Yuri?' - 'soviet_soldier_#3'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11022327) -- LOCDB [11022327] 'I watched from cover—they moved on past the building, thinking everyone was dead.' - 'soviet_soldier_#2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11022328) -- LOCDB [11022328] 'The Germans haven’t left the area.  If we’re spotted, we’ll be in the shit.' - 'soviet_soldier_#3'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11022329) -- LOCDB [11022329] 'Sergei Mikhailovich, you know we can do this.  And the Captain would do it for us.' - 'soviet_soldier_#2'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11022330) -- LOCDB [11022330] 'All right.  But we’re on our own--the new Major’s a hard ass, he’d never permit a rescue.' - 'soviet_soldier_#3'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11022331) -- LOCDB [11022331] 'What he does not know, comrade...' - 'soviet_soldier_#2'
	CTRL.WAIT()
end

EVENTS.Injury_Short = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11046440) -- LOCDB [11046440] 'We have to go back for the Captain. The Nazis don't even know he's there!' - 'Yuri'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046441) -- LOCDB [11046441] 'Are you certain, Yuri? Major Polivanov will not permit a rescue attempt.' - 'Soviet_Soldier_03'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Yuri, 11046442) -- LOCDB [11046442] 'They haven't seen him; I'm certain. We must free the Captain! I won't leave him to die!' - 'Yuri'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11046443) -- LOCDB [11046443] 'As you say, Yuri. Find an engineer. We go to free the Captain.' - 'Soviet_Soldier_03'
	CTRL.WAIT()
end

EVENTS.Eliminate = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11047032) -- LOCDB [11047032] 'Clear the sector of German forces!' - 'Soviet_Soldier_02'
	CTRL.WAIT()
end

-- Objective 3
EVENTS.ReachSuccess = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031947) -- LOCDB [11031947] 'The engineers are working to free Captain Isakovich. Hold this sector until we can move the Captain.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.ReachFail = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031946) -- LOCDB [11031946] 'Comrade Isakovich is dead...we couldn't reach him in time.' - 'ACTOR.Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.DefendSuccess = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031949) -- LOCDB [11031949] 'We've almost cleared the rubble. Just hold on.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.DefendFail = function()
	EGroup_Kill(eg_ikeBuilding)
	Rule_AddOneShot(_killDiggingEngineers, 2)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11049528) -- LOCDB [11049528] 'Engineers taking fire! We can't free the captain!' - 'Soviet_Engineer'
	CTRL.WAIT()
end

_killDiggingEngineers = function()
	SGroup_Kill(sg_nearIke)
end

EVENTS.TruckArrival = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031948) -- LOCDB [11031948] 'Commander, a support truck is on the way to help defend Comrade Isakovich.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.StukaBomber = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036710) -- LOCDB [11036710] 'Stuka bomber incoming! Clear the central plaza!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.IkeUpdate_01 = function ()
	CTRL.Event_Delay(1)
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036711) -- LOCDB [11036711] 'We are exploring a compound east of your position. Keep us safe, comrades.' - 'Isakovich'
	CTRL.WAIT()
end

EVENTS.IkeUpdate_02 = function ()
	CTRL.Event_Delay(1)
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036712) -- LOCDB [11036712] 'Commander, we've found a German command post but no sign of the enemy.' - 'Isakovich'
	CTRL.WAIT()
end

EVENTS.IkeUpdate_03 = function ()
	CTRL.Event_Delay(1)
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036713) -- LOCDB [11036713] 'Thank you for seeing to those German snipers.' - 'Isakovich'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Isakovich, 11036714) -- LOCDB [11036714] 'My squad will gather up intel and return to HQ shortly.' - 'Isakovich'
	CTRL.WAIT()
end

EVENTS.GermanMaxim_01 = function ()
	if scartype(g_HMG1_captureSgroup) == ST_SGROUP then
		if SGroup_Count(g_HMG1_captureSgroup) > 0 then
			Sound_Play3D("speech/sp/mission/m06/11036715", EGroup_GetSpawnedEntityAt(eg_atgun_reinforce, 1))
		end
	end
end

EVENTS.GermanMaxim_02 = function ()
	if scartype(g_HMG2_captureSgroup) == ST_SGROUP then
		if SGroup_Count(g_HMG2_captureSgroup) > 0 then
			Sound_Play3D("speech/sp/mission/m06/11036716", EGroup_GetSpawnedEntityAt(eg_hmg_reinforce, 1))
		end
	end
end

-- Secondary Objective 1
EVENTS.StartSecondary = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11031951) -- LOCDB [11031951] 'Recon has located fuel and weapon caches nearby. Retrieve them to bolster our supplies.' - 'Russian_Commissar'
	CTRL.WAIT()
end

-- Dec. 5, 2012
EVENTS.TimerStart_Obj2 = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046436) -- LOCDB [11046436] 'Get to Isakovich! German troops are closing in!' - 'Soviet_Soldier_02'
	CTRL.WAIT()
end

EVENTS.ResourcesRetrieved = function ()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11046437) -- LOCDB [11046437] 'We've found a crate of anti-tank grenades. Share them with our conscripts and penal squads.' - 'Soviet_Soldier_04'
	CTRL.WAIT()
end

function _endNIS()
	if not g_nisEnded then
		nis_stop()
		Game_Letterbox(false, 3)
		Camera_ResetToDefault()
		Camera_FocusOnPosition(Marker_GetPosition(mkr_playerStart), false)
		g_nisEnded = true
	end
end

function _ikeGarrison()
	Util_GarrisonNearbyBuilding(sg_tempIke, Marker_GetPosition(mkr_introIke), 10)
end


