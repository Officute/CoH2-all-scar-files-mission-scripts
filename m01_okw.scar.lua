import("scarutil.scar");
import("m01_utilities.scar");
import("m01_american.scar");
import("m01_main.scar");
import("m01_reinforcements.scar");

function OnGameSetup()
	player1 = World_GetPlayerAt(1);
	player2 = World_GetPlayerAt(2);
	player3 = World_GetPlayerAt(3);
	player4 = World_GetPlayerAt(4);
	player5 = World_GetPlayerAt(5);
end

function OnInit()

	AI_EnableAll(false);

	Mission_Difficulty();
	Mission_Restrictions();
	Mission_Objectives();
	Mission_Reinforcements();
	
	Rule_AddOneShot(Mission_BeginIntel, 1);
	
	if (Util_IsCoop() == false) then
		Setup_SetPlayerName(player1, "$08a0ac9c7e6144909909a02d533ce8aa:209");
		Setup_SetPlayerName(player2, "$08a0ac9c7e6144909909a02d533ce8aa:210");
		Setup_SetPlayerName(player3, "$08a0ac9c7e6144909909a02d533ce8aa:210");
		Setup_SetPlayerName(player4, "$08a0ac9c7e6144909909a02d533ce8aa:211");
		Setup_SetPlayerName(player5, "$08a0ac9c7e6144909909a02d533ce8aa:212");
	end
	
end

Scar_AddInit(OnInit);
