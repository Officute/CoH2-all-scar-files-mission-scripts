-- berlin_defend.scar

-- This function runs as soon as the map initializes
function OnInit()
    
    -- 1. Make the Belgian Gates invulnerable
    -- Check if the group exists to prevent crashes if it gets renamed in Worldbuilder
    if EGroup_Exists("eg_belgiangate") then
        EGroup_SetInvulnerable(eg_belgiangate, true)
    end

    -- 2. Make the 'noselect' group unselectable
    if EGroup_Exists("eg_noselect") then
        -- SCAR usually requires disabling selection on a per-entity basis, 
        -- so we loop through the EGroup and apply a helper function to each entity.
        EGroup_ForEach(eg_noselect, DisableSelection)
    end
    
end

-- Helper function that applies the "no select" rule to individual entities within the group
function DisableSelection(groupID, itemIndex, entityID)
    Entity_SetSelectable(entityID, false)
end

-- Registers the OnInit function to trigger when the map starts
Scar_AddInit(OnInit)