-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Bonus Objective
-- Objective File - Capture The Intel
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


--[[	This is the data table that has to go inside the secondaryObjectives section of your g_missionData table:
	
	{										
		obj = SecondaryOBJ_CaptureIntel,
		data = {
			
  			-- Required items 
			locations 			= {marker1, marker2, marker3...},											-- potential locations for spawning intel items
			number_to_spawn 	= Integer,																	-- how many items will be spawned.  MAKE SURE THERE ARE ENOUGH LOCATIONS IN THE TABLE ABOVE TO COVER THIS!
			number_to_capture 	= Integer,																	-- how many the player needs to capture in order to complete the objective 
			base_area 			= MarkerID,																	-- the area you need to return items to 
	
			
			-- Optional items --
			intel_ebp 			= BP_GetEntityBlueprint("captureintel_pickup"),								-- defaults to a suitable Intel pickup EBP, but you can specify another blueprint here
			intel_slotitem 		= BP_GetSlotItemBlueprint("captureintel_slotitem"),							-- the corresponding slot item to any new pickup item specified above
			title 				= LocID,																	-- an alternative objective title (if you're swapping the item out, you probably want to re-word the objective)
			return_message 		= LocID,																	-- alternative hintpoint text to use on the hintpoint that tells you to return items to the base (again, may need to re-word it if you change the item)
			bonus_callback 		= LuaFunction(Int num_captured, Int num_required, SGroup returning_squad),	-- alternative bonus function, called every time you return an item. Tells you whether this was the 1st, 2nd, 3rd, etc item returned, out of how many, and who returned it
			bonus_message		= LocID,																	-- the default bonus_callback function uses this message on a kicker over the returning squad
 		},
	},
--]]



-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_BonusCaptureIntel()

	print("Initializing SecondaryOBJ_CaptureIntel...")
	
	
	-- Objective specific variables
	_eg_bonus_IntelItems = EGroup_CreateIfNotFound("_eg_bonus_IntelItems")
	
	
	-- Pre-condition:		Mission_StartSecondaryObjective called
	-- Success condition:	Player collects and returns to base the required number of intel items
	-- Failure condition:	Mission ends
	-- Post-condition:
	--		Success:		Company Strength increases by 10%
	--		Failure:		
	SecondaryOBJ_CaptureIntel = {
		
		--Info
		Title = 11076418, -- LOCDB [11076418] 'Capture intelligence items and bring them to your HQ'
		Type = OT_Bonus,
		Parent = nil,
		
		--Intel
		Intel_Start = 				CaptureIntel_IntroEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			CaptureIntel_OutroEvent,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		
		--Functions
		SetupUI = function()
			if SecondaryOBJ_CaptureIntel.data.number_to_capture >= 2 then
				Objective_SetCounter(SecondaryOBJ_CaptureIntel, SecondaryOBJ_CaptureIntel.data.number_captured, SecondaryOBJ_CaptureIntel.data.number_to_capture)	-- add a counter to the objective (only if you have to capture multiple)
			end
		end,
		PreStart = CaptureIntel_Start,
		OnStart = nil,
		IsComplete = function() 
			-- have we captured enough intel items?
			return SecondaryOBJ_CaptureIntel.data.number_captured >= SecondaryOBJ_CaptureIntel.data.number_to_capture
		end,
		PreComplete = nil,
		OnComplete = function()
			Rule_Remove(CaptureIntel_ReturnCheck)
			Rule_AddInterval(CaptureIntel_ShowReward, 1)
		end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
end
Scar_AddInit(INIT_BonusCaptureIntel)


-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function CaptureIntel_Start()

	-- give player the necessary upgrade that enables the AE->SCAR callbacks used by this system
	Cmd_Upgrade(player1, BP_GetUpgradeBlueprint("capture_intel_enable"), 1, true)

	-- create some objective specific groups
	eg_capture_intel_pickups = EGroup_CreateIfNotFound("eg_capture_intel_pickups")
	sg_capture_intel_carriers = SGroup_CreateIfNotFound("sg_capture_intel_carriers")
	t_capture_intel_objectivepings = {}
	t_capture_intel_carrierpings = {}
	
	-- add some defaults to the data table if they aren't specified explicitly
	SecondaryOBJ_CaptureIntel.data.intel_ebp			= SecondaryOBJ_CaptureIntel.data.intel_ebp or BP_GetEntityBlueprint("capture_intel_pickup")
	SecondaryOBJ_CaptureIntel.data.intel_slotitem 		= SecondaryOBJ_CaptureIntel.data.intel_slotitem or BP_GetSlotItemBlueprint("capture_intel_slotitem")
	SecondaryOBJ_CaptureIntel.data.intel_upgrade 		= SecondaryOBJ_CaptureIntel.data.intel_upgrade or BP_GetUpgradeBlueprint("capture_intel_carrying")
	
	SecondaryOBJ_CaptureIntel.Title 					= SecondaryOBJ_CaptureIntel.data.title or SecondaryOBJ_CaptureIntel.Title
	SecondaryOBJ_CaptureIntel.data.return_message 		= SecondaryOBJ_CaptureIntel.data.return_message or 11076419 -- LOCDB [11076419] 'Bring captured Enemy Intelligence items here'
	SecondaryOBJ_CaptureIntel.data.carrying_message		= SecondaryOBJ_CaptureIntel.data.carrying_message or 11081059 -- LOCDB [11081059] 'Carrying Enemy Intelligence'
	
	
	SecondaryOBJ_CaptureIntel.data.bonus_callback 		= SecondaryOBJ_CaptureIntel.data.bonus_callback or CaptureIntel_DefaultBonus
	SecondaryOBJ_CaptureIntel.data.bonus_message 		= SecondaryOBJ_CaptureIntel.data.bonus_message or 11076420 -- LOCDB [11076420] 'Enemy Intelligence returned\n+300 Manpower'
	
	-- set up some other variables
	SecondaryOBJ_CaptureIntel.data.number_captured = 0
	
	-- spawn intel objects around the map 
	local number = SecondaryOBJ_CaptureIntel.data.number_to_spawn
	local chosen_locations = Table_GetRandomItem(SecondaryOBJ_CaptureIntel.data.locations, SecondaryOBJ_CaptureIntel.data.number_to_spawn)		-- choose locations
	
	if scartype(chosen_locations) == ST_MARKER then	 																							-- throw marker into a table if it wasn't in one already (safety)
		chosen_locations = {chosen_locations}
	end
	
	for index, this_location in pairs(chosen_locations) do 																						-- and spawn one item at each marker
		local pos = Util_GetPosition(this_location)	
		Util_CreateEntities(nil, eg_capture_intel_pickups, SecondaryOBJ_CaptureIntel.data.intel_ebp, pos, 1, World_Pos(pos.x - 1, pos.y, pos.z))
		Event_PlayerCanSeeElement(CaptureIntel_IntelSpotted, {location = this_location}, player1, pos, ANY, 0)
	end
	
	
	-- add a rule to check 
	Rule_AddInterval(CaptureIntel_ReturnCheck, 1)
	
	if scartype(SecondaryOBJ_CaptureIntel.data.additionalEncounters) == ST_TABLE then
		for i = 1, table.getn(SecondaryOBJ_CaptureIntel.data.additionalEncounters) do
			SecondaryOBJ_CaptureIntel.data.additionalEncounters[i]()
		end
	end
	
end

--Triggered when an intel item is spotted
function CaptureIntel_IntelSpotted(data)
	
	if Prox_AreEntitiesNearMarker(eg_capture_intel_pickups, data.location, ANY, 10) then
		local blipid = Objective_AddUIElements(SecondaryOBJ_CaptureIntel, data.location, true, 11076421, true, 1.0) -- LOCDB [11076421] 'Intel. item'
		table.insert(t_capture_intel_objectivepings, {blipid = blipid, location = data.location})
	end
	
end

-- called when a carrying squad is killed
function CaptureIntel_SquadKilled(squad)
	CaptureIntel_DropItem(squad)	
end

-- called when a carrying squad recrews a vehicle
function CaptureIntel_VehicleRecrewed(vehicle, squad)
	CaptureIntel_DropItem(squad, vehicle)
end

--Drops a new intel item on the ground
function CaptureIntel_DropItem(squad, vehicle)	

	-- remove the hintpoint
	for index, item in pairs(t_capture_intel_carrierpings) do 
		if item.squad == Squad_GetGameID(squad) then
			Objective_RemoveUIElements(SecondaryOBJ_CaptureIntel, item.map_ping)
			HintPoint_Remove(item.hint_point)
			table.remove(t_capture_intel_carrierpings, index)
		end
	end
	
	Rule_RemoveSquadEvent(CaptureIntel_SquadKilled, squad)
	Rule_RemoveSquadEvent(CaptureIntel_VehicleRecrewed, squad)

	-- remove the upgrade 
	Squad_RemoveUpgrade(squad, SecondaryOBJ_CaptureIntel.data.intel_upgrade)
	
	--Remove from carrier sgroup
	SGroup_Remove(sg_capture_intel_carriers, squad)
	
	-- drop a new breifcase on the ground
	local pos = Squad_GetPosition(squad) or Entity_GetPosition(vehicle)
	Util_CreateEntities(nil, eg_capture_intel_pickups, SecondaryOBJ_CaptureIntel.data.intel_ebp, pos, 1, World_Pos(pos.x - 1, pos.y, pos.z))

	local blipid = Objective_AddUIElements(SecondaryOBJ_CaptureIntel, pos, true, 11076421, true, 1.0) -- LOCDB [11076421] 'Intel. item'
	table.insert(t_capture_intel_objectivepings, {blipid = blipid, location = pos})
	
end



-- called as an action from the AE when the player picks an item up from the ground
function CaptureIntel_ItemPickedUp(squad, target)		

	-- add this squad to the group of units currently carrying intel
	SGroup_Add(sg_capture_intel_carriers, squad)
	
	-- add a hintpoint to the squad carrying the intel
	local map_ping = Objective_AddUIElements(SecondaryOBJ_CaptureIntel, squad, true)
	local hint_point = HintPoint_Add(squad, true, SecondaryOBJ_CaptureIntel.data.carrying_message)
	table.insert(t_capture_intel_carrierpings, {map_ping = map_ping, hint_point = hint_point, squad = Squad_GetGameID(squad)})
	
	-- add the upgrade (prevents the unit from picking up TWO intel objects!)
	-- THIS IS DONE IN THE AE!
	
	-- add the rule that'll kick in when the squad dies (to drop the item)
	Rule_AddSquadEvent(CaptureIntel_SquadKilled, squad, GE_SquadKilled)
	Rule_AddSquadEvent(CaptureIntel_VehicleRecrewed, squad, GE_DriverRecrewed)
	
	-- find the blip closest to this location 
	local position = Util_GetPosition(squad)
	local closest_index = 0
	local closest_distance = 999999
	for index = 1, #t_capture_intel_objectivepings do 
		local this_distance = Util_GetDistance(position, t_capture_intel_objectivepings[index].location)
		if this_distance < closest_distance then
			closest_distance = this_distance
			closest_index = index
		end
	end
	
	-- remove the blip 
	if closest_index ~= 0 then
		Objective_RemoveUIElements(SecondaryOBJ_CaptureIntel, t_capture_intel_objectivepings[closest_index].blipid)
		table.remove(t_capture_intel_objectivepings, closest_index)
	end
	
	-- ping the return location (if it isn't already pinged)
	if hpid_captureintel_returntobase == nil then
		hpid_captureintel_returntobase = Objective_AddUIElements(SecondaryOBJ_CaptureIntel, SecondaryOBJ_CaptureIntel.data.base_area, true, SecondaryOBJ_CaptureIntel.data.return_message, true)										
	end
	
end

-- monitor units at the base area to see if any are returning the intel items
function CaptureIntel_ReturnCheck()
	
	local single = SGroup_Create("")

	
	-- check each squad to see if it's carrying the slot item
	local _CheckSquad = function(gid, idx, sid)
	
		if Squad_IsRetreating(sid) then
			
			CaptureIntel_DropItem(sid)
			
		elseif Marker_InProximity(SecondaryOBJ_CaptureIntel.data.base_area, Util_GetPosition(sid)) and Squad_HasUpgrade(sid, SecondaryOBJ_CaptureIntel.data.intel_upgrade) then
			
			-- remove the slotitem
			SGroup_Single(single, sid)
			
			-- remove the hintpoint
			for index, item in pairs(t_capture_intel_carrierpings) do 
				if item.squad == Squad_GetGameID(sid) then
					Objective_RemoveUIElements(SecondaryOBJ_CaptureIntel, item.map_ping)
					HintPoint_Remove(item.hint_point)
					table.remove(t_capture_intel_carrierpings, index)
				end
			end
			
			-- remove the upgrade 
			Squad_RemoveUpgrade(sid, SecondaryOBJ_CaptureIntel.data.intel_upgrade)
	
			-- remove the onDeath callback that drops the item 			
			Rule_RemoveSquadEvent(CaptureIntel_SquadKilled, sid)
			Rule_RemoveSquadEvent(CaptureIntel_VehicleRecrewed, sid)
			SGroup_Remove(sg_capture_intel_carriers, sid)
			
			-- credit the player with the return of the intel
			SecondaryOBJ_CaptureIntel.data.number_captured = SecondaryOBJ_CaptureIntel.data.number_captured + 1
			if SecondaryOBJ_CaptureIntel.data.number_to_capture >= 2 then
				Objective_SetCounter(SecondaryOBJ_CaptureIntel, SecondaryOBJ_CaptureIntel.data.number_captured, SecondaryOBJ_CaptureIntel.data.number_to_capture)
			end
			
			-- give the player a bonus (if specified)
			if scartype(SecondaryOBJ_CaptureIntel.data.bonus_callback) == ST_FUNCTION then
				SecondaryOBJ_CaptureIntel.data.bonus_callback(SecondaryOBJ_CaptureIntel.data.number_captured, SecondaryOBJ_CaptureIntel.data.number_to_capture, single)
			end
			
		end
	end
	SGroup_ForEach(sg_capture_intel_carriers, _CheckSquad)
	
	SGroup_Destroy(single)	-- De-alloc
	
	-- remove base hint if there is no longer anyone carrying intel (either because they returned it or they died)
	if hpid_captureintel_returntobase ~= nil and SGroup_Count(sg_capture_intel_carriers) == 0 then
		Objective_RemoveUIElements(SecondaryOBJ_CaptureIntel, hpid_captureintel_returntobase)
		hpid_captureintel_returntobase = nil
	end
	
end

-- default bonus function: Give the player 300 Manpower per item returned
function CaptureIntel_DefaultBonus(num_captured, num_needed, returning_squad)
	
	if num_captured <= num_needed then
		Player_AddResource(player1, RT_Manpower, 300)
		UI_CreateSGroupKickerMessage(player1, returning_squad, SecondaryOBJ_CaptureIntel.data.bonus_message)
	end
	
end

--Grants the player the reward and shows the corresponding text
function CaptureIntel_ShowReward()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		XP1_AddCompanyStrength(10, true)
	end
end



---------------------------
-- INTEL EVENTS
---------------------------
--SEQUENCE "" MISSION "SOBJ_CaptureIntel" CHARACTER "Intel"
function CaptureIntel_IntroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074780)	-- LOCDB [11074780] 'We need more information on German movements in the area. Retrieve German intel caches and bring them back to our HQ.' - 'Intel'
	CTRL.WAIT()
end

function CaptureIntel_OutroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074781)	-- LOCDB [11074781] 'Good job collecting the intel. It will certainly make our jobs easier.' - 'Intel'
	CTRL.WAIT()
end
