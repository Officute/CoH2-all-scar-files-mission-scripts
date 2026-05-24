name = "the_last_tiger"
scar_file = "data:scar/winconditions/TLT.scar"
fe_name = "The Last Tiger"
fe_priority = 0
fe_option_name = "Time until German reinforcements"
options = {
	{
		fe_name = "20 Minutes",
		value = 1,
	},
	{
		fe_name = "30 Minutes",
		value = 2,
	},
	{
		fe_name = "40 Minutes",
		value = 3,
	},
}
score_display = time
show_time = true
entity_replacements =
{
	{
		original = "victory_point",
		replacement = "territory_point_mp",
	}
}
