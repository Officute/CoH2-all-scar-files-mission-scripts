EVENTS = {}


-- Who I've used for what:
--
-- ACTOR.American_Captain_01      -- the leader of the player's forces.
-- Intel										-- notify when enemy receieves reinforcements


EVENTS.IntroMsg = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("IntroMsg"))
end

EVENTS.IntroMsg_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075449) -- LOCDB [11075449] 'The Germans have all their armor sittin' in one place.  This is our chance to really deal a blow to 'em.  Destroy everything you can.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075450) -- LOCDB [11075450] 'Now I've got a report of an AT gun in the area.   See if you can track it down and put it to some good use.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroMsg_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079758) -- LOCDB [11079758] 'Alright, these dumbassed Germans have their vehicles amassed in one spot.  Gives us a prime opportunity - let's take em' out!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079759) -- LOCDB [11079759] 'We should be getting' some extra armour to help sort the Kraut tanks out, so watch for reinforcments.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075450) -- LOCDB [11075450] 'Now I've got a report of an AT gun in the area.   See if you can track it down and put it to some good use.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroMsg_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081578) -- LOCDB [11081578] 'Alright, Baker - The German's have got a bunch of mechanized forces sitting out in the open -- We're here to take advantage of the situation.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081579) -- LOCDB [11081579] 'We should be getting some extra armor to help deal with them. Now let's get out there and wreak some havoc!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075450) -- LOCDB [11075450] 'Now I've got a report of an AT gun in the area.   See if you can track it down and put it to some good use.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroMsg_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079880) -- LOCDB [11079880] 'Germans got armor amassing in the area. If we can assemble and strike 'em here, it could spare a lot of lives down the line.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079881) -- LOCDB [11079881] 'We ought to be getting' some armored reinforcements of our own to help deal with the enemy's build up.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075450) -- LOCDB [11075450] 'Now I've got a report of an AT gun in the area.   See if you can track it down and put it to some good use.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.IntroMsg_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080120) -- LOCDB [11080120] 'Alright Rangers, the Germans have their armor bunched up in one spot -- we got orders to hit 'em hard and fast.'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080121) -- LOCDB [11080121] 'Command's gonna be sendin' some armour reinforcements to ease our situation as well. Alright - let's move out!'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075450) -- LOCDB [11075450] 'Now I've got a report of an AT gun in the area.   See if you can track it down and put it to some good use.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.Reinforcements = function()
	local choices = {
		11075451,		 -- LOCDB [11075451] 'Mechanized support is on location.  Advise as needed.' - 'American Captain'
		11075452,		 -- LOCDB [11075452] 'More friendly vehicles just came in.  They need orders.' - 'American Captain'
		11075453,		 -- LOCDB [11075453] 'Allied tanks are rollin' in. Point 'em in the right direction.' - 'American Captain'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.EnemyTanks = function()
	local choices = {
		11075632, -- LOCDB [11075632] 'Enemy vehicles are being reported across the lines. Prepare for contact.' - 'Intel'
		11075633, -- LOCDB [11075633] 'German Panzer reinforcements are rollin' in.' - 'Intel'
		11075634, -- LOCDB [11075634] 'Stand to your anti-tank assets.   Panzers inbound.' - 'Intel'
	}
	CTRL.Actor_PlaySpeech(ACTOR.None, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

EVENTS.EnemyTankDestroyed = function()
	local choices = {
		11081217, -- LOCDB [11081217] 'Fuck yeah! Keep getting hits like that and we'll have the Germans down and out in no time!'
		11081218, -- LOCDB [11081218] 'One more Kraut tank down, they gotta be runnin low by now!'
		11081219, -- LOCDB [11081219] 'Another one bites the dust!'
		11081244, -- LOCDB [11081244] 'Fuck yeah! Kraut armour down!'
		11081245, -- LOCDB [11081245] 'Just took out another enemy vehicle!'
		11081246, -- LOCDB [11081246] 'That's another Kraut tank down!'
		11081247, -- LOCDB [11081247] 'Hit another Kraut vehicle, let's keep it up!'
		11081248, -- LOCDB [11081248] 'Another enemy tank down!'
		11081249, -- LOCDB [11081249] 'Another of Jerry's tanks is outta commission!'
		11081250, -- LOCDB [11081250] 'Took out another of Jerry's vehicles!'
		11081251, -- LOCDB [11081251] 'One less tank for Jerry to use against us!'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end



-- VICTORY ----------------------------------------------------------------------------------

EVENTS.Victory = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Victory"))
end

EVENTS.Victory_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11075658) -- LOCDB [11075658] 'They've lost too many vehicles. Their attack is stalled!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.Victory_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079760) -- LOCDB [11079760] 'Now that we've hit their vehicles the German's don't have the stomach for a fight…Fuckin' cowards are bailing out. Good job Able!'
	CTRL.WAIT()
end

EVENTS.Victory_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081580) -- LOCDB [11081580] 'These Germans will regret they day they met us.  Well done, men!'
	CTRL.WAIT()
end

EVENTS.Victory_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079882) -- LOCDB [11079882] 'Enemy armor's down -- Well done, Dog!'
	CTRL.WAIT()
end

EVENTS.Victory_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080122) -- LOCDB [11080122] 'Enemy tanks have been wiped out -- Bastards won't be mounting much of an attack after that.  Can always count on this company to get the job done.'
	CTRL.WAIT()
end

-- DEFEAT -------------------------------------------------------------------------------------

EVENTS.Defeat = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("Defeat"))
end

EVENTS.Defeat_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11076055) -- LOCDB [11076055] 'We've lost too many tanks!  Fall back!  Fall back!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.Defeat_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079761) -- LOCDB [11079761] 'Fuck -- bunch of our tanks got chewed up -- we can't do shit now… Bail out… Bail out, goddamnit!'
	CTRL.WAIT()
end

EVENTS.Defeat_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081581) -- LOCDB [11081581] 'These kraut's are too goddamn vicious - Fall back, Baker!'
	CTRL.WAIT()
end

EVENTS.Defeat_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079883) -- LOCDB [11079883] 'German's have hit our amour too hard - Pull back!'
	CTRL.WAIT()
end

EVENTS.Defeat_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080123) -- LOCDB [11080123] 'Shit -- we've are takin' hits left and right! What a goddamn fuck up - Fall back, Fox!'
	CTRL.WAIT()
end
