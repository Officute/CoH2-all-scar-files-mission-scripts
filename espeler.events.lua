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
--Intro NISlet
--~ NIS_EVENTS.IntroNISlet = function()
--~ 	Game_SubTextFade(LOC("Date"), LOC("Location"), 0.5, 4, 0.5)
--~ 	CTRL.Game_TextTitleFade( LOC("Noville"), 0.3, 0.8, 0.2)
--~ 	CTRL.WAIT()
--~ end


--
-- Who I've used for what:
--
-- ACTOR.American_Captain_01      -- the leader of the player's forces.
-- ACTOR.American_Riflemen_01  	  -- generic on-the-ground alerts
-- ACTOR.None	 					 -- intel on enemy movements



--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE 1: Destroy HQ halftracks -------------------------------------------
--[[********************************************************************************************************]]

-- Intro
EVENTS.OBJ_DestroyBases = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("OBJ_DestroyBases"))
end

EVENTS.OBJ_DestroyBases_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074854)      -- LOCDB [11074854] 'German's got a bunch of command halftracks in Espeler.  We can really put a wrench in their plans if we can knock those vehicles out.  Get a strike team assembled and hit 'em fast.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.OBJ_DestroyBases_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079777)      -- LOCDB [11079777] 'Okay, here's the the skinny: We've discovered the German's have some command vehicles around Espeler.  If we're able to put them out of commission their command chain will take a massive blow.  Alright enough chit-chat -- let's get it done!'
	CTRL.WAIT()
end

EVENTS.OBJ_DestroyBases_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081597)      -- LOCDB [11081597] 'We've got word that the German's have command vehicles kicking around in Espeler.  Taking them out would go a long way in disrupting their chain of command.  Let's get it done, men!'
	CTRL.WAIT()
end

EVENTS.OBJ_DestroyBases_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079899)      -- LOCDB [11079899] 'Alright men -- we need to nullify the German command units in Espeler.   That will hinder their ability to coordinate any attack.'
	CTRL.WAIT()
end

EVENTS.OBJ_DestroyBases_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080139)      -- LOCDB [11080139] 'Intel is showing the Germans have command vehicles gathered in Espeler...This is a golden opportunity to turn the Germans' plans on their ear...Form up and strike -- full throttle!'
	CTRL.WAIT()
end

-- second part of intro talking about IR halftracks
EVENTS.OBJ_DestroyHalftracks = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074855)      -- LOCDB [11074855] 'We got reports of IR halftracks in the area.  If they spot us, those command vehicles will pull outta there.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074856)      -- LOCDB [11074856] 'Swing around those IR tracks. Only  use direct fire on 'em or the whole area will know you're coming.' - 'Intel'
	CTRL.WAIT()
end

-- alert for when player hits a halftrack with artillery
EVENTS.ArtilleryWarning = function()
	local choices = {
		11074857,      -- LOCDB [11074857] 'Do not engage those IR halftracks with indirect assets!' - 'American Captain'
		11074858,      -- LOCDB [11074858] 'Cease fire!  Cease fire!  Those IR units will blow our initiative if you keep hitting 'em like that!' - 'American Captain'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

-- warnings for when an hq is retreating
EVENTS.RetreatHqWarning1 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074859)      -- LOCDB [11074859] 'Forward Observers report the command halftrack is pulling out!  Don't let it escape.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.RetreatHqWarning2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074860)      -- LOCDB [11074860] 'That command halftrack is making a break for it!  You need to plough through and stop it!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.RetreatHqWarning3 = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074861)      -- LOCDB [11074861] 'Command halftrack just went mobile!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HqEscaped = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074862)      -- LOCDB [11074862] 'One of the command halftracks just escaped!' - 'Intel'
	CTRL.WAIT()
end

-- WIN: for when all hq's are destroyed  -------------------------------------------------------------------------

EVENTS.MissionCompleteFull = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionCompleteFull"))
end

EVENTS.MissionCompleteFull_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074863)      -- LOCDB [11074863] 'All targets destroyed. Kraut command structure's been blown.  God damn fine job.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.MissionCompleteFull_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079778)      -- LOCDB [11079778] 'Direct fuckin' hit!  German command units are down!  Krauts on the ground will be scrambling! Way to go boys!'
	CTRL.WAIT()
end

EVENTS.MissionCompleteFull_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081598)      -- LOCDB [11081598] 'That's it!...Enemy command units have been neutralized!... We've cut the head from the beast, men!'
	CTRL.WAIT()
end

EVENTS.MissionCompleteFull_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079900)      -- LOCDB [11079900] 'Targets negated!...Command chain's been shattered! Way to knock one out of the park boys!'
	CTRL.WAIT()
