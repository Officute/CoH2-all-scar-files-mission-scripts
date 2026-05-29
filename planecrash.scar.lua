--
-- "PlaneCrash"
--	
--  Prefab Script
--


--? @group scardoc;Prefabs


-- Initializer function should ALWAYS be named after the prefab name with _Init appended on the end
function planecrash_Init(data)	

	local instance = Prefab_GetInstance(data)
	
	instance.data = {}
	instance.data.hasTriggered = false
	
	if instance.trigger_enable == true then
		
		Event_Proximity(planecrash_Trigger, {instance = instance}, instance.trigger_player, instance.trigger_zone, Marker_GetProximityRadius(instance.trigger_zone), ANY, instance.delay)
		
	end
	
end



--? @args Table/String instance
--? @shortdesc Trigger the Plane Crash prefab... 
--? @extdesc The plane is spawned immediately, but it will take time to fly in and get to the crash location. 
function planecrash_Trigger(data)

	local instance = Prefab_GetInstance(data)
	
	if instance.once_only == false or instance.data.hasTriggered == false then
		
		instance.data.hasTriggered = true

		if Player_HasAbility(instance.plane_owner, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP) == false then --  (obviously you could have the ability swap so it's dependant on the plane_owner's faction)
			Player_AddAbility(instance.plane_owner, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP)
		end
		
		-- call in the plane
		Cmd_Ability(instance.plane_owner, ABILITY.SOVIET.IL_2_RECON_SINGLEPASS_SP,  instance.plane_location, Marker_GetDirection(instance.plane_location), true, false)
		
		-- poll for the plane to start existing
		Event_Timer(planecrash_FindPlane, {instance = instance}, 0.1)
	
	end
	
end



function planecrash_FindPlane(data)		-- wait until the plane is on the map, then throw it into an SGroup for tracking

	local instance = Prefab_GetInstance(data)
	
	local already_grabbed = SGroup_CreateIfNotFound("_sg_planecrash_alreadygrabbed")	-- this is global across all PlaneCrash instances
	
	Player_GetAll(instance.plane_owner)
	SGroup_Filter(sg_allsquads, SBP.SOVIET.IL_2_STURMOVIK_RECON_SQUAD_SP, FILTER_KEEP)
	SGroup_RemoveGroup(sg_allsquads, already_grabbed)
	
	if SGroup_Count(sg_allsquads) >= 1 then
		
		local this_plane = SGroup_Create("_sg_planecrash_plane")
		SGroup_AddGroup(this_plane, sg_allsquads)
		SGroup_AddGroup(already_grabbed, sg_allsquads)
		
		SGroup_SetInvulnerable(this_plane, true)
		
		Event_Proximity(planecrash_KillPlane, {plane = this_plane, instance = instance}, this_plane, instance.plane_location, 60, ANY, 0)
		
	else
		
		Event_Timer(planecrash_FindPlane, instance, 0.1)

	end

end



function planecrash_KillPlane(data)		-- when it gets close to the crash site, kill it (it should land roughly on the site)

	SGroup_Kill(data.plane)
	SGroup_Destroy(data.plane)

end