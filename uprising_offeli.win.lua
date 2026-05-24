name = "uprising_OffEli"
scar_file = "data:scar/winconditions/uprising_OffEli.scar"
fe_name = "Uprising - Officer Assassination"
fe_priority = 0
fe_option_name = "Number Of Officers"
options = {
	{
		fe_name = "2 Officers",
		value = 2,
	},
	{
		fe_name = "3 Officers",
		value = 3,
	},
	{
		fe_name = "4 Officers",
		value = 4,
	},
	{
		fe_name = "5 Officers",
		value = 5,
	},
}
score_display = time
show_time = true
entity_replacements =
{
	{
		original = "victory_point",
		replacement = "9d197160ccb545028db7d0bf1c944418:radio_tower_point_uprising_mp",
	}
}
