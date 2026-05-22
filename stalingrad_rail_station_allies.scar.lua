

function Docks_Allies_Init()
	
	_allies_center_min = 1
	_allies_center_max = 2
	
	_allies_despawn = mkr_hmg_despawn
	
	_left_Allies_Max = 20
	_left_Allies_Curr = 0
	
	sg_docks_allies_left = SGroup_CreateIfNotFound("sg_docks_allies_left")
	_left_Allies_Spawns = Marker_GetTable("mkr_docks_allies_left_spawn_%02d")
	_left_Allies_Dests = {mkr_docks_allies_left_dest_01}
	_left_Allies_paths = {"pth_a_left_A", "pth_a_left_B"}
	
	_central_Allies_Max = 10
	_central_Allies_Curr = 0
	
	sg_docks_allies_central = SGroup_CreateIfNotFound("sg_docks_allies_central")
	_central_Allies_Spawns = Marker_GetTable("mkr_docks_allies_center_spawn_%02d")
	_central_Allies_Dests = {mkr_docks_allies_center_dest_01}
	_central_Allies_vuln = true
	_central_Allies_paths = {"pth_a_cen_A", "pth_a_cen_C"}
	-- "pth_a_cen_B",
	_right_Allies_Max = 20
	_right_Allies_Curr = 0
	
	sg_docks_allies_right = SGroup_CreateIfNotFound("sg_docks_allies_right")
	_right_Allies_Spawns = Marker_GetTable("mkr_docks_allies_right_spawn_%02d")
	_right_Allies_Dests = {mkr_docks_allies_right_dest_01}
	_right_Allies_paths = {"pth_a_right_A", "pth_a_right_B"}
	
	_hmgSuppress = false
	
	Rule_AddDelayedInterval(_allies_left_spawn, 2, 6)
	Rule_AddInterval(_allies_central_spawn, 6)
	Rule_AddDelayedInterval(_allies_right_spawn, 4, 6)
	
	Rule_AddInterval(_allies_keep_moving, 10)

end

-- HMG Allies
function HMG_Allies_Init()
	
	-- Central
	_central_Allies_Max = 0
	_central_HMG = true
	
	_central_Allies_invuln = mkr_hmg_pin_dest
	_central_Allies_Dests = {mkr_hmg_pin_dest}
	_central_Allies_invuln_Max = 4
	_central_Allies_AttackMove = true
	
	local __moveUp = function(gid, idx, sid)
		Cmd_Move(gid, Util_GetRandomPosition(_central_Allies_Dests[1]))
	end
	
	SGroup_ForEach(sg_docks_allies_central, __moveUp)
	
	-- Left
	_left_Allies_invuln = mkr_res_allies_left_dest_01
	_left_Allies_Dests = {mkr_docks_allies_left_dest_01, mkr_res_allies_left_dest_01}
	_left_Allies_Max = 17
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_left)
	local kill = nil
	if spawned > _left_Allies_Max then
		kill = (spawned - (_left_Allies_Max-5))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_left_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_left, __moveUp)
	
	-- Right
	_right_Allies_invuln = mkr_res_allies_right_dest_01
	_right_Allies_Dests = {mkr_docks_allies_right_dest_01, mkr_res_allies_right_dest_01}
	_right_Allies_Max = 15
	_right_Allies_AttackMove = true
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_right)
	local kill = nil
	if spawned > _right_Allies_Max then
		kill = (spawned - (_right_Allies_Max-4))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_right_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_right, __moveUp)

end

