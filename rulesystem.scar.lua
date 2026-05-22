----------------------------------------------------------------------------------------------------------------
-- Rule System helper functions
-- (c) 2003 Relic Entertainment Inc.

--? @group scardoc;RuleSystem

----------------------------------------------------------------------------------------------------------------
-- Scar rule system functions

function __ClampRulePriority(priority)

	if priority == nil then
		priority = 0
	end
	
	if priority < 0 then
		print("Adding rule with priority less than 0. Clamping to 0. Rule priorities have to be from 0 to 1000.")
		priority = 0
	elseif priority > 1000 then
		print("Adding rule with priority greater than 1000. Clamping to 1000. Rule priorities have to be from 0 to 1000.")
		priority = 1000
	end
	
	return priority
	
end

--? @shortdesc Add a rule to be executed every frame. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @result Void
--? @args LuaFunction rule[, Integer priority]
function Rule_Add( f, priority )
	priority = __ClampRulePriority(priority)
	TimeRule_Add( f, priority )
end

--? @shortdesc Add a rule to be executed 'calls' times, at every 'interval' seconds. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @result Void
--? @args LuaFunction rule, Real interval, Integer calls[, Integer priority]
function Rule_AddIntervalEx( f, interval, calls, priority )
	priority = __ClampRulePriority(priority)
	TimeRule_AddIntervalEx( f, 0, interval, calls, priority )
end

--? @shortdesc Add a rule to be executed at every 'interval' seconds. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @result Void
--? @args LuaFunction rule, Real interval[, Integer priority]
function Rule_AddInterval( f, interval, priority )
	priority = __ClampRulePriority(priority)
	TimeRule_AddInterval( f, interval, priority )
end

--? @shortdesc Add a rule to be executed at every 'interval' seconds, after an initial delay. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @args LuaFunction rule, Real delay, Real interval[, Integer priority]
function Rule_AddDelayedInterval( f, delay, interval, priority )
	Rule_AddDelayedIntervalEx( f, delay, interval, -1, priority )
end

--? @shortdesc Add a rule to be executed 'calls' times, at every 'interval' seconds, after an initial delay. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @args LuaFunction rule, Real delay, Real interval, Integer calls[, Integer priority, Integer calls]
function Rule_AddDelayedIntervalEx( f, delay, interval, calls, priority )
	priority = __ClampRulePriority(priority)
	TimeRule_AddIntervalEx( f, delay, interval, calls, priority )
end

--? @shortdesc Add a rule to be executed once, after 'delay' seconds. Priority can be from 0 to 1000, with 0 being the lowest. Priority is used in conjunction with Rule_RemoveAll so that rules with high priority do not get removed.
--? @result Void
--? @args LuaFunction rule, Real delay[, Integer priority]
function Rule_AddOneShot( f, delay, priority )
	priority = __ClampRulePriority(priority)
	TimeRule_AddOneShot( f, delay, priority )
end

--? @shortdesc Change 'interval' seconds of an existing rule
--? @result Void
--? @args LuaFunction rule, Real interval
function Rule_ChangeInterval( f, interval )
	TimeRule_ChangeInterval( f, interval )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened on the 'squad'
--? @extdesc Event types are: GE_SquadKilled, GE_SquadPinned, GE_SquadParadropComplete, GE_SquadCommandIssued, GE_AbilityExecuted, GE_SpawnActionComplete
--? @result Void
--? @args LuaFunction rule, SquadID squad, Integer eventtype
function Rule_AddSquadEvent( f, squad, eventType )
	EventRule_AddSquadEvent( f, squad, eventType )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened on squads in the 'sgroup'
--? @extdesc Event types are: GE_SquadKilled, GE_SquadPinned, GE_SquadParadropComplete, GE_SquadCommandIssued, GE_AbilityExecuted, GE_SpawnActionComplete
--? @result Void
--? @args LuaFunction rule, SGroupID sgroup, Integer eventtype
function Rule_AddSGroupEvent( f, sgroup, eventType )
	local _AddToSquad = function ( gid, idx, sid )
		Rule_AddSquadEvent( f, sid, eventType )
	end
	SGroup_ForEach( sgroup, _AddToSquad )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened on the 'entity'
--? @extdesc Event types are: GE_EntityKilled, GE_EntityParadropComplete, GE_EntityCommandIssued, GE_ProjectileFired, GE_AbilityExecuted, GE_SpawnActionComplete
--? @result Void
--? @args LuaFunction rule, EntityID entity, Integer eventtype
function Rule_AddEntityEvent( f, entity, eventType )
	EventRule_AddEntityEvent( f, entity, eventType )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened on entities in the 'egroup'
