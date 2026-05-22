import("scarutil.scar");
import("m01_ost_mission.scar");
import("m01_ost_soviet.scar");
import("m01_ost_time.scar");
import("m01_ost_reinforcements_coop.scar");
import("m01_ost_german.scar");

g_last_man = "LastSoldier";
g_line_fail = "LineFail";

DEMAND_HIGH = 75;
DEMAND_MEDIUM = 50;
DEMAND_LOW = 25;

DEMAND_NONE = 0;
DEMAND_FORCE = 150;

function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
end

function OnInit()

	AI_EnableAll(false);

	Mission_Difficulty();
	Mission_Restrictions();
	Mission_Objectives();
	Mission_Reinforcements();
	Mission_SpawnPakGuns();
	
	Berlin_InitializeTime();
	German_Initialize();
	Soviet_Initialize();
	
	Rule_AddOneShot(Mission_BeginIntel, 1);
	
	sg_brokenthrough = SGroup_CreateIfNotFound("sg_brokenthrough");
	
	Player_SetDefaultSquadMoodMode(player1, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player2, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player3, MM_ForceTense);
	Player_SetDefaultSquadMoodMode(player4, MM_ForceTense);
	
	FOW_PlayerRevealArea(player1, Marker_GetPosition(mkr_nomansland01), 50, -1);
	FOW_PlayerRevealArea(player1, Marker_GetPosition(mkr_nomansland02), 50, -1);
	FOW_PlayerRevealArea(player1, Marker_GetPosition(mkr_nomansland03), 50, -1);
	
	FOW_PlayerRevealArea(player2, Marker_GetPosition(mkr_nomansland01), 50, -1);
	FOW_PlayerRevealArea(player2, Marker_GetPosition(mkr_nomansland02), 50, -1);
	FOW_PlayerRevealArea(player2, Marker_GetPosition(mkr_nomansland03), 50, -1);
	
	Modify_WeaponRange(Player_GetSquads(player1), "hardpoint_01", 1.5);
	Modify_WeaponRange(Player_GetSquads(player2), "hardpoint_01", 1.5);	
	
	if (Util_IsCoop() == true) then
		--Util_MissionTitle(Util_CreateLocString("Game is coop"), 5.0, 5.0, 5.0);  -- REMOVE !!!
	end
	
end

Scar_AddInit(OnInit);