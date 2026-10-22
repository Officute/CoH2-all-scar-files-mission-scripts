-- 1. ESSENTIAL: Import the core SCAR utility, UI, and objective tracking rules
import("SCARUtil.scar")
import("Objectives.scar")
import("ui.scar")

function Util_CreateLocString(text)
	local tmpstr = LOC(text)
	tmpstr[1] = text
	return tmpstr
end

function Safe_GetPlayer(idx)
	if idx == nil then return nil end
	if idx > World_GetPlayerCount() then return nil end
	return World_GetPlayerAt(idx)
end 

-- Declare the parent objective and sub-task checkboxes globally
obj_destroy_bridges = {}
task_left_bridge = {}
task_right_bridge = {}
local obj_secondary_vp = nil

-- Global variables for the Radio and Elimination Missions
local obj_capture_radio = {}
local obj_kill_forces = {}
local obj_retreat_countdown = nil

-- State safety flag to prevent duplicate rule registration crashes
local is_radio_captured = false

-- Variables for the integrated text timer
local elimination_time_left = 180 -- 3 minutes in seconds

-- Directly list the full blueprint names you want deleted
local blueprints_to_delete = {
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_aa_vehicle_in_7_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_car_in_3_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_elite_squad_in_3_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_heavy_tank_in_15_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_howitzer_tank_in_20_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_infantry_squad_in_5_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_infantry_squad_para_and_recon_units_in_10_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_light_vehicles_in_5_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_light_vehicles_in_5_minutes_one_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_medium_heavy_tank_in_10_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_medium_howitzer_vehicle_in_10_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_mortar_team_in_3_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_mortar_team_in_3_minutes_one_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_officer_in_15_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_para_and_recon_units_in_10_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_tank_in_7_minutes",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_aa_vehicle_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_artillery_vehicles_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_car_halftrack_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_elite_units_every_20_seconds",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_engineers_every_5_seconds",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_heavy_tank_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_howitzer_tank_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_infantry_squad_every_20_seconds",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_light_vehicles_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_medium_heavy_tank_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_mortar_team_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_officer_every_30_seconds",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_para_and_recon_units_every_30_seconds",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_tank_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:attacker_spawn_infantry_and_light_vehicle_in_5_minutes_setup",
    "77af372fe79e4e1d88e9a6e0c077da0b:attacker_spawn_infantry_and_vehicles_setup",
    "77af372fe79e4e1d88e9a6e0c077da0b:attacker_spawn_mortar_and_artillery_or_rocket_vehicle_setup",
    "77af372fe79e4e1d88e9a6e0c077da0b:attacker_starting_spawn_infantry_in_5_minutes_setup",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_mortar_team_every_random_time",
    "77af372fe79e4e1d88e9a6e0c077da0b:spawn_tank_every_random_time"
}

----------------------------------------------------------------------------------------
-- BRIDGE OBJECTIVES SEQUENCE
----------------------------------------------------------------------------------------

function Mission_Start()
    -- Remove the 299-second bridge protection now that objectives begin
    if EGroup_Exists("eg_left_bridge") then
        EGroup_SetSelectable(EGroup_FromName("eg_left_bridge"), true)
        EGroup_SetInvulnerable(EGroup_FromName("eg_left_bridge"), false)
    end
    if EGroup_Exists("eg_right_bridge") then
        EGroup_SetSelectable(EGroup_FromName("eg_right_bridge"), true)
        EGroup_SetInvulnerable(EGroup_FromName("eg_right_bridge"), false)
    end

    Disable_Wrecked_Bridge_Selection()

    if Is_Bridge_Destroyed("eg_left_bridge") and Is_Bridge_Destroyed("eg_right_bridge") then
        return
    end

    obj_destroy_bridges = {
        Title = Util_CreateLocString("Destroy the two bridges"),
        Description = Util_CreateLocString("Locate and destroy both the left and right bridges."),
        Type = OT_Secondary,
        Visible = true,
    }
    Objective_Register(obj_destroy_bridges)
    Objective_Start(obj_destroy_bridges, true)
    
    task_left_bridge = {
        Title = Util_CreateLocString("Destroy the west bridge"),
        Type = OT_Secondary, 
        Parent = obj_destroy_bridges, 
    }
    Objective_Register(task_left_bridge)
    Objective_Start(task_left_bridge, false) 
    
    task_right_bridge = {
        Title = Util_CreateLocString("Destroy the east bridge"),
        Type = OT_Secondary,
        Parent = obj_destroy_bridges,
    }
    Objective_Register(task_right_bridge)
    Objective_Start(task_right_bridge, false)

    -- UI arrows from objectives to the bridges
    if EGroup_Exists("eg_left_bridge") then
        Objective_AddUIElements(task_left_bridge, EGroup_FromName("eg_left_bridge"), true, Util_CreateLocString("Destroy the bridge"), true)
    end
    if EGroup_Exists("eg_right_bridge") then
        Objective_AddUIElements(task_right_bridge, EGroup_FromName("eg_right_bridge"), true, Util_CreateLocString("Destroy the bridge"), true)
    end

    Rule_AddInterval(Check_Bridges, 1)