end

EVENTS.MissionCompleteFull_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080140)      -- LOCDB [11080140] 'We snuffed out the targets! Enemy command structure's been severed!  That's a big leap forward out here.'
	CTRL.WAIT()
end


-- WIN: for when the player won but allowed an hq to escape ----------------------------------------------------

EVENTS.MissionCompletePartial = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionCompletePartial"))
end

EVENTS.MissionCompletePartial_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074864)      -- LOCDB [11074864] 'Didn't manage to hit all the targets, but still did a number on the enemy's command structure. That'll do, boys.' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.MissionCompletePartial_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079779)      -- LOCDB [11079779] 'A few vehicles slipped through the cracks, but we were able to wipe most of em' out…A damn fine effort in my book.'
	CTRL.WAIT()
end

EVENTS.MissionCompletePartial_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081599)      -- LOCDB [11081599] 'That's the last left in the area - well done Baker! I'd chalk this one up as a success.'
	CTRL.WAIT()
end

EVENTS.MissionCompletePartial_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079901)      -- LOCDB [11079901] 'It was hit and miss out there.  Luckily we hit more than we missed.  At least we were able to disrupt their command structure -- that's a step in the right direction.'
	CTRL.WAIT()
end

EVENTS.MissionCompletePartial_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080141)      -- LOCDB [11080141] 'We didn't clear out all the targets, but we dealt a serious blow to the German command structure -- great fucking job!'
	CTRL.WAIT()
end

-- Mission fail -----------------------------------------------------------------------------------------------------------

EVENTS.MissionFailure = function()
	XP1_PlayCompanySpeechLine(XP1_ConstructCompanySpeechTable("MissionFailure"))
end

EVENTS.MissionFailure_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074865)      -- LOCDB [11074865] 'God dammit!  The bulk of their command structure got away!  We fucked a great chance here!' - 'American Captain'
	CTRL.WAIT()
end

EVENTS.MissionFailure_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079780)      -- LOCDB [11079780] 'Shit -- we had a golden opportunity and those command units got right by us… It's time to get heads outta' our asses!'
	CTRL.WAIT()
end

EVENTS.MissionFailure_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081600)      -- LOCDB [11081600] 'Goddamn! The enemy command vehicles escaped.  Missed a huge opportunity.'
	CTRL.WAIT()
end

EVENTS.MissionFailure_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079902)      -- LOCDB [11079902] 'That was a massive blunder…We lost the targets…Just took a major leap back.'
	CTRL.WAIT()
end

EVENTS.MissionFailure_RANGER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080142)      -- LOCDB [11080142] 'Fuck -- most of their command structure eluded us…We botched a golden opportunity…I expected more from you guys!'
	CTRL.WAIT()
end

--[[********************************************************************************************************]]
------------------------------------------ OBJECTIVE 2: Destroy IR halftracks -------------------------------------------
--[[********************************************************************************************************]]

-- warning of panzer attack
EVENTS.HalftrackSpotted = function()
	local choices = {
		11074866,      -- LOCDB [11074866] 'IR signature detected.  Watch your front and see if you can skirt the area.' - 'American Riflemen'
		11074867,      -- LOCDB [11074867] 'Shit, IR Halftrack dead-ahead.  Keep clear of its searchlight.' - 'American Riflemen'
		11074868,      -- LOCDB [11074868] 'Heads up.  Kraut IR spotted.  Keep your guard up.' - 'American Riflemen'
		11074869,      -- LOCDB [11074869] 'We got a position on an IR halftrack.  Reference your map for grid.' - 'American Riflemen'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end

-- warning of light armour counter attack
EVENTS.PlayerSpotted = function()
	local choices = {
		11074870,      -- LOCDB [11074870] 'We've been spotted!  Expect enemy contact!' - 'American Riflemen'
		11074871,      -- LOCDB [11074871] 'They've seen us!  Get ready for enemy contact!' - 'American Riflemen'
		11074872,      -- LOCDB [11074872] 'IR contact! Shake it out!  Get ready for Krauts!' - 'American Riflemen'
	}
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, Table_GetRandomItem(choices))
	CTRL.WAIT()
end


-- pak 43 spotted
EVENTS.Pak43 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074873)      -- LOCDB [11074873] 'Boys ran up on a heavy A-T gun!  Could come in handy if we grab it.' - 'American Riflemen'
	CTRL.WAIT()
end


-- node strength: when a sniper is spotted
EVENTS.SniperSpotted = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080796)      -- LOCDB [11080796] 'Watch your steps; they got snipers nearby!'
	CTRL.WAIT()
end
