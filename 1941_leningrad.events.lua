EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b07")
	g_MissionSpeechPath = "theater_of_war/b07"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049366) -- LOCDB [11049366] "The Wehrmacht's ability to hold Leningrad in a noose would remain unchallenged until the beginning of 1943."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049367) -- LOCDB [11049367] "Even then, the Soviets would only manage to lift the siege in the beginning of 1944."
	CTRL.WAIT()
end



