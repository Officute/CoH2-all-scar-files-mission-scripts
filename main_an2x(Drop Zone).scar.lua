-- Frans L Copyright (C) 2015
-- 		except: Function ToRomanNumerals(s) --> Copyright (C) 2012 LoDC
-- 		except: Function Util_CreateLocString(text) --> Copyright (C) 2010 Mannerheim

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("WinConditions/victorypointplusannihilate.scar")
import("winconditions/Main.scar")

function OnInit()
	g_modeAnnihilation = true
	g_findingDropZoneBonusTime = - 25
	g_abilityBonusTime = - 25
	g_alarmBonusTime = - 15
	g_dropZoneIntervalBonusTime = - 1
	g_popCapBonus = 50
	g_aiBonusMExtra = 35
	g_introHeadBonus = " Extreme"
	OnGameSetupINI()
end

Scar_AddInit(OnInit)