EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/b02")
	g_MissionSpeechPath = "theater_of_war/dlc1/b02"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051869) -- LOCDB [11051869] 'The Wehrmacht repelled early probing attacks across the Don River, but Army Group B never managed to consolidate its defenses.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051870) -- LOCDB [11051870] 'The Soviets' Operation Uranus would overwhelm these weakened flanks, ultimately trapping the Eighth Army in Stalingrad and reversing all the German gains of Case Blue.' - 'German Officer'
	CTRL.WAIT()
end



