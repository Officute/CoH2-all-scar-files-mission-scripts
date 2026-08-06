-------------------------------------------------------------------------
-------------------------------------------------------------------------

import("ScarUtil.scar")
import("Systems/BlizzardMulitplayer.scar")

-------------------------------------------------------------------------
-- [[ ONINIT ]]
-------------------------------------------------------------------------

function OnInit()

local blizzarddata =
{
blizzard_interval_first = 300,
blizzard_interval_min = 300,
blizzard_interval_max = 1000,
blizzard_exit_min = 120,
blizzard_exit_max = 200,
}
MP_BlizzardInit("data:<Any atmoshere file name>.aps", nil, blizzarddata, true)

end
Scar_AddInit(OnInit)