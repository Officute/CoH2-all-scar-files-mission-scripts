EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b04")
	g_MissionSpeechPath = "theater_of_war/b04"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049360) -- LOCDB [11049360] "Soviet victories were few and far between during the opening month of Barbarossa. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049361) -- LOCDB [11049361] "The heroic struggle of encircled Soviet general Ivan Boldin to fight his way back to the Soviet lines showed an early glimmer of the spirited defenses to come."
	CTRL.WAIT()
end



