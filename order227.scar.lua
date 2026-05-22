
-----------------------------------------------------------------------------------
-- CoH2 -- Feb 7, 2013
-- Order 227: Commissar at player HQ that shoots soldiers in retreating squads
-----------------------------------------------------------------------------------
--? @group scardoc;Various

--? @args [Integer timeLimit,  Integer timeBetweenShots, Boolean noMercy]
--? @result Void
--? @shortdesc Enable the HQ Commissar in CoH2 campaign missions. The noMercy flag allows the Commissar to execute more than one member of each squad.
function Order227_Init(timeLimit, timeBetweenShots, noMercy)
	UI_SetSoviet227Visibility(true)
	Player_CompleteUpgrade(World_GetPlayerAt(1), BP_GetUpgradeBlueprint("227_enable"))
	g_227_timeLimit = timeLimit or 60 -- after this time, commissar is despawned
	g_227_noMercy = noMercy or true
	g_227_timeBetweenShots = timeBetweenShots or Util_DifVar({12, 6, 3, 3})
	g_227_spawnPositions = {}
	g_227_startSpeech = {11049582, 11049583, 11049584}
	g_227_endSpeech = {11049585, 11049586, 11049587}
	g_227_attackSpeech = {"11049568", "11049569", "11049570", "11049571", "11049572", "11049573"}
	g_227_speechIndex = 1
	g_227_attackSpeechIndex = 1
	g_227_timeBetweenAttackSpeech = 0
	g_227_tempSpeechPath = "mission/global"
	Rule_AddGlobalEvent(Order227_Start, GE_AbilityExecuted)
end


-----------------------------------------------------------------------------------
-- Order 227: Commissar at player HQ that shoots soldiers in retreating squads
-----------------------------------------------------------------------------------
function Order227_Start(caster, ability, target)
	if scartype(caster) == ST_PLAYER and (ability == ABILITY.SOVIET.BASE_CONSCRIPT_DISPATCH or ability == ABILITY.SOVIET.FRONTOVIKI_CONSCRIPT_DISPATCH or ability == ABILITY.SOVIET.PENAL_TROOP_DISPATCH_SP) then
		
		if caster ~= World_GetPlayerAt(1) then
			return
		end
		
		local playerEntities = Player_GetEntities(World_GetPlayerAt(1))
		g_227_timer = 000227
		g_227_resource = 100
		g_227_timeLimit = g_227_timeLimit + 3
		
		Player_SetResource(World_GetPlayerAt(1), RT_SovietOrder227, g_227_resource)
		local hqBPs = {EBP.SOVIET.HQ, EBP.SOVIET.HQ_WRECK, BP_GetEntityBlueprint("sp_hq"), BP_GetEntityBlueprint("m10_military_hospital"), BP_GetEntityBlueprint("forward_hq")}
		EGroup_Filter(playerEntities, hqBPs, FILTER_KEEP)
		if not EGroup_IsEmpty(playerEntities) then
			sg_227_commissar = SGroup_CreateIfNotFound("sg_227_commissar")
			sg_227_retreatingSquads = SGroup_CreateIfNotFound("sg_227_retreatingSquads")
			sg_227_usedTargets = SGroup_CreateIfNotFound("sg_227_usedTargets")
			
			local f = function (gid, idx, eid)
				local spawnpos = Util_GetOffsetPosition(eid, OFFSET_BACK, 5)
				
				-- spawn commissars at HQs
				if scartype(player227) == ST_PLAYER then
					Util_CreateSquads(player227, sg_227_commissar, BP_GetSquadBlueprint("commissar_227"), spawnpos)
				else
					Util_CreateSquads(World_GetPlayerAt(2), sg_227_commissar, BP_GetSquadBlueprint("commissar_227"), spawnpos)
				end
				table.insert(g_227_spawnPositions,spawnpos)
				SGroup_EnableUIDecorator(sg_227_commissar, false)
			end
			if SGroup_IsEmpty(sg_227_commissar) then
				EGroup_ForEach(playerEntities, f)
			end
			if not Rule_Exists(Order227_Update) then
			
				-- add rule that looks for retreating player squads
				SGroup_Clear(sg_227_retreatingSquads)
				Rule_AddDelayedInterval(Order227_Update, 3, 1)
				Timer_Start(g_227_timer, g_227_timeLimit)
				UIWarning_Show(11046802) -- LOCDB [11046802] 'Order 227 enacted! Commissar dispatched to HQ!'
			else
				UIWarning_Show(11046803)-- LOCDB [11046803] 'Order 227 reinstated.'
				SGroup_Clear(sg_227_usedTargets)
				Timer_End(g_227_timer)
				Rule_Remove(Order227_Update)
				Rule_AddDelayedInterval(Order227_Update, 3, 1)
				Timer_Start(g_227_timer, g_227_timeLimit)
			end
			-- Play a speech event to indicate Order 227 is active
			if Event_IsAnyRunning() == false then
				Util_StartIntel(Order227_StartSpeech)
			end
		end
	end