function HOWITZER_Allies_Init()
	
	-- Central
	_central_Allies_Max = 20
	_central_HMG = false
	
	_central_Allies_Dests = {mkr_docks_allies_center_dest_01, mkr_res_allies_center_dest_01, mkr_res_allies_center_dest_02}
	_central_Allies_invuln_Max = 8
	_central_Allies_AttackMove = true
	
	local __moveUp = function(gid, idx, sid)
		Cmd_Move(gid, Util_GetRandomPosition(_central_Allies_Dests[3]))
	end
	
	SGroup_ForEach(sg_docks_allies_central, __moveUp)
	
	-- Left
	_left_Allies_Dests = {mkr_docks_allies_left_dest_01, mkr_res_allies_left_dest_01, mkr_res_a_left_despawn}
	_left_Allies_Max = 20
	_left_Allies_despawn = mkr_res_a_left_despawn
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_left)
	local kill = nil
	if spawned > _left_Allies_Max then
		kill = (spawned - (_left_Allies_Max-4))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_left_Allies_Dests[2]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_left, __moveUp)
	
	-- Right
	_right_Allies_Dests = {mkr_docks_allies_right_dest_01, mkr_res_allies_right_dest_01, mkr_res_allies_right_dest_02, mkr_res_a_right_despawn}
	_right_Allies_Max = 20
	_right_Allies_despawn = mkr_res_a_right_despawn
	
	local spawned = SGroup_CountSpawned(sg_docks_allies_right)
	local kill = nil
	if spawned > _right_Allies_Max then
		kill = (spawned - (_right_Allies_Max-5))
	end
	
	local __moveUp = function(gid, idx, sid)
		if kill == nil or kill == 0 then
			Cmd_Move(gid, Util_GetRandomPosition(_right_Allies_Dests[3]))
		elseif kill >= 1 then
			kill = kill-1
			Squad_Kill(sid)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_right, __moveUp)

end


-- Spawn functions
function _allies_left_spawn()

	if _left_Allies_Curr < _left_Allies_Max then
		local squads = World_GetRand(2, 3)
		local _spawn = SGroup_Create("")
		
		for i = 1, squads do
			local spawn = Table_GetRandomItem(_left_Allies_Spawns)
			local _currSG = SGroup_Create("")
			
			Util_CreateSquads(player3, {_currSG, _spawn, sg_docks_allies_left}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, spawn, nil, 1, World_GetRand(2, 3))
			Rule_AddSquadEvent(_allies_left_die, SGroup_GetSpawnedSquadAt(_currSG, 1), GE_SquadKilled)
			Modify_TargetPriority(_currSG, 10)
			SGroup_EnableUIDecorator(_currSG, false)
			SGroup_Destroy(_currSG)
			
			_left_Allies_Curr = _left_Allies_Curr + 1
		end
		
		local path = Table_GetRandomItem(_left_Allies_paths)
		
		Cmd_SquadPath(_spawn, path, true, false, true, 0)
		
		SGroup_Destroy(_spawn)
	end

end

function _allies_central_spawn()

	if _central_Allies_Curr < _central_Allies_Max then
		local squads = World_GetRand(_allies_center_min, _allies_center_max)
		local _spawn = SGroup_Create("")
		
		for i = 1, squads do
			local spawn = Table_GetRandomItem(_central_Allies_Spawns)
			local _currSG = SGroup_Create("")
			
			Util_CreateSquads(player3, {_currSG, _spawn, sg_docks_allies_central}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, spawn, nil, 1, World_GetRand(2, 3))
			Rule_AddSquadEvent(_allies_center_die, SGroup_GetSpawnedSquadAt(_currSG, 1), GE_SquadKilled)
			if _central_Allies_vuln == true then Modify_Vulnerability(_currSG, 5) end
			SGroup_EnableUIDecorator(_currSG, false)
			Modify_TargetPriority(_currSG, 10)
			SGroup_Destroy(_currSG)
			_central_Allies_Curr = _central_Allies_Curr + 1
		end
		
		local path = Table_GetRandomItem(_central_Allies_paths)
		Cmd_SquadPath(_spawn, path, true, false, true, 0)
		SGroup_Destroy(_spawn)
	end

end

