--[[
	NHC2 Mod: Schultz tiger (Win Condition)

	Adds a single "tiger_ace_schultz" squad to a German player:
		* spawned at the nearest German map entry point
		* only ONE player ever gets the squad
		* if the tiger squad is not on the map, the German side fails
		* adds the primary objective "Shultz must survive"
		* adds a live UI health bar for Schultz's squad
--]]

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")

-- ------------------------------------------------------------------
-- [[ CONFIGURATION ]]
-- ------------------------------------------------------------------
local SCHULTZ_SBP = "97127c821f624593a1a70d59cdc4f4cc:tiger_ace_schultz"
local SCHULTZ_CREW_SBP = "97127c821f624593a1a70d59cdc4f4cc:tiger_tank_crew_schultz"
local SCHULTZ_RACE = "german"
local SCHULTZ_FALLBACK_RACE = "west_german"
local SCHULTZ_TITLE = "Shultz must survive"
local ENEMY_TITLE = "Kill the Shultz"

-- Battle phase / dispatch upgrades granted to every player, by race.
local NHC_MOD_GUID = "97127c821f624593a1a70d59cdc4f4cc:"

local t_RaceUpgrades = {
	aef = {
		NHC_MOD_GUID .. "battle_phase_1_aef",
		NHC_MOD_GUID .. "battle_phase_2_aef",
		NHC_MOD_GUID .. "battle_phase_3_aef",
	},
	british = {
		NHC_MOD_GUID .. "captain_dispatched_upgrade",
		NHC_MOD_GUID .. "lieutenant_dispatched_upgrade",
		NHC_MOD_GUID .. "cromwell_command_dispatch_upgrade",
	},
	-- German battle phases are vanilla CoH2 blueprints, so they carry no GUID.
	german = {
		"battle_phase_2_mp",
		"battle_phase_3_mp",
		"battle_phase_4_mp",
	},
	soviet = {
		NHC_MOD_GUID .. "soviet_battle_phase_1",
		NHC_MOD_GUID .. "soviet_battle_phase_2",
		NHC_MOD_GUID .. "soviet_battle_phase_3",
	},
	west_german = {
		NHC_MOD_GUID .. "west_german_battle_phase_1",
		NHC_MOD_GUID .. "west_german_battle_phase_2",
		NHC_MOD_GUID .. "west_german_battle_phase_3",
		NHC_MOD_GUID .. "unlock_panzerschreck",
		},
}

-- Starting resources handed to every player.
local START_MANPOWER = 3500
local START_MUNITION = 200
local START_FUEL = 400
local START_COMMAND = 12

-- Opening units per race. ai_bp replaces bp when the player is AI-controlled.
-- Entries flagged vehicle = true are withheld from whoever owns the Tiger.
local t_FactionStartUnits = {
	aef = {
		{ bp = "riflemen_squad_mp", count = 2 },
		{ bp = "m36_tank_destroyer_squad_mp", count = 2, vehicle = true },
		{ bp = NHC_MOD_GUID .. "bazooka_squad", count = 2 },
		{ bp = "m1_57mm_at_gun_squad_mp", count = 2, ai_bp = NHC_MOD_GUID .. "m1_57mm_at_gun_squad_ai" },
	},
	british = {
		{ bp = "tommy_squad_mp", count = 2 },
		{
			bp = "tommy_squad_tank_hunter_mp",
			count = 2,
			upgrades = { NHC_MOD_GUID ..  "tommy_tank_hunters_piat" },
		},
		{ bp = "sherman_firefly_squad_mp", count = 2, vehicle = true },
		{ bp = "brit_6_pounder_at_gun_squad_mp", count = 2, ai_bp = NHC_MOD_GUID .. "brit_6_pounder_at_gun_squad_ai" },
	},
	german = {
		{ bp = "grenadier_squad_mp", count = 2 },
		{
			bp = "panzer_grenadier_squad_mp",
			count = 2,
			upgrades = { "panzer_grenadier_panzershreck_atw_item_mp" },
		},
		{ bp = "stug_iii_squad_mp", count = 2, vehicle = true },
		{ bp = "pak40_75mm_at_gun_squad_mp", count = 2, ai_bp = NHC_MOD_GUID .. "pak40_75mm_at_gun_squad_ai" },
	},
	soviet = {
		{ bp = "penal_battalion_mp", count = 2 },
		{
			bp = "guards_troops_assault_mp",
			count = 2,
			upgrades = { "guards_bazooka_upgrade_mp" },
		},
		{ bp = "su-85_mp", count = 2, vehicle = true },
		{ bp = "m1942_zis-3_76mm_at_gun_squad_mp", count = 2, ai_bp = NHC_MOD_GUID .. "m1942_zis-3_76mm_at_gun_squad_ai" },
	},
	west_german = {
		{ bp = NHC_MOD_GUID .. "panzer_grenadier_squad_west", count = 2 },
		{ bp = NHC_MOD_GUID .. "panzer_grenadier_tank_hunter_squad", count = 2 },
		{ bp = "jagdpanzer_tank_destroyer_squad_mp", count = 2, vehicle = true },
		{
			bp = "raketenwerfer43_88mm_puppchen_antitank_gun_squad_mp",
			count = 2,
			ai_bp = NHC_MOD_GUID .. "raketenwerfer43_88mm_puppchen_antitank_gun_squad_ai",
		},
	},
}

