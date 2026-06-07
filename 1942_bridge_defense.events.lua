EVENTS = {}

function Init_Audio()
	Sound_PreCacheSinglePlayerSpeech("theater_of_war/dlc1/c04")
	g_MissionSpeechPath = "theater_of_war/dlc1/c04"
end

Scar_AddInit(Init_Audio)
	
EVENTS.Intro = function() -- 010
	CTRL.Event_Delay(2)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051824 )
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052269 )
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051825 )
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051826 )
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051827 )
	CTRL.WAIT()
end

EVENTS.Point = function()
end

EVENTS.Return = function()
end

EVENTS.Bonus = function()-- 020
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051828 ) 
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052291 ) 
	CTRL.WAIT()
end

EVENTS.Bonus_Fail = function()-- 030
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051829 )  
	CTRL.WAIT()
end

EVENTS.Bonus_Transport = function()-- 040
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051830 ) 
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051831 )
	CTRL.WAIT()
end

EVENTS.Bonus_Transport_Complete = function() -- 050
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051832 )
	CTRL.WAIT()
end

EVENTS.Bonus_Transport_Fail = function() --060
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051833 )
	CTRL.WAIT()
end

EVENTS.Partisans = function()--070
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051843 ) -- LOCDB [11051843] 'My thanks, Comrade.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051844 ) -- LOCDB [11051844] 'My partisans are at your disposal.'
	CTRL.WAIT()
end

EVENTS.Ready_Up_01 = function()--080
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051834 )
	CTRL.WAIT()
end

EVENTS.Ready_Up_02 = function()--090
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051835 )
	CTRL.WAIT()
end

EVENTS.Ready_Up_03 = function()--100
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051836 )
	CTRL.WAIT()
end

EVENTS.Enemy_Capturing_Bridge = function()--110
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051837 )
	CTRL.WAIT()
end

EVENTS.Bridge_Neutral = function()--120
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051838)
	CTRL.WAIT()
end

EVENTS.Mission_Fail_Bridge_Lost = function()--130
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051839 )
	CTRL.WAIT()
end

EVENTS.Mission_Fail_Units_Lost = function()--140
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11051840 )
	CTRL.WAIT()
end

EVENTS.VPVictoryMessage = function()--150
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051841 )
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11051842 )
	CTRL.WAIT()
end
