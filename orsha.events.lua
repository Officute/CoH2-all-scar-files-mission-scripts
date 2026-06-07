function NIS_Init()
--~ 	nis_setintransitiontime(0)
--~ 	nis_setouttransitiontime(0)
	Sound_PreCacheSound("campaign/m09_radio_tower_destroyed")
end
Scar_AddInit(NIS_Init)

EVENTS = {}

EVENTS.NIS_Start = function()
	
--~ 	Game_SetMode(UI_Cinematic)
--~ 	Game_FadeToBlack(FADE_OUT, 0)

--~ 	CTRL.SitRep_PlayMovie("m09_cin01")
--~ 	CTRL.WAIT()
end

EVENTS.NIS_Intro = function()
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	local startTime = World_GetGameTime()
	Game_FadeToBlack(FADE_IN, 0.5)
	Util_CreateSquads(player3, {sg_p_units, sg_playerEngies}, SBP.SOVIET.COMBAT_ENGINEER_SQUAD, mkr_engySpawn, mkr_engyBuildPosition, 1)
	Util_CreateSquads(player1, {sg_p_units, sg_playerSnipers}, SBP.SOVIET.SNIPER_TEAM, mkr_troopSpawn, mkr_sniperMoveto, 1)
	evt_introSendAir = Event_Timer(_sendAir, nil, 8.0)
	CTRL.Scar_PlayNIS(NIS01)
	CTRL.SUB()		
		local location = 11048218			-- LOCDB [11048218] 'Orsha, Belarus'
		local timeline = 11048219			-- LOCDB [11048219] 'June 1944'
		Game_SubTextFade(location, timeline, 0.5, 4, 0.5)
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037878) -- LOCDB [11037878] 'Alright, sir. We've reached the forward position and will begin to establish an outpost...' - 'Russian_Soldier_01'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.None, 11037879) -- LOCDB [11037879] 'Excellent, we are sending air recon your way to get the lay of the land.' - 'Radio_Command'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037880) -- LOCDB [11037880] 'Blyat!  There's German forces directly outside of our position! We need reinforcements at once!' - 'Russian_Soldier_01'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.None, 11046934) -- LOCDB [11046934] 'Apologies, comrade. We've been cut off by German forces. You're on your own.' - 'Soviet_Radio_Command'
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037882) -- LOCDB [11037882] 'What the hell do you mean on our own?!' - 'Russian_Soldier_01'
		CTRL.WAIT()	
		CTRL.Actor_PlaySpeech(ACTOR.None, 11037883) -- LOCDB [11037883] 'Don't be a pizda.  The Germans don't know your position yet. Just take that damned town back.' - 'Radio_Command'
		CTRL.WAIT()	
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037884) -- LOCDB [11037884] 'Yes, sir! Comrades, hurry the hell up and finish getting this outpost established!' - 'Russian_Soldier_01'
		CTRL.WAIT()	
	CTRL.END()	
	CTRL.WAIT()	
	
end

function _endOfIntro()
	if introNisletSkipped ~= true then
		Game_SetMode(UI_Normal)
	end
	
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, ITEM_REMOVED)
	Event_NarrativeEventsNotRunning(EventHandler_ObjectiveStart, {objective = obj_main})
end

function _sendAir()
	evt_introCreateBarracks = Event_Timer(Intro_CreateBarracks, nil, 20.75)
	Player_AddAbility(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
	Cmd_Ability(player1, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP, mkr_planeRecon, Marker_GetDirection(mkr_planeRecon), true)	
	
	introHasSentAirRecon = true
end

function Intro_CreateBarracks()
	introHasCreatedBarracks = true
	Cmd_Construct(sg_playerEngies, EBP.SOVIET.BARRACKS, mkr_engyBuildPosition)	
	Rule_Add(Intro_GivePlayerEngies)
end

function Intro_GivePlayerEngies()
	if SGroup_IsConstructingBuilding(sg_playerEngies, ANY) == false then
		SGroup_SetPlayerOwner(sg_playerEngies, player1)
		local eg_building = EGroup_CreateIfNotFound("__eg_playerBuilding")
		World_GetEntitiesNearMarker(player3, eg_building, mkr_engyBuildPosition, OT_Ally)
		EGroup_Filter(eg_building, EBP.SOVIET.BARRACKS, FILTER_KEEP)
		EGroup_SetPlayerOwner(eg_building, player1)		
		Rule_RemoveMe()
	end
end

EVENTS.RushPlayer = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046683) -- LOCDB [11046683] 'We've got the territory! Now, secure it to gain extra munitions or fuel.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.BuildResourcePoint = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046681) -- LOCDB [11046681] 'Sir, we could secure these strategic points to gain extra munitions or fuel.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.BuildArmour = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046680) -- LOCDB [11046680] 'Sir, we now have enough fuel to begin construction of a Mechanized Armour Kampaneya.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.Foothold = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037885) -- LOCDB [11037885] 'The Germans are currently unaware of our presence.  We can use this to our advantage, but we've got to hurry!' - 'Russian_Soldier_01'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037886) -- LOCDB [11037886] 'If we take the nearby territory from the Germans we can use their resources to prepare our forces.' - 'Radio_Command'
--~ 	CTRL.WAIT()
end

