print("\tLoading Railsplitters_obj_BaseDestruction.scar file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Railsplitters
-- Objective File - Destroy enemy bases before they destroy yours to win
-- Designer: Jim Dodge
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_BaseDestruction()
	print("Initializing BaseDestruction...") 
	
	-- Pre-condition:		Player has additional resources to spend as they choose
	-- Success condition:	Destroy a set number of German command trucks
	-- Failure condition:	Have two bases get destroyed (or the same base twice) ------------------------------THIS HAS BEEN REMOVED------------------------
	-- Post-condition:
	--		Success:		Victory
	--		Failure:		Defeat
	OBJ_Victory = {
		--Info
		Title = 11075621, -- LOCDB [11075621] 'Destroy German Command Trucks to halt their advance'
--~ 		TitleEnd = 11076137,  -- LOCDB [11076137] 'German command just went down in the area.  Good work boys.'
--~ 		TitleFail = 11076138,  -- LOCDB [11076138] 'Command area is overrun!  Fallback!  Fallback!'
		Type = OT_Primary,
		Parent = nil,
		subObjectives = {},
		
		--Intel
		Intel_Start = EVENTS.Mission_Start,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = EVENTS.Winning_Complete,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = EVENTS.Losing_Complete,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = 
			function()
				Objective_SetCounter(OBJ_Victory, 0, i_destroyToWin)
			end,
		PreStart = nil,
		OnStart = nil,
		IsComplete = 
			function() 
				return WinCondition() 
			end, --check to see how many bases are destroyed and return true if number is equal to 4 (easy), 5 (medium), or 6 (hard)
		PreComplete = nil,
		OnComplete = 
			function() 
				CalculateMissionScore()
				Rule_AddInterval(Mission_Complete, 1)
			end,
		IsFailed = function()
			return EGroup_IsEmpty(eg_XP1_player_base)
		end,
		PreFail = nil,
		OnFail = function()
			CalculateMissionScore()
			Rule_AddInterval(Mission_Fail, 1)
		end,
	}
	
	

end
Scar_AddInit(INIT_BaseDestruction)	-- <== ### CRITICAL ELEMENT.



-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------

function WinCondition()
	--check global variable that counts number of destroyed trucks against win requirement
	if i_destroyedTrucks >= i_destroyToWin then
		return true
	else
		return false
	end
end

-- sets the mission score absed on time
function CalculateMissionScore()
	if World_GetGameTime() <= 14*60 then
		XP1_SetMissionSuccessLevel(3)
	elseif World_GetGameTime() <= 18*60 then
		XP1_SetMissionSuccessLevel(2)
	else
		XP1_SetMissionSuccessLevel(1)
	end
	
	print("***** SUCCESS LEVEL *****")
	print(XP1_GetMissionSuccessLevel())
end