-- ------------------------------------------------------------------
-- [[ GLOBALS ]]
-- ------------------------------------------------------------------
g_SchultzPlayer = nil
g_SchultzTeam = nil
g_SchultzLost = false
g_SchultzSpawned = false
g_SchultzObjResolved = false
g_SchultzLastPos = nil
CINEMATIC_SECONDS = 5.0
obj_Enemy = nil
sg_Schultz = nil
obj_Schultz = nil

-- ------------------------------------------------------------------
-- [[ UTILITIES ]]
-- ------------------------------------------------------------------
function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

-- BP_Get*Blueprint raises a FATAL scar error when a name does not resolve, which
-- aborts the entire init function. Relic guards these calls the same way in
-- aod.scar. Return nil instead so one bad entry only skips that one item.
function Schultz_SafeUpgradeBlueprint(name)
	local result = nil

	if pcall(function() result = BP_GetUpgradeBlueprint(name) end) then
		return result
	end

	print("Schultz win condition: MISSING upgrade blueprint '" .. name .. "'")
	return nil
end

function Schultz_SafeSquadBlueprint(name)
	local result = nil

	if pcall(function() result = BP_GetSquadBlueprint(name) end) then
		return result
	end

	print("Schultz win condition: MISSING squad blueprint '" .. name .. "'")
	return nil
end

-- Player display names come back as LocString tables, which cannot be
-- concatenated with "..". Pull the plain text out for print/debug output.
function Schultz_ToText(value)
	local valueType = scartype(value)

	if valueType == ST_STRING then
		return value
	end

	if valueType == ST_TABLE then
		return tostring(value[1])
	end

	return tostring(value)
end

-- Returns a position on a map entry point owned by any Allied player.
-- Returns the position of the map entry point nearest the Schultz player,
-- taken from the enemy (German) side's entry points.
function Schultz_GetEnemyEntryPoint()
	local eg_entries = EGroup_CreateIfNotFound("eg_schultz_entries")
	local eg_player = EGroup_CreateIfNotFound("eg_schultz_player")
	local sg_player = SGroup_CreateIfNotFound("sg_schultz_player")
	local bp_entry_point = BP_GetEntityBlueprint("map_entry_point")

	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)

		if Player_GetTeam(player) == g_SchultzTeam then
			-- One map entry point entity per call keeps them from piling up in the group.
			EGroup_Clear(eg_player)

			Player_GetAll(player, sg_player, eg_player)
			EGroup_Filter(eg_player, bp_entry_point, FILTER_KEEP)
			EGroup_AddEGroup(eg_entries, eg_player)
		end
	end

	EGroup_Clear(eg_player)

	local entryCount = EGroup_CountSpawned(eg_entries)

	if entryCount == 0 then
		-- Map has no explicit entry points.
		return nil
	end

	-- World_GetClosest wants one group per candidate, so wrap each entity.
	local candidates = {}

	for i = 1, entryCount do
		local eg_single = EGroup_CreateIfNotFound("eg_schultz_entry_" .. i)
		EGroup_Add(eg_single, EGroup_GetSpawnedEntityAt(eg_entries, i))
		candidates["k" .. i] = eg_single
	end

	local closest = World_GetClosest(Player_GetStartingPosition(g_SchultzPlayer), candidates)

	if closest ~= nil then
		return EGroup_GetSpawnedEntityAt(closest, 1)
	end

	return EGroup_GetSpawnedEntityAt(eg_entries, 1)
end

