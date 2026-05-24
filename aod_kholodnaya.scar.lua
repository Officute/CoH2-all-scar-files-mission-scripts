import("ScarUtil.scar")

-- SETUP ------------------------------------------------

SETUP = {
	["WAVE_DEFAULT_INTERVAL"] = 10,
	["START_TIME"] = 60,
	["BOMB_FRIENDLY_SQUADS_ABILITY"] = "off_map_arty_single_shot_instant",
	["BOMB_FRIENDLY_ENTITIES_ABILITY"] = "off_map_arty_single_shot_instant",
	["HURT_FRIENDLY_SQUADS_SOUND"] = "speech/mp/soviet/cn2/events/pinned/sb_cn2_pin_gengen_lt_s",
	["BOMB_FRIENDLY_SQUADS_SOUND"] = "speech/mp/aef/ech/events/warning/ab_ech_wrn_astgen_lt_s",
	["INVULNERABLE_PLANES"] = {"il-2_sturmovik_rocket_sp_squad", "paratroopers_plane_paras"},

	["AI_PATHS"] = {
			-- 'real' spawns
			[1] = {
					["spawn_position"] = "AOD_spawn_1",
					["spawn_direction"] = "AOD_spawn_direction_1",
					["path"] = "AOD_path_1"
				},
			[2] = {
					["spawn_position"] = "AOD_spawn_2",
					["spawn_direction"] = "AOD_spawn_direction_2",
					["path"] = "AOD_path_2"
				},
			[3] = {
					["spawn_position"] = "AOD_spawn_3",
					["spawn_direction"] = "AOD_spawn_direction_3",
					["path"] = "AOD_path_3"
				},
			
			-- sneak attacks
			[4] = {
					["spawn_position"] = "AOD_sneak_1",
					["spawn_direction"] = "AOD_sneak_direction_1",
					["entry_point"] = "AOD_sneak_entry_point_1"
				},
			[5] = {
					["spawn_position"] = "AOD_sneak_2",
					["spawn_direction"] = "AOD_sneak_direction_2",
					["entry_point"] = "AOD_sneak_entry_point_2"
				},
			[6] = {
					["spawn_position"] = "AOD_sneak_3",
					["spawn_direction"] = "AOD_sneak_direction_3",
					["entry_point"] = "AOD_sneak_entry_point_3"
				},
				
			-- base attacks
			[7] = {
					["spawn_position"] = "AOD_sneak_base_1",
					["spawn_direction"] = "AOD_sneak_base_direction_1",
					["entry_point"] = "AOD_sneak_base_entry_point_1"
				},
			[8] = {
					["spawn_position"] = "AOD_sneak_base_2",
					["spawn_direction"] = "AOD_sneak_base_direction_2",
					["entry_point"] = "AOD_sneak_base_entry_point_2"
				}
		},
		
	["AI_FAIL_POSITIONS"] = {
			[1] = "AOD_dest_fail"
		},
		
	["DIFFICULTY"] = {
			["starting_resources"] = {
					["manpower"] = {1500, 1500, 1400, 1000},
					["fuel"] = {200, 200, 150, 80},
					["ammo"] = {300, 300, 200, 100},
					["command"] = {10, 10, 5, 0}
				},
			["resource_multipliers"] = {
					["manpower"] = {1.4, 1.4, 1.3, 1.2},
					["fuel"] = {1.4, 1.4, 1.3, 1.2},
					["ammo"] = {1.4, 1.4, 1.3, 1.2},
					["upkeep"] = {0.5, 0.5, 0.5, 0.6}
				},
			["wave"] = {
					["autofire"] = {false, true, true, true},
					["armor"] = {0.9, 1.0, 1.1, 1.2},
					["speed"] = {0.9, 0.9, 1.0, 1.0},
					["veterancy"] = {0, 0, 1, 2},
					["received_suppression"] = {0.7, 0.3, 0, 0},
					["received_damage"] = {1.0, 1.0, 1.0, 0.9},
				},
			["hurt_units_on_route"] = {
					["time_without_damage"] = {3, 3, 3, 2},
					["time_till_max_damage"] = {5, 4, 4, 3},
					["max_damage_per_second"] = {0.1, 0.1, 0.1, 0.15}
				},
			["popcap"] = {250, 225, 200, 150},
			["sight"] = {1.3, 1.2, 1.1, 1.0},
			["experience"] = {0.9, 0.8, 0.8, 0.7},
			["units_allowed_to_pass"] = {31, 21, 11, 0},
			["karma_between_waves"] = {
					["hurt_moving_friendly_squads_on_route"] = {false, false, false, true},
					["hurt_friendly_squads_on_route"] = {false, false, false, true},
					["bomb_friendly_squads_on_route"] = {false, false, false, true}
				}
		},
		
	["WAVE_SETUP"] = {
		[1] = 	{
					["units"] = {
							[1] = {
									["type"] = "assault_officer_squad_mp",
									["amount"] = 2,
									["interval"] = 2,
									["spawns"] = {3},
									["slots"] = {"dp-28_light_machine_gun_package_moving_mp", "grenadier_mg42_lmg_moving_mp"},
									["upgrades"] = {"pioneer_minesweeper_mp"}
								}
						},
							
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0
				},
		[2] = 	{
					["units"] = {
							[1] = {
									["type"] = "pioneer_squad_mp",
									["amount"] = 5,
									["interval"] = 1,
									["spawns"] = {2, 3},
									["slots"] = {"grenadier_mg42_lmg_moving_mp"},
									["upgrades"] = {"pioneer_minesweeper_mp"}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								},
							[2] = {
									["blueprint"] = "railway_gun_artillery_single",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_bunker_bombing_1",
												["direction"] = "AOD_bunker_bombing_direction_1",
												["delay"] = 6
											},
										[2] = {
												["position"] = "AOD_bunker_bombing_4",
												["direction"] = "AOD_bunker_bombing_direction_4",
												["delay"] = 15
											}
									}
								},
							[3] = {
									["blueprint"] = "off_map_arty_single_shot_instant",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_bunker_bombing_1",
												["direction"] = "AOD_bunker_bombing_direction_1",
												["delay"] = 4
											},
										[2] = {
												["position"] = "AOD_bunker_bombing_4",
												["direction"] = "AOD_bunker_bombing_direction_4",
												["delay"] = 13
											}
									}
								}
						}
				},
		[3] = 	{
					["units"] = {
							[1] = {
									["type"] = "volksgrenadier_squad_mp",
									["amount"] = 3,
									["interval"] = 2,
									["spawns"] = {3},
									["slots"] = {"grenadier_mg42_lmg_moving_mp"},
									["upgrades"] = {"pioneer_minesweeper_mp"}
								},
							[2] = {
									["type"] = "assault_pioneer_squad_mp",
									["amount"] = 3,
									["interval"] = 2,
									["spawns"] = {2},
									["delay"] = 0,
									["slots"] = {"grenadier_mg42_lmg_moving_mp"},
									["upgrades"] = {"pioneer_minesweeper_mp"}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0
				},
		[4] = 	{
					["units"] = {
							[1] = {
									["type"] = "sniper_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {2, 3}
								},
							[2] = {
									["type"] = "obersoldaten_squad_mp",
									["amount"] = 4,
									["interval"] = 1.5,
									["spawns"] = {2, 3}
								},
							[3] = {
									["type"] = "ostruppen_squad_mp",
									["amount"] = 4,
									["interval"] = 2,
									["spawns"] = {1},
									["delay"] = 0
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "railway_gun_artillery_single",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_bunker_bombing_2",
												["direction"] = "AOD_bunker_bombing_direction_2",
												["delay"] = 14
											},
										[2] = {
												["position"] = "AOD_bunker_bombing_3",
												["direction"] = "AOD_bunker_bombing_direction_3",
												["delay"] = 21
											}
									}
								},
							[2] = {
									["blueprint"] = "off_map_arty_single_shot_instant",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_bunker_bombing_2",
												["direction"] = "AOD_bunker_bombing_direction_2",
												["delay"] = 12
											},
										[2] = {
												["position"] = "AOD_bunker_bombing_3",
												["direction"] = "AOD_bunker_bombing_direction_3",
												["delay"] = 19
											}
									}
								}
						}
				},
		[5] = 	{
					["units"] = {
							[1] = {
									["type"] = "panzer_grenadier_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {1, 2}
								},
							[2] = {
									["type"] = "stormtrooper_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {3},
									["delay"] = 0
								},
							[3] = {
									["type"] = "kubelwagen_squad_mp",
									["amount"] = 4,
									["interval"] = 2,
									["spawns"] = {3},
									["delay"] = 17
								},
							[4] = {
									["type"] = "mortar_team_81mm_mp",
									["amount"] = 1,
									["spawns"] = {4},
									["delay"] = 0
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["bomb_friendly_entities_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								}
						},
					["message_when_starting"] = {
							["title"] = "Bombing defences on the road",
							["fadein"] = 1.0,
							["fadeout"] = 1.0,
							["lifetime"] = 5.0,
							["type"] = "missionTitle"
						}
				},
		[6] = 	{
					["units"] = {
							[1] = {
									["type"] = "jaeger_light_infantry_recon_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {2, 3}
								},
							[2] = {
									["type"] = "panzerfusilier_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1},
									["delay"] = 0
								},
							[3] = {
									["type"] = "kubelwagen_squad_mp",
									["amount"] = 3,
									["interval"] = 5,
									["spawns"] = {3},
									["delay"] = 18,
									["modifiers"] = {
											["received_damage"] = {0.2, 0.2, 0.2, 0.2},
											["speed"] = {0.5, 0.5, 0.5, 0.5},
											["veterancy"] = {1, 1, 1, 1}
										}
								},
							[4] = {
									["type"] = "sniper_squad_mp",
									["amount"] = 2,
									["interval"] = 3,
									["spawns"] = {5, 6},
									["delay"] = 0
								},
							[5] = {
									["type"] = "mg42_heavy_machine_gun_squad_mp",
									["amount"] = 1,
									["spawns"] = {4, 5},
									["delay"] = 0
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true
				},
		[7] = 	{
					["units"] = {
							[1] = {
									["type"] = "urban_assault_light_infantry",
									["amount"] = 5,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[2] = {
									["type"] = "fallschirmjager_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[3] = {
									["type"] = "scoutcar_sdkfz222_mp",
									["amount"] = 4,
									["interval"] = 4,
									["spawns"] = {2, 3},
									["upgrades"] = {"sdkfz_222_20mm_gun_mp"},
									["delay"] = 24
								},
							[4] = {
									["type"] = "raketenwerfer43_88mm_puppchen_antitank_gun_squad_mp",
									["amount"] = 1,
									["spawns"] = {4, 5, 6},
									["delay"] = 5
								},
							[5] = {
									["type"] = "assault_pioneer_squad_mp",
									["amount"] = 1,
									["spawns"] = {4, 5, 6},
									["delay"] = 8,
									["upgrades"] = {"pioneer_minesweeper_mp"}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 20.0,
					["kill_friendly_entities_on_route"] = true
				},
		[8] = 	{
					["units"] = {
							[1] = {
									["type"] = "obersoldaten_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {2, 3}
								},
							[2] = {
									["type"] = "ostruppen_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {2, 3}
								},
							[3] = {
									["type"] = "assault_grenadier_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1},
									["delay"] = 0
								},
							[4] = {
									["type"] = "sdkfz_251_halftrack_squad_mp",
									["amount"] = 4,
									["interval"] = 3,
									["spawns"] = {1, 2},
									["upgrades"] = {"sdkfz_251_halftrack_flammpanzerwagen_upgrade_mp"},
									["delay"] = 23
								},
							[5] = {
									["type"] = "pak40_75mm_at_gun_squad_mp",
									["amount"] = 2,
									["interval"] = 3,
									["spawns"] = {5, 6},
									["delay"] = 23
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["bomb_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								}
						},
					["message_when_starting"] = {
							["title"] = "Units idling on the road will take damage!",
							["type"] = "missionTitle"
						}
				},
		[9] = 	{
					["units"] = {
							[1] = {
									["type"] = "stormtrooper_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1}
								},
							[2] = {
									["type"] = "sniper_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {2},
									["delay"] = 0
								},
							[3] = {
									["type"] = "panzerfusilier_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {3},
									["delay"] = 0
								},
							[4] = {
									["type"] = "puma_east_german_mp",
									["amount"] = 5,
									["interval"] = 4,
									["spawns"] = {1, 2, 3},
									["delay"] = 19
								},
							[5] = {
									["type"] = "pak40_75mm_at_gun_squad_mp",
									["amount"] = 1,
									["spawns"] = {7, 8},
									["delay"] = 19
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "stuka_smoke_bomb",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_event_bombing9",
												["direction"] = "AOD_event_bombing_dir9",
												["delay"] = 1
											},
										[2] = {
												["position"] = "AOD_event_bombing10",
												["direction"] = "AOD_event_bombing_dir10",
												["delay"] = 2
											},
										[3] = {
												["position"] = "AOD_event_bombing6",
												["direction"] = "AOD_event_bombing_dir6",
												["delay"] = 3
											}
									}
								}
						}
				},
		[10] = 	{
					["units"] = {
							[1] = {
									["type"] = "panzerfusilier_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[2] = {
									["type"] = "obersoldaten_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[2] = {
									["type"] = "ostruppen_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[3] = {
									["type"] = "ostwind_squad_westgerman_mp",
									["amount"] = 4,
									["interval"] = 3,
									["spawns"] = {1, 2, 3},
									["delay"] = 19
								},
							[4] = {
									["type"] = "puma_east_german_mp",
									["amount"] = 2,
									["interval"] = 0.5,
									["spawns"] = {5, 6},
									["delay"] = 8
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								}
						}
				},
		[11] = 	{
					["units"] = {
							[1] = {
									["type"] = "grenadier_squad_mg42lmg_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {1},
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[2] = {
									["type"] = "stormtrooper_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {2},
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[3] = {
									["type"] = "panzer_grenadier_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {3},
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[4] = {
									["type"] = "command_king_tiger_squad_mp",
									["amount"] = 2,
									["interval"] = 3,
									["spawns"] = {3},
									["modifiers"] = {
											["speed"] = {0.7, 0.7, 0.7, 0.7}
										},
									["delay"] = 16
								},
							[5] = {
									["type"] = "command_king_tiger_squad_mp",
									["amount"] = 1,
									["interval"] = 3,
									["spawns"] = {3},
									["modifiers"] = {
											["received_damage"] = {0.2, 0.2, 0.2, 0.2},
											["speed"] = {0.7, 0.7, 0.7, 0.7},
											["veterancy"] = {3, 3, 3, 3}
										},
									["delay"] = 22
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "stuka_smoke_bomb",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_event_bombing9",
												["direction"] = "AOD_event_bombing_dir9",
												["delay"] = 1
											},
										[2] = {
												["position"] = "AOD_event_bombing10",
												["direction"] = "AOD_event_bombing_dir10",
												["delay"] = 2
											},
										[3] = {
												["position"] = "AOD_event_bombing6",
												["direction"] = "AOD_event_bombing_dir6",
												["delay"] = 3
											},
										[4] = {
												["position"] = "AOD_event_bombing1",
												["direction"] = "AOD_event_bombing_dir1",
												["delay"] = 8
											},
										[5] = {
												["position"] = "AOD_event_bombing3",
												["direction"] = "AOD_event_bombing_dir3",
												["delay"] = 9
											}
									}
								}
						}
				},
		[12] = 	{
					["units"] = {
							[1] = {
									["type"] = "panzerfusilier_squad_mp",
									["amount"] = 4,
									["interval"] = 0.5,
									["spawns"] = {1, 2},
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[2] = {
									["type"] = "stormtrooper_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {3},
									["delay"] = 0,
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[3] = {
									["type"] = "ostruppen_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2},
									["wait_for_wave"] = 1,
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[4] = {
									["type"] = "urban_assault_panzer_grenadier_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {3},
									["wait_for_wave"] = 2,
									["modifiers"] = {
											["received_damage"] = {0.8, 0.8, 0.8, 0.8}
										}
								},
							[5] = {
									["type"] = "panzer_iv_ausf_j_battle_group_mp",
									["amount"] = 5,
									["interval"] = 3,
									["spawns"] = {1, 2},
									["wait_for_wave"] = 3,
									["delay"] = 10
								},
							[6] = {
									["type"] = "tiger_squad_mp",
									["amount"] = 4,
									["interval"] = 4,
									["spawns"] = {3},
									["wait_for_wave"] = 4,
									["delay"] = 13
								},
							[7] = {
									["type"] = "mortar_250_halftrack_squad_westgerman_mp",
									["amount"] = 1,
									["interval"] = 4,
									["spawns"] = {4, 5, 6, 7, 8},
									["delay"] = 20
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 10.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								}
						}
				},
		[13] = 	{
					["units"] = {
							[1] = {
									["type"] = "obersoldaten_squad_mp",
									["amount"] = 5,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.7, 0.7, 0.7, 0.7}
										}
								},
							[2] = {
									["type"] = "fallschirmjager_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.7, 0.7, 0.7, 0.7}
										}
								},
							[3] = {
									["type"] = "assault_grenadier_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.7, 0.7, 0.7, 0.7}
										}
								},
							[4] = {
									["type"] = "panther_commander_squad_mp",
									["amount"] = 6,
									["interval"] = 3,
									["spawns"] = {1, 2, 3}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 20.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true
				},
		[14] = 	{
					["units"] = {
							[1] = {
									["type"] = "stormtrooper_squad_mp",
									["amount"] = 4,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.7, 0.7, 0.7, 0.7}
										}
								},
							[2] = {
									["type"] = "sniper_squad_mp",
									["amount"] = 6,
									["interval"] = 0.5,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.7, 0.7, 0.7, 0.7}
										}
								},
							[3] = {
									["type"] = "pioneer_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.3, 0.3, 0.3, 0.3}
										}
								},
							[4] = {
									["type"] = "kubelwagen_squad_mp",
									["amount"] = 8,
									["interval"] = 0.5,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.5, 0.5, 0.5, 0.5},
											["speed"] = 0.8
										}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "stuka_smoke_bomb",
									["type"] = "markers",
									["locations"] = 
									{
										[1] = {
												["position"] = "AOD_event_bombing9",
												["direction"] = "AOD_event_bombing_dir9",
												["delay"] = 3
											},
										[2] = {
												["position"] = "AOD_event_bombing10",
												["direction"] = "AOD_event_bombing_dir10",
												["delay"] = 6
											},
										[3] = {
												["position"] = "AOD_event_bombing6",
												["direction"] = "AOD_event_bombing_dir6",
												["delay"] = 4
											},
										[4] = {
												["position"] = "AOD_event_bombing1",
												["direction"] = "AOD_event_bombing_dir1",
												["delay"] = 12
											},
										[5] = {
												["position"] = "AOD_event_bombing3",
												["direction"] = "AOD_event_bombing_dir3",
												["delay"] = 15
											}
									}
								}
						}
				},
		[15] = 	{
					["units"] = {
							[1] = {
									["type"] = "panzer_grenadier_squad_mp",
									["amount"] = 5,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.6, 0.6, 0.6, 0.6}
										}
								},
							[2] = {
									["type"] = "officer_squad_mp",
									["amount"] = 1,
									["modifiers"] = {
											["received_damage"] = {0.1, 0.1, 0.1, 0.1},
											["veterancy"] = {3, 3, 3, 3}
										},
									["spawns"] = {1, 2, 3}
								},
							[3] = {
									["type"] = "obersoldaten_squad_mp",
									["amount"] = 3,
									["interval"] = 1,
									["spawns"] = {1, 2, 3},
									["modifiers"] = {
											["received_damage"] = {0.6, 0.6, 0.6, 0.6}
										}
								},
							[4] = {
									["type"] = "king_tiger_squad_mp",
									["amount"] = 8,
									["interval"] = 2,
									["spawns"] = {3},
									["delay"] = 18
								},
							[5] = {
									["type"] = "opel_blitz_supply_squad",
									["amount"] = 12,
									["interval"] = 1,
									["spawns"] = {1, 2},
									["delay"] = 24
								},
							[6] = {
									["type"] = "ostwind_squad_westgerman_mp",
									["amount"] = 1,
									["interval"] = 1,
									["spawns"] = {7, 8},
									["delay"] = 10
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 10.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true,
					["event_when_starting"] = {
							[1] = {
									["blueprint"] = "paratroopers_paradrop",
									["type"] = "paradrop_near_random_objective"
								}
						}
				},
		[16] = 	{
					["units"] = {
							[1] = {
									["type"] = "brummbar_squad_mp",
									["amount"] = 1,
									["modifiers"] = {
											["received_damage"] = {0.05, 0.05, 0.05, 0.05},
											["speed"] = {0.6, 0.6, 0.6, 0.6},
											["veteramcy"] = {3, 3, 3, 3}
										},
									["spawns"] = {3}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 30.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true
				},
		[17] = 	{
					["units"] = {
							[1] = {
									["type"] = "ostwind_squad_westgerman_mp",
									["amount"] = 10,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[2] = {
									["type"] = "panzer_iv_ausf_j_battle_group_mp",
									["amount"] = 10,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[3] = {
									["type"] = "puma_east_german_mp",
									["amount"] = 5,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								},
							[4] = {
									["type"] = "tiger_ace_squad_mp",
									["amount"] = 10,
									["interval"] = 2,
									["spawns"] = {1, 2, 3}
								},
							[5] = {
									["type"] = "kubelwagen_squad_mp",
									["amount"] = 30,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 15.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true
				},
		[18] = 	{
					["units"] = {
							[1] = {
									["type"] = "command_king_tiger_squad_mp",
									["amount"] = 15,
									["interval"] = 1,
									["spawns"] = {1, 2, 3}
								}
						},
					["wait_until_everybody_dead"] = true,
					["delay_after_wave"] = 30.0,
					["kill_friendly_entities_on_route"] = true,
					["hurt_friendly_squads_on_route"] = true
				},
		}
	}


-- init

function OnInit()
	AOD_Setup(SETUP)
	AOD_OnOnit()
	
	EGroup_SetAnimatorState(AOD_lights, "Light_State", "On")
	EGroup_SetAnimatorState(AOD_lights, "Light", "On")
end

function ShowWelcomeMessage(VERSION, PLAYER_COUNT)
	local messageTitle = Util_CreateLocString("AOD_Kholodny 0.1 (AOD " .. VERSION .. ") - player count: " .. (PLAYER_COUNT - 1))
	local messageBody1 = Util_CreateLocString("Prevent the enemy from reaching the other end of the map")
	local messageBody2 = Util_CreateLocString("")
	
	Game_SubTextFade(messageTitle, messageBody1, messageBody2, 0.5, 4.0, 1.5)
end

function OnFaultyInit()
	local messageTitle = LOC("ERROR")
	messageTitle[1] = "ERROR"
	local messageBody1 = LOC("Make sure that you are running this level with the official Art of Defence mod enabled")
	messageBody1[1] = "Make sure that you are running this level with the official Art of Defence mod enabled"
	local messageBody2 = LOC("")
	messageBody2[1] = ""
	
	Game_SubTextFade(messageTitle, messageBody1, messageBody2, 0.5, 20.0, 1.5)
end

if pcall(function() import("winconditions/aod.scar") end) then
	Scar_AddInit(OnInit)
else
	Scar_AddInit(OnFaultyInit)
end
