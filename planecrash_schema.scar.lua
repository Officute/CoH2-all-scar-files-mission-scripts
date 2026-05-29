--
-- WorldBuilder prefab
-- "PlaneCrash"
--


-- Schema

planecrash_schema = {		-- schema ALWAYS named the prefab name with schema on the end
	
	type = "Prefab",
	name = "planecrash",																						-- name the prefab uses to identify itself
	description = "Plane Crash",																				-- name to display for this prefab
	script = "PlaneCrash.scar",																		-- script associated with this prefab, needs to be imported into the prefab data script
	proxy = "art/gameplay/prefabs/prefab_plane_crash/prefab_plane_crash",				-- some identifying visual we can see in the WB - something to click on, too, in order to select the prefab
	itemSchema = {
		
		{
			type = ST_BOOLEAN,
			name = "trigger_enable",                 
			description = "Use trigger zone",          
			default = false,                            
		},
		{
			type = ST_PLAYER,
			name = "trigger_player",
			description = "Trigger player:",
			default = "Player1",               
			requirement = {"trigger_enable", true},
		},
		{
			type = ST_MARKER,
			name = "trigger_zone",
			description = "Trigger zone",
			colour = "white",
			requirement = {"trigger_enable", true},
			hasRange = true,
		},
		{
			type = ST_BOOLEAN,
			name = "ignore_planes",                 
			description = "Ignore planes",          
			default = false,                            
			requirement = {"trigger_enable", true},
		},
		{
			type = ST_NUMBER,
			name = "delay",
			description = "Delay:",
			default = 0,
			requirement = {"trigger_enable", true},
		},
		{
			type = ST_PLAYER,
			name = "plane_owner",
			description = "Plane belongs to:",
			default = "Player2",
		},
		{
			type = ST_MARKER,
			name = "plane_location",
			description = "Crash location",
			colour = "orange",
			hasDirection = true,
		},
		{
			type = ST_BOOLEAN,
			name = "once_only",
			description = "Once only",
			default = true,                     
		},
		
		
	},
}