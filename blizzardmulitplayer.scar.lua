
--? @group scardoc;Multiplayer

-------------------------------------------------------------------------
-- [[ INIT ]]
-------------------------------------------------------------------------

--? @shortdesc Initializes and starts cold weather and blizzard mechanics, taking in atmosphere presets to use in each condition. Uses MP values by default. Defaults to NOT starting in blizzard conditions. 
--? @extdesc You need to add import("Systems/BlizzardMulitplayer.scar") to your mission script to use this - it isn't imported by default
--? @result Void
--? @args String blizzard_atmosphere, String default_atmosphere[, Boolean startInBlizzard, Table blizzardData, Boolean useSpeech, String transitionOutAtmosphere]
function MP_BlizzardInit(bliz_atmsph, def_atmsph, startInBlizzard, t_blizzardData, useSpeech, trans_out_atmsph)
	if Game_ColdTechDisabled() == true then
		return
	end
	
	startInBlizzard = startInBlizzard or false
	t_blizzardData = t_blizzardData or {}
	useBlizzardSpeech = useSpeech or true

	--
	-- Atmosphere Variables
	--
	blizzard_default_atmosphere = def_atmsph or "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_a.aps"
	blizzard_transition_atmosphere = bliz_atmsph or "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_b.aps"
	blizzard_transition_out_atmosphere = trans_out_atmsph
	blizzard_atmosphere = bliz_atmsph or "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_b.aps"
	
	-- parameters DURING a blizzard
	blizzard_in_heat   = t_blizzardData.blizzard_in_heat   or 2.5					-- heat loss value 
	blizzard_in_vision = t_blizzardData.blizzard_in_vision or 1						-- vision range modifier 
	blizzard_in_freeze = t_blizzardData.blizzard_in_freeze or 0.01					-- ice re-freeze rate (percent per sec)
	blizzard_in_snow_heal = t_blizzardData.blizzard_in_snow_heal or 0.5				-- snow re-heal rate (percent per sec)
	
	-- parameters BETWEEN blizzards
	blizzard_out_heat   = t_blizzardData.blizzard_out_heat   or 0.1						-- heat loss value 
	blizzard_out_vision = t_blizzardData.blizzard_out_vision or 1						-- vision range modifier 
	blizzard_out_freeze = t_blizzardData.blizzard_out_freeze or 0.0025					-- ice re-freeze rate (percent per sec)
	blizzard_out_snow_heal = t_blizzardData.blizzard_out_snow_heal or 0					-- snow re-heal rate (percent per sec)
	
	-- abilities to lock out in blizzards
	blizzard_lock_out_abilities = t_blizzardData.blizzard_lock_out_abilities or {}				-- abilities to be locked out during a blizzard
		
	-- audio
	blizzard_in_audio  = t_blizzardData.blizzard_in_audio  or "streamed/ambience_beds/blizzard_wind"
	blizzard_out_audio = t_blizzardData.blizzard_out_audio or "streamed/ambience_beds/ambience_layered"
	blizzard_out_transition_audio = t_blizzardData.blizzard_out_transition_audio or "emitters/blizzard_transition_out"
	
	-- timing variables
	blizzard_interval_min 				 = t_blizzardData.blizzard_interval_min 			 	or 400	-- min seconds between blizzards
	blizzard_interval_max 				 = t_blizzardData.blizzard_interval_max 			 	or 800 -- max seconds between blizzards
	blizzard_exit_min 					 = t_blizzardData.blizzard_exit_min 				 	or 160 -- min duration  of a blizzard
	blizzard_exit_max 					 = t_blizzardData.blizzard_exit_max 		 		 	or 240 -- max duration  of a blizzard
	blizzard_transition_time 			 = t_blizzardData.blizzard_transition_time 			 	or 60				-- how long it takes to transition in or out of a blizzard
	blizzard_transition_time_out 		 = t_blizzardData.blizzard_transition_time_out		 	or 30           -- how long it takes to transition out of a blizzard
	blizzard_transition_ticks_per_second = t_blizzardData.blizzard_transition_ticks_per_second 	or 2	-- defines how smooth the gameplay transitions are

	
	if startInBlizzard then
		current_heat = blizzard_in_heat				-- starting heat loss value for the cold weather mechanic
		current_vision = blizzard_in_vision			-- starting vision range modifier
		current_freeze = blizzard_in_freeze			-- starting ice re-freeze value for the cold weather mechanic
		current_snow = blizzard_in_snow_heal	-- starting snow heal rate for the cold weather
		current_audio = Sound_PlayStreamed(blizzard_in_audio)
		blizzard_interval_first = t_blizzardData.blizzard_interval_first or World_GetRand(blizzard_exit_min,blizzard_exit_max) -- time before first transition occurs

	else
		current_heat = blizzard_out_heat			-- starting heat loss value for the cold weather mechanic
		current_vision = blizzard_out_vision		-- starting vision range modifier
		current_freeze = blizzard_out_freeze		-- starting ice re-freeze value for the cold weather mechanic
		current_snow = blizzard_out_snow_heal	-- starting snow heal rate outside of blizzard
		current_audio = Sound_PlayStreamed(blizzard_out_audio)
		blizzard_interval_first = t_blizzardData.blizzard_interval_first or World_GetRand(480, 600) -- time before first transition occurs
	end
	
	for i=1,World_GetPlayerCount() do
		local playerId = World_GetPlayerAt(i)
		Player_CompleteUpgrade(playerId, BP_GetUpgradeBlueprint("allow_building_campfires")) -- Allow building campfires in this cold weather map
		Player_SetHeatLossRate(playerId, current_heat)
		Player_SetHeatGainRate(playerId, 3)
		if startInBlizzard then
			Player_CompleteUpgrade(playerId, BP_GetUpgradeBlueprint("blizzard_active")) -- This upgrade blueprint is referenced by the AI AE data for detecting blizzards
		end
	end
	

	World_SetIceHealingRate(current_freeze)
	World_SetSnowHealingRate(current_snow)
	

	-- internal variables that will be set by the system
	blizzard_transitioning = false				-- is true whilst in the middle of a transition
	blizzard_state = startInBlizzard						-- true means we're in a blizzard, false means we aren't. Set at the END of the transition in / out
	blizzard_interval = 0
	blizzard_game_time = World_GetGameTime()
	timer_blizzard_start = 1232138
	blizzard_timer_started = false
	
	-- German Speech Events
	if Player_GetRaceName(Game_GetLocalPlayer()) == "german" then
		speech_blizzard_approaching = "speech/mp/german/gan/events/warning/xb_gan_wrn_bz1gen_nt_s"
		speech_blizzard_here        = "speech/mp/german/gan/events/warning/xb_gan_wrn_bz2gen_nt_s"
		speech_blizzard_clearing		= "speech/mp/german/gan/events/warning/xb_gan_wrn_bz3gen_nt_s"
		speech_blizzard_lifted	= "speech/mp/german/gan/events/warning/xb_gan_wrn_bz4gen_nt_s"
		Sound_PreCacheSoundFolder("speech/mp/german/gan/events/warning")
	elseif Player_GetRaceName(Game_GetLocalPlayer()) == "aef" then
		speech_blizzard_approaching = "speech/mp/aef/int/events/warning/ab_int_wrn_bz1gen_nt_s"
		speech_blizzard_here        = "speech/mp/aef/int/events/warning/ab_int_wrn_bz2gen_nt_s"
		speech_blizzard_clearing		= "speech/mp/aef/int/events/warning/ab_int_wrn_bz3gen_nt_s"
		speech_blizzard_lifted	= "speech/mp/aef/int/events/warning/ab_int_wrn_bz4gen_nt_s"
		Sound_PreCacheSoundFolder("speech/mp/aef/int/events/warning")	
	elseif Player_GetRaceName(Game_GetLocalPlayer()) == "west_german" then
		speech_blizzard_approaching = "speech/mp/west_german/win/events/warning/xb_win_wrn_bz1gen_nt_s"
		speech_blizzard_here        = "speech/mp/west_german/win/events/warning/xb_win_wrn_bz2gen_nt_s"
		speech_blizzard_clearing		= "speech/mp/west_german/win/events/warning/xb_win_wrn_bz3gen_nt_s"
		speech_blizzard_lifted	= "speech/mp/west_german/win/events/warning/xb_win_wrn_bz4gen_nt_s"
		Sound_PreCacheSoundFolder("speech/mp/west_german/win/events/warning")	
	else
		speech_blizzard_approaching = "speech/mp/soviet/int/events/warning/sb_int_wrn_bz1gen_nt_s"
		speech_blizzard_here        = "speech/mp/soviet/int/events/warning/sb_int_wrn_bz2gen_nt_s"
		speech_blizzard_clearing		= "speech/mp/soviet/int/events/warning/sb_int_wrn_bz3gen_nt_s"
		speech_blizzard_lifted	= "speech/mp/soviet/int/events/warning/sb_int_wrn_bz4gen_nt_s"
		Sound_PreCacheSoundFolder("speech/mp/soviet/int/events/warning")
	end

	
	Rule_AddOneShot(MP_BlizzardTransition , blizzard_interval_first)
	
	if startInBlizzard then
		Game_LoadAtmosphere(blizzard_atmosphere, 0)
		Rule_AddOneShot (BlizzardCue, 2)
	else
		Game_LoadAtmosphere(blizzard_default_atmosphere, 0)
	end
	
