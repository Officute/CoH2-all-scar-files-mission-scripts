name = "victory_point"
scar_file = "DATA:Scar/WinConditions/main.scar"
fe_name = "Airborne Raid"
fe_priority = 0
score_display = vp_ticker
show_time = true
requires_vp_ticker = false
permitted_categories = intel_bulletin + skin_pack + vehicle_decal + fatality

fe_option_name = "$11038967"
options =
{
	{
		fe_name = "$40644",
		value = 250,
	},
	{
		default = true,
		fe_name = "$40641",
		value = 500,
	},
	--{
	--	fe_name = "$40642",
		--value = 1000,
    --},
}

entity_replacements =
{
	{
		original = "ebps/gameplay/victory_point",
        replacement = "ebps/gameplay/territory_point_mp",
        --replacement = "ebps/gameplay/axis_hq_capturable",
	}
}


-- List of starting buildings/squads to spawn.

starting_building_replacements =
{
    -- Replaces default starting building with prebuilt base.
  --  {
     --   original = "default_mp",
     --   replacement = "prebuilt_mp",
  --  },
    -- Removes all bunkers.
    {
        original = "bunker",
        replacement = "",
    },
    -- Replaces default starting building/squads with the specified building/squads on a per race baises.
    {
        original = "default_mp",
        starting_buildings =
        {
            {
                race = "aef",
                building = "ebps/races/aef/buildings/base_building/rifle_command_mp",
                starting_squads =
                {
                    --"6c196065c70546af8f51e48c1f0a0f75:sniper_team_mp",
                    --"6c196065c70546af8f51e48c1f0a0f75:paratrooper_squad",
                    --"m8_greyhound_squad_mp"
                },
            },
        },
    },
}
