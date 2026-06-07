EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/b01")
	g_MissionSpeechPath = "theater_of_war/dlc1/b01"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051871) -- LOCDB [11051871] "Soviet high command pulled back from its assault on Kharkov on May 28th, leaving at least 200,000 men trapped in the so-called "Barvenkovo mousetrap". "
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051872) -- LOCDB [11051872] "Even with the Germans controlling up to ninety percent of the city at one point, the Red Army refused to back down."
	CTRL.WAIT()
end



