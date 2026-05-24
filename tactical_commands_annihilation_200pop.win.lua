name = "tactical_commands_annihilation_200pop"
scar_file = "data:scar/winconditions/tc_core.scar"
fe_name = "Tactical Commands (Annihilation)"
fe_priority = 0	
score_display = time
show_time = true
requires_vp_ticker = false

entity_replacements = 
{
	{
		original = "ebps/gameplay/victory_point",
		replacement = "ebps/gameplay/territory_point_mp",
	},
}

