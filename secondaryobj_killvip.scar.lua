-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Bonus Objective
-- Objective File - Kill the German VIP
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

--[[ Sample data table:
See http://relicwiki.relic.sega.us/display/REL/Slottable+Secondary+Objectives for more information

{
	obj = SecondaryOBJ_KillVIP,
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
function INIT_BonusVIP()
	print("Initializing SecondaryOBJ_KillVIP...")
	
	
	--Objective specific variables
	_sg_germanVIP = SGroup_CreateIfNotFound("_sg_germanVIP")
	
	
	-- Pre-condition:		BonusObj_Start() called.
	-- Success condition:	Player kills German VIP
	-- Failure condition:	Mission ends.
	-- Post-condition:
	--		Success:		Player gets 10% Company Veterancy bonus
	--		Failure:		
	SecondaryOBJ_KillVIP = {
		--Info
		Title = 11076430, -- LOCDB [11076430] 'Locate and eliminate the German VIP'
		Type = OT_Bonus,
		Parent = nil,
		subObjectives = nil,
		--Intel
		Intel_Start = 				KillVIP_IntroEvent,
		Intel_Start_SkipFunc = 		nil,
		Intel_Complete = 			KillVIP_OutroEvent,
		Intel_Complete_SkipFunc = 	nil,
		Intel_Fail = 				nil,
		Intel_Fail_SkipFunc = 		nil,
		--Functions
		SetupUI = nil,
		PreStart = nil,
		OnStart = KillVIP_Start,
		IsComplete = function() 
				return SGroup_CountSpawned(_sg_germanVIP) == 0
			end,
		PreComplete = nil,
		OnComplete = function()
				Rule_AddInterval(KillVIP_ShowReward, 1)
				if(scartype(SecondaryOBJ_KillVIP.data.OnComplete) == ST_FUNCTION) then
					SecondaryOBJ_KillVIP.data.OnComplete()
				end
			end,
		IsFailed = nil,
		PreFail = nil,
		OnFail = nil,
	}
	
	
end
Scar_AddInit(INIT_BonusVIP)


-------------------------------------------------------------------------
-- [[ OBJECTIVE FUNCTIONS ]]
-------------------------------------------------------------------------
function KillVIP_Start()
	local data = SecondaryOBJ_KillVIP.data
	
	local spawnLoc = Table_GetRandomItem(data.spawns)

	local encData = {
		name = "secondaryObj_killVIP",
		spawn = spawnLoc.spawn,
		sgroups = {_sg_germanVIP},
		units = {
			SBP.WEST_GERMAN.FIELD_OFFICER_SQUAD_MP,
		},
	}
	local enc_vip = Encounter:Create(encData)
	
	CircleBlipID = MapIcon_CreatePosition(Util_GetPosition(spawnLoc.ui), "Icons_minimap_area_circle", 50, 255, 255, 0, 255)
	hpid_killVIP2 = Objective_AddUIElements(SecondaryOBJ_KillVIP, _sg_germanVIP, false, 11076431, true, 2.5)	-- LOCDB [11076431] 'Eliminate the VIP'
	
	if(data.goal) then
		data.goal(enc_vip)
	end
	
	if(data.protectEncounter) then
		defendEncounter = data.protectEncounter(spawnLoc.spawn)
		local goalData = {
			name = "Defend",
			target = _sg_germanVIP,
			range = 10,
			leashRange = 20,
			maxIdleTime = -1,
			retaliateAttacks = false,
		}
		defendEncounter:SetGoal(goalData)
	end
	
	if scartype(data.additionalEncounters) == ST_TABLE then
		for i = 1, table.getn(data.additionalEncounters) do
			data.additionalEncounters[i](spawnLoc.spawn)
		end
	end
	
	Rule_AddInterval(PlayerCanSeeVIP, 1.0)
end

--Grants the player the reward and shows the corresponding text
function KillVIP_ShowReward()
	if not Event_IsAnyRunning() then
		Rule_RemoveMe()
		XP1_GiftVeterancy(0.10, true)
	end
end

-- when the player sees the VIP, remove the radius ping and put a normal ping
function PlayerCanSeeVIP()
	if Player_CanSeeSGroup(player1, _sg_germanVIP, ANY) or SGroup_IsAlive(_sg_germanVIP) == false then
		MapIcon_Destroy(CircleBlipID)
		if SGroup_IsAlive(_sg_germanVIP) then
			hpid_killVIP = Objective_AddUIElements(SecondaryOBJ_KillVIP, _sg_germanVIP, true)
		end
		Rule_RemoveMe()
	end
end


---------------------------
-- INTEL EVENTS
---------------------------
--SEQUENCE "" MISSION "SOBJ_KillVIP" CHARACTER "American Riflemen"
function KillVIP_IntroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.None, 11074786)	-- LOCDB [11074786] 'There are reports of a high-value target in the area. Take him out.' - 'Intel'
	CTRL.WAIT()
end

function KillVIP_OutroEvent()
	CTRL.Actor_PlaySpeech(ACTOR.American_Riflemen_01, 11074787)	-- LOCDB [11074787] 'The target has been neutralized!' - 'American Riflemen'
	CTRL.WAIT()
end
