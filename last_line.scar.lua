import("ScarUtil.scar")
import("WinConditions/victorypointplusannihilate.scar")
import("Fatalities/Fatalities.scar")
 
function WinCondition_PreInit()
        WinCondition_Init()
end
 
Scar_AddInit(WinCondition_PreInit)
 
function WinCondition_Init()
        g_enable_messages = false
        g_text = ""
        g_victorypoints = World_GetEntitiesByBlueprint("victory_point")
        g_victorypointCount = table.getn(g_victorypoints)
        g_resource_modifiers = {}
        g_holder_team = -1
        g_opposing_team = -1
        g_resource_mod = {
                manpower = 1.2,
                munition = 1.2,
                fuel = 1.2,
        }
        Rule_Add(WinCondition_MonitorVictoryPoints)
end
 
function WinCondition_MonitorVictoryPoints()
        -- team victory point own counters
        local team_owns_counters = {[0] = 0, [1] = 0}
        for key, victorypoint in ipairs(g_victorypoints) do
                local owner = Entity_GetPlayerOwnerSafe(victorypoint)
                if owner ~= "world" then
                        local team = Player_GetTeam(owner)
                        team_owns_counters[team] = team_owns_counters[team] + 1
                end
        end
       
        for teamId = 0, 1 do
                local teamOwnsCount = team_owns_counters[teamId]
                -- if a team owns all the points and the team is not registered as the holder team
                if teamOwnsCount == g_victorypointCount and g_holder_team ~= teamId then
                        g_holder_team = teamId
                        g_opposing_team = Team_GetOpposingTeam(teamId)
                        -- apply resource income modifiers for both teams
                        Msg("holder team got munis")
                        Util_GlobalMessage(Util_CreateLocString("Team "..Team_GetTitle(teamId).. " Holds all the victory points!"), 5)
                        Players_ForEachInTeam(teamId, function(pid, idx, player)
                                local pKey = Player_GetUniqueKey(player)
                                g_resource_modifiers[pKey.."_munition"] = Modify_PlayerResourceRate(player, RT_Munition, g_resource_mod.munition, MUT_Multiplication)
                        end)
                       
                        Players_ForEachInTeam(g_opposing_team, function(pid, idx, player)
                                local pKey = Player_GetUniqueKey(player)
                                g_resource_modifiers[pKey.."_manpower"] = Modify_PlayerResourceRate(player, RT_Manpower, g_resource_mod.manpower, MUT_Multiplication)
                                g_resource_modifiers[pKey.."_fuel"] = Modify_PlayerResourceRate(player, RT_Fuel, g_resource_mod.fuel, MUT_Multiplication)
                        end)
                        Msg("opposing team  got fuel and manpower")
                end
        end
        --remove opposing team modifiers since all victory points are no longer held by one team
        if team_owns_counters[0] < g_victorypointCount and team_owns_counters[1] < g_victorypointCount and g_opposing_team > -1 then
                Msg("opposing team lost fuel and manpower")
                Players_ForEachInTeam(g_opposing_team, function(pid, idx, player)
                        local pKey = Player_GetUniqueKey(player)
                        Modifier_Remove(g_resource_modifiers[pKey.."_manpower"])
                        Modifier_Remove(g_resource_modifiers[pKey.."_fuel"])
                       
                end)
                g_opposing_team = -1
        --remove holder team modifiers since all victory points are no longer held by one team
        elseif team_owns_counters[0] < g_victorypointCount and team_owns_counters[1] < g_victorypointCount and g_holder_team > -1 then
                Msg("holder team lost munis")
                Players_ForEachInTeam(g_holder_team, function(pid, idx, player)
                        local pKey = Player_GetUniqueKey(player)
                        Modifier_Remove(g_resource_modifiers[pKey.."_munition"])
                end)
                g_holder_team = -1
        end
end
 
-- misc function for getting an unique key for a player. Purpose: Table indexing
function Player_GetUniqueKey(player)
        return "player_"..Player_GetName(player)..":"..Player_GetID(player)
end
 
-- misc function for getting the actual player name string instead of the locstring
function Player_GetName(player)
        return Player_GetDisplayName(player)[1]
end
 
-- misc function for forming a team title of the team player names
function Team_GetTitle(team)
        local teamName = "[ "
        local players = {}
        Players_ForEach(function(pid, idx, player)
                if Player_GetTeam(player) == team then
                        table.insert(players, player)
                end
        end)
       
        for key, player in ipairs(players) do
                local comma = ", "
                if key == table.getn(players) then
                        comma = ""
                end
                teamName = teamName.. Player_GetName(player).. comma
        end
       
        return teamName .." ]"
end
 
-- mis function for getting the opposing team of a team
function Team_GetOpposingTeam(team)
        if team == 0 then
                return 1
        elseif team == 1 then
                return 0
        end
end
 
-- mis function for looping over all players
function Players_ForEach(f)
        for i = 1, World_GetPlayerCount() do
                local player = World_GetPlayerAt(i)
                local pid = Player_GetID(player)
                f(pid, i, player)
        end
end
 
-- mis function for looping over all players in a team
function Players_ForEachInTeam(team, f)
        Players_ForEach(function(pid, idx, player)
                if Player_GetTeam(player) == team then
                        f(pid, idx, player)
                end
        end)
end
 
-- mis function for getting all entities from the world per ebp string
function World_GetEntitiesByBlueprint(ebp)
        local result = {}
        if scartype(ebp) == ST_STRING then
                ebp = BP_GetEntityBlueprint(ebp)
        end
        for i = 0, World_GetNumEntities() -1 do
                local entity = World_GetEntity(i)
                if Entity_GetBlueprint(entity) == ebp then
                        table.insert(result, entity)
                end
        end
       
        return result
end
 
-- misc function for getting the player owner of an entity safely
function Entity_GetPlayerOwnerSafe(entity)
        if World_OwnsEntity(entity) then
                return "world"
        else
                return Entity_GetPlayerOwner(entity)
        end
end
-- debug function for printing messages on screen
function Msg(text)
        if g_enable_messages then
                g_text = text.."\n"..g_text
                dr_clear("MSG")
                dr_setautoclear("MSG", 0)
                dr_text2d("MSG", 0.615, 0.025, g_text, 0, 255, 0)
        end
end
 
-- misc function for diplaying global titles
function Util_GlobalMessage(title, displaytime)
        Game_TextTitleFade(title, 0, displaytime, 2)
end
 
-- misc function for creating localization strings
function Util_CreateLocString(text)
        local tmpstr = LOC(text)
        tmpstr[1] = text
        return tmpstr
end