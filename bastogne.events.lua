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
--None

--[[********************************************************************************************************]]
---------------------------------------- OBJECTIVES MISSION EVENTS  -----------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.
EVENTS.CaptureTheRoad_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("CaptureTheRoad_Start"))
end

--Commander specific
EVENTS.CaptureTheRoad_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074911)	-- LOCDB [11074911] 'This storm is just want we need.  German's won't be able to reinforce their lines - they'll never expect us!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.CaptureTheRoad_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079762)	-- LOCDB [11079762] 'If this storm holds up we can ambush the German position in Bastogne…They'll be down for the count before they know what hit em'.'
	CTRL.WAIT()
end

EVENTS.CaptureTheRoad_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081582)	-- LOCDB [11081582] 'Looks like the elements are on our side in Bastogne boys.  The German's will be blind to our movements in this storm…Perfect time to strike.  This will make for a great letter back home to my Father.'
	CTRL.WAIT()
end

EVENTS.CaptureTheRoad_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079884)	-- LOCDB [11079884] 'Weather is smiling on us today boys.  We'll use the storm as cover to sneak up on the German forces.  We'll hit em' hard and fast. All of us should make it back safe and sound.'
	CTRL.WAIT()
end

EVENTS.CaptureTheRoad_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080124)	-- LOCDB [11080124] 'Alright Fox, we gotta bring some aid to our troops holed up in Bastogne. We'll assault the German positions surrounding the town under cover of this storm - use the element of surprise to give us an advantage - before we launch a full scale assault.'
	CTRL.WAIT()
end



EVENTS.CaptureTheRoad_American_Spotted = function()
	local speechTable = {
		11074912,	-- LOCDB [11074912] 'Contact! American Infantry!' - 'German Grenadier'
		11074913,	-- LOCDB [11074913] 'Incoming! American Infantry!' - 'German Grenadier'
		11074914,	-- LOCDB [11074914] 'Enemy contact!' - 'German Grenadier'
		11074915,	-- LOCDB [11074915] 'Contact! We have contact!' - 'German Grenadier'
	}
	CTRL.Actor_PlaySpeech(ACTOR.German_Grenadier, Table_GetRandomItem(speechTable))
	CTRL.WAIT()
end

EVENTS.CaptureTheRoad_Complete = function()
	if Player_OwnsEGroup(player1, eg_road_all) then
		CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074916)	-- LOCDB [11074916] 'Ballsy move.  Road's ours.  Just don't be pullin' stunts like that every time.' - 'American Lieutenant'
		CTRL.WAIT()
	else
		CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074917)	-- LOCDB [11074917] 'That storms lettin' up.  German's are gonna try and get reinforcements in, so shake it up.' - 'American Lieutenant'
		CTRL.WAIT()
	end
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074918)	-- LOCDB [11074918] 'The base is up and runnin'.    Keep it in one piece.' - 'Intel'
	CTRL.WAIT()
end

-- Secure Road
--~ EVENTS.SecureTheRoad_Start = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, LOC("The Germans are re-routing additional forces for a counter-offensive."))
--~ 	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, LOC("We must capture the remaining points quickly and get the supply convoy through to Bastogne."))
--~ 	CTRL.WAIT()
--~ end

EVENTS.SecureTheRoad_Explain = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("SecureTheRoad_Explain"))
end

--Company specific
EVENTS.SecureTheRoad_Explain_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074919)	-- LOCDB [11074919] 'Our boys in Bastogne are gettin' chewed up pretty bad.  They ain't gonna be able to hold out forever.' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074920)	-- LOCDB [11074920] 'the German's are really givin' it to 'em -- we need to open up a corridor before it's to late!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_Explain_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079763)	-- LOCDB [11079763] 'We can't let our boys in Bastogne get butchered - gonna have to push hard, Able! Secure the road -- get the Krauts off their backs.'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_Explain_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081583)	-- LOCDB [11081583] 'If we don't haul ass none of those boys under attack in Bastogne will make it outa this -  I don't want that on my record.  Let's secure that road and give em' some relief!'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_Explain_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079885)	-- LOCDB [11079885] 'We're not gonna leave the men to slaughter in Bastogne.  We gotta move that road and break through the German line -- come on!'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_Explain_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080125)	-- LOCDB [11080125] 'We gotta' secure the road in Bastogne ASAP -- our men are getting hammered out there…We can't leave them in harm's way…We cannot let them down!'
	CTRL.WAIT()
