print("\tLoading .events file...")
-- IntelEvents Table Container.
--	This contains all Regular IntelEvent functions (simple dialogue).


-- Who I've used for what:
--
-- ACTOR.American_Captain_01      -- the leader of the player's forces, giving orders and encouragement
-- ACTOR.American_Riflemen_01  	  -- generic on-the-ground alerts pertaining to a squad's immediate situation
-- ACTOR.American_Lieutenant_01  	  -- generic on-the-ground situational updates pertaining to objectives
-- ACTOR.None -- serves as Intel from HQ

EVENTS = {}

-- NIS events table container.
--[[	Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. 
		These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic. ]]--
NIS_EVENTS = {}



--[[********************************************************************************************************]]
------------------------------------------ NIS EVENTS -----------------------------------------------------
--[[********************************************************************************************************]]
--None

--~ EVENTS.GetReady = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074763)      -- LOCDB [11074763] 'They've used all their fuel pushing into the area.  Retaking the town's reserves will cripple their assault. Now is the time to hit their lines.' - 'Intel'
--~ 	CTRL.WAIT()	
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074764)      -- LOCDB [11074764] 'The Fuel Point at  the town's Sanatorium is the initial target.  Everything else will jump off from there.   Capture and hold the area.' - 'Intel'
--~ 	CTRL.WAIT()	
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074765)      -- LOCDB [11074765] 'Cutting off that point will put the German's against the wall.  They're running on fumes as it is.' - 'Intel'
--~ 	CTRL.WAIT()	
--~ end

EVENTS.GetReady = function()

	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("GetReady"))
	
end
	
EVENTS.GetReady_DEFAULT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074763)      -- LOCDB [11074763] 'They've used all their fuel pushing into the area.  Retaking the town's reserves will cripple their assault. Now is the time to hit their lines.' - 'Intel'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074764)      -- LOCDB [11074764] 'The Fuel Point at  the town's Sanatorium is the initial target.  Everything else will jump off from there.   Capture and hold the area.' - 'Intel'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074765)      -- LOCDB [11074765] 'Cutting off that point will put the German's against the wall.  They're running on fumes as it is.' - 'Intel'
	CTRL.WAIT()	
end


EVENTS.GetReady_AIRBORNE = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079807)      -- LOCDB [11079807] 'Krauts wasted all their fuel movin' in -- they'll be hell-bent on picking up Stoumont's reserves…Let's kick em' while they're down!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079808)      -- LOCDB [11079808] 'We gotta' take the fuel point at the town's Sanatorium.  Clear it, and we'll go from there.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079809)      -- LOCDB [11079809] 'We can really knock knock the Kraut's down a peg if we can grab any fuel caches in the area.'
	CTRL.WAIT()
end

EVENTS.GetReady_MECHANIZED = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081627)      -- LOCDB [11081627] 'Alright, Baker - the German's expended their fuel reserves pushing into the area.  The doors wide open for us.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081628)      -- LOCDB [11081628] 'The objective is simple:  Seize the fuel point at the town's Sanatorium -- The Kraut's will push back, but if we can hold them off  long enough - they'll run outta gas and the town will be ours'
	CTRL.WAIT()
end

EVENTS.GetReady_SUPPORT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079929)      -- LOCDB [11079929] 'Germans wasted their fuel reserves advancing into area.  If we cut off Stoumont's remaining fuel reserves, the Germans attack will be completely stalled…Their lines will be vulnerable.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079930)      -- LOCDB [11079930] 'We've got a bumpy road ahead of us boys -- and the starting point is the town's Sanatorium.  Capture and maintain the area -- then we'll go from there.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079931)      -- LOCDB [11079931] 'Block the Germans off from the fuel point in Stoumont…That will take the wind right out of their sails.'
	CTRL.WAIT()
end

EVENTS.GetReady_RANGER = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080169)      -- LOCDB [11080169] 'Alright, enemy vehicles are runnin' on fumes -- we gotta prevent them from securing Stoumont's fuel reserves to halt their armor.  We do that, and their forces aren't gonna have a leg to stand on.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080170)      	-- LOCDB [11080170] 'Our focus is the fuel point at the Sanatorium -- Secure and hold that area.  Don't drop the ball out there!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080171)      -- LOCDB [11080171] 'There's more fuel caches out there - if we can block the Kraut's from takin' them we'll have this in the bag!'
	CTRL.WAIT()