end

function MP_BlizzardInterval()
	
	local current_time = World_GetGameTime()
	
	if current_time - blizzard_game_time >= blizzard_interval then
		Rule_RemoveMe()
		MP_BlizzardTransition()
	end
	
end

function MP_BlizzardTransition()
	
	if blizzard_state then
		Blizzard_End()
		blizzard_interval = World_GetRand(blizzard_interval_min, blizzard_interval_max)
		blizzard_state = false
	else
		Blizzard_Start()
		blizzard_interval = World_GetRand(blizzard_exit_min, blizzard_exit_max)
		blizzard_state = true
	end
	
	blizzard_game_time = World_GetGameTime()
	
	Rule_AddInterval(MP_BlizzardInterval, 10)
end


------------------------
--                    --
-- Blizzard functions --
--                    --
------------------------
--
-- Transition INTO a blizzard
--
function Blizzard_Start() -- call THIS function to trigger the transition 
	
	if useBlizzardSpeech then
		Sound_PlayStreamed(speech_blizzard_approaching)
	end
	
	-- Gameplay
	Rule_AddOneShot(Blizzard_StartGameplayTransition, blizzard_transition_time/2)
	
	-- make sure we aren't already in the middle of a transition
	if blizzard_transitioning == false then
		Blizzard_Start_StartTransition()
		WinWarning_ShowLoseWarning(11043077, 0.5, 2.5, 0.5)
	else
		if Rule_Exists(Blizzard_WaitToStart) == false then
			Rule_AddInterval(Blizzard_WaitToStart, 1)
		end
	end
	
