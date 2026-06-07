
EVENTS = {}

-- Who I've used for what:
-- ACTOR.None					-- situational updates from HQ about the airdrops and orders

	
EVENTS.VPVictoryMessage = function()
	Objective_Complete(OBJ_Victory)

end

-- INTRO -----------------------------------------------------------------------------------------------------

EVENTS.Mission_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Mission_Start"))
end

EVENTS.Mission_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074699)      -- LOCDB [11074699] 'Germans are tryin' to air drop supplies.  They have no idea we're Johnny on the spot.  Get to it before they know we're around.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074700)      -- LOCDB [11074700] 'Now, the weather's bad so I can't get a clear read on drop zones, but I might be able to pin point a sector.  Just be ready to move.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074701)      -- LOCDB [11074701] 'We can get a better view of the sector if you can secure high ground.  There's some watch towers in the area that might help out.' - 'Intel'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079821) -- LOCDB [11079821] 'Alright boys, looks like these dumbassed Krauts are tryin' to drop supplies to their troops. Supplies we could use just as much as them.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079822) -- LOCDB [11079822] 'Weather's a pain in the ass -- so Recon can't pinpoint the exact drop zones - but we should be able to get the general location. Let's beat the Germans to their own supplies - send the bastards home empty handed!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079823) -- LOCDB [11079823] 'There's some watchtowers in the area - Haul ass to 'em and clear the high ground.  We'll have a better view the drop zone's from up there!'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081641) -- LOCDB [11081641] 'Listen up -- Germans are air-dropping supplies. We gotta' hustle to the drop-zones and get a leg up on them!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081642) -- LOCDB [11081642] 'The weather's hampering our line of sight… we aren't gonna be pinpointing any drop zones.  We'll have to search the sector in a hurry to get the supplies before Jerry.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081643) -- LOCDB [11081643] 'There are watchtowers nearby if we can secure them, the high ground will give us a better vantage on the drops and an edge over the Germans.'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079943) -- LOCDB [11079943] 'We've got intel that says the Germans are air dropping supplies.  This is a real jackpot.  If we reach the drop zones before they do we'll gain a massive edge…We can't pass up this opportunity.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079944) -- LOCDB [11079944] 'Damnit - weather is obscuring my vision…Having a hell of a time acquiring the drop zones…Can only hope I can locate a sector and we can go from there.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079945) -- LOCDB [11079945] 'We need to seize control of the watch towers in the area.  We can better track enemy movement from up top…Maybe we can avoid a massive firefight.'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080183) -- LOCDB [11080183] 'Germans are beginning to air-drop supplies.  Let's move in on the drop-zones before they're alerted to our presence.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080184) -- LOCDB [11080184] 'The weather's working against us -- can't spot the locations of the supply drops.  Hold fast.  Just need to zero in on the sector then we can move in on em'.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080185) -- LOCDB [11080185] 'Secure the watchtowers -- the high vantage point will give us a strategic advantage out here…Germans will walk right in to a death trap.'
	CTRL.WAIT()
	EnemyAirSupport()
end


function EnemyAirSupport()
	
	-- node strength: call out about enemy air support
	if XP1_GetNodeStrength() >= 3 then
		local choices = {
			11080876, -- LOCDB [11080876] 'Got intel that Jerry's got air support prepped, keep an eye on the skies out there!'
			11080877, -- LOCDB [11080877] 'Check your sectors, got reports of enemy aircraft in the area'
		}
		CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
		CTRL.WAIT()
	end
end



EVENTS.AirDropInc = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074703)      -- LOCDB [11074703] 'Air drop inbound.  E-T-A 15 seconds.  Stand by.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.AirDrop = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074704)      -- LOCDB [11074704] 'Incoming Air Drop!' - 'Intel'
	CTRL.WAIT()
end

--~ EVENTS.GermansCapturedAirDrop = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074705)      -- LOCDB [11074705] 'Damnit Germans got to the supplies.' - 'Intel'
--~ 	CTRL.WAIT()
--~ end

