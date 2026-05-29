-----------------------------------------------------------------------
-- VPTicker Win Condition
--
-- (c) Relic Entertainment 2006
--
-- Programmers: Shelby Hubick, Kris Botha, Randy Lukashuk
-----------------------------------------------------------------------

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("Prototype/WorldEntityCollector.scar")
import("Prototype/AABattle_VPTickerWin-Annihilate_Functions.scar")
import("Prototype/SpecialAEFunctions.scar")
import("PrintOnScreen.scar")
import("WinConditions/AABattle_Annihilate.scar")


SetGlobals()

-----------------------------------------------------------------------
-- Register the OnInit function w/ the SCAR system
-----------------------------------------------------------------------
Scar_AddInit( VPTicker_OnInit )