end

function Is_Bridge_Destroyed(egroup_name)
    if not EGroup_Exists(egroup_name) then return true end
    local eg = EGroup_FromName(egroup_name)
    return (eg == nil) or EGroup_IsEmpty(eg) or (EGroup_Count(eg) == 0)
end

function Check_Bridges()
    Disable_Wrecked_Bridge_Selection()

    local left_destroyed = Is_Bridge_Destroyed("eg_left_bridge")
    local right_destroyed = Is_Bridge_Destroyed("eg_right_bridge")
    
    if left_destroyed and not Objective_IsComplete(task_left_bridge) then
        Objective_Complete(task_left_bridge)
    end
    
    if right_destroyed and not Objective_IsComplete(task_right_bridge) then
        Objective_Complete(task_right_bridge)
    end
    
    if left_destroyed and right_destroyed then
        Objective_Complete(obj_destroy_bridges)
        Rule_Remove(Check_Bridges)
    end
end

----------------------------------------------------------------------------------------
-- TIMED AND CONDITIONAL SEQUENCES (5-MINUTE MARK)
----------------------------------------------------------------------------------------

function Mission_InitSecondaryObjectives()
    Rule_AddOneShot(SecondaryObjective_ExpandMap, 299)
    Rule_AddOneShot(Evaluate_FiveMinuteCondition, 298)
end

function SecondaryObjective_ExpandMap()
    World_IncreaseInteractionStage()
end

function Evaluate_FiveMinuteCondition()
    local vp_exists = false
    if EGroup_Exists("eg_victory_point") and EGroup_CountSpawned(EGroup_FromName("eg_victory_point")) > 0 then
        vp_exists = true
    end

    if vp_exists then
        SecondaryObjective_Start()
    else
        RadioObjective_Start()
    end
end

function SecondaryObjective_Start()
    obj_secondary_vp = {
        Title = Util_CreateLocString("Capture and hold the two Victory Points"),
        Description = Util_CreateLocString("Capture and protect the marked victory points to secure the sector."),
        Type = OT_Secondary,
        Visible = true,
    }
    Objective_Register(obj_secondary_vp)
    Objective_Start(obj_secondary_vp, true)
end

----------------------------------------------------------------------------------------
-- RADIO TOWER PRIMARY SEQUENCE & REINFORCEMENT DELETION
----------------------------------------------------------------------------------------

function RadioObjective_Start()
    if EGroup_Exists("eg_radio") then
        local eg = EGroup_FromName("eg_radio")
        
        obj_capture_radio = {
            Title = Util_CreateLocString("Capture the Radio Tower"),
            Description = Util_CreateLocString("Player 1 and 2 must capture the radio tower."),
            Type = OT_Primary,
            Visible = true,
            Target = eg, 
        }
        Objective_Register(obj_capture_radio)
        Objective_Start(obj_capture_radio, true)

        Objective_AddUIElements(obj_capture_radio, eg, "capture", obj_capture_radio.Title, true)
        Rule_AddInterval(Check_RadioCaptureStatus, 0.125)
    end
end

function Check_RadioCaptureStatus()
    if is_radio_captured then return end

    if EGroup_Exists("eg_radio") then
        local eg = EGroup_FromName("eg_radio")
        
        if EGroup_CountSpawned(eg) > 0 then
            local entity = EGroup_GetSpawnedEntityAt(eg, 1)
            
            if entity ~= nil then
                if not World_OwnsEntity(entity) then
                    local owner = Entity_GetPlayerOwner(entity)
                    local p1 = Safe_GetPlayer(1)
                    local p2 = Safe_GetPlayer(2)

                    if owner == p1 or owner == p2 then
                        is_radio_captured = true 
                        
                        -- Complete the objective and clear its minimap/UI icons
                        Objective_Complete(obj_capture_radio)
                        Objective_RemoveUIElements(obj_capture_radio)

                        -- Remove bridge objectives silently when radio is captured (no completed popups)
                        for _, _o in ipairs({obj_destroy_bridges, task_left_bridge, task_right_bridge}) do
                            if _o ~= nil and type(_o) == "table" and _o.Title ~= nil and Objective_IsStarted(_o) and not Objective_IsComplete(_o) then
                                Objective_Complete(_o, false)
                            end
                        end

                        if not Rule_Exists(Delete_SpawnerEntitiesLoop) then
                            Rule_AddInterval(Delete_SpawnerEntitiesLoop, 1)
                        end
                        
                        EliminationObjective_Start()
                        Rule_RemoveMe()
                    end
                end
            end
        end
    end
