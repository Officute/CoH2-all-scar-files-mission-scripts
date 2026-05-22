----------------------------------------------------------------------------------------------------------------
-- Single player scar helper functions
-- (c) 2003 Relic Entertainment Inc.


import("LuaConstsAuto.scar")
import("Setup.scar")
import("Proximity.scar")
import("Timer.scar")
import("Player.scar")
import("Entity.scar")
import("Squad.scar")
import("Command.scar")
import("Groups.scar")
import("Camera.scar")
import("Actor.scar")
import("Modifiers.scar")
import("Objectives.scar")
import("RuleSystem.scar")
import("View.scar")
import("UI.scar")
import("DesignerLib.scar")
import("SyncWeapons.scar")
import("UID.scar")
import("Team.scar")
import("NIS.scar")
import("Events.scar")

function __ScarUtil_Init()

	sg_single = SGroup_CreateIfNotFound("sg_single")
	sg_temp = SGroup_CreateIfNotFound("sg_temp")
	sg_blah = SGroup_CreateIfNotFound("sg_blah")
	
	eg_single = EGroup_CreateIfNotFound("eg_single")
	eg_temp = EGroup_CreateIfNotFound("eg_temp")
	eg_blah = EGroup_CreateIfNotFound("eg_blah")
	
	__t_SquadIntoSGroupMapping = {}
	__t_paradrop_squads = {}
	
	--Special debug boolean used to prevent any intelEvent from playing. Can only be toggled using Util_ToggleAllowIntelEvents() in -dev mode.
	--Used to capture mission action without intelEvents triggering.
	__g_playIntelEvents = true
end

Scar_AddInit(__ScarUtil_Init)

---------------------
-- CONSTANTS
------------------
ALL = true
ANY = false		-- for use in "Boolean: all" parameters

-- set of offsets that are enumerated so that we don't have to memorize the numbers.
-- numbers go CLOCKWISE around the circle.
-- the orientation is in respect to the SGroup or object to which you desire an offeset; 
-- here's a quick drawing for visualization
--[[
FRONT_LEFT  FRONT  	FRONT_RIGHT

			 /\
			/  \
LEFT	   /_  _\        RIGHT
			 ||
			 ||
			 ||
			 
BACK_LEFT   BACK	BACK_RIGHT

]]
OFFSET_FRONT = 0
OFFSET_FRONT_RIGHT = 1
OFFSET_FRONT_LEFT = 7
OFFSET_BACK = 4
OFFSET_BACK_RIGHT = 3
OFFSET_BACK_LEFT = 5
OFFSET_RIGHT = 2
OFFSET_LEFT = 6

-- use these as offsets in SGroup_IsUnderAttackFromDirection
OFFSET_DIRECTION_FRONT = {OFFSET_FRONT_LEFT, OFFSET_FRONT, OFFSET_FRONT_RIGHT}
OFFSET_DIRECTION_RIGHT = {OFFSET_FRONT_RIGHT, OFFSET_RIGHT, OFFSET_BACK_RIGHT}
OFFSET_DIRECTION_BACK = {OFFSET_BACK_RIGHT, OFFSET_BACK, OFFSET_BACK_LEFT}
OFFSET_DIRECTION_LEFT = {OFFSET_BACK_LEFT, OFFSET_LEFT, OFFSET_FRONT_LEFT}

TRACE_SOVIET = "soviet"
TRACE_GERMAN = "german"

-- constants used for event priorities
EVENT_NIS = 0
EVENT_INTEL = 1
EVENT_AMBIENT = 2

--*** EVENT CUE ICON & SOUNDS ***
-- 					Icon Path:	Root\WW2\Data\Art\UI\InGame
-- 					Sound Path:	Root\WW2\Data\Sound\UI\EventCues
CUE = {
	__scardoc_enum = true,
	NORMAL 				= {icon = "Icons_events_event_cue", sound = "General_alert"},
	NORMAL_REPEATING	= {icon = "Icons_events_event_cue", sound = "General_alert", class = "repeating"},
	VEHICLE				= {icon = "Icons_events_event_cue", sound = "ui/in_game/event_cues/population_increased"},
	ATTACKED 			= {icon = "Icons_events_event_cue_combat", sound = "ui/in_game/event_cues/infantry_under_attack"},
	MAP 				= {icon = "Icons_events_event_cue_map", sound = "General_alert"},
	UPGRADE				= {icon = "Icons_events_event_cue_upgrade", sound = "General_alert"},
	NETWORK				= {icon = "Icons_events_event_cue_network", sound = "General_alert"},
	BLIZZARD			= {icon = "Icons_events_event_cue_blizzard", sound = "General_alert"},
	INFANTRY_BUILT		= {icon = "Icons_events_event_cue_infantry_complete", sound = "General_alert"},
	VEHICLE_BUILT		= {icon = "Icons_events_event_cue_vehicle_complete", sound = "General_alert"},
	POP_INC				= {icon = "Icons_events_event_cue_upgrade", sound = "ui/in_game/event_cues/population_increased"},
}

LIST = {
	__scardoc_enum = true,
	AIRCRAFT = {
		SBP.SOVIET.IL_2_STURMOVIK_RECON_SQUAD,
		SBP.SOVIET.IL_2_STURMOVIK_RECON_SQUAD_MP,
		BP_GetSquadBlueprint("il-2_sturmovik_recon_squad_sp"),
		SBP.SOVIET.IL_2_STUMOVIK_SQUAD,
		SBP.SOVIET.IL_2_STUMOVIK_SQUAD_MP,
		SBP.SOVIET.IL_2_STURMOVIK_ROCKET_SQUAD,
		SBP.SOVIET.IL_2_STURMOVIK_ROCKET_SQUAD_MP,
		SBP.SOVIET.IL_2_STURMOVIK_ROCKET_SP_SQUAD,
		BP_GetSquadBlueprint("m01_il-2_sturmovik_rocket_squad"),
		SBP.GERMAN.STUKA_AIR_CAP_SQUAD,
		SBP.GERMAN.STUKA_GROUND_ANTI_TANK_SQUAD,
		SBP.GERMAN.STUKA_GROUND_ATTACK_SQUAD,
		SBP.GERMAN.STUKA_GROUND_ATTACK_SQUAD_LONG,
		SBP.GERMAN.STUKA_GROUND_FRAGMENTATION_SQUAD,
		SBP.GERMAN.STUKA_SMOKE_SQUAD,
		SBP.AEF.P47_RECON,
		SBP.AEF.P47_ROCKETS,
		SBP.AEF.P47_STRAFES,
		BP_GetSquadBlueprint("pm_aef_airborne_paratroopers_plane_paras"),
		BP_GetSquadBlueprint("pm_aef_airborne_paratroopers_plane_strafe"),
		BP_GetSquadBlueprint("aef_air_support_recon"),
		BP_GetSquadBlueprint("aef_air_support_rocket"),
		BP_GetSquadBlueprint("aef_air_support_strafe"),
		BP_GetSquadBlueprint("pm_aef_airborne_supply_drop_plane"),
		SBP.AEF.PARATROOPERS_PLANE,
		SBP.AEF.PARATROOPERS_PLANE_PARAS,
		
		SBP.WEST_GERMAN.JU52_PARATROOPER_PLANE,
	},
	INFANTRY = {
		SBP.SOVIET.BASE_CONSCRIPT_SQUAD,
		SBP.SOVIET.COMBAT_ENGINEER_SQUAD,
		SBP.SOVIET.GUARDS_TROOPS,
		SBP.SOVIET.SHOCK_TROOPS,
		SBP.SOVIET.PENAL_BATTALION,
		SBP.SOVIET.CONSCRIPT_SQUAD,
		SBP.SOVIET.PM_82_41_MORTAR_SQUAD,
		SBP.SOVIET.HM_120_38_MORTAR_SQUAD,
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
		SBP.SOVIET.DSHK_38_HMG_SQUAD,
		SBP.SOVIET.SNIPER_TEAM,
		SBP.SOVIET.M08_TANK_BUSTER_CONSCRIPT_SQUAD,
		SBP.SOVIET.M08_COMBAT_ENGINEER_SQUAD,
		SBP.SOVIET.M11_PARTISAN_SQUAD_KAR98K_RIFLE,
		SBP.SOVIET.M11_PARTISAN_SQUAD_NAGANT_RIFLE,
		SBP.SOVIET.M11_SNIPER_TEAM,
		SBP.SOVIET.M11_ANIA_SNIPER_SQUAD,
	},
	AEF_INFANTRY = {
		SBP.AEF.REAR_ECHELON_SQUAD_MP,
		SBP.AEF.RIFLEMEN_SQUAD_MP,
		SBP.AEF.RIFLEMEN_SQUAD_VETERAN_MP,
		SBP.AEF.PARATROOPER_SQUAD_MP,
		SBP.AEF.PATHFINDER_SQUAD_MP,
		SBP.AEF.PATHFINDER_SQUAD_RECON_MP,
		SBP.AEF.JACKSON_SQUAD,
		SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP,
		SBP.AEF.ASSAULT_ENGINEER_SQUAD_5_MAN_MP,
		SBP.AEF.M1_81MM_MORTAR_SQUAD_MP,
		SBP.AEF.M2_60MM_MORTAR_SQUAD_MP,
		SBP.AEF.M2HB_50CAL_HMG_SQUAD_MP,
		SBP.AEF.M1919A4_HMG_SQUAD_MP,
		SBP.AEF.RANGER_SQUAD_MP,
		SBP.AEF.CAPTAIN_SQUAD_MP,
		SBP.AEF.LIEUTENANT_SQUAD_MP,
		SBP.AEF.MAJOR_SQUAD_MP,
		SBP.AEF.VEHICLE_CREW_SQUAD_MP,
		SBP.AEF.VEHICLE_CREW_BAZOOKA_SQUAD_MP,
		SBP.AEF.USF_MEDIC_SQUAD_MP,
		SBP.AEF.PM_RIFLEMEN_SQUAD_OMCG,
	},
	SOVIETBASEBUILDINGS = {
		EBP.SOVIET.MOTORPOOL,
		EBP.SOVIET.BARRACKS,
		EBP.SOVIET.TANK_DEPOT,
		EBP.SOVIET.WEAPON_SUPPORT_CENTER,
		EBP.SOVIET.HQ,
		EBP.SOVIET.HQ_NO_WRECK,
	},

	GERMANBASEBUILDINGS = {
		EBP.GERMAN.BEREICH_FESTUNG,
		EBP.GERMAN.DOLCH_AKTIONEN,
		EBP.GERMAN.HINTERE_PANZERWERK,
		EBP.GERMAN.SCHWERES_KRIEGSWERK,
		EBP.GERMAN.GERMAN_HQ,
		EBP.GERMAN.GERMAN_HQ_WRECK,
	},
	
	HMGS = {
		SBP.SOVIET.M1910_MAXIM_HEAVY_MACHINE_GUN_SQUAD,
		SBP.SOVIET.DSHK_38_HMG_SQUAD,
		SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD,
	},
	
	ATGUNS = {
		SBP.SOVIET.M1937_53_K_45MM_AT_GUN_SQUAD,
		SBP.SOVIET.M1942_ZIS_3_76MM_AT_GUN_SQUAD,
		SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD,
		SBP.GERMAN.PAK43_88MM_AT_GUN_SQUAD,
	},
	
	TANKS = {
		SBP.SOVIET.IS_2,
		SBP.SOVIET.ISU_152,
		SBP.SOVIET.KV_1,
		SBP.SOVIET.KV_8,
		SBP.SOVIET.SU_76M,
		SBP.SOVIET.SU_85,
		SBP.SOVIET.T_34_76_SQUAD,
		SBP.SOVIET.T_34_85_SQUAD,
		SBP.SOVIET.T_70M,
		SBP.GERMAN.BRUMMBAR_SQUAD,
		SBP.GERMAN.ELEFANT_TANK_DESTROYER_SQUAD,
		SBP.GERMAN.OSTWIND_SQUAD,
		SBP.GERMAN.PANTHER_SQUAD,
		SBP.GERMAN.PANZER_IV_COMMAND_SQUAD,
		SBP.GERMAN.PANZER_IV_SQUAD,
		SBP.GERMAN.STUG_III_E_SQUAD,
		SBP.GERMAN.STUG_III_SQUAD,
		SBP.GERMAN.TIGER_SQUAD,
	},
	
	LIGHTVEHICLES = {
		SBP.SOVIET.M5_HALFTRACK_SQUAD,
		SBP.SOVIET.M3A1_SCOUT_CAR_SQUAD,
		SBP.SOVIET.KATYUSHA_BM_13N_SQUAD,
		SBP.GERMAN.SCOUTCAR_SDKFZ222,
		SBP.GERMAN.SDKFZ_251_HALFTRACK_SQUAD,
		SBP.GERMAN.PANZERWERFER_SQUAD,
		SBP.GERMAN.MORTAR_250_HALFTRACK_SQUAD,
	},
}



--------------------------
--------------------------

-- Deprecate error function
error = fatal

-- returns a temp egroup or sgroup containing the item (entity/squad) passed in, or nil if you couldn't follow instructions
local __GetTempGroup = function(item)
	local groupcaller = __GetGroupCaller(item)
	if groupcaller then
		local group = groupcaller.CreateIfNotFound("temp!")
		groupcaller.ClearItems(group)
		groupcaller.AddItem(group, item)
		return group
	end
	
end

local __GarrisonNearbyUnit = function(groupcaller, sgroup, pos, radius, occupied, filter)

	if pos == nil then pos = SGroup_GetPosition(sgroup) end
	if radius == nil then radius = 9999 end
	if occupied == nil then occupied = true end
	
	-- get all entities nearby
	local grp_temp_nearby = groupcaller.Create("grp_temp_nearby")
	groupcaller.GetItemsNearPoint(grp_temp_nearby, Util_GetPlayerOwner(sgroup), Util_GetPosition(pos), radius, OT_Ally)
	groupcaller.GetItemsNearPoint(grp_temp_nearby, Util_GetPlayerOwner(sgroup), Util_GetPosition(pos), radius, OT_Neutral)

	-- filter out any groups that the caller does not want to be occupied
	if filter ~= nil then
		
		if scartype(filter) == ST_TABLE then
			for i=1, table.getn(filter) do
				groupcaller.RemoveGroup(grp_temp_nearby, filter[i])
			end
		else
			groupcaller.RemoveGroup(grp_temp_nearby, filter)
		end
	end
	
	-- try to find him a home
	local closestitem
	local closestdistance = 9999
	print("How many items found:")
	print(EGroup_Count(grp_temp_nearby))
	for i = 1, groupcaller.GetSpawnedCount(grp_temp_nearby) do
		local item = groupcaller.GetSpawnedItemAt(grp_temp_nearby, i)
		
		local bCanLoad = true
		
		-- if we don't want to consider [friendly] occupied buildings
		if occupied == false then
			local grp_temp_held = SGroupCaller.Create("grp_temp_held")
			groupcaller.ItemGetSquadsHeld(item, grp_temp_held)
			local relationship = Util_GetRelationship(sgroup, grp_temp_held)
			SGroupCaller.Destroy(grp_temp_held)
			if relationship == R_ALLY then
				bCanLoad = false
			end
		end
		
		local _canLoadSgroup = function(sgid, indx, sid)
			print(BP_GetName(Entity_GetBlueprint(item)))
			if not groupcaller.CanItemLoadSquad(item, sid, true, false) then
				return false
			end
			return true
		end
		
		if not SGroup_ForEach(sgroup, _canLoadSgroup) then
			bCanLoad = false
		end
		
 		if bCanLoad then
			local distance = World_DistancePointToPoint(Util_GetPosition(pos), Util_GetPosition(item))
			if distance < closestdistance then
				closestdistance = distance
				closestitem = item
			end
		end
		
	end

	if closestitem ~= nil then	
		local grp_temp_garrison = groupcaller.Create("grp_temp_garrison")
		groupcaller.AddItem(grp_temp_garrison, closestitem)
		Cmd_Garrison(sgroup, grp_temp_garrison, false, true)
		groupcaller.Destroy(grp_temp_garrison)
	end

	groupcaller.Destroy(grp_temp_nearby)
	return closestitem

