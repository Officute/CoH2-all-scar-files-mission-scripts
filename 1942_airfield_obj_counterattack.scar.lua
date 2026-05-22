-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- 1942 ToW CHALLENGE: TATSINSKAIA AIRFIELD
-- Objective File - COUNTERATTACK
-- Designer: NJR
-------------------------------------------------------------------------
-------------------------------------------------------------------------


-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_Obj_Counterattack()
	
	-- Pre-condition:		After the player has captured the Control Tower
	-- Success condition:	Player kills the Tiger tank that's the focus of the counterattack
	-- Failure condition:	N/A
	-- Post-condition:
	--		Success:		Mission success!
	--		Failure:		N/A 
	
	OBJ_Counterattack = {
		
		--Info
		Title = 11052235,	-- Objective Title		-- locdb [11052235] "Repel the Counterattack"
		TitleEnd = nil,
		TitleFail = nil,
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		subObjectives = {},
		
		--Intel
		Intel_Start = 				EVENTS.Counterattack_Start,		-- EVENT called *before* the objective actually starts
		Intel_Start_SkipFunc = 		nil,							-- Function to play if Intel_Start is Skipped
		Intel_Complete = 			nil,							-- This EVENT is called _before_ the objective actually completes
		Intel_Complete_SkipFunc = 	nil,							-- Function to play if Intel_Complete is Skipped
		Intel_Fail = 				nil,							-- This EVENT is called _before_ the objective actually fails
		Intel_Fail_SkipFunc = 		nil,							-- Function to play if Intel_Fail is Skipped
		--Functions
		SetupUI = function() 						-- This is called alongside the new objective ui animation, but this may occur sometime _after_ the OnStart depending on any running Events
			
			
		end,
		Precondition = function() end,
		PreStart = function() end,					-- Called on start, before Intel_Start
		OnStart = function()						-- Called after any Intel_Start items, and the objective is considered officially started here
			
			Counterattack_Start()
			
		end,
		IsComplete = function() 
			
			if counterattack_all_spawned == true and SGroup_Count(sg_counterattack_tiger) == 0 then
				
				if enc_Counterattack:IsAlive() then
					enc_Counterattack:Disable()
					Cmd_Retreat(sg_counterattack, mkr_controltower_spawn01, true)
				end
				
				return true
				
			end
			
		end,
		PreComplete = function() end,				-- Called before Intel_Complete
		OnComplete = function()	end,				-- Called after any Intel_Complete items, and the objective is considered officially completed here. The objective ui animation happens at this time as well.
		IsFailed = function() return false end,
		PreFail = function() end,					-- Called before Intel_Fail
		OnFail = function()	end,					-- Called after any Intel_Fail items, and the objective is considered officially failed here. The objective ui animation happens at this time as well.
	}

	--------------------
	-- INITIALISATION --
	--------------------
	
	sg_counterattack = SGroup_CreateIfNotFound("sg_counterattack")
	sg_counterattack_tiger = SGroup_CreateIfNotFound("sg_counterattack_tiger")
	
	counterattack_all_spawned = false				-- flag to say whether all the counterattack units have actually been spawned yet
	last_know_tiger_position = Marker_GetPosition(mkr_controltower_spawn01)
	
	-------------
	-- KICKOFF --
	-------------
	

	
end
Scar_AddInit(INIT_Obj_Counterattack)	-- <== ### CRITICAL ELEMENT. Don't forget to add this!



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------




function Counterattack_Start()
	
	enc_Counterattack = ENCOUNTERS.Counterattack()
	enc_Counterattack_Entourage = ENCOUNTERS.Counterattack_Entourage()
	
	counterattack_all_spawned = true

	Event_PlayerCanSeeElement(Counterattack_PlayerSeesTiger, nil, player1, sg_counterattack_tiger, ANY)
	Event_Timer(Counterattack_TopUpEntourage, nil, t_difficulty.topup_frequency + World_GetRand(0, 30))
	
end

function Counterattack_TopUpEntourage()
	
	if Objective_IsComplete(OBJ_Counterattack) == false then
		
		SGroup_Clear(sg_temp)
		
		Util_CreateSquads(player2, sg_temp, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_controltower_spawn01, nil, 1, 3, nil, nil, UPG.GERMAN.PANZERBUSCHE_39)
		Util_CreateSquads(player2, sg_temp, SBP.GERMAN.PANZER_GRENADIER_SQUAD, mkr_controltower_spawn01, nil, 1, 2, nil, nil, UPG.GERMAN.PANZERBUSCHE_39)
		Util_CreateSquads(player2, sg_temp, SBP.GERMAN.GRENADIER_SQUAD, mkr_controltower_spawn03)
		enc_Counterattack_Entourage:AddSgroup(sg_temp)
		
		Event_Timer(Counterattack_TopUpEntourage, nil, t_difficulty.topup_frequency + World_GetRand(0, 30))
		
	end

end

function Counterattack_EntourageRetreat()	-- this is called as the encounter's onFailure callback
	
	Cmd_StaggeredRetreat(enc_Counterattack_Entourage:GetSgroup(), {mkr_controltower_spawn01, mkr_extra_spawn03, mkr_extra_spawn01})

end







function Counterattack_PlayerSeesTiger()	-- this is called once the Tiger is spotted by the player

	-- tell the player about the T34's ramming ability
	Rule_AddInterval(HintAtRamming, 5)
	
	Rule_AddInterval(Counterattack_GetTigerPosition, 1)
	
end

function Counterattack_GetTigerPosition()

	if SGroup_Count(sg_counterattack_tiger) == 0 then
		
		Rule_RemoveMe()
		
	else
		
		last_know_tiger_position = SGroup_GetPosition(sg_counterattack_tiger)
		
	end

end




function HintAtRamming()
	
	if Event_IsAnyRunning() == false then
		
		-- get the selected units
		Misc_GetSelectedSquads(sg_temp, false)
		SGroup_Filter(sg_temp, SBP.SOVIET.T_34_76_SQUAD, FILTER_KEEP)
		
		-- if the player has a T34 selected, show the hint
		if SGroup_Count(sg_temp) >= 1 then
			
			UI_NewHUDFeature(HUDF_None, 11052234, "Icons_abilities_ability_soviet_ramming_manuever", 10)	-- locdb [11052234] "Soviet T34s can ram enemy tanks, causing critical damage to both vehicles."
			flashid_ramming = UI_FlashAbilityButton(ABILITY.SOVIET.T_34_RAMMING_ABILITY, true)
			
			Rule_Add(HintAtRamming_Remove)
			Rule_RemoveMe()
			
		end
		
	end
	
end
function HintAtRamming_Remove()

	-- get the selected units
	Misc_GetSelectedSquads(sg_temp, false)
	SGroup_Filter(sg_temp, SBP.SOVIET.T_34_76_SQUAD, FILTER_KEEP)
	
	-- if the player has a T34 selected, show the hint
	if SGroup_Count(sg_temp) == 0 then
		
		UI_StopFlashing(flashid_ramming)
		Rule_RemoveMe()
		
	end

end