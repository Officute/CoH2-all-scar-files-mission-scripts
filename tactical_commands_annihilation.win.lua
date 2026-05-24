name = "tactical_commands_annihilation"
scar_file = "data:scar/winconditions/tc_200pop.scar"
fe_name = "Tactical Commands (Ann. 200 Pop)"
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

