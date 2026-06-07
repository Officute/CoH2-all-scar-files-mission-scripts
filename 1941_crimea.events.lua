EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b05")
	g_MissionSpeechPath = "theater_of_war/b05"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049362) -- LOCDB [11049362] "Moving quickly and striking hard, the German Eleventh Army broke through the Isthmus of Perekop and drove across the Crimea with great speed."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049363) -- LOCDB [11049363] "Only Sevastopol would hold out against invasion, resisting until July of 1942."
	CTRL.WAIT()
end



