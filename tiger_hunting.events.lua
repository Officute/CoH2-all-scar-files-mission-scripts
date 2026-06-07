
-- m08_cin01 - Intro

function Audio_Init()
	
	Sound_PreCacheSinglePlayerSpeech("mission/m08")
	g_MissionSpeechPath = "mission/m08"
	
	Sound_PreCacheSound("campaign/m08_tiger_break_out")
	
	NIS_Start = "SP/CoH2_Campaign/M08-Tiger_Hunting/nis/m08_camera_start_new"
	nis_load(NIS_Start)
	
	NIS_Tiger = "SP/CoH2_Campaign/M08-Tiger_Hunting/nis/m08_camera_tiger"
	nis_load(NIS_Tiger)
	
	g_music_tiger_reveal = "streamed/music/missions/m08/m08_cue_tiger_reveal"
	g_music_hunt_begins = "streamed/music/missions/m08/m08_cue_tiger_hunt"
	g_music_repair_part1 = "streamed/music/missions/m08/m08_cue_tiger_repair_phase_1"
	g_music_repair_part2 = "streamed/music/missions/m08/m08_cue_tiger_repair_phase_2"
	g_music_extraction = "streamed/music/missions/m08/m08_cue_tiger_extraction"
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)

end

Scar_AddInit(Audio_Init)

EVENTS = {}

EVENTS.CAMERA_START = function()
	
	FOW_EnableTint(false)
	Game_FadeToBlack(FADE_IN, 2.5)
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	
	local location = 11047550			-- LOCDB [11047550] '8 miles south of Leningrad'
	local timeline = 11047551			-- LOCDB [11047551] 'February, 1944'
	
	CTRL.Scar_PlayNIS(NIS_Start)
	CTRL.SUB()
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		Game_SubTextFade(timeline, location, 0.5, 4, 0.5)
		CTRL.Event_Delay(8)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.Russian_Tank_Officer, 11037051)		-- LOCDB [11037051] 'This is Ochev to all elements - we are coming up on the village, reduce speed.' - 'Tank Officer'
		CTRL.WAIT()
		CTRL.Event_Delay(8)
		Objective_Start(SOBJ_EscortTanks)
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
	FOW_EnableTint(true)
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)

end

EVENTS.CAMERA_TIGER = function()
	
	Sound_StopMusic(0, 0)
	Util_PlayMusic(g_music_tiger_reveal, 0, 0)
	
	FOW_RevealMarker(mkr_tiger_reveal_area, -1)
	
	sg_nearTigerExit = SGroup_CreateIfNotFound("sg_nearTigerExit")
	Player_GetAllSquadsNearMarker(player1, sg_nearTigerExit, mkr_massacre_tiger_dest_A, 9)
	tMarkers = Marker_GetTable("mkr_nearTiger_warp_%02d")
	
	local _warpAway = function(gid, idx, sid)
		Squad_WarpToPos(sid, Util_GetPosition(tMarkers[idx]))
	end
	
	SGroup_ForEach(sg_nearTigerExit, _warpAway)
	
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	
	CTRL.Scar_PlayNIS(NIS_Tiger)
	CTRL.SUB()
		SGroup_WarpToPos(sg_hunt_a_t34_02, Util_GetOffsetPosition(mkr_massacre_t34_02_warp, OFFSET_FRONT, 5))
		Cmd_Move(sg_hunt_a_t34_02, mkr_massacre_t34_02_dest)
		-- Su76
		SGroup_WarpToMarker(sg_hunt_a_su85, mkr_massacre_su76_warp)
		Cmd_Move(sg_hunt_a_su85, mkr_massacre_su76_dest_01)
--~ 		Cmd_Move(sg_hunt_a_su85, mkr_massacre_su76_dest_02, true)
--~ 		Cmd_Move(sg_hunt_a_su85, mkr_hunt_a_su85_dest, true)
		CTRL.Event_Delay(5.1)
		Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_m08_tiger_hunting_dark.aps", 0)
		CTRL.WAIT()
		CTRL.Event_Delay(1.5)
		CTRL.WAIT()
		Cmd_SquadPath(sg_hunt_a_su85, "pth_a_su76_turnaround", false, false, false, 0)
		Cmd_Attack(sg_hunt_a_su85, sg_e_tiger, true)
		CTRL.Event_Delay(0.5)
		CTRL.WAIT()
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037062)		-- LOCDB [11037062] 'Oh shit! Tiger!' - 'Tank Commander'
		CTRL.WAIT()
	CTRL.END()
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)