--? @extdesc Event types are: GE_EntityKilled, GE_EntityParadropComplete, GE_EntityCommandIssued, GE_ProjectileFired, GE_AbilityExecuted, GE_SpawnActionComplete
--? @result Void
--? @args LuaFunction rule, EGroupID egroup, Integer eventtype
function Rule_AddEGroupEvent( f, egroup, eventType )
	local _AddToEntity = function ( gid, idx, eid )
		Rule_AddEntityEvent( f, eid, eventType )
	end
	EGroup_ForEach( egroup, _AddToEntity )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened on the 'player'
--? @extdesc Event types are: GE_PlayerBeingAttacked, GE_PlayerCommandIssued, GE_AbilityExecuted, GE_UpgradeComplete, GE_ConstructionComplete, GE_BuildItemComplete, GE_PlayerKilled, GE_SpawnActionComplete, GE_AIPlayer_ObjectiveNotification
--? @result Void
--? @args LuaFunction rule, PlayerID player, Integer eventtype
function Rule_AddPlayerEvent( f, player, eventType )
	EventRule_AddPlayerEvent( f, player, eventType )
end

--? @shortdesc Add a rule to be executed when the event of 'eventType' has happened, regardless of source
--? @extdesc Event types are: GE_PlayerBeingAttacked
--? @result Void
--? @args LuaFunction rule, Integer eventtype
function Rule_AddGlobalEvent( f, eventType )
	EventRule_AddEvent( f, eventType )
end

--? @shortdesc Remove an active event rule for the 'squad'
--? @result Void
--? @args LuaFunction rule, SquadID squad
function Rule_RemoveSquadEvent( f, squad )
	EventRule_RemoveSquadEvent( f, squad )
end

--? @shortdesc Remove an active event rule for squads in the 'sgroup'
--? @result Void
--? @args LuaFunction rule, SGroupID sgroup
function Rule_RemoveSGroupEvent( f, sgroup )
	local _RemoveFromSquad = function ( gid, idx, sid )
		Rule_RemoveSquadEvent( f, sid )
	end
	SGroup_ForEach( sgroup, _RemoveFromSquad )
end

--? @shortdesc Remove an active event rule for the 'entity'
--? @result Void
--? @args LuaFunction rule, EntityID entity
function Rule_RemoveEntityEvent( f, entity )
	EventRule_RemoveEntityEvent( f, entity )
end

--? @shortdesc Remove an active event rule for entities in the 'egroup'
--? @result Void
--? @args LuaFunction rule, EGroupID egroup
function Rule_RemoveEGroupEvent( f, egroup )
	local _RemoveFromEntity = function ( gid, idx, eid )
		Rule_RemoveEntityEvent( f, eid )
	end
	EGroup_ForEach( egroup, _RemoveFromEntity )
end

--? @shortdesc Remove an active event rule for the 'player'
--? @result Void
--? @args LuaFunction rule, PlayerID player
function Rule_RemovePlayerEvent( f, player )
	EventRule_RemovePlayerEvent( f, player )
end

--? @shortdesc Remove an active event rule that's been applied 'globally'
--? @result Void
--? @args LuaFunction rule
function Rule_RemoveGlobalEvent( f )
	EventRule_RemoveEvent( f )
end

--? @shortdesc Remove a currently executing rule (only works inside a rule function)
--? @result Void
--? @args Void
function Rule_RemoveMe()
	-- Try RemoveMe in both time rule system and event rule system.
	-- There should only be one rule executing at any given time.
	TimeRule_RemoveMe()
	EventRule_RemoveMe()
end

--? @shortdesc Remove a currently active rule (this does not remove any event rules)
--? @result Void
--? @args LuaFunction rule
function Rule_Remove( f )
	-- Event rule removal would require additional input.
	-- Therefore, this is only for time rules
	TimeRule_Remove( f )
end

--? @shortdesc Remove a currently active rule if it exists(this does not remove any event rules)
--? @result Void
--? @args LuaFunction rule
function Rule_RemoveIfExist( f )
	-- Event rule removal would require additional input.
	-- Therefore, this is only for time rules
	if Rule_Exists( f ) then
		TimeRule_Remove( f )
	end
end

--? @shortdesc Kills all rules below a certain priority. The default is to remove ALL rules.
--? @result Void
--? @args [Integer max_priority]
function Rule_RemoveAll(max_priority)
	if max_priority == nil then max_priority = 1000 end
	-- Kill both time rules and event rules
	TimeRule_RemoveAll(max_priority)
	EventRule_RemoveAll()
end

--? @shortdesc Test if a rule is currently active
--? @result Boolean
--? @args LuaFunction rule
function Rule_Exists( f )
	-- Check if the rules exists as time rules; if not check for event rules
	if ( TimeRule_Exists( f ) == true ) then
		return true;
	end
	
	return EventRule_Exists( f )

end
