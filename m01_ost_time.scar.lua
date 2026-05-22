g_time = {};

TIME_DAY = false;
TIME_NIGHT = true;

function Berlin_InitializeTime()

	g_time.duration = 8 * 60;
	g_time.conversion = 3 * 60;

	g_time.day = "data:art/scenarios/presets/atmosphere/_m06_stalingrad_injury.aps";
	g_time.night = "data:art/scenarios/presets/atmosphere/_tow_brody_night.aps";
	g_time.night_rain = "data:art/scenarios/presets/atmosphere/_tow_brody_night.aps";
	
	g_time.current = TIME_NIGHT;
	g_time.currentday = 0;
	
	Berlin_Lights(true);
	
end

function Berlin_TimeBegin()

	Rule_AddInterval(Berlin_TimeUpdate, g_time.duration);

end

function Berlin_ApplyModifiers(time)
	
	if (time == TIME_NIGHT) then
		
		Production_Enable();
		
	elseif (time == TIME_DAY) then
		
		Production_Disable();
		
	end
	
end

function Berlin_TimeUpdate()

	if (g_time.current == TIME_NIGHT) then
		
		g_time.current = TIME_DAY;
		Game_LoadAtmosphere(g_time.day, g_time.conversion);
		Berlin_ApplyModifiers(g_time.current);
		Berlin_RandomIntel(g_time.current);
		Berlin_Lights(false);
		
	else
		
		local rain = World_GetRand(1, 5);
		g_time.current = TIME_NIGHT;
		if (rain >= 4) then
			Game_LoadAtmosphere(g_time.night_rain, g_time.conversion);
		else
			Game_LoadAtmosphere(g_time.night, g_time.conversion);
		end
		
		Berlin_ApplyModifiers(g_time.current);
		Berlin_RandomIntel(g_time.current);
		Berlin_Lights(true);
		
		g_time.currentday = g_time.currentday + 1;
		
		Player_AddResource(german1, RT_Manpower, t_difficulty.resourceaward);
		Player_AddResource(german2, RT_Manpower, t_difficulty.resourceaward);
		
	end

	if (S_Center_Enabled == true) then
		if (S_North_Enabled == false) then
			S_North_Enabled = true;
		else
			S_South_Enabled = true;
			if (Objective_IsStarted(OBJ_TRAIN) == false) then
				--Mission_DoTrainStation();
			end
		end
	end
	
end

function Berlin_RandomIntel(time)

	if (time == TIME_NIGHT) then
		local rand = World_GetRand(1, 4);
		if (rand == 1) then
			Util_StartIntel(EVENTS.NIGHT);
		elseif (rand == 2) then
			Util_StartIntel(EVENTS.NIGHT2);
		elseif (rand == 3) then
			Util_StartIntel(EVENTS.NIGHT3);
		elseif (rand == 4) then
			Util_StartIntel(EVENTS.NIGHT4);
		end
	else
		local rand = World_GetRand(1, 4);
		if (rand == 1) then
			Util_StartIntel(EVENTS.DAY);
		elseif (rand == 2) then
			Util_StartIntel(EVENTS.DAY2);
		elseif (rand == 3) then
			Util_StartIntel(EVENTS.DAY3);
		elseif (rand == 4) then
			Util_StartIntel(EVENTS.DAY4);
		end
	end
	
end

function Berlin_Lights(enable)
	if (enable) then
		for i=1, EGroup_Count(eg_lights) do
			Entity_SetAnimatorState(EGroup_GetSpawnedEntityAt(eg_lights, i), "light", "On");
		end
	else
		for i=1, EGroup_Count(eg_lights) do
			Entity_SetAnimatorState(EGroup_GetSpawnedEntityAt(eg_lights, i), "light", "Off");
		end
	end
end
