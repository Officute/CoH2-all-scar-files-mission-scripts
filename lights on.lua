function OnInit()

	EGroup_SetAnimatorState(eg_lamps, "Light_State", "On")

	EGroup_SetAnimatorState(eg_lamps, "Light", "On")


end


Scar_AddInit(OnInit)