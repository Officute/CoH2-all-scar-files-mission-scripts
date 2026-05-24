name = "cheatcommands_mod_nowincondition"
scar_file = "data:scar/winconditions/ccm_nowincondition.scar"
fe_name = "CheatCommands (None)"
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
