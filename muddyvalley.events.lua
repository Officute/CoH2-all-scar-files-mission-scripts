EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b08")
	g_MissionSpeechPath = "theater_of_war/dlc2/b08"
end

Scar_AddInit(Init_Audio)
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055101)	-- LOC("Operation Gallop saw the Soviet Red Army push the Southwest Front back through the Donbas region, south of Kharkov.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055102)	-- LOC("The Wehrmacht were pushed back almost all the way to Zaporizhia, where their headquarters were located.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055103)	-- LOC("After reorganizing the remains of the Sixth Army into a new Army Group South, the Germans were ready to launch their counterattack.")
	CTRL.WAIT()
end



