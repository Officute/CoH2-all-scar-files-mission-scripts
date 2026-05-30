--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% BY: DREDNOUT_571 %%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function OnInit()
	g_DaynightCycle = 480 --полный цикл 20 мин (480+480+240). В оригинальной миссии ТВД день и ночь идут по 5 минут, но этого слишком мало
	g_DaynightTrans = g_DaynightCycle/2 -- время смены днян а ночь
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_CompleteUpgrade(player, BP_GetUpgradeBlueprint("allow_building_campfires")) -- Возможность строить костры всем игрокам
	end
	Rule_AddOneShot(StartTransitionToNight, g_DaynightCycle) --старт первой смены дня на ночь
end

Scar_AddInit( OnInit )

--Взято из миссии ТВД Ржев
function StartTransitionToNight()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_tow_brody_night.aps", g_DaynightTrans)
	Rule_AddOneShot(StartTransitionToDay, g_DaynightCycle)
	Rule_AddOneShot(SetTempToNight, g_DaynightTrans/2)
end

function SetTempToDay()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetHeatLossRate(player, 0)
		Player_SetHeatGainRate(player, 1.5)
		Modify_PlayerSightRadius( player, 1.25 ) --радиус обзора назад
	end
end

function StartTransitionToDay()
	Game_LoadAtmosphere("data:art/scenarios/presets/atmosphere/_tow_brody_day.aps", g_DaynightTrans)
	Rule_AddOneShot(StartTransitionToNight, g_DaynightCycle)
	Rule_AddOneShot(SetTempToDay, g_DaynightTrans/2)
end

function SetTempToNight()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetHeatLossRate(player, 1)
		Player_SetHeatGainRate(player, 0.9)
		Modify_PlayerSightRadius( player, 0.8 ) --радиус обзора уменьшен
	end
end
