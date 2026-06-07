
EVENTS = {}

function Init_Audio()

	Sound_PreCacheSinglePlayerSpeech("mission/m10")
	g_MissionSpeechPath = "mission/m10"
	
end

Scar_AddInit(Init_Audio)

--------------------------------------------------------------------------------
-- Player loses at the Bridge Obj 
--------------------------------------------------------------------------------

EVENTS.SitRep = function ()
	Game_SetMode(UI_Cinematic)
	Util_PlayMovie("m10_sitrep", 2, 2)
	CTRL.WAIT()

	Game_SetMode(UI_Normal)
	CTRL.WAIT()
end

EVENTS.Intro = function ()
	Game_SetMode(UI_Cinematic)
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.WAIT()
	_delayedStartSitrep()
end

EVENTS.NIS02 = function ()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	CTRL.SitRep_PlayMovie("m10_cin05")
	CTRL.WAIT()
	
	Game_FadeToBlack(FADE_OUT, 0)
	Game_EndSP(true)
end

EVENTS.CaptureTerritories = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031962) -- LOCDB [11031962] 'We must force the Germans to fall back before we call for heavy armor support. Clear and capture the territories surrounding the castle.' - 'Senior_Officer'
	CTRL.WAIT()
end

----

EVENTS.TanksSpotted = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031974) -- LOCDB [11031974] 'Enemy tanks and armored support are stationed to the southeast. Command advises ZIS-3 and T-34 deployment.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.PanzerwerfersSpotted = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031963) -- LOCDB [11031963] 'Scouts report Panzerwerfer rockets to the northeast.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.FlaksSpotted = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11031964) -- LOCDB [11031964] 'The northwest is covered by fucking 88mm anti-tank guns.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

----

EVENTS.HQWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031965) -- LOCDB [11031965] 'Our HQ is under attack.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.ArtyHuntWarning = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11049535) -- LOCDB [11049535] 'Guard your mortars and artillery. The enemy will hunt them down.' - 'soviet_senior_officer'
	CTRL.WAIT()
end

EVENTS.DemolitionsWarning_01 = function()
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11049533) -- LOCDB [11049533] 'Enemy engineers approach our headquarters. They'll try to wire it with demolitions!' - 'soviet_senior_officer'
	CTRL.WAIT()
end

EVENTS.DemolitionsWarning_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11049534) -- LOCDB [11049534] 'German explosives on our HQ! Clear out!' - 'soviet_senior_officer'
	CTRL.WAIT()
end

EVENTS.PanzerwerferWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11031966) -- LOCDB [11031966] 'Panzerwerfer firing!' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.PanzerwerferWarning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036726) -- LOCDB [11036726] 'Rocket barrage! Clear the impact zone!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.ElefantWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031967) -- LOCDB [11031967] 'Elefant spotted! Keep your distance! The Elefant has remarkable range, but it is vulnerable to flanking by turreted tanks.' - 'Senior_Officer'
	CTRL.WAIT()
end

----

EVENTS.ProtectISUs = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031969) -- LOCDB [11031969] 'Protect the ISU-152s; they are vulnerable to panzerschrecks and swift German armor.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.ProtectISUs2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031970) -- LOCDB [11031970] 'German tanks are hunting our 152s. Keep them protected.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.ISUdestroyed1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031971) -- LOCDB [11031971] 'We've lost a 152! Keep the other safe; we have no replacements!' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.ISUdestroyed2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031972) -- LOCDB [11031972] 'We've lost the 152s. We can't breach the wall before the prisoners are executed.' - 'Senior_Officer'
	CTRL.WAIT()
end

----

EVENTS.SecondaryObj = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11031973) -- LOCDB [11031973] 'German infantry is approaching from the south to reinforce the castle. Cover the main road, and eliminate those troops.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.SecondaryObj_Won = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11036727) -- LOCDB [11036727] 'We have repelled most German reinforcements, and the castle's defenders are spread thin.' - 'Russian Senior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11036728) -- LOCDB [11036728] 'Anticipate less infantry resistance when we assault the castle.' - 'Russian Senior Officer'
	CTRL.WAIT()
end

EVENTS.SecondaryObj_Lost = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11036729) -- LOCDB [11036729] 'Many of the enemy's infantry reinforcements have reached the castle.' - 'Russian Senior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11036730) -- LOCDB [11036730] 'Prepare for greater infantry resistance when we make our assault.' - 'Russian Senior Officer'
	CTRL.WAIT()
end

----

EVENTS.AssaultTheCastle = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022442) -- LOCDB [11022442] 'It is time to assault the castle.  Use the ISU-152s to breach the gate from range.' - 'Senior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022443) -- LOCDB [11022443] 'We must move quickly if we wish to save any of our comrades being held inside.' - 'Senior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022444) -- LOCDB [11022444] 'Partisans have reported more German reinforcements on the way.' - 'Senior_Officer'
	CTRL.WAIT()
	--- CHECKPOINT AUTOSAVE THING #2 ---
	Util_Autosave(nil, 7)
end

EVENTS.CastleTaken = function()
	FOW_RevealAll()
	Sound_SetMusicCombatValue(2, 30)
	Game_FadeToBlack(FADE_IN,0.5)
	CTRL.Scar_PlayNIS(NIS04)
	Game_SetMode(UI_Cinematic)
	CTRL.SUB()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022445) -- LOCDB [11022445] 'Well done, comrades!  The castle is ours!' - 'Senior_Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11022446) -- LOCDB [11022446] 'Comrade Colonel, the prisoners in the castle were killed by the Germans, but the fascists say there’s a camp nearby where more of our men are being held.' - 'Tank_Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11022447) -- LOCDB [11022447] 'I believe other units are clearing that area now, Captain.  We must hope it’s not too late for those prisoners.' - 'Senior_Officer'
		CTRL.WAIT()
		Game_FadeToBlack(FADE_OUT,1)
		Rule_AddOneShot(outro_startMajdanekNIS, 1.5)
	CTRL.END()
	CTRL.WAIT()
end

function outro_startMajdanekNIS()
	Util_StartNIS(EVENTS.NIS02)
end

--

EVENTS.StukaWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11036731) -- LOCDB [11036731] 'German bombers! Keep away from the castle!' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11036732) -- LOCDB [11036732] 'We'll breach the castle wall from range when the 152s arrive.' - 'Russian Senior Officer'
	CTRL.WAIT()
end

EVENTS.BarrageWarning = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, 11036733) -- LOCDB [11036733] 'Howitzer barrage! Get down!' - 'Panzer Grenadier'
	CTRL.WAIT()
end