end

function Blizzard_WaitToStart()
	if blizzard_transitioning == false then
		Rule_RemoveMe()
		Blizzard_Start_StartTransition()
	end
end

function Blizzard_StartGameplayTransition()

	Blizzard_TransitionGameplay(blizzard_transition_time, blizzard_in_heat, blizzard_in_vision, blizzard_in_freeze, blizzard_in_snow_heal)
	
end

function Blizzard_Start_StartTransition()

	if blizzard_state == false then -- only transition if we are currently NOT in a blizzard
		
		-- start the transition INTO a blizzard
		blizzard_transitioning = true
		
		-- Visual
		Game_LoadAtmosphere(blizzard_transition_atmosphere, 60)
		Rule_AddOneShot(Blizzard_Start_MidTransition, 60)
		
		-- Audio
		Sound_Stop(	current_audio )
		current_audio = Sound_PlayStreamed("streamed/ambience_beds/blizzard_wind")
		
		
		-- Set up the finalising at the end of the transition
		Rule_AddOneShot(Blizzard_Start_TransitionFinished, blizzard_transition_time)
		Rule_Add(Blizzard_Start_Timer)
		
	end
	
end

function Blizzard_Start_Timer()
	
	if blizzard_timer_started == false then
		blizzard_timer_started = true
		Timer_Start(timer_blizzard_start, blizzard_transition_time)
	end
	
	if Timer_GetRemaining(timer_blizzard_start) <= 0 then
		Rule_RemoveMe()
		blizzard_timer_started = false
		Obj_HideProgress()
		Timer_End(timer_blizzard_start)
	else
		Obj_ShowProgressTimer(Timer_GetRemaining(timer_blizzard_start)) 
	end
