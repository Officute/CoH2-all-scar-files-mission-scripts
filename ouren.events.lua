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



--
-- Who I've used for what:
--
-- ACTOR.American_Captain_01	-- the leader of the player's forces.
-- ACTOR.American_Major_01		-- the leader of the allies fighting from the north. They also give the status reports on the northern bridge
-- ACTOR.American_Lieutenant_01 -- generic on-the-ground reports
-- ACTOR.None					-- radio voice, used here for the reconnaissance team (when they relay reports to you directly - sometimes it's via the Captain).
--




--[[********************************************************************************************************]]
--------------------------------------------------- Intro ----------------------------------------------------
--[[********************************************************************************************************]]

-- played right at the start of the mission
EVENTS.MissionIntro = function()

	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.MissionIntro_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.MissionIntro_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.MissionIntro_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.MissionIntro_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.MissionIntro_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)
	
end
EVENTS.MissionIntro_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074424)		-- LOCDB [11074424] 'Alright! Look alive.  The bridge is just ahead!  The hundred and twelfth is to the north tryin' to secure the other crossing.  Someone get me a sitrep on 'em.' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074425)				-- LOCDB [11074425] 'The 1-12th is on final approach.  We're 3 minutes out.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074426)		-- LOCDB [11074426] 'Alright, get the battle group movin'!  Let's go!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.MissionIntro_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079787)					-- LOCDB [11079787] 'Alright fellas, we gotta' secure and hold the Southern bridge just up ahead.  Our boys in the hundred and twelfth are to the North taking the crossing there. Somebody get eyes on em' and give me a sit-rep!'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074425)				-- LOCDB [11074425] 'The 1-12th is on final approach.  We're 3 minutes out.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074426)		-- LOCDB [11074426] 'Alright, get the battle group movin'!  Let's go!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.MissionIntro_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081607)					-- LOCDB [11081607] 'The Our river, along with the bridge we've gotta secure, is just ahead. While we're taking it, the twelfth is gonna be up North gaining control of the crossing there. Someone get me a sitrep on them!'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074425)				-- LOCDB [11074425] 'The 1-12th is on final approach.  We're 3 minutes out.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074426)		-- LOCDB [11074426] 'Alright, get the battle group movin'!  Let's go!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.MissionIntro_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079909)					-- LOCDB [11079909] 'Alright, men - We gotta secure the bridge  just up ahead.  The hundred and twelfth is to the north attempting to clear the other crossing.  Someone get eyes on 'em and relay their progress.'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074425)				-- LOCDB [11074425] 'The 1-12th is on final approach.  We're 3 minutes out.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074426)		-- LOCDB [11074426] 'Alright, get the battle group movin'!  Let's go!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.MissionIntro_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080149)					-- LOCDB [11080149] 'Heads up -- got eyes on the bridge up ahead.  Our mission is to hold that crossing… The boys in the hundred and twelfth are up North doing their best trying to secure the the bridge up there.   Someone get me an update on their progress.'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074425)				-- LOCDB [11074425] 'The 1-12th is on final approach.  We're 3 minutes out.' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074426)		-- LOCDB [11074426] 'Alright, get the battle group movin'!  Let's go!' - 'American Captain'
	CTRL.WAIT()
end



--[[********************************************************************************************************]]
------------------------------------------------ OBJ_Bridges -------------------------------------------------
--[[********************************************************************************************************]]

-- partway after taking the first bridge, you get this report from the allies on the northern bridge - basically tells the player to assist.
EVENTS.Bridges_TalkAboutHelpingAllies = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074428)				-- LOCDB [11074428] '1-12th status update, the Germans are dug in on the opposite bank… We can't get across the bridge!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074429)		-- LOCDB [11074429] 'Hang tight! We're on our way up there!' - 'American Captain'
	CTRL.WAIT()
	
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074427)		-- LOCDB [11074427] 'They're hittin' heavy resistance in the North!  Get a strike force up there and see what you can do to help out!' - 'American Captain'
	CTRL.WAIT()
	
end