end

local __GetUnitConcentration = function(player, groupcaller, bPopcapOnly, includeBPs, excludeBPs, bLeastConcentrated, marker)
	
	if bLeastConcentrated == nil then bLeastConcentrated = false end
	
	-- in this function, 'item' refers to squad or entity, based on the query being made
	
	if includeBPs ~= nil and excludeBPs ~= nil then
		error("GetUnitConcentration: can't include and exclude blueprints at the same time!")
	end
	
	local playersToGather = player
	if type(player) == "table" then
		if scartype(player) == ST_PLAYER then
			playersToGather = { player }
		end
	end
	
	local scorefunction = function(item)
		local score = 0
		-- population?
		local pop = groupcaller.GetItemPopulationScore(item)
		score = score + pop
		if not bPopcapOnly then
			-- hp?
			local health = groupcaller.GetItemHealthScore(item) / 200
			score = score + health
			-- resource cost?
			local cost = groupcaller.GetItemCostScore(item) / 200
			score = score + cost
		end
		return score
	end
	
	local IsValidItem = function(item)
		local valid = true
		local bp = groupcaller.GetItemBlueprint(item)
		local FindBP = function(bp, bptable)
			for k,v in pairs(bptable) do
				if bp == v then
					return true
				end
			end
		end
		if includeBPs ~= nil then
			valid = FindBP(bp, includeBPs)
		end
		if excludeBPs ~= nil then
			valid = not FindBP(bp, excludeBPs)
		end
		return valid
	end
	
	-- get list of items to look at
	local grp
	grp = groupcaller.CreateIfNotFound("GetUnitConcentration(1)")
	groupcaller.ClearItems(grp)
	if type(marker) == "table" then
		if scartype(marker) == ST_MARKER then
			marker = {marker}
		end

		for i, gatherPlayer in pairs(playersToGather) do
			for k,v in pairs(marker) do
				groupcaller.GetItemsNearMarker(grp, gatherPlayer, v, OT_Player)
			end
		end
	else
		for i, gatherPlayer in pairs(playersToGather) do
			local playerItems
			playerItems = groupcaller.GetPlayerItems(gatherPlayer)
			groupcaller.AddGroup(grp, playerItems)
		end
	end
	
	-- prune list of items
	local validitems = {}
	for i = 1, groupcaller.GetSpawnedCount(grp) do
		local item = groupcaller.GetSpawnedItemAt(grp, i)
		if IsValidItem(item) then
			table.insert(validitems, item)
		end
	end
	
	-- nothing to return!
	if table.getn(validitems) == 0 then
		return nil
	end
	
	-- get table of {item, position, selfscore}: O(N)
	local numitems = table.getn(validitems)
	itemtable = {}
	local i = 1
	for k,v in pairs(validitems) do
		local item = v
		local pos = groupcaller.GetItemPosition(item)
		local selfscore = scorefunction(item)
		itemtable[i] = {item, pos, selfscore}
		i = i + 1
	end
	
	-- adjust scores based on proximity to other items: O(N^2)
	for i = 1, numitems do
		-- start with self score, and add score for being close to other items
		local score = itemtable[i][3]
		for j = 1, numitems do
			if i ~= j then
				local distance = World_DistancePointToPoint(itemtable[i][2], itemtable[j][2])
				distance = math.max(0.5, distance)
				if distance < 20 then
					score = score + itemtable[j][3] / distance
				end
			end
		end
		itemtable[i][4] = score
	end
	
	-- find the best item for this query: O(N)
	local bestitem
	local bestscore = 0
	if bLeastConcentrated == true then bestscore = 99999 end
	for i = 1, numitems do
		local score = itemtable[i][4]
		local is_best = ((score < bestscore) == bLeastConcentrated)
		if is_best then
			bestscore = score
			bestitem = itemtable[i][1]
		end
	end
	
	local grpConcentrated = groupcaller.CreateIfNotFound("GetUnitConcentration(2)")
	groupcaller.ClearItems(grpConcentrated)
	groupcaller.AddItem(grpConcentrated, bestitem)
	
	return grpConcentrated

end

-- Check if the table is a team or not
__isTableTeam = function(tableid)
	local isTeam = true
	for i = 1, table.getn(tableid) do
		if scartype(tableid[i]) ~= ST_PLAYER then return false end
	end
	return true
end

-- must be global since it's used as a callback
__OnSpawnActionComplete = function(executer, squad, pos)

	if scartype(executer) == ST_ENTITY then
		local id = Entity_GetGameID(executer)
		local groupname = __t_SquadIntoSGroupMapping[id]
		if type(groupname) == "string" and SGroup_Exists(groupname) then
			local sg = SGroup_FromName(groupname)
			SGroup_Add(sg, squad)
		end
		-- we don't know when it's "done" spawning squads, so we can never remove the table entry
		
		__ApplyRoleVariation(squad)
	end

end

-- special internal function that will apply an animator state
-- to the spawned squad depending on the presets set for this particular mission
__ApplyRoleVariation = function(sgroup)
	
	-- check to see if the role variation is actually a squad
	if scartype(sgroup) == ST_SQUAD then
		local sg = SGroup_CreateIfNotFound("_sg_rolevariation")
		SGroup_Add(sg, sgroup)
		sgroup = sg
	end
	
	if sg ~= nil then
		SGroup_Destroy(sg)
	end

end

-- checks the paradrop squad and applies the role variation once the squad has
-- be completely spawned on the map.
__ParadropSquadFull = function()

	for i=table.getn(__t_paradrop_squads), 1, -1 do
		
		if SGroup_CountSpawned(__t_paradrop_squads[i][1]) > 0 then
			SGroup_AddGroup(__t_paradrop_squads[i][2], __t_paradrop_squads[i][1])
		end
		
		if SGroup_CountSpawned(__t_paradrop_squads[i][1]) > 0 then
			
			-- first check if the loadout for the squads has been specified by the designer.
			local loadout = __t_paradrop_squads[i][3]
			
			-- otherwise just use the maximum squad size to determine the number of soldiers that need to be spawned
			-- before applying the role variation
			if loadout == 0 then
				loadout = Squad_GetMax(SGroup_GetSpawnedSquadAt(__t_paradrop_squads[i][1], 1))
			end
			
			if SGroup_TotalMembersCount(__t_paradrop_squads[i][1]) == loadout 
			or Timer_GetRemaining(__t_paradrop_squads[i][4]) == 0 then
				print("Timer: "..Timer_GetRemaining(__t_paradrop_squads[i][4]))
				__ApplyRoleVariation(__t_paradrop_squads[i][1])
				SGroup_Destroy(__t_paradrop_squads[i][1])
				table.remove(__t_paradrop_squads, i)
			end
		end
	
	end
	
	if table.getn(__t_paradrop_squads) == 0 then
		Rule_RemoveMe()
	end

end

--? @group scardoc;Util

--? @shortdesc E-mails a warning out with logfiles at the end of the game.
--? @extdesc This is similar to fatal() only the game will continue on. Use the ErrorMessage to dump out relevent information to the scarlog
--? @extdesc Example: bug( "This shouldn't happen, fix "..problem.here)
--? @args ErrorMessage errormessage
function bug(errormessage)
	warning(errormessage)
end


--? @shortdesc Converts a 2D top down position to a 3D ScarPosition.
--? @extdesc
--? 3D ScarPositions have the x axis left to right, the z axis in to out, and the y axis down to up (y axis represents the height of the terrain).  Use this function to convert a top-down 2D position to a 3D world position.\n\n
--? Note: (0,0) is in the center of the map.
--? @result Position, if y-height is nil, y-height = ground height, terrain ground or walkable
--? @args Real xpos, Real zpos, Real ypos
function Util_ScarPos(xpos, zpos, ypos)
	if ypos == nil then
		ypos = World_GetHeightAt(xpos,zpos)
	end
	return World_Pos(xpos, ypos, zpos)
end

--? @shortdesc Spawns a demo charge at a position and returns an egroup
--? @extdesc Use this instead of World_SpawnDemolitionCharge if you need to manage it
--? @result EGroupID
--? @args PlayerID player, MarkerID/Pos location
function Util_SpawnDemoCharge(player, position)

	World_SpawnDemolitionCharge(player, Util_GetPosition(position))
	
	local eg = EGroup_Create("")
	
	Player_GetAllEntitiesNearMarker(player, eg, position, 5)
	
	EGroup_Filter(eg, BP_GetEntityBlueprint("demo_charge"), FILTER_KEEP)
	
	return eg

end


--? @shortdesc Creates a given number of entities at a location and adds them to an egroup. A PlayerID of nil will create the entities as world objects.
--? @args PlayerID player, EGroupID egroup, Integer blueprintID, MarkerID/Pos location, Integer numentities[, MarkerID/Pos toward]
--? @result Void
function Util_CreateEntities(playerid, egroupid, blueprintID, pos, numentities, toward)

	-- if we passed in a marker rather than a pos, then convert it now
	if (scartype(pos) == ST_MARKER) then
		if toward == nil then
			local dir = Marker_GetDirection(pos)
			toward = Marker_GetPosition(pos)
			toward.x = toward.x + dir.x * 100
			toward.y = toward.y + dir.y * 100
			toward.z = toward.z + dir.z * 100
		end
		pos = Marker_GetPosition(pos)
	end
	
	if toward == nil then
		toward = pos
	elseif scartype(toward) == ST_MARKER then
		toward = Marker_GetPosition(toward)
	end
	
	-- do some type checking
	if (scartype(blueprintID) ~= ST_PBG) then fatal("Util_CreateEntites: Blueprint is invalid") end
	if (scartype(pos) ~= ST_SCARPOS) then fatal("Util_CreateEntites: Position/MarkerID is invalid") end
	if (scartype(numentities) ~= ST_NUMBER) then fatal("Util_CreateEntites: Number of entities is invalid") end
	
	for i = 1, numentities do
		
		local entityid = nil
		if playerid == nil then
			entityid = Entity_CreateENV(blueprintID, pos, toward)					-- create the entity as a world object
		else
			entityid = Entity_Create(blueprintID, playerid, pos, toward)			-- create the entity as a player unit
			Entity_Spawn(entityid)													-- spawn it
		end
		
		if (Entity_IsBuilding(entityid) == true) then								-- if it's a building then make it fully constructed
			Entity_ForceConstruct(entityid)
		end
		
		if (egroupid ~= nil) then
			if scartype(egroupid) == ST_TABLE then
				for i = 1, table.getn(egroupid) do
					EGroup_Add(egroupid[i], entityid)
				end
			else
				EGroup_Add(egroupid, entityid)											-- add to group
			end
		end
		
	end

end


--? @shortdesc High level function to create squads and give them basic orders upon spawning. Detailed explanation found in ScarUtil.scar
--? @args PlayerID player, SGroupID/Table/String sgroup, SquadBlueprint/Table sbp, Marker/Pos/SGroup/EGroup spawn_point[, Position destination, Integer numsquads, Integer loadout, Boolean attackmove, Position dest_facing, UpgradeBlueprint/Table upgrades, Position spawn_facing]
--? @extdesc
--? PlayerID player - player who will own the squads
--? SGroupID/Table/String sgroup - sgroup that receives the new squads. 
--?		Can be nil if you don't need to manage the new squads or a string if you want to create a new sgroup with that name.
--?		If a table is given, the first item will be used as the return sgroup.
--? SquadBlueprint sbp - the blueprint for the new squads. can be a table of blueprints, in which case a random blueprint will be chosen for each squad
--? Position location - where to spawn the squads (can be any parameter type whose position can be queried)
--? 	SGroup - If the sgroup is a Hold Entity then the squad is spawned inside of it.
--? 	EGroup - If the egroup is a hold entity then the squad is spawned inside of it.
--? 	NOTE: if the hold is destroyed, or is full, or due to any other misc. failure case, then the squad is spawned at the player's map entry point.
--? 	Pos - the squad is spawned at this location.
--? 	Marker - the squad is spawned at the marker and facing the direciton of the marker.
--? 
--? Position destination - (OPTIONAL) where the squads will move to, load into, or attack
--? 	SGroup can mean two different things, if the Sgroup is owned by the player and a hold then try to enter it.  Or if the SGroup is an enemy squad, then the spawned squad should attack move the enemy.  If neither is true, then the squad just moves to the location.
--? 	EGroup should be treated the same as the SGroup.
--? 	Position/Marker: the squad moves to the location.
--? 	Sync weapon: the squad captures the sync weapon.
--? 
--? Integer numsquads - (OPTIONAL) how many squads to spawn
--? Integer loadout - (OPTIONAL) max amount of units to spawn per squad
--? Boolean attackmove - (OPTIONAL) in cases where the squads do a simple move to their destination (not attacking or loading into anything), this determines whether they attack move or not
--? Position facing - (OPTIONAL) in cases where the squads do a simple move to their destination, this determines their facing once they reach their destination. If facing is not specified, and the squad is moving to a marker, the marker's facing is used.
--? UpgradeBlueprint upgrades - (OPTIONAL) upgrade(s) to instantly apply to squads when they spawn
--? @refs http://relicjira.thqinc.com/confluence/display/COHXP/Util_CreateSquads
--? @result SGroup
function Util_CreateSquads(player, sgroup, sbp, location, destination, numsquads, loadout, attackmove, dest_facing, upgrades, spawn_facing)

	if numsquads == nil then numsquads = 1 end
	if loadout == nil then loadout = 0 end
	
	local spawnpos
	local spawntoward
	local loctype = scartype(location)
	if loctype == ST_SGROUP then
		spawnpos = SGroup_GetPosition(location)
		spawntoward = spawnpos
	elseif loctype == ST_EGROUP then
		spawnpos = EGroup_GetPosition(location)
		spawntoward = spawnpos
	elseif loctype == ST_MARKER then
		spawnpos = Marker_GetPosition(location)
		local dir = Marker_GetDirection(location)
		spawntoward = Marker_GetPosition(location)
		spawntoward.x = spawntoward.x + (dir.x * 100)
		spawntoward.y = spawntoward.y + (dir.y * 100)
		spawntoward.z = spawntoward.z + (dir.z * 100)
	elseif loctype == ST_SCARPOS then
		spawnpos = location
		spawntoward = spawnpos
	else
		fatal("Util_CreateSquads: invalid location type " .. scartype_tostring(location))
	end
	
	-- allow facing override
	if spawn_facing then
		spawntoward = Util_GetPosition(spawn_facing)
	end
	
	local GroupCanLoadSquad = function(group, squad)
		local groupcaller = __GetGroupCaller(group)
		for i = 1, groupcaller.GetSpawnedCount(group) do
			local holdsquad = groupcaller.GetSpawnedItemAt(group, i)
			if groupcaller.CanItemLoadSquad(holdsquad, squad, false, false) then
				return true
			end
		end
		return false
	end
	
	
	--Automatically create a new sgroup if received string
	local sg_tempSgroup = nil
	if scartype(sgroup) == ST_TABLE then
		if(scartype(sgroup[1]) == ST_SGROUP) then
			sg_tempSgroup = sgroup[1]
		elseif(scartype(sgroup[1]) == ST_STRING) then
			sg_tempSgroup = SGroup_CreateIfNotFound(sgroup[1])
		end
	else
		if(scartype(sgroup) == ST_SGROUP) then
			sg_tempSgroup = sgroup
		elseif(scartype(sgroup) == ST_STRING) then
			sg_tempSgroup = SGroup_CreateIfNotFound(sgroup)
		end
	end
		
	
	for i = 1, numsquads do
		-- spawn it
		local bp = sbp
		if scartype(sbp) == ST_TABLE then
			bp = sbp[World_GetRand(1, table.getn(sbp))]
		end
		
		local squad = Squad_CreateAndSpawnToward(bp, player, loadout, spawnpos, spawntoward)
		if squad ~= nil then
			if(sg_tempSgroup ~= nil) then
				SGroup_Add(sg_tempSgroup, squad)
			end
		
			if scartype(sgroup) == ST_TABLE then
				for i = 1, table.getn(sgroup) do
					SGroup_Add(sgroup[i], squad)
				end
			end
		
			-- kludgy special code that will apply a special state machine to the squad entities that
			-- will spawn during the mission and apply that role variation to the soldiers in the squad
	--~ 		__ApplyRoleVariation(sgroup)
		
			local sg_util_temp = __GetTempGroup(squad)
		
			-- apply requested upgrades
			if upgrades then
				Cmd_InstantUpgrade(sg_util_temp, upgrades)
			end
		
			-- load it into something (if necessary)
			local groupcaller = __GetGroupCaller(location)
			if groupcaller ~= nil then
			
				local canload = GroupCanLoadSquad(location, squad)
				if canload == true then
					Cmd_Garrison(sg_util_temp, location, true, true, true)
				else
					-- to be on the safe side, move non-loaded squads to the map entry point.
					-- possible reasons could be: location destroyed, location full
					if Player_HasMapEntryPosition(player) then
						print("Util_CreateSquads: FYI a squad could not be loaded into '" .. groupcaller.GetName(location) .. "'")
						Squad_WarpToPos(squad, Player_GetMapEntryPosition(player))
					else
						print("Util_CreateSquads: couldn't load/garrison squad, or spawn it at map entry position. it got spawned at the site of the egroup/sgroup...")
					end
				end
			
			end
		
			-- move it to its destination (if any)
			if destination ~= nil then
			
				-- if they're not loaded, this shouldn't do anything
				Cmd_UngarrisonSquad(sg_util_temp, destination, true)
			
				local groupcaller = __GetGroupCaller(destination)
				if groupcaller ~= nil then
					local relationship = Util_GetRelationship(player, destination)
					if relationship == R_ALLY then
						-- try to load into it
						if GroupCanLoadSquad(destination, squad) then
							Cmd_Garrison(sg_util_temp, destination, true, true)
						else
							destination = groupcaller.GetPosition(destination) -- just move here
						end
					elseif relationship == R_ENEMY then
						-- attack enemy sgroup
						Cmd_AttackMove(sg_util_temp, destination, true)
					elseif relationship == nil then
						-- check if it's an available sync weapon
						local swid = groupcaller.GetSyncWeaponID(destination)
						if SyncWeapon_IsOwnedByPlayer(swid, nil) then
							Cmd_CaptureTeamWeapon(sg_util_temp, destination)
						else
							destination = Util_GetPosition(destination) -- just move here (syncweapon not available)
						end
					end
				end
			
				-- convert marker to position/facing if necessary
				if scartype(destination) == ST_MARKER then
					if dest_facing == nil then
						local dir = Marker_GetDirection(destination)
						dest_facing = Marker_GetPosition(destination)
						dest_facing.x = dest_facing.x + dir.x
						dest_facing.y = dest_facing.y + dir.y
						dest_facing.z = dest_facing.z + dir.z
					end
					destination = Marker_GetPosition(destination)
				end
			
				-- fallback on a regular move (possibly attackmove)
				if scartype(destination) == ST_SCARPOS then
					if attackmove == true then
						Cmd_AttackMove(sg_util_temp, destination, true)
					else
						Cmd_Move(sg_util_temp, destination, true, nil, dest_facing)
					end
				end
			
			end
		
			SGroup_Destroy(sg_util_temp)
		end
	end
	
	return sg_tempSgroup

