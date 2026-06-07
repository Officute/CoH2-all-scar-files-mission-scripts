--------------------------------------------------------------------------------
-- NIS File for Kaluga
--------------------------------------------------------------------------------
function NIS_Init()
	nis_setintransitiontime(0)
	nis_setouttransitiontime(0)
end

Scar_AddInit(NIS_Init)

EVENTS = {}

EVENTS.OpeningCinematic = function()	
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 0)
	
	CTRL.SitRep_PlayMovie("m04_cin02")
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
	Game_FadeToBlack(FADE_IN, 2.5)
	CTRL.WAIT()	
end

EVENTS.ClosingCinematic = function()	
	Game_SetMode(UI_Cinematic)
	
	Game_FadeToBlack(FADE_OUT, 1.5)
	CTRL.Event_Delay(1.5)
	CTRL.WAIT()
	CTRL.SitRep_PlayMovie("m04_cin09")
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
	Game_FadeToBlack(FADE_IN, 2.5)
	CTRL.WAIT()	
	Game_EndSP(true)
end

EVENTS.IntroSitrep = function()	
	Game_FadeToBlack(FADE_OUT, 0.5)
	Game_SetMode(UI_Cinematic)
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.MERGE_ABILITY, ITEM_UNLOCKED)
	Player_SetConstructionMenuAvailability(player1, "tp_construction_soviet_conscripts", ITEM_UNLOCKED)
	CTRL.SitRep_PlayMovie("m04_sitrep") 
	CTRL.WAIT()
	Game_FadeToBlack(FADE_IN, 0.5)
	Game_SetMode(UI_Normal)
end

--------------------------------------------------------------------------------
-- Depot 1 speech
--------------------------------------------------------------------------------
EVENTS.FindFireSpeech = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022240) -- LOCDB [11022240] 'We risk freezing to death!  Look for fires or structures along our path!' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.ConscriptFreezing = function()
	local event = Table_GetRandomItem({
		11035472, -- LOCDB [11035472] 'So... cold...' - 'soviet_soldier_02'
		11035473, -- LOCDB [11035473] 'I... just need to stop to warm up a bit' - 'soviet_soldier_02'
		11035474, -- LOCDB [11035474] 'This chill... it's in my bones now' - 'soviet_soldier_02'
		11035475, -- LOCDB [11035475] 'I... I can't feel my legs anymore' - 'soviet_soldier_02'
	})
		
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, event)
	CTRL.WAIT()	
end

EVENTS.TracksInSnow = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11035466) -- LOCDB [11035466] 'Look at these tracks, Fritz has been this way. There must be a camp nearby.' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.FoundFireSpeech = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11022241) -- LOCDB [11022241] 'There, comrades!  We can warm ourselves by that fire.  These Germans will not mind.' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.DeepSnow = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046933) -- LOCDB [11046933] 'Snow this deep will slow our advance. We can move much faster on roads and trails.' - 'Conscript'
	CTRL.WAIT()
end
 
EVENTS.FreezingSquad_Warning = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11008096) -- LOCDB [11008096] 'Stay in cover to to shield yourself from the wind.  It may not keep you warm, but it will keep you alive.' - 'soviet_soldier_01'
	CTRL.WAIT()
end
 
EVENTS.Ambushed = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11040460) -- LOCDB [11040460] 'Blyat! Ambush!' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.FoundAdvanceCamp = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035477) -- LOCDB [11035477] 'This camp... it must have been left by the advance team... but where are they?' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.SnipersArrive = function()
--~ 	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.German_Panzer_Grenadier, 11035479) -- LOCDB [11035479] 'Scheisse! Russian snipers!' - 'German_Panzer_Grenadier'
	
	Sound_Play3D("speech/sp/mission/m04/11035479", Squad_EntityAt(SGroup_GetSpawnedSquadAt(sg_germanAmbush, 1),0)) -- LOCDB [11035479] 'Scheisse! Russian snipers!' - 'German_Panzer_Grenadier'
	CTRL.Event_Delay(4)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035478) -- LOCDB [11035478] 'The scouts, we're saved!' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.SnipersScout = function()
	CTRL.Event_Delay(1.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11035480) -- LOCDB [11035480] 'You made it.  Good!  We thought you might have frozen to death.' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11035481) -- LOCDB [11035481] 'Hah, not from this little breeze, this cold is nothing!' - 'soviet_Sniper'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11045734) -- LOCDB [11045734] 'Now hurry and warm yourselves. We need to scout the German position.' - 'soviet_Sniper'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11035483) -- LOCDB [11035483] 'We can put up some flares to gauge the enemy's defenses.' - 'Sniper'
