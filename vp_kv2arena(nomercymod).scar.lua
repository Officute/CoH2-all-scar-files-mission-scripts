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
	Game_SubTextFade("KV-2 Arena By: DREDNOUT_571" ,"Special for NoMercy wincondition Pack","Destroyed KV-2s will be replaced every 10 minutes.", 1, 16, 1) --
	g_respawns = {} --объявляем пустой массив для определения числа респаунов
	for i = 1, World_GetPlayerCount() do
		g_respawns[i] = 3 --заполняем массив на длину игроков [i] номер элемена массива будет = 5, такой вид по заполнению: g_respawns = {5,5,5,5,5,5,5,5} 
	end

--массив с юнитами
l_type = {
	   l_subtype1 = {
				t1 = BP_GetSquadBlueprint("major_squad_mp"),
				t2 = BP_GetSquadBlueprint("major_squad_mp"),
				t3 = BP_GetSquadBlueprint("major_squad_mp"),
			},
	   l_subtype2 = {
				s1 = BP_GetSquadBlueprint("kv-2_mp"),
				s2 = BP_GetSquadBlueprint("kv-2_mp"),
			},
	}
	g_supportinterval = 10 -- интервал подкреплений (общий)
	Rule_AddOneShot( timer_initial, 1, 600 ) --таймер до прибытия
	Rule_AddInterval( kv2_message, 10, 400 ) --запускаем функцию, которая каждые 10 секунд будет писать эвент над КВшкой, с оставшимся числом респаунов
	Rule_AddInterval( kv2_check, 1, 700 ) -- проверяем, есть ли у игроков ещё респауны


	print("Initializing Main Objective...")	
	obj_Tiger = {
	
		SetupUI = function() 
			--Objective_StartTimer(obj_Tiger, COUNT_DOWN, g_GameTime)
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
		
	Objective_Register(obj_Tiger)
	Objective_Start(obj_Tiger, true) --boolean показать заголовок
	Rule_Add( timer_update2, 600 ) --обновляется таймер2

	g_GameTime = 1200
	g_TimeLeft = 1
	Timer_Start(g_TimeLeft, g_GameTime)
end

function timer_update2()
	local seconds = math.floor(Timer_GetRemaining(g_TimeLeft))
	Objective_UpdateText(obj_Tiger, "Time to reinforcements: "..math.floor(seconds/60)..":"..math.floor((seconds % 60) / 10)..(seconds % 60) - math.floor((seconds % 60) / 10) * 10, nil, false)
end

function timer_initial()

		local data = {}
		data.time = g_supportinterval
		data.text = "Support deploy(if dead)"
		data.maxtime = g_supportinterval
		
		Event_Timer(Support_timer, data, 1)
end

function Support_timer(data)
	if data.time > 0 then
		data.time = data.time - 1
		local prog = data.time / data.maxtime
		Obj_ShowProgress(data.text, prog)
		--Obj_ShowProgressTimer("Support deploy(if dead):", prog)
		Event_Timer(Support_timer, data, 1)
	elseif data.time == 0 then --по истесению таймера вызывается
		--MidTransitionPoint(data)
		Rule_AddOneShot( timer_initial, 1, 600 ) --обновляется таймер
		Rule_AddOneShot( kv2_spawn, 1, 600 ) --подкрепление вызывается
	end
end


Scar_AddInit( OnInit )

function kv2_spawn()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		--выбираем случайный элемент для каждого плайера
   		 local l_support = Table_GetRandomItem({
			l_type.l_subtype1.t1,
			l_type.l_subtype1.t2,
			l_type.l_subtype1.t3,
       			l_type.l_subtype2.s1,
			l_type.l_subtype2.s2,
   		})
		SGroup_CreateIfNotFound( "sg_kv2"..i ) --sg_kv2 = 
		if SGroup_Exists( "sg_kv2"..i ) == true then
			if SGroup_IsEmpty( "sg_kv2"..i ) == true then
				if g_respawns[i] > 0 then
					Util_CreateSquads (player, "sg_kv2"..i, l_support, Util_GetRandomPosition(TLT_GetClosestEntryPoint(player), 20), Player_GetStartingPosition(player), 1) --major_squad_mpBP_GetSquadBlueprint(l_support)
					g_respawns[i] = g_respawns[i] - 1 --минусуем респаун при возрождении
				end
			end
		end
	end
end

function kv2_message()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if SGroup_Exists( "sg_kv2"..i ) == true then
			if SGroup_IsEmpty( "sg_kv2"..i ) == false then --группа не пуста
				SGroup_CreateKickerMessage( "sg_kv2"..i, player, "Respawns :"..g_respawns[i] ) --меседж белым текстом над сквадгруппой. сквадгруппа не должна быть пуста
				--UI_CreateSGroupKickerMessage( player, "sg_kv2"..i, "Respawns :"..g_respawns[i] ) --не работает
				--HintPoint_Add("sg_kv2"..i, true, "Respawns :"..g_respawns[i], 3, HPAT_Hint)
			end
		end
	end
end

function kv2_check()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		if SGroup_Exists( "sg_kv2"..i ) == true then
			if SGroup_IsEmpty( "sg_kv2"..i ) == true then --группа не пуста
				if g_respawns[i] < 1 then
					World_SetPlayerLose( player ) -- нет респаунов, объявляем проигравшим игрока и его команду
				end
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
