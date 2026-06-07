EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/t03")
	g_MissionSpeechPath = "theater_of_war/t03"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()

	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040385 ) -- LOCDB [11040385] 'Commanders-'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040386 ) -- LOCDB [11040386] 'The Soviets are trying to retake Rostov.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040387 ) -- LOCDB [11040387] 'It is up to you to stop them.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040388 ) -- LOCDB [11040388] 'Both armies are prepared to commit heavy resources to the fight.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040389 ) -- LOCDB [11040389] 'In the event that you lose control of one of the Victory Points, additional materiel will arrive from the reserves.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040390 ) -- LOCDB [11040390] 'Be warned: The enemy is likely to employ the same tactic, so expect fierce counter-attacks after taking an enemy point.'
	CTRL.WAIT()
	
end

EVENTS.Point = function()
end

EVENTS.Reinforcements1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040391 ) -- LOCDB [11040391] 'Additional troops are arriving from at the front.'
	CTRL.WAIT()
end

EVENTS.Reinforcements2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040392 ) -- LOCDB [11040392] 'More soldiers are now at your disposal, Commander.'
	CTRL.WAIT()
end

EVENTS.Resources1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040393 ) -- LOCDB [11040393] 'Additional resources are now at your disposal.'
	CTRL.WAIT()
end

EVENTS.Resources2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040394 ) -- LOCDB [11040394] 'Supplies have arrived at the front.'
	CTRL.WAIT()
end

EVENTS.SovietReinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11040395 ) -- LOCDB [11040395] 'Soviet troops are massing in response.'
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049430) -- LOCDB [11049430] "The First Panzer Army deflected the first attempts to retake Rostov, but the Soviet enemy was implacable."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049431) -- LOCDB [11049431] "Although they inflicted heavy losses, the Wehrmacht would be forced to pull out of the city by the end of November."
	CTRL.WAIT()
end



