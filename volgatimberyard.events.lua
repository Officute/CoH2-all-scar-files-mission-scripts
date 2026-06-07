EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b07")
	g_MissionSpeechPath = "theater_of_war/dlc2/b07"
end

Scar_AddInit(Init_Audio)
	

EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055098)	-- LOC("After a number of defeats in Kharkov, the Soviet army had retreated to the Donets River.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055099)	-- LOC("Even though the Red Army managed to halt any further advance throughout the region, the Wehrmacht managed to capture Belgorod on the 18th March.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055100)	-- LOC("After months of fierce fighting, exhaustion on both sides led to the end of offensives in the region until the Battle of Kursk in July 1943")
	CTRL.WAIT()
end