-- Spawn spot plus the facing taken from the entry point itself, so the Tiger
-- comes out of the gate pointing the same way the map expects.
function Schultz_GetSpawnPlacement()
	local entry = Schultz_GetEnemyEntryPoint()

	if entry == nil then
		local fallback = Player_GetStartingPosition(g_SchultzPlayer)
		print("Schultz win condition: no map_entry_point, using the starting position.")
		return fallback, nil
	end

	local pos = Util_GetPosition(entry)

	-- Aim the Tiger at the enemy side. Player_GetStartingPosition is reliable at
	-- init time, whereas the HQ entity list is not populated this early, and
	-- there is no entity-facing native exposed to Scar (only Marker_GetDirection).
	local enemyStart = nil

	for i = 1, World_GetPlayerCount() do
		local other = World_GetPlayerAt(i)

		if Player_GetTeam(other) ~= g_SchultzTeam then
			enemyStart = Player_GetStartingPosition(other)
			break
		end
	end

	if enemyStart == nil then
		print("Schultz win condition: no enemy player, spawning without a facing.")
		return pos, nil
	end

	-- Squad_CreateAndSpawnToward only uses the heading, not the length.
	local facing = World_Pos(pos.x + ((enemyStart.x - pos.x) * 2.0),
		pos.y + ((enemyStart.y - pos.y) * 2.0),
		pos.z + ((enemyStart.z - pos.z) * 2.0))

	print("Schultz win condition: spawn " .. tostring(pos.x) .. ", " .. tostring(pos.y) ..
		" facing toward enemy base " .. tostring(enemyStart.x) .. ", " .. tostring(enemyStart.y))

	return pos, facing
end

-- ------------------------------------------------------------------
-- [[ DISPATCH ]]
-- ------------------------------------------------------------------

-- Collects the Schultz player's HQ entity into eg_out, or leaves it empty.
function Schultz_FindHQ(eg_out)
	local sg_scan = SGroup_CreateIfNotFound("sg_schultz_hq_scan")

	EGroup_Clear(eg_out)
	Player_GetAll(g_SchultzPlayer, sg_scan, eg_out)
	EGroup_Filter(eg_out, BP_GetEntityBlueprint("hq_mp"), FILTER_KEEP)
end

-- Where Schultz should head when there is no rally point.
function Schultz_GetHQPosition()
	local eg_hq = EGroup_CreateIfNotFound("eg_schultz_hq")
	Schultz_FindHQ(eg_hq)

	local pos = nil

	if EGroup_CountSpawned(eg_hq) > 0 then
		pos = Util_GetPosition(EGroup_GetSpawnedEntityAt(eg_hq, 1))
	end

	EGroup_Clear(eg_hq)

	if pos == nil then
		-- No HQ on the map: fall back to where the player started.
		return Player_GetStartingPosition(g_SchultzPlayer)
	end

	return pos
end

-- Reads the HQ's rally point. ScarUtil exposes no helper for this, so the native
-- is probed rather than called blindly.
function Schultz_GetRallyPointPosition()
	if (scartype(Entity_GetRallyPoint) ~= ST_FUNCTION) then
		return nil
	end

	local eg_hq = EGroup_CreateIfNotFound("eg_schultz_hq_rally")
	Schultz_FindHQ(eg_hq)

	local pos = nil

	if EGroup_CountSpawned(eg_hq) > 0 then
		local rally = Entity_GetRallyPoint(EGroup_GetSpawnedEntityAt(eg_hq, 1))
		local rallyType = scartype(rally)

		if rallyType == ST_SCARPOS or rallyType == ST_ENTITY or rallyType == ST_MARKER then
			pos = Util_GetPosition(rally)
		end
	end

	EGroup_Clear(eg_hq)

	return pos
end

-- Send Schultz to the rally point if there is one, otherwise to his own HQ.
function Schultz_Dispatch()
	local target = Schultz_GetRallyPointPosition()
	local usedRally = target ~= nil

	if usedRally == false then
		target = Schultz_GetHQPosition()
	end

	Cmd_Move(sg_Schultz, target)

	print("Schultz win condition: dispatched to " .. (usedRally and "rally point" or "HQ") ..
		" at " .. tostring(target.x) .. ", " .. tostring(target.y) .. ", " .. tostring(target.z))
end