end

--? @shortdesc Returns the player owner for any of: entity, squad, egroup, sgroup, player. for groups, the first item is used. Returns nil for world owned or empty groups
--? @args entity/squad/egroup/sgroup/player Object
--? @result PlayerID
function Util_GetPlayerOwner(thing)

	local original_type = scartype_tostring(thing)
	
	if scartype(thing) == ST_SGROUP then
		if SGroup_CountSpawned(thing) == 0 then
			return nil
		end
		thing = SGroup_GetSpawnedSquadAt(thing, 1)
	elseif scartype(thing) == ST_EGROUP then
		if EGroup_CountSpawned(thing) == 0 then
			return nil
		end
		thing = EGroup_GetSpawnedEntityAt(thing, 1)
	end
	
	if scartype(thing) == ST_SQUAD then
		if World_OwnsSquad(thing) then
			return nil
		end
		thing = Squad_GetPlayerOwner(thing)
	elseif scartype(thing) == ST_ENTITY then
		if World_OwnsEntity(thing) then
			return nil
		end
		thing = Entity_GetPlayerOwner(thing)
	end
	
	if scartype(thing) ~= ST_PLAYER then
		fatal("Util_GetPlayerOwner: invalid type " .. original_type)
	end
	
	return thing
	
end

--? @shortdesc Returns the distance between two objects
--? @args entity/squad/egroup/sgroup/marker/pos Object1, entity/squad/egroup/sgroup/marker/pos Object2
--? @result Real
function Util_GetDistance(thing1, thing2)

	local distance = World_DistancePointToPoint(Util_GetPosition(thing1), Util_GetPosition(thing2))
	
	return distance
	
end

--? @shortdesc Sets the player owner for an entity, squad, egroup or sgroup. Also sets player owner of whatever is garrisoned inside them
--? @args entity/squad/egroup/sgroup Object, PlayerID owner[, Boolean bApplyToSquadsHeld=true]
--? @result Void
function Util_SetPlayerOwner(thing, owner, bApplyToSquadsHeld)

	if bApplyToSquadsHeld == nil then bApplyToSquadsHeld = true end
	
	SGroup_Clear(sg_temp)
	
	if scartype(thing) == ST_ENTITY then
		Entity_SetPlayerOwner(thing, owner)
		Entity_GetSquadsHeld(thing, sg_temp)
	elseif scartype(thing) == ST_EGROUP then
		EGroup_SetPlayerOwner(thing, owner)
		EGroup_GetSquadsHeld(thing, sg_temp)
	elseif scartype(thing) == ST_SQUAD then
		Squad_SetPlayerOwner(thing, owner)
		Squad_GetSquadsHeld(thing, sg_temp)
	elseif scartype(thing) == ST_SGROUP then
		SGroup_SetPlayerOwner(thing, owner)
		SGroup_GetSquadsHeld(thing, sg_temp)
	else
		fatal("Util_SetPlayerOwner: invalid type " .. scartype_tostring(thing))
	end
	
	if bApplyToSquadsHeld == true then
		local _SquadHeld = function(gid, idx, sid)
			Squad_SetPlayerOwner(sid, owner)
		end
		SGroup_ForEach(sg_temp, _SquadHeld)
	end
	
end

--? @shortdesc Gets the relationship between two of: entity, squad, egroup, sgroup, player. for groups, the first item is used.
--? @args entity/squad/egroup/sgroup/player Object_1, entity/squad/egroup/sgroup/player Object_2
--? @result Integer --> R_ENEMY, R_ALLY, R_NEUTRAL, R_UNDEFINED, or nil (if world owned or invalid parameters)
function Util_GetRelationship(thing1, thing2)

	thing1 = Util_GetPlayerOwner(thing1)
	thing2 = Util_GetPlayerOwner(thing2)

	if scartype(thing1) == ST_PLAYER and scartype(thing2) == ST_PLAYER then
		return Player_GetRelationship(thing1, thing2)
	else
		return nil
	end
	
end

--? @shortdesc Returns a position relative to a entity/squad/egroup/sgroup/marker/position's current position and orientation.
--? @args entity/squad/egroup/sgroup/marker/position pos, Integer offset, Real distance
--? @result Position
function Util_GetOffsetPosition(pos, offset, distance)

	-- simplify egroup/sgroup queries to their first item
	if scartype(pos) == ST_EGROUP then
		pos = EGroup_GetSpawnedEntityAt(pos, 1)
	elseif scartype(pos) == ST_SGROUP then
		pos = SGroup_GetSpawnedSquadAt(pos, 1)
	end
	
	if scartype(pos) == ST_ENTITY then
		return Entity_GetOffsetPosition(pos, offset, distance)
	elseif scartype(pos) == ST_SQUAD then
		return Squad_GetOffsetPosition(pos, offset, distance)
	elseif scartype(pos) == ST_MARKER then
		return World_GetOffsetPosition(Marker_GetPosition(pos), Marker_GetDirection(pos), offset, distance)
	elseif scartype(pos) == ST_SCARPOS then
		return World_GetOffsetPosition(pos, World_Pos(0,0,1), offset, distance)
	else
		fatal("Util_GetOffsetPosition: unsupported type " .. scartype_tostring(pos))
	end
	
end

--? @shortdesc Returns a relative offset position to an element
--? @args entity/squad/egroup/sgroup/marker/position element, entity/squad/egroup/sgroup/marker/position pos
--? @result Offset
function Util_GetRelativeOffset(element, target)
	
	local _tDir = {OFFSET_BACK, OFFSET_BACK_LEFT, OFFSET_BACK_RIGHT, OFFSET_FRONT, OFFSET_FRONT_LEFT, OFFSET_FRONT_RIGHT, OFFSET_LEFT, OFFSET_RIGHT}
	local closest = 99999999
	local dir = nil
	
	for i = 1, table.getn(_tDir) do
		local pos = Util_GetOffsetPosition(Util_GetPosition(element), _tDir[i], 5)
		local dist = Util_GetDistance(pos, Util_GetPosition(target))
		if dist < closest then
			closest = dist
			dir = _tDir[i]
		end
	end
	
	return dir

end

--? @group scardoc;FOW

--? @shortdesc Reveals an area the size of a given markers proximity at that markers position for a given amount of time. Pass in a duration of 1 for indefinite duration. YOU SHOULD ONLY CALL THIS ONCE FOR EACH AREA. 
--? @extdesc This function will reveal the FOW for ALL alive players. This does not work with markers with rectangular proximity type
--? @args MarkerID marker, Real duration
--? @result Void
function FOW_RevealMarker( markerid, duration )

	-- only work with circular proximity markers
	if ( Marker_GetProximityType( markerid ) ~= PT_Circle ) then
		return;
	end
	
	local markerpos = Marker_GetPosition( markerid )
	local markerprox = Marker_GetProximityRadius( markerid )

	-- reveal the area
	FOW_RevealArea( markerpos, markerprox, duration )

end


--? @shortdesc Unreveals an area the size of a given markers proximity at that markers position. YOU SHOULD ONLY CALL THIS ONCE FOR EACH AREA. 
--? @extdesc This does not work with markers with rectangular proximity type
--? @args MarkerID marker
--? @result Void
function FOW_UnRevealMarker( markerid )

	-- only work with circular proximity markers
	if ( Marker_GetProximityType( markerid ) ~= PT_Circle ) then
		return;
	end
	
	local markerpos = Marker_GetPosition( markerid )
	local markerprox = Marker_GetProximityRadius( markerid )

	-- reveal the area
	FOW_UnRevealArea( markerpos, markerprox )

end



--? @group scardoc;Util

function _GetGroupByBP( srcID, destID, groupcaller, bp )
	if( srcID == destID ) then
		fatal( "Function does not support the same source and destination groups")
	end
	
	local CheckBP = function( groupid, itemindex, itemid )
		
		if( groupcaller.GetItemBlueprint( itemid ) == bp ) then
			-- blueprint matches, add to dest group
			groupcaller.AddItem( destID, itemid )
		end
	end

	groupcaller.ForEach( srcID, CheckBP )
end


--? @shortdesc Find all the squads with a given blueprint in sourcegroup and add them to destgroup.
--? @result Void
--? @args SGroupID sourcegroup, SGroupID destgroup, SquadBlueprint sbp
--? @extdesc See also: SGroup_Filter()
function Util_GetSquadsByBP( sourcegroupid, destgroupid, sbp )

	_GetGroupByBPID(
		sourcegroupid,
		destgroupid,
		SGroupCaller,
		sbp
	)
end


--? @shortdesc Find all the entities with a given blueprint in sourcegroup and add them to destgroup.
--? @result Void
--? @args EGroupID sourcegroup, EGroupID destgroup, EntityBlueprint ebp
--? @extdesc See also: EGroup_Filter()
function Util_GetEntitiesByBP( sourcegroupid, destgroupid, ebp )
	_GetGroupByBPID(
		sourcegroupid,
		destgroupid,
		EGroupCaller,
		ebp
	)
end

--? @shortdesc Returns trailing numbers from a string, if it exists, nil otherwise. E.G. "marker23" would return 23.
--? @result Number
--? @args String val
function Util_GetTrailingNumber( val )

	local trail = nil
	for d in string.gfind( val, "%a+(%d+)" ) do
		trail = d
	end

	return trail

end

--? @shortdesc Play an events file at a given markers location
--? @result void
--? @args String markername, String eventfile
function Util_MarkerFX( markername, eventfile )
	World_FXEvent( eventfile, Marker_GetPosition( Marker_FromName( markername, "basic_marker" ) ) )
end




--? @shortdesc Play an Intel Event. These are medium priority, and will interrupt a ambient, but not an NIS.
--? @extdesc This function should used instead of Event_Start because it handles priorities.
--? @result Void
--? @args LuaFunction func
function Util_StartIntel( func )
	
	if(__g_playIntelEvents) then
		Event_Start( func, EVENT_INTEL ) 			-- medium priority
	end
--	Game_StartIntel(func, __Private_Util_DoNothing)
end


--? @shortdesc Play Nislet Event. Starts a Nislet event, and calls back a function for post-nislet setup if the Nislet is skipped. noFadeIn stops the system from fading back into gameplay when the player skips
--? @result Void
--? @args LuaFunction event, LuaFunction skippedCallback, bool noFadeIn, int fadeInTime
function Util_StartNislet(event, skippedCallback, noFadeIn, fadeInTime)	
	if Rule_Exists(_NisletIsStarting) or Rule_Exists(_NisletIsFinished) then
		fatal("Only one Nislet can be queued using Util_StartNislet at a time")
	end

	if(__g_playIntelEvents) then
		Game_StartMuted(true)
		
		__nisletFade = noFadeIn
		__nisletCallback = skippedCallback
		if fadeInTime == nil then
			fadeInTime = 3
		end
		__nisletFadeInTime = fadeInTime
		
		Rule_Add(_NisletIsStarting)
		Event_Start( event, EVENT_NIS )
	end
end

function _NisletIsStarting()
	if Event_IsAnyRunning(EVENT_NIS) == true then
		Util_SetPlayerCanSkipSequence(__nisletCallback, __nisletFade, __nisletFadeInTime)

		__nisletCallback = nil
		__nisletFade = nil
		
		__sequenceIsSkipped = false	
		Rule_Add(_NisletIsFinished)
		Rule_RemoveMe()
	end
end
function _NisletIsFinished()
	if Event_IsAnyRunning(EVENT_NIS) == false then
		Util_SetPlayerUnableToSkipSequence()
		Rule_RemoveMe()
	end
end

--? @shortdesc Returns whether the currently running sequence has been skipped
--? @result bool
function Util_IsSequenceSkipped()
	if __sequenceIsSkipped == nil then
		__sequenceIsSkipped = false
	end
	return __sequenceIsSkipped
end

--? @shortdesc Sets it so that a player can skip a scripted sequence. When the skip key is pressed, calls back the given function as a post-sequence setup. noFadeIn stops the system from fading back into gameplay when finished. Call Util_SetPlayerUnableToSkipSequence() when the sequence is finished to disable
--? @result Void
--? @args LuaFunction event, LuaFunction skippedCallback, bool noFadeIn[, int fadeInTime]
function Util_SetPlayerCanSkipSequence(skippedCallback, noFadeIn, fadeInTime)
	__nisletSkippedCallback = skippedCallback
	__playerCanSkipNislet = true
	__nisletSkippedFade = noFadeIn
	if fadeInTime == nil then
		fadeInTime = 3
	end
	__nisletSkippedFadeInTime = fadeInTime
end