EVENTS.BreakLine = function()		
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037887) -- LOCDB [11037887] 'Excellent work men! Now, secure the area and build up a strike force to hit the Germans!' - 'Radio_Command'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037888) -- LOCDB [11037888] 'Yes, sir' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037889) -- LOCDB [11037889] 'Work fast! You'll need to hit them hard with everything you've got. You will not be able to match their strength if they have time to react.' - 'Radio_Command'
	CTRL.WAIT()
end

EVENTS.GermanAttackEast = function()
	local event = Table_GetRandomItem({
		11037890, -- LOCDB [11037890] 'We have reports of a German counter attack force coming from the east.' - 'Radio_Command'
		11037891, -- LOCDB [11037891] 'Men! We've received intel of a counter attack coming your way! Watch your east flank.' - 'Radio_Command'
	})
	CTRL.Actor_PlaySpeech(ACTOR.None, event) 
	CTRL.WAIT()
end

EVENTS.GermanAttackWest = function()
	local event = nil
	if playerHasStartedAttack == true then
		event = Table_GetRandomItem({
			11037892, -- LOCDB [11037892] 'A German counter attack is reported to be coming from the west.' - 'Radio_Command'
			11037893, -- LOCDB [11037893] 'Word has just come in of a German force coming along the west road!' - 'Radio_Command'
		})
	else
		event = 11037893 -- LOCDB [11037893] 'Word has just come in of a German force coming along the west road!' - 'Radio_Command'
	end
		
	CTRL.Actor_PlaySpeech(ACTOR.None, event) 
	CTRL.WAIT()
end

EVENTS.IncomingStrafe = function() 
	local event = Table_GetRandomItem({
		11037894, -- LOCDB [11037894] 'We've received word of an incoming air strike, watch out!' - 'Radio_Command'
		11037895, -- LOCDB [11037895] 'German Stukas heading your way!' - 'Radio_Command'
		11022428,-- LOCDB [11022428] 'Stukas inbound!  Spread your forces out, do not give them a bunched target!' - 'Radio_Command'
	})
	CTRL.Actor_PlaySpeech(ACTOR.None, event) 
	CTRL.WAIT()
end

EVENTS.CommsOut = function()	
	Sound_Play2D("campaign/m09_radio_tower_destroyed")	
	CTRL.Event_Delay(3.7)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037896) -- LOCDB [11037896] 'Blyad! That last German Air Strike knocked out our communications. We're completely cutoff!' - 'Russian_Soldier_01'
	CTRL.WAIT()	
	Game_FadeToBlack(FADE_OUT, 0.5)
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	Game_SetMode(UI_Normal)
	Camera_MoveTo(sitrepCamStartPosition, false)	
	Camera_ResetToDefault()
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	Util_StartIntel(EVENTS.SitRep_Intro) 
end

EVENTS.SitRep_Intro = function()
	CTRL.SitRep_PlayMovie("m09_sitrep")
	CTRL.WAIT()
	local allPlayerSquads = SGroup_Create("allPlayerSquads")
	Player_GetAll(player1, allPlayerSquads)
	SGroup_SetInvulnerable(allPlayerSquads, false)
	
	local allGermanSquads = SGroup_Create("allGermanSquads")
	Player_GetAll(player2, allGermanSquads)
	SGroup_SetInvulnerable(allGermanSquads, false)
	
	Game_FadeToBlack(FADE_IN, 0.5)	
	Objective_Start(obj_Communications)
end

EVENTS.CommsReestablished = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037899) -- LOCDB [11037899] 'Communication has been reestablished.' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037900) -- LOCDB [11037900] 'Where in the hell have you been?' - 'Radio_Command'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037901) -- LOCDB [11037901] 'Sir, our radio tower was hit by a German air strike. We had to commandeer the German's tower to regain communications.' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037902) -- LOCDB [11037902] 'I don't give a shit about your excuses! We need the Germans out of that area now!' - 'Radio_Command'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037903) -- LOCDB [11037903] 'Yes, sir!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.BrokeLine = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037904) -- LOCDB [11037904] 'We've broken through their defensive line! We need to keep pushing through to root them from their strongholds in the city.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.BombersAvailable = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037905) -- LOCDB [11037905] 'Men, one of our IL-2 bombers just became available. It is at your disposal.' - 'Radio_Command'
	CTRL.WAIT()
