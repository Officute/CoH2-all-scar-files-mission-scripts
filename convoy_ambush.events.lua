print("\tLoading .events file...")
-- IntelEvents Table Container.
--	This contains all Regular IntelEvent functions (simple dialogue).
EVENTS = {}

-- NIS events table container.
--[[	Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. 
		These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic. ]]--
NIS_EVENTS = {}



--[[********************************************************************************************************]]
------------------------------------------ NIS EVENTS -----------------------------------------------------
--[[********************************************************************************************************]]




--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE_1 Escort the truck -------------------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "" MISSION "Convoy_Ambush" CHARACTER "American Riflemen"
EVENTS.ObjReunite_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074540)	-- LOCDB [11074540] 'Johnson, where the HELL are we? Where's the rest of the convoy?' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074541)	-- LOCDB [11074541] 'Are we lost? We're lost, aren't we?' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, 11074542)	-- LOCDB [11074542] 'We're NOT lost, dammit! The convoy is on the other side of this town... I think.' - 'American Engineer'
	CTRL.WAIT()
end

EVENTS.PlayerAtExit = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074543)	-- LOCDB [11074543] 'The truck is at the Exit Point! Get everyone else here!' - 'American Riflemen'
	CTRL.WAIT()
end

EVENTS.MissionFailure = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074544)	-- LOCDB [11074544] 'Shit! We've lost the truck! Let's get the hell out of here!' - 'American Riflemen'
	CTRL.WAIT()
end

EVENTS.MissionSuccess = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074545)	-- LOCDB [11074545] 'Well, that's the last time I'm trusting you with directions, Johnson!' - 'American Riflemen'
	CTRL.WAIT()
end
