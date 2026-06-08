-- CoH2 Mission Script: Pegasus Bridge (6 June 1944)
-- Co-op Mission Configuration with Native Player Restrictions

import("ScarUtil.scar")
import("objectives.scar")
import("player.scar")

-- -----------------------------------------------------------------------------
-- Global Tracking Variables
-- -----------------------------------------------------------------------------
counterattack_wave_id = 0
defend_seconds_left = 1200 -- 20 minutes in seconds
counterattack_delay = 0    -- Dynamic countdown tracker for spawning waves
is_secondary_obj_active = false -- Safe state variable tracking objective activity

-- Modifier IDs for Player 5
p5_mp_mod = nil
p5_mun_mod = nil
p5_fuel_mod = nil

-- -----------------------------------------------------------------------------
-- Compatibility Layer for Custom Maps
-- -----------------------------------------------------------------------------

function LOC(text)
    return text
end

-- -----------------------------------------------------------------------------
-- Core Mission Initialization
-- -----------------------------------------------------------------------------
function OnInit()
    
    p1 = World_GetPlayerAt(1) -- Human Player 1 (British Commandos)
    p2 = World_GetPlayerAt(2) -- Human Player 2 (British Commandos)
    p3 = World_GetPlayerAt(3) -- Allied Player 3 (Endgame Reinforcements)
    p4 = World_GetPlayerAt(4) -- AI West German (Scripted Counter-attacks)
    p5 = World_GetPlayerAt(5) -- AI West German (Base Defense)
    
    for _, human_player in ipairs({p1, p2}) do
        if human_player ~= nil then
            Player_SetResource(human_player, RT_Manpower, 1000)
            Player_SetResource(human_player, RT_Munition, 60)
            Player_SetResource(human_player, RT_Fuel, 25)
            Player_SetResource(human_player, RT_Command, 0)
        end
    end
    
    if p5 ~= nil then
        -- Save the ModIDs so we can remove them later
        p5_mp_mod = Modify_PlayerResourceRate(p5, RT_Manpower, 0, MUT_Multiplication)
        p5_mun_mod = Modify_PlayerResourceRate(p5, RT_Munition, 0, MUT_Multiplication)
        p5_fuel_mod = Modify_PlayerResourceRate(p5, RT_Fuel, 0, MUT_Multiplication)
        
        Player_SetResource(p5, RT_Manpower, 1000)
        Player_SetResource(p5, RT_Munition, 100)
        Player_SetResource(p5, RT_Fuel, 100)
        Player_SetResource(p5, RT_Command, 0)
    end
    
    if p3 ~= nil then AI_Enable(p3, false) end
    if p4 ~= nil then AI_Enable(p4, false) end
    if p5 ~= nil then AI_Enable(p5, false) end
    
    UI_SetCPMeterVisibility(false)
    UI_SetAbilityCardVisibility(false)
    
    DisableSpecificAbilities()
    
    EGroup_SetInvulnerable(eg_bridge, true)
    
    Rule_AddInterval(Rule_LockdownPlayerProgression, 0.5)
    Rule_AddInterval(Rule_CheckOstruppenTrigger, 2)
    
    SpawnInitialGarrisons()
    
    SetupMissionObjectives()
    Objective_Start(obj_capture_vp, true)
    
    if eg_vp ~= nil then
        Objective_AddUIElements(obj_capture_vp, eg_vp, true, false)
    end
    
    Rule_AddOneShot(Rule_SpawnInitialVolks, 5)
    Rule_AddInterval(Rule_CheckVPCapture, 1)
    
end

-- -----------------------------------------------------------------------------
-- Ability & Unit Exclusion Configuration
-- -----------------------------------------------------------------------------
function DisableSpecificAbilities()
    local target_abilities = {
        "qf_25lb_coordinated_fire_order_sniper_mp",
        "smoke_barrage_tommy_flare_officer_mp",
        "qf_25lb_coordinated_fire_order_officer_no_smoke_mp",
        "officer_recon_sweep",
        "assault_sections",
        "m1_81mm_mortar_dispatch_brits_mp",
        "raid_section_mp",
        "field_recovery",
        "brit_repair_ability_tommys_mp",
        "piat_deploy_mp"
    }
    
    for i = 1, 5 do
        local p = World_GetPlayerAt(i)
        if p ~= nil then
            for _, abp_name in ipairs(target_abilities) do
                local abp = BP_GetAbilityBlueprint(abp_name)
                if abp ~= nil then
                    Player_SetAbilityAvailability(p, abp, ITEM_REMOVED)
                end
            end
            
            local mortar_sbp = BP_GetSquadBlueprint("mortar_team_81mm_mp")
            if mortar_sbp ~= nil then
                Player_SetSquadProductionAvailability(p, mortar_sbp, ITEM_REMOVED)
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- Commander & Ability Lockdown Loop
-- -----------------------------------------------------------------------------
function Rule_LockdownPlayerProgression()
    for i = 1, 5 do
        local player = World_GetPlayerAt(i)
        if player ~= nil then
            if Player_GetResource(player, RT_Command) > 0 then
                Player_SetResource(player, RT_Command, 0)
            end
        end
    end
