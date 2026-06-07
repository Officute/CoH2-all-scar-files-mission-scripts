EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/b04")
	g_MissionSpeechPath = "theater_of_war/dlc1/b04"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11052321) -- LOCDB [11052321] 'Soviet high command pulled back from its assault on Kharkov on May 28th, leaving at least 200,000 men trapped in the so-called "Barvenkovo mousetrap".' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11052322) -- LOCDB [11052322] 'With this victory, the Wehrmacht regained the initiative, launching the ambition Case Blue summer offensive one month later.' - 'German Officer'
	CTRL.WAIT()
end



