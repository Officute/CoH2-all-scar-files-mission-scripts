print("\tLoading XP1 Narrative Objective Logic...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-------- XP1 Narrative Objective Script and Data File -----------
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-- Narrative objectives to be loaded are entered here
import("Libraries/NarrativeObjectives/XP1/NarrativeObj_Lazzaro_Beat_01.scar")
import("Libraries/NarrativeObjectives/XP1/NarrativeObj_Lazzaro_Beat_02.scar")
import("Libraries/NarrativeObjectives/XP1/NarrativeObj_Lazzaro_Beat_03.scar")
import("Libraries/NarrativeObjectives/XP1/NarrativeObj_Lazzaro_Beat_04.scar")
import("Libraries/NarrativeObjectives/XP1/NarrativeObj_Lazzaro_Beat_05.scar")

function Initialize_NarrativeObjectives()


	g_NarrativeObjectivesData = {}
	g_NarrativeObjectivesData[CD_AIRBORNE] = {
				-- beat 1
				{
					obj = NarrativeOBJ_RescueSquads,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_01, 
								ui = mkr_lazzaroBeat_01,
							},
						},
						goal = nil,
						
					},
					onStart = nil,				
				},
				
				-- beat 2
				{
					obj = NarrativeOBJ_CheckCamp,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_02, 
								ui = mkr_lazzaroBeat_02,
							},
						},
						buildingMarker = mkr_lazzaroBeat_02Building,
						goal = nil,
						
					},
					onStart = nil,
					delay = 10,
				},
				
				-- beat 3
				{
					obj = NarrativeOBJ_AmbushTruck,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_03, 
								ui = mkr_lazzaroBeat_03,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 4
				{
					obj = NarrativeOBJ_FindTheKillers,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_04, 
								ui = mkr_lazzaroBeat_04,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 5
				{
					obj = NarrativeOBJ_FindJacksonsBody,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_05, 
								ui = mkr_lazzaroBeat_05,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
			}
			
	g_NarrativeObjectivesData[CD_MECHANIZED] = {
		-- beat 1
				{
					obj = NarrativeOBJ_RescueSquads,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_01, 
								ui = mkr_lazzaroBeat_01,
							},
						},
						goal = nil,
						
					},
					onStart = nil,				
				},
				
				-- beat 2
				{
					obj = NarrativeOBJ_CheckCamp,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_02, 
								ui = mkr_lazzaroBeat_02,
							},
						},
						buildingMarker = mkr_lazzaroBeat_02Building,
						goal = nil,
						
					},
					onStart = nil,
					delay = 10,
				},
				
				-- beat 3
				{
					obj = NarrativeOBJ_AmbushTruck,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_03, 
								ui = mkr_lazzaroBeat_03,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 4
				{
					obj = NarrativeOBJ_FindTheKillers,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_04, 
								ui = mkr_lazzaroBeat_04,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 5
				{
					obj = NarrativeOBJ_FindJacksonsBody,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_05, 
								ui = mkr_lazzaroBeat_05,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
			}
			-- mechanized

			g_NarrativeObjectivesData[CD_SUPPORT] = {
		-- beat 1
				{
					obj = NarrativeOBJ_RescueSquads,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_01, 
								ui = mkr_lazzaroBeat_01,
							},
						},
						goal = nil,
						
					},
					onStart = nil,				
				},
				
				-- beat 2
				{
					obj = NarrativeOBJ_CheckCamp,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_02, 
								ui = mkr_lazzaroBeat_02,
							},
						},
						buildingMarker = mkr_lazzaroBeat_02Building,
						goal = nil,
						
					},
					onStart = nil,
					delay = 10,
				},
				
				-- beat 3
				{
					obj = NarrativeOBJ_AmbushTruck,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_03, 
								ui = mkr_lazzaroBeat_03,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 4
				{
					obj = NarrativeOBJ_FindTheKillers,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_04, 
								ui = mkr_lazzaroBeat_04,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
				
				-- beat 5
				{
					obj = NarrativeOBJ_FindJacksonsBody,
					data = {
						spawns = {
							{
								spawn = mkr_lazzaroBeat_05, 
								ui = mkr_lazzaroBeat_05,
							},
						},
						goal = nil,
						
					},
					onStart = nil,
				},
			}
			
			--support



end
Scar_AddInit(Initialize_NarrativeObjectives)
-------------------------------------------------------------------------
-- Narrative OBJECTIVES
-------------------------------------------------------------------------
--? @shortdesc Selects a narrative objective and uses it.
--? @extdesc 'cmdr' and 'narrNum' can be used to override the random selection and load a specific narrative objective.
--? @refs http://relicwiki.relic.sega.us/display/REL/Commander+Narrative+Objectives
--? @args Bool showTitle, Bool skipIntel, [Int cmdr, Int narrNum]
function Mission_StartNarrativeObjective(showTitle, skipIntel, cmdr, narrNum)
	if(scartype(g_NarrativeObjectivesData) ~= ST_TABLE or #g_NarrativeObjectivesData == 0) then
		print("Unable to start Narrative Objective. Check your g_NarrativeObjectivesData table" )
	else
		
		g_narrNum = narrNum or 1 -- or whatever value our get commander beat function gives
		g_cmdr = cmdr or CD_AIRBORNE -- g_cmdr or XP1_GetDivision or 1 to be used eventually
		
		--CD_AIRBORNE
		--CD_MECHANIZED
		--CD_SUPPORT
		-- corresponds to the table entry in the narrativeObjectives table in g_missionData
		
		
		__NarrativeObjective = g_NarrativeObjectivesData[g_cmdr][g_narrNum].obj
		__NarrativeObjective.data = g_NarrativeObjectivesData[g_cmdr][g_narrNum].data
		
		
		local narrDelay = g_NarrativeObjectivesData[g_cmdr][g_narrNum].delay
		
		if narrDelay == nil or narrDelay == 0 then
		
			local onStart = g_NarrativeObjectivesData[g_cmdr][g_narrNum].onStart
			if scartype(onStart) == ST_FUNCTION then
				onStart()
			end
			
			Objective_Register(__NarrativeObjective)
			if (scartype(__NarrativeObjective.subObjectives) == ST_TABLE) then
				for i = 1, table.getn(__NarrativeObjective.subObjectives) do
					Objective_Register(__NarrativeObjective.subObjectives[i])
				end
			end
			
			Objective_Start(__NarrativeObjective, showTitle, skipIntel)
		
		elseif narrDelay ~= nil and narrDelay > 0 then
		
			Rule_AddOneShot(Mission_NarrativeObjectiveDelayedStart, narrDelay)
		
		end		
	end
end

function Mission_NarrativeObjectiveDelayedStart()
	
	--CD_AIRBORNE is value of 1 
	--CD_MECHANIZED is value of 2
	--CD_SUPPORT is value of 3
	-- corresponds to the table entry in the narrativeObjectives table in g_missionData
	__NarrativeObjective = g_NarrativeObjectivesData[g_cmdr][g_narrNum].obj
	__NarrativeObjective.data = g_NarrativeObjectivesData[g_cmdr][g_narrNum].data
	
	local onStart = g_NarrativeObjectivesData[g_cmdr][g_narrNum].onStart
	if scartype(onStart) == ST_FUNCTION then
		onStart()
	end
	
	Objective_Register(__NarrativeObjective)
	if (scartype(__NarrativeObjective.subObjectives) == ST_TABLE) then
		for i = 1, table.getn(__NarrativeObjective.subObjectives) do
			Objective_Register(__NarrativeObjective.subObjectives[i])
		end
	end
	
	Objective_Start(__NarrativeObjective, showTitle, skipIntel)
end



--? @shortdesc Return a reference to the Narrative Objective table. Nil if objective has not been started yet.
--? @result Table objective
function Mission_GetNarrativeObjective()
	return __NarrativeObjective
end