end

-----------------------------------------------------------------------------------
-- Order 227: Look for retreating player squads; have the commissar shoot them when they get close
-----------------------------------------------------------------------------------
function Order227_Update()
	if (Timer_GetElapsed(g_227_timer) >= g_227_timeLimit) then
		SGroup_DestroyAllSquads(sg_227_commissar)
		SGroup_Clear(sg_227_usedTargets)
		UIWarning_Show(11046804) -- LOCDB [11046804] 'Order 227 lifted! Commissar dismissed.'
		Player_SetResource(World_GetPlayerAt(1), RT_SovietOrder227, 0)
		g_227_spawnPositions = {}
		-- Play a speech event to indicate Order 227 is inactive
		if Event_IsAnyRunning() == false then
			Util_StartIntel(Order227_EndSpeech)
		end
		Rule_RemoveMe()
	else
		local playerSquads = Player_GetSquads(World_GetPlayerAt(1))
		g_227_timeBetweenShots = g_227_timeBetweenShots - 1
		g_227_timeBetweenAttackSpeech = g_227_timeBetweenAttackSpeech - 1
		local f = function (gid, idx, sid)
			if Squad_IsRetreating(sid) and (not Entity_IsVehicle(Squad_EntityAt(sid, 0)) or Squad_HasTeamWeapon(sid)) then
				SGroup_Add(sg_227_retreatingSquads, sid)
			end
		end
		SGroup_ForEach(playerSquads, f)
		
		if not SGroup_IsEmpty(sg_227_retreatingSquads) then
			local f = function (gid, idx, commissar)
				local spawnPos = g_227_spawnPositions[idx]
				local f2 = function (gid2, idx2, victim)
					-- Keep the Commissar near his spawn position
					if World_DistancePointToPoint(Util_GetPosition(commissar), spawnPos) > 20 then
						sg_227_commissarSingle = SGroup_CreateIfNotFound("sg_227_commissarSingle")
						SGroup_Clear(sg_227_commissarSingle)
						SGroup_Add(sg_227_commissarSingle, commissar)
						Cmd_Move(sg_227_commissarSingle, spawnPos)
					-- check to ensure the commissar is close to his target
					elseif Squad_CanSeeSquad(commissar, victim) and (World_DistancePointToPoint(Squad_GetPosition(commissar), Squad_GetPosition(victim)) <= 20) then
						sg_227_commissarSingle = SGroup_CreateIfNotFound("sg_227_commissarSingle")
						sg_227_commissarTarget = SGroup_CreateIfNotFound("sg_227_commissarTarget")
						local ability = BP_GetAbilityBlueprint("commissar_shot_227")
						SGroup_Clear(sg_227_commissarSingle)
						SGroup_Add(sg_227_commissarSingle, commissar)
						if not SGroup_IsDoingAbility(sg_227_commissarSingle, ability, ANY) then
							SGroup_Clear(sg_227_commissarTarget)
							SGroup_Add(sg_227_commissarTarget, victim)
							
							if g_227_timeBetweenShots <= 0 and (g_227_noMercy or (SGroup_ContainsSquad(sg_227_usedTargets, Squad_GetGameID(victim)) == false)) then
								Cmd_Ability(sg_227_commissarSingle, ability, sg_227_commissarTarget, nil, true, true)
								local speech = "speech/sp/mission/global/" .. g_227_attackSpeech[g_227_attackSpeechIndex]
								if g_227_timeBetweenAttackSpeech <= 0 then
									Sound_PlayOnSquad(speech, sg_227_commissarSingle)
									g_227_timeBetweenAttackSpeech = 10
									if g_227_attackSpeechIndex == 6 then
										g_227_attackSpeechIndex = 1
									else
										g_227_attackSpeechIndex = g_227_attackSpeechIndex + 1
									end
								end
								SGroup_Add(sg_227_usedTargets, victim)
								g_227_timeBetweenShots = Util_DifVar({12, 6, 3, 3})
								return true
							end
						end
					end
				end
				SGroup_ForEach(sg_227_retreatingSquads, f2)
			end
			SGroup_ForEach(sg_227_commissar, f)
		end
		-- Attack enemies if they're nearby
		if scartype(player227) == ST_PLAYER then
			local f = function (gid, idx, sid)
				sg_e_nearCommissar227 = SGroup_CreateIfNotFound("sg_e_nearCommissar227")
				Player_GetAllSquadsNearMarker(World_GetPlayerAt(2), sg_e_nearCommissar227, Squad_GetPosition(sid), 25)
				if SGroup_Count(sg_e_nearCommissar227) > 0 then
					sg_227_commissarSingle = SGroup_CreateIfNotFound("sg_227_commissarSingle")
					SGroup_Clear(sg_227_commissarSingle)
					SGroup_Add(sg_227_commissarSingle, sid)
					local ability = BP_GetAbilityBlueprint("commissar_shot_227_enemy")
					if not SGroup_IsDoingAbility(sg_227_commissarSingle, ability, ANY) and not SGroup_IsDoingAttack(sg_227_commissarSingle, ANY, 3) then
						Cmd_Ability(sg_227_commissarSingle, ability, sg_e_nearCommissar227, nil, true, true)
					end
				end
			end
			SGroup_ForEach(sg_227_commissar, f)
		end
		
		local timeLeft = math.floor(Timer_GetRemaining(g_227_timer))
		local showKicker = function (gid, idx, commissar) 
			local kicker = Loc_FormatText(11046805, Loc_ConvertNumber(timeLeft)) -- LOCDB [11046805] 'Commissar dismissed in %1TIME% seconds'
			UI_CreateEntityKickerMessage(World_GetPlayerAt(1), Squad_EntityAt(commissar, 0), kicker)
		end
		if not SGroup_IsEmpty(sg_227_commissar) and (math.mod(timeLeft, 5) == 0) and timeLeft ~= 0 then
			SGroup_ForEach(sg_227_commissar, showKicker)
		end
		g_227_resource = g_227_resource - (100 /(g_227_timeLimit - 3))
		Player_SetResource(World_GetPlayerAt(1), RT_SovietOrder227, g_227_resource)
	end
	
	