end


----------------------
-- INTRO
----------------------
EVENTS.INTRO_SPEECH_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037052)		-- LOCDB [11037052] 'There was a tank battle here - look at the carcasses.' - 'Tank Commander'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037053)		-- LOCDB [11037053] 'They look like they've been here for months; perhaps since last Spring.' - 'Tank Officer'
	CTRL.WAIT()
end

EVENTS.INTRO_SPEECH_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037054)		-- LOCDB [11037054] 'Does anyone see anything?' - 'Tank Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037055)		-- LOCDB [11037055] 'Negative - but plenty of places for an ambush..' - 'Tank Commander'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037056)		-- LOCDB [11037056] 'Agreed, stay alert.' - 'Tank Officer'
	CTRL.WAIT()
end

EVENTS.INTRO_BRUMMBAR_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037057)		-- LOCDB [11037057] 'Contact!' - 'Tank Officer'
	CTRL.WAIT()
end

EVENTS.INTRO_BRUMMBAR_HIT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037058)		-- LOCDB [11037058] 'God dammit!' - 'Tank Officer'
	CTRL.WAIT()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037059)		-- LOCDB [11037059] 'That Brummbar carcass will think twice before engaging us again' - 'Tank Commander'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11046850)		-- LOCDB [11046850] 'That tank carcass will think twice before engaging us again' - 'Tank Commander'
	CTRL.WAIT()
end

EVENTS.INTRO_SPEECH_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037060)		-- LOCDB [11037060] 'I am so glad you are on point, Ochev, I feel safer already.' - 'Tank Commander'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037061)		-- LOCDB [11037061] 'Shut your mouth, Vasili; or you will have latrine duty for a month.' - 'Tank Officer'
	CTRL.WAIT()
end

----------------------
-- INTRO
----------------------
EVENTS.MASSACRE_TIGER_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037062)		-- LOCDB [11037062] 'Oh shit! Tiger!' - 'Tank Commander'
	CTRL.WAIT()
end

EVENTS.MASSACRE_REAR_TANK_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037063)		-- LOCDB [11037063] 'Rear Tank down! Vasili; turn around and fire!' - 'Tank Officer'
	CTRL.WAIT()
end

EVENTS.MASSACRE_DEFLECTION = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Commander, 11037064)		-- LOCDB [11037064] 'Deflection! His armour's too thick!' - 'Tank Commander'
	CTRL.WAIT()
end

EVENTS.MASSACRE_T34_RUNNING = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Tank_Officer, 11037065)		-- LOCDB [11037065] 'He's got my turret! I'm pulling back!' - 'Tank Officer'
	CTRL.WAIT()
end

EVENTS.MASSACRE_FINISH = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037066)		-- LOCDB [11037066] 'Pull back, commander - pull your forces back, get out of there!' - 'Intel'
	CTRL.WAIT()
end


----------------------
-- Hunting the Tiger
----------------------
EVENTS.TH_REINFORCEMENTS = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037067)		-- LOCDB [11037067] 'Commander, we cannot let a Tiger roam freely behind our lines.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037068)		-- LOCDB [11037068] 'We are sending additional forces, but they are all we can spare - destroy that Tiger!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.TH_LOSING_TOO_MANY = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037856)		-- LOCDB [11037856] 'Failure is not an option; we will send you no more conscripts until you destroy that Tiger!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.TH_RUN_OUT_OF_RESOURCES = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046449)		-- LOCDB [11046449] 'We have no more conscripts available - we will have to finish him with what we have.'
	CTRL.WAIT()
end

EVENTS.TH_ALMOST_DEAD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11046450)		-- LOCDB [11046450] 'Commander, our forces have almost been wiped out!'
	CTRL.WAIT()
end

EVENTS.TH_HINT_ENGINEERS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11046451)		-- LOCDB [11046451] 'We should lay demolition packs and lure the Tiger to them.'
	CTRL.WAIT()
end

EVENTS.TH_HINT_AT_GUNS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11046452)		-- LOCDB [11046452] 'There must be some abandoned Anti-Tank weapons around we could use.'
	CTRL.WAIT()