-- ------------------------------------------------------------------
-- [[ PRIMARY OBJECTIVE ]]
-- ------------------------------------------------------------------
function Schultz_InitObjective()
	-- "Shultz must survive" belongs to Schultz's own side. The enemy gets
	-- "Kill the Shultz" instead, so exactly one of the two is ever shown.
	if (g_SchultzTeam == nil) or (Game_HasLocalPlayer() == false) then
		obj_Schultz = nil
		return
	end

	if Player_GetTeam(Game_GetLocalPlayer()) ~= g_SchultzTeam then
		obj_Schultz = nil
		return
	end

	obj_Schultz = {
		SetupUI = function()
		end,

		OnStart = function()
			Schultz_AddObjectiveUI()
		end,

		OnComplete = function()
		end,

		OnFail = function()
		end,

		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,

		Title = Util_CreateLocString(SCHULTZ_TITLE),
		Description = 0,
		Type = OT_Primary,
	}

	-- NOTE: Objective_Register's owner argument goes through Team_IsPlayerOnTeam,
	-- which does not exist in this build (it is commented out in team.scar), so any
	-- numeric owner throws a fatal error. Passing nothing registers for the local
	-- player, which is what a win condition wants -- every client runs this scar.
	Objective_Register(obj_Schultz)
	Objective_Start(obj_Schultz)

	-- title/hintpoints on, but no forced HUD arrow (that is the red off-screen arrow).
	Objective_SetAlwaysShowDetails(obj_Schultz, true, false, true)
end

function Schultz_AddObjectiveUI()
	local hpHintPoint = Util_CreateLocString("Protect Schultz")

	-- pos, ping, hintpointText, worldArrow -- worldArrow stays false so no 3D
	-- arrow is drawn over the Tiger.
	Objective_AddUIElements(obj_Schultz, sg_Schultz, false, hpHintPoint, false, 3)
end

-- "Kill the Shultz", shown to the enemy side only. Follows the Conquest mode
-- pattern from (Conquest Mode) main.scar: guard on the local player, then
-- register for that client only, so each side gets its own objective.
function Schultz_InitEnemyObjective()
	if (g_SchultzTeam == nil) or (Game_HasLocalPlayer() == false) then
		obj_Enemy = nil
		return
	end

	-- Schultz's own side already has "Shultz must survive".
	if Player_GetTeam(Game_GetLocalPlayer()) == g_SchultzTeam then
		obj_Enemy = nil
		return
	end

	obj_Enemy = {
		SetupUI = function()
		end,

		OnStart = function()
		end,

		OnComplete = function()
		end,

		OnFail = function()
		end,

		Intel_Start = nil,
		Intel_Complete = nil,
		Intel_Fail = nil,

		Title = Util_CreateLocString(ENEMY_TITLE),
		Description = 0,
		Type = OT_Primary,
	}

	Objective_Register(obj_Enemy)
	Objective_Start(obj_Enemy)
end

-- Close out whichever objective THIS client owns. Exactly one of obj_Schultz /
-- obj_Enemy is ever set, because the two init functions gate on opposite teams.
-- State follows Tiger existence:
--     Tiger alive  -> "must survive" COMPLETE, "Kill the Shultz" FAILED
--     Tiger gone   -> "must survive" FAILED,  "Kill the Shultz" COMPLETE
function Schultz_ResolveObjectives()
	-- Resolve at most once. Objective_Fail only guards against OS_Complete (not
	-- OS_Failed), so a second call re-queues the objective and the fail popup
	-- shows twice. Both call sites below can fire for the same match.
	if g_SchultzObjResolved then
		return
	end
	g_SchultzObjResolved = true

	local alive = Schultz_SquadExists()

	if obj_Schultz ~= nil then
		if alive then
			Objective_Complete(obj_Schultz)
		else
			Objective_Fail(obj_Schultz)
		end

		return
	end

	if obj_Enemy ~= nil then
		if alive then
			Objective_Fail(obj_Enemy)
		else
			Objective_Complete(obj_Enemy)
		end
	end
end

-- ------------------------------------------------------------------
-- [[ UI HEALTH BAR ]]
-- Same mechanism as the Tiger health bar in tlt.scar: the engine's own
-- HUD progress bar, fed from SGroup_GetAvgHealth.
-- ------------------------------------------------------------------
function Schultz_CreateHealthbar()
	Obj_ShowProgress2(Util_CreateLocString("Shultz"), SGroup_GetAvgHealth(sg_Schultz))
	g_SchultzLastPos = SGroup_GetPosition(sg_Schultz)
end

function Schultz_UpdateHealthbar()
	if SGroup_IsAlive(sg_Schultz) then
		-- Remember where the Tiger was while it still existed; once the squad is
		-- destroyed SGroup_GetPosition is no longer usable for the wreck shot.
		g_SchultzLastPos = SGroup_GetPosition(sg_Schultz)
		Obj_ShowProgress2(Util_CreateLocString("Shultz"), SGroup_GetAvgHealth(sg_Schultz))
	else
		Obj_ShowProgress2(Util_CreateLocString("Shultz"), 0.0)
	end
end

function Schultz_RemoveHealthbar()
	Obj_HideProgress()
end

