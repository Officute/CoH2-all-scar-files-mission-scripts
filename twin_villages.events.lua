print("\tLoading .events file...")

-- IntelEvents Table Container. This contains all Regular IntelEvent functions (simple dialogue).
EVENTS = {}

-- NIS events table container. Unlike the EVENTS table, NIS_EVENTS contains more complex intel events that involve logic, unit movement, etc. These are kept separete in order to allow QA to rapidly iterate to all dialogue sequences without breaking any mission logic.
NIS_EVENTS = {}



----------------------------------------------------------------------------------------------------
----------------------------------------  NIS EVENTS  ----------------------------------------------
----------------------------------------------------------------------------------------------------
--Intro NISlet
NIS_EVENTS.IntroNISlet = function()
	Game_SubTextFade(LOC("Date"), LOC("Location"), 0.5, 4, 0.5)
	CTRL.Game_TextTitleFade( LOC("Intro NISlet"), 0.3, 0.8, 0.2)
	CTRL.WAIT()
end

--Movie playback example
NIS_EVENTS.EndMovie = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 1.8)
	
	CTRL.Event_Delay(2.0)
	CTRL.WAIT()
	CTRL.SitRep_PlayMovie("m02_cin03")
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
end





EVENTS.Mission_Intro = function()	-- may be part of the intro NIS

	-- video portion: 	R&R in the Ardennes. Settling in for the winter.
	-- sitrep portion:	Quick reference to the twin villages so players get a sense of how the area is laid out
	--					Support will take over sentry duty from the airborne company at checkpoint delta. (also mention checkpoint bravo maybe?)
	--					Support will also spend their time on duty building out checkpoint delta.
	

end

----------------------------------------------------------------------------------------------------
------------------------------------------  PREPARATION  -------------------------------------------
----------------------------------------------------------------------------------------------------


EVENTS.Intro_SupportDivisionIntro = function()		-- s010
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075666)	-- LOCDB [11075666] 'Alright you ninety day wonders, listen up. We're gonna be taking over sentry duty from the Airborne over at Checkpoint Fox.' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075667)	-- LOCDB [11075667] 'Now seein' as how there aint nothing there, we're gonna build some stuff.' - 'Derby'
	CTRL.WAIT()
end

EVENTS.Intro_BuildUnits = function()				-- s020
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075668)	-- LOCDB [11075668] 'Lucky for you all, we got Rear Echelon squads available to pitch in.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Intro_BuildUnits_InProgress = function()		-- s030
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075669)	-- LOCDB [11075669] 'They've got it all figured out when it comes to buildin' defenses, so they're help with the checkpoint.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Intro_BuildUnits_Done = function()			-- s040
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075670)	-- LOCDB [11075670] 'Well look who we have here.  Welcome to the shin dig.  Hope you've got nowhere else to be.' - 'Derby'
	CTRL.WAIT()
end


EVENTS.Intro_MoveOutToSentryLocation = function()	-- s050
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075671)	-- LOCDB [11075671] 'Fall in. Alright let's move out boys.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Intro_MoveOutToSentryLocationFollowUp = function()	-- s060
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075672)	-- LOCDB [11075672] 'Hop to it boys. You know that son-of-a-gun Jackson'll never stop with the wise-crackin if we're late.' - 'Derby'
	CTRL.WAIT()
end



----------------------------------------------------------------------------------------------------
--------------------------------------  SUPPORT COMMANDER  -----------------------------------------
----------------------------------------------------------------------------------------------------

-- hand off from commander to Lazzaro
EVENTS.Support_ShiftChange = function()				-- s070
	CTRL.Actor_PlaySpeech(ACTOR.Jackson, 11075674)	-- LOCDB [11075674] 'Captain Derby, glad you could finally make it.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075675)	-- LOCDB [11075675] 'Yeah well, this war aint in no hurry to end, figured we had plenty of time to mosey-on over.' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson, 11075676)	-- LOCDB [11075676] 'Damn, we wouldn't want you boys pullin' a muscle hurryin' on our account.  I'm going to get the men back to Rocherath for hot meals and showers.  They could use it.' - 'Jackson'
	CTRL.WAIT()
