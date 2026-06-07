print("\tLoading .events file...")

-- Who I've used for what:
-- ACTOR.American_Riflemen_01  	  -- generic on-the-ground alerts pertaining to a squad's immediate situation
-- ACTOR.American_Lieutenant_01  	  -- generic on-the-ground situational updates pertaining to objectives
-- ACTOR.None -- Serves as Intel and orders and situational updates from HQ

-- IntelEvents Table Container.
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
------------------------------------------ OBJECTIVE_1 Kill Convoy -------------------------------------------
--[[********************************************************************************************************]]

-- This is where you define intel events for Objective_1
-- These should be FUNCTIONS, defined as entries within the table EVENTS.
EVENTS.KillTheConvoyStart = function()

	
	local t = {
		{cmdr_id = CD_NONE, event_id = EVENTS.KillTheConvoyStart_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.KillTheConvoyStart_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.KillTheConvoyStart_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.KillTheConvoyStart_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.KillTheConvoyStart_RANGER},
	}
	
	XP1_PlayCompanySpeechLine (t)
end
	
EVENTS.KillTheConvoyStart_DEFAULT = function()	
	--CTRL.Actor_PlaySpeech(ACTOR.None, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
	--CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080870)      -- LOCDB [11080870] 'We need to shut 'em down before they can get those supplies out'
	CTRL.WAIT()
end


EVENTS.KillTheConvoyStart_AIRBORNE = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079772)      -- LOCDB [11079772] 'Alright, we gotta knock out the goddamn vehicles before they can supply their forces -- Get to it, Able!'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyStart_MECHANIZED = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081592)      -- LOCDB [11081592] 'Alright, Baker, we've gotta find a way to halt that convoy before it reaches enemy lines - let's get to it!'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyStart_SUPPORT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079894)      -- LOCDB [11079894] 'Neutralize enemy convoy -- Can't let it escape Eschdorf intact.'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyStart_RANGER = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074709)      -- LOCDB [11074709] 'We're gettin' word that a German supply convoy was spotted in Eschdorf.  We figure they're going to try and reinforce their lines just outside the town.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080134)      -- LOCDB [11080134] 'Alright - We need to shut these Krauts down before they can get that equipment out!'
	CTRL.WAIT()
end




EVENTS.KillTheConvoyFail = function()

	
	local t = {
		{cmdr_id = CD_NONE, event_id = EVENTS.KillTheConvoyFail_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.KillTheConvoyFail_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.KillTheConvoyFail_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.KillTheConvoyFail_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.KillTheConvoyFail_RANGER},
	}
	
	XP1_PlayCompanySpeechLine (t)
end
	
EVENTS.KillTheConvoyFail_DEFAULT = function()	

	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074716)      -- LOCDB [11074716] 'God dammit!  Convoy's pushed through!' - 'American Lieutenant'
	CTRL.WAIT()	
end


EVENTS.KillTheConvoyFail_AIRBORNE = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079773)      -- LOCDB [11079773] 'Goddamnit! We couldn't hit the convoy before it bailed out… Hope this doesn't sink us.'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyFail_MECHANIZED = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081593)     -- LOCDB [11081593] 'Goddamnit, the convoy's escaped! We've lost our chance, men.'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyFail_SUPPORT = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079895)      -- LOCDB [11079895] 'German convoy made it out…Goddamnit!...That's going to cost us down the line…Experience is a cruel fuckin' teacher.'
	CTRL.WAIT()
end

EVENTS.KillTheConvoyFail_RANGER = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080135)      -- LOCDB [11080135] 'God dammit!  Convoy pushed through! Rangers are better than this… leave a bitter taste in my mouth!'
	CTRL.WAIT()
end





EVENTS.ConvoyMoving = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = EVENTS.ConvoyMoving_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.ConvoyMoving_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.ConvoyMoving_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.ConvoyMoving_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.ConvoyMoving_RANGER},
	}
	
	XP1_PlayCompanySpeechLine (t)
end
	
EVENTS.ConvoyMoving_DEFAULT = function()	

	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074719)      -- LOCDB [11074719] 'Krauts are movin' that convoy out!' - 'American Lieutenant'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074720)      -- LOCDB [11074720] 'Get over there and nail it down before it's outta reach!' - 'American Lieutenant'
	CTRL.WAIT()	
end


EVENTS.ConvoyMoving_AIRBORNE = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079776)      -- LOCDB [11079776] 'Move your asses goddamnit!  German convoy's up and running -- wipe it off the goddamn map…Now!'
	CTRL.WAIT()
end

EVENTS.ConvoyMoving_MECHANIZED = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081596) -- LOCDB [11081596] 'The enemy convoy has fueled up -- we've gotta advance in a hurry, baker! We cannot allow it to escape Eschdorf!'
	CTRL.WAIT()
end

EVENTS.ConvoyMoving_SUPPORT = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079898)      -- LOCDB [11079898] 'German convoys been loaded up -- head it off before it's home free…Can't afford to let em' off the hook.'
	CTRL.WAIT()
end

EVENTS.ConvoyMoving_RANGER = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080138)      -- LOCDB [11080138] 'Convoy's movin - we gotta get out there and  nail it before it's out of range!'
	CTRL.WAIT()
end

EVENTS.ConvoyStartedFuelling = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074711)      -- LOCDB [11074711] 'Forward elements report the convoy is nearly ready to move.  There's not much time left -- get your guys over there.' - 'Intel'
	CTRL.WAIT()

