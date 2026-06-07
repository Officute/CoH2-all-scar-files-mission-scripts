EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/b06")
	g_MissionSpeechPath = "theater_of_war/b06"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049364) -- LOCDB [11049364] "The Wehrmacht's Army Group South would take Kharkov by October 24th, securing the critical flanks of the advancing attack on Moscow."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11049365) -- LOCDB [11049365] "This drove the Red Army back and set the stage for the later battle for Stalingrad."
	CTRL.WAIT()
end