--[[********************************************************************************************************]]
------------------------------------------ SOBJ_SouthBridge Events -------------------------------------------
--[[********************************************************************************************************]]


-- when the enemies fall back over the bridge
EVENTS.SouthBridge_Fallback = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074430)	-- LOCDB [11074430] 'They're tryin' to cross over!  Consolidate on the Southern bridge!' - 'American Lieutenant'
	CTRL.WAIT()
end

-- when the enemy mortar starts shelling the bridge directly
EVENTS.SouthBridge_MortarAttackingBridge = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074431)	-- LOCDB [11074431] 'They're droppin' mortars on the bridge!  Crazy bastards are tryin' to take it out!' - 'American Lieutenant'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11074432)	-- LOCDB [11074432] 'Find that mortar and knock it out!' - 'American Lieutenant'
	CTRL.WAIT()
end

-- when the bridge is secured
EVENTS.SouthBridge_Secured = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074433)		-- LOCDB [11074433] 'We secured the bridge in the south!  Consolidating on the bank now!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074434)		-- LOCDB [11074434] 'Get me a defensive perimeter around this god damn bridge!  We can't let it get knocked out!' - 'American Captain'
	CTRL.WAIT()
end


-- when the bridge is heavily damaged
EVENTS.SouthBridge_HeavilyDamaged = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074435)		-- LOCDB [11074435] 'Southern bridge is takin' a beatin'!  It ain't gonna last long at this rate!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.SouthBridge_HeavilyDamaged_Stage2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074436)		-- LOCDB [11074436] 'The sub-structure is startin' to weaken!' - 'American Captain'
	CTRL.WAIT()
end

-- when the bridge is destroyed
EVENTS.SouthBridge_Destroyed = function()
	
	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.SouthBridge_Destroyed_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.SouthBridge_Destroyed_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.SouthBridge_Destroyed_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.SouthBridge_Destroyed_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.SouthBridge_Destroyed_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)

end

EVENTS.SouthBridge_Destroyed_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074437)		-- LOCDB [11074437] 'We lost the southern bridge, god dammit!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.SouthBridge_Destroyed_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074437)		-- LOCDB [11074437] 'We lost the southern bridge, god dammit!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079790)					-- LOCDB [11079790] 'Shit! Mission's fucked without that crossing - retreat!'
	CTRL.WAIT()
end
EVENTS.SouthBridge_Destroyed_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074437)		-- LOCDB [11074437] 'We lost the southern bridge, god dammit!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081610)					-- LOCDB [11081610] 'Fall back, men - Fall back! It's all for nothing without that crossing.'
	CTRL.WAIT()
end
EVENTS.SouthBridge_Destroyed_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074437)		-- LOCDB [11074437] 'We lost the southern bridge, god dammit!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079912)					-- LOCDB [11079912] 'Damnit it all! Mission's fucked without that bridge. Pull out before we lose any more men!'
	CTRL.WAIT()
end
EVENTS.SouthBridge_Destroyed_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074437)		-- LOCDB [11074437] 'We lost the southern bridge, god dammit!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080152)					-- LOCDB [11080152] 'Shit! How're we lettin' these damn krauts beat us?! Mission's fucked, pull back!'
	CTRL.WAIT()
end




--[[********************************************************************************************************]]
------------------------------------------ SOBJ_NorthBridge Events -------------------------------------------
--[[********************************************************************************************************]]

-- when allies arrive at the north bridge
EVENTS.NorthBridge_AlliesArrive = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074438)				-- LOCDB [11074438] '1-12 is holding on the opposite bank at the north bridge!  We're facin' heavy resistance.  Tryin' to push through!' - 'American Major'
	CTRL.WAIT()
end

-- when the bridge is secured
EVENTS.NorthBridge_Secured = function()
	
	-- "player" voice instead of allied voice, as it's the player that actually secures this bridge
	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.NorthBridge_Secured_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.NorthBridge_Secured_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.NorthBridge_Secured_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.NorthBridge_Secured_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.NorthBridge_Secured_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)
	