end

-- -----------------------------------------------------------------------------
-- UI Objectives Setup
-- -----------------------------------------------------------------------------
function SetupMissionObjectives()
    obj_capture_vp = {
        ID = "obj_capture_vp",
        Type = OT_Primary,
        Title = "$9729de9631714bf88ce09528f637a36e:1",
        Description = LOC("Secure the vital bridge before German reinforcements dig in."),
        Visible = true,
    }
    Objective_Register(obj_capture_vp)
    
    obj_defend_vp = {
        ID = "obj_defend_vp",
        Type = OT_Primary,
        Title = "$9729de9631714bf88ce09528f637a36e:2",
		TitleEnd = "$9729de9631714bf88ce09528f637a36e:2",
		TitleFail = "$9729de9631714bf88ce09528f637a36e:2",
        Description = LOC("Defend the bridge at all costs. Do not let the Axis recapture it!"),
        Visible = true,
    }
    Objective_Register(obj_defend_vp)
    
    obj_destroy_base = {
        ID = "obj_destroy_base",
        Type = OT_Secondary,
        Title = "$9729de9631714bf88ce09528f637a36e:3",
        Description = LOC("Locate and destroy the German HQ to weaken regional counter-attacks."),
        Visible = true,
    }
    Objective_Register(obj_destroy_base)
end

-- -----------------------------------------------------------------------------
-- Initial Garrison Logic
-- -----------------------------------------------------------------------------
function SpawnInitialGarrisons()
    if p4 == nil then return end 
    
    local sbp_bunker = BP_GetSquadBlueprint("panzerfusilier_squad_mp")
    local sbp_mg34 = BP_GetSquadBlueprint("mg34_heavy_machine_gun_squad_mp")
    
    if eg_bunker ~= nil then
        local sg_bunker_occupants = SGroup_CreateIfNotFound("sg_bunker_occupants")
        local pos_bunker = EGroup_GetPosition(eg_bunker)
        local squad1 = Squad_CreateAndSpawnToward(sbp_bunker, p4, 0, pos_bunker, pos_bunker)
        SGroup_Add(sg_bunker_occupants, squad1)
        Cmd_Garrison(sg_bunker_occupants, eg_bunker, false)
    end
    
    if eg_building_mg34 ~= nil then
        local sg_building_occupants = SGroup_CreateIfNotFound("sg_building_occupants")
        local pos_mg34 = EGroup_GetPosition(eg_building_mg34)
        local squad2 = Squad_CreateAndSpawnToward(sbp_mg34, p4, 0, pos_mg34, pos_mg34)
        SGroup_Add(sg_building_occupants, squad2)
        Cmd_Garrison(sg_building_occupants, eg_building_mg34, false)
    end
end

-- -----------------------------------------------------------------------------
-- Fixed Volks movement pathing logic
-- -----------------------------------------------------------------------------
function Rule_SpawnInitialVolks()
    if p4 == nil then return end
    
    local sbp_volkes = BP_GetSquadBlueprint("volksgrenadier_squad_mp")
    
    if mkr_volkspawn1 ~= nil and start_volks1 ~= nil then
        local sg_volks1 = SGroup_CreateIfNotFound("sg_volks1")
        local spawn_pos1 = Marker_GetPosition(mkr_volkspawn1)
        local target_pos1 = Marker_GetPosition(start_volks1)
        local squad1 = Squad_CreateAndSpawnToward(sbp_volkes, p4, 0, spawn_pos1, spawn_pos1)
        SGroup_Add(sg_volks1, squad1)
        Cmd_AttackMove(sg_volks1, target_pos1)
    end
    
    if mkr_volkspawn2 ~= nil and start_volks2 ~= nil then
        local sg_volks2 = SGroup_CreateIfNotFound("sg_volks2")
        local spawn_pos2 = Marker_GetPosition(mkr_volkspawn2)
        local target_pos2 = Marker_GetPosition(start_volks2)
        local squad2 = Squad_CreateAndSpawnToward(sbp_volkes, p4, 0, spawn_pos2, spawn_pos2)
        SGroup_Add(sg_volks2, squad2)
        Cmd_AttackMove(sg_volks2, target_pos2)
    end
