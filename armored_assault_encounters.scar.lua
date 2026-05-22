--~ print("\tLoading encdata file...")
--~ -------------------------------------------------------------------------
--~ -------------------------------------------------------------------------
--~ -- Hardpoint - Encounters data
--~ -- Designer: Byron Chow
--~ -------------------------------------------------------------------------
--~ -------------------------------------------------------------------------

print("\tLoading encdata file...")

ENCOUNTERS = {}

--~ -- Similar to the EVENTS file, each of these creates an encounter and returns a reference.
--~ -- Remember to add a simple description for each encounter.


-- squads that will
ENCOUNTERS.capture_encounter = function(target_pos) --add skirmish ai

	local random_intent = t_intents[World_GetRand(1, table.getn(t_intents))]

	local encData = {
		name = "Capture Encounter",
		sgroups = {sg_capture_encounter},
		spawn = {mkr_captureEntryPoint},
		intent = random_intent,
		onDeath = nil,
		goal = {
			name = "Defend",
			target = target_pos,
			range = 25,
			leashRange = 10,
			attackMove = true,
			coordinatedMoveRadius = 10,
			tacticControlList = {},
			onFailure = DespawnSquads,
			fallbackParams = {
				thresholds = {0.3},
				thresholdType = Threshold_PercentageHealth,
				markers = {mkr_captureEntryPoint},
				retreat = true,
				retreatDelay = 3,
			},
		},
	}
	
	
	local enc_newEncounter = XP1_EncounterCreate(encData) -- Always declare locally and pass back as a return

	return enc_newEncounter
end


GOALS = {}



-- retreats and despawns squads
function DespawnSquads(encounter)
	encounter:ClearGoal()
	Cmd_Retreat(encounter:GetSgroup(), mkr_captureEntryPoint, mkr_captureEntryPoint)
end

