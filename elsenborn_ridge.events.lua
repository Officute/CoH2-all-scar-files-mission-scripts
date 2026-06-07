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
--none



--[[********************************************************************************************************]]
------------------------------------------ MISC MISSION EVENTS  -------------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.
EVENTS.HoldTheLine_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("HoldTheLine_Start"))
end

--Company specific start
EVENTS.HoldTheLine_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074878)	-- LOCDB [11074878] 'Artillery support is on the line.  Shake out your defensive positions and be ready for enemy attack.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079769)	-- LOCDB [11079769] 'We've got artillery support -- fan out into defensive positions.  We're gonna' send  the krauts to their graves!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081589)	-- LOCDB [11081589] 'Alright men, strengthen your resolve.  Baker company's got to hold this Ridge against the German onslaught. But don't fear -  we've got some heavy artillery backing us up. Stand fast, we can not let the Germans past our line!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079891)	-- LOCDB [11079891] 'Don't worry -- we've got artillery support to counter the Germans.  We're gonna lay waste them!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080131)	-- LOCDB [11080131] 'Alright, men - we don't let a single damn Kraut passed this ridge - got it? We've got artillery support standing by to help out. Move in to battle formations… and be ready to rip the enemy to shreds.'
	CTRL.WAIT()
end


EVENTS.Barrage_OneMinute = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074879)	-- LOCDB [11074879] 'Barrage complete in figures 0-1 minutes.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.Barrage_TwentySeconds = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074880)	-- LOCDB [11074880] 'Be advised.  Fire mission complete in figures 2-0 seconds. I say again.  Fire mission complete in figures 2-0 seconds.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.ArtilleryReady = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11074881)	-- LOCDB [11074881] 'I've been attached to your group to provide artillery support.  I'll take care of all your forward observer calls.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11074882)	-- LOCDB [11074882] 'Division's assigned all battalion artillery to our sector.  We got fire support standin' by, so call it as you see it.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.ArtilleryRecharged = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11074907)	-- LOCDB [11074907] 'Fire support is ready to go.  Call your grid.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.FireArtillery = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11074883)		-- LOCDB [11074883] 'Roger. Fire mission, as indicated, stand by impact.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.ArtilleryAvailableReminder = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Major_01, 11074884)		-- LOCDB [11074884] 'Battalion guns are doped and ready.  Get 'em raining lead on those bastards.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.ArtilleryFiring = function()
	t_fireOrders = {
		11074885,	-- LOCDB [11074885] 'Troop, fire mission, coordinates, 5-5-3-7 - 8-9-2-3, azimuth 450, enemy concentration, sustained fire, will adjust.  Shot out.' - 'American Major'
		11074886,	-- LOCDB [11074886] 'Fire mission, Range quadrant, Able Charlie, coordinates  4-7-7-6... 9-9-3-8... Traversing fire, send over.' - 'American Major'
		11074887,	-- LOCDB [11074887] 'Troop gunfire. Easy Easy… direction One Five zero yards, search two degrees, stand by.' - 'American Major'
		11074888,	-- LOCDB [11074888] 'Roger, Dog Foxtrot 4-0-0-5... 0-0-5-3... direction One Nine Hundred yards, shot out.' - 'American Major'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, Table_GetRandomItem(t_fireOrders))
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074889)	-- LOCDB [11074889] 'Fire for effect.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.ArtilleryCooldown = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074890)	-- LOCDB [11074890] 'Use caution assigning those artillery assets.  They've got to cover the entire sector, not just your area of operation.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074891)	-- LOCDB [11074891] 'More times they gotta send aid your way, the longer it's gonna take to get fire support to you the next time around.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.ArtilleryGone = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074948)	-- LOCDB [11074948] 'Battalion reports artillery has gone through their ammo.   We're on our own.' - 'American Major'
	CTRL.WAIT()
end

EVENTS.SmokeScreen = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074892)		-- LOCDB [11074892] 'German's droppin' smoke!  Zero in on that cloud and get ready!!' - 'American Riflemen 1'
	CTRL.WAIT()
end

--[[********************************************************************************************************]]
------------------------------------------ HOLD THE LINE -------------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.
EVENTS.HoldTheLine_PointCapturing = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074893)	-- LOCDB [11074893] 'They're over-running one of our sectors!  Get a quick-reaction-force over there, now!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_PointLost = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074894) -- LOCDB [11074894] 'German's just took the point!  Get a counter-attack on 'em before they dig in!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.SkiesClearing = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074895)	-- LOCDB [11074895] 'Look at that boys!  Sky's clearing!  Help will be here any minute!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.AirSupportArrives = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074896)	-- LOCDB [11074896] 'Fast air inbound!  Give it to 'em!  Let 'em have it!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_OneMinute = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074897)	-- LOCDB [11074897] 'Hold the line!  Hold the line!  Supports almost here!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Complete = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("HoldTheLine_Complete"))
end

--Company specific win
EVENTS.HoldTheLine_Complete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01,11074898)	-- LOCDB [11074898] 'That's it! Rock 'em back onto their heels!' - 'American Riflemen 1'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Complete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079770)	-- LOCDB [11079770] 'Fuck yeah -- rip em' apart, flyboys! The Ridge is ours!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Complete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081590)	-- LOCDB [11081590] 'The Germans are beaten, the ridge is ours! Well done, Baker!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Complete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079892)	-- LOCDB [11079892] 'We got this in the can, boys! Damn fine work out there!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Complete_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080132)	-- LOCDB [11080132] 'Ridge secure -- The Germans have had enough.   Great work out there!'
	CTRL.WAIT()
end



EVENTS.HoldTheLine_Failed = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("HoldTheLine_Failed"))
end

--Company specific loss
EVENTS.HoldTheLine_Failed_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074899)	-- LOCDB [11074899] 'Fuck! area's been overrun!' - 'American Riflemen 1'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074900)	-- LOCDB [11074900] 'We're losin' the ridge!  All forces, withdraw to fallback positions!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Failed_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079771)	-- LOCDB [11079771] 'Shit -- the German's have overrun the sectors -- we gotta' pull back and regroup…'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Failed_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081591)	-- LOCDB [11081591] 'Enemy forces have secured the ridge! Fall back, Baker!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Failed_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079893)	-- LOCDB [11079893] 'The Germans have overrun the sectors! We can't do much more without digging a bigger hole. Fall back and regroup!'
	CTRL.WAIT()
end

EVENTS.HoldTheLine_Failed_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080133)	-- LOCDB [11080133] 'Germans took the ridge -- goddamnit! How in the fuck did we let this slide?! Fall back, Fox!'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
------------------------------------------ SECURE THE FLANK -------------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.
EVENTS.CaptureTheCheckpoint_Start = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074901)	-- LOCDB [11074901] 'We got eye's on enemy build up West of the road.' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074902)	-- LOCDB [11074902] 'German's hold a key position there. If we can open it up, we might be able to get some help sent this way.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.CaptureTheCheckpoint_Complete = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074903)	-- LOCDB [11074903] 'Good job.  Easy Company's sending support.' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074904)	-- LOCDB [11074904] 'They'll keep sending squads as long as they can. Just hold the area.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.CaptureTheCheckpoint_Reinforcements_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074905)	-- LOCDB [11074905] 'Forward elements of Easy just got here.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.CaptureTheCheckpoint_Reinforcements_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074906)	-- LOCDB [11074906] 'More of Easy Company just got here.' - 'American Lieutenant'
	CTRL.WAIT()
end