end

function Delete_SpawnerEntitiesLoop()
    local found_any = false

    for p = 1, 4 do
        local player = Safe_GetPlayer(p)
        if player ~= nil then
            local eg = Player_GetEntities(player)
            if eg ~= nil then
                local count = EGroup_CountSpawned(eg)
                
                for i = count, 1, -1 do
                    local entity = EGroup_GetSpawnedEntityAt(eg, i)
                    if entity ~= nil then
                        local ebp = Entity_GetBlueprint(entity)
                        local bp_name = string.lower(BP_GetName(ebp))
                        
                        for _, target_bp in ipairs(blueprints_to_delete) do
                            if bp_name == string.lower(target_bp) or string.find(bp_name, string.lower(target_bp), 1, true) then
                                Entity_Destroy(entity)
                                found_any = true
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    if not found_any then
        Rule_RemoveMe()
    end
end

----------------------------------------------------------------------------------------
-- ENDGAME ELIMINATION MECHANICS
----------------------------------------------------------------------------------------

function EliminationObjective_Start()
    elimination_time_left = 180 

    obj_kill_forces = {
        Title = Util_CreateLocString("Kill all the remaining enemy forces"),
        Description = Util_CreateLocString("Eliminate all surviving Player 3 and Player 4 forces on the field."),
        Type = OT_Primary,
        Visible = true,
    }
    Objective_Register(obj_kill_forces)
    Objective_Start(obj_kill_forces, true)

    -- Primary countdown objective: "Enemy forces will retreat in: 3:00"
    obj_retreat_countdown = {
        Title = Util_CreateLocString("Enemy forces will retreat in:"),
        TitleEnd = nil,
        Type = OT_Primary,
        Visible = true,
    }
    Objective_Register(obj_retreat_countdown)
    Objective_Start(obj_retreat_countdown, false)

    Timer_Start("EliminationTimer", elimination_time_left)
    Timer_Display("EliminationTimer", Util_CreateLocString("Time Remaining"), true)

    local p3 = Safe_GetPlayer(3)
    local p4 = Safe_GetPlayer(4)

    if p3 ~= nil then
        Player_SetResource(p3, RT_Manpower, 0)
        Player_SetResource(p3, RT_Fuel, 0)
        Modify_PlayerResourceRate(p3, RT_Manpower, 0)
        Modify_PlayerResourceRate(p3, RT_Fuel, 0)
        Modify_PlayerResourceRate(p3, RT_Munition, 0)
    end

    if p4 ~= nil then
        Player_SetResource(p4, RT_Manpower, 0)
        Player_SetResource(p4, RT_Fuel, 0)
        Modify_PlayerResourceRate(p4, RT_Manpower, 0)
        Modify_PlayerResourceRate(p4, RT_Fuel, 0)
        Modify_PlayerResourceRate(p4, RT_Munition, 0)
    end

    Rule_AddInterval(Update_EliminationTimerTextLoop, 1)
    Rule_AddInterval(Check_EnemyForcesEliminated, 1)
end

function Update_EliminationTimerTextLoop()
    local current_rem_time = Timer_GetRemaining("EliminationTimer")

    -- Update the countdown objective title without popups/parentheses
    if obj_retreat_countdown ~= nil and Objective_IsStarted(obj_retreat_countdown) and not Objective_IsComplete(obj_retreat_countdown) then
        local mins = math.floor(current_rem_time / 60)
        local secs = math.floor(math.mod(current_rem_time, 60))
        if secs < 10 then secs = "0" .. secs end
        Objective_UpdateText(obj_retreat_countdown, Util_CreateLocString("Enemy forces will retreat in: " .. mins .. ":" .. secs), nil, false)
    end

    if current_rem_time <= 0 then
        Timer_End("EliminationTimer")
        if obj_retreat_countdown ~= nil then
            Objective_Complete(obj_retreat_countdown, false)
            obj_retreat_countdown = nil
        end
        Rule_Remove(Check_EnemyForcesEliminated)
        Rule_RemoveMe()
        Execute_RetreatAndVictorySequence()
    end