end




EVENTS.ExampleAppear = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074738)      -- LOCDB [11074738] 'Contact! Enemy advancin' along the road!' - 'American Lieutenant'
	CTRL.WAIT()	
end

EVENTS.TankNoFuel = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074739)      -- LOCDB [11074739] 'It stopped!  They're out of fuel!  Nail 'em as they bail out!' - 'American Riflemen'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074740)      -- LOCDB [11074740] 'Someone get that thing goin'!  Use our fuel ya gotta!' - 'American Lieutenant'
	CTRL.WAIT()	
end

EVENTS.TankCaptured = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074741)      -- LOCDB [11074741] 'Good work boys. Now get that thing on the line.' - 'American Captain'
	CTRL.WAIT()		
end

EVENTS.CapFuelPoints = function()

	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074742)      -- LOCDB [11074742] 'Stand ready! They were just feelin' us out.  They'll be back in force!' - 'American Captain'
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074743)      -- LOCDB [11074743] 'Seems the Krauts are already running out of fuel and ditchin' their vehicles...  If we run their reserves down we can turn their gear against them!' - 'American Captain'
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074744)      -- LOCDB [11074744] 'The German's are runnin' on fumes already... Capturin' fuel points will bleed them dry.' - 'American Captain'
	
	CTRL.WAIT()	

end

EVENTS.CapFuelPoints2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074745)      -- LOCDB [11074745] 'That's the way to stick it to 'em! Keep it up!' - 'American Captain'
	--CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074746)      -- LOCDB [11074746] 'German's only have one fuel point left.  Pour it on and get me that area!' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.CapFuelPoints2b = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074746)      -- LOCDB [11074746] 'German's only have one fuel point left.  Pour it on and get me that area!' - 'American Captain'
	CTRL.WAIT()

end

EVENTS.AllFuelTaken = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074747)      -- LOCDB [11074747] 'We got the German's against the ropes! Keep on those fuel points!  They're down to their last drops!' - 'American Captain'
	
	CTRL.WAIT()	
end

EVENTS.SanatoriumTaken = function()
--	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01,11074748)      -- LOCDB [11074748] 'There's a Fuel Point near the Sanatorium.  If we can secure that point, we can cut their lines!' - 'American Captain'
--	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080799)       -- LOCDB [11080799] 'Got the Sanatorium under our control!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01,11074749)      -- LOCDB [11074749] 'Alright!  Shake it out!  Get me a hasty defensive line and prepare for a counter-attack!' - 'American Captain'
	CTRL.WAIT()	
end


EVENTS.SanatoriumCapped = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074750)      -- LOCDB [11074750] 'Get squads over to the Sanatorium! Germans just over ran the fuel point nearby!' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.SanatoriumRecap = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074751)      -- LOCDB [11074751] 'Establish a defensive perimeter!  They're gonna want that fuel point back!' - 'American Riflemen'
	CTRL.WAIT()	
end

EVENTS.SanatoriumFail = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("SanatoriumFail"))	
end
	
EVENTS.SanatoriumFail_DEFAULT = function()	

end

EVENTS.SanatoriumFail_AIRBORNE = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079806)      -- LOCDB [11079806] 'Goddamn, Jerry's got the fuel cache - their armour's gonna overrun us - fall the hell back!'
	CTRL.WAIT()	
end

EVENTS.SanatoriumFail_MECHANIZED = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081626)      -- LOCDB [11081626] 'Damnit, the Germans got control of the fuel! We can't stand against 'em now - fall back, fall back!'
	CTRL.WAIT()

end

EVENTS.SanatoriumFail_SUPPORT = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079928)      -- LOCDB [11079928] 'Christ, German's got the fuel! Their armour's comin' in full force, fall back!'
	CTRL.WAIT()

end

EVENTS.SanatoriumFail_RANGER = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080168)      -- LOCDB [11080168] 'Fuckin' hell, we gave the gas to the Germans, now there's no way we'll stand up against their armour - Retreat!'
	CTRL.WAIT()

end


