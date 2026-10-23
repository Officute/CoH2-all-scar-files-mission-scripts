import("winconditions/annihilate.scar")

local NHC_MOD_GUID = "97127c821f624593a1a70d59cdc4f4cc:"

-- Upgrades that get +25% production speed via the upgrade modifier.
local t_ProductionSpeedUpgrades = {
	NHC_MOD_GUID .. "battle_phase_1_aef",
	NHC_MOD_GUID .. "battle_phase_2_aef",
	NHC_MOD_GUID .. "battle_phase_3_aef",
	NHC_MOD_GUID .. "soviet_battle_phase_1",
	NHC_MOD_GUID .. "soviet_battle_phase_2",
	NHC_MOD_GUID .. "soviet_battle_phase_3",
	NHC_MOD_GUID .. "west_german_battle_phase_1",
	NHC_MOD_GUID .. "west_german_battle_phase_2",
	NHC_MOD_GUID .. "west_german_battle_phase_3",
	"battle_phase_2_mp",
	"battle_phase_3_mp",
	"battle_phase_4_mp",
}

-- British HQ entities that get +25% production speed via the entity (cost ticks) modifier.
local t_ProductionSpeedEntities = {
	NHC_MOD_GUID .. "british_hq2",
	NHC_MOD_GUID .. "british_hq3",
}

local function Resources_OnInit()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetResource(player, RT_Manpower, 3500)
		Player_SetResource(player, RT_Munition, 600)
		Player_SetResource(player, RT_Fuel, 350)

		-- +25% production speed for the listed upgrades (upgrade modifier).
		for k = 1, table.getn(t_ProductionSpeedUpgrades) do
			Modify_UpgradeBuildTime(player, t_ProductionSpeedUpgrades[k], 0.85)
		end

		-- +25% production speed for the British HQ entities (entity/cost ticks modifier).
		for k = 1, table.getn(t_ProductionSpeedEntities) do
			Modify_EntityBuildTime(player, t_ProductionSpeedEntities[k], 0.85)
		end
	end
end

Scar_AddInit(Resources_OnInit)