--~ 	CTRL.WAIT()
end

EVENTS.Sniper_Holdfire_Lesson = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11008222) -- LOCDB [11008222] 'Hold your fire; we do not want to give our position away.' - 'soviet_Sniper'
	UI_AddHintAndFlashAbility(player1, ABILITY.SOVIET.SNIPER_HOLD_FIRE, 11046390, 7) -- LOCDB [11046390] 'Use hold fire so as not to alert enemies to your presence'
	CTRL.WAIT()	
end

EVENTS.Sniper_Camouflage = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11046391) -- LOCDB [11046391] 'The German outpost is nearby; we can move to cover to camouflage our approach.' - 'soviet_Sniper'
	CTRL.WAIT()	
end

EVENTS.Engineers = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11035484) -- LOCDB [11035484] 'Comrade Lieutenant! We took cover in this house when we heard gunfire, but we are ready to serve!' - 'soviet_Engineer'
	CTRL.WAIT()
end

EVENTS.DestroyTanks = function()		
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11035485) -- LOCDB [11035485] 'Sir! We had to take shelter from the cold, but we are ready to aid your effort!' - 'soviet_Engineer_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11022243) -- LOCDB [11022243] 'The cold has crippled the German tanks.  Explosives can ensure they stay that way.' - 'soviet_Engineer_02'
	CTRL.WAIT()
end

EVENTS.ShootFlare = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11035486) -- LOCDB [11035486] 'We can put up a flare from here to scout out the enemy approach.' - 'soviet_Sniper'
	CTRL.WAIT()
end

EVENTS.TakeCover = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Sniper, 11049598) -- LOCDB [11049598] 'We can put up a flare from here to scout out the enemy approach.' - 'soviet_Sniper'
	CTRL.WAIT()
end

--------------------------------------------------------------------------------
-- Depot 2 speech
--------------------------------------------------------------------------------
EVENTS.FindSecondDepot = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11042899) -- LOCDB [11042899] 'The outpost is ours.' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11042900) -- LOCDB [11042900] 'Excellent. We've put extra squads at your disposal.' - 'Commissar'
	CTRL.WAIT()
	UI_AddHintAndFlashAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, nil, 5) 
	
	Player_AddAbility(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH)
	Player_AddAbility(player1, BP_GetAbilityBlueprint("frontoviki_conscript_dispatch"))
	Player_SetAbilityAvailability(player1, ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH, ITEM_DEFAULT)
	Player_AddAbility(player1, ABILITY.GLOBAL.TRANSFER_ORDERS)
	Player_SetAbilityAvailability(player1, ABILITY.GLOBAL.TRANSFER_ORDERS, ITEM_UNLOCKED)
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022251) -- LOCDB [11022251] 'We'll continue our advance.  There should be another German depot near here.' - 'soviet_soldier_01'
	CTRL.WAIT()
end

EVENTS.HalfTrack = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11035488) -- LOCDB [11035488] 'Sir, we can commandeer that half-track to aid our troops' - 'soviet_Engineer'
	CTRL.WAIT()
end

EVENTS.NeedReinforcements = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11045735) -- LOCDB [11045735] 'Blyat, we lost another squad!' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11045736) -- LOCDB [11045736] 'If we can just take the next outpost, command will send help.' - 'soviet_soldier_02'
	CTRL.WAIT()
end

--------------------------------------------------------------------------------
-- Depot 3 speech
--------------------------------------------------------------------------------
EVENTS.FindThirdDepot = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022269) -- LOCDB [11022269] 'You perform like true Communists! But our work here isn't done yet, comrades.' - 'Commisar'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022270) -- LOCDB [11022270] 'There's at least one more depot, across the river to the northeast.  Our scouts should advance carefully, as the Germans must know we're coming.' - 'Commisar'
	CTRL.WAIT()
end

EVENTS.PrepareAmbush = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11022272) -- LOCDB [11022272] 'Comrade Lieutenant! Scouts report German reinforcements approaching our position!' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11022273) -- LOCDB [11022273] 'Man those mortars at once! We will prepare an ambush!' - 'soviet_soldier_02'
	CTRL.WAIT()	
	ShowMortarHint()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11035489) -- LOCDB [11035489] 'We must hold the region at any cost!' - 'soviet_soldier_02'