end

EVENTS.ForestEnemies = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074712)      -- LOCDB [11074712] 'Krauts got anti-tank guns linin' the road.  Whole fuckin' place is a shootin' gallery.' - 'American Riflemen'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074713)      -- LOCDB [11074713] 'Should try to find a way around 'em. Otherwise, those guns'll need to be taken out before we can roll our armor in.' - 'American Riflemen'
	CTRL.WAIT()
end

EVENTS.ForestMines = function()
	--CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074714)      -- LOCDB [11074714] 'Watch your step!  Krauts got the place covered in mines.  We gotta clear it -- or find another way around!' - 'American Riflemen'
	--CTRL.WAIT()	
	--CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11081460)      -- LOCDB [11081460] 'Watch your step!  Krauts got the place covered in mines.  We got to clear it -- or find a way around!'
	--CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11081303)      -- LOCDB [11081303] 'Watch your step!  Krauts got the place covered in mines.  We got to clear it -- or find a way around!'
	CTRL.WAIT()	
	
end

EVENTS.SideRoad = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074715)      -- LOCDB [11074715] 'Hey we found a service road... We might be able to use it to bring our vehicles up.' - 'American Riflemen'
	CTRL.WAIT()	
end




EVENTS.ConvoyAllDead = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = EVENTS.ConvoyAllDead_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.ConvoyAllDead_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.ConvoyAllDead_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.ConvoyAllDead_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.ConvoyAllDead_RANGER},
	}
	
	XP1_PlayCompanySpeechLine (t)
end
	
EVENTS.ConvoyAllDead_DEFAULT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074717)      -- LOCDB [11074717] 'That did it! Aint no supplies gettin' through now.' - 'American Lieutenant'
	CTRL.WAIT()	
end


EVENTS.ConvoyAllDead_AIRBORNE = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079774)     	 -- LOCDB [11079774] 'Smoked the enemy convoy before it could slip away…Right on the money boys!'
	CTRL.WAIT()
end

EVENTS.ConvoyAllDead_MECHANIZED = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081594) 		-- LOCDB [11081594] 'The convoy's nothin' but a burning pile, good job men! Let's see how much push-back the German's can manage without those supplies.'
	CTRL.WAIT()
end

EVENTS.ConvoyAllDead_SUPPORT = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079896)    		-- LOCDB [11074717] 'That did it! Aint no supplies gettin' through now.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.ConvoyAllDead_RANGER = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080136) 		-- LOCDB [11080136] 'The convoy's down, great work, Fox! The Germans will be hurtin' without those supplies!'
	CTRL.WAIT()
end



EVENTS.ConvoyMostDead = function()
	local t = {
		{cmdr_id = CD_NONE, event_id = EVENTS.ConvoyMostDead_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.ConvoyMostDead_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.ConvoyMostDead_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.ConvoyMostDead_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.ConvoyMostDead_RANGER},
	}
	
	XP1_PlayCompanySpeechLine (t)
end
	
EVENTS.ConvoyMostDead_DEFAULT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074718)      -- LOCDB [11074718] 'Good job boys.  We got most of 'em.' - 'American Lieutenant'
	CTRL.WAIT()	
end


EVENTS.ConvoyMostDead_AIRBORNE = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079775)      	-- LOCDB [11079775] 'Some of the convoy pushed through, but we made damn sure most of it didn't get outta here in one piece. Well done, Able.'
	CTRL.WAIT()
end

EVENTS.ConvoyMostDead_MECHANIZED = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081595) 		-- LOCDB [11081595] 'Well done men, most of the convoy's down! We've dealt a serious blow to the Germans!'
	CTRL.WAIT()
end

EVENTS.ConvoyMostDead_SUPPORT = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079897)    		-- LOCDB [11079897] 'Some escaped, but most of the convoy was eliminated.  That'll go a long way in crushing their spirits.'
	CTRL.WAIT()
end

EVENTS.ConvoyMostDead_RANGER = function()	
	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080137) 		-- LOCDB [11080137] 'Alright, most of the convoy's down and out -- this oughta take a serious bite out of the Germans' strength. Well done, men!'
	CTRL.WAIT()
end

EVENTS.PanzerIVEscortSpotted = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11081205) 		-- LOCDB [11081205] 'Shit, the convoy's got a Panzer IV escorting it!'
	CTRL.WAIT()
end

EVENTS.PantherEscortSpotted = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11081206) 		-- LOCDB [11081206] 'Jesus Christ, Germans got a Panther protectin' the convoy!'
	CTRL.WAIT()
end


EVENTS.Convoy50PercentTimerReached = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074721)      -- LOCDB [11074721] 'Recon says those Kraut trucks are nearly ready to go!' - 'American Lieutenant'
	CTRL.WAIT()	
end

EVENTS.Convoy75PercentTimerReached = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074722)      -- LOCDB [11074722] 'Get it together!  We're losin' time… that convoy is about to jump off!' - 'American Lieutenant'
	CTRL.WAIT()	
end

EVENTS.MapEntryPointCleared = function()
	--CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11075080)      -- LOCDB [11075080] 'Good work! That opened up a hole in the line for our boys to push through!' - 'American Lieutenant'
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11081301)      -- LOCDB [11081301] 'Good work! That opened up a hole in the line for our boys to push through!'
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11081300)      -- LOCDB [11081300] 'We should be able to field our troops faster by rallying them nearby.'
	
	CTRL.WAIT()	
end