function Schultz_HealthbarUpdate()
	if sg_Schultz == nil then
		Rule_RemoveMe()
		return
	end

	Schultz_UpdateHealthbar()
end

-- ------------------------------------------------------------------
-- [[ SCHULTZ RESOLUTION ]]
-- ------------------------------------------------------------------

-- Purely an existence test: SGroup_IsEmpty asks whether the group still holds
-- anything. No health, no member count, nothing else is consulted.
function Schultz_SquadExists()
	if sg_Schultz == nil then
		return false
	end

	return SGroup_IsEmpty(sg_Schultz) == false
end

-- The tiger squad was never created in the first place (no eligible German,
-- or the blueprint did not resolve).
-- Game_SubTextFade(title, body1, fadeIn, lifetime, fadeOut)
function Schultz_AnnounceNeverSpawned()
	print("Shultz win condition: no Tiger was ever created - ending the mission.")

	Game_SubTextFade(
		Util_CreateLocString("No German Added"),
		Util_CreateLocString("The game is Dropped"),
		0.5, 9999.0, 1.5)
end

-- Stop anyone from producing another Schultz Tiger. Removing the CREW blueprint
-- alone was not enough: production goes through the Tiger squad's own entry, so
-- both blueprints have to go. This runs regardless of whether a Tiger spawned.
function Schultz_RestrictCrew()
	local t_tiger = {
		SCHULTZ_SBP,
		SCHULTZ_CREW_SBP,
	}

	local blocked = 0

	for n = 1, table.getn(t_tiger) do
		local sbp = Schultz_SafeSquadBlueprint(t_tiger[n])

		if sbp ~= nil then
			for i = 1, World_GetPlayerCount() do
				local player = World_GetPlayerAt(i)

				Player_SetSquadProductionAvailability(player, sbp, ITEM_REMOVED)
			end

			blocked = blocked + 1
		end

		-- Some tech trees gate the squad behind an ability; harmless to try, but
		-- this call may reject a squad blueprint, so keep it guarded.
		pcall(function()
			Player_SetAbilityAvailability(World_GetPlayerAt(1), t_tiger[n], ITEM_REMOVED)
		end)
	end

	print("Shultz win condition: Tiger production blocked for " .. tostring(blocked) ..
		"/" .. tostring(table.getn(t_tiger)) .. " blueprint(s), all players.")
end

-- The Tiger crew squad must not outlive the Tiger. Called only from the
-- destruction path -- never on the "Tiger never spawned" path.
function Schultz_RemoveCrew()
	local crewBP = Schultz_SafeSquadBlueprint(SCHULTZ_CREW_SBP)

	if crewBP == nil then
		return
	end

	local removed = 0

	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local sg_scan = SGroup_CreateIfNotFound("sg_schultz_crew_scan_" .. i)
		local eg_scan = EGroup_CreateIfNotFound("eg_schultz_crew_scan_" .. i)

		Player_GetAll(player, sg_scan, eg_scan)

		-- Collect first, destroy afterwards: Squad_Destroy mutates the very
		-- group being walked, so destroying inline would skip entries.
		local matches = {}
		local found = 0

		SGroup_ForEach(sg_scan, function(gid, index, squad)
			if Squad_GetBlueprint(squad) == crewBP then
				found = found + 1
				matches[found] = squad
			end
		end)

		for m = 1, found do
			-- Squad_Destroy also detaches the squad from every group.
			Squad_Destroy(matches[m])
			removed = removed + 1
		end

		SGroup_Clear(sg_scan)
		EGroup_Clear(eg_scan)
	end

	if removed > 0 then
		print("Shultz win condition: removed " .. tostring(removed) .. " Tiger crew squad(s).")
	end
end

-- Cutscene on the Tiger's wreck: HUD off, camera on the last known position and
-- the area revealed, so everyone sees where he went down. Mirrors TLT_tigercheck
-- in tlt.scar.lua, which does the same thing for its Tiger.
function Schultz_DestroyedCinematic()
	local pos = g_SchultzLastPos

	if pos == nil then
		pos = Player_GetStartingPosition(g_SchultzPlayer)
	end

	-- UI_Cinematic hides the taskbar/minimap for the duration.
	Game_SetMode(UI_Cinematic)

	Camera_MoveTo(pos, true, 0.35, false, true)
	FOW_RevealArea(pos, 25, 5)

	print("Shultz win condition: cinematic on the wreck at " ..
		tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z))
end

