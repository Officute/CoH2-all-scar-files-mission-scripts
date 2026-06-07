-------------------------------------
-- NIS
-------------------------------------

function Audio_Init()
	
	Sound_PreCacheSinglePlayerSpeech("mission/m14")
	g_MissionSpeechPath = "mission/m14"
	
	NIS_Start = "SP/CoH2_Campaign/M14-The_Reichstag/nis/m14_camera_start"
	nis_load(NIS_Start)
	
	nis_setintransitiontime(0)
	nis_setouttransitiontime(1)

end

Scar_AddInit(Audio_Init)

EVENTS = {}

EVENTS.INTRO_NIS = function()
	
	Game_FadeToBlack(FADE_IN, 2.5)
	FOW_EnableTint(false)
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)

	EGroup_Hide(LAYER_intro_despawn_layer, true)
	
	local location = 11047011			-- LOCDB [11047011] 'Berlin, Germany'
	local timeline = 11047012			-- LOCDB [11047012] 'April 29, 1945'
	
	CTRL.Scar_PlayNIS(NIS_Start)
	CTRL.SUB()
		
		Cmd_Move(sg_p_con_02, mkr_intro_p_con_02_dest)
		Cmd_Move(sg_p_shock_01, mkr_intro_p_shock_dest)
		Cmd_Move(sg_p_engineer_01, mkr_intro_p_engineer_dest)
		CTRL.Event_Delay(2.5)
		CTRL.WAIT()
		
		Game_SubTextFade(timeline, location, 0.5, 4, 0.5)
		Cmd_Move(sg_p_con_01, mkr_intro_p_con_01_dest)
		
		CTRL.Event_Delay(2)
		CTRL.WAIT()
		
		Actor_PlaySpeechWithoutPortrait(ACTOR.Russian_Senior_Officer, 11046610)
		
		CTRL.Event_Delay(5)
		CTRL.WAIT()
		
		Cmd_Move(sg_p_is2, mkr_intro_p_is2_dest)
		
	CTRL.END()
	CTRL.WAIT()
	
	EGroup_Hide(LAYER_intro_despawn_layer, false)
	
	Game_SetMode(UI_Normal)
	Camera_SetInputEnabled(true)
	FOW_EnableTint(true)

	SGroup_DestroyAllSquads(sg_a_truck_01)
	SGroup_DestroyAllSquads(sg_a_truck_02)
	
end


EVENTS.OUTRO_NIS = function()

	if Util_GetDistance(Camera_GetTargetPos(), mkr_camera_reichstag) <= 40 then		-- we're only going to do a camera push if it's vaguely close to the reichstag already
		Camera_SetInputEnabled(false)
		Camera_SetSlideTargetRate(0.5)
		Camera_ResetToDefault()
		Camera_MoveTo(mkr_camera_reichstag, true, 0.1)
	end
	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046637)	-- LOCDB [11046637] 'The Tigers are down! Comrades, storm the Reichstag now!' - 'Senior_Officer'
	CTRL.WAIT()
	
	Game_FadeToBlack(FADE_OUT, 0.5)
	
	CTRL.Event_Delay(0.5)
	CTRL.WAIT()
	
	Game_SetMode(UI_Cinematic)
	
	CTRL.SitRep_PlayMovie("m14_cin03")
	CTRL.WAIT()
	
	Game_EndSP(true)
--~ 	Game_FadeToBlack(FADE_IN, 0.5)
end


----------------------
-- GENERIC MISSION
----------------------
EVENTS.M14_ROADBLOCK_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046587)		-- LOCDB [11046585] 'We'll need to clear these roadblocks.  Bring up some demolition charges.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.M14_ROADBLOCK_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11047028)	 -- LOCDB [11046586] 'The IS-2's main cannon can also clear them out.' - 'Senior_Officer'
	CTRL.WAIT()
end

-- LOCDB [11046587] 'We'll need to clear these roadblocks.  The IS-2's main cannon could make short work of them!' - 'Senior_Officer'
-- LOCDB [11047028] 'Another roadblock - our Engineers can destroy them with demolition charges.' - 'Senior_Officer'

-- Random kill shouts - played at random times when german units are killed
-- LOCDB [11046588] 'That was for Warsaw, you sons of bitches!' - 'Soldier_01'
-- LOCDB [11046589] 'No mercy for the fascists!' - 'Soldier_01'
-- LOCDB [11046590] 'Die, German dogs!' - 'Soldier_01'
-- LOCDB [11046591] 'I will piss on your grave!' - 'Soldier_02'
-- LOCDB [11046592] 'That was for Leningrad!' - 'Soldier_02'
-- LOCDB [11046593] 'Die! All of you die!' - 'Soldier_03'
-- LOCDB [11046594] 'Beg for your lives, dogs!' - 'Soldier_03'
-- LOCDB [11046595] 'Show no mercy, comrades!' - 'Soldier_03'

