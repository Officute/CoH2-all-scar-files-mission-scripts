
function Mission_InitObjectives()
	OBJ_Main = {
		--Intel_Start = EVENTS.IntroSpeechLine01,
		Title = Util_CreateLocString("Survive " .. g_lastWave .. " waves of enemy attacks"),
		TitleEnd = Util_CreateLocString("Enemy waves defeated"), 
		Type = OT_Primary, 
		OnStart = function() 
			Objective_SetCounter(OBJ_Main, 1, g_lastWave)
			
			Subtitle_PlaySpeech(ICONS.INTRO_SPEECH_OFFICER, LOCSTRINGS.INTRO_OFFICER_NAME, LOCSTRINGS.INTRO_MOTIVATION, false, false, false, false, SOUNDS.INTRO_MOTIVATION)
			Sound_Play2D(SOUNDS.INTRO_MOTIVATION)
		end,
		OnComplete = function()  
			
		end,
		OnFail = nil, 
	}   
		
	Objective_Register(OBJ_Main)
	
	OBJ_Respawn = {
		Title = Util_CreateLocString("A new Sturmtiger will arrive in " .. g_sturmtigerRespawnTime .. " seconds."),

		Type = OT_Secondary, 
		OnStart = function() 

		end,
		OnComplete = function()  
			
		end,
		OnFail = nil, 
	}   	
	
	OBJ_MunitionEvent = {
		Title = Util_CreateLocString("Time until munition delivery arrives"),
		Title1 = Util_CreateLocString("Time until munition delivery arrives"),
		Title2 = Util_CreateLocString("Munition shipment has arrived"),
		Type = OT_Secondary, 
		OnStart = function() 

		end,
		OnComplete = function()  
			
		end,
		OnFail = nil, 
	}   
		
	Objective_Register(OBJ_Main)
	Objective_Register(OBJ_Respawn)
	Objective_Register(OBJ_MunitionEvent)
end