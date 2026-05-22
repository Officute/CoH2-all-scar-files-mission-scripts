print("\tLoading ObjHouffalize file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Houffalize
-- Objective File - Link Up
-- Designer: Byron Chow
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------

function INIT_ObjLinkUp()
	print("Initializing Obj_LinkUp...")
	
	
	-- Pre-condition:		Mission start.
	-- Success condition:	Player captures the victory point.
	-- Failure condition:	SOBJ_ConnectTerritory is failed.
	-- Post-condition:
	--		Success:		Start OBJ_PushEnemyOut. Spawns the strong ally wave that pushes against germans.
	--		Failure:		Mission Failure.
	OBJ_LinkUp = {
		--Info
		Title = 11074766,      -- LOCDB [11074766] 'Link-up with the 1st Army'
--~ 		TitleEnd = 11074767,      -- LOCDB [11074767] 'Linked with the 1st Army'
--~ 		TitleFail = 11074768,      -- LOCDB [11074768] 'The 1st Army was repelled'
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {},

		--Intel
		Intel_Start =               		EVENTS.OBJ_LinkUp,        
		Intel_Start_SkipFunc =   	nil,       
		Intel_Complete =           	nil,      
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail =               	 	nil,
		Intel_Fail_SkipFunc =      	nil,
		--Functions
		SetupUI = function()
			g_capture_id = Objective_AddUIElements(OBJ_LinkUp, eg_enemy_vp, true, 11074811, true, 4.0)	-- LOCDB [11074811] 'Capture the Victory Point'
		end,
		PreStart = nil,
		OnStart = function() 
			Objective_Start(SOBJ_ConnectTerritory, false, true)
			Objective_Start(SOBJ_PreventCapture, false, true)
			Objective_Start(SOBJ_DestroyArtillery)
		end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = function() 
			-- complete when player captures the victory point and the tank(s) are defeated
			--if World_IsInSupply(player1, Marker_GetPosition(mkr_ally_zone)) and SGroup_IsAlive(sg_enemy_tanks) == false then
			--if World_IsInSupply(player1, EGroup_GetPosition(eg_enemy_vp)) and SGroup_IsAlive(sg_enemy_tanks) == false then	
			if g_connectionEstablished == true and SGroup_IsAlive(sg_enemy_tanks) == false then
				return true
			else
				return false 
			end
		end,   -- Automatic check called to see if the objective is complete. Must return boolean value.
		PreComplete = nil,
		OnComplete = function() 
				Objective_Start(OBJ_PushEnemyOut, true)
				-- spawn allied waves to push against germans	
				Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave1}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_spawn)
				Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave1}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_spawn)
				Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave2}, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_ally_spawn)
				Util_CreateSquads(player3, {sg_ally_infantry, sg_ally_wave2}, SBP.AEF.M1_81MM_MORTAR_SQUAD_MP, mkr_ally_spawn)
			
				Util_CreateSquads(player3, {sg_ally_wave1, sg_ally_tanks}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_ally_spawn)
				Util_CreateSquads(player3, {sg_ally_wave2, sg_ally_tanks}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_ally_spawn)
				Util_CreateSquads(player3, {sg_ally_wave2, sg_ally_tanks}, SBP.AEF.M4A3_SHERMAN_SQUAD_MP, mkr_ally_spawn)
				Cmd_SquadPath(sg_ally_wave1, "path_ally_wave1", true, false, true, 0) 
				Cmd_SquadPath(sg_ally_wave2, "path_ally_wave2", true, false, true, 0) 
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = function() 
				Cmd_Retreat(sg_ally_infantry, mkr_ally_spawn, true, false, nil, true)
				Camera_MoveTo(eg_ally_vp, true, 0.10)
				Rule_AddInterval(Mission_Fail, 1) 
			end,
	}
	
	-- Pre-condition:		Mission start.
	-- Success condition:	None.
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		None.
	-- Basically this objective is just to clarify the main objective
	SOBJ_ConnectTerritory = {
		--Info
		Title = 11074769,      -- LOCDB [11074769] 'Connect your territory to your ally'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_LinkUp,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {},

		--Intel
		Intel_Start =               		nil,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =      	nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            	nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                		nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =      	nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_LinkUp.subObjectives, SOBJ_ConnectTerritory) -- Don't forget to add them to their parent!
	
	-- Pre-condition:		Mission start.
	-- Success condition:	None.
	-- Failure condition:	Enemy captures the ally's victory point.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		Fail OBJ_LinkUp -> Mission Failure.
	SOBJ_PreventCapture = {
		--Info
		Title = 11074770,      -- LOCDB [11074770] 'Prevent the enemy from capturing the allied victory point'
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,              
		Parent = OBJ_LinkUp,           
		subObjectives = {},

		--Intel
		Intel_Start =				nil,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =		nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            	nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                		nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       	nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()
			g_prevent_capture_id = Objective_AddUIElements(SOBJ_PreventCapture, eg_ally_vp, true, 11074812, true, 4.0) -- LOCDB [11074812] 'Prevent enemy capture'
		end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = nil,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = function() 
			-- fail the mission when the enemy captures the allied vp
			if EGroup_IsCapturedByPlayer(eg_ally_vp, player2, ANY) then
				return true
			else
				return false
			end
		end,    
		PreFail = nil,
		OnFail = function() 
				Objective_Fail(OBJ_LinkUp)
			end,
	}
	table.insert(OBJ_LinkUp.subObjectives, SOBJ_PreventCapture) -- Don't forget to add them to their parent!
	
	
	
	
	-- Pre-condition:		Triggered by proximity marker.
	-- Success condition:	All of the enemy artillery is killed/captured.
	-- Failure condition:	None.
	-- Post-condition:
	--		Success:		None.
	--		Failure:		None.
	SOBJ_DestroyArtillery = {
		--Info
		Title = 11074771,      -- LOCDB [11074771] 'Capture enemy artillery'
		TitleEnd = 11074772,      -- LOCDB [11074772] 'Artillery captured'
		TitleFail = 11074773,      -- LOCDB [11074773] 'Failed to destroy enemy artillery'
		Type = OT_Secondary,              -- Objective Type (OT_Primary, OT_Secondary)
		Parent = nil,                   -- Used for sub-objectives to specify its parent. Remove for top-level objectives.
		subObjectives = {},

		--Intel
		Intel_Start =               		EVENTS.EnemyArtillery,        -- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc =     	nil,        -- Function to play if Intel_Start is Skipped
		Intel_Complete =            	nil,        -- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc =  nil,        -- Function to play if Intel_Complete is Skipped
		Intel_Fail =                		nil,        -- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc =       	nil,        -- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function()                        -- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			-- ObjectiveUIElements are removed when Objective_Complete or Objective_Fail are completed
			g_artillery_arrow_id1 = Objective_AddUIElements(SOBJ_DestroyArtillery, mkr_enemy_artillery_01, true, 11074813, true, 3.0) -- LOCDB [11074813] 'Capture Artillery'
			g_artillery_arrow_id2 = Objective_AddUIElements(SOBJ_DestroyArtillery, mkr_enemy_artillery_02, true, 11074813, true, 3.0) -- LOCDB [11074813] 'Capture Artillery'
		end,
		PreStart = function() 
				-- spawn artillery that the player will need to destroy
				Util_CreateSquads(player2, {sg_enemy_artillery_01, sg_enemy_artillery_all}, BP_GetSquadBlueprint("howitzer_105mm_long_range"), mkr_enemy_artillery_01)
				Util_CreateSquads(player2, {sg_enemy_artillery_02, sg_enemy_artillery_all}, BP_GetSquadBlueprint("howitzer_105mm_long_range"), mkr_enemy_artillery_02)
	--~ 			Util_CreateSquads(player2, {sg_enemy_artillery_01, sg_enemy_artillery_all}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_enemy_artillery_01)
	--~ 			Util_CreateSquads(player2, {sg_enemy_artillery_02, sg_enemy_artillery_all}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_enemy_artillery_02)
				SGroup_SetAutoTargetting(sg_enemy_artillery_01, "hardpoint_01", false)
				SGroup_SetAutoTargetting(sg_enemy_artillery_02, "hardpoint_01", false)
				GrabArtilleryID()
				Rule_AddInterval(MakeArtilleryInvulnerable, 1.0)
			end,                  -- Called on start, before Intel_Start
		OnStart = function() 
				-- start artillery manager
				Rule_AddDelayedInterval(ArtilleryManager, 10.0, 10.0)
				Rule_AddInterval(ArtilleryHintpoints, 1.0)
				Rule_AddInterval(CheckPlayerCapturedArtillery, 1.0)
			end,                   -- Called after any Intel_Start items, and the objective is considered officially started here
		IsComplete = function() 
				-- completes when all artillery are destroyed
				if ( SyncWeapon_IsOwnedByPlayer(g_artillery_id1, player1) or SyncWeapon_Exists(g_artillery_id1) == false ) and ( SyncWeapon_IsOwnedByPlayer(g_artillery_id2, player1) or SyncWeapon_Exists(g_artillery_id2) == false ) then
					return true
				else
					return false 
				end
			end,
		PreComplete = nil,
		OnComplete = nil,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	table.insert(OBJ_LinkUp.subObjectives, SOBJ_DestroyArtillery) -- Don't forget to add them to their parent!
	
end

Scar_AddInit(INIT_ObjLinkUp)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!

