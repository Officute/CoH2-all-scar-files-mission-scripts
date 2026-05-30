--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% BY: DREDNOUT_571 %%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/VPTickerWin-Annihilate_Functions.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")
import("WinConditions/Annihilate.scar")
import("Systems/BlizzardMulitplayer.scar")
import("WinConditions/_forcewin.scar")
import("WinConditions/_coldnight.scar")
import("WinConditions/_camera.scar")
import("Timer.scar")

SetGlobals()

Scar_AddInit( VPTicker_OnInit )

function OnInit()
	Game_SubTextFade("Heavy Support By: DREDNOUT_571" ,"","Special for NoMercy wincondition Pack", 1, 10, 1) 

	obj_HeavySupport = {
	
		SetupUI = function() 
			--Objective_StartTimer(obj_HeavySupport, COUNT_DOWN, g_GameTime)
		end,
		
		OnStart = function()
		end,
		
		OnComplete = function()
		end,
		
		OnFail = function()
		end,
		
		Title = "Time to reinforcements:", --Util_CreateLocString("Time to reinforcements:"),
		Description = 0,
		Type = OT_Primary,
	}
		
	Objective_Register(obj_HeavySupport)
	Objective_Start(obj_HeavySupport, true) --boolean показать заголовок

	g_GameTime = 1200 --1200=20 мин
	g_TimeLeft = 1
	Timer_Start(g_TimeLeft, g_GameTime)
	Rule_Add( Timer_Update, 600 ) --обновляется таймер каждый кадр
end

Scar_AddInit( OnInit )

function Timer_Update()
	local seconds = math.floor(Timer_GetRemaining(g_TimeLeft))
	Objective_UpdateText(obj_HeavySupport, "Time to reinforcements: "..math.floor(seconds/60)..":"..math.floor((seconds % 60) / 10)..(seconds % 60) - math.floor((seconds % 60) / 10) * 10, nil, false)

	if Timer_GetRemaining(g_TimeLeft) < 1 then
		if Rule_Exists( HeavySupport_Spawn ) == false then
			Rule_AddOneShot( HeavySupport_Spawn, 1, 600 ) --подкрепление вызывается
			Rule_AddInterval( HeavySupport_Check, 1, 600 ) --подкрепление проверка на непустоту
			Rule_RemoveIfExist( Timer_Update ) --ремувает себя
		end
	end
end


function HeavySupport_Spawn()
--двумерный массив с юнитами
local l_type = {
	   l_subtype1 = {
				t1 = BP_GetSquadBlueprint("m26_pershing_mp"),
				t2 = BP_GetSquadBlueprint("churchill_avre_squad_mp"),
				t3 = BP_GetSquadBlueprint("churchill_crocodile_mp"),
				t4 = BP_GetSquadBlueprint("churchill_default_squad_mp"),
				t5 = BP_GetSquadBlueprint("comet_tank_squad_mp"),
				t6 = BP_GetSquadBlueprint("elefant_tank_destroyer_squad_mp"),
				t7 = BP_GetSquadBlueprint("tiger_ace_squad_mp"),
				t8 = BP_GetSquadBlueprint("is-2_mp"),
				t9 = BP_GetSquadBlueprint("isu-152_mp"),
				t10 = BP_GetSquadBlueprint("kv-1_commander_mp"),
				t11 = BP_GetSquadBlueprint("kv-2_mp"),
				t12 = BP_GetSquadBlueprint("kv-8_mp"),
				t13 = BP_GetSquadBlueprint("m3a1_scout_car_squad_mp"),
				t14 = BP_GetSquadBlueprint("jagdtiger_td_squad_mp"),
				t15 = BP_GetSquadBlueprint("command_king_tiger_squad_mp"),
				t16 = BP_GetSquadBlueprint("kubelwagen_squad_mp"),
				t17 = BP_GetSquadBlueprint("opel_blitz_squad_mp"),
				t18 = BP_GetSquadBlueprint("panther_commander_squad_mp"),
				t19 = BP_GetSquadBlueprint("sturmtiger_squad_mp"),
			},
	   l_subtype2 = {
				s1 = BP_GetSquadBlueprint("kv-2_mp"), --просто пример двумерного массива
			},
	}

	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		--выбираем случайный элемент для каждого плайера
   		 local l_support = Table_GetRandomItem({
			l_type.l_subtype1.t1,
			l_type.l_subtype1.t2,
			l_type.l_subtype1.t3,
			l_type.l_subtype1.t4,
			l_type.l_subtype1.t5,
			l_type.l_subtype1.t6,
			l_type.l_subtype1.t7,
			l_type.l_subtype1.t8,
			l_type.l_subtype1.t9,
			l_type.l_subtype1.t10,
			l_type.l_subtype1.t11,
			l_type.l_subtype1.t12,
			l_type.l_subtype1.t13,
			l_type.l_subtype1.t14,
			l_type.l_subtype1.t15,
			l_type.l_subtype1.t16,
			l_type.l_subtype1.t17,
			l_type.l_subtype1.t18,
			l_type.l_subtype1.t19,
   		})
		SGroup_CreateIfNotFound( "sg_heavysupport"..i ) 
		if SGroup_Exists( "sg_heavysupport"..i ) == true then
			if SGroup_IsEmpty( "sg_heavysupport"..i ) == true then
				Util_CreateSquads (player, "sg_heavysupport"..i, l_support, Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), 1) --major_squad_mpBP_GetSquadBlueprint(l_support)
				Objective_Complete(obj_HeavySupport, true) --цель достигнута булеан - показывать анимацию завершения
			end
		end
	end
