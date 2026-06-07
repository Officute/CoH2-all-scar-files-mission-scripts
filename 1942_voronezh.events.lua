EVENTS = {}
	
function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/t02")
	g_MissionSpeechPath = "theater_of_war/dlc1/t02"
end

Scar_AddInit(Init_Audio)

EVENTS.Intro = function()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050531) -- LOCDB [11050531] 'Your orders are to take and hold the city of Voronezh, securing Army Group South’s advance toward Stalingrad.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050532) -- LOCDB [11050532] 'Our infantry have crossed to the eastern riverbank and into the city proper, but Panzer forces remain on the western side of the Don.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050533) -- LOCDB [11050533] 'We cannot take the city without getting our armor across the river.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050534) -- LOCDB [11050534] 'Capture a bridgehead, move armor into the city, and overwhelm the Soviet defenders.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.AttackWarning1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050542) -- LOCDB [11050542] 'Scouts report that a force of Bolshevik light armor is approaching out Panzer headquarters.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.AttackWarning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050543) -- LOCDB [11050543] 'Soviet armor and elite infantry are moving to assault our Panzer headquarters!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.CityAttackWarning1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050545) -- LOCDB [11050545] 'Have a care: Light vehicles are moving into the city to repel our infantry!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.CityAttackWarning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050546) -- LOCDB [11050546] 'Soviet armor is mobilizing to assault our infantry headquarters!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.CityAttackWarning3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050547) -- LOCDB [11050547] 'Enemy forces are driving towards our infantry base!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.BridgeReminder = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050544) -- LOCDB [11050544] 'You must get those Panzers across the river! The infantry cannot hold the city alone!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.AllVpsCaptured = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050548) -- LOCDB [11050548] 'The Bolsheviks are breaking. Assault their command sector and finish this!'' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.FearPropaganda = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050800) -- LOCDB [11050800] 'The enemy fires artillery shells loaded with Bolshevik propaganda!' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050801) -- LOCDB [11050801] 'A coward’s tactic, but it will disrupt our infantry.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.ScorchedEarthStart = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050802) -- LOCDB [11050802] 'Soviet rockets trucks have been spotted in position to bombard strategic locations.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050803) -- LOCDB [11050803] 'Anticipate enemy bombardment of any contested territory.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.ScorchedEarth1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050804) -- LOCDB [11050804] 'Soviet artillery overwatch has begun!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.ScorchedEarth2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050805) -- LOCDB [11050805] 'Enemy rocket artillery commencing overwatch!' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.MineField = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050933) -- LOCDB [11050933] 'A Soviet mine field protects the southern river crossing.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051863) -- LOCDB [11051863] 'Dispatch a squad of Pioneers equipped for mine detection.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()
	FOW_RevealAll()
	Game_SetMode(UI_Cinematic)
	Sound_SetMusicCombatValue(2, 30)
	Game_FadeToBlack(FADE_OUT, 1)
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	CTRL.Scar_PlayNIS(NIS_OUTRO)
	Game_FadeToBlack(FADE_IN, 1)
	CTRL.SUB()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050535) -- LOCDB [11050535] 'By July 8th, Fourth Panzer Army had taken Voronezh.' - 'German Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050536) -- LOCDB [11050536] 'With its flank secure, Army Group South could now drive south along the Don River, toward the oil fields of the Caucasus and to Stalingrad.' - 'German Officer'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11050537) -- LOCDB [11050537] 'The opening strike of the Case Blue offensive was a success.' - 'German Officer'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	if AI_IsEnabled(player1) or AI_IsEnabled(player2) then
		Rule_RemoveIfExist(_outroComplete)
		_outroComplete()
	end
end
