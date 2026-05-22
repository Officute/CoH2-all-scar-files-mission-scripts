-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1943 Challenge: MUD HUNT - ABANDONED TANK OBJECTIVE
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_AbandonedTank()
	
	-- Pre-condition:		Starts when the player sees their first abandoned tank
	-- Success condition:	Player has captured all abandoned tanks and got them to the rendezvous point
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		N/A
	--		Failure:		N/A
	
	OBJ_AbandonedTank = {
		
		--Info
		Title = 11055668,					-- Objective Title 			-- LOC("Retrieve the adandoned tank")
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Secondary,				-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.AbandonedTank_Spotted,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,								-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,							-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,								-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,								-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,								-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
			if t_difficulty.num_abandoned_encounters >= 2 then
				Objective_SetCounter(OBJ_AbandonedTank, num_abandoned_tanks_rescued, t_difficulty.num_abandoned_encounters)
			end
			
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
		end,
		IsComplete = function() 
			
			if num_abandoned_tanks_rescued == t_difficulty.num_abandoned_encounters then
				return true
			end
			
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()						-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
			
			Util_StartIntel(EVENTS.AbandonedTank_Completed)
			AbandonedTank_GivePlayerReward()
			
		end,
		IsFailed = function() 
			
			if num_abandoned_tanks_lost >= 1 then
				return true
			end
			
		end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	--------------------
	-- INITIALISATION --
	--------------------
	
	num_abandoned_tanks_rescued = 0
	num_abandoned_tanks_lost = 0
	
	
	-------------
	-- KICKOFF --
	-------------
	
	-- kicked off by the main script, which has called the AbandonedTank_SetUp function below for all the instances of abandoned tanks on the map
	
end
Scar_AddInit(INIT_Obj_AbandonedTank)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!





-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------



-- called with a data table that has the location chosen for this encounter
function AbandonedTank_SetUp(data)
	
	abandoned_index = abandoned_index + 1
	local sgroup = SGroup_CreateIfNotFound("sg_abandoned"..abandoned_index)
	local egroup = EGroup_CreateIfNotFound("eg_abandoned"..abandoned_index)
	local defenders = SGroup_CreateIfNotFound("sg_abandoned"..abandoned_index.."_defenders")
	local attackers = SGroup_CreateIfNotFound("sg_abandoned"..abandoned_index.."_attackers")
	
	-- spawn the tank
	Util_CreateSquads(player2, sgroup, SBP.GERMAN.BRUMMBAR_SQUAD, data.location)
	
	num_total_tanks = num_total_tanks + 1
	
	-- spawn the guys defending the tank
	Util_CreateSquads(player2, defenders, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(sgroup, OFFSET_FRONT, 5), nil, 1, nil, nil, nil, nil, Util_GetOffsetPosition(sgroup, OFFSET_FRONT, 40))
	Util_CreateSquads(player2, defenders, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(sgroup, OFFSET_LEFT, 5), nil, 1, nil, nil, nil, nil, Util_GetPositionFromAtoB(Util_GetOffsetPosition(sgroup, OFFSET_FRONT_LEFT, 40), Util_GetOffsetPosition(sgroup, OFFSET_LEFT, 40), 0.5))
	Util_CreateSquads(player2, defenders, SBP.GERMAN.MG42_HEAVY_MACHINE_GUN_SQUAD, Util_GetOffsetPosition(sgroup, OFFSET_RIGHT, 5), nil, 1, nil, nil, nil, nil, Util_GetPositionFromAtoB(Util_GetOffsetPosition(sgroup, OFFSET_FRONT_RIGHT, 40), Util_GetOffsetPosition(sgroup, OFFSET_RIGHT, 40), 0.5))
	Cmd_InstantSetupTeamWeapon(defenders)
	
	-- now make the tank abandoned and find the abandoned version
	Cmd_CriticalHit(player2, sgroup, CRIT.VEHICLE_STUCK_IN_MUD, 0)
	Cmd_CriticalHit(player2, sgroup, CRIT.VEHICLE_ABANDON, 1)
	World_GetNeutralEntitiesNearPoint(egroup, Util_GetPosition(data.location), 5)
	EGroup_Filter(egroup, EBP.GERMAN.BRUMMBAR_STURMPANZER_IV_SDKFZ_166, FILTER_KEEP)
	
	-- store all the info for this tank situation
	local this = {}
	this.location = data.location
	this.tank_sgroup = sgroup 
	this.tank_egroup = egroup 
	this.tank_gameID = Entity_GetGameID(EGroup_GetSpawnedEntityAt(egroup, 1))
	this.defenders = defenders
	this.attackers = attackers
	this.state = "abandoned"
	
	-- and kick off the manager function
	if t_abandonedtankdefenders == nil then
		t_abandonedtankdefenders = {}
	end
	table.insert(t_abandonedtankdefenders, this)
	
	if Rule_Exists(AbandonedTank_Manager) == false then
		Rule_AddInterval(AbandonedTank_Manager, 0.5)
	end
	
end

function AbandonedTank_Manager()
	
	for index = #t_abandonedtankdefenders, 1, -1 do 
		
		local this = t_abandonedtankdefenders[index]
		local removeme = false
		
		
		if SGroup_Count(this.tank_sgroup) + EGroup_Count(this.tank_egroup) == 0 then
			
			if Entity_IsValid(this.tank_gameID) == false then
				
				-- it was destroyed
				num_abandoned_tanks_lost = num_abandoned_tanks_lost + 1
				FindAndDestroy_TankHasBeenDestroyed()
				
				removeme = true
				
			else
				
				-- it must have been abandoned / captured
				local eid = Entity_FromWorldID(this.tank_gameID)
				if Entity_IsPartOfSquad(eid) then
					SGroup_Add(this.tank_sgroup, Entity_GetSquad(eid))
				else
					EGroup_Add(this.tank_egroup, eid)
				end
				
			end
			
		else
			
			-- deal with the defenders around the tank
			if (this.state == "captured" or SGroup_TotalMembersCount(this.defenders) <= 9) and this.defender_encounter == nil then
				
				this.defender_encounter = Encounter:ConvertSgroup(this.defenders)
				local goalData = {
					name = "Defend",
					target = this.tank_egroup,
					tacticControlList = {
						{
							tacticType = TACTIC_Recrew,			-- make sure they don't recrew the tank!
							priority = -1,
						},
					},
					
				}
				this.defender_encounter:SetGoal(goalData)
				
			end
			
			
			-- deal with the stages of the tank enounter
			if this.state == "abandoned" then
				
				if Entity_IsValid(this.tank_gameID) then
					
					local eid = Entity_FromWorldID(this.tank_gameID)
					
					if Player_CanSeeEntity(player1, eid) then
						
						if Objective_IsStarted(OBJ_AbandonedTank) == false then
							Objective_Start(OBJ_AbandonedTank)
						else
							Util_StartIntel(EVENTS.AbandonedTank_SpottedSubsequent)
						end
						
						this.hpid_abandonedtank = Objective_AddUIElements(OBJ_AbandonedTank, eid, true, 11055669, true)		-- LOC("Capture this abandoned Sturmpanzer")
						EventCue_Create(CUE.NORMAL, 11055666, 0, Util_GetPosition(eid), nil, nil, 6, true)					-- LOC("Tank spotted")
						UI_CreateMinimapBlip(Util_GetPosition(eid), 6, BT_ObjectivePrimary)
						
						this.state = "spotted"
						
					end
					
				end
				
			elseif this.state == "spotted" then
				
				if Entity_IsValid(this.tank_gameID) then
					
					local eid = Entity_FromWorldID(this.tank_gameID)
					
					-- see if the player has captured the tank
					if Entity_IsPartOfSquad(eid) and Player_OwnsEntity(player1, eid) then
						
						local sid = Entity_GetSquad(eid)
						SGroup_Add(this.tank_sgroup, sid)
						
						if Objective_IsComplete(OBJ_AbandonedTank) == false then
							Objective_RemoveUIElements(OBJ_AbandonedTank, this.hpid_abandonedtank)
							Objective_AddUIElements(OBJ_AbandonedTank, mkr_abandonedtank_rescue, true, 11055670, true)		-- LOC("Bring the captured Brummbar here")
						end
						
						Util_StartIntel(EVENTS.AbandonedTank_Captured)
						
						this.state = "captured"
						
					end
					
				end
				
			elseif this.state == "captured" then
				
				if SGroup_Count(this.attackers) <= Util_DifVar({0, 1, 2}) then
					
					-- spawn in an AT gun to destroy it before the player digs it out (they still have to deal with the mud issue)
					Util_CreateSquads(player2, this.attackers, SBP.GERMAN.PAK40_75MM_AT_GUN_SQUAD, Util_GetClosestMarker(this.location, t_infantryspawnlocations), Util_GetOffsetPosition(this.location, OFFSET_BACK, 20), nil, nil, true)
					Util_CreateSquads(player2, this.attackers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, Util_GetClosestMarker(this.location, t_infantryspawnlocations), Util_GetOffsetPosition(this.location, OFFSET_BACK, 20), nil, nil, true)
					Util_CreateSquads(player2, this.attackers, SBP.GERMAN.PANZER_GRENADIER_SQUAD, Util_GetClosestMarker(this.location, t_infantryspawnlocations), Util_GetOffsetPosition(this.location, OFFSET_BACK, 20), nil, nil, true)
					
					if enc_AbandonedTank == nil then
						local goalData = {
							name = "Attack",
							target = this.tank_sgroup,
						}
						enc_AbandonedTank = Encounter:ConvertSgroup(this.attackers)
						enc_AbandonedTank:SetGoal(goalData)
					else 
						enc_AbandonedTank:AddSgroup(this.attackers)
						enc_AbandonedTank:RestartGoal()
					end
					
				end
				
				if Prox_AreSquadsNearMarker(this.tank_sgroup, mkr_abandonedtank_rescue, ANY) then
					
					-- tank has been rescued!
					
					-- drive the captures tank off map
					Misc_SelectSquad(SGroup_GetSpawnedSquadAt(this.tank_sgroup, 1), false)
					SGroup_SetSelectable(this.tank_sgroup, false)
					Cmd_MoveToAndDespawn(this.tank_sgroup, mkr_abandonedtank_exit)
					
					-- increase the counter of rescued tanks 
					num_abandoned_tanks_rescued = num_abandoned_tanks_rescued + 1
					num_destroyed_tanks = num_destroyed_tanks + 1	-- we count this as destroyed too, I guess, since it's no longer on the map
					
					-- update the objective counter if there is one (i.e. we have more than one abandoned tank around)
					if Objective_IsCounterSet(OBJ_AbandonedTank) == true then
						Objective_SetCounter(OBJ_AbandonedTank, num_abandoned_tanks_rescued, t_difficulty.num_abandoned_encounters)
					end
					
					this.state = "rescued"
					removeme = true
					
				end
				
			end
			
		end
		
		
		if removeme == true then
			table.remove(t_abandonedtankdefenders, index)
		end
		
	end
	
	if #t_abandonedtankdefenders == 0 then
		Rule_RemoveMe()
	end
	
end



-- called upon objective completion
function AbandonedTank_GivePlayerReward()
	
	Util_CreateSquads(player1, sg_blah, SBP.SOVIET.SU_76M, mkr_abandonedtank_exit, mkr_abandonedtank_rescue, 2)
	
end




