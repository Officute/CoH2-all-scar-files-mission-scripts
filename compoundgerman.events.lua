EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b01")
	g_MissionSpeechPath = "theater_of_war/dlc2/b01"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function ()

end
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055083)	--	LOC("After repelling a Soviet counterattack in the suburbs of Kharkov, German forces were able to flank a major anti-tank obstacle, take the Soviet defenders by surprise, and open a path for tanks to cross.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055084)	--	LOC("The German forces were able to advance to the city’s main railway station before once again meeting stalwart resistance.")
	CTRL.WAIT()
end



