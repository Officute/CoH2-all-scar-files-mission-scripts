-- Local development: Load code from the file system instead of SGA
if false then
	loadfile("E:/dev/coh2/mods/4p_dockyard_warzone/scenarios/mp/4p_dockyard_warzone/4p_dockyard_warzone_main.scar")()
else
	import("4p_dockyard_warzone_main.scar")
end