-- Ends the wreck cutscene, hands camera control back, then decides the match.
function Schultz_EndCinematic()
	Rule_RemoveMe()

	Game_SetMode(UI_Normal)

	-- camera.scar deliberately does NOT re-enable input itself while letterboxed
	-- (UI_Cinematic letterboxes the screen), so force it back on here.
	Camera_SetInputEnabled(true)

	Schultz_FinishLost()
end

-- Ends the match: Allies win, the German side is defeated.
function Schultz_FinishLost()
	Rule_RemoveMe()
	WinCondition_GameOver(Team_GetEnemyTeam(g_SchultzTeam), g_SchultzTeam)
end

function Schultz_GermansDefeat()
	-- One shot only: WinCondition_Check ticks every 3s and must not re-enter.
	if g_SchultzLost then
		return
	end
	g_SchultzLost = true

	-- Kill every rule right now so nothing else can advance the match.
	Rule_RemoveAll()

	-- ...but that also killed the objective refresh loop from objectives.scar,
	-- and the match stays alive through the cinematic. Put it back.
	if (scartype(__UpdateObjectives) == ST_FUNCTION) and (Rule_Exists(__UpdateObjectives) == false) then
		Rule_AddInterval(__UpdateObjectives, 1, 10)
	end

	Schultz_RemoveHealthbar()

	-- The objective resolves as the cutscene starts, so the fail/complete card
	-- lands with the wreck shot. g_SchultzObjResolved keeps it to one popup even
	-- though WinCondition_GameOver also calls this.
	Schultz_ResolveObjectives()

	-- A Tiger that existed gets the wreck cutscene, and the match is decided
	-- when it ends. One that never existed just gets the notice.
	if g_SchultzSpawned == true then
		Schultz_RemoveCrew()
		Schultz_DestroyedCinematic()
		Rule_AddDelayedInterval(Schultz_EndCinematic, CINEMATIC_SECONDS, 1)
	else
		Schultz_AnnounceNeverSpawned()
		Rule_AddDelayedInterval(Schultz_FinishLost, 3.0, 1)
	end
end

-- ------------------------------------------------------------------
-- [[ WIN CONDITION ]]
-- ------------------------------------------------------------------
function WinCondition_GameOver(winningTeam, losingTeam)
	-- Resolve the objective BEFORE the result screen takes over, so the
	-- complete/fail popup is actually seen. Covers the annihilation endings too.
	Schultz_ResolveObjectives()

	-- Set the winning team (this will fire win/loss events for each player).
	World_SetTeamWin(winningTeam)

	local winningPlayers = Team_GetPlayers(winningTeam)
	local losingPlayers = Team_GetPlayers(losingTeam)

	Fatality_Execute(winningPlayers, losingPlayers)
end

function WinCondition_Check()
	local results = {}

	-- Latched once per check: Schultz's team is protected from the base
	-- annihilation condition only while the Tiger is still on the map.
	local tigerAlive = (g_SchultzTeam ~= nil and Schultz_SquadExists())

	-- Check every player on each team for ownership of the "annihilation_condition" entity.
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local team = Player_GetTeam(player)

		results[team] = results[team] or { surrender_count = 0, annihilation_condition_count = 0 }

		-- If any player on a team has surrendered, that team loses.
		if (Player_IsSurrendered(player)) then
			results[team].surrender_count = results[team].surrender_count + 1
		end

		-- If at least one player on a given team owns an "annihilation_condition" entity, then that team has not yet lost.
		-- Schultz's team is the exception: while the Tiger is alive it cannot be
		-- defeated by losing its bases, only by losing the Tiger itself. Same
		-- exemption tlt.scar.lua applies to its Tiger team.
		if (Player_IsAlive(player)) or (team == g_SchultzTeam and tigerAlive == true) then
			local entities = Player_GetEntities(player)
			local found = false

			for entityCount = 1, EGroup_CountSpawned(entities) do
				local entity = EGroup_GetSpawnedEntityAt(entities, entityCount)
				if (Entity_IsOfType(entity, "annihilation_condition")) then
					results[team].annihilation_condition_count = results[team].annihilation_condition_count + 1
					found = true
					break
				end
			end

			-- Tiger still up but no base left: do not let this count as a loss.
			if found == false and team == g_SchultzTeam and tigerAlive == true then
				results[team].annihilation_condition_count = results[team].annihilation_condition_count + 1
			end
		end
	end

	-- Check if any team has lost.
	for team,result in pairs(results) do
		if (result.surrender_count > 0 or result.annihilation_condition_count == 0) then
			-- Schultz's side lost its bases while the Tiger lived, and now the
			-- Tiger is gone too. This branch returns before reaching the Tiger
			-- check below, so route it through the cinematic defeat or the
			-- cutscene would never play.
			if team == g_SchultzTeam and tigerAlive == false then
				Schultz_GermansDefeat()
				return
			end

			Rule_RemoveAll()

			local winningTeam = Team_GetEnemyTeam(team)
			local losingTeam = team

			WinCondition_GameOver(winningTeam, losingTeam)
			return
		end
	end

	-- The tiger squad is not on the map: the German side fails.
	if g_SchultzTeam ~= nil and Schultz_SquadExists() == false then
		Schultz_GermansDefeat()
	end
