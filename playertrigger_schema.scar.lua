--
-- WorldBuilder prefab
-- "PlayerTrigger"
--


-- Schema

playertrigger_schema = {		-- schema ALWAYS named the prefab name with schema on the end

	type = "prefab", 
	name = "playertrigger",																						-- name the prefab uses to identify itself
	description = "Player Trigger",																			-- name to display for this prefab
	script = "PlayerTrigger.scar",																	-- script associated with this prefab, needs to be imported into the prefab data script
	proxy = "art/gameplay/prefabs/prefab_trigger_zone/prefab_trigger_zone",			-- some identifying visual we can see in the WB - something to click on, too, in order to select the prefab
	itemSchema = {
		
		{
			type = ST_PLAYER,
			name = "trigger_player",
			description = "Trigger player:",
			default = "Player1",                     
		},
		{
			type = ST_MARKER,
			name = "trigger_zone",
			description = "Trigger zone",
			colour = "white",
			default = true,
			hasRange = true,
		},
		{
			type = ST_BOOLEAN,
			name = "ignore_planes",
			description = "Ignore planes",
			default = true,                     
		},
		{
			type = ST_TABLE,
			name = "things_to_trigger",
			description = "Things to trigger",
			multiplicity = "multiple",
			default = {},
			itemSchema = {
				{
					type = ST_STRING,
					name = "trigger_type",
					description = "Trigger a",
					options = {"Prefab", "Scar Function"},
					default = "Prefab",
				},
				{
					type = ST_STRING,
					name = "trigger_target",
					description = "  named:",
					variableName = true,
				},
				{
					type = ST_NUMBER,
					name = "delay",
					description = "Delay:",
					default = 0,
				},
			},
		},
 
	},
}