end

function Blizzard_Start_MidTransition()

	-- Visual
	Game_LoadAtmosphere(blizzard_atmosphere, blizzard_transition_time - 35)
	
--~ 	-- Gameplay
--~ 	EventCue_Create(CUE.BLIZZARD, LOC("Blizzard Conditions"), LOC("No air support until blizzard abates"), nil)
	
end

function Blizzard_Start_TransitionFinished()	-- declare the transition finished
	
	-- Giving blizzard active upgrade
	for i=1,World_GetPlayerCount() do
		Player_CompleteUpgrade(World_GetPlayerAt(i), BP_GetUpgradeBlueprint("blizzard_active"))
	end
	
	-- Gameplay
	EventCue_Create(CUE.BLIZZARD, 11038780, 0, nil) -- LOCDB [11038780] 'Blizzard Conditions'
	
	if useBlizzardSpeech then
		Sound_PlayStreamed(speech_blizzard_here)
	end

	blizzard_transitioning = false
	blizzard_state = true
	
	WinWarning_ShowLoseWarning(11043078, 0.5, 2.5, 0.5)
end



--
-- Transition OUT OF a blizzard
--
function Blizzard_End() -- call THIS function to trigger the transition
	
	if useBlizzardSpeech then
		Sound_PlayStreamed(speech_blizzard_clearing)
	end
	
	-- make sure we aren't already in the middle of a transition
	if blizzard_transitioning == false then
		Blizzard_End_StartTransition()
	else
		if Rule_Exists(Blizzard_WaitToEnd) == false then
			Rule_AddInterval(Blizzard_WaitToEnd, 1)
		end
	end
	
end

function Blizzard_WaitToEnd()
	if blizzard_transitioning == false then
		Rule_RemoveMe()
		Blizzard_End_StartTransition()
	end	
end

function Blizzard_End_StartTransition()

	if blizzard_state == true then -- only transition if we are currently in a blizzard
		
		-- start the transition OUT OF a blizzard
		blizzard_transitioning = true
		
		-- Visual
		if blizzard_transition_out_atmosphere ~= nil then
			Game_LoadAtmosphere(blizzard_transition_out_atmosphere, blizzard_transition_time_out - 5)
		else
			Game_LoadAtmosphere(blizzard_default_atmosphere, blizzard_transition_time_out - 5)
		end
		Rule_AddOneShot(Blizzard_End_MidTransition, blizzard_transition_time_out - 5)
		
		-- Audio
		transition_out_audio = Sound_PlayStreamed(blizzard_out_transition_audio)
		
		-- Gameplay
		Blizzard_TransitionGameplay(blizzard_transition_time_out, blizzard_out_heat, blizzard_out_vision, blizzard_out_freeze, blizzard_out_snow_heal)
		
		-- Removing blizzard upgrade
		for i=1,World_GetPlayerCount() do
			Player_RemoveUpgrade(World_GetPlayerAt(i), BP_GetUpgradeBlueprint("blizzard_active"))
		end
		
		-- Set up the finalising at the end of the transition
		Rule_AddOneShot(Blizzard_End_TransitionFinished, blizzard_transition_time_out)
		
		
		
	end
	
end
function Blizzard_End_MidTransition()

	-- Visual
--~ 	Game_LoadAtmosphere(blizzard_default_atmosphere, 5)
	
	-- Gameplay
	EventCue_Create(CUE.BLIZZARD, 11038810, 0,  nil) -- LOCDB [11038810] 'Blizzard Conditions Subsiding'
	
end

function Blizzard_End_TransitionFinished()		-- declare the transition finished
	blizzard_transitioning = false
	blizzard_state = false
	
	WinWarning_ShowLoseWarning(11043079, 0.5, 2.5, 0.5)
	
	-- Visual
	if blizzard_transition_out_atmosphere ~= nil then
		Rule_AddOneShot(Blizzard_End_AtmosphereFinal, 30)
	end
	
	-- Audio
	Sound_Stop( transition_out_audio )
	Sound_Stop(	current_audio )
	current_audio = Sound_PlayStreamed("streamed/ambience_beds/ambience_layered")

	-- Placeholder Speech Event
	if useBlizzardSpeech then
		Sound_PlayStreamed(speech_blizzard_lifted)
	end
	