-- Random battle shouts
-- LOCDB [11046596] 'What's wrong, Fritz? Your city doesn't look so good!' - 'Soldier_01'
-- LOCDB [11046597] 'Run away, Fritz - run while you still can!' - 'Soldier_01'
-- LOCDB [11046598] 'You've all lost, you only delay the end!' - 'Soldier_02'
-- LOCDB [11046599] 'The Red Army will destroy every last building in this shithole!' - 'Soldier_02'
-- LOCDB [11046600] 'Where is your Fuhrer now, Fritz?!' - 'Soldier_02'
-- LOCDB [11046601] 'Where is your leader now, Fritz?!' - 'Soldier_03'
-- LOCDB [11046602] 'Your leaders have abandoned you! Flee, you sacks of shit!' - 'Soldier_03'
-- LOCDB [11046603] 'You shit on the wrong hornet's nest!' - 'Soldier_03'

-- LOCDB [11046604] 'They do not realise they have lost, even now they believe their leadership will save them!' - 'Soldier_01'
-- LOCDB [11046605] 'They fight yet they have no hope, stupid bastards!' - 'Soldier_01'
-- LOCDB [11046606] 'What did I tell you, comrade? Berlin before winter!' - 'Soldier_02'
-- LOCDB [11046607] 'We've done what the Yankees could not!' - 'Soldier_02'
-- LOCDB [11046608] 'The Americans better hurry up or there will be nothing left for them to fight.' - 'Soldier_03'
-- LOCDB [11046609] 'I did not think I would see the end, but it is within our grasp!' - 'Soldier_03'

-- LOCDB [11046649] 'Comrade commander, the Germans are attempting to re-take our territory!' - 'Senior_Officer'
-- LOCDB [11046650] 'The Germans are trying to re-secure territory!' - 'Senior_Officer'
-- LOCDB [11046651] 'They are attempting to cut our supply lines, commander!' - 'Senior_Officer'

--------------------------------------------------------------------------------
-- MOTKE BRIDGE
--------------------------------------------------------------------------------
EVENTS.MOLTKE_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046610)	-- LOCDB [11046610] 'Forward!  Command wants the Moltke Bridge taken at once!' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOLTKE_APPROACH = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046611)	-- LOCDB [11046611] 'Push them back, comrades!  Drive the facists back across the bridge!' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOLTKE_DEMO_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046612) -- LOCDB [11046612] 'Oh shit, the bridge is wired, RUN!' - 'Soldier_01'
	CTRL.WAIT()
end

-- LOCDB [11046613] 'They are fools if they think these roadblocks will stop us!' - 'Soldier_01'
-- LOCDB [11046614] 'I think the Germans are compensating for something with this bridge, aren't you, Fritz?' - 'Soldier_02'

--------------------------------------------------------------------------------
-- MINISTRY OF THE INTERIOR BUILDING
--------------------------------------------------------------------------------
EVENTS.MOTI_START = function()
	CTRL.Event_Delay(2.5)
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046615)	-- LOCDB [11046615] 'Look, the bridge is still intact.' - 'Soldier_01'
	CTRL.WAIT()	
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046616)	-- LOCDB [11046616] 'Intact and clear of Germans - let us move up and secure the opposite side before they try to take it back.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOTI_ARTILLERY_UNAVAIL = function()
--~ 	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046617)	-- LOCDB [11046617] 'Our Artillery is still out of range and those flak towers are preventing close air support.' - 'Senior_Officer'
--~ 	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11048611)	-- LOCDB [11048611] 'Our artillery is still out of range, and flak towers in the area are preventing close air support.' - 'Senior_Officer'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046618)	-- LOCDB [11046618] 'Boots on the ground and armour in the streets, comrades - we will take Berlin ourselves!' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOTI_STREET_WARNING = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046619)	-- LOCDB [11046619] 'The Germans will likely be heavily dug in on the streets - we should try to flank through the city blocks when possible.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOTI_NORTHBRIDGE_COUNTERATTACK = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046620)	-- LOCDB [11046620] 'Smoke rounds - prepare for a counter-attack!' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOTI_MAINSTREET_DIFFICULT = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046621)	-- LOCDB [11046621] 'Going down this street is suicide! We should flank through the city blocks to the east and west.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.MOTI_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046622)	-- LOCDB [11046622] 'Good work, comrade, these resources will greatly help in the final push.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.MOTI_STUG_CREW_SPOTTED = function()
	
	if moti_stug_crew_hintpoints_removed ~= true then
		
		threatid_moti_stug_crew = ThreatArrow_CreateGroup(sg_moti_e_stug_def_02)
		hpid_moti_stug_crew = HintPoint_Add(sg_moti_e_stug_def_02, true, 11046976)	-- LOCDB [11046976] 'Stug Crew'
		
		CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01, 11046623)	-- LOCDB [11046623] 'Stop those Pioneers! They're going for the Stug!' - 'Soldier_01'
		CTRL.WAIT()
		
	end
	
