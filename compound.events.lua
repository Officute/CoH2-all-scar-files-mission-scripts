EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc2/b05")
	g_MissionSpeechPath = "theater_of_war/dlc2/b05"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function ()

end
	
EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055093)	-- LOC("The offensive to retake Kharkov began with the Wehrmacht’s attack from the west, but their advance was stopped amidst very heavy fighting by the Red Army’s defenders and a heavy screen of anti-tank guns.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055094)	-- LOC("The Soviets ultimately launched a number of futile counterattacks against elite German forces. Pockets of stiff Soviet resistance continued for several days before being slowly eliminated.")
	CTRL.WAIT()
end