end
EVENTS.NorthBridge_Secured_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074440)		-- LOCDB [11074440] 'North bridge secured!  Elements crossing in force!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074441)		-- LOCDB [11074441] 'Hold the crossing.  If we let it fall or this whole operation is gonna go sideways!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Secured_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074440)		-- LOCDB [11074440] 'North bridge secured!  Elements crossing in force!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079788)					-- LOCDB [11079788] 'Good goddamn work! Now hold that crossing at all costs!'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Secured_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074440)		-- LOCDB [11074440] 'North bridge secured!  Elements crossing in force!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081608)					-- LOCDB [11081608] 'Hold firm up there! We can't give up control of the bridge!'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Secured_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074440)		-- LOCDB [11074440] 'North bridge secured!  Elements crossing in force!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079910)					-- LOCDB [11079910] 'We gotta hold that crossing! If it falls, the Germans will overrun Ouren.'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Secured_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074440)		-- LOCDB [11074440] 'North bridge secured!  Elements crossing in force!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080150)					-- LOCDB [11080150] 'Maintain the crossing -- whatever it takes.  If the Germans break  through, this whole operation will go down the shitter.'
	CTRL.WAIT()
end

-- when the bridge is heavily damaged
EVENTS.NorthBridge_HeavilyDamaged = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074442)				-- LOCDB [11074442] 'We're seeing major structural damage to the bridge.  I say again, northern bridge is sustaining major structural damage!' - 'American Major'
	CTRL.WAIT()
end
EVENTS.NorthBridge_HeavilyDamaged_Stage2 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074443)				-- LOCDB [11074443] 'North bridge isn't gonna last much longer!' - 'American Major'
	CTRL.WAIT()
end

-- when the bridge is destroyed
EVENTS.NorthBridge_Destroyed = function()
	
	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.NorthBridge_Destroyed_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.NorthBridge_Destroyed_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.NorthBridge_Destroyed_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.NorthBridge_Destroyed_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.NorthBridge_Destroyed_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)

end

EVENTS.NorthBridge_Destroyed_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074444)				-- LOCDB [11074444] 'The god damn bridge just went down!' - 'American Major'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Destroyed_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074444)				-- LOCDB [11074444] 'The god damn bridge just went down!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079790)					-- LOCDB [11079790] 'Shit! Mission's fucked without that crossing - retreat!'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Destroyed_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074444)				-- LOCDB [11074444] 'The god damn bridge just went down!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081610)					-- LOCDB [11081610] 'Fall back, men - Fall back! It's all for nothing without that crossing.'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Destroyed_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074444)				-- LOCDB [11074444] 'The god damn bridge just went down!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079912)					-- LOCDB [11079912] 'Damnit it all! Mission's fucked without that bridge. Pull out before we lose any more men!'
	CTRL.WAIT()
end
EVENTS.NorthBridge_Destroyed_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074444)				-- LOCDB [11074444] 'The god damn bridge just went down!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080152)					-- LOCDB [11080152] 'Shit! How're we lettin' these damn krauts beat us?! Mission's fucked, pull back!'
	CTRL.WAIT()
end


--[[********************************************************************************************************]]
------------------------------------------ OBJ_Counterattack Events ------------------------------------------
--[[********************************************************************************************************]]

-- counterattack countdown messages
EVENTS.Counterattack_Incoming_Start = function()
	
	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.Counterattack_Incoming_Start_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.Counterattack_Incoming_Start_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.Counterattack_Incoming_Start_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.Counterattack_Incoming_Start_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.Counterattack_Incoming_Start_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)

