EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/c01")
	g_MissionSpeechPath = "theater_of_war/dlc1/c01"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function()

	CTRL.SitRep_PlayMovie("tow_tigerace")
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 2)
	CTRL.WAIT()
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051814 ) -- LOCDB [11051814] 'Our offensive into the Caucasus continues, Commander.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051815 ) -- LOCDB [11051815] 'Use your new Tiger heavy tank to drive into the enemy protecting the road to Stalingrad.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051038 )-- LOCDB [11051038] 'Clearing enemy positions will gain you supplies and allow infantrymen to move in and secure the area.' - 'German Officer'
	CTRL.WAIT()

	
end

EVENTS.Point = function()
end

EVENTS.Return = function()
end


EVENTS.Minefield = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Panzer_Grenadier, 11040383 ) -- LOCDB [11040383] 'Beware! They've mined the area!' - 'German Soldier'
	CTRL.WAIT()
end

EVENTS.Area_Cleared = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051031 ) -- LOCDB [11051031] 'Well done. Infantry are moving in to secure the position.' - 'German Officer'
	CTRL.WAIT()
end
EVENTS.Area_Cleared_2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051032 ) -- LOCDB [11051032] 'Good. Grenadiers will secure that location.' - 'German Officer'
	CTRL.WAIT()
end
EVENTS.Area_Cleared_3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051816 ) -- LOCDB [11051816] 'Our infantry will take that position.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.Progress_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051817) -- LOCDB [11051817] 'Continue to clear the road so that our operation may continue.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.Progress_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051818) -- LOCDB [11051818] 'The road to Stalingrad is almost clear. Continue the good work.' - 'German Officer'
	CTRL.WAIT()
end

EVENTS.OBJRetal_01 = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051033) -- LOCDB [11051033] 'Soviet armored units are moving to your position, Commander.' - 'German Officer'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051819) -- LOCDB [11051819] 'Show them the power of German engineering.' - 'German Officer'
	CTRL.WAIT()	
end

EVENTS.OBJRetal_02 = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051034) -- LOCDB [11051034] 'Have a care: Additional enemy armor is moving in.' - 'German Officer'
	CTRL.WAIT()	
end

EVENTS.OBJFinale = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051035) -- LOCDB [11051035] 'Excellent work, but it is not over yet.' - 'German Officer'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051036) -- LOCDB [11051036] 'A large force of enemy tanks is headed for your position.' - 'German Officer'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051037) -- LOCDB [11051037] 'The Grenadiers now in position can provide support against the Soviet counterattack, but you must break them, Commander.' - 'German Officer'
	CTRL.WAIT()	
end

EVENTS.OBJFinale_Warning_01 = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051820) -- LOCDB [11051820] 'One of the Bolsheviks’ new KV-2 heavy tanks is arriving, Commander.' - 'German Officer'
	CTRL.WAIT()	
end

EVENTS.OBJFinale_Warning_02 = function()	
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051821) -- LOCDB [11051821] 'More Soviet heavy tanks inbound, Commander.' - 'German Officer'
	CTRL.WAIT()	
end


EVENTS.VPVictoryMessage = function()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051822) -- LOCDB [11051822] 'With the incomparable power of the Panzer Kampfwagon Tiger, the Wehrmacht broke the Soviet defenders and opened the road to Stalingrad.' - 'German Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.German_Officer, 11051823) -- LOCDB [11051823] 'For the remainder of the war, the Tiger would sow fear among Germany’s enemies.' - 'German Officer'
	CTRL.WAIT()
end