function skipNIS()
	if __playerCanSkipNislet then 
		Util_SetPlayerUnableToSkipSequence()
		__sequenceIsSkipped = true
		__playerCanSkipNislet = false
		Rule_RemoveIfExist(_NisletIsFinished)
		
		Game_FadeToBlack(FADE_OUT, 0) 
		Game_EndSubTextFade()
		Game_EndTextTitleFade()
		Subtitle_EndAllSpeech()
		
		if __nisletSkippedCallback ~= nil then
			Rule_AddOneShot(__CallNisletSkippedCallback, 0.1)
		end		
		
		Rule_AddOneShot(__ResetSkippedFlag, 0.1)
		Rule_AddOneShot(_startNislet_setCam, 0.1)
		if __nisletSkippedFade ~= true then
			Rule_AddOneShot(_startNislet_fadeIn, __nisletSkippedFadeInTime)
		end
	end
end

function __CallNisletSkippedCallback()
	__nisletSkippedCallback()
	__nisletSkippedCallback = nil
end

--? @shortdesc Disables Util_SetPlayerCanSkipSequence
--? @result Void
--? @args LuaFunction event, LuaFunction skippedCallback, bool noFadeIn
function Util_SetPlayerUnableToSkipSequence()
	__playerCanSkipNislet = false
end

function __ResetSkippedFlag()
	__sequenceIsSkipped = false
end

function _startNislet_setCam()
	Camera_ResetToDefault()
end

function _startNislet_fadeIn()
	Game_FadeToBlack(FADE_IN, 0.5)
	Game_SetMode(UI_Normal)
end


--? @shortdesc Play a quick, one-line Intel event.  These are medium priority, and will interrupt ambient, but not an NIS.
--? @extdesc Use this when playing a single line.  For multi-line events, use Util_StartIntel 
--? @result Void
--? @args String actor, LocString speech
function Util_StartQuickIntel( actor, speech )
	local event = {}
	
	event.quickIntel = function()
		CTRL.Actor_PlaySpeech(actor, speech)
		CTRL.WAIT()
	end
	
	if(__g_playIntelEvents) then
		Event_Start( event.quickIntel, EVENT_INTEL ) 			-- medium priority
	end
--	Game_StartIntel(func, __Private_Util_DoNothing)
end


--? @shortdesc Play a movie.
--? @extdesc Plays a movie file after fading out the screen. Fades back in and triggers onComplete once it ends. If fadeIn < 0, does not face back in once complete.
--? @extdesc If onCompleteAfterMovie is true, the onComplete function will play as soon as the movie is over, instead of after the fade-in
--? @result Void
--? @args String name[, Integer fadeOut, Integer fadeIn, LuaFunction onComplete, Integer delay, Boolean onCompleteAfterMovie]
function Util_PlayMovie( name, fadeOut, fadeIn, onComplete, delay, onCompleteImmediate )
	
	if(delay == nil) then delay = 0 end
	if(fadeOut == nil) then fadeOut = 0 end
	if(fadeIn == nil) then fadeIn = 1.5 end
	if(onCompleteImmediate == nil) then onCompleteImmediate = false end
	
	__sitRep_name = name
	__sitRep_fadeOut = fadeOut
	__sitRep_fadeIn = fadeIn
	__sitRep_onComplete = onComplete
	__sitRep_onCompleteImmediate = onCompleteImmediate
	__sitRep_delay = delay
	
	Util_StartNIS(_sitRepEvent_Internal)
	
end

function _sitRepEvent_Internal()

	Game_FadeToBlack(FADE_OUT, __sitRep_fadeOut)
	
	if(__sitRep_fadeOut >0) then
		CTRL.Event_Delay(__sitRep_fadeOut)
		CTRL.WAIT()
	end
	
	Game_SetMode(UI_Cinematic)
	
	CTRL.SitRep_PlayMovie(__sitRep_name)
	CTRL.WAIT()
	
	Game_SetMode(UI_Normal)
	
	if (__sitRep_onComplete ~= nil and __sitRep_onCompleteImmediate == true) then Rule_AddOneShot(__sitRep_onComplete, __sitRep_delay) end
	
	if scartype(__sitRep_fadeIn) == ST_NUMBER 
	  and (__sitRep_fadeIn > 0) then
		CTRL.Game_FadeToBlack(FADE_IN, __sitRep_fadeIn)
		CTRL.WAIT()
		Game_FadeToBlack(FADE_IN, 0)	-- safety, this fixes the "not properly fading back in if skipped" bug
	else
		Game_FadeToBlack(FADE_OUT, 0)	-- safety, this fixes the "not properly fading back in if skipped" bug
	end
	
	if (__sitRep_onComplete ~= nil and __sitRep_onCompleteImmediate == false) then Rule_AddOneShot(__sitRep_onComplete, __sitRep_delay) end
	

end


--? @shortdesc Play a Speech Ambient. These are the lowest priority, and will be bumped by Intel Events or NIS's.
--? @extdesc This function should used instead of Event_Start because it handles priorities.
--? @result Void
--? @args LuaFunction func
function Util_StartAmbient( func )
	if(__g_playIntelEvents) then
		Event_Start( func, EVENT_AMBIENT ) 			-- low priotity
	end
end

--? @shortdesc Auto-generate an Ambient Event. These are Low priority, and will hopefully interrupt nothing.
--? @extdesc Takes a table of Actors and LOC numbers
--? @result Void
--? @args Table intelEventTable
function Util_AutoAmbient(t_events)

	if scartype(t_events) ~= ST_TABLE then
		fatal("invalid data for Util_AutoAmbient, parameter 1 must be a table")
	end
	
	local count = table.getn(t_events)
	
	if count == 0 then
		
		fatal("invalid number of speech lines for Util_AutoIntel, count = "..count)
		
	else
		
		local Intel = function()
			
			for k,v in pairs(t_events) do 
				if k~=1 then
					CTRL.Event_Delay(0.3)
					CTRL.WAIT()
				end

				if UI_IsTacticalMapShown() then
					return
				end
				
				-- debug step - until LOCstring ID's are in place - deg
				if scartype(v[2]) == 20 then
					CTRL.Game_TextTitleFade( v[2], .5, 5, .5 )
					CTRL.WAIT()
				else
					CTRL.Actor_PlaySpeechWithoutPortrait( v[1], v[2])
					CTRL.WAIT()
				end
			end
			
		end
		
		if(__g_playIntelEvents) then
			Event_Start( Intel, 3 ) -- medium priority
		end
		
	end
	
end


--? @shortdesc Auto-generate an Intel Event. These are medium priority, and will interrupt ambient, but not an NIS.
--? @extdesc Takes a table of parameters defining speaker(s) and line(s)
--? @result Void
--? @args Table intelEventTable
function Util_AutoIntel(t_events)

	if scartype(t_events) ~= ST_TABLE then
		fatal("invalid data for Util_AutoIntel, parameter 1 must be a table")
	end
	
	local count = table.getn(t_events[1])
	
	if count == 0 then
		
		fatal("invalid number of speech lines for Util_AutoIntel, count = "..count)
		
	else
		
		local Intel = function()
			
			for k,v in pairs(t_events) do 
				if k~=1 then
					CTRL.Event_Delay(0.3)
					CTRL.WAIT()
				end
				
				if UI_IsTacticalMapShown() then
					return
				end
				
				-- debug step - until LOCstring ID's are in place - deg
				if scartype(v[2]) == 20 then
					CTRL.Game_TextTitleFade( v[2], .5, 5, .5 )
					CTRL.WAIT()
				else
					CTRL.Actor_PlaySpeech( v[1], v[2])
					CTRL.WAIT()
				end
			end
			
		end
		
		if(__g_playIntelEvents) then
			Event_Start( Intel, 1 ) -- medium priority
		end
		
	end
	
end

NISLET_BLACK2GAME	= 1 -- starts in black and fades up, ends in gamplay
NISLET_GAME2GAME 	= 2 -- transitions from game play to letterbox and backto gameplay
NISLET_GAME2BLACK	= 3 -- starts in gameplay and ends in black
NISLET_GAME2LETTER	= 4 -- starts in gameplay and ends in letterbox mode
NISLET_TIME 		= 1 -- use seconds to wait on camera movements
NISLET_VO			= 2 -- use voice to wait on camera movements

--? @shortdesc Auto-generate an NISlet Event, a simple NIS meant to convey mission location. These are high priority, and will interrupt ambient and Intel Events.
--? @extdesc Takes an NISLET type and a table of parameters defining speaker(s) and line(s)
--? NISLET_BLACK2GAME	= 1 -- starts in black and fades up, ends in gamplay
--? NISLET_GAME2GAME 	= 2 -- transitions from game play to letterbox and backto gameplay
--? NISLET_GAME2BLACK	= 3 -- starts in gameplay and ends in black
--? NISLET_GAME2LETTER	= 4 -- starts in gameplay and ends in letterbox mode (for transition to sitrep)
--? NISLET_TIME 		= 1 -- use seconds to wait on camera movements
--? NISLET_VO			= 2 -- use voice to wait on camera movements
--?	t_eventes.nislet_start = {
--?		{camPos = pos1, waitType = NISLET_TIME, waitValue = 5},
--?		{camPos = pos2, waitType = NISLET_VO, waitValue = {ACTOR.GenericAlly, 000000}},
--?	}
--? @result Void
--? @args Integer nisletType, Table intelEventTable, [boolean bFOWvisible]
function Util_AutoNISlet(nisletType, eventTable, bFOWvisible)

	if scartype(eventTable) ~= ST_TABLE then
		fatal("invalid data for Util_AutoIntel, parameter 1 must be a table")
	end
	
	UI_HideTacticalMap()
	
	local count = table.getn(eventTable)
	
	if count == 0 then
		
		fatal("invalid number of speech lines for Util_AutoNislet, count = "..count)
		
	else
		if bFOWvisible == nil then
			bFOWvisible = false
		end
		
		local NISStart = function(int)
			if int == 1 then FOW_Enable(bFOWvisible) Game_FadeToBlack(false, 1) -- assumes already letterboxed
			else FOW_Enable(bFOWvisible) Game_Letterbox(true, 1) -- assumes no fade to black
			end
		end
		
		local NISEnd = function(int)
			if int == 3 then 
				FOW_Enable(true) Game_FadeToBlack(true, 1) -- assumes already letterboxed
			elseif int == 4 then
				FOW_Enable(true) -- assumes no fade to black and letterbox already enabled
			else 
				FOW_Enable(true) Game_Letterbox(false, 1) -- assumes no fade to black
			end
		end
		
		local NISlet = function()
			
			Camera_ResetToDefault()
			CTRL.Event_Delay(1)
				NISStart(nisletType)
			CTRL.WAIT()
			
			for k,v in pairs(eventTable) do 
				if k~=1 then
					
					CTRL.Event_Delay(0.3)
					CTRL.WAIT()
				end
				
				-- brw 08/09/07 currently leaving this as a bug since it's been this way since the
				-- start, will change later...next project?
				-- should be scartype(v.camPos) == ST_SGROUP
				if v.camPos == ST_SGROUP then
					Camera_Follow(v.camPos)
				elseif v.camPos == false then
					-- don't move the camera
				else
					Camera_MoveTo(Util_GetPosition(v.camPos), true, SLOW_CAMERA_PANNING)
				end
				
				if v.waitType == 1 then
					CTRL.Event_Delay(v.waitValue)
					CTRL.WAIT()
				elseif v.waitType == 2 then
					
					-- debug step - until LOCstring ID's are in place - deg
					if scartype(v.waitValue[2]) == 20 then
						CTRL.Game_TextTitleFade( v.waitValue[2], .5, 5, .5 )
						CTRL.WAIT()
					else
						CTRL.Actor_PlaySpeech( v.waitValue[1], v.waitValue[2])
						CTRL.WAIT()
					end
					
				end
				
			end
			
			CTRL.Event_Delay(1)
				NISEnd(nisletType)
			CTRL.WAIT()
			
		end
		
		if(__g_playIntelEvents) then
			Event_Start( NISlet, 0 ) -- high priority
		end
		
	end
	
end


--? @shortdesc Play the mission title fade.
--? @result Void
--? @args LocString title[, Int time_fade_in, Int lifetime, Int time_fade_out]
function Util_MissionTitle( title, fadein, lifetime, fadout )
	
	-- NOTE: this function could easily be made to wait for 2 seconds if designers want to wait on it
	local gameTitle = function()
		-- params: loc_str, fade_in_secs, lifetime_secs, fade_out_secs
		if fadein == nil then
			fadein = .5
		end
		if lifetime == nil then
			lifetime = 3
		end
		if fadeout == nil then
			fadeout = 2
		end
		CTRL.Game_TextTitleFade( title, fadein, lifetime, fadeout )
		CTRL.WAIT()
	end
	
	-- we will try it as an Intel Event first
	-- the IE's and NIS's have different sets of priorities
	Util_StartIntel(gameTitle)
end

--? @shortdesc Library function to trigger NIS event under a certain sets of conditions.  NOTE: if checking against a marker DO NOT specify a range.  The range of the marker set in the WorldBuilder will be used.
--? @extdesc triggering event when one of the player's squads come near a particular SGroup, EGroup, Marker, or Position and that squad is onscreen, and that squad is not in combat.
--? @extdesc 6 arguments when using marker, 7 arguments when using position, egroup and sgroup with the additional range value
--? @extdesc non_combat set to TRUE means the squad cannot be in combat if the event is to be triggered.
--? @extdesc onscreen_only set to TRUE means the squad must be onscreen if the event is to be triggered.
--? @result Void
--? @args PlayerID playerid, Marker/EGroup/SGroup/ScarPos position, Int range, LuaFunction func, Boolean non_combat, Boolean onscreen_only, Int onscreen_duration

