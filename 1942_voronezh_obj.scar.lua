-------------------------------------------------------------------------
-------------------------------------------------------------------------

-- 1942: Voronezh
-- Designer: Sacha Narine
-- Objective File 

-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------
function Objectives_Init()
	
	--[[ REGISTER OBJECTIVES ]]
	INIT_AllObjectives()
	
	--[[ OBJECTIVE_KICKOFF ]]
	Rule_AddOneShot(Objective_Kickoff, 1)
	
end

Scar_AddInit(Objectives_Init)

-------------------------------------------------------------------------
-- [[ REGISTER OBJECTIVE ]]
-------------------------------------------------------------------------
function INIT_AllObjectives()
	-- Main Objective: Secure the city of Voronezh
	-- This objective is the parent for gameplay tasks like 'Capture Victory Points'
	-- No scripted fail condition other than VP loss or Annihilation
	OBJ_Main = {
		Title = 11050519,				-- LOCDB [11050519] 'Secure the city of Voronezh'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 	
		end,
		
		OnStart = function()
			Util_StartIntel(EVENTS.Intro)
			-- Hints and Reminders
			Mission_EnableVaultingHints()
			Rule_AddInterval(Mission_FlashProductionButtons, 10)
			Rule_AddInterval(Voronezh_IsPlayerNearEnemyBase, 5)
			if g_difficulty == GD_EASY then
				Rule_AddInterval(Mission_MineFieldHint, 1)
			end
			
			-- Attacks on the western (armor) player's base
			if not AI_IsEnabled(player1) then
				Rule_AddOneShot(Voronezh_WestBankAttack1, t_difficulty.westBankAttackDelay1)
				Rule_AddOneShot(Voronezh_WestBankAttack2, t_difficulty.westBankAttackDelay2)
			end
			
			-- Enemy KV-8 moves into the city
			Rule_AddOneShot(Voronezh_KV8Patroller, t_difficulty.KV8SpawnDelay)
			
			-- Modify VP capture importance as the game goes on --
			Rule_AddDelayedInterval(Voronezh_ChangeCaptureImportance, 30, 90)
			
			-- Speech/Narrative Events
			Rule_AddDelayedInterval(Voronezh_Speech_AttackEnemyBase, 300, 5)
			local delay = Util_DifVar({625, 475, 325})
			Rule_AddOneShot(Voronezh_Speech_CrossTheRiver, delay)
			
			-- Enemy Commander Abilities
			Rule_AddDelayedInterval(Voronezh_FearPropaganda, t_difficulty.fearPropagandaDelay, 5)
			Rule_AddDelayedInterval(Voronezh_ScorchedEarth, t_difficulty.scorchedEarthDelay, 5)
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	
	Objective_Register(OBJ_Main)
	
	--[[SUB-OBJECTIVES]]
	-- Task #1: Capture and hold Victory Points
	-- Standard VP loss is the primary fail condition
	SOBJ_CaptureVPs = {
		Title = 11050518,				-- LOCDB [11050518] 'Capture and hold Victory Points'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Main,			-- Used for Sub-objectives, registers its' parent
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	Objective_Register(SOBJ_CaptureVPs)

	-- Task #2: Rendezvous with your ally and fight together
	-- More of a suggestion than a task. The players don't need to fight together, but it helps
	-- No completion or fail condition
	SOBJ_MeetAlly = {
		Title = 11050517,				-- LOCDB [11050517] 'Rendezvous with your ally and fight together'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Main,			-- Used for Sub-objectives, registers its' parent
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
			
		end,
		
		OnStart = function()
			Rule_AddInterval(Objective_CompleteRendezvous, 3)
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	Objective_Register(SOBJ_MeetAlly)

	-- Task #3: Defend against enemy armor attacks
	-- On Normal and Hard difficulty, enemies will attack the Infantry player's HQ
	-- If these attacks are ignored, they can annihilate the player
	-- The Objective UI and timer are not visible on HARD. 
	SOBJ_ArmorIncoming = {
		Title = 11050549,				-- LOCDB [11050549] 'Enemy armor will mobilize in:'
		Type = OT_Primary,				-- Objective Type (OT_Primary, OT_Secondary)
		Parent = OBJ_Main,			-- Used for Sub-objectives, registers its' parent
		
			--[[Fires off before Objective Starts]]
		Intel_Start = nil,				-- Event will play when obj starts but before any UI appears
		Intel_Start_SkipFunc = nil,		-- Function to play if Intel_Start is Skipped
			-- Objective Starts
		SetupUI = function() 
		end,
		
		OnStart = function()
			
		end,
		
			--[[Fires off before Objective Completes]]
		Intel_Complete = nil,			-- Event will play when obj completes but before UI is cleared
		Intel_Complete_SkipFunc = nil,	-- Function to play if Intel_Complete is Skipped
			-- Objective Completes
		OnComplete = function()
			
		end,
		
			--[[Fires off before Objective Fails]]
		Intel_Fail = nil,				-- Event will play when obj fails but before UI is cleared
		Intel_Fail_SkipFunc = nil,		-- Function to play if Intel_Fail is Skipped
			-- Objective Fails
		OnFail = function()
			
		end,		
	}
	Objective_Register(SOBJ_ArmorIncoming)

end

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function Objective_Kickoff()
	Objective_Start(OBJ_Main)
	Rule_AddOneShot(Objective_StaggeredStart1, 6)
end

function Objective_StaggeredStart1()
	Objective_Start(SOBJ_CaptureVPs)
	Rule_AddOneShot(Objective_StaggeredStart2, 6)
end

function Objective_StaggeredStart2()
	Objective_Start(SOBJ_MeetAlly)
	
	if g_difficulty == GD_NORMAL or g_difficulty == GD_HARD then
		Rule_AddOneShot(Objective_StaggeredStart3, 6)
	end
	
end

function Objective_StaggeredStart3()

	-- Attacks on the eastern (infantry) player's base
	
	local firstAttackDelay = World_GetRand(550, 650)
	if g_difficulty == GD_HARD then
		firstAttackDelay = firstAttackDelay - 150
	end
	Rule_AddOneShot(Voronezh_EastBankAttack1, firstAttackDelay)
	
	local secondAttackDelay = World_GetRand(900, 960)
	if g_difficulty == GD_HARD then
		secondAttackDelay = secondAttackDelay - 150
	end
	g_secondAttackTimer = secondAttackDelay - firstAttackDelay
	Rule_AddOneShot(Voronezh_EastBankAttack2, secondAttackDelay)
	
	local thirdAttackDelay = World_GetRand(1480, 1580)
	if g_difficulty == GD_HARD then
		thirdAttackDelay = thirdAttackDelay - 150
	end
	g_thirdAttackTimer = thirdAttackDelay - secondAttackDelay
	Rule_AddOneShot(Voronezh_EastBankAttack3, thirdAttackDelay)

	
	
	-- show the associated objective/UI for this attack ONLY ON NORMAL
	if g_difficulty == GD_NORMAL then
		Objective_Start(SOBJ_ArmorIncoming, false)
		Objective_StartTimer(SOBJ_ArmorIncoming, COUNT_DOWN, firstAttackDelay, 30)
	end
	
end

function Objective_CompleteRendezvous()
	if Prox_PlayerSquadsInProximityOfPlayerSquads(player1, player2, 30, ANY) then
		Objective_Complete(SOBJ_MeetAlly)
		Rule_RemoveMe()
		Rule_AddOneShot(Objective_HideRendezvous, 6)
	end
end

function Objective_HideRendezvous()
	Objective_Show(SOBJ_MeetAlly, false)
end