end


-- build out checkpoint delta
EVENTS.Support_BuildFightingPosition = function()	-- s080
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075678)	-- LOCDB [11075678] 'Alright, this checkpoint's got to be flushed out.  Getting a bit crowded around here.' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075679)	-- LOCDB [11075679] 'If we're gonna sit out the winter here, we need some more cover.  Let's start by building a fighting position over there -- between the two trenches.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_BuildFightingPosition_WrongPosition = function()	-- s090
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075681)	-- LOCDB [11075681] 'That's not going to do any damn good over there.  We need a position between the trenches.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_BuildFightingPosition_WrongDirection = function()	-- s100
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075682)	-- LOCDB [11075682] 'Area of view is the wrong way.  Get it pointed toward the tree line.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_BuildFightingPosition_AddHMG = function()	-- s110
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075683)	-- LOCDB [11075683] 'Good. Get a fifty cal in there to cover that area.' - 'Derby'
	CTRL.WAIT()
end


EVENTS.Support_BuildTankTraps = function()			-- s120
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075684)	-- LOCDB [11075684] 'Alright, let's build some tank traps on the road next to the checkpoint here.' - 'Derby'
	CTRL.WAIT()
end


-- when the artillery attack starts
EVENTS.Support_ArtilleryStart = function()			-- s130
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075685)	-- LOCDB [11075685] 'Incoming!  Find cover!' - 'Derby'
	CTRL.WAIT()
	
end
EVENTS.Support_ArtilleryGetInCover = function()		-- s140
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075686)	-- LOCDB [11075686] 'Use the bunkers! We need a lookout in the watch tower!' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_ArtilleryAlreadyInCover = function()	-- s150
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075687)	-- LOCDB [11075687] 'Keep your heads down!' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_ArtilleryReport = function()			-- s160
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075688)	-- LOCDB [11075688] 'Checkpoint Fox, contact report!  Enemy artillery fire!' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075689)	-- LOCDB [11075689] 'Roger Fox, hold and advise as needed.' - 'Intel'
	CTRL.WAIT()
end


-- when the first men are spotted coming through the trees
EVENTS.Support_InfantryAttackStart = function()		-- s170
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075690)	-- LOCDB [11075690] 'There's movement in the tree line!  Fritz is on us!' - 'Derby'
	CTRL.WAIT()
end

EVENTS.Support_InfantryAttack_FlankRight = function()	-- s180
	if titleid_callInArtillery == nil then
		CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075691)	-- LOCDB [11075691] 'They're flanking to the right!' - 'Riflemen'
		CTRL.WAIT()
	else
		CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.American_Riflemen_01, 11075691)	-- LOCDB [11075691] 'They're flanking to the right!' - 'Riflemen'
		CTRL.WAIT()
	end
end
EVENTS.Support_InfantryAttack_FlankLeft = function()	-- s190
	if titleid_callInArtillery == nil then	-- only if the artillery card isn't onscreen
		CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11075692)	-- LOCDB [11075692] 'Watch that left flank!  The left flank!' - 'Riflemen'
		CTRL.WAIT()
	else
		CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.American_Riflemen_01, 11075692)	-- LOCDB [11075692] 'Watch that left flank!  The left flank!' - 'Riflemen'
		CTRL.WAIT()
	end
end


-- tell the player about the barrage ability
EVENTS.Support_UseBarrageAbility = function()		-- s200
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075693)	-- LOCDB [11075693] 'We need artillery support over here now god dammit!' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_BarrageAbilityUsed = function()		-- s210
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075694)	-- LOCDB [11075694] 'That'll keep the enemies ahead pinned down. Focus your fire on any guys coming from the flanks.' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_WrongBarrageAbilityUsed = function()	-- s220
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075695)	-- LOCDB [11075695] 'Fire mission incorrect!  Verify your orders!' - 'Derby'
	CTRL.WAIT()
