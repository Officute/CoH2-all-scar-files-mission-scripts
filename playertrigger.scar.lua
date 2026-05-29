--
-- "PlayerTrigger"
--	
--  Prefab Script
--


--? @group scardoc;Prefabs


-- Initializer function should ALWAYS be named after the prefab name with _Init appended on the end
function playertrigger_Init(data)	

	local instance = Prefab_GetInstance(data)
	
	-- set up instance's data
	instance.data = {}
	instance.data.hasTriggered = false
	
	-- register the trigger zone if there was one
	PrefabHelper_StandardTriggerSystem(instance)
	
end



--? @args Table/String instance
--? @shortdesc Start triggering the items listed in the PlayerTrigger prefab
--? @extdesc This prefab can only be triggered once, either by the trigger zone or by script, whichever is first
function playertrigger_Trigger(data)

	local instance = Prefab_GetInstance(data)
	
	if instance.once_only == false or instance.data.hasTriggered == false then
		
		instance.data.hasTriggered = true
		
		for index, item in pairs(instance.things_to_trigger) do
		
			if item.trigger_type == "Scar Function" then
				
				local event_data = {
					instance = instance,
					trigger_target = item.trigger_target,
				}
				Event_Timer(playertrigger_TriggerScarFunction, event_data, item.delay)
				
			elseif item.trigger_type == "Prefab" then

				local event_data = {
					instance = instance,
					trigger_target = item.trigger_target,
				}
				Event_Timer(playertrigger_TriggerPrefab, event_data, item.delay)
				
			end
		
		end
		
	end	
end








function playertrigger_TriggerScarFunction(data)

	local instance = Prefab_GetInstance(data)
	
	local func = _G[data.trigger_target]
	
	if scartype(func) == ST_FUNCTION then
		func(instance)
	end

end


function playertrigger_TriggerPrefab(data)

	Prefab_DoAction(data.trigger_target, "Trigger")

end