end

-- ------------------------------------------------------------------
-- [[ SETUP ]]
-- ------------------------------------------------------------------
-- [[ FACTION UPGRADES ]]
-- ------------------------------------------------------------------
function Schultz_ApplyUpgrades()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local race = Player_GetRaceName(player)
		local upgrades = t_RaceUpgrades[race]

		if upgrades ~= nil then
			local applied = 0

			for k = 1, table.getn(upgrades) do
				local bp = Schultz_SafeUpgradeBlueprint(upgrades[k])

				if bp ~= nil then
					Player_CompleteUpgrade(player, bp)
					applied = applied + 1
				end
			end

			print("Schultz win condition: granted " .. tostring(applied) .. "/" .. tostring(table.getn(upgrades)) ..
				" upgrade(s) to " .. Schultz_ToText(Player_GetDisplayName(player)) .. " (" .. race .. ")")
		else
			print("Schultz win condition: no upgrade list for race '" .. race .. "'")
		end
	end
end

-- ------------------------------------------------------------------
-- [[ STARTING RESOURCES ]]
-- ------------------------------------------------------------------
function Schultz_ApplyResources()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)

		Player_SetResource(player, RT_Manpower, START_MANPOWER)
		Player_SetResource(player, RT_Munition, START_MUNITION)
		Player_SetResource(player, RT_Fuel, START_FUEL)
		Player_SetResource(player, RT_Command, START_COMMAND)
	end

	print("Schultz win condition: starting resources set to " .. tostring(START_MANPOWER) ..
		" manpower, " .. tostring(START_MUNITION) .. " munitions, " .. tostring(START_FUEL) .. " fuel, " .. tostring(START_COMMAND) .. " command.")
end

-- ------------------------------------------------------------------
-- [[ STARTING UNITS ]]
-- ------------------------------------------------------------------
function Schultz_ApplyStartUnits()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		local race = Player_GetRaceName(player)
		local list = t_FactionStartUnits[race]

		if list ~= nil then
			local isAI = (Player_IsHuman(player) == false)
			local home = Player_GetStartingPosition(player)
			local sg_start = SGroup_CreateIfNotFound("sg_start_units_" .. i)

			local isTigerOwner = (g_SchultzPlayer ~= nil and player == g_SchultzPlayer)
			local skipped = 0

			for k = 1, table.getn(list) do
				local entry = list[k]
				local bpName = entry.bp

				-- Schultz already provides the Tiger, so that player gets no
				-- opening vehicles of their own.
				if isTigerOwner and entry.vehicle == true then
					skipped = skipped + 1
				else
					if isAI and entry.ai_bp ~= nil then
						bpName = entry.ai_bp
					end

					local upgrades = nil

					if entry.upgrades ~= nil then
						upgrades = {}

						for u = 1, table.getn(entry.upgrades) do
							local ubp = Schultz_SafeUpgradeBlueprint(entry.upgrades[u])

							if ubp ~= nil then
								table.insert(upgrades, ubp)
							end
						end
					end

					local sbp = Schultz_SafeSquadBlueprint(bpName)

					if sbp ~= nil then
						-- Spread the squads out a little so they do not stack on one tile.
						Util_CreateSquads(player, sg_start, sbp,
							Util_GetRandomPosition(home, 20), nil, entry.count, nil, false, nil, upgrades)
					end
				end
			end

			print("Schultz win condition: start units for " .. Schultz_ToText(Player_GetDisplayName(player)) ..
				" (" .. race .. (isAI and ", AI" or "") .. (isTigerOwner and ", Tiger owner" or "") ..
				(skipped > 0 and (", " .. tostring(skipped) .. " vehicle(s) withheld") or "") .. ")")
		else
			print("Schultz win condition: no start unit list for race '" .. race .. "'")
		end
	end
end