--~ EVENTS.AlliesCapturedAirDrop = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.None, 11074706)      -- LOCDB [11074706] 'Let's get those supplies where they're needed.' - 'Intel'
--~ 	CTRL.WAIT()
--~ end

EVENTS.AlliedFuelLow = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074707)      -- LOCDB [11074707] 'Q-M reports supplies are running low.  Do what you can to get your hands on some more.' - 'Intel'
	CTRL.WAIT()
end



-- VICTORY ---------------------------------------------------------------------------------------------------

EVENTS.Victorious = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victorious"))
end

EVENTS.Victorious_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11076135)    -- LOCDB [11076135] 'That's it. That was the last sortie of supply drops.  Germans are gonna pay dearly for that screw up.' - 'None'
	CTRL.WAIT()	
end

EVENTS.Victorious_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079820) -- LOCDB [11079820] 'All key sectors clear. Way to step up to the plate boys!'
	CTRL.WAIT()
end

EVENTS.Victorious_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081640) -- LOCDB [11081640] 'We're in great shape -- all key areas are clear…Germans are falling back…'
	CTRL.WAIT()
end

EVENTS.Victorious_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079942) -- LOCDB [11079942] 'The sector is ours!... The Germans gave us all we could handle but we persevered…I'm damn proud of you boys.'
	CTRL.WAIT()
end

EVENTS.Victorious_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080182) -- LOCDB [11080182] 'Area secure -- Germans didn't stand a chance against us.  Good work, Rangers!'
	CTRL.WAIT()
end

-- DEFEAT ---------------------------------------------------------------------------------------------------

EVENTS.Defeated = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeated"))
end

EVENTS.Defeated_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11076136)    -- LOCDB [11076136] 'Well you cocked that up.  Wasted a good opportunity to really hand it to 'em.' - 'None'
	CTRL.WAIT()	
end

EVENTS.Defeated_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079819) -- LOCDB [11079819] 'Goddamnit -- Krauts took the sector -- pull back before this gets more bungled up!'
	CTRL.WAIT()
end

EVENTS.Defeated_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081639) -- LOCDB [11081639] 'German's have seized control of the region -- fall back before they wipe out the entire unit!'
	CTRL.WAIT()
end

EVENTS.Defeated_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079941) -- LOCDB [11079941] 'Damnit -- the Germans have managed to take control of the sector…Fall back and regroup…I don't want any unnecessary losses on my hands.'
	CTRL.WAIT()
end

EVENTS.Defeated_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080181) -- LOCDB [11080181] 'The Germans have taken the sector -- goddamnit!...Fall back!'
	CTRL.WAIT()
end

------------------------------------------------------------------------------------------------------------NEW AUDIO-------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

EVENTS.AlliesCapturedAirDrop = function()
	local choices = {
		
		11081220, -- LOCDB [11081220] 'We got the drop!'
		11081221, -- LOCDB [11081221] 'Supply drop secure!'
		11081222, -- LOCDB [11081222] 'Secured the supplies!'
		11081252, -- LOCDB [11081252] 'Alright, the supplies are ours!'
		11081253, -- LOCDB [11081253] 'German's ain't getting these supplies!'
		11081254, -- LOCDB [11081254] 'Hah! Grabbed 'em from right under Jerry's nose!'
		11081255, -- LOCDB [11081255] 'Got the Kraut's supplies'
		11081256, -- LOCDB [11081256] 'The drop is ours!'
		11081257, -- LOCDB [11081257] 'Boy, Jerry is gonna be *supplized*'
		11081258, -- LOCDB [11081258] 'We nabbed the drop!'

	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end


EVENTS.GermansCapturedAirDrop = function()
	local choices = {
		
		11080895, -- LOCDB [11080895] 'Jerry secured the supplies; prepare for the next drop!'
		11080896, -- LOCDB [11080896] 'The Germans got the drop; square away for the next one.'
		11080897, -- LOCDB [11080897] 'The enemy picked up the drop; stand by for the next.'
		11080898, -- LOCDB [11080898] 'Germans got the drop!'

	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end