end



EVENTS.SecureTheRoad_AlliedStrength75 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074921)	-- LOCDB [11074921] 'Bastogne reports casualties are startin' to pile up.  The lines are runnin' thin.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_AlliedStrength50 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074922)	-- LOCDB [11074922] 'We lost contact with front line elements in Bastogne -- squads are falling back to secondary positions.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_AlliedStrength25 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074923)	-- LOCDB [11074923] 'Bastogne's falling - we need that road open, now!' - 'Intel'
	CTRL.WAIT()
end




EVENTS.SecureTheRoad_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074924)	-- LOCDB [11074924] 'All positions reporting in.  Roads open.' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074925)	-- LOCDB [11074925] 'Recon and scouts are reporting German forces assembling.  Be ready for a counter attack.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.SecureTheRoad_Fail = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074926)	-- LOCDB [11074926] ''God dammit! We lost comm's with Bastogne… not looking good.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074927)	-- LOCDB [11074927] 'We're too late, what a fuckin' mess.' - 'American Lieutenant'
	CTRL.WAIT()
end

-- Defend Road
EVENTS.DefendTheRoad_Start = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074928)	-- LOCDB [11074928] 'The enemy is trying to cut the road in half.   Get a blockin' force together and do what you can.' - 'American Lieutenant'
--~ 	CTRL.WAIT()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("DefendTheRoad_Start"))
end

EVENTS.DefendTheRoad_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074929)	-- LOCDB [11074929] 'We have field reports pouring in.  German's are moving on key locations.  Points are marked on the map.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079766)	-- LOCDB [11079766] 'Krauts are gearing up to split the road in half.'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081586)	-- LOCDB [11081586] 'The German's are intent on cutting the road in half.  We've gotta assemble a blocking force and throw everything we have at them!'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079888)	-- LOCDB [11079888] 'The enemy is trying to cut the road in half.   Get a blocking force together and do what you can.  We gotta barge through the enemy line -- those boys can't stay afloat much longer.'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080128)	-- LOCDB [11080128] 'Germans are massing up to counter.  Let's dig in and take it to em'!'
	CTRL.WAIT()
end





EVENTS.DefendTheRoad_Contact_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074930)	-- LOCDB [11074930] 'Contact!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Contact_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074931)	-- LOCDB [11074931] 'Germans Spotted!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Contact_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074932)	-- LOCDB [11074932] 'Attack Spotted!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Contact_04 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074933)	-- LOCDB [11074933] 'German Contact!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Contact_05 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074930)	-- LOCDB [11074930] 'Contact!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074934)	-- LOCDB [11074934] ''German's are tuckin' tail.  They're pullin' out.' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074935)	-- LOCDB [11074935] 'That's it, good work boys, the corridor is secured! Relief is on their way.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_PointCapturing = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074936)	-- LOCDB [11074936] 'They're pressing their attack!  Redeploy the lines!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Fail = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("DefendTheRoad_Fail"))
end

--Commander-specific fail
EVENTS.DefendTheRoad_Fail_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074937)	-- LOCDB [11074937] 'They broke through!  The roads been cut in half!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074938)	-- LOCDB [11074938] 'God dammit!  Pull the squads back.  Boys in Bastogne are gonna have to hold on a bit longer.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Fail_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079765)	-- LOCDB [11079765] 'Goddamnit! Too late…It's a fuckin' train wreck.'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Fail_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081585)	-- LOCDB [11081585] 'Damnit all! These Germans are too damn vicious - we're outmatched here! Fall back, Baker!'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Fail_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079887)	-- LOCDB [11079887] 'Time's up -- shit…Those boys didn't stand a chance against that onslaught…What a waste.'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_Fail_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080127)	-- LOCDB [11080127] 'We were too late -- it's over.  Those boys deserved better…We let them down.'
	CTRL.WAIT()
end



EVENTS.DefendTheRoad_AmbulencesEntering = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074939)	-- LOCDB [11074939] 'We got ambulances headed up to Bastogne.  Make sure the corridor is safe.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.DefendTheRoad_AmbulencesLeaving = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074940)	-- LOCDB [11074940] 'The wounded are being brought out.  Keep security on that road.' - 'Intel'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
------------------------------------------ MISC MISSION EVENTS  -------------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.