-- ------------------------------------------------------------------
-- [[ SETUP ]]
-- ------------------------------------------------------------------
function Schultz_FindPlayer()
	-- Preferred: the first player running the base "german" race, whatever slot
	-- they happen to occupy.
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)

		if Player_GetRaceName(player) == SCHULTZ_RACE then
			return player
		end
	end

	-- Otherwise the first West German takes it.
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)

		if Player_GetRaceName(player) == SCHULTZ_FALLBACK_RACE then
			return player
		end
	end

	-- Soviet / AEF / British lobbies never get the Tiger.
	return nil
end

function Schultz_Spawn()
	print("Schultz win condition: init running, looking for a '" .. SCHULTZ_RACE .. "' player...")

	for i = 1, World_GetPlayerCount() do
		print("Schultz win condition: player " .. i .. " race = '" .. Player_GetRaceName(World_GetPlayerAt(i)) .. "'")
	end

	g_SchultzPlayer = Schultz_FindPlayer()

	if g_SchultzPlayer == nil then
		-- No eligible Tiger owner, so the mission cannot run. Still point the
		-- defeat check at a real team: if g_SchultzTeam stays nil then
		-- WinCondition_Check skips the Schultz block and play continues.
		if World_GetPlayerCount() >= 1 then
			g_SchultzTeam = Player_GetTeam(World_GetPlayerAt(1))
		end
		print("Schultz win condition: no german or west_german player in the lobby, the mission cannot start.")
		return false
	end

	if Player_GetRaceName(g_SchultzPlayer) == SCHULTZ_RACE then
		print("Schultz win condition: Tiger assigned to the first '" .. SCHULTZ_RACE .. "' player.")
	else
		print("Schultz win condition: no '" .. SCHULTZ_RACE .. "' player, Tiger assigned to the first '" ..
			SCHULTZ_FALLBACK_RACE .. "' player.")
	end

	g_SchultzTeam = Player_GetTeam(g_SchultzPlayer)

	-- Exactly one spawn, for exactly one player.
	sg_Schultz = SGroup_CreateIfNotFound("sg_Schultz")

	local spawnPos, spawnFacing = Schultz_GetSpawnPlacement()
	local schultzBP = Schultz_SafeSquadBlueprint(SCHULTZ_SBP)

	if schultzBP ~= nil then
		Util_CreateSquads(g_SchultzPlayer, sg_Schultz, schultzBP,
			spawnPos, nil, 1, nil, false, nil, nil, spawnFacing)
	end

	local didSpawn = Schultz_SquadExists()

	print("Schultz win condition: spawn position = " .. tostring(spawnPos.x) .. ", " .. tostring(spawnPos.y) .. ", " .. tostring(spawnPos.z))

	if didSpawn == false then
		-- The blueprint did not resolve. Skip the objective and the bar entirely;
		-- WinCondition_Check turns this into a German defeat.
		print("Schultz win condition: FAILED to spawn '" .. SCHULTZ_SBP .. "' - the German side will lose.")
		return false
	end

	-- Latched: the Tiger now exists, so a later disappearance means it was
	-- destroyed rather than never created.
	g_SchultzSpawned = true

	print("Shultz win condition: spawned '" .. SCHULTZ_SBP .. "' for " .. Schultz_ToText(Player_GetDisplayName(g_SchultzPlayer)))

	-- Flag the squad visually as the objective target.
	-- UI_SetSGroupSpecialLevel is a Lua wrapper that calls the native
	-- UI_SetSquadSpecialLevel, which this build does not provide.
	if (scartype(UI_SetSquadSpecialLevel) == ST_FUNCTION) then
		UI_SetSGroupSpecialLevel(sg_Schultz, 2)
	end

	Schultz_InitObjective()
	Schultz_InitEnemyObjective()
	Schultz_CreateHealthbar()

	-- HQ and rally point are read a beat after the spawn so the base buildings
	-- have finished loading into the player's entity list.
	Rule_AddOneShot(Schultz_Dispatch, 2)

	print("Schultz win condition: setup complete.")

	return true
end

local function WinCondition_Init()
	-- Resources and upgrades go to every player regardless of whether a Tiger
	-- was spawned.
	Schultz_ApplyResources()
	Schultz_ApplyUpgrades()
	Schultz_RestrictCrew()

	-- The spawn must run BEFORE the start units, because Schultz_ApplyStartUnits
	-- reads g_SchultzPlayer to decide who is denied their opening vehicles.
	local spawned = Schultz_Spawn()

	Schultz_ApplyStartUnits()

	if spawned == true then
		-- tlt drives its Tiger bar every frame; 0.25s is smooth enough here.
		Rule_AddInterval(Schultz_HealthbarUpdate, 0.25)
	end

	Rule_AddInterval(WinCondition_Check, 3)
end

Scar_AddInit(WinCondition_Init)
