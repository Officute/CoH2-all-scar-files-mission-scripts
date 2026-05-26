DEV_MODE = false
FORCE_MESSAGES_ENABLED = true

-- All paths should end in /
LIBRARY_ABSOLUTE_ROOT = "E:/dev/coh2/mods/2p_faust_bug/scenarios/mp/2p_faust_bug/janne252/data/scar/"
LIBRARY_RELATIVE_ROOT = "janne252/data/scar/"
MOD_ABSOLUTE_ROOT = "E:/dev/coh2/mods/2p_faust_bug/scenarios/mp/2p_faust_bug/"
MOD_RELATIVE_ROOT = "" -- Relative to this file

import(LIBRARY_RELATIVE_ROOT .. "core.scar")

function FaustBug_PreInit()
    Core_Init()

    Mod_Register("FaustBug", "11b69bfef15a4bd9988a4492c005aad3")

    Import({
        files = {
            "main.scar",
        },
        
        relativeRoot = MOD_RELATIVE_ROOT,
        absoluteRoot = MOD_ABSOLUTE_ROOT,
    })

    FaustBug_Init()
end

Scar_AddInit(FaustBug_PreInit)
