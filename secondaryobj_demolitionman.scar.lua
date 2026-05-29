-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Slottable Secondary Objective
-- Objective File - Destroy a specific structure on the map
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_BonusDemolition()
	print("Initializing SecondaryOBJ_DemolitionMan...")
	
	-- Pre-condition:		BonusObj_Start() called.
	-- Success condition:	Target structure is destroyed
	-- Failure condition:	Mission ends.
	-- Post-condition:
	--		Success:		Player gets bonus Company XP
	--		Failure:		
	SecondaryOBJ_DemolitionMan = {
		--Info
		Title = 11076423,	-- LOCDB [11076423] 'Destroy the key structure'
		Type = OT_Bonus,
		Parent = nil,
		subObjectives = {},
		--Intel
		Intel_Start = 				Demolition_IntroEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			Demolition_OutroEvent,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = Demolition_Start,
		IsComplete = function() 
				return EGroup_CountSpawned(SecondaryOBJ_DemolitionMan.data.target) == 0
			end,
		PreComplete = nil,
		OnComplete = function()
				Rule_AddInterval(Demolition_ShowReward, 1)
				if(scartype(SecondaryOBJ_DemolitionMan.data.OnComplete) == ST_FUNCTION) then
					SecondaryOBJ_DemolitionMan.data.OnComplete()
				end
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
end
Scar_AddInit(INIT_BonusDemolition)


-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function Demolition_Start()
	local data = SecondaryOBJ_DemolitionMan.data
	
	hpid_demoTarget = Objective_AddUIElements(SecondaryOBJ_DemolitionMan, data.target, true, 11076423, true, 2.5)	-- LOCDB [11076423] 'Destroy the key structure'
	
	if scartype(data.additionalEncounters) == ST_TABLE then
		for i = 1, table.getn(data.additionalEncounters) do
			data.additionalEncounters[i](data.target)
		end
	end
end

--Grants the player the reward and shows the corresponding text
function Demolition_ShowReward()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		XP1_GiftVeterancy(0.1, true)
	end
end


---------------------------
-- INTEL EVENTS
---------------------------
--SEQUENCE "" MISSION "SOBJ_DemolitionMan" CHARACTER "American Riflemen"
function Demolition_IntroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074782)	-- LOCDB [11074782] 'We have located a high-value structure near your area. Advance on that position and DESTROY it.' - 'Intel'
	CTRL.WAIT()
end

function Demolition_OutroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074783)	-- LOCDB [11074783] 'Well, it looks like the Germans won't be making use of that...' - 'American Riflemen'
	CTRL.WAIT()
end
