EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b01")
	g_MissionSpeechPath = "theater_of_war/b01"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049353) -- LOCDB [11049353] "Although the Wehrmacht would take Minsk by the end of June, the encircled defenders continued fighting across Belorussia. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049354) -- LOCDB [11049354] "They inflicted heavy German casualties and allowed almost a quarter-million troops to escape the pockets and fight another day."
	CTRL.WAIT()
end



