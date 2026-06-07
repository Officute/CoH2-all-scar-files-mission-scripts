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
------------------------------------------ OBJECTIVE_1 Hold the bridge ---------------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "" MISSION "Hold_Bridge" CHARACTER "American Riflemen"
EVENTS.InstructionIntelEvent = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074546)	-- LOCDB [11074546] 'Our scouts report that German armor heading this way.' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074547)	-- LOCDB [11074547] 'We're not equipped to repel that kind of firepower, so we're going to destroy this bridge.' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074548)	-- LOCDB [11074548] 'Hold this position until our engineers arrive with the explosives, then cover them while they rig the bridge to blow.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.EngineerIntelEvent = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074549)	-- LOCDB [11074549] 'Engineers and reinforcements have arrived!' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074550)	-- LOCDB [11074550] 'It's about time! Protect the Engineers while they rig the explosives!' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.PanzerIncoming = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074551)	-- LOCDB [11074551] 'German armor is approaching! Don't let it cross the bridge!' - 'American Lieutenant'
	CTRL.WAIT()		
end


EVENTS.BridgeRigged = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Engineer_01, 11074552)	-- LOCDB [11074552] 'The bridge is rigged to blow!  Everyone, off the bridge, NOW!!!' - 'American Engineer'
	CTRL.WAIT()
end


EVENTS.ArmorDestroyed = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074553)	-- LOCDB [11074553] 'Hmm... impressive. I didn't think we would be able to stop them. Well done, men!' - 'American Captain'
	CTRL.WAIT()
end


EVENTS.BridgeDestroyed = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074554)	-- LOCDB [11074554] 'The bridge is out! The remaining Germans are retreating!' - 'American Captain'
	CTRL.WAIT()
end


EVENTS.DestroyPanzerBridge = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074555)	-- LOCDB [11074555] 'Impressive work, you killed two birds with one stone!' - 'American Captain'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074556)	-- LOCDB [11074556] 'It's too bad about the bridge though, but it had to be done...' - 'American Captain'
	CTRL.WAIT()
end


EVENTS.EngineersKilled = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074557)	-- LOCDB [11074557] 'We've lost the engineers!  Retreat! Retreat!' - 'American Riflemen'
	CTRL.WAIT()	
end

EVENTS.MissionFailEvent = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074558)	-- LOCDB [11074558] 'German forces have breached our defenses!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074559)	-- LOCDB [11074559] 'Retreat! We can't hold them back!' - 'American Captain'
	CTRL.WAIT()
end

