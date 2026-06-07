print("\tLoading .events file...")

-- IntelEvents Table Container.
--	This contains all Regular IntelEvent functions (simple dialogue).
EVENTS = {}

-- NIS events table container.
--	Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. 
--	These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic.
NIS_EVENTS = {}



--[[****************************************************************************************************]]
--------------------------------------------- EVENTS -----------------------------------------------------
--[[****************************************************************************************************]]

EVENTS.MissionStart = function()		-- s010

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055113)	-- LOC("It seems the Wehrmacht's Second Panzer Division has attempted to withdraw through this region, though they are unprepared for the conditions.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055114)	-- LOC("The spring rasputitsa has turned the ground into thick mud and reports suggest the German amour is ensnared in it.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055115)	-- LOC("We will ambush them while they are waylaid and destroy as many Panzers as possible before they can withdraw.")
	CTRL.WAIT()

end

EVENTS.MissionComplete = function()		-- s020

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055116)	-- LOC("Fresh from victory in Stalingrad, the Red Army launched multiple successful campaigns against disorganized and depleted German forces.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055117)	-- LOC("During January and February 1943, the Germans would lose the cities of Kharkov, Kursk and Belgorod.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055118)	-- LOC("However, after an aggressive and successful advance, the Red Army had overextended itself.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055622)	-- LOC("The spring of 1943 would give the Wehrmacht a chance to regroup, reorganise and attempt to seize back the momentum.")
	CTRL.WAIT()

end


EVENTS.MissionFailed = function()		-- s030

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055119)	-- LOC("Too many of the German panzer crews have escaped the mud.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055120)	-- LOC("We have failed.")
	CTRL.WAIT()

end



--[[*****************************************************************************************]]
-------------------------------------- FIND AND DESTROY ---------------------------------------
--[[*****************************************************************************************]]

--
-- objective progress
--
EVENTS.FindAndDestroy_OneMoreToDestroy = function()		-- s040
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055121)	-- LOC("Good work, soldier! Just one more tank to go!")
	CTRL.WAIT()
	
end

EVENTS.FindAndDestroy_TooManyEscaping = function()		-- s050
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055122)	-- LOC("Panzers are escaping! Redouble your efforts and destroy the waylaid tanks!")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055123)	-- LOC("This mud is the perfect opportunity. Don't waste it!")
	CTRL.WAIT()
	
end


--
-- lines for spotting various types of encounters (not the abandoned tank encounter - that has its own subobjective with all its own speech)
--
EVENTS.SingleTank_Spotted = function()					-- s060

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055124)	-- LOC("Panzer spotted.")
	CTRL.WAIT()
	
end


EVENTS.DoubleTank_Spotted = function()					-- s070

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055125)	-- LOC("Two more Panzers. It looks like they're guarded.")
	CTRL.WAIT()
	
end


EVENTS.ElefantTank_Spotted = function()					-- s080

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055126)	-- LOC("Look out! Elefant tank spotted!")
	CTRL.WAIT()
	
end


--
-- lines played when a tank is dug out of the mud and starts moving off (two versions - one if the player can see the tank drive off, and another for when they can't)
--
EVENTS.TankOnTheMove_InSight = function()				-- s090

	local choices = {
		11055127,	-- LOC("They got the tank free!")
		11055128,	-- LOC("That tank is out of the mud! Get it before it escapes!")	
		11055129,	-- LOC("Enemy tank on the move!")
	}
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Table_GetRandomItem(choices))
	CTRL.WAIT()
	
end

EVENTS.TankOnTheMove_OutOfSight = function()			-- s100

	local choices = {
		11055130,	-- LOC("It sounds like a tank is free from the mud...")
		11055131,	-- LOC("Hear that? The next Panzer is fleeing!")
		11055132,	-- LOC("Sounds like motion... a Panzer is on the move.")
	}
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Table_GetRandomItem(choices))
	CTRL.WAIT()
	
end






--[[*******************************************************************************************]]
---------------------------------------- ABANDONED TANK -----------------------------------------
--[[*******************************************************************************************]]


EVENTS.AbandonedTank_Spotted = function()				-- s110

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055133)	-- LOC("Attention! We’ve spotted what looks to be the German’s new Sturmpanzer tank.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055134)	-- LOC("It seems to be unmanned, but troops are guarding it.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055135)	-- LOC("See if you can capture it! Our engineers would like to examine it.")
	CTRL.WAIT()

end
EVENTS.AbandonedTank_SpottedSubsequent = function()		-- s120

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055136)	-- LOC("We’ve spotted another Sturmpanzer")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055137)	-- LOC("Capture that one, too, if you can.")
	CTRL.WAIT()

end
EVENTS.AbandonedTank_Captured = function()				-- s130

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055138)	-- LOC("You have captured the Sturmpanzer. Excellent.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055139)	-- LOC("Now get it out of the mud and back to base.")
	CTRL.WAIT()

end
EVENTS.AbandonedTank_Completed = function()				-- s140

	CTRL.Event_Delay(3)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055140)	-- LOC("Excellent work. Our engineers can strip the Sturmpanzer down and expose its weaknesses.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055249)	-- LOC("As a reward, we are sending you some reinforcements.")
	CTRL.WAIT()

end





--[[*******************************************************************************************]]
---------------------------------------- MISC ENVIRONMENT ---------------------------------------
--[[*******************************************************************************************]]

EVENTS.EnemyWatchtowerSpotted = function()				-- s150

	local choices = {
		11055141,	-- LOC("Look out! There is incoming fire from those watchtowers.")
		11055142,	-- LOC("Enemy units firing upon us from those watchtowers!")
	}
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, Table_GetRandomItem(choices))
	CTRL.WAIT()

end
EVENTS.AllWatchtowersOccupied = function()				-- s160

	CTRL.Event_Delay(6)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055247)	-- LOC("With all of the watchtowers occupied, we have good sightlines throughout the area.")
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11055248)	-- LOC("We can now call in targetted aerial bombardments.")
	CTRL.WAIT()

end