end

function ShowMortarHint()
	local eg_mortar = EGroup_CreateIfNotFound("eg_mortar")
	World_GetNeutralEntitiesNearPoint(eg_mortar, Util_GetPosition(mkr_gammaCapture), 50)
	EGroup_Filter(eg_mortar, EBP.GERMAN.GRANATEWERFER_34_81MM_MORTAR, FILTER_KEEP)	
	if EGroup_Count(eg_mortar) > 0 then
		local ent = EGroup_GetSpawnedEntityAt(eg_mortar, 1)
		hp_manMortar = HintPoint_Add(ent, true, 11045733, nil, nil, "Icons_tooltips_teamweapon_5") -- LOCDB [11045733] 'Man the mortars'
		Event_PlayerOwnsElement(EventHandler_RemoveHint, {hint = hp_manMortar}, player1, ent)
	end
end

EVENTS.BreakIce = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11043113) -- LOCDB [11043113] 'There's a German Stug coming up the river, we're fucked!' - 'soviet_soldier_01'
	ThreatArrow_CreateGroup(sg_d4_tank)
	CTRL.WAIT()
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11043114) -- LOCDB [11043114] 'We can take it! Quick, barrage the river with the mortars, break the ice! We can sink the fascist tank!' - 'soviet_soldier_02'
	CTRL.WAIT()
end

EVENTS.TankSunk = function() 
	Game_SetMode(UI_Cinematic)
	SGroup_SetInvulnerable(Player_GetSquads(player1), true)	
	Camera_MoveTo(Marker_GetPosition(mkr_d3_tank_attack), true, .25)
	FOW_RevealArea(Marker_GetPosition(mkr_d3_tank_attack), 20, -1)
	CTRL.Event_Delay(2)	
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11045629) -- LOCDB [11045629] 'Good shot! Sent the bastards to an icy grave.' - 'soviet_soldier_01'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046458) -- LOCDB [11046458] 'Look at the Germans run. They aren't so tough without their tank.' - 'soviet_soldier_01'
	CTRL.WAIT()	
	Objective_Complete(OBJ_Objective3, true)
	Event_Timer(EndMission, nil, 3)
end

EVENTS.FailedDefense = function()
	Camera_FocusOnPosition(Util_GetPosition(eg_gammaPoint), false)
	Game_SetMode(UI_Cinematic)
	Game_FadeToBlack(FADE_OUT, 1.5)
	CTRL.Event_Delay(1.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11035490) -- LOCDB [11035490] 'Many brave men sacrificed themselves that day. Not a single Soviet soldier survived to enjoy their victory.' - 'Commissar'
	CTRL.WAIT()
	EndMission()
end

EVENTS.TankRunAway = function()
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11049599) -- LOCDB [11049599] 'Blyat! That tank is working!' - 'soviet_Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11049595) -- LOCDB [11049595] 'The damn Germans are getting away!' - 'soviet_Engineer'
	CTRL.WAIT()
end

EVENTS.DestroyedTank = function()
	tankLines = {
		11031996, -- LOCDB [11031996] 'Burn, you svoloch!' - 'Engineer'
		11031997, -- LOCDB [11031997] 'Take that, you sukin syn!' - 'Engineer'
		11031998, -- LOCDB [11031998] '*Cheering*' - 'Engineer'
		11031999, -- LOCDB [11031999] 'That was for Aleksei, you bastards.' - 'Engineer'
		11032000, -- LOCDB [11032000] 'Sosi hui!' - 'Engineer'
	}

	if unusedTankLines == nil or table.getn(unusedTankLines) < 1 then		
		unusedTankLines = tankLines
	end

	line = World_GetRand(1, table.getn(unusedTankLines))
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, unusedTankLines[line])		
	table.remove(unusedTankLines, line)
	CTRL.WAIT()
end

--------------------------------------------------------------------------------
-- Speech to readd
--------------------------------------------------------------------------------
EVENTS.FoundFreezingGermans = function() 
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Commissar, 11022253) -- LOCDB [11022253] 'Germans...and they are freezing to death.  Save your ammunition, General Snow will take care of them soon enough.' - 'soviet_sniper'
	CTRL.WAIT()
end
