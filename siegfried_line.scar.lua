print("\tLoading Siegfried_Line mission file...")
-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- Siegfried Line - Challenge
-- Designer: A.Molina
-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScriptSetup.scar") -- <== ### CRITICAL ELEMENT. 
import("XP1.scar")				-- Ardennes Assault functionality

-- [[ Objective files ]]
import("Siegfried_Line_obj_Artillery.scar")			--Airborne - take out artillery
import("Siegfried_Line_obj_BreakLine.scar")		-- Support - Secure road
import("Siegfried_Line_obj_AAGuns.scar")			-- Mechanized/Infantry - AA guns
import("Siegfried_Line_obj_DestroyBunker.scar")	-- End objective - Take out enemy bunker

-- [[ Encounter data ]]
import("Siegfried_Line_encounters.scar")



-------------------------------------------------------------------------
-- [[ MISSION SETUP ]]
-------------------------------------------------------------------------
-- Initializes players
function Mission_SetupPlayers()
	player1 = Setup_Player(1, 11073202, "aef", 1)					-- player1 is always the human player
	player2 = Setup_Player(2, 11073205, "west_german", 2)		-- player2 is always the AI opponent
	player3 = Setup_Player(3, 11073202, "aef", 1)					-- player3 is always the AI ally
end

-- Defines key mission data and any global values used throughout the mission.
function Mission_SetupVariables()
	print("Initializing mission DATA...")
	
	-- ### CRITICAL ELEMENT. This table contains all the initialization data for the mission.
	g_missionData = {
		useBeginnerHints = false,					-- Wether or not to use the BeginnerHint system
		useEncounterSystem = true,					-- Whether or not to use the Encounter system
		useXP1Difficulty = true,					-- Whether or not this mission uses the XP1 Difficulty system
		missionType = MT_XP1_CHALLENGE,					-- What Mission Type is this mission? MT_
		introNIS =  "XP1/Siegfried_Line_Intro",			-- Movie filename
		introNISlet = nil,					 		-- NISlet triggered after introNIS
		introNISletSkipped = nil,	 				-- Function called if the introNISlet is skipped
		introSitRep = nil,							-- Movie (string) to play after intro nislet
		endNISlet = nil,							-- NISlet triggered on mission completion
		endNIS = nil,								-- Movie (string) to play on mission completion
		missionSpeechPath = "botb/gameplay",					-- Speech path to cache (string)
		precacheSounds = {							-- Any audio files you want precached (list of strings)
		},
		nisFiles = {								-- .nis files associated with the mission (path string)
		},
		nisInTransitionTime = 0,
		nisOutTransitionTime = 0,
		objectives = {								-- List of PARENT objective tables.
			OBJ_BreachLine,
			OBJ_Artillery,
			OBJ_AAGuns,
			OBJ_DestroyBunker,
		},
		atmosphere = "xp1/_siegfried_line_start.aps",		-- Loads an atmosphere for this mission. Useful for battles and mini challenges
		startingUnits = {							-- Units to be spawned for P1 on mission start. Follows same parameters as Encounters.
		}
	}
	
	
	--[[GLOBAL VARIABLES]]
	eg_retreatPoint = EGroup_Create("eg_retreatPoint")						-- Invisible retreat point spawned via script.
	sg_enemyArtillery = SGroup_CreateIfNotFound("sg_enemyArtillery")
	sg_artillery1 = SGroup_CreateIfNotFound("sg_artillery1")
	sg_artillery2 = SGroup_CreateIfNotFound("sg_artillery2")
	sg_artillery3 = SGroup_CreateIfNotFound("sg_artillery3")
	
	t_atmospheres = {
		mid = "data:art/scenarios/presets/atmosphere/xp1/_siegfried_line_mid.aps",
		ending = "data:art/scenarios/presets/atmosphere/xp1/_siegfried_line_end.aps"
	}
	
	t_flavourAbilitiesAllied = {
		flyby = BP_GetAbilityBlueprint("p47_flyby"),
		BP_GetAbilityBlueprint("p47_mg_strafe"),
		BP_GetAbilityBlueprint("p47_short_rocket_attack"),
		ABILITY.AEF.MAJOR_QUICK_RECON_RUN,
	}
	
	t_flavourAbilitiesEnemy = {
		ABILITY.GLOBAL.M01_STUKA_DOGFIGHT_PASS,
		ABILITY.GLOBAL.SP_OFF_MAP_ARTY_HARMLESS,
	}
	
	-- Contains information relevant to each commander selection
	t_commanderSelection = {
		{ -- AIRBORNE
			challenge = 1,		-- Which challenge this company was used on.
			name = 11078325,	-- loc 'Airborne Company'
			intelNotAvailable = EVENTS.NoAirborne,	--Intel if company is not available
			selectionIcon = "Icons_bob_companies_type_airborne_small",
			intelFinalSelection = EVENTS.AirborneSelected,
			survivingSgroup = SGroup_CreateIfNotFound("sg_airborneSurvivors"),
			prestartUnits = ENCOUNTERS.AirbornePreStartUnits,
			startingUnits = ENCOUNTERS.AirborneStartingUnits,
		},
		{ -- MECHANIZED
			challenge = 2,
			name = 11078326,	-- loc "Mechanized Company"
			intelNotAvailable = EVENTS.NoMechanized,
			selectionIcon = "Icons_bob_companies_type_infantry_small",
			intelFinalSelection = EVENTS.MechanizedSelected,
			survivingSgroup = SGroup_CreateIfNotFound("sg_mechanizedSurvivors"),
			prestartUnits = ENCOUNTERS.MechanizedPreStartUnits,
			startingUnits = ENCOUNTERS.MechanizedStartingUnits,
		},
		{ -- SUPPORT
			challenge = 3,
			name = 11078327,	-- loc "Support company"
			intelNotAvailable = EVENTS.NoSupport,
			selectionIcon = "Icons_bob_companies_type_support_small",
			intelFinalSelection = EVENTS.SupportSelected,
			survivingSgroup = SGroup_CreateIfNotFound("sg_supportSurvivors"),
			prestartUnits = ENCOUNTERS.SupportPreStartUnits,
			startingUnits = ENCOUNTERS.SupportStartingUnits,
		},
		{ -- RECON
			challenge = -1,
			name = 11078473,
			intelNotAvailable = EVENTS.NoRecon,
			selectionIcon = "Icons_bob_companies_type_ranger_small",
			intelFinalSelection = EVENTS.ReconSelected,
			survivingSgroup = SGroup_CreateIfNotFound("sg_reconSurvivors"),
			prestartUnits = ENCOUNTERS.ReconPreStartUnits,
			startingUnits = ENCOUNTERS.ReconStartingUnits,
			objectiveIntros = {
				EVENTS.FoxStartArtillery,				
				EVENTS.FoxStartRoad,				
				EVENTS.FoxStartAAGuns,				
			},
			objectiveOutros = {
				EVENTS.FoxOutroArtillery,
				EVENTS.FoxOutroRoad,
				EVENTS.FoxOutroAAGuns,
			}
		},
		--TODO:DLC: Insert a data table for each new company
	}
	
	
	--Contains information relevant to the intro "challenges" each of the commanders has to complete
	t_challengeData = {
		{	--Eliminate the Artillery
			camStart = mkr_camStart_artillery,
			spawnStart = mkr_spawnArty,
			spawnPositions = Marker_GetSequence("mkr_spawnArty_0", ""),
			commander = CD_AIRBORNE,			-- this gets filled further below
			intelIntro = EVENTS.IntroArtillery,		-- Intro before objective starts
			completed = false,					-- Whether or not this objective was completed.
			initFunction = ObjArtillery_Init,
			objective = OBJ_Artillery,
			button = DB_Button1,
			basePos = mkr_base2,				-- Where to spawn the base if this Commander is selected for final assault.
			entryPt = eg_entryArtillery,
		},
		{	--Take the main road
			camStart = mkr_camStart_road,
			spawnStart = mkr_spawnRoad,
			spawnPositions = Marker_GetSequence("mkr_spawnRoad_0", ""),
			commander = CD_MECHANIZED,
			intelIntro = EVENTS.IntroSecureRoad,
			completed = false,
			initFunction = ObjRoad_Init,
			objective = OBJ_BreachLine,
			button = DB_Button2,
			basePos = mkr_base1,
			entryPt = eg_entryRoad,
		},
		{	--Destroy the AA guns
			camStart = mkr_camStart_AA,
			spawnStart = mkr_spawnAA,
			spawnPositions = Marker_GetSequence("mkr_spawnAA_0", ""),
			commander = CD_SUPPORT,
			intelIntro = EVENTS.IntroAAGuns,
			completed = false,
			initFunction = ObjAAGuns_Init,
			objective = OBJ_AAGuns,
			button = DB_Button3,
			basePos = mkr_base3,
			entryPt = eg_entryAAGuns,
		},
	}
	
	
	g_currentChallenge = 1
	g_currentCommander = -1
	
	
	--[[MAP GROUPS]]
	--eg_bunkerHill1-3
	--eg_commandBunker
	--eg_entryPoints
	--eg_line1-3
