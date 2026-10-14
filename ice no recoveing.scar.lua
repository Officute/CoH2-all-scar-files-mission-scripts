import("ScarUtil.scar");

ICE_HEAL_RATE        = 0.0;
ICE_ENFORCE_INTERVAL = 1.0;

function Frost_ApplyIceRate()
	if not pcall(World_SetIceHealingRate, ICE_HEAL_RATE) then
		print("[frost] World_SetIceHealingRate failed");
	end
end

function Frost_EnforceIce()
	Frost_ApplyIceRate();
end

function Frost_Setup()
	Frost_ApplyIceRate();
	if ICE_ENFORCE_INTERVAL > 0 then
		Rule_RemoveIfExist(Frost_EnforceIce);
		Rule_AddInterval(Frost_EnforceIce, ICE_ENFORCE_INTERVAL);
	end
end

Scar_AddInit(Frost_Setup);

function OnGameRestore()
	Frost_Setup();
	Game_DefaultGameRestore();
end