function Util_TriggerEvent(...) 

	-- grab the arguments
	local playerid = arg[1]
	local marker = nil
	local pos
	local egroupid
	local sgroupid
	local range
	local i
	
	if ( scartype( playerid ) ~= ST_PLAYER ) then fatal("playerid is not a valid player ID") 				end

	if (table.getn(arg) == 6) then
	
		local marker = arg[2]
		
		if ( scartype( marker ) ~= ST_MARKER ) then fatal("MarkerID is invalid") end
		
		marker = pos
		pos = nil
		
		i = 2
		
	elseif (table.getn(arg) == 7) then
		
		local target = arg[2]
		
		-- Check what type of target is passed in
		if (scartype(target) == ST_SCARPOS) then
			pos = target
		elseif (scartype(target) == ST_SGROUP) then
			sgroupid = target
		elseif (scartype(target) == ST_EGROUP) then
			egroupid = target
		else
			fatal("target is neither ScarPos, SGroupID or EGroupID")
		end

		-- Find range
		range = arg[3]
	
		if (scartype(range) ~= ST_NUMBER) then fatal("Range is invalid") end
		
		i = 3
	else
		fatal("Wrong number of arguments - should be 6 if using a marker, 7 if using a position, sgroup or egroup")
	end

	-- get the rest of the parameters
	local event = arg[i+1]
	local non_combat = arg[i+2]
	local onscreen_only = arg[i+3]
	local onscreen_duration = arg[i+4]
	
	-- do final parameter check
	if ( scartype( event ) 				~= ST_FUNCTION ) 	then fatal("event is not a valid funciton") 					end
	if ( scartype( non_combat ) 		~= ST_BOOLEAN ) 	then fatal("non_combat is not a valid boolean flag") 			end
	if ( scartype( onscreen_only ) 		~= ST_BOOLEAN ) 	then fatal("on_screen_only is not a valid boolean flag") 		end
	if ( scartype( onscreen_duration ) 	~= ST_NUMBER ) 		then fatal("on_screen_duration is not a valid boolean flag") 	end
	
	-- onscreen_duration is not used if onscreen_only is not set
	if ( onscreen_only == false ) then
		onscreen_duration = 0
	end

	------------------
	-- the rule to run
	function Rule_TriggerEvent()
		print( onscreen_duration )
		
		local success = false
		
		-- process sgroup target
		if (sgroupid ~= nil) then
		
			if ( SGroup_CountSpawned( sgroupid ) == 0 ) then
				Rule_RemoveMe()
				return
			end
			
			squad = SGroup_GetSpawnedSquadAt( sgroupid, 1 )
			
			if ( Prox_PlayerSquadsInProximityOfSquads( playerid, sgroupid, range, ANY, squad ) and
			     ( onscreen_only == false or Misc_IsSquadOnScreen( SGroup_GetSpawnedSquadAt( sgroupid, 1 ), 1.0 ) ) 
			   ) then
			   
			   success = true
			   
			   -- if the player squads needs to be non-combat, check for this
				if ( non_combat ) then
					local temp_sgroup = SGroup_Create( "temp_sgroup" )
					World_GetSquadsNearPoint( playerid, temp_sgroup, SGroup_GetPosition( sgroupid ), range, OT_Ally )
					
					if ( SGroup_IsUnderAttack( temp_sgroup, ANY, 2.0 ) ) then
						success = false
					end
					
					SGroup_Destroy( temp_sgroup )
				end
			end
		-- process egroup target
		elseif (egroupid ~= nil) then
			if ( Prox_PlayerSquadsInProximityOfEntities( playerid, egroupid, range, ANY ) and
				 ( onscreen_only == false or Misc_IsEntityOnScreen( EGroup_GetSpawnedEntityAt( egroupid, 1 ), 1.0 ) ) 
			   ) then
			   
			   success = true
			   
			   -- if the player squads needs to be non-combat, check for this
				if ( non_combat ) then
					local temp_sgroup = SGroup_Create( "temp_sgroup" )
					World_GetSquadsNearPoint( playerid, temp_sgroup, EGroup_GetPosition( egroupid ), range, OT_Ally )
					
					if ( SGroup_IsUnderAttack( temp_sgroup, ANY, 2.0 ) ) then
						success = false
					end
					
					SGroup_Destroy( temp_sgroup )
				end
			end
		-- process marker target
		elseif (marker ~= nil) then
			if ( Prox_IsPlayerNearMarker( playerid, marker, ANY ) and
				 ( onscreen_only == false or Misc_IsPosOnScreen( pos, 1.0 ) ) 
			   ) then
			   success = true
			   
			   -- if the player squads needs to be non-combat, check for this
				if ( non_combat ) then
					local temp_sgroup = SGroup_Create( "temp_sgroup" )
					World_GetSquadsNearMarker( playerid, temp_sgroup, marker, OT_Ally )
					
					if ( SGroup_IsUnderAttack( temp_sgroup, ANY, 2.0 ) ) then
						success = false
					end
					
					SGroup_Destroy( temp_sgroup )
				end
			end
		-- finally process positional target
		elseif (pos ~= nil) then
			if ( Prox_IsPlayerNearMarker( playerid, pos, range, ANY ) and
				 ( onscreen_only == false or Misc_IsPosOnScreen( pos, 1.0 ) ) 
			   ) then
			   success = true
			   
			   -- if the player squads needs to be non-combat, check for this
				if ( non_combat ) then
					local temp_sgroup = SGroup_Create( "temp_sgroup" )
					World_GetSquadsNearPoint( playerid, temp_sgroup, pos, range, OT_Ally )
					
					if ( SGroup_IsUnderAttack( temp_sgroup, ANY, 2.0 ) ) then
						success = false
					end
					
					SGroup_Destroy( temp_sgroup )
				end
			end
		end
		
		if ( success ) then
						
			-- count down the duration if successful
			onscreen_duration = onscreen_duration - 1
					
			if ( onscreen_duration <= 0 ) then
				Util_StartNIS(event)
			end
		else
			-- failed to keep the target on screen, will quit
			onscreen_duration = 0
		end
			
		--
		if ( onscreen_duration <= 0 ) then
			Rule_RemoveMe()
		end
		
	end
	
	Rule_AddInterval( Rule_TriggerEvent, 1 )
end

--? @shortdesc Try to garrison a loadable building within radius that is closer to the first squad of the sgroup than enemy
--? @extdesc Returns the entity id of the building that the squad try to garrison into. Return nil if nothing is found
--? @extdesc The squad suppression would be resetted before fallling back so that they would not succumb to pinned state
--? @result EntityID
--? @args SGroupID sgroupid, Int radius
function Util_FallBackToGarrisonBuilding( sgroupid, radius )

	-- check if the sgroup is empty or not
	if ( SGroup_CountSpawned( sgroupid ) == 0 ) then
		
		print("*** WARNING in Util_FallBackToGarrisonBuilding: SGroup is empty ***")
		
	else
		-- get the first squad of the sgroup 
		local squad = SGroup_GetSpawnedSquadAt( sgroupid, 1 )
		
		-- get the sgroup owner player
		local player = Util_GetPlayerOwner( sgroupid )
		
		-- get sgroup centre position
		local centre = SGroup_GetPosition( sgroupid )
		
		-- find all loadable buildings within the radius
		local eg = EGroup_Create( "temp" )
		World_GetEntitiesNearPoint( player, eg, centre, radius, OT_Neutral )
		World_GetEntitiesNearPoint( player, eg, centre, radius, OT_Ally )
		
		--print( "Entities found: "..EGroup_Count( eg ) )
		
		local building = nil
		
		local CheckEntity = function( groupid, itemindex, itemid )
			
			-- skip entities that are not loadable
			if ( Entity_CanLoadSquad( itemid, squad, true, false ) == false ) then
				--print( "Entity cannot load squad. Next!" )
				return false
			end
			
			local sg = SGroup_Create( "temp" )
			
			-- find the number of enemies near the building
			local numEnemies = World_GetSquadsNearPoint( player, sg, Entity_GetPosition( itemid ), radius, OT_Enemy )
			
			SGroup_Destroy( "temp" )		
			
			-- If the building doesn't have enemy near it, then the squad is save to load
			if ( numEnemies == 0 ) then
				
				-- print( "No enemy found nearby. Garrisoning..." )
				
				-- save the building EntityID
				building = itemid 
				
				local eg_building = EGroup_Create( "temp2" )
				EGroup_Add( eg_building, itemid )
				
				-- make sure the squad is not pinned right now
				SGroup_SetSuppression( sgroupid, 0 )
				
				-- garrison this building here
				Cmd_Garrison( sgroupid, eg_building, false )
				
				EGroup_Destroy( eg_building )
				
				-- do not continue the for loop
				return true
			end
			
			-- print( "Enemy nearby the building. Next!" )
			
			return false
		end
		
		EGroup_ForEach( eg, CheckEntity )
		
		EGroup_Destroy( eg )
		
		return building
		
	end
	
end



--? @shortdesc Returns a position that is distance metres from point A, headed in the direction of point B.
--? @extdesc You can also pass in a percentage (0.0 to 1.0) instead of a distance in metres.
--? @result Position
--? @args MarkerID/Pos a, MarkerID/Pos b, Real distance
function Util_GetPositionFromAtoB(a, b, distance)

	
	-- if either a or b are markers, convert them to positions
	if (scartype(a) == ST_MARKER) then
		a = Marker_GetPosition(a)
	end
	if (scartype(b) == ST_MARKER) then
		b = Marker_GetPosition(b)
	end
	
	if scartype(a) ~= ST_SCARPOS then fatal("Util_GetPositionFromAtoB: Position A invalid") end
	if scartype(b) ~= ST_SCARPOS then fatal("Util_GetPositionFromAtoB: Position B invalid") end
	if scartype(distance) ~= ST_NUMBER then fatal("Util_GetPositionFromAtoB: No distance specified") end
	
	local distbetweenpoints = World_DistancePointToPoint(a, b)
	
	if (distbetweenpoints > 0.05) then
		
		-- if asked for distance in metres, work out the percentage
		if (distance >= 1) then
			distance = (distance / distbetweenpoints)
		end
		
		local deltax = (b.x - a.x) * distance
		local deltay = (b.y - a.y) * distance
		local deltaz = (b.z - a.z) * distance
		
		return World_Pos((a.x + deltax), (a.y + deltay), (a.z + deltaz))
		
	end
	
	-- failsafe
	print("*** WARNING in Util_GetPositionFromAtoB: Positions A and B are too close together to function properly ***")
	return a
	
end

--? @shortdesc Reloads the running scar script. Current running rules would also be updated to the redefined functioin.
function Util_ReloadScript()

	-- reload scar script and refresh the rule systems
	Scar_ReloadScripts()
	TimeRule_Refresh()
	EventRule_Refresh()

end


--? @shortdesc Play sound on the first entity of the squad in sgroup
--? @result Integer
--? @args String soundpathname, SGroupID/Squad sgroupid
function Sound_PlayOnSquad( soundpathname, sgroupid)
	
	local squad = nil
	
	if(scartype(sgroupid) == ST_SQUAD) then
		squad = sgroupid
	elseif(scartype(sgroupid) == ST_SGROUP) then
		if( SGroup_Count( sgroupid ) <= 0 ) then
			return
		end

		squad = SGroup_GetSpawnedSquadAt( sgroupid, 1 )
	else
		fatal("Invalid type used in Sound_PlayOnSquad(). Must be sgroupid or squad.")
	end

	if ( Squad_Count( squad ) <= 0 ) then
		return
	end
	
	local entity = Squad_EntityAt( squad, 0 )
	
	return Sound_Play3D( soundpathname, entity )
end


FADE_OUT = true
FADE_IN = false

--? @shortdesc Fades the screen to black - FADE_OUT to fade to black, FADE_IN to fade back in
--? @result Void
--? @args Bool direction, Real length
function Game_FadeToBlack(direction, length)
	
	if (direction == FADE_OUT) then
		Game_ScreenFade(0, 0, 0, 1, length)
		UI_ScreenFade(0, 0, 0, 1, length, true)
	elseif (direction == FADE_IN) then
		Game_ScreenFade(0, 0, 0, 0, length)
		UI_ScreenFade(0, 0, 0, 0, length, true)
	end

end



--? @group scardoc;World

--? @shortdesc Returns whether the current map is set in winter. Checks if 'g_isWinterMap' is set to true.
--? @result Boolean
function World_IsWinterMap()
	return (g_isWinterMap ~= nil and g_isWinterMap == true)
end

--? @shortdesc Returns the closest object from the table of marker/pos/egroup/sgroup to the closest marker/pos/egroup/sgroup specified
--? @extdesc The table may mix together objects of different types.
--? @args Variable var, LuaTable items
--? @result Variable
function World_GetClosest(var, items)
	
	local dist
	local closest = 99999
	local result

	for i=1, table.getn(items) do 
		
		if (scartype(items[i]) ~= ST_EGROUP and scartype(items[i]) ~= ST_SGROUP)
		or (scartype(items[i]) == ST_EGROUP and EGroup_IsEmpty(items[i]) == false)
		or (scartype(items[i]) == ST_SGROUP and SGroup_IsEmpty(items[i]) == false) then
		
			dist = World_DistancePointToPoint(Util_GetPosition(var), Util_GetPosition(items[i]))
			if dist < closest then
				closest = dist
				result = items[i]
			end
		end
		
	end
	
	return result

end

--? @shortdesc Returns the furthest object from the table of marker/pos/egroup/sgroup to the furthest marker/pos/egroup/sgroup specified.
--? @extdesc The table may mix together objects of different types.
--? @args Variable var, LuaTable items
--? @result Variable
function World_GetFurthest(var, items)
	
	local dist
	local furthest = 0
	local result

	for i=1, table.getn(items) do 
		dist = World_DistancePointToPoint(Util_GetPosition(var), Util_GetPosition(items[i]))
		if dist > furthest then
			furthest = dist
			result = items[i]
		end
	end
	
	return result

end

--? @shortdesc Returns whether ANY or ALL of the squads in the group are owned by the world (i.e. neutral)
--? @args SGroupID sgroup, Boolean all
--? @result Boolean
function World_OwnsSGroup(sgroup, all)

	local _CheckSquad = function(gid, idx, sid)
		return World_OwnsSquad(sid)
	end
	
	return SGroup_ForEachAllOrAny(sgroup, all, _CheckSquad)
	
end



--? @shortdesc Returns whether ANY or ALL of the entities in the group are owned by the world (i.e. neutral)
--? @args EGroupID egroup, Boolean all
--? @result Boolean
function World_OwnsEGroup(egroup, all)

	local _CheckEntity = function(gid, idx, eid)
		return World_OwnsEntity(eid)
	end
	
	return EGroup_ForEachAllOrAny(egroup, all, _CheckEntity)
	
end


--? @shortdesc Find a position on a path hidden from view, as close to the destination as possible whilst still satisfying your hidden checktype. Checktype can be either CHECK_IN_FOW, CHECK_OFFCAMERA or CHECK_BOTH.
--? @extdesc The path is always calculated as if it were plain infantry. This function returns nil if it can't find a suitable position, so you can do a backup plan. 
--? @result Position
--? @args PlayerID player, MarkerID/Pos origin, MarkerID/Pos destination, Integer checktype
function World_GetHiddenPositionOnPath(playerid, origin, dest, checktype)

	if scartype(origin) == ST_MARKER then
		origin = Marker_GetPosition(origin)
	end
	if scartype(dest) == ST_MARKER then
		dest = Marker_GetPosition(dest)
	end

	local eid = BP_GetEntityBlueprint("ebps/races/soviet/soldiers/conscript_soldier/conscript_soldier")
	local pos = Misc_GetHiddenPositionOnPath(checktype, dest, origin, eid, 10, 10, playerid, false)

	if (pos.x == 0) and (pos.y == 0) and (pos.x == 0) then
		return nil
	else
		return pos
	end

end

--? @shortdesc Kill off a specific player's dead bodies (enter ALL to clean them all up)
--? @result Void
--? @args PlayerID player
function World_CleanUpTheDead(player)

	local _CleanUpPlayerDeadBodies = function (gid, idx, eid)
		if (Entity_IsBuilding(eid) == false) and (Entity_IsAlive(eid) == 0 or Entity_GetHealth(eid) == 0) then
			Entity_Destroy(eid)
		end
	end
	
	if (player == ALL) then
		for n = 1, World_GetPlayerCount() do
			local deadbodiestempgroup = Player_GetEntities(World_GetPlayerAt(n))
			EGroup_ForEach(deadbodiestempgroup, _CleanUpPlayerDeadBodies)
			EGroup_Destroy(deadbodiestempgroup)
		end
	else
		local deadbodiestempgroup = Player_GetEntities(player)
		EGroup_ForEach(deadbodiestempgroup, _CleanUpPlayerDeadBodies)
		EGroup_Destroy(deadbodiestempgroup)
	end
	
end

--? @shortdesc Kill off a specific player's dead bodies (enter ALL to clean them all up) in a marker radius
--? @result Void
--? @args PlayerID player, MarkerID marker
function Marker_CleanUpTheDead(player, marker)
	
	local _CleanUpPlayerDeadBodies = function (gid, idx, eid)
		if (Entity_IsBuilding(eid) == false) and (Entity_IsAlive(eid) == 0 or Entity_GetHealth(eid) == 0) then
			Entity_Destroy(eid)
		end
	end
	
	if (player == ALL) then
		for n = 1, World_GetPlayerCount() do
			local __theDead = EGroup_CreateIfNotFound("__theDead")
			Player_GetAllEntitiesNearMarker(World_GetPlayerAt(n), __theDead, marker)
			
			EGroup_ForEach(__theDead, _CleanUpPlayerDeadBodies)
			EGroup_Destroy(__theDead)
		end
	else
		local __theDead = EGroup_CreateIfNotFound("__theDead")
		Player_GetAllEntitiesNearMarker(player, __theDead, marker)
		
		EGroup_ForEach(__theDead, _CleanUpPlayerDeadBodies)
		EGroup_Destroy(__theDead)
	end
	
end

--? @group scardoc;Util

--? @shortdesc Returns true if given entity/marker/pos/egroup/sgroup/squad has a position; if false, Util_GetPosition will fail.
--? @args Variable var
--? @result Boolean
function Util_HasPosition(variable)

	if variable == nil then
		return false
	end
	
	local type = scartype(variable)
	
	if type == ST_ENTITY then
		return true
	elseif type == ST_MARKER then
		return true
	elseif type == ST_SCARPOS then
		return true
	elseif type == ST_EGROUP then
		return EGroup_Count(variable) > 0
	elseif type == ST_SGROUP then
		return SGroup_Count(variable) > 0
	elseif type == ST_SQUAD then
		return true
	else
		return false
	end
end


