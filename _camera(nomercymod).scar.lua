function OnInit()
	World_SetIceHealingRate( 1 ) --регенерация льда в секунду 0.05 - 5%
	Camera_SetTuningValue(TV_DistMax, 80) --55
	--Camera_SetTuningValue(TV_DefaultHeight, 54)
	--Camera_SetTuningValue(TV_DefaultDeclination, 48)
	Camera_ResetToDefault()
end

Scar_AddInit( OnInit )