end



--------------------------------------------------------------------------------
-- KROLL OPERA HOUSE
--------------------------------------------------------------------------------
EVENTS.KROLL_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046624)	-- LOCDB [11046624] 'Comrade commander, advance forward and secure the ruined Kroll Opera House.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.KROLL_ALTERNATE_ENTRANCE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046625)	-- LOCDB [11046625] 'They will likely have the front entrance heavily defended  - we might find an alternate entrance to the east.' - 'Senior_Officer'
	CTRL.WAIT()
end

-- LOCDB [11046626] 'This was an opera house? What a piece of shit it is now.' - 'Soldier_02'
EVENTS.KROLL_FORWARD_BASE = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11047029)	-- LOCDB [11047029] 'Engineers are moving up to establish a forward base, commander' - 'Senior_Officer'
	CTRL.WAIT()
end

--------------------------------------------------------------------------------
-- REICHSTAG
--------------------------------------------------------------------------------
EVENTS.REICH_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046627)	-- LOCDB [11046627] 'Comrades, hear me!' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046628)	-- LOCDB [11046628] 'The fascists reign ends here!  Across this square is the very symbol of their corruption!' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046629)	-- LOCDB [11046629] 'You will cross the plaza.  You will kill every German you find.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046630)	-- LOCDB [11046630] 'You will not stop until the flag of the motherland flies from the rooftop!' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046631)	-- LOCDB [11046631] 'For the Motherland! For Russia!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.REICH_ARTILLERY_AVAILABLE = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046632)	-- LOCDB [11046632] 'Access routes into Berlin are re-established; Artillery guns are now available for deployment.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046633)	-- LOCDB [11046633] 'Comrade - orders from Stalin, do not destroy the Reichstag - take it intact.' - 'Intel'
	CTRL.WAIT()
end

EVENTS.REICH_PANZERWERFER = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046634)	-- LOCDB [11046634] 'Incoming barrage!' - 'Soldier_02'
	CTRL.WAIT()
end

EVENTS.REICH_TIGERS_SPOTTED = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11046635)		-- LOCDB [11046635] 'They have Tigers defending the building!' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11046636)	-- LOCDB [11046636] 'We must destroy those tanks before we can assault the Reichstag itself.' - 'Senior_Officer'
	CTRL.WAIT()
end

EVENTS.COLLAPSED_SUBWAY = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_02, 11049490)		-- LOCDB [11049490] 'Where did this ditch come from? This wasn't on the maps!' - 'Soldier_02'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Senior_Officer, 11049491)	-- LOCDB [11049491] 'I think it's the subway, they've collapsed and flooded it. Find somewhere to cross!' - 'Senior_Officer'
	CTRL.WAIT()
end

-- LOCDB [11046652] 'Command expected the city to be taken by now, comrade commander.  We are giving you access to artillery - hurry up!' - 'Intel'

-- LOCDB [11049488] 'Comrades, storm the Reichstag now!' - 'Senior_Officer'
-- LOCDB [11049489] 'The Tigers are down! Capture that territory!' - 'Senior_Officer'


--------------------------------------------------------------------------------
-- BONUS: Howitzers
--------------------------------------------------------------------------------
EVENTS.HOWITZERS_START = function()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046638)	-- LOCDB [11046638] 'Commander, good job on taking out that howitzer.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046639)	-- LOCDB [11046639] 'We've received reports from allied divisions of shelling on their lines - there may be more.' - 'Intel'
	CTRL.WAIT()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11046640)	-- LOCDB [11046640] 'Sweep the riverbank and find any others - take them out!' - 'Intel'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_NO_AMMO = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046641)	-- LOCDB [11046641] 'Those Germans were low on shells - there's not enough left to make this gun useful.' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_FOUND_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046642)	-- LOCDB [11046642] 'We've found another Howitzer!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_FOUND_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046643)	-- LOCDB [11046643] 'Comrades, another one of those Howitzers!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_FOUND_03 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046644)	-- LOCDB [11046644] 'Another artillery gun.' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_FOUND_04 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046645)	-- LOCDB [11046645] 'Look, there's another Howitzer.' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_DEAD_01 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046646)	-- LOCDB [11046646] 'Howitzer neutralized!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_GUN_DEAD_02 = function()
	CTRL.Actor_PlaySpeech(ACTOR.Russian_Soldier_01 , 11046647)	-- LOCDB [11046647] 'We've taken out another gun, only one left!' - 'Soldier_01'
	CTRL.WAIT()
end

EVENTS.HOWITZERS_COMPLETE = function()
	CTRL.Actor_PlaySpeech(ACTOR.None , 11046648)	-- LOCDB [11046648] 'Good work, Comrade! That should take some pressure off our allies.' - 'Intel'
	CTRL.WAIT()
end