--? @shortdesc Returns a position from entity/marker/pos/egroup/sgroup/squad
--? @args Variable var
--? @result Position
function Util_GetPosition(variable)

	local type = scartype(variable)
	
	if type == ST_ENTITY then
		return Entity_GetPosition(variable)
	elseif type == ST_MARKER then
		return Marker_GetPosition(variable)
	elseif type == ST_SCARPOS then
		return World_Pos(variable.x, variable.y, variable.z) -- return copy instead of reference
	elseif type == ST_EGROUP then
		return EGroup_GetPosition(variable)
	elseif type == ST_SGROUP then
		return SGroup_GetPosition(variable)
	elseif type == ST_SQUAD then
		return Squad_GetPosition(variable)
	else
		error("Util_GetPosition: unsupported type " .. scartype_tostring(variable))
	end
end

--? @shortdesc Returns a random position within an area that is not near a player
--? @extdesc Useful for dropping artillery NEAR a player, but not on him, for example.  
--? @extdesc searchRadius is the area to look for the location in.  Distance is how far from the player's units the position must be.
--? @args MarkerID/Pos/EGroupID/SGroupID pos, PlayerID player, [Integer searchRadius, Integer distance]
--? @result Position
function Util_GetPositionAwayFromPlayer(pos, player, radius, distance)
	
	local count = 0
	
	if radius == nil then
		if scartype(pos) == ST_MARKER 
		  and Marker_GetProximityType(pos) == PT_Circle 
		  and Marker_GetProximityRadius(pos) > 0 then
			radius = math.floor( Marker_GetProximityRadius(pos))
			
		else
			radius = 10
		end
	end
	
	if scartype(pos) ~= ST_SCARPOS then
		pos = Util_GetPosition(pos)
	end
	
	if distance == nil then
		distance = 5
	end
	
	local _sgTemp = SGroup_CreateIfNotFound("_sgTemp")	
	local foundPos = nil 
	
	while foundPos == nil and count < 10 do
		foundPos = Util_GetRandomPosition(pos, radius)
		Player_GetAllSquadsNearMarker(player, _sgTemp, foundPos, distance)
		if SGroup_IsEmpty(_sgTemp) == false then
			foundPos = nil
			count = count + 1
		else
			return foundPos
		end
	end
	
	if count >= 10 then
		print("Util_GetPositionAwayFromPlayer: Cound not find valid location!")
	end
	
end

--? @shortdesc Returns a random position either within the marker's proximity or with a pos and range provided. Range is ignored for rectangular markers
--? @result Pos
--? @args MarkerID/ScarPos [, Real range, Boolean hidden]
function Util_GetRandomPosition(marker, range, hidden)

	local pos
	local hidden = hidden or false
	
	if scartype(marker) == ST_MARKER then
		
		if range == nil or scartype(range) ~= ST_NUMBER then
			if Marker_GetProximityType(marker) == PT_Rectangle then
				range = 0 -- range doesn't apply to rectangular markers, but make it an int anyway so the function call below works
			else
				range = Marker_GetProximityRadius(marker)
			end
			
		end
		
		return Marker_GetRandomPositionInternal(marker, range)
		
	elseif scartype(marker) == ST_SCARPOS then
		
		pos = marker
		if range == nil then
			range = 0
		end
		
		local dir = World_GetRand(1, math.floor(2000*math.pi)) / 1000
		local offset = World_GetRand(1, (range * 1000)) / 1000
		
		local x = pos.x + (math.cos(dir) * offset)
		if math.abs(x) > World_GetWidth()/2 then
			if x < 0 then 
				x = (World_GetWidth()/2 - 1) * -1
			else
				x = World_GetWidth()/2 - 1
			end
		end
		
		local z = pos.z + (math.sin(dir) * offset)
		if math.abs(z) > World_GetLength()/2 then
			if z < 0 then 
				z = (World_GetLength()/2 - 1) * -1
			else
				z = World_GetLength()/2 - 1
			end			
		end
		
		return World_Pos(x, pos.y, z)
		
	end
	
end

--? @shortdesc Returns a formatted localized string.
--? @extdesc Use this function to format localized text. ie %1PLAYERNAME% is going to win. It accepts up to 4 additional LocStrings as parameters.
--? @args Integer FormatID[, argc parameters]
--? @result LocString
function Loc_FormatText(LocID, ...)
	
	local argc = table.getn(arg)
	
	if argc == 1 then
		return Loc_FormatText1(LocID, arg[1])
	elseif argc == 2 then
		return Loc_FormatText2(LocID, arg[1], arg[2])
	elseif argc == 3 then
		return Loc_FormatText3(LocID, arg[1], arg[2], arg[3])
	elseif argc == 4 then
		return Loc_FormatText4(LocID, arg[1], arg[2], arg[3], arg[4])
	else
		fatal("Loc_FormatText: Too many arguments (" .. argc .. ")")
	end
	
end

--? @shortdesc Kills ALL world entities near a marker
--? @args MarkerID marker
--? @result Void
function World_KillAllNeutralEntitesNearMarker(marker)

	egTemp = EGroup_CreateIfNotFound("egTemp_World_KillNeutralEntitesNearMarker")
	World_GetNeutralEntitiesNearMarker(egTemp, marker)
	
	local _KillEntity = function(gid, idx, eid)
		Entity_Kill(eid)
	end
	
	EGroup_ForEach(egTemp, _KillEntity)

end

--? @shortdesc Returns the closest MarkerID to the entity/marker/pos/egroup/sgroup/squad from the table of markers provided
--? @args Variable var, Table markers
--? @result MarkerID
function Util_GetClosestMarker(var, markers) 

	local dist
	local closest = 99999
	local result

	for i=1, table.getn(markers) do 
		dist = World_DistancePointToPoint(Util_GetPosition(var), Marker_GetPosition(markers[i]))
		if dist < closest then
			closest = dist
			result = markers[i]
		end
	end
	
	return result
end


--? @group scardoc;UI

--? @shortdesc Returns true if ANY or ALL of the SGroup is selected
--? @args SGroupID sgroup, Boolean all
--? @result Boolean
function Misc_IsSGroupSelected(sgroup, all)

	local _CheckSquad = function(gid, idx, sid)
		return Misc_IsSquadSelected(sid)
	end

	return SGroup_ForEachAllOrAny(sgroup, all, _CheckSquad)
	
end


--? @shortdesc Returns true if ANY or ALL of the EGroup is selected
--? @args EGroupID egroup, Boolean all
--? @result Boolean
function Misc_IsEGroupSelected(egroup, all)

	local _CheckEntity = function(gid, idx, eid)
		return Misc_IsEntitySelected(eid)
	end

	return EGroup_ForEachAllOrAny(egroup, all, _CheckEntity)
	
end


--? @group scardoc;SGroup

--? @shortdesc Grabs the selected squads/entities and returns them in a group. Only works with -dev.
--? @extdesc Tries to return an SGroup first. If it's empty, it will return an EGroup. (Both types can't be selected at the same time)
--? @args Boolean subselect
--? @result Sgroup/Egroup Group containing selection
function Util_Grab(subSelect)
	
	local sg_grabbed = SGroup_CreateIfNotFound("")
	Misc_GetSelectedSquads(sg_grabbed, subSelect or false)
	
	local eg_grabbed = EGroup_CreateIfNotFound("")
	Misc_GetSelectedEntities(eg_grabbed, subSelect or false)
	
	if(SGroup_Count(sg_grabbed) > 0) then
		return sg_grabbed
	else
		return eg_grabbed
	end
	
end

--? @shortdesc Returns true if ANY or ALL of the squads in an SGroup are carrying some kind of team weapon
--? @args SGroupID sgroup, Boolean all
--? @result Boolean
function SGroup_HasTeamWeapon(sgroup, all)

	local _CheckSquad = function (gid, idx, sid)
		return Squad_HasTeamWeapon(sid)
	end
	
	return SGroup_ForEachAllOrAny(sgroup, all, _CheckSquad)
	
end

--? @group scardoc;Util

--? @shortdesc Ends the single player game (win/lose).
--? @args Boolean win[, Boolean nis, Boolean sandmap]
--? @result Void
function Game_EndSP(win, nis, sandmap)
	print("Game_EndSP. Win: " .. tostring(win));
	
	-- remember control groups, to be able to restore them for counterattack (in __SetupCounterattack)
	t_control_groups = {}
	for i = 0, 9 do
		local sg = SGroup_CreateIfNotFound("sg_saved_control_group" .. i)
		local eg = EGroup_CreateIfNotFound("eg_saved_control_group" .. i)
		SGroup_Clear(sg)
		EGroup_Clear(eg)
		
		Misc_GetControlGroupContents(i, sg, eg)
		
		table.insert(t_control_groups, {sg, eg})
	end
	
	-- fail everything you haven't completed
	if __t_Objectives ~= nil then
		for k, v in pairs(__t_Objectives) do
			if Obj_GetState(v.ID) == OS_Incomplete and Objective_IsStarted(v) then
				v.PreFail = nil
				v.OnFail = nil
				Objective_Fail(v, false, true)
			end
		end
	end
	-- profiler
	if Rule_Exists(_CountAvg_Track) then
		_CountAvg_Report()
	end

	-- defaults to 'win'
	if win == nil then
		win = true
	end
	
	if sandmap == nil then
		sandmap = true
	end
	
	-- local NIS
	local GameOverNIS = function()
		
		-- rotate around current position
		Camera_AutoRotate(Camera_GetTargetPos(), 35, 43, 1)
		Game_SetMode(UI_Fullscreen)
		FOW_Enable(false)
		UI_ToggleDecorators()
		Misc_SetDefaultCommandsEnabled(false)
		Misc_SetSelectionInputEnabled(false)
		
		-- Fade out speech / sfx as win screen comes up
		Sound_SetVolume("master\\speech_master", 0.0, 2)
		Sound_SetVolume("master\\sfx_master", 0.0, 2)
		
		World_EndSP(win)
		World_SetGameOver()
	end
	
	local ViewMapDelay = function()
		
		-- rotate around current position
		Game_SetMode(UI_Fullscreen)
		UI_ToggleDecorators()
		
		local text = LOC("MISSON COMPLETE - Press PAUSE to view the map.")
		CTRL.Game_TextTitleFade( text, .5, 5, .5 )
		CTRL.WAIT()
		local text = LOC("Press ESC to skip past this mode.")
		CTRL.Game_TextTitleFade( text, .5, 5, .5 )
		CTRL.Event_Delay(10)
		CTRL.WAIT()
		
		if nis == true and __g_playIntelEvents then
			Event_Start(GameOverNIS, 0)
		else
			World_EndSP(win)
			World_SetGameOver()
		end
		
	end
	
	UI_HideTacticalMap()
	
	-- special debug command so that the designers can view the map before the mission end screen appears
	if Misc_IsCommandLineOptionSet("delay_endsp") and __g_playIntelEvents then
		Event_Start(ViewMapDelay, 0)
	-- play NIS
	elseif nis ~= false and __g_playIntelEventsthen then
		Event_Start(GameOverNIS, 0)
	-- otherwise don't play the NIS, just end it
	else
		Game_SetMode(UI_Fullscreen)
		World_EndSP(win)
		World_SetGameOver()
	end
end

--? @shortdesc If there's a squad under the mouse cursor, this adds it to a unique SGroup. Return value is the SGroup it was added to, or nil if there was no squad under the mouse cursor. Pass in true for 'clearGroup' to clear the sgroup before adding the squad.
--? @args [Boolean clearGroup]
--? @result SGroupID
function Util_AddMouseoverSquadToSGroup(clearGroup)

	local sg = Util_GetMouseoverSGroup()
		
	if (Misc_IsMouseOverEntity()) then
		
		local entity = Misc_GetMouseOverEntity()
		if (Entity_IsPartOfSquad( entity )) then
			
			local squad = Entity_GetSquad(entity)
			if clearGroup == true then
				SGroup_Clear(sg)
			end
			SGroup_Add(sg, squad)
			return sg
			
		end
	end
	
	-- is this redundant in Lua?
	return nil
	
end


--? @shortdesc Returns a unique SGroup used to hold mouseover squads obtained from Util_AddMouseoverSquadToSGroup
--? @result Void
function Util_GetMouseoverSGroup()
	if sg_mouseover == nil then
		sg_mouseover = SGroup_Create("sg_mouseover")
	end
	
	return sg_mouseover
end


--? @shortdesc Hides all of a player's squads and/or buildings
--? @extdesc Doesn't hide buildings a player is in, or any base structures. Only items like sandbags, tanktraps, mg nests, etc. Put multiple playerIDs in a table to hide many players together, or use ALL for the playerID to apply to all players at once.
--? @args PlayerID player, Bool hide
--? @result Void
function Util_HidePlayerForNIS(player, hide)

	if scartype(player) == ST_PLAYER then
		
		player = {player}
		
	elseif player == ALL then
		
		player = {}
		for n = 1, World_GetPlayerCount() do
			table.insert(player, World_GetPlayerAt(n))
		end
		
	end
	
	local _sg_hideplayerfornis = SGroup_CreateIfNotFound("_sg_hideplayerfornis")
	local _eg_hideplayerfornis = EGroup_CreateIfNotFound("_eg_hideplayerfornis")
	
	for n = 1, table.getn(player) do
		Player_GetAll(player[n], _sg_hideplayerfornis, _eg_hideplayerfornis)
		SGroup_Hide(_sg_hideplayerfornis, hide)
	end
	SGroup_Destroy(_sg_hideplayerfornis)
	EGroup_Destroy(_eg_hideplayerfornis)
end



--? @shortdesc ReSpawns or DeSpawns sgroups (and egroups) for all players or the indicated player.
--? @args Boolean despawn, Boolean allPlayers [or Int playerNum], Boolean egroups
--? @result Void
--? @extdesc examples: Util_DespawnAll(true, true, false) or Util_DespawnAll(true, 1, false) or Util_DespawnAll(false, true, false)
function Util_DespawnAll(boolean, everybody, everything)
	local SGspawnFunction = function(sgroup)
		if boolean == true then
			SGroup_DeSpawn(sgroup)
		else
			SGroup_ReSpawn(sgroup)
		end
	end
	local EGspawnFunction = function(egroup)
		if boolean == true then
			EGroup_DeSpawn(egroup)
		else
			EGroup_ReSpawn(egroup)
		end
	end
	
	if everybody == true then
		for i = 1, World_GetPlayerCount() do 
			Player_GetAll(World_GetPlayerAt(i))
			SGspawnFunction(sg_allsquads)
			if everything == true then
				EGspawnFunction(eg_allentities)
			end
		end
	elseif everybody ~= nil and everybody <= World_GetPlayerCount() then
		Player_GetAll(World_GetPlayerAt(everybody))
		SGspawnFunction(sg_allsquads)
		if everything == true then
			EGspawnFunction(eg_allentities)
		end
	end

end


--? @shortdesc Checks the entity count for the world and returns true or false depending on the result. A specific value can be passed in to override the default amount.
--? @args [Integer entityLimit]
--? @result Boolean
function Util_EntityLimit(int)
	if int == nil then
		int = 290
	end
	if Util_UnitCounts(true).entity <= int then
		return true
	else
		return false
	end
end
--[[
Example:
function now()
	local t = Util_UnitCounts(player1)
	print(t.squad)
	print(t.entity)
	print(t.vehicle)
	if t.squad < 50 then
		print("yippee")
	else
		print("darn")
	end
end
]]


