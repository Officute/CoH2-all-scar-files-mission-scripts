EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b06")
	g_MissionSpeechPath = "theater_of_war/dlc2/b06"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055095) -- LOCDB [11055095] "The Red Army was under attack from multiple directions. The best individual Divisions could do was to provide resistance against a frontal assault on Kharkov."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055096) -- LOCDB [11055096] "The German Army, however, pushed up past the western side of Karkhov and encircled it from the north."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055097) -- LOCDB [11055097] "Kharkov would be recaptured by the Germans soon after."
	CTRL.WAIT()
end



