name = "Attrition - Supply Mode"
scar_file = "DATA:Scar/WinConditions/Attrition.scar"
fe_name = "Attrition - Supply Mode"
fe_priority = 0
requires_vp_ticker = false
score_display = vp_ticker
show_time = true
entity_replacements = 
{ 
	{
		original = "ebps/gameplay/territory_point_mp",
		replacement = "04f85e44bd424ec0845ab9c68c1dd7fb:ebps/gameplay/territory_point_mp",
	},
	{
		original = "ebps/gameplay/territory_munitions_point_mp",
		replacement = "04f85e44bd424ec0845ab9c68c1dd7fb:ebps/gameplay/territory_munitions_point_mp",
	},
	{
		original = "ebps/gameplay/territory_fuel_point_mp",
		replacement = "04f85e44bd424ec0845ab9c68c1dd7fb:ebps/gameplay/territory_point_mp",
	},
}
starting_building_replacements =
{
	{
		original = "default",
		replacement = "prebuilt_mp",
	},
	{
		original = "default_mp",
		starting_buildings =
				{
					{
						race = "aef",
						building = "aef_base_stamper",
						starting_squads ={},
					},
					{
						race = "soviet",
						building = "soviet_base_stamper",
						starting_squads ={},
					},
					{
						race = "west_german",
						building = "west_german_base_stamper",
						starting_squads ={},
					},
					{
						race = "german",
						building = "german_base_stamper",
						starting_squads ={},
					},
				},       
	},

}