function _allies_right_spawn()
	
	if _right_Allies_Curr < _right_Allies_Max then
		local squads = World_GetRand(2, 3)
		local _spawn = SGroup_Create("")
		
		for i = 1, squads do
			local spawn = Table_GetRandomItem(_right_Allies_Spawns)
			local _currSG = SGroup_Create("")
			
			Util_CreateSquads(player3, {_currSG, _spawn, sg_docks_allies_right}, SBP.SOVIET.M01_CONSCRIPT_SQUAD_HARMLESS, spawn, nil, 1, World_GetRand(2, 3))
			Rule_AddSquadEvent(_allies_right_die, SGroup_GetSpawnedSquadAt(_currSG, 1), GE_SquadKilled)
			Modify_TargetPriority(_currSG, 10)
			SGroup_EnableUIDecorator(_currSG, false)
			SGroup_Destroy(_currSG)
			_right_Allies_Curr = _right_Allies_Curr + 1
		end
		
		local path = Table_GetRandomItem(_right_Allies_paths)
		Cmd_SquadPath(_spawn, path, true, false, true, 0)
		SGroup_Destroy(_spawn)
	end
	
end

-- Death functions
function _allies_center_die() _central_Allies_Curr = _central_Allies_Curr - 1 end
function _allies_right_die() _right_Allies_Curr = _right_Allies_Curr - 1 end
function _allies_left_die() _left_Allies_Curr = _left_Allies_Curr - 1 end

-- Despawn functions
function _allies_despawner()
	
	sg_despawn = SGroup_CreateIfNotFound("sg_despawn")
	
	Player_GetAllSquadsNearMarker(player3, sg_despawn, _allies_despawn)
	local _despawn = function(gid, idx, sid)
		local _sg = SGroup_Create("")
		SGroup_Add(_sg, sid)
		
		if SGroup_IsOnScreen(player1, _sg, ALL) == false then SGroup_Kill(_sg) end
		SGroup_Destroy(_sg)
	end
	
	SGroup_ForEach(sg_despawn, _despawn)

end

-- Keep Allies moving
function _allies_keep_moving()
	
	local _Move = function(gid, idx, sid)
		if Squad_IsAttacking(sid, 3) == false
		  and Squad_IsUnderAttack(sid, 3) == false
		  and Squad_IsMoving(sid) == false then
			local tempSG = SGroup_Create("")
			SGroup_Add(tempSG, sid)
			local path = Table_GetRandomItem(_left_Allies_paths)
			
			local rand = World_GetRand(1, 2)
			local attackMove = false
			if rand == 1 then attackMove = true end
			Cmd_SquadPath(tempSG, path, true, false, attackMove, 0)
			SGroup_Destroy(tempSG)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_left, _Move)
	
	local _Move = function(gid, idx, sid)
		if Squad_IsAttacking(sid, 3) == false
		  and Squad_IsUnderAttack(sid, 3) == false
		  and Squad_IsMoving(sid) == false then
			local tempSG = SGroup_Create("")
			SGroup_Add(tempSG, sid)
			local path = Table_GetRandomItem(_central_Allies_paths)
			
			local rand = World_GetRand(1, 2)
			local attackMove = false
			if rand == 1 then attackMove = true end
			if _central_HMG == true then
				Cmd_Move(tempSG, _central_Allies_Dests[1])
			else
				Cmd_SquadPath(tempSG, path, true, false, attackMove, 0)
			end
			SGroup_Destroy(tempSG)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_central, _Move)
	
	local _Move = function(gid, idx, sid)
		if Squad_IsAttacking(sid, 3) == false
		  and Squad_IsUnderAttack(sid, 3) == false
		  and Squad_IsMoving(sid) == false then
			local tempSG = SGroup_Create("")
			SGroup_Add(tempSG, sid)
			local path = Table_GetRandomItem(_right_Allies_paths)
			
			local rand = World_GetRand(1, 2)
			local attackMove = false
			if rand == 1 then attackMove = true end
			Cmd_SquadPath(tempSG, path, true, false, attackMove, 0)
			SGroup_Destroy(tempSG)
		end
	end
	
	SGroup_ForEach(sg_docks_allies_right, _Move)

end
