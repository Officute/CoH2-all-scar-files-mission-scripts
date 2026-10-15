import("winconditions/victorypointplusannihilate.scar")

local function PopCap_OnInit()
	Camera_SetTuningValue(TV_DistMax, 55)
	Camera_ResetToDefault()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetPopCapOverride(player, 100)
		Modify_PlayerResourceRate(player, RT_Manpower, 1.0, MUT_Multiplication)
		Modify_PlayerResourceRate(player, RT_Munition, 1.0, MUT_Multiplication)
		Modify_PlayerResourceRate(player, RT_Fuel, 1.0, MUT_Multiplication)
	end
end

Scar_AddInit(PopCap_OnInit)