-- mission victory
EVENTS.NoFuel = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("NoFuel"))
end

EVENTS.NoFuel_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074752)      -- LOCDB [11074752] 'Kraut's are pullin' back! Stoumont's ours!' - 'American Riflemen'
	CTRL.WAIT()	
end

EVENTS.NoFuel_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079805)      -- LOCDB [11079805] 'German vehicles are bone dry -- mobility just took a big hit -- great fuckin' job!'
	CTRL.WAIT()	

end

EVENTS.NoFuel_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081625)      -- LOCDB [11081625] 'They German's have no fuel left in the tank -- they're high-tailing it out of area…Great job!'
	CTRL.WAIT()	
end

EVENTS.NoFuel_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079927)      -- LOCDB [11079927] 'The Germans are waving the white-flag….They're withdrawing without fuel…Stoumont's secure!'
	CTRL.WAIT()	
end

EVENTS.NoFuel_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080167)      -- LOCDB [11080167] 'Listen up alright -- German vehicles have lost mobility -- the Krauts are fallin' back. Well done, Rangers!'
	CTRL.WAIT()	
end



EVENTS.WaveBeaten = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074753)      -- LOCDB [11074753] 'Good job! Re-org' and get your lines ready for enemy action!' - 'American Captain'
	CTRL.WAIT()	

end



EVENTS.FirstWave = function()

 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074754)      -- LOCDB [11074754] 'Germans have a company plus shakin' out in the A.O., expect multiple incoming attacks!' - 'Intel'
 	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074755)      -- LOCDB [11074755] 'They're goin' to try and probe the line for weaknesses.   Be ready.' - 'Intel'
	CTRL.WAIT()	

end

EVENTS.WaveLaunched = function()

	CTRL.Actor_PlaySpeech(ACTOR.None, 11074756)      -- LOCDB [11074756] 'Lead elements report enemy action along their lines.' - 'Intel'
	CTRL.WAIT()	

end

EVENTS.SecondWave = function()

	CTRL.Actor_PlaySpeech(ACTOR.None, 11074757)      -- LOCDB [11074757] 'Enemy infantry have been spotted making ready to advance.   Get your front line ready.' - 'Intel'
	CTRL.WAIT()	

end

EVENTS.ThirdWave = function()

	CTRL.Actor_PlaySpeech(ACTOR.None, 11074758)      -- LOCDB [11074758] 'Contact reports are comin'g detailing a Mechanized enemy force closing.  Prepare for a third assault.' - 'Intel'
	CTRL.WAIT()	
	

end

EVENTS.FourthWave = function()

	CTRL.Actor_PlaySpeech(ACTOR.None, 11074759)      -- LOCDB [11074759] 'A panzer company is moving in.   Consolidate your anti-armor assets.  We can't let them break our lines.' - 'Intel'
	CTRL.WAIT()	

end

EVENTS.VehicleOutOfFuel = function()

	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074760)      -- LOCDB [11074760] 'One of their vehicle's just stalled out!  I think it's outta fuel!' - 'American Riflemen'
	CTRL.WAIT()	

end

EVENTS.LastWave = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074761)      -- LOCDB [11074761] 'The German's are bringin' up their command elements. They're gettin' desperate now.  This is their final play to secure the area.' - 'Intel'
	CTRL.WAIT()	

end


EVENTS.FuelUp = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074762)      -- LOCDB [11074762] 'German units are assembling at a forward staging area.  Stand the lines to full alert.  Get ready.' - 'Intel'
	CTRL.WAIT()	

end



EVENTS.SecondWaveOver = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076039)           -- LOCDB [11076039] 'Well done.  Now shore up the defenses - they aren't gonna let up that easy.' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.ThirdWaveOver = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076040)           -- LOCDB [11076040] 'Way to hold strong, boys.  Keep alert - more Krauts are sure to show their faces soon.' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.FourthWaveOver = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076041)           -- LOCDB [11076041] 'Almost got this - prep the defenses - at least one more force is sure to come.' - 'American Captain'
	CTRL.WAIT()	
end

EVENTS.HeavyTanks = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11080872)      -- LOCDB [11080872] 'Prep some AT! Krauts are lookin' to throw some heavy armor your way!'
	CTRL.WAIT()	

end