end
EVENTS.ArtilleryAvailable = function()	
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037906) -- LOCDB [11037906] 'Special delivery, comrades! The Germans were nice enough to give us an opening, so we thought you may like some Katyushas to play with.' - 'Radio_Command'
	CTRL.WAIT()
end

EVENTS.DefendTown = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11022433) -- LOCDB [11022433] 'The dogs are counter-attacking!  Destroy the fascist tanks, call in air support if you need it.  They must not drive you out!' - 'Radio_Command'
	CTRL.WAIT()
end
EVENTS.CapturedHQ = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037907) -- LOCDB [11037907] 'Excellent work! We've taken their HQ.  We almost have the svolochs! Let's take out their last stronghold!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end
EVENTS.CapturedVehicle = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037908) -- LOCDB [11037908] 'Hah! The German dogs will have a harder time now that we've taken their Vehicle Depot! We just need to hit their HQ and they'll have nowhere left to hide.' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.MissionComplete = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037909) -- LOCDB [11037909] 'We've taken the town! The last of the German cowards are retreating. Excellent work, comrades!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

recentlyPlayedCommsOut = false

EVENTS.CommsOutBlind = function() 	
	if recentlyPlayedCommsOut == false then
		recentlyPlayedCommsOut = true
		local speech = {
			11037911, -- LOCDB [11037911] 'Blyat! We're running blind out here!' - 'Russian_Soldier_03'
			11037912, -- LOCDB [11037912] 'It's all going to hell!  We need to get communications reestablished with HQ!  Now!' - 'Russian_Soldier_03'
		}
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, Table_GetRandomItem(speech))
		CTRL.WAIT()		
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		recentlyPlayedCommsOut = false
	end
end

EVENTS.CommsOutNeedAir = function() 
	if recentlyPlayedCommsOut == false then
		recentlyPlayedCommsOut = true
		local speech = {
			11037913, -- LOCDB [11037913] 'We need some damn air support!' - 'Russian_Soldier_03'
			11037914, -- LOCDB [11037914] 'It would be helpful if we could get some fucking air support from HQ!' - 'Russian_Soldier_03'
		}
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, Table_GetRandomItem(speech))
		CTRL.WAIT()
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		recentlyPlayedCommsOut = false
	end
end

EVENTS.CommsOutCounterAtk = function() 
	if recentlyPlayedCommsOut == false then
		recentlyPlayedCommsOut = true
		local speech = {
			11037915, -- LOCDB [11037915] 'The Germans are here! We need to get communications back up so we know when they are coming.' - 'Russian_Soldier_03'
			11037916, -- LOCDB [11037916] 'Germans! Get those communications back up already!' - 'Russian_Soldier_03'
		}
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, Table_GetRandomItem(speech))
		CTRL.WAIT()
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		recentlyPlayedCommsOut = false
	end
end

EVENTS.CommsOutStuka = function() 
	if recentlyPlayedCommsOut == false then
		recentlyPlayedCommsOut = true
		local speech = {
			11037917, -- LOCDB [11037917] 'Stuka! We're fish in a barrel here without intel' - 'Russian_Soldier_03'
			11037918, -- LOCDB [11037918] 'Sukin Syn! We need to know when these airstrikes are coming!' - 'Russian_Soldier_03'
		}
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, Table_GetRandomItem(speech))
		CTRL.WAIT()
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		recentlyPlayedCommsOut = false
	end
end

EVENTS.BombIsland = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11037919) -- LOCDB [11037919] 'Sir, there are German forces stuck on the island to the west. We control the only road off...' - 'Russian_Soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11037920) -- LOCDB [11037920] 'Now they are the fish in a barrel!  We could bomb the hell out of the bastards!' - 'Russian_Soldier_02'
	CTRL.WAIT()
end

EVENTS.destroyedIsland = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040461) -- LOCDB [11040461] 'The bastards never had a chance!' - 'Russian_Soldier_01'
	CTRL.WAIT()
end

EVENTS.tankReinforcements = function() 
	CTRL.Actor_PlaySpeech(ACTOR.None, 11041886) -- LOCDB [11041886] 'Comrades, we've sent you some extra fire power to help root the German swine out of their strongholds!' - 'Radio_Command'
	CTRL.WAIT()
end

EVENTS.buildTanks = function()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040462) -- LOCDB [11040462] 'Blyat!  Those German tanks have this approach covered.' - 'Russian_Soldier_01'
	CTRL.WAIT()
	if Player_GetBuildingsCountOnly(player1, EBP.SOVIET.TANK_DEPOT) < 1 then
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11040463) -- LOCDB [11040463] 'If we're going to get past them we'll need to get a Tankoviy Battalion Command set up.' - 'Russian_Soldier_02'
		CTRL.WAIT()
	end
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11040464) -- LOCDB [11040464] 'Then we can build an SU-85 to take the kraut armour out.' - 'Russian_Soldier_02'
	CTRL.WAIT()
end