end

-- Defines difficulty tables/tuning variables
function Mission_SetDifficulty(diffVal)
	g_difficulty = diffVal or Game_GetSPDifficulty() 	-- Note: Having the diffVal parameter allows for redefining difficulty settings during runtime.
	AI_OverrideDifficulty(g_difficulty)
	
	--Global difficulty table
	t_difficulty = {
		germanAttackDelay = Util_DifVar({120, 90, 60}, g_difficulty),		-- delay before germans attack player base
	}
	
	--Resources
	Player_SetResource(player1, RT_Manpower, 500)
	Player_SetResource(player1, RT_Fuel, 75)
	Player_SetResource(player1, RT_Munition, 75)
	
end

-- Sets restrictions on units, teams, etc.
function Mission_SetupRestrictions()
	--	Note: Resource Income/Caps should be defined in Mission_SetDifficulty()
	
	--[[ HUMAN PLAYER ]]
--~ 	Player_SetEntityProductionAvailability(player1, EBP.SOVIET.IS_2_HEAVY_TANK, ITEM_REMOVED)
	
	--[[ ALLIED PLAYER ]]
	
	--[[ ENEMY PLAYER ]]
	
end

-- Sets up the map before the mission starts (starting units, ownership, etc.)
function Mission_Preset()
	Camera_ResetToDefault()
	Camera_MoveTo(mkr_camStart_artillery, false)
	Game_SetMode(UI_Cinematic)
	
	Sound_SetMusicCombatValue(3, 60*60)
	--No ice re-freeze
	World_SetIceHealingRate(0.0)
	
	
	--Remove the popCap reduction stuff present in other missions. (Defined in xp1.scar)
	Rule_RemoveIfExist(XP1_Squad_Killed_Callback)
	--Remove all company strength/experience hooks. This needs to be called every time the commander is changed.
	XP1_StopCompanyStatTracking()
	
	
	Cmd_Upgrade(player1, UPG.AEF.RIFLE_COMMAND_GRENADE_MP, nil, true)
	Player_SetResource(player1, RT_Command, 5)
	
	
	--Other allied/enemy abilities
	for k, bp in pairs(t_flavourAbilitiesAllied) do
		Player_AddAbility(player3, bp)
	end
	for k, bp in pairs(t_flavourAbilitiesEnemy) do
		Player_AddAbility(player2, bp)
	end
	Player_AddAbility(player3, BP_GetAbilityBlueprint("pm_airdropped_mines"))
	Player_AddAbility(player3, BP_GetAbilityBlueprint("pm_pinpoint_artillery"))
	
	
	--Enemy artillery positions
	Util_CreateSquads(player2, {sg_enemyArtillery, sg_artillery1}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_artilleryGun1)
	Util_CreateSquads(player2, {sg_enemyArtillery, sg_artillery2}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_artilleryGun2)
	Util_CreateSquads(player2, {sg_enemyArtillery, sg_artillery3}, SBP.GERMAN.HOWITZER_105MM_LE_FH18_ARTILLERY, mkr_artilleryGun3)
	-- reduce range player can use artillery (so the player can't use it to bombard the bunkers)
	Modify_AbilityMaxCastRange(player1, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, 0.5)
	
	--AA Guns
	Util_CreateSquads(player2, {sg_enemyAA, sg_enemyAA_1}, SBP.WEST_GERMAN.FLAK_EMPLACEMENT, mkr_AAGun1)
	Util_CreateSquads(player2, {sg_enemyAA, sg_enemyAA_2}, SBP.WEST_GERMAN.FLAK_EMPLACEMENT, mkr_AAGun2)
	SGroup_SetInvulnerable(sg_enemyAA, true)
	
	--Start with no entry points. These are respawned by each challenge objective.
	for k,v in pairs(t_challengeData) do
		EGroup_DeSpawn(v.entryPt)
	end
	
	
	--Starting Allies and player units for Airborne section
	sg_alliesArtillery = SGroup_CreateIfNotFound("sg_alliesArtillery")
	Util_CreateSquads(player3, sg_alliesArtillery, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_allySpawn03)
	Util_CreateSquads(player3, sg_alliesArtillery, SBP.AEF.RIFLEMEN_SQUAD_MP, mkr_allySpawn04)
	SGroup_SetInvulnerable(sg_alliesArtillery, true)
	Modify_ReceivedDamage(sg_alliesArtillery, 0.3)
	Modify_WeaponDamage(sg_alliesArtillery, "hardpoint_01", 0.2)
	
	
--~ 	--This accounts for different Commander selections
--~ 	-- 't_companiesTable' table is created on startup by XP1_PrototypeSetupParameters().
--[[
 	for challengeIndex, challengeData in pairs(t_challengeData) do
		
		for i,companyData in pairs(companies) do
			if(challengeIndex == 1 and companyData.company == CD_AIRBORNE) then
				t_challengeData[challengeIndex].commander = CD_AIRBORNE
				break
			elseif(challengeIndex == 2 and companyData.company == CD_MECHANIZED) then
				t_challengeData[challengeIndex].commander = CD_MECHANIZED
				break
			elseif(challengeIndex == 3 and companyData.company == CD_SUPPORT) then
				t_challengeData[challengeIndex].commander = CD_SUPPORT
				break
			elseif(challengeIndex == 3 and companyData.company == CD_RANGER) then
				t_challengeData[challengeIndex].commander = CD_RANGER
				break
			elseif(challengeIndex == 1 and companyData.company == CD_CINCO) then
				t_challengeData[challengeIndex].commander = CD_CINCO
				break
			end
		end
		
		--Sanity check
		if(t_challengeData[challengeIndex].commander == -1) then
			print("break")
			fatal(string.format("Unable to find a suitable commander for SiegfriedLine Challenge#%d. Playing mission with companies %s, %s, and %s.", challengeIndex, companies[1].company, companies[2].company, companies[3].company))
		end
	end
	]]
	
	--TODO:DLC - Need to be able to assign new companies to whichever slot is empty.
	--For the time being, this simply drops Fox Company into the first challenge who's commander is not present
	for i=1, #t_challengeData do
		local challenge = t_challengeData[i]
		if not XP1_IsCompanyAvailable(challenge.commander) then
			print(string.format("Company %s not present. Replacing with Recon.", challenge.commander))
			challenge.commander = CD_RANGER
			t_commanderSelection[CD_RANGER].challenge = i
			
			--Change the intro/outro intel events of the objective to match Fox company
			t_challengeData[i].objective.Intel_Start = t_commanderSelection[CD_RANGER].objectiveIntros[i]
			t_challengeData[i].objective.Intel_Complete = t_commanderSelection[CD_RANGER].objectiveOutros[i]
			t_challengeData[i].objective.Intel_Fail = EVENTS.FoxObjectiveFailed
			break
		end
	end
	
	g_currentCommander = t_challengeData[g_currentChallenge].commander
	
	--Spawn the pre-start units for the first challenge since the camera will start on top of them
	t_commanderSelection[t_challengeData[1].commander].prestartUnits()
end




-------------------------------------------------------------------------
-- [[ MISSION START ]]
-------------------------------------------------------------------------
--Called once the intro nis/nislet/sitrep finishes playing.
function Mission_Start()
--~ 	g_currentChallenge = 1	--DEBUG
--~ 	Game_SetMode(UI_Normal)
--~ 	Game_FadeToBlack(FADE_IN, 0)
--~ 	Camera_SetInputEnabled(true)
--~ 	XP1_SetActiveCommander(g_currentCommander, false)
--~ 	XP1_StopCompanyStatTracking()
--~ 	
	
	Rule_AddInterval(CombatFlavourEnemy, 30)						-- 
	Rule_AddDelayedInterval(CombatFlavourAllied, 15, 30)

	Util_StartIntel(EVENTS.MissionIntro)
	Event_NarrativeEventsNotRunning(_StartCurrentChallenge, nil, 1.0)
end

--Called when a challenge objective is completed
function GoToNextChallenge()
	World_IncreaseInteractionStage()
	--Store the units that survived. later used when the player chooses a commander
	--Make sure they are spawned first
	local _tempGroup = SGroup_Create("")
	Player_GetAll(player1, _tempGroup)
	for k=1, SGroup_CountSpawned(_tempGroup) do
		SGroup_Add(t_commanderSelection[g_currentCommander].survivingSgroup, SGroup_GetSpawnedSquadAt(_tempGroup, k))
	end
	SGroup_Destroy(_tempGroup)
	
	--Clear any control groups
	for i=1, 9 do
		Misc_ClearControlGroup(i)
	end
	Misc_ClearSelection()
	
	--Remove units from player (so they don't control them in other challenges)
	SGroup_SetPlayerOwner(Player_GetSquads(player1), player3)
	
	--Disable the entry point (an appropriate one will be enabled on challenge start)
	EGroup_DeSpawn(t_challengeData[g_currentChallenge].entryPt)
	
	g_currentChallenge = g_currentChallenge + 1
	
	--Manange atmosphere transitions
	if g_currentChallenge == 2 then
		Game_LoadAtmosphere(t_atmospheres.mid, 2*60)
	end
	
	if(g_currentChallenge < 4) then
		--Go to the next intro challenge
		g_currentCommander = t_challengeData[g_currentChallenge].commander
		_StartCurrentChallenge()
	else
		--Start the final bunker assault
		Game_SetMode(UI_Cinematic)
		Game_LoadAtmosphere(t_atmospheres.ending, 2*60)
		Event_NarrativeEventsNotRunning(_StartFinalAssaultSelection, nil, 0.5)
	end
end

function _StartCurrentChallenge()
	
	Util_StartIntel(t_challengeData[g_currentChallenge].intelIntro)
	
	--Reset camera. Lock and move to new position
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	Camera_ResetToDefault()
	
	Rule_AddOneShot(_CinematicWait, 2.5)
end

function _CinematicWait()
	--Spawn necessary units before panning camera
	t_challengeData[g_currentChallenge].initFunction()
	
	--Move camera and Check when camera reaches target
	Camera_MoveTo(t_challengeData[g_currentChallenge].camStart, true, 0.1)
	Event_ElementOnScreen(_CameraOnTarget, nil, player1, t_challengeData[g_currentChallenge].camStart, ANY, 0.33, false, 1.0)
end

--Callback when camera finishes moving to challenge start location
function _CameraOnTarget(data)
	--Ungarrison any left over units.
	if(g_currentChallenge-1 >= 1) then
		local _prevCommanderIndex = t_challengeData[g_currentChallenge-1].commander
		Cmd_UngarrisonSquad(t_commanderSelection[_prevCommanderIndex].survivingSgroup)
	end

	Camera_SetInputEnabled(true)
	
	Util_MissionTitle(t_commanderSelection[t_challengeData[g_currentChallenge].commander].name)
	
	Event_NarrativeEventsNotRunning(_CompanyTitleWait, nil, 1.0)
end

function _CompanyTitleWait(data)
	--Temporarily despawn units from previous challenge
	if(g_currentChallenge-1 >= 1) then
		local _prevCommanderIndex = t_challengeData[g_currentChallenge-1].commander
		SGroup_DeSpawn(t_commanderSelection[_prevCommanderIndex].survivingSgroup)
	end


	--Check to see if the commander is alive.
	if(XP1_GetCommanderDataTable(g_currentCommander).isAlive) then
		XP1_SetActiveCommander(g_currentCommander, false)
		XP1_StopCompanyStatTracking()
		Game_SetMode(UI_Normal)
		
		--ReSpawn the corresponding entryPt
		EGroup_ReSpawn(t_challengeData[g_currentChallenge].entryPt)
		
		--Start the objective and spawn the units that will be there when the camera pans over.
		Objective_Start(t_challengeData[g_currentChallenge].objective)
		t_commanderSelection[g_currentCommander].startingUnits()
	else
		--Inform the player that company is not available, and move on to the next challenge.
		Util_StartIntel(t_commanderSelection[g_currentCommander].intelNotAvailable)
		Event_NarrativeEventsNotRunning(GoToNextChallenge, nil)
	end
end



--Shows commander selection for the final assault
function _StartFinalAssaultSelection()
	Camera_SetInputEnabled(false)
	Camera_ResetToDefault()
	
	SGroup_SetPlayerOwner(Player_GetSquads(player1), player3)
	
	local _commanderAlive = false
	
	--This loop checks to see which commanders are alive and successfully completed the intro objectives.
	for k,challenge in pairs(t_challengeData) do
		if challenge.completed and XP1_GetCommanderDataTable(challenge.commander).isPresent and XP1_GetCommanderDataTable(challenge.commander).isAlive then
			_commanderAlive = true
			break
		end
	end
	
	
	--If commander available for selection, show dialogue. Otherwise fail the mission.
	if(_commanderAlive) then
		print("Showing final assault selection...")
		Util_StartIntel(EVENTS.CommanderSelection)
		Event_NarrativeEventsNotRunning(_ShowFinalAssaultDialogue, nil)
	else
		--No available commanders, fail the mission. They're dead, they're ALL DEAD!
		Util_StartIntel(EVENTS.ChallengesFailed)
		Event_NarrativeEventsNotRunning(Mission_Fail, nil, 2.0)
	end
end

function _ShowFinalAssaultDialogue()
	UI_MessageBoxReset()
	UI_MessageBoxSetText(11077872, 11076821)		-- LOCDB [11076821] 'Select which Commander will lead the final assault.'
														-- LOCDB [11077872] 'The Final Assault'
	
	for k,challenge in pairs(t_challengeData) do
		local isAvailable = challenge.completed and XP1_GetCommanderDataTable(challenge.commander).isPresent and XP1_GetCommanderDataTable(challenge.commander).isAlive
		local companyName = XP1_GetCommanderDataTable(challenge.commander).companyLocName
		local icon = t_commanderSelection[challenge.commander].selectionIcon
		
		UI_MessageBoxSetButton(challenge.button, Loc_Empty(), Loc_FormatText(11077873, companyName), icon, isAvailable)
	end

	UI_MessageBoxShow(DC_Iconographic, _FinalAssaultSelectionCallback)
	
	Sound_Play2D("ui/metamap/mm_ablity_page_appears")
end

--Callback when a button from UI_MessageBox is clicked.
function _FinalAssaultSelectionCallback(selection)
	for k,data in pairs(t_challengeData) do
		if data.button == selection then
			Sound_Play2D("ui/metamap/mm_commander_select_in_mission")
			
			g_currentCommander = data.commander
			OBJ_DestroyBunker.Intel_Start = t_commanderSelection[g_currentCommander].intelFinalSelection
			SGroup_ReSpawn(t_commanderSelection[g_currentCommander].survivingSgroup)
			Rule_AddOneShot(GoToFinalAssault, 1)
--~ 			Util_MissionTitle(LOC("Selected " .. g_currentCommander), 0.25, 3, 0.25) --debug
			break
		end
	end
end

--Called once a commander is selected for the final assault.
function GoToFinalAssault()
	Game_SetMode(UI_Cinematic)
	Camera_SetInputEnabled(false)
	Game_FadeToBlack(FADE_OUT, 1.2)
	Event_Timer(EventHandler_ObjectiveStart, {objective = OBJ_DestroyBunker}, 1.5)
end











-----------------------------------
-- UTIL STUFF
-----------------------------------
--Firing enemy artillery. Called from multiple objectives
function FireEnemyArtillery(targets)
	local _tempGroup = SGroup_CreateIfNotFound("sg_fireArtilleryGroup")
	
	for k=1, SGroup_CountSpawned(sg_enemyArtillery) do
		local _squad = SGroup_GetSpawnedSquadAt(sg_enemyArtillery, k)
		SGroup_Add(_tempGroup, _squad)
		Cmd_Ability(_tempGroup, ABILITY.GERMAN.HOWITZER_105MM_BARRAGE_ABILITY, Table_GetRandomItem(targets), nil, true, false)
		SGroup_Clear(_tempGroup)
	end
end

--Removes an existing ScarEvent from the queue.
function _RemoveEvent(data)
	Event_Remove(data.eventID)
end

---Finds the closest valid entry point to a position
function GetClosestEntryPoint(position)
	position = Util_GetPosition(position)
	local minDistance = 999999
	local closest = false
	
	for k=1, EGroup_Count(eg_entryPoints) do
		local entryPt = EGroup_GetSpawnedEntityAt(eg_entryPoints, k)
		local dist = World_DistancePointToPoint(Entity_GetPosition(entryPt), position)
		if (Player_OwnsEntity(player1, entryPt) or Player_OwnsEntity(player3, entryPt)) and  dist < minDistance  then
			minDistance = dist
			closest = entryPt
		end
	end
	
	if scartype(closest) ~= ST_ENTITY then
		fatal("Unable to find closest entry point to position")
	else
		return closest
	end
end

--Despawns units on goal failure (usually retreat)
function Despawn(enc)
	if(SGroup_CountSpawned(enc:GetSgroup()) > 0) then
		enc:RemoveOnDeath(true)
		enc:ClearGoal()
		SGroup_DestroyAllSquads(enc:GetSgroup())
	end
end

--Stagger retreats a list of encounters
function RetreatRemainingEncounters(encountersList, retreatTarget)
	for k,enc in pairs(encountersList) do
		if enc:IsAlive() then
			enc:ClearGoal()
			Cmd_StaggeredRetreat(enc:GetSgroup(), {retreatTarget}, 20, true)
		end
	end
end

--Replaces a unit on an encounter.
function ReplaceUnit(unit)
	local enc = unit.encounter
	enc:AddUnit(unit.data)
	
	if(not enc:Goal_HasValidObjective()) then
		enc:RestartGoal()
	end	
end

-- Callback helper for removing and onDeath functions for encounters
function _RemoveOnDeath(data)
	if data.allUnits == nil then data.allUnits = true end
	data.encounter:RemoveOnDeath(data.allUnits)
end


--Planes and explosions going off throughout the map for combat flavour
function CombatFlavourEnemy()
	local _pos = Player_GetSquadConcentration(player1) or Camera_GetCurrentTargetPos()
	
	_pos = Prox_GetRandomPosition(_pos, 15,  5)
--~ 	view(_pos)
	Cmd_Ability(player2, Table_GetRandomItem(t_flavourAbilitiesEnemy), _pos, Util_GetOffsetPosition(_pos, OFFSET_BACK_LEFT, 5), true)
end

function CombatFlavourAllied()
	local _enemies = SGroup_CreateIfNotFound("sg_enemiesOnCamera")
	Player_GetAllSquadsNearMarker(player2, _enemies, Camera_GetTargetPos(), 25)
	
	if SGroup_CountSpawned(_enemies) > 0 then
		local _pos = Squad_GetPosition(SGroup_GetRandomSpawnedSquad(_enemies))
		_pos = Util_GetOffsetPosition(_pos, OFFSET_BACK_RIGHT, 15)
--~ 		view(_pos)
		Cmd_Ability(player3, Table_GetRandomItem(t_flavourAbilitiesAllied), _pos, nil, true)
	else
		print("No target found for CombatFlavourAllied()")
		Cmd_Ability(player3, t_flavourAbilitiesAllied.flyby, Camera_GetTargetPos(), nil, true)
	end
end



-----------------------------------
-- DEBUG
-----------------------------------
--Debug - Insta-caps a territory point
function cap(owner)
	if Misc_IsCommandLineOptionSet("dev") then
		EGroup_InstantCaptureStrategicPoint(Util_Grab(), owner)
	end
end

--Debug - Setup final assault
function setupFinal()
	if Misc_IsCommandLineOptionSet("dev") then
		World_IncreaseInteractionStage()
		World_IncreaseInteractionStage()
		World_IncreaseInteractionStage()
		
		g_currentChallenge = 4
		t_challengeData[1].completed = true
		t_challengeData[2].completed = true
		t_challengeData[3].completed = true
		
--~ 		ENCOUNTERS.AirbornePreStartUnits()
--~ 		ENCOUNTERS.AirborneStartingUnits()
		
		ENCOUNTERS.MechanizedPreStartUnits()
--~ 		ENCOUNTERS.MechanizedStartingUnits()
		
		ENCOUNTERS.SupportPreStartUnits()
--~ 		ENCOUNTERS.SupportStartingUnits()
		
--~ 		_StartFinalAssaultSelection()
	end
end

function winIntro()
	if Misc_IsCommandLineOptionSet("dev") then
		t_challengeData[t_commanderSelection[1].challenge].completed=false
		t_challengeData[t_commanderSelection[2].challenge].completed=true
		t_challengeData[t_commanderSelection[3].challenge].completed=false
	end
end