end
EVENTS.Counterattack_Incoming_Start_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074445)		-- LOCDB [11074445] 'Ouren sector be advised, recon elements have spotted a large German force preparing to move on your A.O.  Stand by further updates as they come in.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074446)		-- LOCDB [11074446] 'We don't have much time.   We're gonna be thin, but do what you can and set up for a counter-attack.' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_Start_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074445)		-- LOCDB [11074445] 'Ouren sector be advised, recon elements have spotted a large German force preparing to move on your A.O.  Stand by further updates as they come in.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079789)					-- LOCDB [11079789] 'Prepare for enemy counter…They're gonna' hit us hard so fucking dig in!..If the damn krauts think they're taking this bridge they got another thing comin'!'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_Start_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074445)		-- LOCDB [11074445] 'Ouren sector be advised, recon elements have spotted a large German force preparing to move on your A.O.  Stand by further updates as they come in.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081609)					-- LOCDB [11081609] 'Alright, Baker - muster all we've got and prepare a defense. We've got incoming!'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_Start_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074445)		-- LOCDB [11074445] 'Ouren sector be advised, recon elements have spotted a large German force preparing to move on your A.O.  Stand by further updates as they come in.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079911)					-- LOCDB [11079911] 'Alright, time's a luxury we don't have-- we gotta prepare for the Germans counter as soon as possible! They're gonnal hit us hard.'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_Start_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074445)		-- LOCDB [11074445] 'Ouren sector be advised, recon elements have spotted a large German force preparing to move on your A.O.  Stand by further updates as they come in.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080151)					-- LOCDB [11080151] 'Alright, Fox - We don't have much time, just do what you can and set up for a counter-attack.'
	CTRL.WAIT()
end




EVENTS.Counterattack_Incoming_5min = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074447)		-- LOCDB [11074447] 'Update to last SitRep.  German force is moving on your location.  I say again, German force is moving on your location. Time on our position in figures 5.  Out.' - 'Intel'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_2min = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074448)		-- LOCDB [11074448] 'Security pickets report German strike force is 2 minutes away.  Prepare for attack.' - 'Intel'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_1min = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074449)						-- LOCDB [11074449] 'You have sixty seconds.  I say again.  You have sixty seconds until forward elements are in contact.' - 'Intel'
	CTRL.WAIT()
end
EVENTS.Counterattack_Incoming_TimerUp = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074450)						-- LOCDB [11074450] 'Contact reports are pouring in from O.P's.  Enemy is on your front line.' - 'Intel'
	CTRL.WAIT()
	
	CTRL.Event_Delay(2)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074451)		-- LOCDB [11074451] 'Get ready!  Get ready!  Hold your ground and keep your rate of fire up!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074453)		-- LOCDB [11074453] 'Keep those crossin's locked down!  If they can't retake them, they're gonna try and blow them!' - 'American Captain'
	CTRL.WAIT()
end


EVENTS.Counterattack_Stage2_Begin = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074454)						-- LOCDB [11074454] 'Ouren battle group be advised.  Enemy is movin' additional forces into your area.  We expect a secondary German force on your position. Stand by for updates.' - 'Intel'
	CTRL.WAIT()
	
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074455)						-- LOCDB [11074455] 'Update to my last.  German battle group is estimated larger than initial wave.  Numbers to be determined.  Prepare defenses as needed.  Out.' - 'Intel'
	CTRL.WAIT()
end


-- when the counterattack starts targetting the southern bridge
EVENTS.Counterattack_TargetSouthBridge = function()
	
	UI_CreateMinimapBlip(eg_bridge_south, 10, BT_General)
	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074456)						-- LOCDB [11074456] 'Correction to my last.  German strike force has made a turn and is moving on the southern bridge.  I say again, German units moving on southern bridge.  Out.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074457)		-- LOCDB [11074457] 'Protect that god damn crossing!  Do whatever it takes!' - 'American Captain'
	CTRL.WAIT()
	
end

-- when the counterattack starts targetting the northern bridge
EVENTS.Counterattack_TargetNorthBridge = function()
	
	UI_CreateMinimapBlip(eg_bridge_north, 10, BT_General)
	
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074458)				-- LOCDB [11074458] 'Enemy forces have split up!  They're comin' heading towards the north!  Get a blockin' force up here!' - 'American Major'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Ouren_112th, 11074459)				-- LOCDB [11074459] 'Keep that bridge operational!   Push those bastards back!' - 'American Major'
	CTRL.WAIT()
	
end

-- when the counterattack units flee
EVENTS.Counterattack_UnitsFlee = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074460)		-- LOCDB [11074460] 'Enemy units turnin' tail, they're fallin' back!' - 'American Captain'
	CTRL.WAIT()
	
