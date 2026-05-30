--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% BY: DREDNOUT_571 %%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OnInit()
	World_SetIceHealingRate( 1 )
	blizz_def_atm = "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_a.aps"
	blizz_trans_atm = "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_b.aps"
	blizz_atm = "data:art/scenarios/presets/atmosphere/_mp_frozen_scrum_b.aps"
	MP_BlizzardInit( blizz_atm, blizz_def_atm, false, blizzardtable , true, blizz_trans_atm )
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("allow_building_campfires")) -- Allow building campfires in this cold weather map
		Player_SetHeatLossRate(player, 1.1)
		Player_SetHeatGainRate(player, 0.9)
	end
	Rule_AddInterval( Temp_Update, 1, 700 )
end

function Temp_Update()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetHeatLossRate(player, 1.1)
		Player_SetHeatGainRate(player, 0.9)
	end
end

Scar_AddInit( OnInit )