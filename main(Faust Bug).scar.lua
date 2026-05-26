function FaustBug_Init()
    Rule_AddOneShot(FastBug_DelayedInit, 1/8)
end

function FastBug_DelayedInit()
    Msg("Faust Bug Catcher v 0.01 Loaded")
    FOW_Enable(false)
    AI_EnableAll(false)

    local player = World_GetPlayerAt(1)
    local enemy = World_GetPlayerAt(2)

    -- Global SGroups
    sg_faust_operator = SGroup_CreateIfNotFound("sg_faust_operator")
    sg_faust_target = SGroup_CreateIfNotFound("sg_faust_target")
    
    SGroup_Add(sg_faust_operator, Squad_CreateAndSpawnToward(
        SBP.GERMAN.GRENADIER_SQUAD_MP,
        player,
        1,
        Marker_GetPosition(mkr_faust_operator_spawn),
        Marker_GetPosition(mkr_faust_operator_spawn)
    ))
   
    SGroup_SetInvulnerable(sg_faust_operator, true)
    Player_SetAbilityAvailability(player, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, ITEM_UNLOCKED)
    Player_AddResource(player, RT_Munition, 10000)
    Modify_AbilityRechargeTime(player, ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP, 0.01)
    SGroup_SetAutoTargetting(sg_faust_operator, "hardpoint_01", false)

    -- Setup faust target
    Util_CreateSquads(
        enemy,
        sg_faust_target,
        SBP.AEF.DODGE_WC51_50CAL_SQUAD_MP,
        Marker_GetPosition(mkr_faust_target_spawn)
    )
    SGroup_SetInvulnerable(sg_faust_target, 0.1)
    Cmd_SquadPath(sg_faust_target, "wp_faust_target", true, true, false, 0, nil, false)
    Rule_AddGlobalEvent(FastBug_ProjectileLanded, GE_ProjectileLanded)
    --Modify_UnitSpeed(sg_faust_target, 0.75)
    --SGroup_IncreaseVeterancyRank(sg_faust_target, 3)

    -- Begin fausting
    --Rule_AddInterval(FaustBug_PerformFaust, 5)
    Rule_AddInterval(FaustBug_Tick, 2)
end

function FastBug_ProjectileLanded(projectile, caster, target)
    --[[
    #1: projectile (entity)
    #2: entity (caster)
    #3: target (pos/entity)
    ]]

    if scartype(target) == ST_ENTITY then
        UI_CreateColouredEntityKickerMessage(
            Game_GetLocalPlayer(),
            target,
            Util_CreateLocString("Ouch!"),
            255,
            0,
            0,
            255
        )
        Msg("Registered a hit on an entity.")
    elseif scartype(target) == ST_SCARPOS then
        UI_CreateColouredPositionKickerMessage(
            Game_GetLocalPlayer(),
            target,
            Util_CreateLocString("Dirt!"),
            128,
            128,
            0,
            255
        )
        Msg("Registered a hit on the ground.")
    end
end

function FaustBug_Tick()
    local squad = SGroup_GetSpawnedSquadAt(sg_faust_target, 1)
    if Squad_GetHealthPercentage(squad) < 1 then
        Squad_ForEachEntity(squad, function(entity)
            if Entity_HasCritical(entity, CRIT.VEHICLE_DAMAGE_ENGINE_SNARE) then
                Entity_RemoveCritical(entity, CRIT.VEHICLE_DAMAGE_ENGINE_SNARE)
            end
        end)
        UI_CreateColouredSquadKickerMessage(
            Game_GetLocalPlayer(),
            squad,
            Util_CreateLocString("Healed: " .. (Squad_GetHealthMax(squad) - Squad_GetHealth(squad)) .. " HP"),
            0,
            255,
            0,
            255
        )
        Squad_SetHealth(squad, 1)
    end
end

function FaustBug_PerformFaust()
    -- Let's not auto-trigger the faust ability for now
    --[[
    local operator = SGroup_GetSpawnedSquadAt(sg_faust_operator, 1)
    local target = SGroup_GetSpawnedSquadAt(sg_faust_target, 1)

    Squad_FacePosition(operator, Squad_GetPosition(target))
    Command_SquadSquadAbility(
        Squad_GetPlayerOwner(operator),
        sg_faust_operator,
        sg_faust_target,
        ABILITY.GERMAN.GRENADIER_PANZERFAUST_MP,
        true,
        false
    )
    --]]
end
