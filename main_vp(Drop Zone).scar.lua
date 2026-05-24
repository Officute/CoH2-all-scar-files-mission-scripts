-- Frans L Copyright (C) 2015
-- 		except: Function ToRomanNumerals(s) --> Copyright (C) 2012 LoDC
-- 		except: Function Util_CreateLocString(text) --> Copyright (C) 2010 Mannerheim

import("ScarUtil.scar")
import("Fatalities/Fatalities.scar")
import("WinConditions/victorypointplusannihilate.scar")
import("winconditions/Main.scar")

function OnInit()
	g_modeAnnihilation = false
	g_findingDropZoneBonusTime = 0
	g_abilityBonusTime = 0
	g_alarmBonusTime = 0
	g_dropZoneIntervalBonusTime = 0
	g_popCapBonus = 25
	g_aiBonusMExtra = 30
	g_introHeadBonus = ""
	OnGameSetupINI()
end

Scar_AddInit(OnInit)