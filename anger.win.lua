name = "anger"
scar_file = "data:scar/winconditions/anger.scar"
fe_name = "Anger"
fe_priority = 0
permitted_categories = intel_bulletin + skin_pack + fatality + vehicle_decal
score_display = time
show_time = true
entity_replacements =
{
	{
		original = "victory_point",
		replacement = "support_bay",
	}
}
starting_building_replacements =
{
    {
        original = "bunker",
        starting_buildings =
        {
            {
                race = "aef",
            },
            {
                race = "german",
                building = "axis_panzerschreck_item_mp",
            },
            {
                race = "soviet",
            },
            {
                race = "west_german",
                building = "axis_panzerschreck_item_mp",
            },
        },
    },
    {
        original = "default_mp",
        starting_buildings =
        {
            {
                race = "aef",
				building = "8fa2fab75c21418fa3061fe86e76cad9:hq_invisible_mp",
                starting_squads =
                {
                    "8fa2fab75c21418fa3061fe86e76cad9:m4a3e8_sherman_anger_squad_mp",
                },
            },
            {
                race = "german",
                building = "8fa2fab75c21418fa3061fe86e76cad9:german_hq_anger_mp",
                starting_squads =
                {
                    "8fa2fab75c21418fa3061fe86e76cad9:pioneer_anger_squad_mp",
                    "8fa2fab75c21418fa3061fe86e76cad9:grenadier_anger_squad_mp",
                },
            },
            {
                race = "soviet",
				building = "8fa2fab75c21418fa3061fe86e76cad9:hq_invisible_mp",
                starting_squads =
                {
                    "8fa2fab75c21418fa3061fe86e76cad9:t_34_85_anger_squad_mp",
                },
            },
            {
                race = "west_german",
                building = "8fa2fab75c21418fa3061fe86e76cad9:west_german_hq_anger_mp",
                starting_squads =
                {
                    "assault_pioneer_squad_mp",
                    "volksgrenadier_squad_mp",
                },
            },
        },
    },
}
