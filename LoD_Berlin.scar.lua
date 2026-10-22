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
        -- EGroup_SetSelectable is the documented API for this. It internally
        -- iterates the EGroup and applies the flag to every entity in it.
        -- (There is no global 'Entity_SetSelectable' - that was the crash.)
        EGroup_SetSelectable(eg_noselect, false)
    end
    
end

-- Registers the OnInit function to trigger when the map starts
Scar_AddInit(OnInit)