end
EVENTS.Support_BarrageAbilityUsedInWrongTerritory = function()	-- s230
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075696)	-- LOCDB [11075696] 'You are off target!' - 'Derby'
	CTRL.WAIT()
end


-- after the attack is over
EVENTS.Support_AttackFinished = function()			-- s240
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075697)	-- LOCDB [11075697] 'Checkpoint Fox. Contact report. Light infantry, advancing from the north-east.' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075699)	-- LOCDB [11075699] 'Roger.  We're getting reports from all over the area. German's are moving in from the east, and to the north between here and Rocherath.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075701)	-- LOCDB [11075701] 'What's the status on Jackson and his Airborne team in Rocherath?' - 'Derby'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11075702)	-- LOCDB [11075702] 'No contact as of yet.  Will update you as we hear news.' - 'Intel'
	CTRL.WAIT()
end



EVENTS.Support_Failed = function()					-- s250
	CTRL.Actor_PlaySpeech(ACTOR.Derby, 11075703)	-- LOCDB [11075703] 'Fall back!  Fall back!  There's too many!' - 'Derby'
	CTRL.WAIT()
end



----------------------------------------------------------------------------------------------------
---------------------------------------  AIRBORNE COMMANDER  ---------------------------------------
----------------------------------------------------------------------------------------------------

-- when we switch to this commander
EVENTS.Airborne_Intro = function()					-- s260

	CTRL.Actor_PlaySpeech(ACTOR.Jackson, 11075705)	-- LOCDB [11075705] 'Hold your positions!   Keep those crossroads open!' - 'Jackson'
	CTRL.WAIT()

end


EVENTS.Airborne_DontGoOutThere = function()			-- s270

	local choices = {
		11075707,	-- LOCDB [11075707] 'There's Germans everywhere!  Stay in the village!  Get a defensive position in the center!' - 'Jackson'
		11075708,	-- LOCDB [11075708] 'Fallback to the center of the village!' - 'Jackson'
		11075709,	-- LOCDB [11075709] 'Everyone back to the middle of the village! We can hold them there!' - 'Jackson'
	}

	CTRL.Actor_PlaySpeech(ACTOR.Jackson, Table_GetRandomItem(choices))
	CTRL.WAIT()

end

EVENTS.Airborne_CallInParatroopers = function()		-- s280

	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075710)	-- LOCDB [11075710] 'Call in some paratroopers -- maybe we can flank these bastards.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075711)	-- LOCDB [11075711] 'There's a drop zone behind those houses!' - 'Jackson'
	CTRL.WAIT()

end

EVENTS.Airborne_ParatroopersEnRoute = function()	-- s290

	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075712)	-- LOCDB [11075712] 'Here they come!' - 'Jackson'
	CTRL.WAIT()

end

EVENTS.Airborne_ParatroopersArrivedNowTakeTheVillage = function()	-- s300

	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075713)	-- LOCDB [11075713] 'Vastano reporting.  We're holdin' on the D-Z!' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075714)	-- LOCDB [11075714] 'Enemy positions in those houses!  Clear them out!' - 'Jackson'
	CTRL.WAIT()

end

EVENTS.Airborne_VillageTakenNowCaptureRadioTower = function()		-- s310

	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075715)	-- LOCDB [11075715] 'Vastano, what's the SitRep when you came in?' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075716)	-- LOCDB [11075716] 'Not good. We got Krauts on all sides.  Village is surrounded.' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075717)	-- LOCDB [11075717] 'Can we get across to Krinkelt?' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075718)	-- LOCDB [11075718] 'No.  The whole place is crawling with Germans.' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075719)	-- LOCDB [11075719] 'We need to raise other sectors -- confirm what's goin' on here. Vastano, our radio's gonna need a boost - get over to the tower in the forest.  We can tie into it.' - 'Jackson'
	CTRL.WAIT()

end


