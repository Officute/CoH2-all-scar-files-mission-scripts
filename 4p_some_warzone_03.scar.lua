function MedievalWarzone_OnInit()
	local ebp = BP_GetEntityBlueprint("castle_m_brick")
	for i = 0, World_GetNumEntities() -1 do
		local entity = World_GetEntity(i)
		if Entity_GetBlueprint(entity) == ebp then
			Entity_SetInvulnerable(entity, true, 0)
		end
	end
	
	EGroup_SetInvulnerable(eg_invulnerable, true)
end

Scar_AddInit(MedievalWarzone_OnInit)

