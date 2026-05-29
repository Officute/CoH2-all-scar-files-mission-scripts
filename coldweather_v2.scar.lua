
import("ScarUtil.scar")

-- my Lua version of a unique ID generator
function __OpUtil_LuaID()
	if _Op.LuaID == nil then 
		_Op.LuaID = 0 
	else
		_Op.LuaID = _Op.LuaID+1 
	end
	local id = World_GetGameTime() 
	id = math.floor(id)-- takes a real and returns integer
	return id.."_".._Op.LuaID 
end

	-- States	
	-- 1 = warming up
	-- 0 = warm
	--	[Snowing - 35 seconds | Blizzard - 45 seconds | Clearing up - 45 seconds]
	-- 1 = cooling off, no warning
	--	[Snowing - 3 minutes | Blizzard - 2 minute | Clearing up - 3 minutes]
	-- 2 = Cold, static warning
	--	[
	-- 3 = Starting to Freeze, count down
	-- 4 = Dieing, static warning

--~ t_cold_squads = {}
--~ t_cold_playerRestrictions = {}
--~ t_heat_sources = Marker_GetTable("mkr_heat%02d")
--~ t_heat_sources = {}
--~ t_condemned = {}
--~ t_molotov = {}
--~ t_coldPlayerTable = {}
local coldSquad_id = 0
local heatSource_id = 0

coldWeather = {}

coldWeather.r_marker = nil
coldWeather.r_egroup = nil

function ColdWeather_ManageUnits()
	
	local sg_temp = SGroup_CreateIfNotFound("sg_temp")
	
	local _filterVehicles = function(gid, idx, sid)
		if Entity_IsVehicle(Squad_EntityAt(sid, 0)) then
			SGroup_Add(sg_heat_vehicles, sid)
			local vehicleSgroup = SGroup_CreateIfNotFound("sg_heatVehcile"..__OpUtil_LuaID())
			SGroup_Add(vehicleSgroup, sid)
			table.insert(t_heat_sources, vehicleSgroup)
		elseif (Squad_GetBlueprint(sid) == SBP.SOVIET.SNIPER_TEAM) then
			
		else
			
			local table_a = { }
			table_a.id = SGroup_CreateIfNotFound("sg_cold_squad_id_"..__OpUtil_LuaID())
			SGroup_Add(table_a.id, sid)
			SGroup_Add(sg_cold_squads, sid)
			table_a.player = Squad_GetPlayerOwner(sid)
			table_a.currState = -1
			table_a.tmr_id = "tmr_squad_"..__OpUtil_LuaID()
			table_a.tmr = 0
			table_a.inCover = false
			table_a.hp = nil
			table_a.visibleMod = nil
			table_a.moving = false
			table_a.movingTimer = "movingTimer_"..__OpUtil_LuaID()
			table_a.frozen_icon = false
			for k,v in pairs(t_coldPlayerTable) do 
				if table_a.player == v.player then
					table_a.suppressionResist = v.suppressionResist
				end
			end
			table.insert(t_cold_squads, table_a)
		end
	end
	
	for k,v in pairs(t_coldPlayerTable) do 
		SGroup_Clear(sg_temp)
		Player_GetAll(v.player, sg_temp)
		SGroup_RemoveGroup(sg_temp, v.restrictions.sgroup)
		SGroup_Filter(sg_temp, v.restrictions.sbpTable, FILTER_REMOVE)
		SGroup_RemoveGroup(sg_temp, sg_cold_squads)
		SGroup_RemoveGroup(sg_temp, sg_heat_vehicles)
		SGroup_ForEach(sg_temp, _filterVehicles)
		for a,b in pairs(t_cold_squads) do 
			if SGroup_ContainsSGroup(v.restrictions.sgroup, b.id, ANY) then
				table.remove(t_cold_squads, a)
			end
		end
	end
	
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
			table_a.inCover = false
			table_a.hp = nil
			table_a.visibleMod = nil
			
			table.insert(t_coldSquads, table_a)
		end
	end
	
end


function _ColdWeath_Monitor()

	if table.getn(t_cold_squads) ~= 0 then
		
		for k, this in pairs(t_cold_squads) do
			
			if SGroup_IsEmpty(this.id) then
				
				table.remove(t_cold_squads, k)
				
			end
			
			if g_weatherState == "CLEAR" then
				
				if this.visibleMod ~= nil then
					
					Modifier_Remove(this.visibleMod)
					
					this.visibleMod = nil
					
				end
				
			elseif g_weatherState == "FOG" or g_weatherState == "BLIZZARD" then
				
				if this.visibleMod == nil then
					
					this.visibleMod = Modify_SightRadius(this.id, 0.50)
					
				end
				
			end
			
			local _nearFire = function(gid)
				
				for i = 1, table.getn(t_heat_sources) do

					if t_heat_sources[i] ~= nil then
						local mkrRadius = coldWeather.r_marker or 5
						local egroupRadius = coldWeather.r_egroup or 9.5
						if scartype(t_heat_sources[i]) == ST_MARKER and Marker_GetProximityRadius(t_heat_sources[i]) > 0 then
							mkrRadius = Marker_GetProximityRadius(t_heat_sources[i]) 
						elseif scartype(t_heat_sources[i]) == ST_SGROUP then
							if SGroup_IsEmpty(t_heat_sources[i]) then
								table.remove(t_heat_sources, i)
							elseif SGroup_IsEmpty(gid) == false and Prox_AreSquadsNearMarker(gid, Util_GetPosition(t_heat_sources[i]), ANY, mkrRadius) then
								this.nearFire = true
								return true
							end
						elseif scartype(t_heat_sources[i]) == ST_EGROUP then 
							if EGroup_IsEmpty(t_heat_sources[i]) then
								table.remove(t_heat_sources, i)
							elseif SGroup_IsEmpty(gid) == false and Prox_AreSquadsNearMarker(gid, Util_GetPosition(t_heat_sources[i]), ANY, egroupRadius) then
								this.nearFire = true
								return true
							end
						end
					end
				end
				
				local _CheckLightorHeavy = function (gid, idx, sid)
					local returnValue = false
					local count = Squad_Count(sid)
					local valueTable = {
						heavy = {
							coverType = "heavy",
							count = 0,
							warms = true, 
						},
						medium = {
							coverType = "medium",
							count = 0,
							warms = true, 
						},
						none = {
							coverType = "none",
							count = 0,
							warms = false, 
						},
						negative = {
							coverType = "negative",
							count = 0,
							warms = false, 
						},
					}
					local valueTotal = 0
					
					for n = 1, count do
						local coverValue = Entity_GetCoverValue(Squad_EntityAt(sid, n-1))
						if coverValue >= 0.5 then
							valueTable.heavy.count = valueTable.heavy.count + 1
						elseif coverValue >= 0.4 then
							valueTable.medium.count = valueTable.medium.count + 1
						elseif coverValue < 0.4 and coverValue >= 0 then
							valueTable.none.count = valueTable.none.count + 1
						else
							valueTable.negative.count = valueTable.negative.count + 1
						end
						
--~ 						valueTotal = valueTotal + (Entity_GetCoverValue(Squad_EntityAt(sid, n-1)))
--~ 						if (Entity_GetCoverValue(Squad_EntityAt(sid, n-1)) >= 0.4) then
--~ 							return true
--~ 						end
					end
					for k,v in pairs(valueTable) do 
						local highCount = 0
						if v.count > highCount then
							returnValue = v.warms
						end
					end
					
					this.nearFire = false
					return returnValue
--~ 					if (valueTotal/count) < 0.4 then
--~ 						return false
--~ 					elseif (valueTotal/count) >= 0.4 then
--~ 						return true
--~ 					end
--~ 					return false
					
				end
				
--~ 				if g_CoverWarms then
--~ 					if SGroup_IsEmpty(gid) == false and SGroup_IsMoving(gid, ANY) == false and SGroup_ForEach(gid, _CheckLightorHeavy) then	
--~ 						return true
--~ 					end
--~ 				end
				
				local playerOwner
				
				local checkPlayerOwner = function(sgid, indx, sid)
					if World_OwnsSGroup(sgid, ANY) then
						return false
					else
						playerOwner = Squad_GetPlayerOwner(sid)
						return true
					end
				end
				
--~ 				if SGroup_ForEach(gid, checkPlayerOwner) then
--~ 					for k,v in pairs(t_coldPlayerTable) do 
--~ 						if v.player == playerOwner and v.coverWarms == true then
--~ 							if SGroup_IsEmpty(gid) == false and SGroup_IsMoving(gid, ANY) == false and SGroup_ForEach(gid, _CheckLightorHeavy) then	
--~ 								return true
--~ 							end
--~ 						end
--~ 					end
--~ 				end
				
				for k,v in pairs(t_molotov) do
					if v.molotovPos ~= nil then 
						if SGroup_IsEmpty(gid) == false and Prox_AreSquadsNearMarker(gid, v.molotovPos, ANY, 20) then
							return true
						end
					end
				
				end
				
				return false
			end
			
			local _inCover = function(gid)
				
--~ 				for i = 1, table.getn(t_heat_sources) do

--~ 					if t_heat_sources[i] ~= nil then
--~ 						local mkrRadius = 5
--~ 						if scartype(t_heat_sources[i]) == ST_MARKER and Marker_GetProximityRadius(t_heat_sources[i]) > 0 then
--~ 							mkrRadius = Marker_GetProximityRadius(t_heat_sources[i]) 
--~ 						end
--~ 						if scartype(t_heat_sources[i]) == ST_SGROUP and SGroup_IsEmpty(t_heat_sources[i]) then
--~ 							table.remove(t_heat_sources, i)
--~ 						elseif SGroup_IsEmpty(gid) == false and Prox_AreSquadsNearMarker(gid, Util_GetPosition(t_heat_sources[i]), ANY, mkrRadius) then
--~ 							this.nearFire = true
--~ 							return true
--~ 						end
--~ 					end
--~ 				end
				
				local _CheckLightorHeavy = function (gid, idx, sid)
					local returnValue = false
					local count = Squad_Count(sid)
					local valueTable = {
						heavy = {
							coverType = "heavy",
							count = 0,
							warms = true, 
						},
						medium = {
							coverType = "medium",
							count = 0,
							warms = true, 
						},
						none = {
							coverType = "none",
							count = 0,
							warms = false, 
						},
						negative = {
							coverType = "negative",
							count = 0,
							warms = false, 
						},
					}
					local valueTotal = 0
					
					for n = 1, count do
						local coverValue = Entity_GetCoverValue(Squad_EntityAt(sid, n-1))
						if coverValue >= 0.5 then
							valueTable.heavy.count = valueTable.heavy.count + 1
						elseif coverValue >= 0.4 then
							valueTable.medium.count = valueTable.medium.count + 1
						elseif coverValue < 0.4 and coverValue >= 0 then
							valueTable.none.count = valueTable.none.count + 1
						else
							valueTable.negative.count = valueTable.negative.count + 1
						end
						
--~ 						valueTotal = valueTotal + (Entity_GetCoverValue(Squad_EntityAt(sid, n-1)))
--~ 						if (Entity_GetCoverValue(Squad_EntityAt(sid, n-1)) >= 0.4) then
--~ 							return true
--~ 						end
					end
					for k,v in pairs(valueTable) do 
						local highCount = 0
						if v.count > highCount then
							returnValue = v.warms
						end
					end
					
					this.nearFire = false
					return returnValue
--~ 					if (valueTotal/count) < 0.4 then
--~ 						return false
--~ 					elseif (valueTotal/count) >= 0.4 then
--~ 						return true
--~ 					end
--~ 					return false
					
				end
				
--~ 				if g_CoverWarms then
--~ 					if SGroup_IsEmpty(gid) == false and SGroup_IsMoving(gid, ANY) == false and SGroup_ForEach(gid, _CheckLightorHeavy) then	
--~ 						return true
--~ 					end
--~ 				end
				
				local playerOwner
				
				local checkPlayerOwner = function(sgid, indx, sid)
					if World_OwnsSGroup(sgid, ANY) then
						return false
					else
						playerOwner = Squad_GetPlayerOwner(sid)
						return true
					end
				end
				
				if SGroup_ForEach(gid, checkPlayerOwner) then
					for k,v in pairs(t_coldPlayerTable) do 
						if v.player == playerOwner and v.coverWarms == true then
--~ 							if SGroup_IsEmpty(gid) == false and SGroup_IsMoving(gid, ANY) == false and SGroup_ForEach(gid, _CheckLightorHeavy) then	
							if SGroup_IsEmpty(gid) == false and SGroup_ForEach(gid, _CheckLightorHeavy) then	
								return true
							end
						end
					end
				end
				
				return false
			end
			
			if SGroup_IsEmpty(this.id) == false and Timer_Exists(this.tmr_id) and Timer_IsPaused(this.tmr_id) and _inCover(this.id) == false then
				
				Timer_Resume(this.tmr_id)
				Cmd_Ability(this.id, BP_GetAbilityBlueprint("cover_animation_test"))
				this.inCover = false
				
			end
		
			-- always warm a squad up if they're near fire or if they're moving
			if SGroup_IsEmpty(this.id) == false and Timer_Exists(this.tmr_id) and _inCover(this.id) then
				
				if Timer_IsPaused(this.tmr_id) == false then
					Timer_Pause(this.tmr_id)
					this.inCover = true
					Cmd_Ability(this.id, BP_GetAbilityBlueprint("cover_animation_test"))
					for k,v in pairs(t_condemned) do 
						if SGroup_ContainsSGroup(this.id, v.squad, ANY) then
--~ 						if SGroup_ContainsSquad(this.id, Squad_GetGameID(v.squad)) then
							table.remove(t_condemned, k)
						end
					end
				end
				
			elseif SGroup_IsEmpty(this.id) == false and (SGroup_IsInHoldEntity(this.id, ANY) or SGroup_IsInHoldSquad(this.id, ANY) or _nearFire(this.id)) or this.moving == true then
				
				if this.currState > 0 then
					
					this.currState = -1
					
					if Timer_Exists(this.tmr_id) then
						
						Timer_End(this.tmr_id)
						
					end
					
					if this.hp ~= nil then
						
						HintPoint_Remove(this.hp)
						
					end
					
					if this.moving ~= true then
						if this.nearFire == true then
							if this.warmingIconFire ~= true then
								this.warmingIconFire = true
								Cmd_Ability(this.id, BP_GetAbilityBlueprint("warming_animation_test"))	
							end
							this.hp = HintPoint_Add(this.id, true, LOC("Warming up"))
--~ 						else
--~ 							if this.warmingIconCover ~= true then
--~ 								this.warmingIconCover = true
--~ 								Cmd_Ability(this.id, BP_GetAbilityBlueprint("cover_animation_test"))
--~ 							end
--~ 							this.hp = HintPoint_Add(this.id, true, LOC("Warming up"))
						end
					else
						--this.hp = HintPoint_Add(this.id, true, LOC("Warmed from moving"))
					end
					
					if this.frozen_icon == true then
						Cmd_Ability(this.id, BP_GetAbilityBlueprint("frozen_icon_test"))	
						this.frozen_icon = false
					end
					
					
					--Timer_Start(this.tmr_id, 15)
					for k,v in pairs(t_coldPlayerTable) do 
						if this.player == v.player then
							if SGroup_IsInHoldEntity(this.id, ANY) then
								Timer_Start(this.tmr_id, v.warmTimes.garrison)
							else
								Timer_Start(this.tmr_id, v.warmTimes.cover)
							end
						end
					end
--~ 					if SGroup_IsInHoldEntity(this.id, ANY) then
--~ 						Timer_Start(this.tmr_id, 5)
--~ 					else
--~ 						Timer_Start(this.tmr_id, 15)
--~ 					end
					
					
					if freezeAccMod ~= nil then
						Modifier_Remove(freezeAccMod)
					end
					
					
				elseif this.currState == -1 then
					
					if Timer_Exists(this.tmr_id) and Timer_GetRemaining(this.tmr_id) <= 0 then
						
						Timer_End(this.tmr_id)
						
						this.currState = 0
						
						if this.hp ~= nil then
							
							if this.nearFire == true then
								if this.warmingIconFire ~= true then
									this.warmingIconFire = true
									Cmd_Ability(this.id, BP_GetAbilityBlueprint("warming_animation_test"))	
								end
--~ 							else
--~ 								if this.warmingIconCover ~= true then
--~ 									this.warmingIconCover = true
--~ 									Cmd_Ability(this.id, BP_GetAbilityBlueprint("cover_animation_test"))
--~ 								end
							end
							
							HintPoint_Remove(this.hp)
							
							this.hp = nil
							
						end
						
					end
					
				end
				
			else
				
				if this.warmingIconFire == true then
					Cmd_Ability(this.id, BP_GetAbilityBlueprint("warming_animation_test"))	
					this.warmingIconFire = false
--~ 				elseif this.warmingIconCover == true then
--~ 					this.warmingIconCover = false
--~ 					Cmd_Ability(this.id, BP_GetAbilityBlueprint("cover_animation_test"))	
				end
				
				-- Only execute if the weather is not clear
				if g_currWeather > 0 then
					
					
					--print(g_currWeather)
					--print(this.currState)
					
					-- if he's warming up or warm, he no longer is - stop any timers and clear hint points
					if this.currState < 0 then
						
						if Timer_Exists(this.tmr_id) then
							
							Timer_End(this.tmr_id)
							Timer_End(this.tmr_id)
							
						end
						
						if this.hp ~= nil then
							
							HintPoint_Remove(this.hp)
							
							this.hp = nil
							
						end
						
						this.currState = 0
						if this.frozen_icon == true then
							Cmd_Ability(this.id, BP_GetAbilityBlueprint("frozen_icon_test"))						
							this.frozen_icon = false
						end
					
					end
					
					if this.currState == 0 then
						-- Get the current condition weather table
--~ 						local stateChangeTime = t_weatherTable[g_currWeather].stateTime_0_to_1
						local stateChangeTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_0_to_1
						-- Start the Timer
						if Timer_Exists(this.tmr_id) == false then
							
							if this.suppressionResist == false and (SGroup_IsSuppressed(this.id, ANY) or SGroup_IsPinned(this.id, ANY)) then
								local reducedChangeTime = stateChangeTime/2
								Timer_Start(this.tmr_id, reducedChangeTime)
							else
								Timer_Start(this.tmr_id, stateChangeTime)
							end
							
						else
							
							if Timer_GetRemaining(this.tmr_id) <= 0 then
								
								Timer_End(this.tmr_id)
								
								this.currState = 1
								
							end
							
						end
						
					elseif this.currState == 1 then
					
						--print(Timer_Exists(this.tmr_id))
						--print(Timer_GetRemaining(this.tmr_id))
						
--~ 						local stateChangeTime = t_weatherTable[g_currWeather].stateTime_1_to_2
						local stateChangeTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_1_to_2
						-- Start the Timer
						if Timer_Exists(this.tmr_id) == false then
							
							if this.suppressionResist == false and (SGroup_IsSuppressed(this.id, ANY) or SGroup_IsPinned(this.id, ANY)) then
								local reducedChangeTime = stateChangeTime/2
								Timer_Start(this.tmr_id, reducedChangeTime)
							else
								Timer_Start(this.tmr_id, stateChangeTime)
							end
							
						else
							
							if Timer_GetRemaining(this.tmr_id) <= 0 then
								
								Timer_End(this.tmr_id)
								
								this.currState = 2
								
								if this.hp ~= nil then
									
									HintPoint_Remove(this.hp)
									
									this.hp = nil
									
								end
								
								this.hp = HintPoint_Add(this.id, true, LOC("Feeling Cold"))
								
							end
							
						end
						
					elseif this.currState == 2 then
						
--~ 						local stateChangeTime = t_weatherTable[g_currWeather].stateTime_2_to_3
						local stateChangeTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_2_to_3
						-- Start the Timer
						if Timer_Exists(this.tmr_id) == false then
							
							if this.suppressionResist == false and (SGroup_IsSuppressed(this.id, ANY) or SGroup_IsPinned(this.id, ANY)) then
								local reducedChangeTime = stateChangeTime/2
								Timer_Start(this.tmr_id, reducedChangeTime)
							else
								Timer_Start(this.tmr_id, stateChangeTime)
							end
							
						else
							
							if Timer_GetRemaining(this.tmr_id) <= 0 then
								
								Timer_End(this.tmr_id)
								
								this.currState = 3
								
								if this.hp ~= nil then
									
									HintPoint_Remove(this.hp)
									
									this.hp = nil
									
								end
								
--~ 								local warningTime = t_weatherTable[g_currWeather].stateTime_3_to_4
								local warningTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_3_to_4
								--this.hp = HintPoint_Add(this.id, true, LOC("Start Freezing: "..sec2Min(warningTime)))
								
								-- freezing squads lose accuracy
								freezeAccMod = Modify_WeaponAccuracy(this.id, "hardpoint_01", 0.5 )
								
								if this.frozen_icon == false then
									Cmd_Ability(this.id, BP_GetAbilityBlueprint("frozen_icon_test"))	
									this.frozen_icon = true
								end
								
							end
							
						end
						
					elseif this.currState == 3 then
						
--~ 						local stateChangeTime = t_weatherTable[g_currWeather].stateTime_3_to_4
						local stateChangeTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_3_to_4
						-- Start the Timer
						if Timer_Exists(this.tmr_id) == false then
							
							if this.suppressionResist == false and (SGroup_IsSuppressed(this.id, ANY) or SGroup_IsPinned(this.id, ANY)) then
								local reducedChangeTime = stateChangeTime/2
								Timer_Start(this.tmr_id, reducedChangeTime)
							else
								Timer_Start(this.tmr_id, stateChangeTime)
							end
							
						else
							
							if this.hp ~= nil then
								
								HintPoint_Remove(this.hp)
								
								this.hp = nil
								
							end
							
							local warningTime = Timer_GetRemaining(this.tmr_id)
							--this.hp = HintPoint_Add(this.id, true, LOC("Start Freezing: "..sec2Min(warningTime)))
							
							--Cmd_Ability(sg_footSquad, BP_GetAbilityBlueprint("frozen_icon_test"))
							if this.frozen_icon == false then
								Cmd_Ability(this.id, BP_GetAbilityBlueprint("frozen_icon_test"))	
								this.frozen_icon = true
							end
							if Timer_GetRemaining(this.tmr_id) <= 0 then
								
								Timer_End(this.tmr_id)
								
								this.currState = 4
								
								if this.hp ~= nil then
									
									HintPoint_Remove(this.hp)
									
									this.hp = nil
									
								end
								
								--this.hp = HintPoint_Add(this.id, true, LOC("Squad Dying"))
--~ 								-- freezing squads lose accuracy
--~ 								freezeAccMod = Modify_WeaponAccuracy(this.id, "hardpoint_01", 0.5 )
								
							end
							
						end
						
					elseif this.currState == 4 then
						
--~ 						local stateChangeTime = t_weatherTable[g_currWeather].stateTime_dieing
						local stateChangeTime = t_weatherTable[(Player_GetID(this.player) - 999)].stateTime_dieing
						
						if Timer_Exists(this.tmr_id) == false then
							
							if this.suppressionResist == false and (SGroup_IsSuppressed(this.id, ANY) or SGroup_IsPinned(this.id, ANY)) then
								local reducedChangeTime = stateChangeTime/2
								Timer_Start(this.tmr_id, reducedChangeTime)
							else
								Timer_Start(this.tmr_id, stateChangeTime)
							end
							
						else
							
							if Timer_GetRemaining(this.tmr_id) <= 0 and SGroup_IsEmpty(this.id) == false then
								
								Timer_End(this.tmr_id)
								
								Timer_Start(this.tmr_id, stateChangeTime)
									

								local table_me = {}
								
								local count = SGroup_TotalMembersCount(this.id)
								local frozenSquad = SGroup_CreateIfNotFound("frozenSquad"..__OpUtil_LuaID())										
								
								for i = 1, count do
									
									local eid = Squad_EntityAt(SGroup_GetSpawnedSquadAt(this.id, 1), i-1)
									
									if Entity_IsSyncWeapon(eid) == false then
										table.insert(table_me, Entity_GetGameID(eid))	
										--SGroup_Add(frozenSquad, SGroup_GetSpawnedSquadAt(this.id, 1))
									end
								end	
								
								local entityworldID = Table_GetRandomItem(table_me)								
								--Entity_Kill(Entity_FromWorldID(entityID))
--~ 								local entitytokill = Entity_FromWorldID(entityworldID)
								--SGroup_Remove(this.id, SGroup_GetSpawnedSquadAt(this.id, 1))
								
								local donotadd = false
								
								if table.getn(t_condemned) >= 1 then
								
									for k,v in pairs(t_condemned) do
									
										if v.w_entity == entityworldID then
											
											donotadd = true
										end	
										
									end
								end
								
								if donotadd == false then
									g_casualtyCount = g_casualtyCount + 1
									SGroup_Add(frozenSquad, SGroup_GetSpawnedSquadAt(this.id, 1))
--~ 									local entityinfo = {w_entity = entityworldID, entity = entitytokill, posture = 1, timerID = "entityTimer"..g_casualtyCount, squad = frozenSquad, stopped = false}		
									local entityinfo = {w_entity = entityworldID, posture = 1, timerID = "entityTimer"..g_casualtyCount, squad = frozenSquad, stopped = false}		
									table.insert(t_condemned, entityinfo)	
								end


							elseif SGroup_IsEmpty(this.id) then
								
								Timer_End(this.tmr_id)
								
							end
							
						end
						
					end
					
					
					--[[
						this.currState = 0
							if Timer_Exists(this.tmr_id) then
								Timer_End(this.tmr_id)
							end
							Timer_Start(this.tmr_id, g_stateTime_warmUp)
							if this.hp ~= nil then
								HintPoint_Remove(this.hp)
								this.hp = nil
							end
							if this.hp == nil then
								this.hp = HintPoint_Add(this.id, true, LOC("Warming Up"))
							end
							
						elseif this.currState == 0 then
							if Timer_Exists(this.tmr_id) and Timer_GetRemaining(this.tmr_id) <= 0 then
								this.currState = -1
								Timer_End(this.tmr_id)
								if this.hp ~= nil then
									HintPoint_Remove(this.hp)
									this.hp = nil
								end
							end
						end
					]]					
					
				end
				
			end
			
		end
		
	end

end

-- governs the killing of condemned entities and their postures
function _ColdWeather_KillCondemned()
--print(table.getn(t_condemned))
	if table.getn(t_condemned) >= 1 then
	
		for k,v in pairs(t_condemned) do

			if v.w_entity ~= nil and Entity_IsValid(v.w_entity) == true then
				
				if SGroup_IsInHoldEntity(v.squad, ANY) or ColdWeather_GetCurrentState(v.squad) == -1 or ColdWeather_GetInCover(v.squad) then
				
					table.remove(t_condemned, k)
				
				else
					if Timer_Exists(v.timerID) == false then
						
						local timerLength = World_GetRand(3, 8)			
						Timer_Start(v.timerID, timerLength)
						Entity_SuggestPosture(Entity_FromWorldID(v.w_entity), v.posture, timerLength)
						
					elseif Timer_Exists(v.timerID) == true then
						
						if math.floor(Timer_GetRemaining(v.timerID)) <= 0 then
						
							if v.posture == 1 then				
								
								v.posture = 0							
								
								Timer_End(v.timerID)
								local timerLength = World_GetRand(3, 8)		
								Timer_Start(v.timerID, timerLength)
								Entity_SuggestPosture(Entity_FromWorldID(v.w_entity), v.posture, timerLength)
								
							elseif v.posture == 0 and (not SGroup_GetInvulnerable(v.squad, true)) then --and v.stopped == true then
								print("__,_,,...--'-'{ FREEZE }'-'--...,,_,__")
--~ 								print(v.w_entity)
								ModMisc_MakeCasualtyAction(Entity_FromWorldID(v.w_entity))
--~ 								Entity_Kill(Entity_FromWorldID(v.w_entity))
								
							end
						
--~ 						elseif math.floor(Timer_GetRemaining(v.timerID)) >= 1 and math.floor(Timer_GetRemaining(v.timerID)) < 3 then--and math.floor(Timer_GetRemaining(v.timerID)) >= 1 then
--~ 							-- tried various methods to stop a single dude, but it didn't work - it would stop the whole squad :(  
--~ 							v.stopped = true
							
						end
					
					end
				end
			elseif v.w_entity == nil or Entity_IsValid(v.w_entity) == false then
				
				table.remove(t_condemned, k)
			
			end
		end
	end
end


function  ColdWeather_SetupWeather(r_marker, r_egroup)
	coldWeather.r_marker = r_marker
	coldWeather.r_egroup = r_egroup
	
	t_cold_squads = {}
	t_cold_playerRestrictions = {}
	t_condemned = {}
	t_molotov = {}
	t_coldPlayerTable = {}

	t_heat_sources = Marker_GetTable("mkr_heat%02d")
	local fireGroup = EGroup_GetWBTable("eg_heat%02d")
	for k,v in pairs(fireGroup) do 
		table.insert(t_heat_sources, v)
	end
	t_warming_positions = Clone(t_heat_sources)

	g_sgroup_id = 0
	
--~ 	States	
--~ 	-1 = warming up
--~ 	0 = warm
--~ 		[Snowing - 35 seconds | Blizzard - 45 seconds | Clearing up - 45 seconds]
--~ 	1 = cooling off, no warning
--~ 		[Snowing - 3 minutes | Blizzard - 2 minute | Clearing up - 3 minutes]
--~ 	2 = Cold, static warning
--~ 		[
--~ 	3 = Starting to Freeze, count down
--~ 	4 = Dieing, static warning
	
	t_weatherTable = {
--~ 		{
--~ 			stateTime_0_to_1 = 15,
--~ 			stateTime_1_to_2 = 10,
--~ 			stateTime_2_to_3 = 8,	-- WARNING 1 SQUAD GETTING COLD
--~ 			stateTime_3_to_4 = 10,	-- WARNING 2 SQUAD DIEING IN: X:XX
--~ 			stateTime_dieing = 5,		-- Every X seconds, a squad member dies
--~ 		},
	}
	
	local coldTimeTable = {
		stateTime_0_to_1 = 15,
		stateTime_1_to_2 = 10,
		stateTime_2_to_3 = 8,	-- WARNING 1 SQUAD GETTING COLD
		stateTime_3_to_4 = 10,	-- WARNING 2 SQUAD DIEING IN: X:XX
		stateTime_dieing = 5,		-- Every X seconds, a squad member dies
	}
	
	g_permLevel = 2
	g_stateTime_warmUp = 40
	
	g_stateTime_trenchMod = 2*60
	
	g_casualtyCount = 0 
	
	g_currWeather = 1
	g_weatherState = "BLIZZARD"
	
	g_CoverWarms = true	
	sg_cold_squads = SGroup_CreateIfNotFound("sg_cold_squads")
	sg_heat_vehicles = SGroup_CreateIfNotFound("sg_heat_vehicles")
	
	sg_cold_squads = SGroup_CreateIfNotFound("sg_cold_squads")
	local playerCount = World_GetPlayerCount()
	for i = 1, playerCount do
		table.insert(t_weatherTable, Clone(coldTimeTable))
		table.insert(t_coldPlayerTable, { 
			player = World_GetPlayerAt(i), 
			restrictions = {
				sgroup = SGroup_CreateIfNotFound("sg_restrict"..__OpUtil_LuaID()),
				sbpTable = {},
			},
			warmTimes = {
				garrison = 5,
				cover = 15,
			},
			coverWarms = true,
			suppressionResist = true,
		})
	end
	Rule_AddInterval(ColdWeather_ManageUnits, 1)
	Rule_AddInterval(_ColdWeath_Monitor, 1)
	Rule_AddInterval(_ColdWeather_KillCondemned, 1)

end

--~ Scar_AddInit(SetupWeather)

-------------------
-- Cold Weather Util Functions
-------------------

-- Adds a sgroup or sbp to a restriction table that makes those units immnue from cold.
function ColdWeather_SetImmune(tempPlayer, tempUnit)
	if tempPlayer ~= nil then
		for k,v in pairs(t_coldPlayerTable) do
			if tempPlayer == v.player then
				if scartype(tempUnit) == ST_SGROUP then
					if SGroup_ContainsSGroup(sg_cold_squads, tempUnit, ANY) then
						SGroup_RemoveGroup(sg_cold_squads, tempUnit)
					end
					SGroup_AddGroup(v.restrictions.sgroup, tempUnit)
				elseif scartype(tempUnit) == ST_PBG then
					if SGroup_ContainsBlueprints(sg_cold_squads, tempUnit, ANY) then
						SGroup_Filter(sg_cold_squads, tempUnit, FILTER_REMOVE)
					end
					table.insert(v.restrictions.sbpTable, tempUnit)
				end
			end			
		end
	end
end

function ColdWeather_RemoveImmunity(tempPlayer, tempUnit)
	if tempPlayer ~= nil then
		for k,v in pairs(t_coldPlayerTable) do
			if tempPlayer == v.player then
				if scartype(tempUnit) == ST_SGROUP then
					if SGroup_ContainsSGroup(v.restrictions.sgroup, tempUnit, ANY) then
						SGroup_RemoveGroup(v.restrictions.sgroup, tempUnit)
					end
				elseif scartype(tempUnit) == ST_PBG then
					for k,v in pairs(v.restrictions.sbpTable) do 
						if v == tempUnit then
							table.remove(v.restrictions.sbpTable, k)
						end
					end
				end
			end			
		end
	end	
end

-- Gets the current cold weather state of a sgroup
function ColdWeather_GetCurrentState(sgroupTemp)
	for k,v in pairs(t_cold_squads) do 
--~ 		if scartype(sgroupTemp) == ST_SGROUP and SGroup_ContainsSGroup(v.id, sgroupTemp, ANY) then
		if scartype(sgroupTemp) == ST_SGROUP and SGroup_ContainsSGroup(sgroupTemp, v.id, ANY) then
			return v.currState
		elseif scartype(sgroupTemp) == ST_SQUAD and SGroup_ContainsSquad(v.id, Squad_GetGameID(sgroupTemp)) then
			return v.currState
		end
	end
	
	return -1
end

function ColdWeahter_SetCurrentState(sgroupTemp, state)
	for k,v in pairs(t_cold_squads) do 
		if SGroup_ContainsSGroup(v.id, sgroupTemp, ANY) then
			v.currState = state
		end
	end
end

function ColdWeather_GetInCover(sgroupTemp)
	for k,v in pairs(t_cold_squads) do 
--~ 		if scartype(sgroupTemp) == ST_SGROUP and SGroup_ContainsSGroup(v.id, sgroupTemp, ANY) then
		if scartype(sgroupTemp) == ST_SGROUP and SGroup_ContainsSGroup(sgroupTemp, v.id, ANY) then
			return v.inCover
		elseif scartype(sgroupTemp) == ST_SQUAD and SGroup_ContainsSquad(v.id, Squad_GetGameID(sgroupTemp)) then
			return v.inCover
		end
	end
	
	return -1
end

function ColdWeather_AddHeatSource(heatSource)
	if scartype(heatSource) == ST_MARKER then
		table.insert(t_heat_sources, heatSource)
		table.insert(t_warming_positions, heatSource)
	end
end

function ColdWeather_SetColdTimer(tempstate, timeCurState)
--~ 	t_weatherTable[g_currWeather].state = timeCurState
	for k,v in pairs(t_weatherTable) do 
		print("t_weatherTable")
		for a,b in pairs(v) do 
			if tempstate == tostring(a) then
				t_weatherTable[k][tempstate] = timeCurState
--~ 				b = timeCurState
			end
			print(b)
		end
	end

end

function ColdWeather_SetPlayerColdTimer(playerID, tempstate, timeCurState)
	
	if tempstate == "stateTime_0_to_1" then
		t_weatherTable[(Player_GetID(playerID) - 999)].stateTime_0_to_1  = timeCurState
--~ 		weatherIndx = stateTime_0_to_1
	elseif tempstate == "stateTime_1_to_2" then
		t_weatherTable[(Player_GetID(playerID) - 999)].stateTime_1_to_2  = timeCurState
--~ 		weatherIndx = 2
	elseif tempstate == "stateTime_2_to_3" then
		t_weatherTable[(Player_GetID(playerID) - 999)].stateTime_2_to_3  = timeCurState
--~ 		weatherIndx = 3
	elseif tempstate == "stateTime_3_to_4" then
		t_weatherTable[(Player_GetID(playerID) - 999)].stateTime_3_to_4  = timeCurState
--~ 		weatherIndx = 4
	elseif tempstate == "stateTime_dieing" then
		t_weatherTable[(Player_GetID(playerID) - 999)].stateTime_dieing  = timeCurState
--~ 		weatherIndx = 5
	end
	
--~ 	t_weatherTable[(Player_GetID(playerID) - 999)][weatherIndx] = timeCurState
	
--~ 	for k,v in pairs(t_weatherTable) do 
--~ 		print("t_weatherTable")
--~ 		for a,b in pairs(v) do 
--~ 			if tempstate == tostring(a) then
--~ 				t_weatherTable[k][tempstate] = timeCurState
--~ 			end
--~ 			print(b)
--~ 		end
--~ 	end

end

function ColdWeather_SetWarmTimes(playerID, garrisonTime, coverTime)
	for k,v in pairs(t_coldPlayerTable) do 
		if v.player == playerID then
			if garrisonTime ~= nil then
				v.warmTimes.garrison = garrisonTime
			end
			if coverTime ~= nil then
				v.warmTimes.cover = coverTime
			end
		end
	end
end

function ColdWeather_SetCoverWarm(tempBool)
	
	for k,v in pairs(t_coldPlayerTable) do 
		v.coverWarms = tempBool
	end

end

function ColdWeather_SetPlayerCoverWarm(tempPlayer, tempBool)
	
	for k,v in pairs(t_coldPlayerTable) do 
		if tempPlayer ~= nil then
			if v.player == tempPlayer then
				v.coverWarms = tempBool
				return
			end
		end
	end
	
end

function ColdWeather_SetPlayerSuppressionResist(tempPlayer, tempBool)
	
	for k,v in pairs(t_coldPlayerTable) do 
		if tempPlayer ~= nil then
			if v.player == tempPlayer then
				v.suppressionResist = tempBool
				for a,b in pairs(t_cold_squads) do 
					if b.player == v.player then
						b.suppressionResist = v.suppressionResist
					end
				end
				return
			end
		end
	end
	
end
