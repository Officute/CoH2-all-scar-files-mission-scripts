-- 1. ESSENTIAL: Import the core SCAR utility, UI, and objective tracking rules
import("SCARUtil.scar")
import("Objectives.scar")
import("ui.scar") 

-- Declare the parent objective and sub-task checkboxes globally
obj_destroy_bridges = {}
task_left_bridge = {}
task_right_bridge = {}
local obj_secondary_vp = nil

-- Global variables for the Radio and Elimination Missions
local obj_capture_radio = {}
local obj_kill_forces = {}

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
    if Is_Bridge_Destroyed("eg_left_bridge") and Is_Bridge_Destroyed("eg_right_bridge") then
        return
    end

    obj_destroy_bridges = {
        Title = "$77838f451547402c99620752cd8e4aaa:1",
        Description = LOC("Locate and destroy both the left and right bridges."),
        Type = OT_Secondary,
        Visible = true,
    }
    Objective_Register(obj_destroy_bridges)
    Objective_Start(obj_destroy_bridges, true)
    
    task_left_bridge = {
        Title = "$77838f451547402c99620752cd8e4aaa:2",
        Type = OT_Secondary, 
        Parent = obj_destroy_bridges, 
    }
    Objective_Register(task_left_bridge)
    Objective_Start(task_left_bridge, false) 
    
    task_right_bridge = {
        Title = "$77838f451547402c99620752cd8e4aaa:3",
        Type = OT_Secondary,
        Parent = obj_destroy_bridges,
    }
    Objective_Register(task_right_bridge)
    Objective_Start(task_right_bridge, false)
    
    Rule_AddInterval(Check_Bridges, 1)
end

function Is_Bridge_Destroyed(egroup_name)
    if not EGroup_Exists(egroup_name) then return true end
    local eg = EGroup_FromName(egroup_name)
    return (eg == nil) or EGroup_IsEmpty(eg) or (EGroup_Count(eg) == 0)
end

function Check_Bridges()
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
        Title = "$77838f451547402c99620752cd8e4aaa:4",
        Description = LOC("Capture and protect the marked victory points to secure the sector."),
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
            Title = "$77838f451547402c99620752cd8e4aaa:5",
            Description = LOC("Player 1 and 2 must capture the radio tower."),
            Type = OT_Primary,
            Visible = true,
            Target = eg, 
        }
        Objective_Register(obj_capture_radio)
        Objective_Start(obj_capture_radio, true)

        Objective_AddUIElements(obj_capture_radio, eg, "capture", obj_capture_radio.Title)
        Rule_AddInterval(Check_RadioCaptureStatus, 0,125)
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
                    local p1 = World_GetPlayerAt(1)
                    local p2 = World_GetPlayerAt(2)

                    if owner == p1 or owner == p2 then
                        is_radio_captured = true 
                        
                        -- Complete the objective and clear its minimap/UI icons
                        Objective_Complete(obj_capture_radio)
                        Objective_RemoveUIElements(obj_capture_radio)
                        
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
        local player = World_GetPlayerAt(p)
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

-- Timer Event Messages
function Msg_Retreat2Min() Util_MissionTitle ("$77838f451547402c99620752cd8e4aaa:8", 1.0, 5.0) end
function Msg_Retreat1Min() Util_MissionTitle ("$77838f451547402c99620752cd8e4aaa:9", 1.0, 5.0) end
function Msg_RetreatNow()  Util_MissionTitle ("$77838f451547402c99620752cd8e4aaa:10", 1.0, 5.0) end

function EliminationObjective_Start()
    elimination_time_left = 180 

    obj_kill_forces = {
        Title = "$77838f451547402c99620752cd8e4aaa:11",
        Description = LOC("Eliminate all surviving Player 3 and Player 4 forces on the field."),
        Type = OT_Primary,
        Visible = true,
    }
    Objective_Register(obj_kill_forces)
    Objective_Start(obj_kill_forces, true)

    Timer_Start("EliminationTimer", elimination_time_left)
    Timer_Display("EliminationTimer", LOC("Time Remaining"), true)

    -- Trigger 3 minute warning immediately upon start
    Util_MissionTitle ("$77838f451547402c99620752cd8e4aaa:7", 1.0, 5.0)
    
    -- Schedule the exact warnings without looping spam
    Rule_AddOneShot(Msg_Retreat2Min, 60)
    Rule_AddOneShot(Msg_Retreat1Min, 120)
    Rule_AddOneShot(Msg_RetreatNow, 179) 

    local p3 = World_GetPlayerAt(3)
    local p4 = World_GetPlayerAt(4)

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

    if current_rem_time <= 0 then
        Timer_End("EliminationTimer")
        Rule_Remove(Check_EnemyForcesEliminated)
        Rule_RemoveMe()
        Execute_RetreatAndVictorySequence()
    end
end

function Check_EnemyForcesEliminated()
    local p3 = World_GetPlayerAt(3)
    local p4 = World_GetPlayerAt(4)

    local total_enemy_squads = 0

    if p3 ~= nil then total_enemy_squads = total_enemy_squads + Player_GetSquadCount(p3) end
    if p4 ~= nil then total_enemy_squads = total_enemy_squads + Player_GetSquadCount(p4) end

    if total_enemy_squads == 0 then
        Timer_End("EliminationTimer")
        
        if Rule_Exists(Msg_Retreat2Min) then Rule_Remove(Msg_Retreat2Min) end
        if Rule_Exists(Msg_Retreat1Min) then Rule_Remove(Msg_Retreat1Min) end
        if Rule_Exists(Msg_RetreatNow)  then Rule_Remove(Msg_RetreatNow) end
        
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
    local objective_list = {obj_destroy_bridges, task_left_bridge, task_right_bridge, obj_secondary_vp, obj_capture_radio}
    
    for _, obj in ipairs(objective_list) do
        if obj ~= nil and type(obj) == "table" and obj.Title ~= nil then
            if Objective_IsStarted(obj) and not Objective_IsComplete(obj) then
                Objective_Complete(obj)
            end
        end
    end
end

function Trigger_MatchVictory()
    local player1 = World_GetPlayerAt(1)
    local allianceTeam = Player_GetTeam(player1)
    World_SetTeamWin(allianceTeam)
end

----------------------------------------------------------------------------------------
-- INITIALIZATION HOOK
----------------------------------------------------------------------------------------

Scar_AddInit(function()
    Rule_AddOneShot(Mission_Start, 299)
    Rule_AddOneShot(Mission_InitSecondaryObjectives, 0,1)
end)
