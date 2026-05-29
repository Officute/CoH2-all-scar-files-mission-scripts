-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Bonus Objective
-- Objective File - Rescue Allied Squads
-- Designer: R.McGechaen
-------------------------------------------------------------------------
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-- [[ OBJECTIVE DEFINITION ]]
-------------------------------------------------------------------------
function INIT_BonusRescueSquads()
	print("Initializing SecondaryOBJ_RescueSquads...")
	
	
	--Objective specific variables
	_sg_alliedSquads = SGroup_CreateIfNotFound("_sg_alliedSquads")
	
	-- Pre-condition:		BonusObj_Start() called.
	-- Success condition:	Player kill unit
	-- Failure condition:	Mission ends.
	-- Post-condition:
	--		Success:		10% company strength increase
	--		Failure:		
	SecondaryOBJ_RescueSquads = {
		--Info
		Title = 11076435,	-- LOCDB [11076435] 'Rescue the Allied Squads'
		Type = OT_Bonus,
		Parent = nil,
		subObjectives = nil,
		--Intel
		Intel_Start = 				RescueSquads_IntroEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			RescueSquads_OutroEvent,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = RescueSquads_Start,
		IsComplete = function() 
				return SGroup_IsEmpty(enc_rescueSquads_enemySquads:GetSgroup())
			end,
		PreComplete = function() Rule_RemoveIfExist(_rescueSquads_killUnit) end,
		OnComplete = function()
				Cmd_UngarrisonSquad(_sg_alliedSquads)
				
				Cmd_Retreat(_sg_alliedSquads, SecondaryOBJ_RescueSquads.data.exitPos, true)
				
				Rule_AddInterval(RescueSquads_ShowReward, 1)
				
				if(scartype(SecondaryOBJ_RescueSquads.data.OnComplete) == ST_FUNCTION) then
					SecondaryOBJ_RescueSquads.data.OnComplete()
				end
			end,
		IsFailed = function()
				return SGroup_CountSpawned(_sg_alliedSquads) == 0
			end,
		PreFail = function() 
				Rule_RemoveIfExist(_rescueSquads_killUnit) 
				Objective_UpdateText(SecondaryOBJ_RescueSquads, 11076435, nil, false)	-- [11076435] 'Rescue the Allied Squads'
			end,
		OnFail = nil,
	}
end
Scar_AddInit(INIT_BonusRescueSquads)


