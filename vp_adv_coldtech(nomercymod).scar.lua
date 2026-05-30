--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%% BY: DREDNOUT_571 %%%%%%%%%%%%%%%%%%%%%%
--%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/VPTickerWin-Annihilate_Functions.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")
import("WinConditions/Annihilate.scar")
import("Systems/BlizzardMulitplayer.scar")
import("WinConditions/_forcewin.scar")
import("WinConditions/_coldnight.scar")
import("WinConditions/_camera.scar")
import("WinConditions/_advcoldtech.scar")

SetGlobals()

Scar_AddInit( VPTicker_OnInit )

function OnInit()
	for i = 1, World_GetPlayerCount() do
		local player = World_GetPlayerAt(i)
		Player_SetPopCapOverride(player, 100) --no use
	end
end

Scar_AddInit( OnInit )
