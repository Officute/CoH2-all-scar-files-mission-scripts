EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b04")
	g_MissionSpeechPath = "theater_of_war/dlc2/b04"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055091)	--	LOC("Wehrmacht forces were able to wedge aside two Soviet Armies, before turning east to encircle the city of Kharkov.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11055092)	--	LOC("Despite attempts by the Red Army to halt the German advance by throwing in a Rifle Division and a supporting Tank Brigade, the German drive to Kharkov continued.")
	CTRL.WAIT()
end



