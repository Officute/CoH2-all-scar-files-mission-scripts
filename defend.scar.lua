-- CoH2 Worldbuilder Mission Script: test_scar.scar

-- Declare the parent objective and sub-task checkboxes globally
obj_destroy_bridges = {}
task_left_bridge = {}
task_right_bridge = {}

function OnInit()
    -- Start the mission sequence after exactly 7 minutes (420 seconds)
    Rule_AddOneShot(Mission_Start, 420)
end

function Mission_Start()
    -- Check bridge integrity BEFORE registering the objectives.
    -- If they were destroyed early, skip creating the mission entirely.
    if Is_Bridge_Destroyed("eg_left_bridge") and Is_Bridge_Destroyed("eg_right_bridge") then
        return
    end

    -- 1. Main Parent Objective
    obj_destroy_bridges = {
        Title = "Destroy the two bridges",
        Description = "Locate and destroy both the left and right bridges.",
        Type = OT_Secondary,
    }
    Objective_Register(obj_destroy_bridges)
    Objective_Start(obj_destroy_bridges, true)
    
    -- 2. Left Bridge Checkbox Sub-Task
    task_left_bridge = {
        Title = "Destroy the Left bridge",
        Type = OT_Secondary, 
        Parent = obj_destroy_bridges, 
    }
    Objective_Register(task_left_bridge)
    Objective_Start(task_left_bridge, false) 
    
    -- 3. Right Bridge Checkbox Sub-Task
    task_right_bridge = {
        Title = "Destroy the right bridge",
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

-- Hook into the engine's map loading sequence
Scar_AddInit(OnInit)