end


-- when the player is pushed off the peninsula 
EVENTS.Counterattack_PlayerPushedOffPeninsula = function()
	
	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.Counterattack_PlayerPushedOffPeninsula_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.Counterattack_PlayerPushedOffPeninsula_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.Counterattack_PlayerPushedOffPeninsula_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.Counterattack_PlayerPushedOffPeninsula_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.Counterattack_PlayerPushedOffPeninsula_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)

end
EVENTS.Counterattack_PlayerPushedOffPeninsula_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074461)		-- LOCDB [11074461] 'Approach points to the bridges have fallen!   My squads are gettin' push back!' - 'American Captain'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074462)		-- LOCDB [11074462] 'Germans are reinforcing' their lines!  We don't have enough men to counter!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.Counterattack_PlayerPushedOffPeninsula_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079791)					-- LOCDB [11079791] 'Holy hell, the German's got our number, we've gotta cut our losses - retreat, men!'
	CTRL.WAIT()
end
EVENTS.Counterattack_PlayerPushedOffPeninsula_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081611)					-- LOCDB [11081611] 'Goddamnit -- The German hordes are overunning us - All forces, retreat!'
	CTRL.WAIT()
end
EVENTS.Counterattack_PlayerPushedOffPeninsula_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079913)					-- LOCDB [11079913] 'Germans are reinforcing their lines!  Damnit, our numbers are too thin -- we don't have enough men to hold them off. Fall back dog, Fall back!'
	CTRL.WAIT()
end
EVENTS.Counterattack_PlayerPushedOffPeninsula_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080153)					-- LOCDB [11080153] 'Fuck! Our numbers are too thin…We won't be able to muster an effective counter! Fallback, Fox!'
	CTRL.WAIT()
end






--[[*******************************************************************************************************]]
-------------------------------------------  Mission-wide Events  -------------------------------------------
--[[*******************************************************************************************************]]

EVENTS.MissionComplete = function()

	local commander_lines = {
		{cmdr_id = CD_NONE, event_id = EVENTS.MissionComplete_DEFAULT},
		{cmdr_id = CD_AIRBORNE, event_id = EVENTS.MissionComplete_AIRBORNE},
		{cmdr_id = CD_MECHANIZED, event_id = EVENTS.MissionComplete_MECHANIZED},
		{cmdr_id = CD_SUPPORT, event_id = EVENTS.MissionComplete_SUPPORT},
		{cmdr_id = CD_RANGER, event_id = EVENTS.MissionComplete_RANGERS},
	}
	XP1_PlayCompanySpeechLine(commander_lines)
	
end
EVENTS.MissionComplete_DEFAULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Captain_01, 11074463)		-- LOCDB [11074463] 'The Germans are retreatin'!  Ouren is ours!' - 'American Captain'
	CTRL.WAIT()
end
EVENTS.MissionComplete_AIRBORNE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano, 11079792)					-- LOCDB [11079792] 'It was a hell of a scrap, but we held the Krauts off.  Ouren is secure…Thank Christ.'
	CTRL.WAIT()
end
EVENTS.MissionComplete_MECHANIZED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards, 11081612)					-- LOCDB [11081612] 'Ouren is secured! A damn fine show, men!'
	CTRL.WAIT()
end
EVENTS.MissionComplete_SUPPORT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11079914)					-- LOCDB [11079914] 'Ouren is clear! An inspired effort boys!'
	CTRL.WAIT()
end
EVENTS.MissionComplete_RANGERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Durante, 11080154)					-- LOCDB [11080154] 'German forces have broken down -- they're on the run…Ouren is clear!'
	CTRL.WAIT()
end



EVENTS.PlayerSpottedInfantrySupportGun = function()
	CTRL.Actor_PlaySpeech(ACTOR.American_Lieutenant_01, 11080797)	-- LOCDB [11080797] 'Careful! Spotted some Krauts with infantry support guns nearby.'
	CTRL.WAIT()
end