--? @shortdesc Returns a table containing either the total or a specific player's squad count, entity count, and vehicle count.
--? @extdesc table can be accessed as scene below
--? Get Player Example:\n
--? local t = Util_UnitCounts(player1)\n
--? print(t.squad)\n
--? print(t.entity)\n
--? print(t.vehicle)\n
--? Get World Example:\n
--? local t = Util_UnitCounts(true)\n
--? print(t.squad)\n
--? print(t.entity)\n
--? print(t.vehicle)\n
--? Alternate Format:\n
--? print(Util_UnitCounts(true).squad)\n
--? @args Boolean world OR playerID player
--? @result Lua Table
function Util_UnitCounts(countWho)
	
	-- true means return for all players
	if countWho == true then
		
		-- each player
		local playercount = World_GetPlayerCount()
		local total_squadcount = 0
		local total_entitycount_actual = 0
		local total_entitycount_reported = 0 -- count vehicles as 5
		local total_vehiclecount = 0
		
		for i = 1, playercount do
			
			local thisplayer = World_GetPlayerAt(i)
			local thisplayer_name = Player_GetRaceName(thisplayer)
			local thisplayer_squadcount = Player_GetSquadCount(thisplayer)
			local sgroupID = Player_GetSquads(thisplayer)
			
			local thisplayer_entitycount_actual = 0
			local thisplayer_entitycount_reported = 0 -- counts vehicles as 5 entities
			local thisplayer_vehiclecount = 0
			
			local _EachSquad = function(gid, idx, sid)
				-- count how many vehicles in this squad
				local thissquad_vehiclecount = 0
				for i = 1, Squad_Count(sid) do
					local entity = Squad_EntityAt(sid, i - 1)
					if Entity_IsVehicle(entity) then
						thissquad_vehiclecount = thissquad_vehiclecount + 1
					end
				end
				
				thisplayer_entitycount_actual = thisplayer_entitycount_actual + Squad_Count(sid)
				thisplayer_vehiclecount = thisplayer_vehiclecount + thissquad_vehiclecount
			end
			
			SGroup_ForEach(sgroupID, _EachSquad)
			
			thisplayer_entitycount_reported = thisplayer_entitycount_actual
			thisplayer_entitycount_reported = thisplayer_entitycount_reported + (thisplayer_vehiclecount * 4) -- each vehicle adds 4 extra entities
			
			total_squadcount = total_squadcount + thisplayer_squadcount
			total_entitycount_actual = total_entitycount_actual + thisplayer_entitycount_actual
			total_entitycount_reported = total_entitycount_reported + thisplayer_entitycount_reported
			total_vehiclecount = total_vehiclecount + thisplayer_vehiclecount
		end
		
		-- player totals
		local str = "Total: " .. total_squadcount .. " squads, " .. total_entitycount_reported .. " entities"
		if total_vehiclecount > 0 then
			str = str .. " (" .. total_vehiclecount .. " vehicles)"
		end
		print(str)
		return {squad = total_squadcount, entity = total_entitycount_reported, vehicle = total_vehiclecount}
		
		--[[ leftover world-owned entities
		local num_worldentities = World_GetNumEntities() - total_entitycount_actual
		str = "World-owned entities: " .. num_worldentities
		ypos = ypos + 0.02
		dr_text2d("unit_count", xpos, ypos, str, 255, 255, 255)
		]]
		
	elseif countWho ~= nil then
		
		--[[ start the work on just one ]]
			local thisplayer = countWho
			local thisplayer_name = Player_GetRaceName(thisplayer)
			local thisplayer_squadcount = Player_GetSquadCount(thisplayer)
			local sgroupID = Player_GetSquads(thisplayer)
			
			local thisplayer_entitycount_actual = 0
			local thisplayer_entitycount_reported = 0 -- counts vehicles as 5 entities
			local thisplayer_vehiclecount = 0
			
			local _EachSquad = function(gid, idx, sid)
				-- count how many vehicles in this squad
				local thissquad_vehiclecount = 0
				for i = 1, Squad_Count(sid) do
					local entity = Squad_EntityAt(sid, i - 1)
					if Entity_IsVehicle(entity) then
						thissquad_vehiclecount = thissquad_vehiclecount + 1
					end
				end
				
				thisplayer_entitycount_actual = thisplayer_entitycount_actual + Squad_Count(sid)
				thisplayer_vehiclecount = thisplayer_vehiclecount + thissquad_vehiclecount
			end
			
			SGroup_ForEach(sgroupID, _EachSquad)
			
			thisplayer_entitycount_reported = thisplayer_entitycount_actual
			thisplayer_entitycount_reported = thisplayer_entitycount_reported + (thisplayer_vehiclecount * 4) -- each vehicle adds 4 extra entities
			
			local str = thisplayer_name .. ": " .. thisplayer_squadcount .. " squads, " .. thisplayer_entitycount_reported .. " entities"
			if thisplayer_vehiclecount > 0 then
				str = str .. " (" .. thisplayer_vehiclecount .. " vehicles)"
			end
			print(str)
			return {squad = thisplayer_squadcount, entity = thisplayer_entitycount_reported, vehicle = thisplayer_vehiclecount}
			
		--[[ end of just one ]]
	else
		fatal("Util_UnitCounts: 'countWho' is neither 'true' nor a valid playerID")
	end
end

-- Entity Count Util Functions 
function _CountAvg_Track()
	
	local t = Util_UnitCounts(true)
	
	if _avg == nil then
		_avg = t.entity
	else
		_avg = (_avg+t.entity)/2
	end
	
	if _high == nil then
		_high = {}
	end
	
	if t.entity >= 250 then
		table.insert(_high, {count = t.entity, time = World_GetGameTime()})
	end
	
end

-- Entity Count Util Functions 
function _CountAvg_Report()
	-- the average
	if _avg ~= nil then
		print("CountAvg_Report: the Average Unit Count = ".._avg)
	end
	
	-- the highs
	if _high ~= nil then
		for k,v in pairs(_high) do
			print(k.." - "..v.count.." entities counted at time "..v.time)
		end
	end
	
	print("Report Time:"..World_GetGameTime())
end

--? @shortdesc Clears vehicle wrecks from a given area.
--? @extdesc Area can be a marker (with or without a range override), a position and range combo, or a territory sector ID. Uses EBP.WRECKED_VEHICLES unless wrecksList is defined.
--? @args MarkerID/Pos/SectorID position[, Real range, Table wrecksList]
--? @result Void
function Util_ClearWrecksFromMarker(pos, range, wrecksList)
	if(wrecksList == nil) then
		wrecksList = EBP.WRECKED_VEHICLES --Defined in LuaConstAuto
	end
	
	eg_clearwrecksgroup = EGroup_CreateIfNotFound("eg_clearwrecksgroup")
	
	-- get all the neutral entitied (different methods for different class types)
	if scartype(pos) == ST_MARKER then
		if range == nil then
			World_GetNeutralEntitiesNearMarker(eg_clearwrecksgroup, pos)
		else
			World_GetNeutralEntitiesNearPoint(eg_clearwrecksgroup, Marker_GetPosition(pos), range)
		end
	elseif scartype(pos) == ST_SCARPOS then
		World_GetNeutralEntitiesNearPoint(eg_clearwrecksgroup, pos, range)
	elseif scartype(pos) == ST_NUMBER then
		World_GetNeutralEntitiesWithinTerritorySector(eg_clearwrecksgroup, pos)
	end
	
	-- filter out anything that isn't a wreck, and destroy all entities that are left\
	EGroup_Filter(eg_clearwrecksgroup, wrecksList, FILTER_KEEP)
	EGroup_Kill(eg_clearwrecksgroup)
end


--? @shortdesc Plays music from the Data:Sound folder, and stores the music track so it can be resumed after a save/load
--? @extdesc The new music will phase out the old one. There can only be one music playing at anytime besides the transition fade is the time to fade in the music; delay is the time in seconds to wait until the new music is started. Example: Sound_PlayMusic( "Music/GreatMusic", 0.0, 0.0 )
--? @args String name, Real fade, Real delay
--? @result Void
function Util_PlayMusic(name, fade, delay)

	Sound_PlayMusic(name, fade, delay)
	_current_music_filename = name	

end


--? @shortdesc Resumes playing the music track that was last triggered i.e. after a save/load
--? @args Void
--? @result Void
function Util_RestoreMusic()
	
	if _current_music_filename ~= nil then
		Sound_PlayMusic(_current_music_filename, 0, 0)
	end
	
end

--? @shortdesc Enabling this function will mute the ambient sound (NOT all sound).
--? @args Boolean enable, [Real fade]
--? @result Void
function Util_MuteAmbientSound(enable, fade_time)

	if enable == false then
		
		if fade_time == nil then
			fade_time = 1.5
		end
	
		Sound_SetVolumeDefault("master\\speech_master", fade_time)
		Sound_SetVolumeDefault("master\\sfx_master", fade_time)
	else
	
		if fade_time == nil then
			fade_time = 0
		end
	
		Sound_SetVolume("master\\speech_master", 0.0, fade_time)
		Sound_SetVolume("master\\sfx_master", 0.0, fade_time)
	end

end

--? @shortdesc Finds the greatest (or least) concentration of squads owned by a team.
--? @extdesc This function is slow, so don't call it very often
--? @args TeamID team[, Boolean popcapOnly, Table includeBlueprints, Table excludeBlueprints, Boolean bLeastConcentrated, MarkerID/Table onlyInThisMarker]
--? @result SGroup
function Team_GetSquadConcentration(team, bPopcapOnly, includeBPs, excludeBPs, bLeastConcentrated, marker)
	local players = Team_GetPlayers(team)
	return __GetUnitConcentration(players, SGroupCaller, bPopcapOnly, includeBPs, excludeBPs, bLeastConcentrated, marker)
end

--? @shortdesc Finds the greatest (or least) concentration of entities owned by a team.
--? @extdesc This function is slow, so don't call it very often
--? @args TeamID team[, Boolean popcapOnly, Table includeBlueprints, Table excludeBlueprints, Boolean bLeastConcentrated, MarkerID/Table onlyInThisMarker]
--? @result EGroup
function Team_GetEntityConcentration(team, bPopcapOnly, includeBPs, excludeBPs, bLeastConcentrated, marker)
	local players = Team_GetPlayers(team)
	return __GetUnitConcentration(players, SGroupCaller, bPopcapOnly, includeBPs, excludeBPs, bLeastConcentrated, marker)
end

--? @shortdesc Finds a nearby building to garrison. can ignore occupied [friendly] buildings. return ID of entity it found, or nil if not found
--? @args SGroupID sgroup, Position pos, Real radius[, Boolean occupied,  SGroup/Table filter]
--? @extdesc Can also filter out groups not to occupy
--? @result EntityID
function Util_GarrisonNearbyBuilding(sgroup, pos, radius, occupied, filter)
	return __GarrisonNearbyUnit(EGroupCaller, sgroup, pos, radius, occupied, filter)
end

--? @shortdesc Finds a nearby vehicle to garrison. can ignore occupied [friendly] vehicles. return ID of vehicle it found, or nil if not found,
--? @extdesc Can also filter out groups not to occupy
--? @args SGroupID sgroup, Position pos, Real radius[, Boolean occupied, SGroup/Table filter]
--? @result SquadID
function Util_GarrisonNearbyVehicle(sgroup, pos, radius, occupied, filter)
	return __GarrisonNearbyUnit(SGroupCaller, sgroup, pos, radius, occupied, filter)
end

--? @shortdesc Returns true if any event is currently running [at or below (more important than) the priority threshold. If not specified, ignores threshold.]
--? @args [Integer priority_threshold]
--? @result Boolean
function Event_IsAnyRunning(threshold)

	if threshold == nil then
		threshold = 999
	end
	
	return Event_IsAnyRunningInternal(threshold)
	
end


--? @shortdesc Creates an Event Cue for an SGroup and repeats it until the SGroup is killed or selected.
--? @extdesc Additionally, a map ping and custome loc strings for the Title and Description can be used.
--? @args SGroupID sgroupName[, LocID custumTitle, LocID customDescript]
--? @result Void
function Util_ReinforceEvent(sgroupName, customLocTitle, customLocDesc)
	
	-- brw forcing the system to use the same repeating reinforcements function,
	-- unfortunately, it's going to ignore the ping map variable.
	EventCue_Create(CUE.NORMAL_REPEATING, customLocTitle, customLocDesc, sgroupName)
	
end


--? @shortdesc Prints out the entire contents of an Object
--? @extdesc This is most useful when used in conjunction with fatal() or bug() to populate the log file.
--? @extdesc Objects can be anything (Player, SGroup, Int, Table, String, etc.), but this is most useful for Tables
--? @args Object obj[, Int max_depth, String data_type, Function print_func]
--? @result Void
function Util_PrintObject(obj, max_depth, data_type, print_func)

	local iPrintObjectDepth = 0
	local PrintTableStack = {}

	if( print_func == nil ) then
		print_func = print
	end
		
	local function _PrintObject(tabs, obj, max_depth, data_type)

		if( max_depth and max_depth > 0 and iPrintObjectDepth > max_depth ) then
			return
		end
		
		if( type(obj) =="table" ) then
			if( Util_TableContains(PrintTableStack, obj) ) then
				print_func( "Recursive Printing Error Detected." )
				return
			end
			
			table.insert( PrintTableStack, obj )
			
			print_func(tabs.. "{")
			iPrintObjectDepth = iPrintObjectDepth + 1
			local indent = tabs.." "
			for k,v in pairs(obj) do
				if (type(v) == "table") then
					print_func(indent.."[" .. tostring(k) .. "]("..tostring(type(v))..") = ")
					_PrintObject(indent.." ", v, max_depth, data_type, print_func)
				else
					if( data_type == nil or type(v) == data_type ) then
						print_func(indent.."[" .. tostring(k) .. "]("..tostring(type(v))..") = "..tostring(v)..",")
					end
				end
			end
			iPrintObjectDepth = iPrintObjectDepth - 1
			print_func(tabs.. "},")
			
			table.remove(PrintTableStack,table.getn(PrintTableStack))
			
		else
			if( data_type == nil or type(obj) == data_type ) then
				print_func(tabs..tostring(obj))
			end
		end
	end
	
	_PrintObject("", obj, max_depth, data_type)
end

function PrintObject(obj, max_depth, data_type, print_func)
	Util_PrintObject(obj, max_depth, data_type, print_func)
end


--? @shortdesc Checks the first layer of a table and looks for a specified Object, returns true if found.
--? @extdesc Objects can be anything (Player, SGroup, Int, Table, String, etc.)
--? @args Table targetTable, Object obj
--? @result Boolean
function Util_TableContains(targetTable, obj)
	local contains = false
	for k, v in pairs(targetTable) do
		if v == obj then
			contains = true
		end
	end
	
	return contains
end

--? @shortdesc Finds a hidden position within the FOW between two given points
--? @extdesc If no position is found, returns origin
--? @args Position origin, Position destination
--? @result Position 
function Util_FindHiddenSpawn(origin, destination)
	
	local pos = Util_GetPosition(origin)
	local destination = Util_GetPosition(destination)
	while Player_CanSeePosition(player1, pos) == false do
		pos = Util_GetPositionFromAtoB(pos, destination, 1)		
		if pos == origin or World_DistancePointToPoint(pos, destination) <= 2 then
			return pos
		end
	end
	
	if(pos == origin) then
		return origin
	else	
		return Util_GetPositionFromAtoB(pos, origin, 10)
	end
	
end

