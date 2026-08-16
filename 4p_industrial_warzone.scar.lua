import("ScarUtil.scar")

function IndustrialWarZone_Init()
	EGroup_SetInvulnerable(eg_invulnerable, true)
end

Scar_AddInit(IndustrialWarZone_Init)