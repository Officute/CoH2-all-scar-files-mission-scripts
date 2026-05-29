-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Bonus Objective
-- Objective File - Destroy Tank
-- Designer: R.McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--[[ Sample data table:
-- See http://relicwiki.relic.sega.us/display/REL/Slottable+Secondary+Objectives for more information

{
obj = SecondaryOBJ_DestroyTank,
	data = {
		spawns = {
			{spawn = mkr_POSSIBLE_SPAWN_POINT_HERE, ui = mkr_MARKER_FOR_AREA_UI},
		},
		goal = GOALS.GOAL_DATA_FOR_VIP,
		protectEncounter = ENCOUNTERS.PROTECT_ENCOUNTER_FOR_VIP,
		additionalEncounters = {
			ENCOUNTERS.ANY_ADDITIONAL_ENCOUNTERS_HERE,
		},
		OnComplete = SecondaryObjCompleted,
	},
},

]]--

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_BonusDestroyTank()
	print("Initializing SecondaryOBJ_DestroyTank...")
	
	--Objective specific variables
	_sg_tank = SGroup_CreateIfNotFound("_sg_tank")
	_sg_tank_protection = SGroup_CreateIfNotFound("_sg_tank_protection")
	
	-- Pre-condition:		BonusObj_Start() called.
	-- Success condition:	Player kills unit
	-- Failure condition:	Mission ends.
	-- Post-condition:
	--		Success:		Player gets 15% Company Veterancy bonus
	--		Failure:		
	SecondaryOBJ_DestroyTank = {
		--Info
		Title = 11076426,	-- LOCDB [11076426] 'Destroy the crippled tank'
		Type = OT_Bonus,
		Parent = nil,
		subObjectives = nil,
		--Intel
		Intel_Start = 				DestroyTank_IntroEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			DestroyTank_OutroEvent,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = Destroy_Tank_Start,
		IsComplete = function() 
				return SGroup_CountSpawned(_sg_tank) == 0
			end,
		PreComplete = nil,
		OnComplete = function()
				Rule_AddInterval(DestroyTank_ShowReward, 1)
				if(scartype(SecondaryOBJ_DestroyTank.data.OnComplete) == ST_FUNCTION) then
					SecondaryOBJ_DestroyTank.data.OnComplete()
				end
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
end
Scar_AddInit(INIT_BonusDestroyTank)

-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function Destroy_Tank_Start()
	local data = SecondaryOBJ_DestroyTank.data
	
	local spawnLoc = Table_GetRandomItem(data.spawns)
	
	Util_CreateSquads(player2, _sg_tank, SBP.GERMAN.PANZER_IV_SQUAD_MP, spawnLoc.spawn)
	Cmd_CriticalHit(player2, _sg_tank, CRIT.VEHICLE_LOSE_TREADS_OR_WHEELS, 0.96)
	SGroup_SetAvgHealth(_sg_tank, 0.94)
	
	hpid_destroyTank = Objective_AddUIElements(SecondaryOBJ_DestroyTank, spawnLoc.ui, true)
	hpid_destroyTank2 = Objective_AddUIElements(SecondaryOBJ_DestroyTank, _sg_tank, false, 11076426, true, 2.5)		-- LOCDB [11076426] 'Destroy the crippled tank'
	
	if(data.protectEncounter) then
		local encData = data.protectEncounter
		local enc_tankProtection = encData(spawnLoc.spawn)
		
		local _removeRepair = function(gid, idx, sid)
			if Squad_GetBlueprint(sid) == SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP then
				Squad_DeSpawn(sid)
			end
		end
		
		SGroup_ForEach(enc_tankProtection:GetSgroup(), _removeRepair)
		
		local goalData = {
			name = "Defend",
			target = _sg_tank,
			range = 10,
			leashRange = 25,
			maxIdleTime = -1,
			retaliateAttacks = false,
			onFailure = _destroyTank_retreat,
		}
		enc_tankProtection:SetGoal(goalData)
	end
	
	if scartype(data.additionalEncounters) == ST_TABLE then
		for i = 1, table.getn(data.additionalEncounters) do
			data.additionalEncounters[i](spawnLoc.spawn)
		end
	end
end

function _destroyTank_retreat(encounterID)
end

--Grants the player the reward and shows the corresponding text
function DestroyTank_ShowReward()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		XP1_GiftVeterancy(0.15, true)
	end
end



---------------------------
-- INTEL EVENTS
---------------------------
--SEQUENCE "" MISSION "SOBJ_DestroyTank" CHARACTER "American Riflemen"
function DestroyTank_IntroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074784)	-- LOCDB [11074784] 'We have received reports of crippled enemy tank in the area. Locate and destroy it.' - 'Intel'
	CTRL.WAIT()
end

function DestroyTank_OutroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074785)	-- LOCDB [11074785] 'One less tank to worry about!' - 'American Riflemen'
	CTRL.WAIT()
end
