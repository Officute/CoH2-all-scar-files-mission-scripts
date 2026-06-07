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
------------------------------------------ OBJECTIVE_1 Protect the tank -------------------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "" MISSION "Tank_Escort" CHARACTER "American Riflemen"
EVENTS.OBJ_MainObjective = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, 11074560)	-- LOCDB [11074560] 'Our engine is crippled but we're still combat effective.' - 'American Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, 11074561)	-- LOCDB [11074561] 'You guys scout ahead and clear a path for us.' - 'American Engineer'
	CTRL.WAIT()
end

EVENTS.ArmorComplain = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074562)	-- LOCDB [11074562] 'Oh sure, sends us to do all the heavy lifting while you sit behind your cozy armor...' - 'American Riflemen'
	CTRL.WAIT()
end

EVENTS.MissionSuccess = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, 11074563)	-- LOCDB [11074563] 'The path looks clear from here. Thanks for the assist, boys!' - 'American Engineer'
	CTRL.WAIT()
end

EVENTS.MissionFailure = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074564)	-- LOCDB [11074564] 'What the hell guys!? You were supposed to protect the tank, not use it for cover!' - 'American Riflemen'
	CTRL.WAIT()
end
