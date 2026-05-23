-- 1. ESSENTIAL: Import the core SCAR utility rules
import("SCARUtil.scar")

-- Declare the parent objective and sub-task checkboxes globally
obj_destroy_bridges = {}
task_left_bridge = {}
task_right_bridge = {}
local obj_secondary_vp = nil

function Mission_Start()
    -- Check bridge integrity BEFORE registering the objectives.
    if Is_Bridge_Destroyed("eg_left_bridge") and Is_Bridge_Destroyed("eg_right_bridge") then
        return
    end

    -- Main Parent Objective Setup using standard CoH2 Table Formatting
    obj_destroy_bridges = {
        Title = LOC("Destroy the two bridges"),
        Description = LOC("Locate and destroy both the left and right bridges."),
        Type = OT_Secondary,
        Visible = true,
    }
    Objective_Register(obj_destroy_bridges)
    Objective_Start(obj_destroy_bridges, true)
    
    -- Left Bridge Checkbox Sub-Task
    task_left_bridge = {
        Title = LOC("Destroy the left bridge"),
        Type = OT_Secondary, 
        Parent = obj_destroy_bridges, 
    }
    Objective_Register(task_left_bridge)
    Objective_Start(task_left_bridge, false) 
    
    -- Right Bridge Checkbox Sub-Task
    task_right_bridge = {
        Title = LOC("Destroy the right bridge"),
        Type = OT_Secondary,
        Parent = obj_destroy_bridges,
    }
    Objective_Register(task_right_bridge)
    Objective_Start(task_right_bridge, false)
    
    -- Start checking the status of both bridges every 1 second
    Rule_AddInterval(Check_Bridges, 1)
end

-- Helper function to safely check if an EGroup is destroyed, empty, or missing
function Is_Bridge_Destroyed(egroup_name)
    if not EGroup_Exists(egroup_name) then return true end
    local eg = EGroup_FromName(egroup_name)
    return (eg == nil) or EGroup_IsEmpty(eg) or (EGroup_Count(eg) == 0)
end

function Check_Bridges()
    local left_destroyed = Is_Bridge_Destroyed("eg_left_bridge")
    local right_destroyed = Is_Bridge_Destroyed("eg_right_bridge")
    
    -- Check off the Left bridge checkbox if destroyed
    if left_destroyed and not Objective_IsComplete(task_left_bridge) then
        Objective_Complete(task_left_bridge)
    end
    
    -- Check off the Right bridge checkbox if destroyed
    if right_destroyed and not Objective_IsComplete(task_right_bridge) then
        Objective_Complete(task_right_bridge)
    end
    
    -- If BOTH checkboxes are complete, finish the entire main objective block safely
    if left_destroyed and right_destroyed then
        Objective_Complete(obj_destroy_bridges)
        -- Stop checking
        Rule_Remove(Check_Bridges)
    end
end

-- Function to initialize the secondary mission tracking
function Mission_InitSecondaryObjectives()
    -- FIXED: The Map Unlock timer runs unconditionally at 4:55 (295 seconds)
    Rule_AddOneShot(SecondaryObjective_ExpandMap, 295)

    -- The UI Objective at 5:00 (300 seconds) ONLY spawns if the group exists
    if EGroup_Exists("eg_victory_point") and EGroup_Count(EGroup_FromName("eg_victory_point")) > 0 then
        Rule_AddOneShot(SecondaryObjective_Start, 300)
    end
end

-- Triggers exactly at 4:55 (295 seconds)
function SecondaryObjective_ExpandMap()
    -- Advances the map environment past the Stage 1 out-of-bounds restrictions
    World_IncreaseInteractionStage()
end

-- Objective UI setup function triggered at 5:00 (300 seconds)
function SecondaryObjective_Start()
    obj_secondary_vp = {
        Title = LOC("Capture and hold the two Victory Points"),
        Description = LOC("Capture and protect the marked victory points to secure the sector."),
        Type = OT_Secondary,
        Visible = true,
    }
    
    Objective_Register(obj_secondary_vp)
    Objective_Start(obj_secondary_vp, true)
end

-- Combined OnInit inline execution directly inside the system hook loop
Scar_AddInit(function()
    -- Start primary bridge sequence after 7 minutes
    Rule_AddOneShot(Mission_Start, 420)
    -- Start validation check for VPs after 1 second
    Rule_AddOneShot(Mission_InitSecondaryObjectives, 1)
end)
