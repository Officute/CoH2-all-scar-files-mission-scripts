EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b02")
	g_MissionSpeechPath = "theater_of_war/dlc2/b02"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055085)	--	LOC("The Panzergrenadier Division Groﬂdeutschland returned to the front lines in early March, as the German Army pushed north towards Kharkov.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055086)	--	LOC("The Red Army tried valiantly to hold ground, but the Wehrmacht managed to split the Soviet forces and encircle the city.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055087)	--	LOC("On the 11th March, the German forces launched attacks into the city's northern suburbs.")
	CTRL.WAIT()
end



