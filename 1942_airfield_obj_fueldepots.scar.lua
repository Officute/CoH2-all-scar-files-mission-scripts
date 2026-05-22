-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1942 ToW CHALLENGE: TATSINSKAIA AIRFIELD
-- Objective File - FUEL DEPOTS
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_FuelDepots()
	
	-- Pre-condition:		Starts when the player approaches one of the depots
	-- Success condition:	Player has captured ALL the depots
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		Bonusses granted on capturing each depot (so, potentially x2)
	--		Failure:		N/A
	
	OBJ_FuelDepots = {
		
		--Info
		Title = 11052236,	-- Objective Title		-- locdb [11052236] "Capture the Fuel Depots"
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.FuelDepot_Intro,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,						-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,						-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,						-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,						-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,						-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
			hintid_fueldepot1 = Objective_AddUIElements(OBJ_FuelDepots, eg_point_fueldepot1, true, nil, true)
			hintid_fueldepot2 = Objective_AddUIElements(OBJ_FuelDepots, eg_point_fueldepot2, true, nil, true)
			
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
			Event_PlayerOwnsTerritory(FuelDepots_CapturedPoint, {point = eg_point_fueldepot1}, player1, eg_point_fueldepot1, ANY)
			Event_PlayerOwnsTerritory(FuelDepots_CapturedPoint, {point = eg_point_fueldepot2}, player1, eg_point_fueldepot2, ANY)
			
		end,
		IsComplete = function() 
			
			if fueldepot_num_captured == 2 then
				return true
			end
			
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()	end,				-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = function() return false end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	
	--------------------
	-- INITIALISATION --
	--------------------
	
	-- trigger this objective to start when the player approaches one of the depots
	Event_Proximity(FuelDepots_ApproachDepot, {encounter = ENCOUNTERS.FuelDepot1}, player1, mkr_fueldepot1_zone, nil, ANY)
	Event_Proximity(FuelDepots_ApproachDepot, {encounter = ENCOUNTERS.FuelDepot2}, player1, mkr_fueldepot2_zone, nil, ANY)

	fueldepot_num_captured = 0				-- how many depots the player has captured (affects which line of speech we play)
	fueldepot_callins_awarded = 0			-- how many bonus tanks the player has currently earned (and not spent)
	fueldepot_callins_visible = false		-- whether the "menu" of bonus tanks is onscreen at the moment
	
	
	
end
Scar_AddInit(INIT_Obj_FuelDepots)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function FuelDepots_ApproachDepot(data)
	
	-- start the objective if it hasn't been started already
	if Objective_IsStarted(OBJ_FuelDepots) == false then
		
		Objective_Start(OBJ_FuelDepots)
		
	end
	
	-- create the encounter that populates the area
	data.encounter()

end


function FuelDepots_CapturedPoint(data)

	-- make point non-recapturable
	Entity_EnableStrategicPoint(EGroup_GetSpawnedEntityAt(data.point, 1), false)
	
	-- remove the objective minimap ping 
	if data.point == eg_point_fueldepot1 then
		Objective_RemoveUIElements(OBJ_FuelDepots, hintid_fueldepot1)
	elseif data.point == eg_point_fueldepot2 then
		Objective_RemoveUIElements(OBJ_FuelDepots, hintid_fueldepot2)
	end
	
	-- award bonus! 
	fueldepot_callins_awarded = fueldepot_callins_awarded + 1
	if fueldepot_callins_visible == false then
		
		-- show the "menu" if it isn't up already
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv1"), ITEM_UNLOCKED)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv8"), ITEM_UNLOCKED)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_t34"), ITEM_UNLOCKED)
		
		Rule_AddPlayerEvent(FuelDepots_AbilityCallback, player1, GE_AbilityExecuted)
		
		fueldepot_callins_visible = true
		
	end
	if fueldepot_callins_awarded == 2 then
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2"), ITEM_UNLOCKED)
	end
	
	-- play the speech 
	fueldepot_num_captured = fueldepot_num_captured + 1
	if fueldepot_num_captured == 1 then
		
		Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.FuelDepot_Bonus1})
		
	elseif fueldepot_num_captured == 2 then
		
		if fueldepot_callins_awarded == 1 then
			Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.FuelDepot_Bonus2})				-- if the player has spent the point from the first depot...
		elseif fueldepot_callins_awarded == 2 then
			Event_NarrativeEventsNotRunning(EventHandler_StartIntel, {intel = EVENTS.FuelDepot_Bonus2_KV2})			-- if the player has kept the point from the first depot, you get the secret KV-2 version!
		end
		
	end
	
end

function FuelDepots_AbilityCallback(caster, ability, target)
	
	-- reduce the bonus count
	if ability == BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2") then
		fueldepot_callins_awarded = fueldepot_callins_awarded - 2
	elseif ability == BP_GetAbilityBlueprint("tow_airfield_dispatch_kv1") 
	    or ability == BP_GetAbilityBlueprint("tow_airfield_dispatch_kv8") 
	    or ability == BP_GetAbilityBlueprint("tow_airfield_dispatch_t34") then
		fueldepot_callins_awarded = fueldepot_callins_awarded - 1
	end
	
	-- hide the menu if they're all used up
	if fueldepot_callins_awarded <= 0 then
		
		-- player has spent ALL their points, so hide EVERYTHING!
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv1"), ITEM_REMOVED)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv8"), ITEM_REMOVED)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_t34"), ITEM_REMOVED)
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2"), ITEM_REMOVED)
		
		Rule_RemoveMe()
		fueldepot_callins_visible = false
		
	elseif fueldepot_callins_awarded == 1 then
		
		-- player has spent ONE point when they had TWO, so just hide the behemoth
		Player_SetAbilityAvailability(player1, BP_GetAbilityBlueprint("tow_airfield_dispatch_kv2"), ITEM_REMOVED)
		
	end
	
end
