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
------------------------------------------ OBJECTIVE_1 Secure the fuelpoints ---------------------------------
--[[********************************************************************************************************]]
--SEQUENCE "" MISSION "Stavelot" CHARACTER "American Riflemen"
EVENTS.MissionIntro = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074565)	-- LOCDB [11074565] 'Germans are assembling a large truck fleet.  It's clear they're going to try and pull whatever fuel they can outta the sector.' - 'Intel'
	CTRL.WAIT()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionIntro"))
end

--Commander-specific
EVENTS.MissionIntro_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074566)	-- LOCDB [11074566] 'Get a plan together and lock down that fuel depot before they get fuel behind their lines.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.MissionIntro_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079804)	-- LOCDB [11079804] 'We gotta' form up and take the fuel depot before the krauts get all that gas outta here!'
	CTRL.WAIT()
end

EVENTS.MissionIntro_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081624)	-- LOCDB [11081624] 'It's vital we secure that fuel depot and foil the German's attempt to move fuel back to their lines.'
	CTRL.WAIT()
end

EVENTS.MissionIntro_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079926)	-- LOCDB [11079926] 'That fuel depot is up for grabs…We need to assemble a team and gain control of it…That will deny the Germans the opporunity to transport fuel behind their lines.'
	CTRL.WAIT()
end

EVENTS.MissionIntro_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080166)	-- LOCDB [11080166] 'Rangers -- we need to seize the fuel depot before the Germans can transport too much of that gas behind their lines.  Stay alert and it should be a piece of cake for us.'
	CTRL.WAIT()
end



EVENTS.WarnFlakHalftrack = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080794)	-- LOCDB [11080794] 'Shit! They got Flak guns on that halftrack. Careful boys!'
	CTRL.WAIT()
end

EVENTS.InformExitBlock = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074567)	-- LOCDB [11074567] 'Forward elements have eyes on enemy trucks leavin' the objective!' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074568)	-- LOCDB [11074568] 'They're fuel trucks!  Stop those S.O.B's!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074569)	-- LOCDB [11074569] 'Get a blockin' force in front of 'em! Don't let them get past you!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.WarnTruck = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074570)	-- LOCDB [11074570] 'Heads up boys. Germans have a truck leavin' their fuel depot.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.WarnFinalTruck = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074571)	-- LOCDB [11074571] 'There's too many trucks makin' it past our men! Redeploy your lines!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.WarnFuelReinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080863)	-- LOCDB [11080863] 'Enemy is scrambling units to hit your position. Hurry up and secure the area!'
	CTRL.WAIT()
end

EVENTS.WarnDepotAttacked = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074573)	-- LOCDB [11074573] 'Germans redepolyin!  They know we're after the fuel cache!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074574)	-- LOCDB [11074574] 'Lock down that god damn point before they run it dry!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.CaptureFail = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("CaptureFail"))
end

--Commander-specific
EVENTS.CaptureFail_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074575)	-- LOCDB [11074575] 'God damn class "A" screw up!  Germans got all their fuel through!  Pack it in. Fall back.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.CaptureFail_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079802)	-- LOCDB [11079802] 'We dropped the ball big time boys…Krauts got the fuel to their lines…Bail out -- now!'
	CTRL.WAIT()
end

EVENTS.CaptureFail_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081622)	-- LOCDB [11081622] 'Damnit! The German's got the fuel out… This is one hell of a setback.'
	CTRL.WAIT()
end

EVENTS.CaptureFail_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079924)	-- LOCDB [11079924] 'Shit -- the op 's gone belly up…Germans extracted fuel here in Stavelot. We gotta regroup before they reach their lines and form up for an attack.'
	CTRL.WAIT()
end

EVENTS.CaptureFail_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080164)	-- LOCDB [11080164] 'Goddamnit -- a unit like ours can't afford slip-ups like this…The Germans have secured too much gas…Fuck!...Fall back and regroup!'
	CTRL.WAIT()
end



EVENTS.CaptureComplete = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("CaptureComplete"))
end

--Commander-specific
EVENTS.CaptureComplete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074576)	-- LOCDB [11074576] 'Fuel depot secured!  Germans are in full retreat!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.CaptureComplete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079803)	-- LOCDB [11079803] 'Wasn't easy, but we blocked the Kraut's from nickin' the gas - German's are headin' back to base empty handed!'
	CTRL.WAIT()
end

EVENTS.CaptureComplete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081623)	-- LOCDB [11081623] 'Stavelot and it's fuel are ours, well done, Baker!'
	CTRL.WAIT()
end

EVENTS.CaptureComplete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079925)	-- LOCDB [11079925] 'Fuel depot is ours -- The Germans have had enough…They're withdrawing their forces.'
	CTRL.WAIT()
end

EVENTS.CaptureComplete_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080165)	-- LOCDB [11080165] 'We've taken the fuel depot!  Enemy forces are scrambling back out of the area!  This unit is unstoppable!'
	CTRL.WAIT()
end

