EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b08")
	g_MissionSpeechPath = "theater_of_war/b08"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049368) -- LOCDB [11049368] "The Second Panzer Army crossed the Oka in its efforts to drive to Moscow."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049369) -- LOCDB [11049369] "Stanlinogorsk would fall on 22 November and the chances of taking Tula and then Moscow grew."
	CTRL.WAIT()
end


