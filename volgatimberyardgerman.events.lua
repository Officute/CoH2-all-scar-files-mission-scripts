EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b03")
	g_MissionSpeechPath = "theater_of_war/dlc2/b03"
end

Scar_AddInit(Init_Audio)
	
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055088)	-- LOC("Fresh from victory in Kharkov the German army pushed east, driving the Red Army back across the Donets River.")) 
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055089)	-- LOC("The Soviet defences collapsed but deteriorating weather, combined with exhaustion, meant that the planned attack on the Kursk salient could not go ahead.")) 
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055090)	-- LOC("Retaking Kursk would have to wait until Operation Citadel, several months later.")) 
	CTRL.WAIT()
end