end

EVENTS.TH_HINT_AT_GRENADES = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11046453)		-- LOCDB [11046453] 'We have plenty of Anti-Tank grenades; we just need to get close enough to throw them!'
	CTRL.WAIT()
end

EVENTS.TH_HINT_AT_RIFLES = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11046454)		-- LOCDB [11046454] 'Anti-Tank rifles... if we flank the Tiger, we might be able to damage its' rear armor!'
	CTRL.WAIT()
end

EVENTS.TH_LOST = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037857)		-- LOCDB [11037857] 'It was a simple task to destroy that Tiger, but even that you are incapable of accomplishing.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.TH_RALLY = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037069)		-- LOCDB [11037069] 'Ok, what have we got?' - 'Soldier_03'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037070)		-- LOCDB [11037070] 'Mines and Demolition packs; we could set them and lure the Tiger into a trap.' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037071)		-- LOCDB [11037071] 'We also have AT rifles; but I doubt they'll do much against that hide.' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037072)	-- LOCDB [11037072] 'There might be left over weapons in the village itself.' - 'Soldier_03'
	CTRL.WAIT()
	Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel_callback = EVENTS.TH_MUNITIONS}, 2)
end

EVENTS.TH_MUNITIONS = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11046434)		-- LOCDB [11046434] 'Command left us with very little, we will need to locate discarded munitions in the village for our demolitions.'
	CTRL.WAIT()
	local _tagItems = function(gid, idx, eid)
		local loc = Util_GetPosition(eid)
		Event_PlayerCanSeeElement(_foundMunitions, {location = loc, entity = eid}, player1, eid, ANY)
	end
	_lastHintLoc = nil
	EGroup_ForEach(eg_easy_items, _tagItems)
end

EVENTS.TH_TIGER_SPOTTED_QUIET = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037073)	-- LOCDB [11037073] 'There he is, hold fire!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.TH_AT_GUNS_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037852)	-- LOCDB [11037852] 'Look, an AT gun!' - 'Soldier_06'
	CTRL.WAIT()
end

EVENTS.TH_AT_GUNS_COLLECTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037853)	-- LOCDB [11037853] 'The cold has not been kind to this thing - I doubt it will be much use.' - 'Soldier_06'
	CTRL.WAIT()
end

EVENTS.TH_TIGER_SPOTTED_LOUD = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037854)	-- LOCDB [11037854] 'Oh shit, he's seen us! Run away!' - 'Soldier_06'
	CTRL.WAIT()
end

EVENTS.TH_CANT_SEE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037074)	-- LOCDB [11037074] 'I think he can only see directly ahead; let's not piss it off until we're ready.' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.TH_AT_RIFLES = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037075)	-- LOCDB [11037075] 'Fuck, these AT rifles are useless!' - 'Soldier_03'
	CTRL.WAIT()
end

EVENTS.TH_MINES = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11046435)	-- LOCDB [11046435] 'These mines won't damage that armour much, but they should shake the crew up a little for a time.'
	CTRL.WAIT()
end

EVENTS.TH_TIGER_RUNNING = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_04, 11037076)	-- LOCDB [11037076] 'He's turning tail and running!' - 'Soldier_04'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037077)	-- LOCDB [11037077] 'He will likely run for the air field north of here.' - 'Junior Officer'
	CTRL.WAIT()
	Objective_UpdateText(OBJ_TheHunt, 11046832, 11046832)	-- LOCDB [11046832] 'Hunt down the Tiger in the Airfield'
end

EVENTS.TH_TIGER_RETURN_TO_COMBAT_AREA = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_07, 11046438)	-- LOCDB [11046438] 'I don't think he'll let us lure him out of the airfield.'
	CTRL.WAIT()
end

EVENTS.TH_TIGER_RUNNING_LAST = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037078)	-- LOCDB [11037078] 'It's going further north!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.TH_TIGER_IMMOBILE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037079)	-- LOCDB [11037079] 'We blew its' treads off, it's stuck!' - 'Solider_06'
	CTRL.WAIT()
end

EVENTS.TH_TIGER_DISABLED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_03, 11037080)	-- LOCDB [11037080] 'Fuck yeah! Take that, you son of a bitch!' - 'Soldier_03'
	CTRL.WAIT()