-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function RescueSquads_Start()
	
	local data = SecondaryOBJ_RescueSquads.data
	
	-- Make sure the egroups provided are valid (not empty)
	for i = table.getn(data.spawns), 1, -1 do 
		if scartype(data.spawns[i]) == ST_EGROUP and EGroup_IsEmpty(data.spawns[i]) then
			table.remove(data.spawns, i)
		end
	end
	
	local spawnLoc = nil
	if(#data.spawns == 0) then
		fatal("Unable to find valid spawn position for RescueSquads objective.")
	else
		spawnLoc = Table_GetRandomItem(data.spawns)
	end
	
	--Check for a predetermined exit position
	if data.exitOptions then
		if scartype(data.exitOptions) ~= ST_TABLE then
			data.exitOptions = {data.exitOptions}
		end
		data.exitPos = World_GetClosest(spawnLoc, data.exitOptions)
	else
		--By default, send units to player base and despawn them there
		data.exitPos = EGroup_GetPosition(eg_XP1_rifle_command)
	end
	
	local coreUnits = XP1_CompanyDif({{SBP.AEF.PARATROOPER_SQUAD_MP}, 
								{SBP.AEF.RIFLEMEN_SQUAD_MP}, 
								{SBP.AEF.ASSAULT_ENGINEER_SQUAD_MP},
								{SBP.AEF.RIFLEMEN_SQUAD_MP}})
	
	local encData = {
		name = "secondaryObj_rescueSquad_allies",
		spawn = Util_GetPosition(spawnLoc),
		player = player3,
		sgroups = {_sg_alliedSquads},
		units = {
			{
				sbp = coreUnits,
			},
			{
				sbp = coreUnits,
			},
		},
	}
	local enc_alliedSquads = Encounter:Create(encData)
	
	if scartype(spawnLoc) == ST_EGROUP then
		Cmd_Garrison(_sg_alliedSquads, spawnLoc, true, false, true)
	end
	SGroup_SetInvulnerable(_sg_alliedSquads, true)
	
	modID_weaponDamage = Modify_WeaponDamage(_sg_alliedSquads, "hardpoint_01", 0)
	
	--Hintpoint
	Objective_AddUIElements(SecondaryOBJ_RescueSquads, spawnLoc, true, 11076435, true, 2.5)		-- LOCDB [11076435] 'Rescue the Allied Squads'
	
	
	--Setup rule that periodically kills entities
	local count = SGroup_TotalMembersCount(_sg_alliedSquads, false)
	local timeOut = data.failTime or 5*60
	
	data.timerValue = math.floor(timeOut/count)
	
	Rule_AddInterval(_rescueSquads_killUnit, data.timerValue)
	
	-- Spawn the Enemies
	local encData = {
		name = "secondaryObj_rescueSquad_enemies",
		spawn = {
			Prox_GetRandomPosition(Util_GetPosition(spawnLoc), 35, 20),
			Prox_GetRandomPosition(Util_GetPosition(spawnLoc), 35, 20),
			Prox_GetRandomPosition(Util_GetPosition(spawnLoc), 35, 20),
			Prox_GetRandomPosition(Util_GetPosition(spawnLoc), 35, 20),
			Prox_GetRandomPosition(Util_GetPosition(spawnLoc), 35, 20),
		},
		units = {
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.ASSAULT_PIONEER_SQUAD_MP,
			},
			{
				sbp = SBP.WEST_GERMAN.VOLKSGRENADIER_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() <= 4},
			},
			{
				sbp = SBP.WEST_GERMAN.OBERSOLDATEN_SQUAD_MP,
				conditions = {XP1_GetNodeStrength() >= 5},
			},
		},
	}
	enc_rescueSquads_enemySquads = Encounter:Create(encData)
	
	local goalData = {
		name = "Attack",
		target = spawnLoc,
		range = 60,
		leashRange = 60,
--~ 		fallbackParams = {
--~ 			thresholds = {0.25},
--~ 			thresholdType = Threshold_PercentageEntitiesRemaining,
--~ 			markers = {mkr_e_retreat_secObj},
--~ 			retreat = true,
--~ 		}
	}
	enc_rescueSquads_enemySquads:SetGoal(goalData)
	
	if scartype(data.additionalEncounters) == ST_TABLE then
		for i = 1, table.getn(data.additionalEncounters) do
			data.additionalEncounters[i](spawnLoc)
		end
	end
end

-- Kill an allied squad every failTime/unitCount seconds
function _rescueSquads_killUnit()
	if SGroup_IsEmpty(_sg_alliedSquads) == false then
		if SGroup_IsUnderAttack(_sg_alliedSquads, ALL, 5) then
			local randSquad = SGroup_GetRandomSpawnedSquad(_sg_alliedSquads)
			local squadSize = Squad_Count(randSquad)
			local randEntityIndex = World_GetRand(1, squadSize) - 1
			
			Entity_Kill(Squad_EntityAt(randSquad, randEntityIndex))
			
			local totalLeft = SGroup_TotalMembersCount(_sg_alliedSquads)
			
			if totalLeft > 0 then
--~ 				Objective_UpdateText(SecondaryOBJ_RescueSquads, Loc_FormatText(11076448, Loc_ConvertNumber(totalLeft)), nil, false)		-- LOCDB [11076448] 'Rescue the Allied Squads (%1TOTAL_LEFT% soldiers left)'
			end
		end
	else
		Rule_RemoveMe()
	end
end

--Grants the player the reward and shows the corresponding text
function RescueSquads_ShowReward()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		XP1_AddCompanyStrength(10, true)
	end
end




---------------------------
-- INTEL EVENTS
---------------------------
--SEQUENCE "" MISSION "SOBJ_RescueSquads" CHARACTER "American Riflemen"
function RescueSquads_IntroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074788)	-- LOCDB [11074788] 'Allied squads are pinned down and are requesting immediate assistance.' - 'Intel'
	CTRL.WAIT()
end

function RescueSquads_OutroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.American_Paratrooper_01, 11074789)	-- LOCDB [11074789] 'Thaks for the assist! I thought we were goners!' - 'American Paratrooper'
	CTRL.WAIT()
end