end

function Check_EnemyForcesEliminated()
    local p3 = Safe_GetPlayer(3)
    local p4 = Safe_GetPlayer(4)

    local total_enemy_squads = 0

    local has_enemy = (p3 ~= nil or p4 ~= nil)
    if p3 ~= nil then total_enemy_squads = total_enemy_squads + Player_GetSquadCount(p3) end
    if p4 ~= nil then total_enemy_squads = total_enemy_squads + Player_GetSquadCount(p4) end

    if has_enemy and total_enemy_squads == 0 then
        Timer_End("EliminationTimer")

        if obj_retreat_countdown ~= nil then
            Objective_Complete(obj_retreat_countdown, false)
            obj_retreat_countdown = nil
        end

        Rule_Remove(Update_EliminationTimerTextLoop)
        Rule_RemoveMe()
        Execute_RetreatAndVictorySequence()
    end
end

function Execute_RetreatAndVictorySequence()
    -- Complete objectives and wrap up match
    if Objective_IsStarted(obj_kill_forces) and not Objective_IsComplete(obj_kill_forces) then
        Objective_Complete(obj_kill_forces)
    end
    
    Cleanup_AllObjectives()
    Rule_AddOneShot(Trigger_MatchVictory, 5)
end

function Cleanup_AllObjectives()
    local objective_list = {obj_destroy_bridges, task_left_bridge, task_right_bridge, obj_secondary_vp, obj_capture_radio, obj_kill_forces, obj_retreat_countdown}
    
    for _, obj in ipairs(objective_list) do
        if obj ~= nil and type(obj) == "table" and obj.Title ~= nil then
            if Objective_IsStarted(obj) and not Objective_IsComplete(obj) then
                Objective_Complete(obj, false)
            end
        end
    end
end

function Trigger_MatchVictory()
    local player1 = Safe_GetPlayer(1)
    if player1 == nil then player1 = Safe_GetPlayer(2) end
    if player1 == nil then player1 = Safe_GetPlayer(3) end
    if player1 == nil then player1 = Safe_GetPlayer(4) end
    if player1 == nil then return end
    local allianceTeam = Player_GetTeam(player1)
    World_SetTeamWin(allianceTeam)
end

----------------------------------------------------------------------------------------
-- INITIALIZATION HOOK
----------------------------------------------------------------------------------------

-- Protect bridges for the first 299 seconds (non-selectable + invulnerable)
function Bridge_Protection_Init()
    if EGroup_Exists("eg_left_bridge") and EGroup_Exists("eg_right_bridge") then
        eg_left_bridge = EGroup_FromName("eg_left_bridge")
        eg_right_bridge = EGroup_FromName("eg_right_bridge")
        EGroup_SetSelectable(eg_left_bridge, false)
        EGroup_SetSelectable(eg_right_bridge, false)
        EGroup_SetInvulnerable(eg_right_bridge, true)
        EGroup_SetInvulnerable(eg_left_bridge, true)
    end
    Disable_Wrecked_Bridge_Selection()
end

-- Prevent repair of destroyed bridges by disabling selection on wrecked bridge entities
function Disable_Wrecked_Bridge_Selection()
    -- Marker-based check: when a bridge is destroyed, a marker appears; disable selection in its radius
    for _, mname in ipairs({"mkr_left_bridge_killed", "mkr_right_bridge_killed"}) do
        if Marker_Exists(mname, "") then
            local marker = Marker_FromName(mname, "")
            local eg = EGroup_CreateIfNotFound("eg_tmp_killed_bridge")
            EGroup_Clear(eg)
            local _p = Safe_GetPlayer(1)
            if _p == nil then _p = Safe_GetPlayer(2) end
            if _p == nil then _p = Safe_GetPlayer(3) end
            if _p == nil then _p = Safe_GetPlayer(4) end
            if _p ~= nil then
                World_GetEntitiesNearMarker(_p, eg, marker, OT_Neutral)
            end
            -- Keep only wrecked bridge entities, then disable selection
            EGroup_Filter(eg, BP_GetEntityBlueprint("bridge_m6_pont_tourant_wrecked"), FILTER_KEEP)
            EGroup_SetSelectable(eg, false)
        end
    end
end

Scar_AddInit(function()
    Bridge_Protection_Init()
    Rule_AddInterval(Disable_Wrecked_Bridge_Selection, 1)
    Rule_AddOneShot(Mission_Start, 299)
    Rule_AddOneShot(Mission_InitSecondaryObjectives, 0,1)
end)