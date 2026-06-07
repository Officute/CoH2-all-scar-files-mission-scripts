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
------------------------------------------ OBJECTIVE_1 Hunt tanks -------------------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "22" MISSION "Tank_Hunter" CHARACTER "American Riflemen 02"
EVENTS.ObjKillTanks_Intro = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074528) -- LOCDB [11074528] 'German heavies in the area have been giving our boys a hard time.' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074529) -- LOCDB [11074529] 'We're gonna find em', and we're gonna kill em'.' - 'American Riflemen'
	CTRL.WAIT()
end

EVENTS.ExplainApproach = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074530) -- LOCDB [11074530] 'Dinozzo, your Stuart will be in charge of keeping them busy while we go in for the kill.' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074531) -- LOCDB [11074531] 'Think your little tank can handle that?' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_02, 11074532) -- LOCDB [11074532] 'Hey! At least my 'little tank' has no need to compensate.' - 'American Riflemen 02'
	CTRL.WAIT()
end

EVENTS.MissionSuccess = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074533) -- LOCDB [11074533] 'Ha! No German armor is match for the mighty 1-2!' - 'American Riflemen 02'
	CTRL.WAIT()
end