EVENTS.Airborne_Outro = function()					-- s320

	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075720)	-- LOCDB [11075720] 'Jackson to C-P, Jackson to C-P,  Sitrep, do you read me?' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075721)	-- LOCDB [11075721] 'Edwards reportin - good to hear you boys are still kickin' out there. Go ahead Jackson.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075723)	-- LOCDB [11075723] 'We're surrounded here. We're holding onto the village center, and we've just managed to capture the radio tower, but there's German's everywhere.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075725)	-- LOCDB [11075725] 'Roger.  Hold your position until advised further, over.' - 'Edwards'
	CTRL.WAIT()

end



EVENTS.Airborne_Failed = function()					-- s330
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075726)	-- LOCDB [11075726] 'German's broke through! Able company's down!' - 'Jackson'
	CTRL.WAIT()
end




----------------------------------------------------------------------------------------------------
--------------------------------------  MECHANIZED COMMANDER  --------------------------------------
----------------------------------------------------------------------------------------------------

EVENTS.Mechanized_Intro = function()				-- s340
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075728)	-- LOCDB [11075728] 'The entire infantry regiment is mobilizing.  Hold your position.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075729)	-- LOCDB [11075729] 'We're going to try and establish a corridor from Krinkelt to Rocherath so you can fallback.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075730)	-- LOCDB [11075730] 'Stand by for updates, out.' - 'Edwards'
	CTRL.WAIT()
	
end

EVENTS.Mechanized_WeaponsRack = function()			-- s350
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075731)	-- LOCDB [11075731] 'Listen up!  I don't know how long this is going to take so I want a B.A.R. weapon rack set up!' - 'Edwards'
	CTRL.WAIT()
end
EVENTS.Mechanized_WeaponsRack_InProgress = function()	-- s360
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075733)	-- LOCDB [11075733] 'Once that thing is up, I want infantry to gun up.' - 'Edwards'
	CTRL.WAIT()
end
EVENTS.Mechanized_WeaponsRack_Done = function()		-- s370
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075734)	-- LOCDB [11075734] 'Get your guys over there and grab some browning's!' - 'Edwards'
	CTRL.WAIT()
end

EVENTS.Mechanized_WeaponsRack_BARPickedUp = function()	-- s380
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075735)	-- LOCDB [11075735] 'Alright, Baker - get ready to move out. We need to break through enemy forces to reach the airborne boys in Rocherath.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075736)	-- LOCDB [11075736] 'Jackson, this is Edwards.  Get your men to the edge of the village.  We're going to try to form an evac corridor.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075737)	-- LOCDB [11075737] 'Roger.  Moving now!' - 'Jackson'
	CTRL.WAIT()
end

EVENTS.Mechanized_GetSightLinesFromSupport = function()	-- s390
	
	CTRL.Actor_PlaySpeech(ACTOR.Derby,  11075738)	-- LOCDB [11075738] 'This is Derby.  My boys at have got sight lines into the attack area!  Dog company can support your advance from here.' - 'Derby'
	CTRL.WAIT()

end

EVENTS.Mechanized_MentionCombinedArms = function()	-- s400
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075739)	-- LOCDB [11075739] 'Men, use combined arms tactics!' - 'Edwards'
	CTRL.WAIT()

end

EVENTS.Mechanized_CombinedArmsTriggered = function()	-- s410
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11081492)	-- LOCDB [11081492] 'Good work men. Combined arms tactics can give both infantry and armour a boost.'
	CTRL.WAIT()
	
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075740)	-- LOCDB [11075740] 'Good, that'll increase the effectiveness of groups of infantry and armour.' - 'Edwards'
--~ 	CTRL.WAIT()

end

EVENTS.Mechanized_PanzerIVSpotted = function()
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01,  11081204)	-- LOCDB [11081204] 'Fucking hell, the Krauts got Panzer IVs here!'
	CTRL.WAIT()

end


