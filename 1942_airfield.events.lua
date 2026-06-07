print("\tLoading .events file...")

-- IntelEvents Table Container.
--	This contains all Regular IntelEvent functions (simple dialogue).
EVENTS = {}

-- NIS events table container.
--	Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. 
--	These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic.
NIS_EVENTS = {}



--[[****************************************************************************************************]]
------------------------------------------ EVENTS -----------------------------------------------------
--[[****************************************************************************************************]]

EVENTS.MissionStart = function()

	CTRL.Event_Delay(1)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052204)	-- LOCDB [11052204] "The Fascist Sixth Army has been trapped in Stalingrad for a month now, Comander." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052205)	-- LOCDB [11052205] "But German air support has kept their troops supplied." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052206)	-- LOCDB [11052206] "That ends tonight." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()

	CTRL.Event_Delay(0.7)
	CTRL.WAIT()

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052207)	-- LOCDB [11052207] "You will lead your armored forces into the German airfield at Tatsinskaya and destroy their aircraft." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052289)	-- LOCDB [11052289] "Victory in Stalingrad depends on your efforts, Comrade." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()

end

EVENTS.MissionComplete = function() -- 030

	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052208)	-- LOCDB [11052208] "The Soviet raid on Tatsinskaya Airfield cost the Luftwaffe over seventy aircraft and cut the supply routes to the Sixth Army." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052209)	-- LOCDB [11052209] "Many of the  men involved in the daring raid paid with their lives, but their accomplishment would finally free Stalingrad from the Germans." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()

end


EVENTS.MissionFailed = function() -- 040

	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052210)	-- LOCDB [11052210] "All our units have been destroyed! You have failed." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()

end



--[[*********************************************************************************************]]
------------------------------------------ BREACH GATES -------------------------------------------
--[[*********************************************************************************************]]

EVENTS.BreachGates_CallOutHowitzers = function() -- 050
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052211)	-- LOCDB [11052211] "Howitzers have your position! Find them and eliminate them!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.BreachGates_OneHowitzerDestroyed = function() -- 060
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052212)	-- LOCDB [11052212] "One Howitzer destroyed. Find and kill the other." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end





--[[***********************************************************************************************]]
---------------------------------------- DESTROY AIRCRAFT -------------------------------------------
--[[***********************************************************************************************]]

EVENTS.DestroyAircraft_ObjectiveStart = function() -- 070
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052213)	-- LOCDB [11052213] "There: Stuka on the airfield." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052214)	-- LOCDB [11052214] "Take out any and all aircraft still on the ground." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.DestroyAircraft_FirstDestroyed = function() -- 080
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052215)	-- LOCDB [11052215] "Excellent. Continue to destroy those aircraft." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.DestroyAircraft_OneRemaining = function()  -- 090
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052216)	-- LOCDB [11052216] "Only one Stuka remains to be destroyed, Comrade." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.DestroyAircraft_AllDone = function() -- 100
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052217)	-- LOCDB [11052217] "That is all the aircraft on the ground destroyed! Well done!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.DestroyAircraft_ObjectiveReminder = function()
	CTRL.Event_Delay(1.0)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052214)	-- LOCDB [11052214] "Take out any and all aircraft still on the ground." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end




--[[******************************************************************************************]]
---------------------------------------- FUEL DEPOTS -------------------------------------------
--[[******************************************************************************************]]

EVENTS.FuelDepot_Intro = function() -- 110
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052218)	-- LOCDB [11052218] "There are fuel depots to the north and south of the airfield." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052219)	-- LOCDB [11052219] "You can strengthen your forces by securing them, Comrade." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.FuelDepot_Bonus1 = function() -- 120
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052220)	-- LOCDB [11052220] "Good work, Comrade Commander. You may call in an additional tank to bolster your forces." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.FuelDepot_Bonus2 = function() -- 130
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052221)	-- LOCDB [11052221] "Excellent: Both fuel depots captured. You may call in another vehicle." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

EVENTS.FuelDepot_Bonus2_KV2 = function() -- 140
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052222)	-- LOCDB [11052222] "Excellent, both fuel depots have been captured! You may now call in a KV-2 Heavy Assault Tank." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end



--[[**********************************************************************************************]]
------------------------------------------ CONTROL TOWER -------------------------------------------
--[[**********************************************************************************************]]


EVENTS.ControlTower_IncomingStukas1 = function() -- 150
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052223)	-- LOCDB [11052223] "Incoming air strike!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end
EVENTS.ControlTower_IncomingStukas2 = function() -- 160
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052224)	-- LOCDB [11052224] "Stukas on the attack!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end
EVENTS.ControlTower_IncomingStukas3 = function()  -- 170
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052225)	-- LOCDB [11052225] "Air attack approaching!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end
EVENTS.ControlTower_IncomingStukas4 = function()  -- 180
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052226)	-- LOCDB [11052226] "Stukas on approach!" MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end





--[[**********************************************************************************************]]
------------------------------------------ COUNTERATTACK -------------------------------------------
--[[**********************************************************************************************]]


EVENTS.Counterattack_Start = function() -- 190
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052227)	-- LOCDB [11052227] "Enemy units are on the move to your location to retake the airfield." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Radio_Command, 11052228)	-- LOCDB [11052228] "You must hold out against the counterattack, Comrade." MISSION "1942_Airfield" CHARACTER "Soviet Commander"
	CTRL.WAIT()
end