end


----------------------
-- ESCAPE
----------------------

EVENTS.ESC_TIGER_BASE_BUILT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11046836)	-- LOCDB [11046836] 'Commander, we now have a base established south of the village.' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_SETUP_DEFENSE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037081)	-- LOCDB [11037081] 'We should setup a wide defense around the Tiger - the Germans will be here soon.' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_CAPTURED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037082)	-- LOCDB [11037082] 'Good news is, it will run.  Bad news? The engine is damaged; first-gear is the best I can give you.' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037083)	-- LOCDB [11037083] 'It will take some time before we can actually start rolling.' - 'ENGINEER'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_REPAIRING_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037084)	-- LOCDB [11037084] 'What is taking so long?' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037085)	-- LOCDB [11037085] 'I am not used to repairing German tanks!' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11037086)	-- LOCDB [11037086] 'Maybe we could ask the Germans for help.' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_REPAIRING_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037087)	-- LOCDB [11037087] 'Come on, hurry up - how hard can it be?' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037088)	-- LOCDB [11037088] 'I am going as quickly as I can!' - 'Engineer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_HATCH_GUNNER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037089)	-- LOCDB [11037089] 'Fuck, someone get up on that mounted MG42 and help out!' - 'Engineer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_MOBILE = function()		-- The Tiger's engine is repaired and it's ready to go.
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037090)	-- LOCDB [11037090] 'That's it; engine's running - we're ready to go!' - 'Engineer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_TAKING_DAMAGE = function()		-- Warning the Tiger's being attacked
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037091)	-- LOCDB [11037091] 'The Tiger's taking damage!  We should stop and attempt repairs!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_IMMOBILE = function()		-- When the tiger drops below a certain health threshhold and is immobilized
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037092)	-- LOCDB [11037092] 'Shit, they immobilized it - get those treads repaired!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_MOBILE = function()		-- After the player removes the immobilized critical
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037093)	-- LOCDB [11037093] 'Alright, treads are back on - let's go!' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037094)	-- LOCDB [11037094] 'We should stick to roads, we'll move faster and can mobilize troops easier!' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_ESCAPES = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11037095)	-- LOCDB [11037095] 'Excellent work, comrade - with this Tiger, we can find weaknesses to exploit.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.ESC_TIGER_FAIL = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037096)	-- LOCDB [11037096] 'This will not make Command happy, comrade.' - 'Junior Officer'
	CTRL.WAIT()
end

-- ENCIRCLEMENT
EVENTS.ESC_ENCIRCLE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037097)	-- LOCDB [11037097] 'Oh shit, Germans in the village.' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037098)	-- LOCDB [11037098] 'They're attempting to encircle us!' - 'Soldier_06'
	CTRL.WAIT()
end

----------------------
-- ELEPHANT
----------------------
EVENTS.ELE_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_06, 11037099)	-- LOCDB [11037099] 'Commander, we have word an Elephant Tank Destoyer has arrived north of the airfield.' - 'Soldier_06'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037100)	-- LOCDB [11037100] 'I would say this to be an excellent chance to test the capabilities of our new prize, comrade.' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037101)	-- LOCDB [11037101] 'It will likely not risk entering the village - we should take the fight to it.' - 'Junior Officer'
	CTRL.WAIT()
end

EVENTS.ELE_WARN = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037102)	-- LOCDB [11037102] 'The Elephant is a fixed-forward gun tank destroyer.' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037103)	-- LOCDB [11037103] 'Head-on, I have no doubt it will make short work of us - we must keep moving.' - 'Engineer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037104)	-- LOCDB [11037104] 'Circle around it - don't let it get a beat on us.' - 'Engineer'
	CTRL.WAIT()
end

EVENTS.ELE_ENGAGED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Engineer, 11037105)	-- LOCDB [11037105] 'This is it - keep moving, do not stop!' - 'Engineer'
	CTRL.WAIT()
end

EVENTS.ELE_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037106)	-- LOCDB [11037106] 'Good work, Comrade - I would call that a successful test.' - 'Junior Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Junior_Officer, 11037107)	-- LOCDB [11037107] 'We will get the Tiger back to our lines, you may want to inform Command of our success.' - 'Junior Officer'
	CTRL.WAIT()
end
