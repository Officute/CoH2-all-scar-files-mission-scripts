EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b02")
	g_MissionSpeechPath = "theater_of_war/b02"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049355) -- LOCDB [11049355] "The southern pincer in the German drive to Moscow faltered and broke against the Soviet defenders around Tula. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049356) -- LOCDB [11049356] "Every advance made by the Second Panzer Army found an answer in Soviet counterattacks. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049357) -- LOCDB [11049357] "This road to Moscow was closed."
	CTRL.WAIT()
end