end

function Blizzard_End_AtmosphereFinal()

	Game_LoadAtmosphere(blizzard_default_atmosphere, 30)

end




--
-- This function sets up a gradual transition to 
-- the heat and vision values passed in
--
function Blizzard_TransitionGameplay(seconds, heat, vision, freeze, snow)
	
	-- set global variables about the target and delta values
	target_heat = heat
	target_vision = vision
	target_freeze = freeze
	target_snow = snow
	delta_heat = (target_heat - current_heat) / (seconds * blizzard_transition_ticks_per_second)
	delta_vision = (target_vision - current_vision) / (seconds * blizzard_transition_ticks_per_second)
	delta_freeze = (target_freeze - current_freeze) / (seconds * blizzard_transition_ticks_per_second)
	delta_snow = (target_snow - current_snow) / (seconds * blizzard_transition_ticks_per_second)

	-- call ticks
	if Rule_Exists(Blizzard_TransitionGameplay_Tick) then
		Rule_Remove(Blizzard_TransitionGameplay_Tick)
		Rule_AddIntervalEx(Blizzard_TransitionGameplay_Tick, (1 / blizzard_transition_ticks_per_second), (seconds * blizzard_transition_ticks_per_second) - 1)
	else
		Rule_AddIntervalEx(Blizzard_TransitionGameplay_Tick, (1 / blizzard_transition_ticks_per_second), (seconds * blizzard_transition_ticks_per_second) - 1)
	end
	if Rule_Exists(Blizzard_TransitionGameplay_Final) then
		Rule_Remove(Blizzard_TransitionGameplay_Final)
		Rule_AddOneShot(Blizzard_TransitionGameplay_Final, seconds)
	else
		Rule_AddOneShot(Blizzard_TransitionGameplay_Final, seconds)
	end
	
end

function Blizzard_TransitionGameplay_Tick()
	
	-- modify the heat
	current_heat = current_heat + delta_heat
	SetHeatRateForAllPlayers(current_heat)
	
	-- modify the vision ranges
	current_vision = current_vision + delta_vision
	SetVisionRadiusForAllPlayers(current_vision)
	
	-- modify the re-freeze rate
	current_freeze = current_freeze + delta_freeze
	World_SetIceHealingRate(current_freeze)
	
	-- modify the snow heal rate
	current_snow = current_snow + delta_snow
	World_SetSnowHealingRate(current_snow)
	
end

function Blizzard_TransitionGameplay_Final()
	
	-- modify the heat
	current_heat = target_heat
	SetHeatRateForAllPlayers(current_heat)
	
	-- modify the vision ranges
	current_vision = target_vision
	SetVisionRadiusForAllPlayers(current_vision)
	
	-- modify the re-freeze rate
	current_freeze = target_freeze
	World_SetIceHealingRate(current_freeze)
	
	-- modify the snow heal rate
	current_snow = target_snow
	World_SetSnowHealingRate(current_snow)
	
end

function BlizzardCue()
		EventCue_Create(CUE.BLIZZARD, 11038780, 0, nil) -- LOCDB [11038780] 'Blizzard Conditions'
end




-- functions to set values for all players
function SetVisionRadiusForAllPlayers(scale)	-- scale is a multiplication modifier value
	
	if t_blizzard_mod == nil then
		t_blizzard_mod = {}
	end
	
	for i=1,World_GetPlayerCount() do
		if t_blizzard_mod[i] ~= nil then
			Modifier_Remove(t_blizzard_mod[i])
		end
		t_blizzard_mod[i] = Modify_PlayerSightRadius(World_GetPlayerAt(i), scale)
	end
	
end

function SetHeatRateForAllPlayers(rate)
	
	for i=1,World_GetPlayerCount() do
		local playerId = World_GetPlayerAt(i)
		
		Player_SetHeatLossRate(playerId, rate)
		Player_SetHeatGainRate(playerId, 3)
		
	end
	
end

function StopBlizAudio()

	Sound_Stop(	current_audio )

end

function __stopBlizzard()
	
	SetHeatRateForAllPlayers(0)
	
	Sound_Stop(	current_audio )
	Game_LoadAtmosphere(blizzard_default_atmosphere, 3)
	
	Rule_RemoveAll()
	
end