end


-----------------
-- Speech Events
-----------------

Order227_StartSpeech = function()
	local speech = g_227_startSpeech[g_227_speechIndex]
	CTRL.Event_Delay(3)
	CTRL.WAIT()
	g_227_tempSpeechPath = g_MissionSpeechPath
	g_MissionSpeechPath = "mission/global"
	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.None, speech)
	g_MissionSpeechPath = g_227_tempSpeechPath
	CTRL.WAIT()
	if g_227_speechIndex == 3 then
		g_227_speechIndex = 1
	else
		g_227_speechIndex = g_227_speechIndex + 1
	end
end

Order227_EndSpeech = function()
	local speech = g_227_endSpeech[g_227_speechIndex]
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	g_227_tempSpeechPath = g_MissionSpeechPath
	g_MissionSpeechPath = "mission/global"
	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.None, speech)
	g_MissionSpeechPath = g_227_tempSpeechPath
	CTRL.WAIT()
end

------------------------------------
-- Conscript Progression Speech
------------------------------------

function ConscriptProgression_AudioInit(penal, onlyPenal)
	if penal ~= false then
		penal = true
	end
	if onlyPenal ~= true then
		onlyPenal = false
	end
	g_conscriptProgression_unlockPenal = penal
	g_conscriptProgression_frontovikSpeech = {11049574, 11049575, 11049576, 11049577}
	g_conscriptProgression_penalSpeech = {11049578, 11049579, 11049580, 11049581}
	g_conscriptProgression_tempSpeechPath = "mission/global"
	if onlyPenal then
		Rule_AddInterval(ConscriptProgression_PenalUnlock, 1)
	else
		Rule_AddInterval(ConscriptProgression_FrontovikUnlock, 1)
	end
end

function ConscriptProgression_FrontovikUnlock()
	if Player_GetResource(World_GetPlayerAt(1), RT_SovietProgression) >= 50 then
		Util_StartIntel(ConscriptProgression_FrontovikSpeech)
		Rule_RemoveMe()
		if g_conscriptProgression_unlockPenal then
			Rule_AddInterval(ConscriptProgression_PenalUnlock, 1)
		end
	end
end

function ConscriptProgression_PenalUnlock()
	if Player_GetResource(World_GetPlayerAt(1), RT_SovietProgression) >= 100 then
		Util_StartIntel(ConscriptProgression_PenalSpeech)
		Rule_RemoveMe()
	end
end

ConscriptProgression_FrontovikSpeech = function()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	g_conscriptProgression_tempSpeechPath = g_MissionSpeechPath
	g_MissionSpeechPath = "mission/global"
	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.None, Table_GetRandomItem(g_conscriptProgression_frontovikSpeech))
	g_MissionSpeechPath = g_conscriptProgression_tempSpeechPath
	CTRL.WAIT()
end

ConscriptProgression_PenalSpeech = function()
	CTRL.Event_Delay(1)
	CTRL.WAIT()
	g_conscriptProgression_tempSpeechPath = g_MissionSpeechPath
	g_MissionSpeechPath = "mission/global"
	CTRL.Actor_PlaySpeechWithoutPortrait(ACTOR.None, Table_GetRandomItem(g_conscriptProgression_penalSpeech))
	g_MissionSpeechPath = g_conscriptProgression_tempSpeechPath
	CTRL.WAIT()
end