end

-- -----------------------------------------------------------------------------
-- Custom Trigger: Ostruppen Proximity Ambush
-- -----------------------------------------------------------------------------
function Rule_CheckOstruppenTrigger()
    if mkr_triggerspawnost == nil or p4 == nil then return end
    
    local trigger_pos = Marker_GetPosition(mkr_triggerspawnost)
    local is_triggered = false
    
    for _, player in ipairs({p1, p2}) do
        if player ~= nil then
            local sg_player = Player_GetSquads(player)
            local squad_count = SGroup_CountSpawned(sg_player)
            
            for i = 1, squad_count do
                local squad = SGroup_GetSpawnedSquadAt(sg_player, i)
                if squad ~= nil then
                    local squad_pos = Squad_GetPosition(squad)
                    local dx = trigger_pos.x - squad_pos.x
                    local dz = trigger_pos.z - squad_pos.z
                    
                    if (dx*dx + dz*dz) < 625 then
                        is_triggered = true
                        break
                    end
                end
            end
        end
        if is_triggered then break end
    end
    
    if is_triggered then
        Rule_RemoveMe()
        
        local sbp_ost = BP_GetSquadBlueprint("ostruppen_squad_mp")
        
        if mkr_spawnost1 ~= nil and mkr_ostmove1 ~= nil then
            local sg_ost1 = SGroup_CreateIfNotFound("sg_ost1")
            local pos1 = Marker_GetPosition(mkr_spawnost1)
            local squad1 = Squad_CreateAndSpawnToward(sbp_ost, p4, 0, pos1, pos1)
            SGroup_Add(sg_ost1, squad1)
            Cmd_AttackMove(sg_ost1, Marker_GetPosition(mkr_ostmove1))
        end
        
        if mkr_spawnost2 ~= nil and mkr_ostmove2 ~= nil then
            local sg_ost2 = SGroup_CreateIfNotFound("sg_ost2")
            local pos2 = Marker_GetPosition(mkr_spawnost2)
            local squad2 = Squad_CreateAndSpawnToward(sbp_ost, p4, 0, pos2, pos2)
            SGroup_Add(sg_ost2, squad2)
            Cmd_AttackMove(sg_ost2, Marker_GetPosition(mkr_ostmove2))
        end
    end
end

-- -----------------------------------------------------------------------------
-- Primary Objective Phase 1: Capture Verification & Area Opening
-- -----------------------------------------------------------------------------
function Rule_CheckVPCapture()
    if eg_vp == nil then return end

    local capturedByP1 = (p1 ~= nil) and EGroup_IsCapturedByPlayer(eg_vp, p1, false)
    local capturedByP2 = (p2 ~= nil) and EGroup_IsCapturedByPlayer(eg_vp, p2, false)
    
    if capturedByP1 or capturedByP2 then
        Rule_RemoveMe()
        
        if sg_change ~= nil then
            SGroup_SetPlayerOwner(sg_change, p5)
        end
        
        World_IncreaseInteractionStage()
        Objective_Complete(obj_capture_vp)
        StartDefensePhase()
    end
end

-- -----------------------------------------------------------------------------
-- Primary Objective Phase 2: The 20-Minute Defense & Secondary Objective
-- -----------------------------------------------------------------------------
function StartDefensePhase()
    if p5 ~= nil then 
        -- Destroy the 0x multipliers applied during OnInit() to restore normal base income
        if p5_mp_mod ~= nil then Modifier_Remove(p5_mp_mod) end
        if p5_mun_mod ~= nil then Modifier_Remove(p5_mun_mod) end
        if p5_fuel_mod ~= nil then Modifier_Remove(p5_fuel_mod) end

        AI_Enable(p5, true) 
    end
    
    Objective_Start(obj_defend_vp, true)
    Objective_Start(obj_destroy_base, true)
    is_secondary_obj_active = true 
    
    if eg_vp ~= nil then
        Objective_AddUIElements(obj_defend_vp, eg_vp, true, false)
    end
    
    if eg_german_hq ~= nil then
        Objective_AddUIElements(obj_destroy_base, eg_german_hq, true, false)
    end
    
    Game_LoadAtmosphere("DATA:/art/scenarios/presets/atmosphere/xp2/8p_essen_steelworks.aps", 1200)
    
    Timer_Start("defend_timer", 1200) 
    
    Rule_AddInterval(Rule_UpdateTimerUI, 1)
    Rule_AddInterval(Rule_CheckDefenseTimer, 1)
    Rule_AddInterval(Rule_CheckSecondaryObjective, 1)
    
    counterattack_delay = 30
    Rule_AddInterval(Rule_ManageCounterAttackTimer, 1)
