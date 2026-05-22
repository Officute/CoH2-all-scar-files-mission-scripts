print("\tLoading ObjHouffalize file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Houffalize
-- Objective File - Push Enemy Out
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------

function INIT_ObjPushEnemyOut()
	print("Initializing Obj_LinkUp...")
	
	-- Pre-condition:		OBJ_LinkUp is completed.
	-- Success condition:	Player kills enough of the enemy.
	-- Failure condition:	Enemy captures ally's victory point.
	-- Post-condition:
	--		Success:		Mission Complete, enemies retreat.
	--		Failure:		Mission Failure.
	OBJ_PushEnemyOut = {
		--Info
		Title = 11074774,      -- LOCDB [11074774] 'Push the enemy out of Houffalize'
--~ 		TitleEnd = 11074775,      -- LOCDB [11074775] 'Push the enemy out of Houffalize'
--~ 		TitleFail = 11074776,      -- LOCDB [11074776] 'The 1st Army was repelled'
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                  
		subObjectives = {},

		--Intel
		Intel_Start =               		EVENTS.OBJ_PushEnemyOut,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      	nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            	EVENTS.OBJ_PushEnemyOutComplete,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =  nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                		nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       	nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = function() 
				-- spawn last enemies
				ENCOUNTERS.encounterLastDefense()
				
				-- flag that player is near the end of the mission
				g_player_near_end = true
				
				-- start checking when the player and ally get near the end
				Rule_AddInterval(DisableEnemyWaves, 1)
				
				-- add a hint
				g_push_hint_id = Objective_AddUIElements(SOBJ_PreventCapture, mkr_enc_final_01, true, 11074774, true, 3.0)
			end, 
		IsComplete = function() 
				if SGroup_CountSpawned(sg_enemies_final) < 5 and flag_both_players_at_end == true then
					Objective_RemoveUIElements(OBJ_PushEnemyOut, g_push_hint_id)
					Cmd_StaggeredRetreat(sg_enemies_final, {mkr_enemy_wave_spawn}, 5, true)
					HintPoint_Remove(g_push_hint_id)
					return true
				else
					return false 
				end
			end,
		PreComplete = nil,
		OnComplete = function() 
				CalculateMissionScore()
				Objective_RemoveUIElements(SOBJ_PreventCapture, g_push_hint_id)
				Camera_MoveTo(mkr_enc_final_01, true, 0.10)
				Rule_AddInterval(Mission_Complete, 1) 
			end,
		IsFailed = function() 
				-- fail the mission when the enemy captures the allied vp
				return EGroup_IsCapturedByPlayer(eg_ally_vp, player2, ANY)
			end,    
		PreFail = nil,
		OnFail = function() 
				Cmd_Retreat(sg_ally_infantry, mkr_ally_spawn, true, false, nil, true)
				Camera_MoveTo(eg_ally_vp, true, 0.10)
				Rule_AddInterval(Mission_Fail, 1)
			end,
	}
end

Scar_AddInit(INIT_ObjPushEnemyOut)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!