end

function HeavySupport_Check()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if SGroup_Exists( "sg_heavysupport"..i ) == true then
			if SGroup_IsEmpty( "sg_heavysupport"..i ) == true then
				--Modify_PlayerResourceRate( player, RT_Manpower, 0.91 )
				Player_SetPopCapOverride( player, 100 )
			else
				--Modify_PlayerResourceRate( player, RT_Manpower, 1.1 )
				Player_SetPopCapOverride( player, 115 )
			end
		end

	end
end

--Определение позиции. Взято из Last Tiger, будет переписано позже

function TLT_GetClosestEntryPoint(player)

	--[[local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entries")

	local _sg_temp = SGroup_CreateIfNotFound("_sg_temp")
	local _eg_all = EGroup_CreateIfNotFound("_eg_all")
	
	for i = 1, World_GetPlayerCount() do
	
		local _player = World_GetPlayerAt(i)
	
		Player_GetAll(_player, _sg_temp, _eg_all)
		EGroup_Filter(_eg_all, BP_GetEntityBlueprint("map_entry_point"), FILTER_KEEP)
		
		EGroup_AddEGroup(eg_all_entry_points, _eg_all)
		
	end
	
	local c = EGroup_CountSpawned(eg_all_entry_points)
	local allEntryPoints = {}
	
	for i = 1, c do
		
		local _entry_point = EGroup_GetSpawnedEntityAt(eg_all_entry_points, i)
		
		allEntryPoints["entryPoint"..i] = _entry_point
		
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), allEntryPoints) ~= nil then
		Util_MissionTitle(Util_CreateLocString("Successfully found entry point for player '"..Player_GetID(player).."'"))
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), allEntryPoints))
	else	
		--print("Unable to find an entry point for player "..Player_GetID(player)..", using starting position instead")
		fatal("Unable to find entry point for player '"..Player_GetID(player).."'")
		return Player_GetStartingPosition(player)
	end ]]
	
	local eg_all_entry_points = EGroup_CreateIfNotFound("eg_all_entry_points")
	local sg_temp = SGroup_CreateIfNotFound("sg_temp")
	local t = {}
	
	for i = 1, World_GetPlayerCount() do
		local p = World_GetPlayerAt(i)
		
		if Player_GetTeam(p) == Player_GetTeam(player) then
			EGroup_AddEGroup(eg_all_entry_points, Player_GetEntities(p))
		end
	end
	for i = 1, EGroup_Count(eg_all_entry_points) do
		local e = EGroup_GetSpawnedEntityAt(eg_all_entry_points, i)
		if Entity_GetBlueprint(e) == BP_GetEntityBlueprint("map_entry_point") then
			t[#t+1] = e
		end
	end
	
	if World_GetClosest(Player_GetStartingPosition(player), t) ~= nil then 
		return Util_GetPosition(World_GetClosest(Player_GetStartingPosition(player), t))
	else
		fatal("Unable to get entry point for player '"..Player_GetDisplayName(player).."' ("..player..")!!!")
		return Player_GetStartingPosition(player)
	end
end
--]]
