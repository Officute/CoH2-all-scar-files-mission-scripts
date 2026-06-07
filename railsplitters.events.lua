EVENTS = {}

--
-- Who I've used for what:
-- ACTOR.American_Riflemen_01 -- Soldier's accounts of what they see with some guidance for the player
-- ACTOR.American_Lieutenant_01   -- generic on-the-ground suggestions and orders to the soldiers
-- ACTOR.None                     -- radio voice, used here to relay orders from the top generals
--

-- INTRO ---------------------------------------------------------------------
EVENTS.Mission_Start = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Mission_Start"))
end

EVENTS.Mission_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075611 ) -- LOCDB [11075611] 'Germans are rollin' command trucks into the zone.    Knock out whatever you can, but make sure our HQ elements are protected.  They'll try to counter to even out the odds.' - 'Intel'
	CTRL.WAIT()
	EnemyAirSupport()
end


EVENTS.Mission_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079799) -- LOCDB [11079799] 'Watch out -- Enemy command units are rollin' in!  We gotta' take em' out, disrupt Jerry's C&C! Gotta do it before they turn our HQ to ash though, no time to fuck around -- move!'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081619) -- LOCDB [11081619] 'Alright, the Germans have some command vehicles coming in towards us - it's gonna be a hell of a fight, but we need to take them out. We gotta hit them hard and fast - get to it, Baker!'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079921) -- LOCDB [11079921] 'Incoming -- German command trucks!...Defend the bases at all costs!'
	CTRL.WAIT()
	EnemyAirSupport()
end

EVENTS.Mission_Start_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080161) -- LOCDB [11080161] 'Listen up Rangers -- We've got incoming…The Germans are looking to break our command lines...It's our job to stop 'em...We are the shield out there…So rally together and see it done!'
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



EVENTS.Explain_Scoring = function() 
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075614 ) -- LOCDB [11075614] 'Hit that truck while its movin'!  Don't let it set up!' - 'American Rifleman'
	CTRL.WAIT()
end

EVENTS.Strategy_Hint= function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075615  ) -- LOCDB [11075615] 'We need to do something about that flak gun!  It's gonna eat us alive!' - 'American Rifleman'
	CTRL.WAIT()
	Rule_AddOneShot(ShowReport, 2)
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11075616 ) -- LOCDB [11075616] 'Maybe we can skirt around it!  Find a better way to hit it!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.Follow_Up = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075617  )  -- LOCDB [11075617] 'Hold your position!  Try a pincer attack on that halftrack!  Hit it on both sides!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.Explain_Retribution = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075618  )  -- LOCDB [11075618] 'Hit that truck quick!  And then get the fuck back to HQ!  Germans will want payback!' - 'American Rifleman'
	CTRL.WAIT()
end

EVENTS.Near_Winning = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11075619 )  -- LOCDB [11075619] 'We've really kicked their teeth in, but we gotta do one more for good measure!' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.Near_Losing = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11075620 )  -- LOCDB [11075620] 'Redeploy your squads!  We can't lose anymore positions around the HQ!' - 'American Lieutenant'
	CTRL.WAIT()
end





-- VICTORY -----------------------------------------------------------

EVENTS.Winning_Complete = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Winning_Complete"))
end

EVENTS.Winning_Complete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01,  11075836 )  -- LOCDB [11075836] 'Hooah! Strike Hard, soldiers! We just turned a SNAFU into a commendation.' - 'American Lieutenant'
	CTRL.WAIT()
end

EVENTS.Winning_Complete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079800) -- LOCDB [11079800] 'Fuck yeah -- nailed em'! Goddamn impressive work, boys!'
	CTRL.WAIT()
end

EVENTS.Winning_Complete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081620) -- LOCDB [11081620] 'The German command trucks are down, we've done it, men!'
	CTRL.WAIT()
end

EVENTS.Winning_Complete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079922) -- LOCDB [11079922] 'Target destroyed!...Game over!'
	CTRL.WAIT()
end

EVENTS.Winning_Complete_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080162) -- LOCDB [11080162] 'Targets eliminated -- we're firing on all cylinders!'
	CTRL.WAIT()
end


-- DEFEAT -----------------------------------------------------------

EVENTS.Losing_Complete = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Losing_Complete"))
end

EVENTS.Losing_Complete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075837 )  -- LOCDB [11075837] 'They are crushing our base! Retreat! Retreat!' - 'American Rifleman'
	CTRL.WAIT()
end

EVENTS.Losing_Complete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079801) -- LOCDB [11079801] 'HQ's being demolished!  Pull back! Pull back goddamnit!'
	CTRL.WAIT()
end

EVENTS.Losing_Complete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081621) -- LOCDB [11081621] 'Goddamn, the Germans are wreaking havoc on our HQ - Retreat, Baker!'
	CTRL.WAIT()
end

EVENTS.Losing_Complete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079923) -- LOCDB [11079923] 'They've toppled our HQ bases Get to cover!...Move!'
	CTRL.WAIT()
end

EVENTS.Losing_Complete_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080163) -- LOCDB [11080163] 'Our bases are absorbing massive blows…Move out!...Go!'
	CTRL.WAIT()
end

