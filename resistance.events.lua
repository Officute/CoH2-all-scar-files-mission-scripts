EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/b03")
	g_MissionSpeechPath = "theater_of_war/dlc1/b03"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11052318) -- LOCDB [11052318] "Even with the Germans controlling up to ninety percent of the city at one point, the Red Army refused to back down."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11052319) -- LOCDB [11052319] "Their tenacity would eventually prevail against the German invader, turning the tide of the entire war."
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11052320) -- LOCDB [11052320] "The fighting in Stalingrad would continue throughout the fall and winter, with the Soviets sacrificing all to hold on to the city."
	CTRL.WAIT()
end