--? @shortdesc Finds a hidden position based on what the local player can and can't see
--? @extdesc If no position is found, returns nil
--? @args Position/EGroup/Entity/SGroup/Squad items
--? @result Position/EGroup/Entity/SGroup/Squad 
function Util_FindHiddenItem(items)
	
	local validPositions = {}
	
	for i = 1, table.getn(items) do
		if scartype(items[i]) == ST_SCARPOS then
			if Player_CanSeePosition(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_EGROUP then
			if Player_CanSeeEGroup(Game_GetLocalPlayer(), items[i], ALL) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_ENTITY then
			if Player_CanSeeEntity(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_SGROUP then
			if Player_CanSeeSGroup(Game_GetLocalPlayer(), items[i], ALL) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_SQUAD then
			if Player_CanSeeSquad(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		end
	end
	
	local size = table.getn(validPositions)
	
	if size > 0 then
		local rand = World_GetRand(1, size)
		
		return validPositions[rand]
	else
		return nil
	end
	
end

--? @shortdesc Finds a hidden position based on what the local player can and can't see
--? @extdesc If no position is found, returns nil
--? @args Position/EGroup/Entity/SGroup/Squad items
--? @result Position/EGroup/Entity/SGroup/Squad 
function Util_GetRandomHiddenPosition(items)
	
	local validPositions = {}
	
	for i = 1, table.getn(items) do
		if scartype(items[i]) == ST_SCARPOS then
			if Player_CanSeePosition(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_EGROUP then
			if Player_CanSeeEGroup(Game_GetLocalPlayer(), items[i], ALL) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_ENTITY then
			if Player_CanSeeEntity(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_SGROUP then
			if Player_CanSeeSGroup(Game_GetLocalPlayer(), items[i], ALL) == false then
				table.insert(validPositions, items[i])
			end
		elseif scartype(items[i]) == ST_SQUAD then
			if Player_CanSeeSquad(Game_GetLocalPlayer(), items[i]) == false then
				table.insert(validPositions, items[i])
			end
		end
	end
	
	local size = table.getn(validPositions)
	
	if size > 0 then
		local rand = World_GetRand(1, size)
		
		return validPositions[rand]
	else
		return nil
	end
	
end

--? @shortdesc Determines the health percentage of a given object
--? @extdesc Returns average health if the object is a group
--? @args Squad/Entity/Sgroup/Egroup var
--? @result Percentage health [0,1] 
function Util_GetHealth(var)
	if(scartype(var) == ST_ENTITY) then
		return Entity_GetHealthPercentage(var)
	elseif(scartype(var) == ST_SQUAD) then
		return Squad_GetHealthPercentage(var)
	elseif(scartype(var) == ST_SGROUP) then
		return SGroup_GetAvgHealth(var)
	elseif(scartype(var) == ST_EGROUP) then
		return EGroup_GetAvgHealth(var)
	else
		fatal("Tried to get health on an unvalid scartype (" .. scartype_tostring(var) .. ")")
	end
end

--? @shortdesc Kills a given object
--? @args Player/Squad/Entity/Sgroup/Egroup var
--? @result Void
function Util_Kill(var)
	if (scartype(var) == ST_PLAYER) then
		SGroup_Kill(Player_GetSquads(var))
	elseif(scartype(var) == ST_EGROUP) then
		EGroup_Kill(var)
	elseif(scartype(var) == ST_SGROUP) then
		SGroup_Kill(var)
	elseif(scartype(var) == ST_SQUAD) then
		Squad_Kill(var)
	elseif(scartype(var) == ST_ENTITY) then
		Entity_Kill(var)
	else
		fatal("Invalid type (" .. scartype_tostring(var) .. "). Must be Entity/Squad/EGroup/Egroup")
	end
end

--? @shortdesc Forces all squads given to retreat, regardless of whether they are on team weapons or not. Disables aiEncounters input (true disables all encounters).
--? @args SGroup sgroup, Marker marker, Marker, deleteAtMarker, Bool/AIEncounter aiEncounterDisable
function Util_ForceRetreatAll(sgroup, marker, deleteAtMarker, aiEncounterDisable)
	if aiEncounterDisable == true then 		
		AI_DisableAllEncounters()
	elseif scartype(aiEncounterDisable) == ST_TABLE then
		for k,enc in ipairs(aiEncounterDisable) do
			enc:Disable()
		end
	elseif aiEncounterDisable ~= nil then
		aiEncounterDisable:Disable()
	end
	
	Cmd_AbandonTeamWeapon(sgroup, true)
	
	Event_Timer(_ForceRetreatAll2, {sgroup = sgroup, marker = marker, deleteAtMarker = deleteAtMarker}, 0.5)
end

function _ForceRetreatAll2(data) 
	Cmd_Retreat(data.sgroup, data.marker, data.deleteAtMarker)
end

--? @group scardoc;Marker

--? @shortdesc Builds a table of MarkerIDs that are named in a sequence. i.e. a name of "spot" will find markers "spot1", "spot2" and so on, up until it looks for a marker that isn't there.
--? @args String name, String type
--? @result Table
function Marker_GetSequence(name, markerType)

	local num = 1
	local result = {}
	
	if(markerType == nil) then markerType = "" end
	
	while Marker_Exists(name..num, markerType) do
		table.insert(result, Marker_FromName(name..num, markerType))
		num = num + 1
	end
	
	if num >= 2 then
		print("Retrieved sequence of Markers: "..name.."1 to "..name..(num-1))
	end
	
	return result
	
end

--? @group scardoc;Util

--? @shortdesc Returns true if a Player/Team can see any or all of an SGroup/Squad/EGroup/Entity/Position/Marker
--? @args PlayerID/TeamID playerID/teamID, SGroupID/EGroupID/EntityID/SquadID/MarkerID/Position element[, ALL])
--? @result Boolean
function Util_ElementCanSee(element1, element2, all)
	if all == nil then all = ALL end
	
	if scartype(element1) == ST_PLAYER then
		if scartype(element2) == ST_SGROUP then
			if Player_CanSeeSGroup(element1, element2, all) then	
				return true
			end
		elseif scartype(element2) == ST_EGROUP then	
			if Player_CanSeeEGroup(element1, element2, all) then	
				return true
			end		
		elseif scartype(element2) == ST_ENTITY then
			if Player_CanSeeEntity(element1, element2) then	
				return true
			end		
		elseif scartype(element2) == ST_SQUAD then				
			if Player_CanSeeSquad(element1, element2, all) then	
				return true
			end
		elseif scartype(element2) == ST_MARKER then
			if Player_CanSeePosition(element1, Util_GetPosition(element2)) then		
				return true
			end
		elseif scartype(element2) == ST_SCARPOS then
			if Player_CanSeePosition(element1, element2)	then
				return true
			end		
		end
	elseif scartype(element1) == ST_TABLE then
		for i = 1, table.getn(element1) do
			if scartype(element2) == ST_SGROUP then
				
				if Player_CanSeeSGroup(element1[i], element2, all) then	
					return true
				end
			elseif scartype(element2) == ST_EGROUP then	
				if Player_CanSeeEGroup(element1[i], element2, all) then	
					return true
				end		
			elseif scartype(element2) == ST_ENTITY then
				if Player_CanSeeEntity(element1[i], element2) then	
					return true
				end		
			elseif scartype(element2) == ST_SQUAD then				
				if Player_CanSeeSquad(element1[i], element2, all) then	
					return true
				end
			elseif scartype(element2) == ST_MARKER then
				if Player_CanSeePosition(element1[i], Util_GetPosition(element2)) then		
					return true
				end
			elseif scartype(element2) == ST_SCARPOS then
				if Player_CanSeePosition(element1[i], element2)	then
					return true
				end		
			end
		end	
	end
end

--? @shortdesc Tracks a syncweapon ID and destroys it (by default) or makes it uncapturable (if kill is set to false)
--? @args SGroupID syncweapon[, Boolean kill]
--? @result Void
function Util_LogSyncWpn(sgroup, kill)
	if __KillSyncWpn == nil then
		__KillSyncWpn = {}
	end
	
	if kill == nil then kill = true end
	
	local _CheckSquad = function(gid, idx, sid)
		
		for n = 1, Squad_Count(sid) do
			local isNewSyncWeap = true
			local eid = Squad_EntityAt(sid, n-1)
--~ 			print("Squad index is: "..n)
--~ 			print(Entity_IsSyncWeapon(eid))
			if Entity_IsSyncWeapon(eid) == true then
				syncid = Entity_GetGameID(eid)
				for i = 1, #(__KillSyncWpn) do 
					if syncid == __KillSyncWpn[i].wpnID then
						isNewSyncWeap = false
						break
					end
				end
				if isNewSyncWeap == true then
					local t = {}
					t.wpnID = syncid
					t.kill = kill
					table.insert(__KillSyncWpn, t)
				end
			end
		end
		
	end
	
	if SGroup_IsEmpty(sgroup) == false then
		SGroup_ForEach(sgroup, _CheckSquad)
	end
	
	if #(__KillSyncWpn) > 0 then
		if Rule_Exists(__Util_KillSyncWpn) == false then
			Rule_AddInterval(__Util_KillSyncWpn, 0)
		end
	end
end

function __Util_KillSyncWpn()
	local count = table.getn(__KillSyncWpn)
	if count > 0 then
		for k, v in pairs(__KillSyncWpn) do
--~ 		for i = count, 1, -1 do 
			local syncw = v.wpnID
			if SyncWeapon_Exists(syncw) == false then
				table.remove(__KillSyncWpn, k)
				return
			end
			
			if SyncWeapon_IsOwnedByPlayer(syncw, nil) then
				local entity = SyncWeapon_GetEntity(syncw)
				local egroup = EGroup_CreateIfNotFound("eg_OPkillentity"..k)
				EGroup_Add(egroup, entity)
				if v.kill == true then
					EGroup_Kill(egroup)
				else
					EGroup_SetSelectable(egroup, false)
					Entity_SetRecrewable(entity, false)
					UI_EnableEntityDecorator(entity, false)
				end
				table.remove(__KillSyncWpn, k)
			end
		end
	end	
end

--? @shortdesc Loads a scar file if it hasn't been loaded yet
--? @args String Path
--? @result nil
_imports = {}
function Import_Once(path)
	if(_imports[path] == nil)then
		import(path)
		_imports[path] = 1
	end
end

--? @shortdesc Returns a table of positions sorted from closest to furthest (or furthes to closest if reverse is true) from the origin
--? @args SGroupID/EGroupID/EntityID/SquadID/MarkerID/Position origin, Table positions[, reverse])
--? @result Table
function Util_SortPositionsByClosest(origin, positions, reverse)
	local returnTable = {}
	if reverse == nil then
		reverse = false
	end
	
	while table.getn(positions) > 0 do
		local index = Util_GetClosestMarker(origin, positions)
		
		for i = 1, table.getn(positions) do
			if index == positions[i] then
				index = i
			end
		end
		
		local tablePos = table.getn(returnTable)+1
		if reverse then
			tablePos = 1
		end
		
		table.insert(returnTable, tablePos, positions[index])
		table.remove(positions, index)
	end
	
	return returnTable
	
end

_cloneTableStack = {}

----------------------------------------------------------------------------------------------------------------------------------------------------------
function CloneTable(original)
	
	if( DoesTableContain(_cloneTableStack, original) ) then
		fatal( "Recursive Cloning Error Detected." )
	end    
    
	table.insert( _cloneTableStack, original )
	
	local tbl = {}
	for k, v in pairs(original) do
		if(scartype(v) ~= ST_TABLE)then 
			tbl[k] = v
		else
			tbl[k] = Clone(v)
		end
	end
	
	setmetatable( tbl, Clone(getmetatable(original)) )
		
	table.remove(_cloneTableStack,table.getn(_cloneTableStack))
	
	return tbl
end

--? @shortdesc Clones a table (recursively) allowing for unadulterated use of the data
--? @args Table data
--? @result Table 
function Clone(original)
	if( type(original) == "table" ) then
		return CloneTable(original)
	else
		return original
	end
end


----------------------------------------------------------------------------------------------------------------------------------------------------------
function TableCount(tbl)

	local count = 0

	if( type(tbl) == "table" ) then
		for k,v in pairs(tbl) do
			count = count+1
		end
	end
	
	return count
end

----------------------------------------------------------------------------------------------------------------------------------------------------------
function DoesTableContain(tbl, value)

	local count = 0

	if( type(tbl) == "table" ) then
		for k,v in pairs(tbl) do
			if( v == value ) then
				return true
			end
		end
	end
	
	return false
end

_cloneTableStack = {}

--? @shortdesc Automatically save the game for the player. The savegame name is built using the abbreviated mission name + checkpoint. 
--? @args LocString checkpoint[, Float delay, Boolean noFade]
--? @result void 
function Util_Autosave(checkpoint, delay, noFade)
	if noFade ~= true then
		noFade = false
	end
	
	if noFade then
		if delay ~= nil then
			Rule_AddDelayedInterval(_autosave_waitForEvents_noFade, delay, 0.2)
		else
			Rule_Add(_autosave_waitForEvents_noFade)
		end
	elseif delay ~= nil then
		Rule_AddDelayedInterval(_autosave_waitForEvents, delay, 0.2)
	else
		Rule_Add(_autosave_waitForEvents)
	end

end

_autosave_waitForEvents = function ()
	if not Event_IsAnyRunning() then
		
		Rule_RemoveMe()
		
		-- put up the "Autosaving" text on-screen
		UI_AutosaveMessageShow()
		
		Rule_AddOneShot(_autosave_delayedA, 0.5)
		Rule_AddOneShot(_autosave_delayedB, 1.5)
	end
end

_autosave_waitForEvents_noFade = function ()
	if not Event_IsAnyRunning() then
		-- Show "Autosaving" text on-screen
		UI_AutosaveMessageShow()
		Rule_RemoveMe()
		Rule_AddOneShot(_autosave_delayedC, 0.5)
	end
end

_autosave_delayedA = function ()

	-- fade down
	UI_ScreenFade(0, 0, 0, 0.7, 0.9, true)

end
_autosave_delayedB = function ()
	-- Begin save
	Scar_Autosave()
	
	-- fade back up
	UI_AutosaveMessageHide()
	UI_ScreenFade(0, 0, 0, 0, 1, false)
end

_autosave_delayedC = function ()
	-- Begin save
	Scar_Autosave()
	UI_AutosaveMessageHide()
end

--? @shortdesc Debug function used to toggle whether or not IntelEvents are played. Only works with -dev parameter
--? @result void 
function Util_ToggleAllowIntelEvents()
	if(Misc_IsCommandLineOptionSet("dev")) then
		__g_playIntelEvents = not __g_playIntelEvents
	end
end


--? @shortdesc Calls UI_NewHUDFeature() as an IntelEvent. Will get queued as any other event. See UI_NewHUDFeature() for parameter details.
--? @args HUDFeatureType newHUDFeature, LocString featureText, String featureIcon, Real duration
--? @result void 
function Util_NewHUDFeatureEvent(HUDFeature, text, icon, duration)
	local event = function()
		CTRL.UI_NewHUDFeature(HUDFeature, text, icon, duration)
		CTRL.WAIT()
	end
	Util_StartIntel(event)
end



--? @group scardoc;Debug

--Sets up the debug table/iterator needed to debug the list of intel events.
function _IntelDebug()
	if Misc_IsCommandLineOptionSet("dev") then
		print("IntelEvent Debugger - Initializing...")
		Event_RemoveAll(true)
		Rule_RemoveAll()
		__t_intelDebugTable = {}
		__t_intelDebugIterator = 0
		for k,v in pairs(EVENTS) do
			table.insert(__t_intelDebugTable, v)
		end
	end
end

--? @shortdesc Replays the last intel event that was debugged. 
--? @result void 
function _IntelDebugReplay()
	if Misc_IsCommandLineOptionSet("dev") then
		if(__t_intelDebugTable == nil) then
			_IntelDebug()
			__t_intelDebugIterator = 1
		end
		Util_StartIntel(__t_intelDebugTable[__t_intelDebugIterator])
	end
end

--? @shortdesc Plays the next intel event in the debug queue.  IntelEvents are played sequentially as they are defined in a mission's .events file.
--? @result void 
function _IntelDebugNext()
	if Misc_IsCommandLineOptionSet("dev") then
		if(__t_intelDebugTable == nil) then
			_IntelDebug()
		end
		
		__t_intelDebugIterator = math.min(__t_intelDebugIterator + 1, #__t_intelDebugTable)
		if(__t_intelDebugIterator == #__t_intelDebugTable) then
			print("#WARNING - IntelEvent Debugger: Looks like you've hit the end of the line, bub...")
		end
		Util_StartIntel(__t_intelDebugTable[__t_intelDebugIterator])
	end
end

--? @shortdesc Plays the next intel event in the debug queue. IntelEvents are played sequentially as they are defined in a mission's .events file.
--? @result void 
function _IntelDebugPrev()
	if Misc_IsCommandLineOptionSet("dev") then
		if(__t_intelDebugTable == nil) then
			_IntelDebug()
		end
		
		__t_intelDebugIterator = math.max(__t_intelDebugIterator - 1, 1)
		if(__t_intelDebugIterator == 1) then
			print("#WARNING - IntelEvent Debugger: You're back at the front of the line!")
		end
		Util_StartIntel(__t_intelDebugTable[__t_intelDebugIterator])
	end
end