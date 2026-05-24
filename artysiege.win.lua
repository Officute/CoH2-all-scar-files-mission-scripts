name = "artillery_siege"
scar_file = "data:scar/winconditions/as.scar"
fe_name = "Artillery Siege"
fe_priority = 0
fe_option_name = "Game Length"
options = {
	{
		fe_name = "Swift Encounter",
		value = 1
	},
	{
		fe_name = "Prolonged Battle",
		value = 2
	}
}
score_display = none
show_time = false
entity_replacements =
{
	{
		original = "victory_point",
		replacement = "territory_point_mp",
	}
}
