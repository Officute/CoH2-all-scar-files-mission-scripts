
t_coldSquads = { }
t_heatSources = { }
local coldSquad_id = 0
local heatSource_id = 0

local ManageUnits = function()
	
	local sg_temp = SGroup_CreateIfNotFound("sg_temp")
	
	Player_GetAll(player1, sg_temp)
	SGroup_RemoveGroup(sg_temp, _coldWeather_squads)
	SGroup_RemoveGroup(sg_temp, _coldWeather_heatSources)
	
	local _sortSquads = function(gid, idx, sid)
		if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
			-- Entity is a vehicle, add to the heatSources
			SGroup_Remove(sg_temp, sid)
			
			heatSource_id = heatSource_id + 1
			
			local table_a = { }
			table_a.id = SGroup_CreateIfNotFound("_coldWeather_heatSource_"..heatSource_id)
			SGroup_Add(_coldWeather_heatSources, sid)
			table_a.enabled = true
			table_a.radius = 10
			
			table.insert(t_heatSources, sid)
		else
			coldSquad_id = coldSquad_id + 1
			
			local table_a = { }
			table_a.id = SGroup_CreateIfNotFound("_coldWeather_squad_"..coldSquad_id)
			SGroup_Add(table_a.id, sid)
			SGroup_Add(_coldWeather_squads, sid)
			table_a.currState = -1
			table_a.tmr_id = "_coldWeather_timer_squad_"..coldSquad_id
			table_a.tmr = 0
			table_a.hp = nil
			table_a.visibleMod = nil
			
			table.insert(t_coldSquads, table_a)
		end
	end
	
	SGroup_ForEach(sg_temp, _sortSquads)
	
end



















local SetupWeather = function()
	
	_coldWeather_squads = SGroup_CreateIfNotFound("_coldWeather_squads")
	_coldWeather_heatSources = SGroup_CreateIfNotFound("_coldWeather_heatSources")
	
	Rule_Add(ManageUnits)

end

Scar_AddInit(SetupWeather)