end

-- -----------------------------------------------------------------------------
-- Real-time UI Objective Timer Formatting
-- -----------------------------------------------------------------------------
function Rule_UpdateTimerUI()
    if defend_seconds_left > 0 then
        defend_seconds_left = defend_seconds_left - 1
    end
    
    local minutes = 0
    local seconds = defend_seconds_left
    while seconds >= 60 do
        minutes = minutes + 1
        seconds = seconds - 60
    end
    
    local seconds_string = tostring(seconds)
    if seconds < 10 then
        seconds_string = "0" .. seconds_string
    end
    
    local clock_string = "Hold the Pegasus Bridge (" .. tostring(minutes) .. ":" .. seconds_string .. ")"
    Objective_UpdateText(obj_defend_vp, (clock_string), nil, false)
end

-- -----------------------------------------------------------------------------
-- Secondary Objective: HQ Neutralization & Structure Conversion
-- -----------------------------------------------------------------------------
function Rule_CheckSecondaryObjective()
    if eg_german_hq == nil then return end
    
    if EGroup_IsEmpty(eg_german_hq) then
        Rule_RemoveMe()
        is_secondary_obj_active = false 
        
        if eg_german_building ~= nil and not EGroup_IsEmpty(eg_german_building) then
            EGroup_SetWorldOwned(eg_german_building) 
        end
        
        Objective_Complete(obj_destroy_base)
    end
end

