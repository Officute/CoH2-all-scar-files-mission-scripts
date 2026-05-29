--
-- WorldBuilder prefab
-- "SimpleDefendEncounter"
--


-- Schema

simpledefendencounter_schema = {		-- schema ALWAYS named the prefab name with schema on the end   
	
	type = "Prefab",
	name = "simpledefendencounter",																					-- name the prefab uses to identify itself
	description = "Simple Defend Encounter",																		-- name to display for this prefab
	script = "SimpleDefendEncounter.scar",																-- script associated with this prefab, needs to be imported into the prefab data script
	proxy = "art/gameplay/prefabs/prefab_defend_encounter/prefab_defend_encounter", 		-- some identifying visual we can see in the WB - something to click on, too, in order to select the prefab
    itemSchema = {
		
		{
			type = ST_STRING,
			name = "when_to_spawn",
			description = "Spawn:",
			options = {"Immediately", "Use trigger zone", "Manually"},
			default = "Immediately",
			tooltip = "Set when this encounter gets spawned.",
		},
		{
			type = ST_PLAYER,
			name = "trigger_player",
			description = "Trigger player:",
			default = "Player1",
			requirement = {"when_to_spawn", "Use trigger zone"},
		},
		{
			type = ST_MARKER,
			name = "trigger_zone",
			description = "Trigger zone",
			colour = "white",
			hasRange = true,
			requirement = {"when_to_spawn", "Use trigger zone"},
			tooltip = "This should be large enough to ensure that units on the edge of the zone won't see the units in the encounter spawn.",
		},
		{
			type = ST_BOOLEAN,
			name = "ignore_planes",                 
			description = "Ignore planes",          
			default = false,                            
			requirement = {"when_to_spawn", "Use trigger zone"},
		},
		{
			type = ST_NUMBER,
			name = "delay",
			description = "Delay:",
			default = 0,
			requirement = {"when_to_spawn", "Use trigger zone"},
		},
		
		
        {
            type = ST_PLAYER,
            name = "player",
            description = "Encounter player:",
            default = "Player2",          
        },
        {
            type = ST_STRING,
            name = "name",
            description = "Name:",
            default = "",
			tooltip = "Used to help debug encounters.",
        },
		{
			type = ST_SGROUP,
			name = "sgroup",
			description = "SGroup:",
			tooltip = "All units in this encounter will be part of this sgroup",
		},
        {
            type = ST_TABLE,
            name = "units",
            description = "Units",
            multiplicity = "multiple", -- this distinguishes lists of groups from a single group of things, etc...
            itemSchema = {
                {
                    type = ST_MARKER,
                    name = "location",
                    description = "Spawn location",
					colour = "red",
					hasDirection = true,
                },
                {
                    type = ST_PBG, 
                    name = "blueprint",
                    description = "Unit type:",
					blueprintType = "squad",
					show = true,
					lockedTo = "location",
					showAlways = true,
					default = "volksgrenadier_squad_mp",
                },
            },
        },
		
		
		{
            type = ST_TABLE,
            name = "goal",
            description = "Goal data",
            multiplicity = "single",
            itemSchema = {
				
				{
					type = ST_STRING,
					name = "goal_trigger",    
					description = "Trigger goal:",
					options = {"Manually","Immediately", "On sight", "On engage"},
					default = "Manually",
				},
				{
					type = ST_MARKER,
					name = "target",
					description = "Defend zone",
					tooltip = "The encounter will primarily defend against units that move into this zone.",
					colour = "blue",
					hasRange = true,
				},
				{
					type = ST_MARKER,
					name = "leashRange",
					description = "Leash range",
					tooltip = "Units in the enounter will (normally) stay within the leash range.",
					colour = "yellow",
					hasRange = true,
					lockedTo = "target",
				},
				{
					type = ST_BOOLEAN,
					name = "garrisonIdle",           
					description = "Use buildings when idle",        
					default = false,          
				},
				{
					type = ST_BOOLEAN,
					name = "garrison",  
					description = "Use buildings in combat",
					default = false,  
				},
				
			},
		},
		
		
		{
			type = ST_BOOLEAN,
			name = "abilityblacklist_enable",
			description = "Blacklist abilities",
			tooltip = "Enable a blacklist, so units in this encounter won't use the listed abilities.",
			default = false,
		},
		{
			type = ST_TABLE,
			name = "abilityblacklist",
			description = "Blacklist",
			multiplicity = "multiple",
			requirement = {"abilityblacklist_enable", true},
			itemSchema = {
				
				{
					type = ST_PBG,
					name = "ability",
					description = "Ability:",
					blueprintType = "ability",
				},
			
			},
		},
		
		
		{
			type = ST_BOOLEAN,
			name = "tactics_enable",
			description = "Configure tactics",
			tooltip = "Manually configure the AI tactics used by this encounter.",
			default = false,
		},
		{
			type = ST_TABLE,
			name = "tactics",
			description = "Tactics",
			multiplicity = "multiple",
			requirement = {"tactics_enable", true},
			itemSchema = {
			
				{
					type = ST_STRING,
					name = "tactic_type",
					description = "Tactic:",
					options = {"Use abilities", "Use cover", "Garrison", "Avoid artillery/grenades", "Maneuver vehicle", "Force attack", "Pick up slot items", "Pick up team weapons", "Recrew vehicles", "Rush at target"},
					default = "Use abilities",
				},
				{
					type = ST_STRING,
					name = "tactic_setting",
					description = "Setting:",
					options = {"High", "Medium", "Low", "Never", "Manual"},
					default = "Medium",
				},
				{
					type = ST_NUMBER,
					name = "tactic_priority",
					description = "Priority:",
					integer = true,
					min = -1,
					max = 1000,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "priority value of tactic. -1 is disabled, 1000 is max priority, nil is default Skirmish AI values.",
					default = 0,
				},
				{
					type = ST_NUMBER,
					name = "tactic_maxusers",
					description = "Max users:",
					integer = true,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "max number of simultaneous users of this tactic.",
					default = 1,
				},
				{
					type = ST_NUMBER,
					name = "tactic_maxrange",
					description = "Maxrange:",
					integer = true,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "max range from squad to target (note: other range constraints may limit the range to a smaller distance)",
					default = 1,
				},
				{
					type = ST_NUMBER,
					name = "tactic_retrytime",
					description = "Retry time (seconds):",
					integer = true,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "seconds to wait between squads retrying the tactic if it fails to execute.",
					default = 1,
				},
				{
					type = ST_NUMBER,
					name = "tactic_waittime",
					description = "Wait time (seconds):",
					integer = true,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "seconds to wait between squads reusing the tactic again, after performing tactic previously.",
					default = 1,
				},
				{
					type = ST_NUMBER,
					name = "tactic_timeout",
					description = "Time out (seconds):",
					integer = true,
					requirement = {"tactic_setting", "Manual"},
					tooltip = "maximum time in seconds to wait for tactic to complete running before stopping it.",
					default = 1,
				},
				{
					type = ST_BOOLEAN,
					name = "tactic_useinitialwaittime",
					description = "Use initial wait time",
					requirement = {"tactic_setting", "Manual"},
					tooltip = "If true, units will wait the Wait time (above) before the first run attempt.",
					default = false,
				},
				
			},
		},
    },
}