EVENTS.Mechanized_ArrivedAtVillage = function()		-- s420
	
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075741)	-- LOCDB [11075741] 'Damn good to see you boys!' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075742)	-- LOCDB [11075742] 'Everything is goin' to shit over here.  Krauts are movin' in from the north and east.' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075743)	-- LOCDB [11075743] 'I say we give you cover and let's get the men out of Rocherath.' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075744)	-- LOCDB [11075744] 'Agreed.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075745)	-- LOCDB [11075745] 'Okay, listen up... Airborne is gonna fallback along the road back to the HQ.   Provide supporting fire along the way as they move.' - 'Edwards'
	CTRL.WAIT()
	
end


EVENTS.Mechanized_StartEvacuation_Stage1 = function()	-- s430
	
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075746)	-- LOCDB [11075746] 'Vastano, you take the first group and guide them back to the base. I'll bring up the second group once you've pushed off.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075747)	-- LOCDB [11075747] 'Yes sir. First group! On me!' - 'Lazzaro'
	CTRL.WAIT()
	
end

EVENTS.Mechanized_StartEvacuation_Stage2 = function()	-- s440
	
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075748)	-- LOCDB [11075748] 'Second group, ready!' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075749)	-- LOCDB [11075749] 'Keep that area covered and cleared!' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075750)	-- LOCDB [11075750] 'Go, go, go!' - 'Jackson'
	CTRL.WAIT()
	
end

EVENTS.Mechanized_StartEvacuation_Jackson = function()	-- s450

	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075751)	-- LOCDB [11075751] 'Okay, that's all of us! I'm covering the rear.' - 'Jackson'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075752)	-- LOCDB [11075752] 'Alright.  Get that infantry back here!  But keep that corridor open!' - 'Edwards'
	CTRL.WAIT()

end



EVENTS.Mechanized_JacksonCapture_Part1 = function()		-- s460
	
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01,  11075753)	-- LOCDB [11075753] 'Ambush!' - 'Paratrooper'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075754)	-- LOCDB [11075754] 'Keep moving!  Keep moving!' - 'Jackson'
	CTRL.WAIT()
	
end
EVENTS.Mechanized_JacksonCapture_Part2 = function()		-- s470
	
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075755)	-- LOCDB [11075755] 'JACKSON!' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Jackson,  11075756)	-- LOCDB [11075756] 'KEEP MOVING!' - 'Jackson'
	CTRL.WAIT()
	
end



EVENTS.Mechanized_EvacuationFailed = function()		-- s480

	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075757)	-- LOCDB [11075757] 'We're over run!  We're over run!' - 'Edwards'
	CTRL.WAIT()

end


EVENTS.Mechanized_OutOfTanks = function()			-- s490
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075759)	-- LOCDB [11075759] 'Just lost our last vehicle!  Someone call in more from the base!' - 'Edwards'
	CTRL.WAIT()
end
EVENTS.Mechanized_OutOfInfantry = function()		-- s500
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075760)	-- LOCDB [11075760] 'We need more infantry!  Call 'em in from the base.' - 'Edwards'
	CTRL.WAIT()
end


EVENTS.Mechanized_Outro = function()				-- s510
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075761)	-- LOCDB [11075761] 'All remaining units reporting in!' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Vastano,  11075762)	-- LOCDB [11075762] 'Where the hell is Jackson?' - 'Lazzaro'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075763)	-- LOCDB [11075763] 'Derby? Any sign of Jackson out there?' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby,  11075764)	-- LOCDB [11075764] 'We lost sight of him fallin' back.  German's are everywhere back there.' - 'Derby'
	CTRL.WAIT()
	
end





----------------------------------------------------------------------------------------------------
----------------------------------------------  OUTRO  ---------------------------------------------
----------------------------------------------------------------------------------------------------


EVENTS.Mission_Outro = function()					-- s520
	
	CTRL.Actor_PlaySpeech(ACTOR.Edwards,  11075765)	-- LOCDB [11075765] 'German's are pouring in more troops.  What's the plan?' - 'Edwards'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Derby,  11075767)	-- LOCDB [11075767] 'Fall back, ain't no more use wastin' lives here. We'll link up with whoever is left, and figure out what in the hell just hit us, coordinate a defense.' - 'Derby'
	CTRL.WAIT()
	
end