-- -----------------------------------------------------------------------------
-- Safe AI Counter-Attack Timer Management (Chained Movement Layout)
-- -----------------------------------------------------------------------------
function Rule_ManageCounterAttackTimer()
    if p4 == nil or eg_vp == nil then return end
    
    counterattack_delay = counterattack_delay - 1
    
    if counterattack_delay <= 0 then
        counterattack_delay = 30 
        
        local elapsed_seconds = 1200 - defend_seconds_left
        local wave_squads = {}
        
        if elapsed_seconds < 120 then
            if World_GetRand(1, 2) == 1 then
                table.insert(wave_squads, "volksgrenadier_squad_mp")
            else
                table.insert(wave_squads, "panzerfusilier_squad_mp")
            end
            
        elseif elapsed_seconds < 300 then
            local bp = (World_GetRand(1, 2) == 1) and "volksgrenadier_squad_mp" or "panzerfusilier_squad_mp"
            for i=1, 3 do table.insert(wave_squads, bp) end
            
        elseif elapsed_seconds < 420 then
            table.insert(wave_squads, "assault_grenadier_squad_mp")
            table.insert(wave_squads, "grenadier_squad_mp")
            table.insert(wave_squads, "infantry_250_halftrack_mp")
            
        elseif elapsed_seconds < 600 then
            table.insert(wave_squads, "assault_grenadier_squad_mp")
            table.insert(wave_squads, "grenadier_squad_mp")
            table.insert(wave_squads, "kubelwagen_squad_mp")
            table.insert(wave_squads, "sdkfz_251_17_flak_halftrack_squad_mp")
            table.insert(wave_squads, "infantry_250_halftrack_mp")
            
        else
            table.insert(wave_squads, "panzer_grenadier_squad_mp")
            table.insert(wave_squads, "panzer_grenadier_squad_mp")
            table.insert(wave_squads, "panzer_ii_luchs_squad_mp")
            table.insert(wave_squads, "panzer_iv_squad_mp")
        end
        
        local routes = {}
        if mkr_counterattackleft ~= nil and german_counterattackleft ~= nil then
            table.insert(routes, {spawn = mkr_counterattackleft, target = german_counterattackleft, id = "left"})
        end
        if mkr_counterattackright ~= nil and german_counterattackright ~= nil then
            table.insert(routes, {spawn = mkr_counterattackright, target = german_counterattackright, id = "right"})
        end
        if mkr_counterattackup ~= nil and german_counterattackup ~= nil then
            table.insert(routes, {spawn = mkr_counterattackup, target = german_counterattackup, id = "up"})
        end
        
        local spawn_pos
        local pathing_queue = {}
        
        if #routes > 0 then
            local chosen_route = routes[World_GetRand(1, #routes)]
            spawn_pos = Marker_GetPosition(chosen_route.spawn)
            
            table.insert(pathing_queue, Marker_GetPosition(chosen_route.target))
            
            if (chosen_route.id == "left" or chosen_route.id == "right") and german_counterattackup ~= nil then
                table.insert(pathing_queue, Marker_GetPosition(german_counterattackup))
            end
        end
        
        counterattack_wave_id = counterattack_wave_id + 1
        local sg_wave = SGroup_CreateIfNotFound("sg_wave_" .. counterattack_wave_id)
        
        for _, bp_name in ipairs(wave_squads) do
            local sbp = BP_GetSquadBlueprint(bp_name)
            if sbp ~= nil then
                local squad = Squad_CreateAndSpawnToward(sbp, p4, 0, spawn_pos, spawn_pos)
                SGroup_Add(sg_wave, squad)
            end
        end
        
        for step_idx, target_pos in ipairs(pathing_queue) do
            local use_queue = (step_idx > 1) 
            Cmd_AttackMove(sg_wave, target_pos, use_queue)
        end
    end
end

-- -----------------------------------------------------------------------------
-- Mission Endgame Resolution & Failure Tracking
-- -----------------------------------------------------------------------------
function Rule_CheckDefenseTimer()
    if eg_vp == nil then return end
    
    local capturedByP4 = (p4 ~= nil) and EGroup_IsCapturedByPlayer(eg_vp, p4, false)
    local capturedByP5 = (p5 ~= nil) and EGroup_IsCapturedByPlayer(eg_vp, p5, false)
    
    if capturedByP4 or capturedByP5 then
        Rule_RemoveMe()
        Rule_Remove(Rule_UpdateTimerUI)
        Rule_Remove(Rule_ManageCounterAttackTimer) 
        Rule_Remove(Rule_CheckSecondaryObjective)
        
        Objective_Fail(obj_defend_vp)
        
        if is_secondary_obj_active then
            Objective_Fail(obj_destroy_base)
        end
        
        Rule_AddOneShot(Rule_TriggerDefeat, 5)
        return
    end
    
    if defend_seconds_left <= 0 or Timer_GetRemaining("defend_timer") <= 0 then
        Rule_RemoveMe()
        Rule_Remove(Rule_UpdateTimerUI)
        Rule_Remove(Rule_ManageCounterAttackTimer) 
        Objective_Complete(obj_defend_vp)
        
        cromwell_spawn_count = 0
        Rule_AddInterval(Rule_SpawnCromwellReinforcements, 3) 
    end
end

-- -----------------------------------------------------------------------------
-- Victory Reinforcements Spawning
-- -----------------------------------------------------------------------------
function Rule_SpawnCromwellReinforcements()
    if p3 == nil or mkr_brit_rein_end == nil or british_reinforcements_endgame == nil then return end
    
    local sbp_cromwell = BP_GetSquadBlueprint("cromwell_mk4_75mm_squad_mp")
    local sg_reinforce = SGroup_CreateIfNotFound("sg_reinforce_" .. cromwell_spawn_count)
    local pos_reinforce = Marker_GetPosition(mkr_brit_rein_end)
    
    local squad = Squad_CreateAndSpawnToward(sbp_cromwell, p3, 0, pos_reinforce, pos_reinforce)
    SGroup_Add(sg_reinforce, squad)
    Cmd_AttackMove(sg_reinforce, Marker_GetPosition(british_reinforcements_endgame)) 
    
    cromwell_spawn_count = cromwell_spawn_count + 1
    
    if cromwell_spawn_count >= 5 then
        Rule_RemoveMe()
        Rule_AddOneShot(Rule_TriggerVictory, 10)
    end
end

-- -----------------------------------------------------------------------------
-- Endgame Conditions
-- -----------------------------------------------------------------------------
function Rule_TriggerVictory()
    World_SetPlayerWin(p1)
    World_SetPlayerWin(p2)
    World_SetPlayerWin(p3)
    World_SetGameOver()
end

function Rule_TriggerDefeat()
    World_SetPlayerWin(p4)
    World_SetPlayerWin(p5)
    World_SetGameOver()
end

Scar_AddInit(OnInit)
