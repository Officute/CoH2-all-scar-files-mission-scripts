name = "cheatcommands_mod_annihilation"
scar_file = "data:scar/winconditions/ccm_victorypoint.scar"
fe_name = "CheatCommands (Annihilation)"
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
