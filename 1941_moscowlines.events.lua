EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b03")
	g_MissionSpeechPath = "theater_of_war/b03"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049358) -- LOCDB [11049358] "By holding back the drive to encircle Moscow, the capital’s defenders would ultimately change the course of the whole war. "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11049359) -- LOCDB [11049359] "From that bitter winter onward, the Soviet Union would slowly push the invaders back."
	CTRL.WAIT()
end



